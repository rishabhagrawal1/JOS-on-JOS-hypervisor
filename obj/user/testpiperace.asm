
obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 44 03 00 00       	callq  800385 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 40 42 80 00 00 	movabs $0x804240,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 7a 38 80 00 00 	movabs $0x80387a,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 59 42 80 00 00 	movabs $0x804259,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 62 42 80 00 00 	movabs $0x804262,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 7f 23 80 00 00 	movabs $0x80237f,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 76 42 80 00 00 	movabs $0x804276,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf 62 42 80 00 00 	movabs $0x804262,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 7f 42 80 00 00 	movabs $0x80427f,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 28 26 80 00 00 	movabs $0x802628,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 9a 42 80 00 00 	movabs $0x80429a,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 98                	cltq   
  8001d0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001de:	00 00 00 
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f3:	00 00 00 
  8001f6:	48 29 c2             	sub    %rax,%rdx
  8001f9:	48 89 d0             	mov    %rdx,%rax
  8001fc:	48 c1 f8 03          	sar    $0x3,%rax
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	48 b8 a5 4f fa a4 4f 	movabs $0x4fa4fa4fa4fa4fa5,%rax
  80020a:	fa a4 4f 
  80020d:	48 0f af c2          	imul   %rdx,%rax
  800211:	48 89 c6             	mov    %rax,%rsi
  800214:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 8f 2b 80 00 00 	movabs $0x802b8f,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 8f 2b 80 00 00 	movabs $0x802b8f,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80025d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800261:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800267:	83 f8 02             	cmp    $0x2,%eax
  80026a:	74 db                	je     800247 <umain+0x204>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80026c:	48 bf b0 42 80 00 00 	movabs $0x8042b0,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002ab:	48 bf 62 42 80 00 00 	movabs $0x804262,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8002c1:	00 00 00 
  8002c4:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002cd:	48 89 d6             	mov    %rdx,%rsi
  8002d0:	89 c7                	mov    %eax,%edi
  8002d2:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba f2 42 80 00 00 	movabs $0x8042f2,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002fb:	48 bf 62 42 80 00 00 	movabs $0x804262,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 f1 37 80 00 00 	movabs $0x8037f1,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx
  800361:	eb 20                	jmp    800383 <umain+0x340>
	else
		cprintf("\nrace didn't happen\n", max);
  800363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 20 43 80 00 00 	movabs $0x804320,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
}
  800383:	c9                   	leaveq 
  800384:	c3                   	retq   

0000000000800385 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %rbp
  800386:	48 89 e5             	mov    %rsp,%rbp
  800389:	48 83 ec 10          	sub    $0x10,%rsp
  80038d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800394:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
  8003a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a5:	48 98                	cltq   
  8003a7:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8003ae:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b5:	00 00 00 
  8003b8:	48 01 c2             	add    %rax,%rdx
  8003bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003c2:	00 00 00 
  8003c5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cc:	7e 14                	jle    8003e2 <libmain+0x5d>
		binaryname = argv[0];
  8003ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d2:	48 8b 10             	mov    (%rax),%rdx
  8003d5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003dc:	00 00 00 
  8003df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e9:	48 89 d6             	mov    %rdx,%rsi
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003fa:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80040c:	48 b8 61 2b 80 00 00 	movabs $0x802b61,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800418:	bf 00 00 00 00       	mov    $0x0,%edi
  80041d:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax

}
  800429:	5d                   	pop    %rbp
  80042a:	c3                   	retq   

000000000080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	53                   	push   %rbx
  800430:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800437:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800444:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800452:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800459:	84 c0                	test   %al,%al
  80045b:	74 23                	je     800480 <_panic+0x55>
  80045d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800464:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800468:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800470:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800474:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800478:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800480:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800487:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048e:	00 00 00 
  800491:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800498:	00 00 00 
  80049b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 18             	mov    (%rax),%rbx
  8004c1:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
  8004cd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004da:	41 89 c8             	mov    %ecx,%r8d
  8004dd:	48 89 d1             	mov    %rdx,%rcx
  8004e0:	48 89 da             	mov    %rbx,%rdx
  8004e3:	89 c6                	mov    %eax,%esi
  8004e5:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	49 b9 64 06 80 00 00 	movabs $0x800664,%r9
  8004fb:	00 00 00 
  8004fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800501:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800508:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050f:	48 89 d6             	mov    %rdx,%rsi
  800512:	48 89 c7             	mov    %rax,%rdi
  800515:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
	cprintf("\n");
  800521:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  800528:	00 00 00 
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800537:	00 00 00 
  80053a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053c:	cc                   	int3   
  80053d:	eb fd                	jmp    80053c <_panic+0x111>

000000000080053f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	8b 00                	mov    (%rax),%eax
  800554:	8d 48 01             	lea    0x1(%rax),%ecx
  800557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800560:	89 d1                	mov    %edx,%ecx
  800562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800566:	48 98                	cltq   
  800568:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	48 98                	cltq   
  800581:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800585:	48 83 c2 08          	add    $0x8,%rdx
  800589:	48 89 c6             	mov    %rax,%rsi
  80058c:	48 89 d7             	mov    %rdx,%rdi
  80058f:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
        b->idx = 0;
  80059b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a9:	8b 40 04             	mov    0x4(%rax),%eax
  8005ac:	8d 50 01             	lea    0x1(%rax),%edx
  8005af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b6:	c9                   	leaveq 
  8005b7:	c3                   	retq   

00000000008005b8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005df:	48 8b 0a             	mov    (%rdx),%rcx
  8005e2:	48 89 08             	mov    %rcx,(%rax)
  8005e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fc:	00 00 00 
    b.cnt = 0;
  8005ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800606:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800609:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800610:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800617:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061e:	48 89 c6             	mov    %rax,%rsi
  800621:	48 bf 3f 05 80 00 00 	movabs $0x80053f,%rdi
  800628:	00 00 00 
  80062b:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800637:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063d:	48 98                	cltq   
  80063f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800646:	48 83 c2 08          	add    $0x8,%rdx
  80064a:	48 89 c6             	mov    %rax,%rsi
  80064d:	48 89 d7             	mov    %rdx,%rdi
  800650:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  800657:	00 00 00 
  80065a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80065c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800676:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800684:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800692:	84 c0                	test   %al,%al
  800694:	74 20                	je     8006b6 <cprintf+0x52>
  800696:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80069a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c4:	00 00 00 
  8006c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ce:	00 00 00 
  8006d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f8:	48 8b 0a             	mov    (%rdx),%rcx
  8006fb:	48 89 08             	mov    %rcx,(%rax)
  8006fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800702:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800706:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80070e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800715:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071c:	48 89 d6             	mov    %rdx,%rsi
  80071f:	48 89 c7             	mov    %rax,%rdi
  800722:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800734:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80073a:	c9                   	leaveq 
  80073b:	c3                   	retq   

000000000080073c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073c:	55                   	push   %rbp
  80073d:	48 89 e5             	mov    %rsp,%rbp
  800740:	53                   	push   %rbx
  800741:	48 83 ec 38          	sub    $0x38,%rsp
  800745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800749:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800751:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800754:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800758:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800763:	77 3b                	ja     8007a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800765:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800768:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f3             	div    %rbx
  80077b:	48 89 c2             	mov    %rax,%rdx
  80077e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	41 89 f9             	mov    %edi,%r9d
  80078f:	48 89 c7             	mov    %rax,%rdi
  800792:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800799:	00 00 00 
  80079c:	ff d0                	callq  *%rax
  80079e:	eb 1e                	jmp    8007be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a0:	eb 12                	jmp    8007b4 <printnum+0x78>
			putch(padc, putdat);
  8007a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 89 ce             	mov    %rcx,%rsi
  8007b0:	89 d7                	mov    %edx,%edi
  8007b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bc:	7f e4                	jg     8007a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	48 f7 f1             	div    %rcx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 ba 70 45 80 00 00 	movabs $0x804570,%rdx
  8007d7:	00 00 00 
  8007da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007de:	0f be d0             	movsbl %al,%edx
  8007e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 89 ce             	mov    %rcx,%rsi
  8007ec:	89 d7                	mov    %edx,%edi
  8007ee:	ff d0                	callq  *%rax
}
  8007f0:	48 83 c4 38          	add    $0x38,%rsp
  8007f4:	5b                   	pop    %rbx
  8007f5:	5d                   	pop    %rbp
  8007f6:	c3                   	retq   

00000000008007f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f7:	55                   	push   %rbp
  8007f8:	48 89 e5             	mov    %rsp,%rbp
  8007fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800803:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800806:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080a:	7e 52                	jle    80085e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getuint+0x44>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getuint+0x5b>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	48 8b 00             	mov    (%rax),%rax
  800855:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800859:	e9 a3 00 00 00       	jmpq   800901 <getuint+0x10a>
	else if (lflag)
  80085e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800862:	74 4f                	je     8008b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	83 f8 30             	cmp    $0x30,%eax
  80086d:	73 24                	jae    800893 <getuint+0x9c>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	89 c0                	mov    %eax,%eax
  80087f:	48 01 d0             	add    %rdx,%rax
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	8b 12                	mov    (%rdx),%edx
  800888:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	89 0a                	mov    %ecx,(%rdx)
  800891:	eb 17                	jmp    8008aa <getuint+0xb3>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089b:	48 89 d0             	mov    %rdx,%rax
  80089e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008aa:	48 8b 00             	mov    (%rax),%rax
  8008ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b1:	eb 4e                	jmp    800901 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	83 f8 30             	cmp    $0x30,%eax
  8008bc:	73 24                	jae    8008e2 <getuint+0xeb>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	8b 00                	mov    (%rax),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	8b 12                	mov    (%rdx),%edx
  8008d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008de:	89 0a                	mov    %ecx,(%rdx)
  8008e0:	eb 17                	jmp    8008f9 <getuint+0x102>
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ea:	48 89 d0             	mov    %rdx,%rax
  8008ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	89 c0                	mov    %eax,%eax
  8008fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800905:	c9                   	leaveq 
  800906:	c3                   	retq   

0000000000800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %rbp
  800908:	48 89 e5             	mov    %rsp,%rbp
  80090b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800913:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800916:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091a:	7e 52                	jle    80096e <getint+0x67>
		x=va_arg(*ap, long long);
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	8b 00                	mov    (%rax),%eax
  800922:	83 f8 30             	cmp    $0x30,%eax
  800925:	73 24                	jae    80094b <getint+0x44>
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	8b 00                	mov    (%rax),%eax
  800935:	89 c0                	mov    %eax,%eax
  800937:	48 01 d0             	add    %rdx,%rax
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	8b 12                	mov    (%rdx),%edx
  800940:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800943:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800947:	89 0a                	mov    %ecx,(%rdx)
  800949:	eb 17                	jmp    800962 <getint+0x5b>
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800953:	48 89 d0             	mov    %rdx,%rax
  800956:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800962:	48 8b 00             	mov    (%rax),%rax
  800965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800969:	e9 a3 00 00 00       	jmpq   800a11 <getint+0x10a>
	else if (lflag)
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800972:	74 4f                	je     8009c3 <getint+0xbc>
		x=va_arg(*ap, long);
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 24                	jae    8009a3 <getint+0x9c>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	8b 12                	mov    (%rdx),%edx
  800998:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 0a                	mov    %ecx,(%rdx)
  8009a1:	eb 17                	jmp    8009ba <getint+0xb3>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ab:	48 89 d0             	mov    %rdx,%rax
  8009ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ba:	48 8b 00             	mov    (%rax),%rax
  8009bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c1:	eb 4e                	jmp    800a11 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	83 f8 30             	cmp    $0x30,%eax
  8009cc:	73 24                	jae    8009f2 <getint+0xeb>
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	8b 00                	mov    (%rax),%eax
  8009dc:	89 c0                	mov    %eax,%eax
  8009de:	48 01 d0             	add    %rdx,%rax
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	8b 12                	mov    (%rdx),%edx
  8009e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ee:	89 0a                	mov    %ecx,(%rdx)
  8009f0:	eb 17                	jmp    800a09 <getint+0x102>
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fa:	48 89 d0             	mov    %rdx,%rax
  8009fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a09:	8b 00                	mov    (%rax),%eax
  800a0b:	48 98                	cltq   
  800a0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a15:	c9                   	leaveq 
  800a16:	c3                   	retq   

0000000000800a17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a17:	55                   	push   %rbp
  800a18:	48 89 e5             	mov    %rsp,%rbp
  800a1b:	41 54                	push   %r12
  800a1d:	53                   	push   %rbx
  800a1e:	48 83 ec 60          	sub    $0x60,%rsp
  800a22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a3a:	48 8b 0a             	mov    (%rdx),%rcx
  800a3d:	48 89 08             	mov    %rcx,(%rax)
  800a40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a50:	eb 17                	jmp    800a69 <vprintfmt+0x52>
			if (ch == '\0')
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	0f 84 cc 04 00 00    	je     800f26 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	48 89 d6             	mov    %rdx,%rsi
  800a65:	89 df                	mov    %ebx,%edi
  800a67:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a75:	0f b6 00             	movzbl (%rax),%eax
  800a78:	0f b6 d8             	movzbl %al,%ebx
  800a7b:	83 fb 25             	cmp    $0x25,%ebx
  800a7e:	75 d2                	jne    800a52 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a80:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a84:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a99:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aac:	0f b6 00             	movzbl (%rax),%eax
  800aaf:	0f b6 d8             	movzbl %al,%ebx
  800ab2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ab5:	83 f8 55             	cmp    $0x55,%eax
  800ab8:	0f 87 34 04 00 00    	ja     800ef2 <vprintfmt+0x4db>
  800abe:	89 c0                	mov    %eax,%eax
  800ac0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac7:	00 
  800ac8:	48 b8 98 45 80 00 00 	movabs $0x804598,%rax
  800acf:	00 00 00 
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	48 8b 00             	mov    (%rax),%rax
  800ad8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ada:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ade:	eb c0                	jmp    800aa0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ae4:	eb ba                	jmp    800aa0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800af0:	89 d0                	mov    %edx,%eax
  800af2:	c1 e0 02             	shl    $0x2,%eax
  800af5:	01 d0                	add    %edx,%eax
  800af7:	01 c0                	add    %eax,%eax
  800af9:	01 d8                	add    %ebx,%eax
  800afb:	83 e8 30             	sub    $0x30,%eax
  800afe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b05:	0f b6 00             	movzbl (%rax),%eax
  800b08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800b0e:	7e 0c                	jle    800b1c <vprintfmt+0x105>
  800b10:	83 fb 39             	cmp    $0x39,%ebx
  800b13:	7f 07                	jg     800b1c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b1a:	eb d1                	jmp    800aed <vprintfmt+0xd6>
			goto process_precision;
  800b1c:	eb 58                	jmp    800b76 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b21:	83 f8 30             	cmp    $0x30,%eax
  800b24:	73 17                	jae    800b3d <vprintfmt+0x126>
  800b26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2d:	89 c0                	mov    %eax,%eax
  800b2f:	48 01 d0             	add    %rdx,%rax
  800b32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b35:	83 c2 08             	add    $0x8,%edx
  800b38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3b:	eb 0f                	jmp    800b4c <vprintfmt+0x135>
  800b3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 83 c2 08          	add    $0x8,%rdx
  800b48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4c:	8b 00                	mov    (%rax),%eax
  800b4e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b51:	eb 23                	jmp    800b76 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b57:	79 0c                	jns    800b65 <vprintfmt+0x14e>
				width = 0;
  800b59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b60:	e9 3b ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b65:	e9 36 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b6a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b71:	e9 2a ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7a:	79 12                	jns    800b8e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b7c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b89:	e9 12 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b8e:	e9 0d ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b93:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b97:	e9 04 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9f:	83 f8 30             	cmp    $0x30,%eax
  800ba2:	73 17                	jae    800bbb <vprintfmt+0x1a4>
  800ba4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bab:	89 c0                	mov    %eax,%eax
  800bad:	48 01 d0             	add    %rdx,%rax
  800bb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb3:	83 c2 08             	add    $0x8,%edx
  800bb6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x1b3>
  800bbb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bbf:	48 89 d0             	mov    %rdx,%rax
  800bc2:	48 83 c2 08          	add    $0x8,%rdx
  800bc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bca:	8b 10                	mov    (%rax),%edx
  800bcc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 ce             	mov    %rcx,%rsi
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	ff d0                	callq  *%rax
			break;
  800bdb:	e9 40 03 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800be0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be3:	83 f8 30             	cmp    $0x30,%eax
  800be6:	73 17                	jae    800bff <vprintfmt+0x1e8>
  800be8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bef:	89 c0                	mov    %eax,%eax
  800bf1:	48 01 d0             	add    %rdx,%rax
  800bf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf7:	83 c2 08             	add    $0x8,%edx
  800bfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfd:	eb 0f                	jmp    800c0e <vprintfmt+0x1f7>
  800bff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c03:	48 89 d0             	mov    %rdx,%rax
  800c06:	48 83 c2 08          	add    $0x8,%rdx
  800c0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c10:	85 db                	test   %ebx,%ebx
  800c12:	79 02                	jns    800c16 <vprintfmt+0x1ff>
				err = -err;
  800c14:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c16:	83 fb 15             	cmp    $0x15,%ebx
  800c19:	7f 16                	jg     800c31 <vprintfmt+0x21a>
  800c1b:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  800c22:	00 00 00 
  800c25:	48 63 d3             	movslq %ebx,%rdx
  800c28:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2c:	4d 85 e4             	test   %r12,%r12
  800c2f:	75 2e                	jne    800c5f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	89 d9                	mov    %ebx,%ecx
  800c3b:	48 ba 81 45 80 00 00 	movabs $0x804581,%rdx
  800c42:	00 00 00 
  800c45:	48 89 c7             	mov    %rax,%rdi
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	49 b8 2f 0f 80 00 00 	movabs $0x800f2f,%r8
  800c54:	00 00 00 
  800c57:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5a:	e9 c1 02 00 00       	jmpq   800f20 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c5f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c67:	4c 89 e1             	mov    %r12,%rcx
  800c6a:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  800c71:	00 00 00 
  800c74:	48 89 c7             	mov    %rax,%rdi
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	49 b8 2f 0f 80 00 00 	movabs $0x800f2f,%r8
  800c83:	00 00 00 
  800c86:	41 ff d0             	callq  *%r8
			break;
  800c89:	e9 92 02 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	83 f8 30             	cmp    $0x30,%eax
  800c94:	73 17                	jae    800cad <vprintfmt+0x296>
  800c96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	89 c0                	mov    %eax,%eax
  800c9f:	48 01 d0             	add    %rdx,%rax
  800ca2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca5:	83 c2 08             	add    $0x8,%edx
  800ca8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cab:	eb 0f                	jmp    800cbc <vprintfmt+0x2a5>
  800cad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb1:	48 89 d0             	mov    %rdx,%rax
  800cb4:	48 83 c2 08          	add    $0x8,%rdx
  800cb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbc:	4c 8b 20             	mov    (%rax),%r12
  800cbf:	4d 85 e4             	test   %r12,%r12
  800cc2:	75 0a                	jne    800cce <vprintfmt+0x2b7>
				p = "(null)";
  800cc4:	49 bc 8d 45 80 00 00 	movabs $0x80458d,%r12
  800ccb:	00 00 00 
			if (width > 0 && padc != '-')
  800cce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd2:	7e 3f                	jle    800d13 <vprintfmt+0x2fc>
  800cd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd8:	74 39                	je     800d13 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cdd:	48 98                	cltq   
  800cdf:	48 89 c6             	mov    %rax,%rsi
  800ce2:	4c 89 e7             	mov    %r12,%rdi
  800ce5:	48 b8 db 11 80 00 00 	movabs $0x8011db,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
  800cf1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cf4:	eb 17                	jmp    800d0d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 ce             	mov    %rcx,%rsi
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d11:	7f e3                	jg     800cf6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d13:	eb 37                	jmp    800d4c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d19:	74 1e                	je     800d39 <vprintfmt+0x322>
  800d1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d1e:	7e 05                	jle    800d25 <vprintfmt+0x30e>
  800d20:	83 fb 7e             	cmp    $0x7e,%ebx
  800d23:	7e 14                	jle    800d39 <vprintfmt+0x322>
					putch('?', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d35:	ff d0                	callq  *%rax
  800d37:	eb 0f                	jmp    800d48 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	48 89 d6             	mov    %rdx,%rsi
  800d44:	89 df                	mov    %ebx,%edi
  800d46:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4c:	4c 89 e0             	mov    %r12,%rax
  800d4f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d53:	0f b6 00             	movzbl (%rax),%eax
  800d56:	0f be d8             	movsbl %al,%ebx
  800d59:	85 db                	test   %ebx,%ebx
  800d5b:	74 10                	je     800d6d <vprintfmt+0x356>
  800d5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d61:	78 b2                	js     800d15 <vprintfmt+0x2fe>
  800d63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6b:	79 a8                	jns    800d15 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6d:	eb 16                	jmp    800d85 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 d6             	mov    %rdx,%rsi
  800d7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d7f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d89:	7f e4                	jg     800d6f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d8b:	e9 90 01 00 00       	jmpq   800f20 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d94:	be 03 00 00 00       	mov    $0x3,%esi
  800d99:	48 89 c7             	mov    %rax,%rdi
  800d9c:	48 b8 07 09 80 00 00 	movabs $0x800907,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	callq  *%rax
  800da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db0:	48 85 c0             	test   %rax,%rax
  800db3:	79 1d                	jns    800dd2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800db5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbd:	48 89 d6             	mov    %rdx,%rsi
  800dc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dc5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcb:	48 f7 d8             	neg    %rax
  800dce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd9:	e9 d5 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de2:	be 03 00 00 00       	mov    $0x3,%esi
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	callq  *%rax
  800df6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e01:	e9 ad 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e06:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	48 89 c7             	mov    %rax,%rdi
  800e12:	48 b8 07 09 80 00 00 	movabs $0x800907,%rax
  800e19:	00 00 00 
  800e1c:	ff d0                	callq  *%rax
  800e1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e22:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e29:	e9 85 00 00 00       	jmpq   800eb3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e36:	48 89 d6             	mov    %rdx,%rsi
  800e39:	bf 30 00 00 00       	mov    $0x30,%edi
  800e3e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e48:	48 89 d6             	mov    %rdx,%rsi
  800e4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e50:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e55:	83 f8 30             	cmp    $0x30,%eax
  800e58:	73 17                	jae    800e71 <vprintfmt+0x45a>
  800e5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e61:	89 c0                	mov    %eax,%eax
  800e63:	48 01 d0             	add    %rdx,%rax
  800e66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e69:	83 c2 08             	add    $0x8,%edx
  800e6c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e6f:	eb 0f                	jmp    800e80 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e75:	48 89 d0             	mov    %rdx,%rax
  800e78:	48 83 c2 08          	add    $0x8,%rdx
  800e7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e80:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e8e:	eb 23                	jmp    800eb3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e94:	be 03 00 00 00       	mov    $0x3,%esi
  800e99:	48 89 c7             	mov    %rax,%rdi
  800e9c:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax
  800ea8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eb3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ebb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ebe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eca:	45 89 c1             	mov    %r8d,%r9d
  800ecd:	41 89 f8             	mov    %edi,%r8d
  800ed0:	48 89 c7             	mov    %rax,%rdi
  800ed3:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800eda:	00 00 00 
  800edd:	ff d0                	callq  *%rax
			break;
  800edf:	eb 3f                	jmp    800f20 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee9:	48 89 d6             	mov    %rdx,%rsi
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	ff d0                	callq  *%rax
			break;
  800ef0:	eb 2e                	jmp    800f20 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	bf 25 00 00 00       	mov    $0x25,%edi
  800f02:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f09:	eb 05                	jmp    800f10 <vprintfmt+0x4f9>
  800f0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f14:	48 83 e8 01          	sub    $0x1,%rax
  800f18:	0f b6 00             	movzbl (%rax),%eax
  800f1b:	3c 25                	cmp    $0x25,%al
  800f1d:	75 ec                	jne    800f0b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800f1f:	90                   	nop
		}
	}
  800f20:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f21:	e9 43 fb ff ff       	jmpq   800a69 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f26:	48 83 c4 60          	add    $0x60,%rsp
  800f2a:	5b                   	pop    %rbx
  800f2b:	41 5c                	pop    %r12
  800f2d:	5d                   	pop    %rbp
  800f2e:	c3                   	retq   

0000000000800f2f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f2f:	55                   	push   %rbp
  800f30:	48 89 e5             	mov    %rsp,%rbp
  800f33:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f3a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f41:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f48:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f56:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f5d:	84 c0                	test   %al,%al
  800f5f:	74 20                	je     800f81 <printfmt+0x52>
  800f61:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f65:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f69:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f6d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f71:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f75:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f79:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f7d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f81:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f88:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f8f:	00 00 00 
  800f92:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f99:	00 00 00 
  800f9c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fae:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fbc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fc3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fd1:	48 89 c7             	mov    %rax,%rdi
  800fd4:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800fdb:	00 00 00 
  800fde:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fe0:	c9                   	leaveq 
  800fe1:	c3                   	retq   

0000000000800fe2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fe2:	55                   	push   %rbp
  800fe3:	48 89 e5             	mov    %rsp,%rbp
  800fe6:	48 83 ec 10          	sub    $0x10,%rsp
  800fea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff5:	8b 40 10             	mov    0x10(%rax),%eax
  800ff8:	8d 50 01             	lea    0x1(%rax),%edx
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	48 8b 10             	mov    (%rax),%rdx
  801009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801011:	48 39 c2             	cmp    %rax,%rdx
  801014:	73 17                	jae    80102d <sprintputch+0x4b>
		*b->buf++ = ch;
  801016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101a:	48 8b 00             	mov    (%rax),%rax
  80101d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801021:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801025:	48 89 0a             	mov    %rcx,(%rdx)
  801028:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80102b:	88 10                	mov    %dl,(%rax)
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 50          	sub    $0x50,%rsp
  801037:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80103b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80103e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801042:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801046:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80104a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80104e:	48 8b 0a             	mov    (%rdx),%rcx
  801051:	48 89 08             	mov    %rcx,(%rax)
  801054:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801058:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80105c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801060:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801064:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801068:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80106c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80106f:	48 98                	cltq   
  801071:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801075:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801079:	48 01 d0             	add    %rdx,%rax
  80107c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801080:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801087:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80108c:	74 06                	je     801094 <vsnprintf+0x65>
  80108e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801092:	7f 07                	jg     80109b <vsnprintf+0x6c>
		return -E_INVAL;
  801094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801099:	eb 2f                	jmp    8010ca <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80109b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80109f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010a3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a7:	48 89 c6             	mov    %rax,%rsi
  8010aa:	48 bf e2 0f 80 00 00 	movabs $0x800fe2,%rdi
  8010b1:	00 00 00 
  8010b4:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010c4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010de:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010e4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010eb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f9:	84 c0                	test   %al,%al
  8010fb:	74 20                	je     80111d <snprintf+0x51>
  8010fd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801101:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801105:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801109:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80110d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801111:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801115:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801119:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80111d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801124:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80112b:	00 00 00 
  80112e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801135:	00 00 00 
  801138:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80113c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801143:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80114a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801151:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801158:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80115f:	48 8b 0a             	mov    (%rdx),%rcx
  801162:	48 89 08             	mov    %rcx,(%rax)
  801165:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801169:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80116d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801171:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801175:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80117c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801183:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801189:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801190:	48 89 c7             	mov    %rax,%rdi
  801193:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80119a:	00 00 00 
  80119d:	ff d0                	callq  *%rax
  80119f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011ab:	c9                   	leaveq 
  8011ac:	c3                   	retq   

00000000008011ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ad:	55                   	push   %rbp
  8011ae:	48 89 e5             	mov    %rsp,%rbp
  8011b1:	48 83 ec 18          	sub    $0x18,%rsp
  8011b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c0:	eb 09                	jmp    8011cb <strlen+0x1e>
		n++;
  8011c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	75 ec                	jne    8011c2 <strlen+0x15>
		n++;
	return n;
  8011d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d9:	c9                   	leaveq 
  8011da:	c3                   	retq   

00000000008011db <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	48 83 ec 20          	sub    $0x20,%rsp
  8011e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011f2:	eb 0e                	jmp    801202 <strnlen+0x27>
		n++;
  8011f4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011fd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801202:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801207:	74 0b                	je     801214 <strnlen+0x39>
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	84 c0                	test   %al,%al
  801212:	75 e0                	jne    8011f4 <strnlen+0x19>
		n++;
	return n;
  801214:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 20          	sub    $0x20,%rsp
  801221:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801225:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801231:	90                   	nop
  801232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801236:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801242:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801246:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80124a:	0f b6 12             	movzbl (%rdx),%edx
  80124d:	88 10                	mov    %dl,(%rax)
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	84 c0                	test   %al,%al
  801254:	75 dc                	jne    801232 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80125a:	c9                   	leaveq 
  80125b:	c3                   	retq   

000000000080125c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80125c:	55                   	push   %rbp
  80125d:	48 89 e5             	mov    %rsp,%rbp
  801260:	48 83 ec 20          	sub    $0x20,%rsp
  801264:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801268:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80126c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801270:	48 89 c7             	mov    %rax,%rdi
  801273:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
  80127f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801282:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801285:	48 63 d0             	movslq %eax,%rdx
  801288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128c:	48 01 c2             	add    %rax,%rdx
  80128f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801293:	48 89 c6             	mov    %rax,%rsi
  801296:	48 89 d7             	mov    %rdx,%rdi
  801299:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8012a0:	00 00 00 
  8012a3:	ff d0                	callq  *%rax
	return dst;
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 28          	sub    $0x28,%rsp
  8012b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ce:	00 
  8012cf:	eb 2a                	jmp    8012fb <strncpy+0x50>
		*dst++ = *src;
  8012d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012e1:	0f b6 12             	movzbl (%rdx),%edx
  8012e4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ea:	0f b6 00             	movzbl (%rax),%eax
  8012ed:	84 c0                	test   %al,%al
  8012ef:	74 05                	je     8012f6 <strncpy+0x4b>
			src++;
  8012f1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801303:	72 cc                	jb     8012d1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 28          	sub    $0x28,%rsp
  801313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80131b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801327:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80132c:	74 3d                	je     80136b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80132e:	eb 1d                	jmp    80134d <strlcpy+0x42>
			*dst++ = *src++;
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80133c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801340:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801344:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801348:	0f b6 12             	movzbl (%rdx),%edx
  80134b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801352:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801357:	74 0b                	je     801364 <strlcpy+0x59>
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	84 c0                	test   %al,%al
  801362:	75 cc                	jne    801330 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80136b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801373:	48 29 c2             	sub    %rax,%rdx
  801376:	48 89 d0             	mov    %rdx,%rax
}
  801379:	c9                   	leaveq 
  80137a:	c3                   	retq   

000000000080137b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137b:	55                   	push   %rbp
  80137c:	48 89 e5             	mov    %rsp,%rbp
  80137f:	48 83 ec 10          	sub    $0x10,%rsp
  801383:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80138b:	eb 0a                	jmp    801397 <strcmp+0x1c>
		p++, q++;
  80138d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801392:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139b:	0f b6 00             	movzbl (%rax),%eax
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 12                	je     8013b4 <strcmp+0x39>
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	0f b6 10             	movzbl (%rax),%edx
  8013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	38 c2                	cmp    %al,%dl
  8013b2:	74 d9                	je     80138d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b8:	0f b6 00             	movzbl (%rax),%eax
  8013bb:	0f b6 d0             	movzbl %al,%edx
  8013be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 18          	sub    $0x18,%rsp
  8013d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013e2:	eb 0f                	jmp    8013f3 <strncmp+0x25>
		n--, p++, q++;
  8013e4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f8:	74 1d                	je     801417 <strncmp+0x49>
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	84 c0                	test   %al,%al
  801403:	74 12                	je     801417 <strncmp+0x49>
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 10             	movzbl (%rax),%edx
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	38 c2                	cmp    %al,%dl
  801415:	74 cd                	je     8013e4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801417:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141c:	75 07                	jne    801425 <strncmp+0x57>
		return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	eb 18                	jmp    80143d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	0f b6 c0             	movzbl %al,%eax
  801439:	29 c2                	sub    %eax,%edx
  80143b:	89 d0                	mov    %edx,%eax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
  801443:	48 83 ec 0c          	sub    $0xc,%rsp
  801447:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144b:	89 f0                	mov    %esi,%eax
  80144d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801450:	eb 17                	jmp    801469 <strchr+0x2a>
		if (*s == c)
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145c:	75 06                	jne    801464 <strchr+0x25>
			return (char *) s;
  80145e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801462:	eb 15                	jmp    801479 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801464:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	84 c0                	test   %al,%al
  801472:	75 de                	jne    801452 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801479:	c9                   	leaveq 
  80147a:	c3                   	retq   

000000000080147b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	48 83 ec 0c          	sub    $0xc,%rsp
  801483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801487:	89 f0                	mov    %esi,%eax
  801489:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80148c:	eb 13                	jmp    8014a1 <strfind+0x26>
		if (*s == c)
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801498:	75 02                	jne    80149c <strfind+0x21>
			break;
  80149a:	eb 10                	jmp    8014ac <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 e2                	jne    80148e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014b0:	c9                   	leaveq 
  8014b1:	c3                   	retq   

00000000008014b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014b2:	55                   	push   %rbp
  8014b3:	48 89 e5             	mov    %rsp,%rbp
  8014b6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014be:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ca:	75 06                	jne    8014d2 <memset+0x20>
		return v;
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	eb 69                	jmp    80153b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d6:	83 e0 03             	and    $0x3,%eax
  8014d9:	48 85 c0             	test   %rax,%rax
  8014dc:	75 48                	jne    801526 <memset+0x74>
  8014de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e2:	83 e0 03             	and    $0x3,%eax
  8014e5:	48 85 c0             	test   %rax,%rax
  8014e8:	75 3c                	jne    801526 <memset+0x74>
		c &= 0xFF;
  8014ea:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f4:	c1 e0 18             	shl    $0x18,%eax
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fc:	c1 e0 10             	shl    $0x10,%eax
  8014ff:	09 c2                	or     %eax,%edx
  801501:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801504:	c1 e0 08             	shl    $0x8,%eax
  801507:	09 d0                	or     %edx,%eax
  801509:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	48 c1 e8 02          	shr    $0x2,%rax
  801514:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801517:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151e:	48 89 d7             	mov    %rdx,%rdi
  801521:	fc                   	cld    
  801522:	f3 ab                	rep stos %eax,%es:(%rdi)
  801524:	eb 11                	jmp    801537 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801526:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801531:	48 89 d7             	mov    %rdx,%rdi
  801534:	fc                   	cld    
  801535:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 28          	sub    $0x28,%rsp
  801545:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801549:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801555:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801569:	0f 83 88 00 00 00    	jae    8015f7 <memmove+0xba>
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801577:	48 01 d0             	add    %rdx,%rax
  80157a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80157e:	76 77                	jbe    8015f7 <memmove+0xba>
		s += n;
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	83 e0 03             	and    $0x3,%eax
  801597:	48 85 c0             	test   %rax,%rax
  80159a:	75 3b                	jne    8015d7 <memmove+0x9a>
  80159c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a0:	83 e0 03             	and    $0x3,%eax
  8015a3:	48 85 c0             	test   %rax,%rax
  8015a6:	75 2f                	jne    8015d7 <memmove+0x9a>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	83 e0 03             	and    $0x3,%eax
  8015af:	48 85 c0             	test   %rax,%rax
  8015b2:	75 23                	jne    8015d7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b8:	48 83 e8 04          	sub    $0x4,%rax
  8015bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c0:	48 83 ea 04          	sub    $0x4,%rdx
  8015c4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015cc:	48 89 c7             	mov    %rax,%rdi
  8015cf:	48 89 d6             	mov    %rdx,%rsi
  8015d2:	fd                   	std    
  8015d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015d5:	eb 1d                	jmp    8015f4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	48 89 d7             	mov    %rdx,%rdi
  8015ee:	48 89 c1             	mov    %rax,%rcx
  8015f1:	fd                   	std    
  8015f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015f4:	fc                   	cld    
  8015f5:	eb 57                	jmp    80164e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fb:	83 e0 03             	and    $0x3,%eax
  8015fe:	48 85 c0             	test   %rax,%rax
  801601:	75 36                	jne    801639 <memmove+0xfc>
  801603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801607:	83 e0 03             	and    $0x3,%eax
  80160a:	48 85 c0             	test   %rax,%rax
  80160d:	75 2a                	jne    801639 <memmove+0xfc>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	83 e0 03             	and    $0x3,%eax
  801616:	48 85 c0             	test   %rax,%rax
  801619:	75 1e                	jne    801639 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	48 c1 e8 02          	shr    $0x2,%rax
  801623:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162e:	48 89 c7             	mov    %rax,%rdi
  801631:	48 89 d6             	mov    %rdx,%rsi
  801634:	fc                   	cld    
  801635:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801637:	eb 15                	jmp    80164e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801641:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801645:	48 89 c7             	mov    %rax,%rdi
  801648:	48 89 d6             	mov    %rdx,%rsi
  80164b:	fc                   	cld    
  80164c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 18          	sub    $0x18,%rsp
  80165c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801660:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801664:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801674:	48 89 ce             	mov    %rcx,%rsi
  801677:	48 89 c7             	mov    %rax,%rdi
  80167a:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  801681:	00 00 00 
  801684:	ff d0                	callq  *%rax
}
  801686:	c9                   	leaveq 
  801687:	c3                   	retq   

0000000000801688 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801688:	55                   	push   %rbp
  801689:	48 89 e5             	mov    %rsp,%rbp
  80168c:	48 83 ec 28          	sub    $0x28,%rsp
  801690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801694:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801698:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80169c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016ac:	eb 36                	jmp    8016e4 <memcmp+0x5c>
		if (*s1 != *s2)
  8016ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b2:	0f b6 10             	movzbl (%rax),%edx
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	38 c2                	cmp    %al,%dl
  8016be:	74 1a                	je     8016da <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	0f b6 d0             	movzbl %al,%edx
  8016ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	0f b6 c0             	movzbl %al,%eax
  8016d4:	29 c2                	sub    %eax,%edx
  8016d6:	89 d0                	mov    %edx,%eax
  8016d8:	eb 20                	jmp    8016fa <memcmp+0x72>
		s1++, s2++;
  8016da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016f0:	48 85 c0             	test   %rax,%rax
  8016f3:	75 b9                	jne    8016ae <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fa:	c9                   	leaveq 
  8016fb:	c3                   	retq   

00000000008016fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	48 83 ec 28          	sub    $0x28,%rsp
  801704:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801708:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80170b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801717:	48 01 d0             	add    %rdx,%rax
  80171a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80171e:	eb 15                	jmp    801735 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	0f b6 10             	movzbl (%rax),%edx
  801727:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80172a:	38 c2                	cmp    %al,%dl
  80172c:	75 02                	jne    801730 <memfind+0x34>
			break;
  80172e:	eb 0f                	jmp    80173f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801730:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801739:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80173d:	72 e1                	jb     801720 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 34          	sub    $0x34,%rsp
  80174d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801751:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801755:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80175f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801766:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801767:	eb 05                	jmp    80176e <strtol+0x29>
		s++;
  801769:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	3c 20                	cmp    $0x20,%al
  801777:	74 f0                	je     801769 <strtol+0x24>
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	3c 09                	cmp    $0x9,%al
  801782:	74 e5                	je     801769 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 2b                	cmp    $0x2b,%al
  80178d:	75 07                	jne    801796 <strtol+0x51>
		s++;
  80178f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801794:	eb 17                	jmp    8017ad <strtol+0x68>
	else if (*s == '-')
  801796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179a:	0f b6 00             	movzbl (%rax),%eax
  80179d:	3c 2d                	cmp    $0x2d,%al
  80179f:	75 0c                	jne    8017ad <strtol+0x68>
		s++, neg = 1;
  8017a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b1:	74 06                	je     8017b9 <strtol+0x74>
  8017b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b7:	75 28                	jne    8017e1 <strtol+0x9c>
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	0f b6 00             	movzbl (%rax),%eax
  8017c0:	3c 30                	cmp    $0x30,%al
  8017c2:	75 1d                	jne    8017e1 <strtol+0x9c>
  8017c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c8:	48 83 c0 01          	add    $0x1,%rax
  8017cc:	0f b6 00             	movzbl (%rax),%eax
  8017cf:	3c 78                	cmp    $0x78,%al
  8017d1:	75 0e                	jne    8017e1 <strtol+0x9c>
		s += 2, base = 16;
  8017d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017df:	eb 2c                	jmp    80180d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e5:	75 19                	jne    801800 <strtol+0xbb>
  8017e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017eb:	0f b6 00             	movzbl (%rax),%eax
  8017ee:	3c 30                	cmp    $0x30,%al
  8017f0:	75 0e                	jne    801800 <strtol+0xbb>
		s++, base = 8;
  8017f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017fe:	eb 0d                	jmp    80180d <strtol+0xc8>
	else if (base == 0)
  801800:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801804:	75 07                	jne    80180d <strtol+0xc8>
		base = 10;
  801806:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	0f b6 00             	movzbl (%rax),%eax
  801814:	3c 2f                	cmp    $0x2f,%al
  801816:	7e 1d                	jle    801835 <strtol+0xf0>
  801818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181c:	0f b6 00             	movzbl (%rax),%eax
  80181f:	3c 39                	cmp    $0x39,%al
  801821:	7f 12                	jg     801835 <strtol+0xf0>
			dig = *s - '0';
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	0f b6 00             	movzbl (%rax),%eax
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801833:	eb 4e                	jmp    801883 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	3c 60                	cmp    $0x60,%al
  80183e:	7e 1d                	jle    80185d <strtol+0x118>
  801840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	3c 7a                	cmp    $0x7a,%al
  801849:	7f 12                	jg     80185d <strtol+0x118>
			dig = *s - 'a' + 10;
  80184b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	0f be c0             	movsbl %al,%eax
  801855:	83 e8 57             	sub    $0x57,%eax
  801858:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80185b:	eb 26                	jmp    801883 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80185d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801861:	0f b6 00             	movzbl (%rax),%eax
  801864:	3c 40                	cmp    $0x40,%al
  801866:	7e 48                	jle    8018b0 <strtol+0x16b>
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	3c 5a                	cmp    $0x5a,%al
  801871:	7f 3d                	jg     8018b0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801877:	0f b6 00             	movzbl (%rax),%eax
  80187a:	0f be c0             	movsbl %al,%eax
  80187d:	83 e8 37             	sub    $0x37,%eax
  801880:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801883:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801886:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801889:	7c 02                	jl     80188d <strtol+0x148>
			break;
  80188b:	eb 23                	jmp    8018b0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80188d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801892:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801895:	48 98                	cltq   
  801897:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018a2:	48 98                	cltq   
  8018a4:	48 01 d0             	add    %rdx,%rax
  8018a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018ab:	e9 5d ff ff ff       	jmpq   80180d <strtol+0xc8>

	if (endptr)
  8018b0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018b5:	74 0b                	je     8018c2 <strtol+0x17d>
		*endptr = (char *) s;
  8018b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018bf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c6:	74 09                	je     8018d1 <strtol+0x18c>
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cc:	48 f7 d8             	neg    %rax
  8018cf:	eb 04                	jmp    8018d5 <strtol+0x190>
  8018d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 30          	sub    $0x30,%rsp
  8018df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018f3:	0f b6 00             	movzbl (%rax),%eax
  8018f6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018fd:	75 06                	jne    801905 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801903:	eb 6b                	jmp    801970 <strstr+0x99>

	len = strlen(str);
  801905:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801909:	48 89 c7             	mov    %rax,%rdi
  80190c:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	48 98                	cltq   
  80191a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801926:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80192a:	0f b6 00             	movzbl (%rax),%eax
  80192d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801930:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801934:	75 07                	jne    80193d <strstr+0x66>
				return (char *) 0;
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	eb 33                	jmp    801970 <strstr+0x99>
		} while (sc != c);
  80193d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801941:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801944:	75 d8                	jne    80191e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	48 89 ce             	mov    %rcx,%rsi
  801955:	48 89 c7             	mov    %rax,%rdi
  801958:	48 b8 ce 13 80 00 00 	movabs $0x8013ce,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
  801964:	85 c0                	test   %eax,%eax
  801966:	75 b6                	jne    80191e <strstr+0x47>

	return (char *) (in - 1);
  801968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196c:	48 83 e8 01          	sub    $0x1,%rax
}
  801970:	c9                   	leaveq 
  801971:	c3                   	retq   

0000000000801972 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	53                   	push   %rbx
  801977:	48 83 ec 48          	sub    $0x48,%rsp
  80197b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80197e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801981:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801985:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801989:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80198d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801991:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801994:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801998:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80199c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019a0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019a4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a8:	4c 89 c3             	mov    %r8,%rbx
  8019ab:	cd 30                	int    $0x30
  8019ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b5:	74 3e                	je     8019f5 <syscall+0x83>
  8019b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019bc:	7e 37                	jle    8019f5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c5:	49 89 d0             	mov    %rdx,%r8
  8019c8:	89 c1                	mov    %eax,%ecx
  8019ca:	48 ba 48 48 80 00 00 	movabs $0x804848,%rdx
  8019d1:	00 00 00 
  8019d4:	be 23 00 00 00       	mov    $0x23,%esi
  8019d9:	48 bf 65 48 80 00 00 	movabs $0x804865,%rdi
  8019e0:	00 00 00 
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e8:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  8019ef:	00 00 00 
  8019f2:	41 ff d1             	callq  *%r9

	return ret;
  8019f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f9:	48 83 c4 48          	add    $0x48,%rsp
  8019fd:	5b                   	pop    %rbx
  8019fe:	5d                   	pop    %rbp
  8019ff:	c3                   	retq   

0000000000801a00 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 20          	sub    $0x20,%rsp
  801a08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2c:	48 89 d1             	mov    %rdx,%rcx
  801a2f:	48 89 c2             	mov    %rax,%rdx
  801a32:	be 00 00 00 00       	mov    $0x0,%esi
  801a37:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3c:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	callq  *%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a59:	00 
  801a5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	be 00 00 00 00       	mov    $0x0,%esi
  801a75:	bf 01 00 00 00       	mov    $0x1,%edi
  801a7a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 10          	sub    $0x10,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a96:	48 98                	cltq   
  801a98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9f:	00 
  801aa0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 03 00 00 00       	mov    $0x3,%edi
  801abe:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ad4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adb:	00 
  801adc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aed:	ba 00 00 00 00       	mov    $0x0,%edx
  801af2:	be 00 00 00 00       	mov    $0x0,%esi
  801af7:	bf 02 00 00 00       	mov    $0x2,%edi
  801afc:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	callq  *%rax
}
  801b08:	c9                   	leaveq 
  801b09:	c3                   	retq   

0000000000801b0a <sys_yield>:

void
sys_yield(void)
{
  801b0a:	55                   	push   %rbp
  801b0b:	48 89 e5             	mov    %rsp,%rbp
  801b0e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b19:	00 
  801b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	be 00 00 00 00       	mov    $0x0,%esi
  801b35:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b3a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 20          	sub    $0x20,%rsp
  801b50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b57:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 c8             	movslq %eax,%rcx
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b70:	00 
  801b71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b77:	49 89 c8             	mov    %rcx,%r8
  801b7a:	48 89 d1             	mov    %rdx,%rcx
  801b7d:	48 89 c2             	mov    %rax,%rdx
  801b80:	be 01 00 00 00       	mov    $0x1,%esi
  801b85:	bf 04 00 00 00       	mov    $0x4,%edi
  801b8a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 30          	sub    $0x30,%rsp
  801ba0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801baa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bb2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb5:	48 63 c8             	movslq %eax,%rcx
  801bb8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbf:	48 63 f0             	movslq %eax,%rsi
  801bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	48 98                	cltq   
  801bcb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bcf:	49 89 f9             	mov    %rdi,%r9
  801bd2:	49 89 f0             	mov    %rsi,%r8
  801bd5:	48 89 d1             	mov    %rdx,%rcx
  801bd8:	48 89 c2             	mov    %rax,%rdx
  801bdb:	be 01 00 00 00       	mov    $0x1,%esi
  801be0:	bf 05 00 00 00       	mov    $0x5,%edi
  801be5:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	callq  *%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 20          	sub    $0x20,%rsp
  801bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c09:	48 98                	cltq   
  801c0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c12:	00 
  801c13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 01 00 00 00       	mov    $0x1,%esi
  801c2a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c2f:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c48:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4e:	48 63 d0             	movslq %eax,%rdx
  801c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c54:	48 98                	cltq   
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 01 00 00 00       	mov    $0x1,%esi
  801c75:	bf 08 00 00 00       	mov    $0x8,%edi
  801c7a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 20          	sub    $0x20,%rsp
  801c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9e:	48 98                	cltq   
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb4:	48 89 d1             	mov    %rdx,%rcx
  801cb7:	48 89 c2             	mov    %rax,%rdx
  801cba:	be 01 00 00 00       	mov    $0x1,%esi
  801cbf:	bf 09 00 00 00       	mov    $0x9,%edi
  801cc4:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 20          	sub    $0x20,%rsp
  801cda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ce1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	48 98                	cltq   
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	48 89 d1             	mov    %rdx,%rcx
  801d01:	48 89 c2             	mov    %rax,%rdx
  801d04:	be 01 00 00 00       	mov    $0x1,%esi
  801d09:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d0e:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801d15:	00 00 00 
  801d18:	ff d0                	callq  *%rax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 20          	sub    $0x20,%rsp
  801d24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d35:	48 63 f0             	movslq %eax,%rsi
  801d38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3f:	48 98                	cltq   
  801d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4c:	00 
  801d4d:	49 89 f1             	mov    %rsi,%r9
  801d50:	49 89 c8             	mov    %rcx,%r8
  801d53:	48 89 d1             	mov    %rdx,%rcx
  801d56:	48 89 c2             	mov    %rax,%rdx
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d63:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	callq  *%rax
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 10          	sub    $0x10,%rsp
  801d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d88:	00 
  801d89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d9a:	48 89 c2             	mov    %rax,%rdx
  801d9d:	be 01 00 00 00       	mov    $0x1,%esi
  801da2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da7:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc4:	00 
  801dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddb:	be 00 00 00 00       	mov    $0x0,%esi
  801de0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801de5:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801dec:	00 00 00 
  801def:	ff d0                	callq  *%rax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 30          	sub    $0x30,%rsp
  801dfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e02:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e05:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e09:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e0d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e10:	48 63 c8             	movslq %eax,%rcx
  801e13:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1a:	48 63 f0             	movslq %eax,%rsi
  801e1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e24:	48 98                	cltq   
  801e26:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e2a:	49 89 f9             	mov    %rdi,%r9
  801e2d:	49 89 f0             	mov    %rsi,%r8
  801e30:	48 89 d1             	mov    %rdx,%rcx
  801e33:	48 89 c2             	mov    %rax,%rdx
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e40:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 20          	sub    $0x20,%rsp
  801e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6d:	00 
  801e6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7a:	48 89 d1             	mov    %rdx,%rcx
  801e7d:	48 89 c2             	mov    %rax,%rdx
  801e80:	be 00 00 00 00       	mov    $0x0,%esi
  801e85:	bf 10 00 00 00       	mov    $0x10,%edi
  801e8a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	callq  *%rax
}
  801e96:	c9                   	leaveq 
  801e97:	c3                   	retq   

0000000000801e98 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e98:	55                   	push   %rbp
  801e99:	48 89 e5             	mov    %rsp,%rbp
  801e9c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801ea0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea7:	00 
  801ea8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebe:	be 00 00 00 00       	mov    $0x0,%esi
  801ec3:	bf 11 00 00 00       	mov    $0x11,%edi
  801ec8:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801ed4:	c9                   	leaveq 
  801ed5:	c3                   	retq   

0000000000801ed6 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	48 83 ec 10          	sub    $0x10,%rsp
  801ede:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee4:	48 98                	cltq   
  801ee6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eed:	00 
  801eee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801efa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eff:	48 89 c2             	mov    %rax,%rdx
  801f02:	be 00 00 00 00       	mov    $0x0,%esi
  801f07:	bf 12 00 00 00       	mov    $0x12,%edi
  801f0c:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
}
  801f18:	c9                   	leaveq 
  801f19:	c3                   	retq   

0000000000801f1a <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
  801f1e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f29:	00 
  801f2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f40:	be 00 00 00 00       	mov    $0x0,%esi
  801f45:	bf 13 00 00 00       	mov    $0x13,%edi
  801f4a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
}
  801f56:	c9                   	leaveq 
  801f57:	c3                   	retq   

0000000000801f58 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f58:	55                   	push   %rbp
  801f59:	48 89 e5             	mov    %rsp,%rbp
  801f5c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f67:	00 
  801f68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f79:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7e:	be 00 00 00 00       	mov    $0x0,%esi
  801f83:	bf 14 00 00 00       	mov    $0x14,%edi
  801f88:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801f8f:	00 00 00 
  801f92:	ff d0                	callq  *%rax
}
  801f94:	c9                   	leaveq 
  801f95:	c3                   	retq   

0000000000801f96 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f96:	55                   	push   %rbp
  801f97:	48 89 e5             	mov    %rsp,%rbp
  801f9a:	48 83 ec 30          	sub    $0x30,%rsp
  801f9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa6:	48 8b 00             	mov    (%rax),%rax
  801fa9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801fad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb1:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fb5:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801fb8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fbb:	83 e0 02             	and    $0x2,%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	75 4d                	jne    80200f <pgfault+0x79>
  801fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc6:	48 c1 e8 0c          	shr    $0xc,%rax
  801fca:	48 89 c2             	mov    %rax,%rdx
  801fcd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd4:	01 00 00 
  801fd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdb:	25 00 08 00 00       	and    $0x800,%eax
  801fe0:	48 85 c0             	test   %rax,%rax
  801fe3:	74 2a                	je     80200f <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801fe5:	48 ba 78 48 80 00 00 	movabs $0x804878,%rdx
  801fec:	00 00 00 
  801fef:	be 23 00 00 00       	mov    $0x23,%esi
  801ff4:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  801ffb:	00 00 00 
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  802003:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80200a:	00 00 00 
  80200d:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  80200f:	ba 07 00 00 00       	mov    $0x7,%edx
  802014:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802019:	bf 00 00 00 00       	mov    $0x0,%edi
  80201e:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	0f 85 cd 00 00 00    	jne    8020ff <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802036:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80203a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802044:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802051:	48 89 c6             	mov    %rax,%rsi
  802054:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802059:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802065:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802069:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80206f:	48 89 c1             	mov    %rax,%rcx
  802072:	ba 00 00 00 00       	mov    $0x0,%edx
  802077:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80207c:	bf 00 00 00 00       	mov    $0x0,%edi
  802081:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	79 2a                	jns    8020bb <pgfault+0x125>
				panic("Page map at temp address failed");
  802091:	48 ba b8 48 80 00 00 	movabs $0x8048b8,%rdx
  802098:	00 00 00 
  80209b:	be 30 00 00 00       	mov    $0x30,%esi
  8020a0:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  8020a7:	00 00 00 
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8020b6:	00 00 00 
  8020b9:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  8020bb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c5:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8020cc:	00 00 00 
  8020cf:	ff d0                	callq  *%rax
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	79 54                	jns    802129 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8020d5:	48 ba d8 48 80 00 00 	movabs $0x8048d8,%rdx
  8020dc:	00 00 00 
  8020df:	be 32 00 00 00       	mov    $0x32,%esi
  8020e4:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  8020eb:	00 00 00 
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8020fa:	00 00 00 
  8020fd:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8020ff:	48 ba 00 49 80 00 00 	movabs $0x804900,%rdx
  802106:	00 00 00 
  802109:	be 34 00 00 00       	mov    $0x34,%esi
  80210e:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  802115:	00 00 00 
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802124:	00 00 00 
  802127:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 20          	sub    $0x20,%rsp
  802133:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802136:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802139:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802140:	01 00 00 
  802143:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802146:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214a:	25 07 0e 00 00       	and    $0xe07,%eax
  80214f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802152:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802155:	48 c1 e0 0c          	shl    $0xc,%rax
  802159:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  80215d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802160:	25 00 04 00 00       	and    $0x400,%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	74 57                	je     8021c0 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802169:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80216c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802170:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802173:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802177:	41 89 f0             	mov    %esi,%r8d
  80217a:	48 89 c6             	mov    %rax,%rsi
  80217d:	bf 00 00 00 00       	mov    $0x0,%edi
  802182:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	85 c0                	test   %eax,%eax
  802190:	0f 8e 52 01 00 00    	jle    8022e8 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802196:	48 ba 32 49 80 00 00 	movabs $0x804932,%rdx
  80219d:	00 00 00 
  8021a0:	be 4e 00 00 00       	mov    $0x4e,%esi
  8021a5:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  8021ac:	00 00 00 
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8021bb:	00 00 00 
  8021be:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8021c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c3:	83 e0 02             	and    $0x2,%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	75 10                	jne    8021da <duppage+0xaf>
  8021ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cd:	25 00 08 00 00       	and    $0x800,%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	0f 84 bb 00 00 00    	je     802295 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8021da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021dd:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8021e2:	80 cc 08             	or     $0x8,%ah
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021e8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021eb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021ef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	41 89 f0             	mov    %esi,%r8d
  8021f9:	48 89 c6             	mov    %rax,%rsi
  8021fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802201:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	7e 2a                	jle    80223b <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802211:	48 ba 32 49 80 00 00 	movabs $0x804932,%rdx
  802218:	00 00 00 
  80221b:	be 55 00 00 00       	mov    $0x55,%esi
  802220:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  802227:	00 00 00 
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802236:	00 00 00 
  802239:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80223b:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80223e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802246:	41 89 c8             	mov    %ecx,%r8d
  802249:	48 89 d1             	mov    %rdx,%rcx
  80224c:	ba 00 00 00 00       	mov    $0x0,%edx
  802251:	48 89 c6             	mov    %rax,%rsi
  802254:	bf 00 00 00 00       	mov    $0x0,%edi
  802259:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802260:	00 00 00 
  802263:	ff d0                	callq  *%rax
  802265:	85 c0                	test   %eax,%eax
  802267:	7e 2a                	jle    802293 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802269:	48 ba 32 49 80 00 00 	movabs $0x804932,%rdx
  802270:	00 00 00 
  802273:	be 57 00 00 00       	mov    $0x57,%esi
  802278:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  80227f:	00 00 00 
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80228e:	00 00 00 
  802291:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802293:	eb 53                	jmp    8022e8 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802295:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802298:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80229c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a3:	41 89 f0             	mov    %esi,%r8d
  8022a6:	48 89 c6             	mov    %rax,%rsi
  8022a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ae:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8022b5:	00 00 00 
  8022b8:	ff d0                	callq  *%rax
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	7e 2a                	jle    8022e8 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8022be:	48 ba 32 49 80 00 00 	movabs $0x804932,%rdx
  8022c5:	00 00 00 
  8022c8:	be 5b 00 00 00       	mov    $0x5b,%esi
  8022cd:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  8022d4:	00 00 00 
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8022e3:	00 00 00 
  8022e6:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ed:	c9                   	leaveq 
  8022ee:	c3                   	retq   

00000000008022ef <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8022ef:	55                   	push   %rbp
  8022f0:	48 89 e5             	mov    %rsp,%rbp
  8022f3:	48 83 ec 18          	sub    $0x18,%rsp
  8022f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8022fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802307:	48 c1 e8 27          	shr    $0x27,%rax
  80230b:	48 89 c2             	mov    %rax,%rdx
  80230e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802315:	01 00 00 
  802318:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231c:	83 e0 01             	and    $0x1,%eax
  80231f:	48 85 c0             	test   %rax,%rax
  802322:	74 51                	je     802375 <pt_is_mapped+0x86>
  802324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802328:	48 c1 e0 0c          	shl    $0xc,%rax
  80232c:	48 c1 e8 1e          	shr    $0x1e,%rax
  802330:	48 89 c2             	mov    %rax,%rdx
  802333:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80233a:	01 00 00 
  80233d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802341:	83 e0 01             	and    $0x1,%eax
  802344:	48 85 c0             	test   %rax,%rax
  802347:	74 2c                	je     802375 <pt_is_mapped+0x86>
  802349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234d:	48 c1 e0 0c          	shl    $0xc,%rax
  802351:	48 c1 e8 15          	shr    $0x15,%rax
  802355:	48 89 c2             	mov    %rax,%rdx
  802358:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80235f:	01 00 00 
  802362:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802366:	83 e0 01             	and    $0x1,%eax
  802369:	48 85 c0             	test   %rax,%rax
  80236c:	74 07                	je     802375 <pt_is_mapped+0x86>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb 05                	jmp    80237a <pt_is_mapped+0x8b>
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	83 e0 01             	and    $0x1,%eax
}
  80237d:	c9                   	leaveq 
  80237e:	c3                   	retq   

000000000080237f <fork>:

envid_t
fork(void)
{
  80237f:	55                   	push   %rbp
  802380:	48 89 e5             	mov    %rsp,%rbp
  802383:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802387:	48 bf 96 1f 80 00 00 	movabs $0x801f96,%rdi
  80238e:	00 00 00 
  802391:	48 b8 f6 40 80 00 00 	movabs $0x8040f6,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80239d:	b8 07 00 00 00       	mov    $0x7,%eax
  8023a2:	cd 30                	int    $0x30
  8023a4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8023a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8023aa:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8023ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023b1:	79 30                	jns    8023e3 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8023b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023b6:	89 c1                	mov    %eax,%ecx
  8023b8:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  8023bf:	00 00 00 
  8023c2:	be 86 00 00 00       	mov    $0x86,%esi
  8023c7:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  8023ce:	00 00 00 
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8023dd:	00 00 00 
  8023e0:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8023e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023e7:	75 3e                	jne    802427 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8023e9:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023fa:	48 98                	cltq   
  8023fc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802403:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80240a:	00 00 00 
  80240d:	48 01 c2             	add    %rax,%rdx
  802410:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802417:	00 00 00 
  80241a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	e9 d1 01 00 00       	jmpq   8025f8 <fork+0x279>
	}
	uint64_t ad = 0;
  802427:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80242e:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80242f:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802434:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802438:	e9 df 00 00 00       	jmpq   80251c <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80243d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802441:	48 c1 e8 27          	shr    $0x27,%rax
  802445:	48 89 c2             	mov    %rax,%rdx
  802448:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80244f:	01 00 00 
  802452:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802456:	83 e0 01             	and    $0x1,%eax
  802459:	48 85 c0             	test   %rax,%rax
  80245c:	0f 84 9e 00 00 00    	je     802500 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802466:	48 c1 e8 1e          	shr    $0x1e,%rax
  80246a:	48 89 c2             	mov    %rax,%rdx
  80246d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802474:	01 00 00 
  802477:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247b:	83 e0 01             	and    $0x1,%eax
  80247e:	48 85 c0             	test   %rax,%rax
  802481:	74 73                	je     8024f6 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802487:	48 c1 e8 15          	shr    $0x15,%rax
  80248b:	48 89 c2             	mov    %rax,%rdx
  80248e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802495:	01 00 00 
  802498:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249c:	83 e0 01             	and    $0x1,%eax
  80249f:	48 85 c0             	test   %rax,%rax
  8024a2:	74 48                	je     8024ec <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8024a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ac:	48 89 c2             	mov    %rax,%rdx
  8024af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b6:	01 00 00 
  8024b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8024c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c5:	83 e0 01             	and    $0x1,%eax
  8024c8:	48 85 c0             	test   %rax,%rax
  8024cb:	74 47                	je     802514 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8024cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8024d5:	89 c2                	mov    %eax,%edx
  8024d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024da:	89 d6                	mov    %edx,%esi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	eb 28                	jmp    802514 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8024ec:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8024f3:	00 
  8024f4:	eb 1e                	jmp    802514 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8024f6:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8024fd:	40 
  8024fe:	eb 14                	jmp    802514 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802504:	48 c1 e8 27          	shr    $0x27,%rax
  802508:	48 83 c0 01          	add    $0x1,%rax
  80250c:	48 c1 e0 27          	shl    $0x27,%rax
  802510:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802514:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80251b:	00 
  80251c:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802523:	00 
  802524:	0f 87 13 ff ff ff    	ja     80243d <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80252a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80252d:	ba 07 00 00 00       	mov    $0x7,%edx
  802532:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802537:	89 c7                	mov    %eax,%edi
  802539:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802545:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802548:	ba 07 00 00 00       	mov    $0x7,%edx
  80254d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802552:	89 c7                	mov    %eax,%edi
  802554:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802560:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802563:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802569:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80256e:	ba 00 00 00 00       	mov    $0x0,%edx
  802573:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802578:	89 c7                	mov    %eax,%edi
  80257a:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802581:	00 00 00 
  802584:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802586:	ba 00 10 00 00       	mov    $0x1000,%edx
  80258b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802590:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802595:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8025a1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8025a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ab:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8025b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025be:	00 00 00 
  8025c1:	48 8b 00             	mov    (%rax),%rax
  8025c4:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8025cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025ce:	48 89 d6             	mov    %rdx,%rsi
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8025da:	00 00 00 
  8025dd:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8025df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025e2:	be 02 00 00 00       	mov    $0x2,%esi
  8025e7:	89 c7                	mov    %eax,%edi
  8025e9:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  8025f0:	00 00 00 
  8025f3:	ff d0                	callq  *%rax

	return envid;
  8025f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8025f8:	c9                   	leaveq 
  8025f9:	c3                   	retq   

00000000008025fa <sfork>:

	
// Challenge!
int
sfork(void)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025fe:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  802605:	00 00 00 
  802608:	be bf 00 00 00       	mov    $0xbf,%esi
  80260d:	48 bf ad 48 80 00 00 	movabs $0x8048ad,%rdi
  802614:	00 00 00 
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
  80261c:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802623:	00 00 00 
  802626:	ff d1                	callq  *%rcx

0000000000802628 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802628:	55                   	push   %rbp
  802629:	48 89 e5             	mov    %rsp,%rbp
  80262c:	48 83 ec 30          	sub    $0x30,%rsp
  802630:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802634:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802638:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80263c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802643:	00 00 00 
  802646:	48 8b 00             	mov    (%rax),%rax
  802649:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	75 34                	jne    802687 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802653:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	callq  *%rax
  80265f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802664:	48 98                	cltq   
  802666:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80266d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802674:	00 00 00 
  802677:	48 01 c2             	add    %rax,%rdx
  80267a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802681:	00 00 00 
  802684:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802687:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80268c:	75 0e                	jne    80269c <ipc_recv+0x74>
		pg = (void*) UTOP;
  80268e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802695:	00 00 00 
  802698:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80269c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a0:	48 89 c7             	mov    %rax,%rdi
  8026a3:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
  8026af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8026b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b6:	79 19                	jns    8026d1 <ipc_recv+0xa9>
		*from_env_store = 0;
  8026b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8026c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8026cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cf:	eb 53                	jmp    802724 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8026d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026d6:	74 19                	je     8026f1 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8026d8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026df:	00 00 00 
  8026e2:	48 8b 00             	mov    (%rax),%rax
  8026e5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8026eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ef:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8026f1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026f6:	74 19                	je     802711 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8026f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026ff:	00 00 00 
  802702:	48 8b 00             	mov    (%rax),%rax
  802705:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80270b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80270f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802711:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802718:	00 00 00 
  80271b:	48 8b 00             	mov    (%rax),%rax
  80271e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802724:	c9                   	leaveq 
  802725:	c3                   	retq   

0000000000802726 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802726:	55                   	push   %rbp
  802727:	48 89 e5             	mov    %rsp,%rbp
  80272a:	48 83 ec 30          	sub    $0x30,%rsp
  80272e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802731:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802734:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802738:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80273b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802740:	75 0e                	jne    802750 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802742:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802749:	00 00 00 
  80274c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802750:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802753:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802756:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80275a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80275d:	89 c7                	mov    %eax,%edi
  80275f:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax
  80276b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80276e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802772:	75 0c                	jne    802780 <ipc_send+0x5a>
			sys_yield();
  802774:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802780:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802784:	74 ca                	je     802750 <ipc_send+0x2a>
	if(result != 0)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	74 20                	je     8027ac <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80278c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278f:	89 c6                	mov    %eax,%esi
  802791:	48 bf 7e 49 80 00 00 	movabs $0x80497e,%rdi
  802798:	00 00 00 
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8027a7:	00 00 00 
  8027aa:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8027ac:	c9                   	leaveq 
  8027ad:	c3                   	retq   

00000000008027ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027ae:	55                   	push   %rbp
  8027af:	48 89 e5             	mov    %rsp,%rbp
  8027b2:	48 83 ec 14          	sub    $0x14,%rsp
  8027b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8027b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027c0:	eb 4e                	jmp    802810 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8027c2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027c9:	00 00 00 
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cf:	48 98                	cltq   
  8027d1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8027d8:	48 01 d0             	add    %rdx,%rax
  8027db:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8027e1:	8b 00                	mov    (%rax),%eax
  8027e3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027e6:	75 24                	jne    80280c <ipc_find_env+0x5e>
			return envs[i].env_id;
  8027e8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8027ef:	00 00 00 
  8027f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f5:	48 98                	cltq   
  8027f7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8027fe:	48 01 d0             	add    %rdx,%rax
  802801:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802807:	8b 40 08             	mov    0x8(%rax),%eax
  80280a:	eb 12                	jmp    80281e <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80280c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802810:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802817:	7e a9                	jle    8027c2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 08          	sub    $0x8,%rsp
  802828:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80282c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802830:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802837:	ff ff ff 
  80283a:	48 01 d0             	add    %rdx,%rax
  80283d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802841:	c9                   	leaveq 
  802842:	c3                   	retq   

0000000000802843 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802843:	55                   	push   %rbp
  802844:	48 89 e5             	mov    %rsp,%rbp
  802847:	48 83 ec 08          	sub    $0x8,%rsp
  80284b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80284f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802853:	48 89 c7             	mov    %rax,%rdi
  802856:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  80285d:	00 00 00 
  802860:	ff d0                	callq  *%rax
  802862:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802868:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80286c:	c9                   	leaveq 
  80286d:	c3                   	retq   

000000000080286e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80286e:	55                   	push   %rbp
  80286f:	48 89 e5             	mov    %rsp,%rbp
  802872:	48 83 ec 18          	sub    $0x18,%rsp
  802876:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80287a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802881:	eb 6b                	jmp    8028ee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802886:	48 98                	cltq   
  802888:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80288e:	48 c1 e0 0c          	shl    $0xc,%rax
  802892:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289a:	48 c1 e8 15          	shr    $0x15,%rax
  80289e:	48 89 c2             	mov    %rax,%rdx
  8028a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028a8:	01 00 00 
  8028ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028af:	83 e0 01             	and    $0x1,%eax
  8028b2:	48 85 c0             	test   %rax,%rax
  8028b5:	74 21                	je     8028d8 <fd_alloc+0x6a>
  8028b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8028bf:	48 89 c2             	mov    %rax,%rdx
  8028c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c9:	01 00 00 
  8028cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d0:	83 e0 01             	and    $0x1,%eax
  8028d3:	48 85 c0             	test   %rax,%rax
  8028d6:	75 12                	jne    8028ea <fd_alloc+0x7c>
			*fd_store = fd;
  8028d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028e0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	eb 1a                	jmp    802904 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028ee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028f2:	7e 8f                	jle    802883 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028ff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802904:	c9                   	leaveq 
  802905:	c3                   	retq   

0000000000802906 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802906:	55                   	push   %rbp
  802907:	48 89 e5             	mov    %rsp,%rbp
  80290a:	48 83 ec 20          	sub    $0x20,%rsp
  80290e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802911:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802915:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802919:	78 06                	js     802921 <fd_lookup+0x1b>
  80291b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80291f:	7e 07                	jle    802928 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802921:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802926:	eb 6c                	jmp    802994 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802928:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80292b:	48 98                	cltq   
  80292d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802933:	48 c1 e0 0c          	shl    $0xc,%rax
  802937:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80293b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293f:	48 c1 e8 15          	shr    $0x15,%rax
  802943:	48 89 c2             	mov    %rax,%rdx
  802946:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80294d:	01 00 00 
  802950:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802954:	83 e0 01             	and    $0x1,%eax
  802957:	48 85 c0             	test   %rax,%rax
  80295a:	74 21                	je     80297d <fd_lookup+0x77>
  80295c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802960:	48 c1 e8 0c          	shr    $0xc,%rax
  802964:	48 89 c2             	mov    %rax,%rdx
  802967:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80296e:	01 00 00 
  802971:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802975:	83 e0 01             	and    $0x1,%eax
  802978:	48 85 c0             	test   %rax,%rax
  80297b:	75 07                	jne    802984 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80297d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802982:	eb 10                	jmp    802994 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802984:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802988:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80298c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802994:	c9                   	leaveq 
  802995:	c3                   	retq   

0000000000802996 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802996:	55                   	push   %rbp
  802997:	48 89 e5             	mov    %rsp,%rbp
  80299a:	48 83 ec 30          	sub    $0x30,%rsp
  80299e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029a2:	89 f0                	mov    %esi,%eax
  8029a4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8029a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ab:	48 89 c7             	mov    %rax,%rdi
  8029ae:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029be:	48 89 d6             	mov    %rdx,%rsi
  8029c1:	89 c7                	mov    %eax,%edi
  8029c3:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
  8029cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d6:	78 0a                	js     8029e2 <fd_close+0x4c>
	    || fd != fd2)
  8029d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029dc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029e0:	74 12                	je     8029f4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8029e2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029e6:	74 05                	je     8029ed <fd_close+0x57>
  8029e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029eb:	eb 05                	jmp    8029f2 <fd_close+0x5c>
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	eb 69                	jmp    802a5d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f8:	8b 00                	mov    (%rax),%eax
  8029fa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029fe:	48 89 d6             	mov    %rdx,%rsi
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a16:	78 2a                	js     802a42 <fd_close+0xac>
		if (dev->dev_close)
  802a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a20:	48 85 c0             	test   %rax,%rax
  802a23:	74 16                	je     802a3b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a29:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a2d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a31:	48 89 d7             	mov    %rdx,%rdi
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a39:	eb 07                	jmp    802a42 <fd_close+0xac>
		else
			r = 0;
  802a3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a46:	48 89 c6             	mov    %rax,%rsi
  802a49:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4e:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
	return r;
  802a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a5d:	c9                   	leaveq 
  802a5e:	c3                   	retq   

0000000000802a5f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a5f:	55                   	push   %rbp
  802a60:	48 89 e5             	mov    %rsp,%rbp
  802a63:	48 83 ec 20          	sub    $0x20,%rsp
  802a67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a75:	eb 41                	jmp    802ab8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a77:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a7e:	00 00 00 
  802a81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a84:	48 63 d2             	movslq %edx,%rdx
  802a87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a8b:	8b 00                	mov    (%rax),%eax
  802a8d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a90:	75 22                	jne    802ab4 <dev_lookup+0x55>
			*dev = devtab[i];
  802a92:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a99:	00 00 00 
  802a9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a9f:	48 63 d2             	movslq %edx,%rdx
  802aa2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aaa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	eb 60                	jmp    802b14 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802ab4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ab8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802abf:	00 00 00 
  802ac2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ac5:	48 63 d2             	movslq %edx,%rdx
  802ac8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acc:	48 85 c0             	test   %rax,%rax
  802acf:	75 a6                	jne    802a77 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ad1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ad8:	00 00 00 
  802adb:	48 8b 00             	mov    (%rax),%rax
  802ade:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ae4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ae7:	89 c6                	mov    %eax,%esi
  802ae9:	48 bf 98 49 80 00 00 	movabs $0x804998,%rdi
  802af0:	00 00 00 
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802aff:	00 00 00 
  802b02:	ff d1                	callq  *%rcx
	*dev = 0;
  802b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b14:	c9                   	leaveq 
  802b15:	c3                   	retq   

0000000000802b16 <close>:

int
close(int fdnum)
{
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	48 83 ec 20          	sub    $0x20,%rsp
  802b1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b28:	48 89 d6             	mov    %rdx,%rsi
  802b2b:	89 c7                	mov    %eax,%edi
  802b2d:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
  802b39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b40:	79 05                	jns    802b47 <close+0x31>
		return r;
  802b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b45:	eb 18                	jmp    802b5f <close+0x49>
	else
		return fd_close(fd, 1);
  802b47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4b:	be 01 00 00 00       	mov    $0x1,%esi
  802b50:	48 89 c7             	mov    %rax,%rdi
  802b53:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
}
  802b5f:	c9                   	leaveq 
  802b60:	c3                   	retq   

0000000000802b61 <close_all>:

void
close_all(void)
{
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b70:	eb 15                	jmp    802b87 <close_all+0x26>
		close(i);
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b75:	89 c7                	mov    %eax,%edi
  802b77:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b87:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b8b:	7e e5                	jle    802b72 <close_all+0x11>
		close(i);
}
  802b8d:	c9                   	leaveq 
  802b8e:	c3                   	retq   

0000000000802b8f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b8f:	55                   	push   %rbp
  802b90:	48 89 e5             	mov    %rsp,%rbp
  802b93:	48 83 ec 40          	sub    $0x40,%rsp
  802b97:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b9a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b9d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802ba1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	79 08                	jns    802bc6 <dup+0x37>
		return r;
  802bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc1:	e9 70 01 00 00       	jmpq   802d36 <dup+0x1a7>
	close(newfdnum);
  802bc6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bc9:	89 c7                	mov    %eax,%edi
  802bcb:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802bd7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bda:	48 98                	cltq   
  802bdc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802be2:	48 c1 e0 0c          	shl    $0xc,%rax
  802be6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bee:	48 89 c7             	mov    %rax,%rdi
  802bf1:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  802bf8:	00 00 00 
  802bfb:	ff d0                	callq  *%rax
  802bfd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c05:	48 89 c7             	mov    %rax,%rdi
  802c08:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1c:	48 c1 e8 15          	shr    $0x15,%rax
  802c20:	48 89 c2             	mov    %rax,%rdx
  802c23:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c2a:	01 00 00 
  802c2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c31:	83 e0 01             	and    $0x1,%eax
  802c34:	48 85 c0             	test   %rax,%rax
  802c37:	74 73                	je     802cac <dup+0x11d>
  802c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3d:	48 c1 e8 0c          	shr    $0xc,%rax
  802c41:	48 89 c2             	mov    %rax,%rdx
  802c44:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c4b:	01 00 00 
  802c4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c52:	83 e0 01             	and    $0x1,%eax
  802c55:	48 85 c0             	test   %rax,%rax
  802c58:	74 52                	je     802cac <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5e:	48 c1 e8 0c          	shr    $0xc,%rax
  802c62:	48 89 c2             	mov    %rax,%rdx
  802c65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c6c:	01 00 00 
  802c6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c73:	25 07 0e 00 00       	and    $0xe07,%eax
  802c78:	89 c1                	mov    %eax,%ecx
  802c7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c82:	41 89 c8             	mov    %ecx,%r8d
  802c85:	48 89 d1             	mov    %rdx,%rcx
  802c88:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8d:	48 89 c6             	mov    %rax,%rsi
  802c90:	bf 00 00 00 00       	mov    $0x0,%edi
  802c95:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
  802ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca8:	79 02                	jns    802cac <dup+0x11d>
			goto err;
  802caa:	eb 57                	jmp    802d03 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb0:	48 c1 e8 0c          	shr    $0xc,%rax
  802cb4:	48 89 c2             	mov    %rax,%rdx
  802cb7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cbe:	01 00 00 
  802cc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cc5:	25 07 0e 00 00       	and    $0xe07,%eax
  802cca:	89 c1                	mov    %eax,%ecx
  802ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cd4:	41 89 c8             	mov    %ecx,%r8d
  802cd7:	48 89 d1             	mov    %rdx,%rcx
  802cda:	ba 00 00 00 00       	mov    $0x0,%edx
  802cdf:	48 89 c6             	mov    %rax,%rsi
  802ce2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce7:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
  802cf3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfa:	79 02                	jns    802cfe <dup+0x16f>
		goto err;
  802cfc:	eb 05                	jmp    802d03 <dup+0x174>

	return newfdnum;
  802cfe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d01:	eb 33                	jmp    802d36 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d07:	48 89 c6             	mov    %rax,%rsi
  802d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d0f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1f:	48 89 c6             	mov    %rax,%rsi
  802d22:	bf 00 00 00 00       	mov    $0x0,%edi
  802d27:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
	return r;
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d36:	c9                   	leaveq 
  802d37:	c3                   	retq   

0000000000802d38 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d38:	55                   	push   %rbp
  802d39:	48 89 e5             	mov    %rsp,%rbp
  802d3c:	48 83 ec 40          	sub    $0x40,%rsp
  802d40:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d43:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d47:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d4b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d4f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d52:	48 89 d6             	mov    %rdx,%rsi
  802d55:	89 c7                	mov    %eax,%edi
  802d57:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802d5e:	00 00 00 
  802d61:	ff d0                	callq  *%rax
  802d63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6a:	78 24                	js     802d90 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d70:	8b 00                	mov    (%rax),%eax
  802d72:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d76:	48 89 d6             	mov    %rdx,%rsi
  802d79:	89 c7                	mov    %eax,%edi
  802d7b:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8e:	79 05                	jns    802d95 <read+0x5d>
		return r;
  802d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d93:	eb 76                	jmp    802e0b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d99:	8b 40 08             	mov    0x8(%rax),%eax
  802d9c:	83 e0 03             	and    $0x3,%eax
  802d9f:	83 f8 01             	cmp    $0x1,%eax
  802da2:	75 3a                	jne    802dde <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802da4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802dab:	00 00 00 
  802dae:	48 8b 00             	mov    (%rax),%rax
  802db1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802db7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dba:	89 c6                	mov    %eax,%esi
  802dbc:	48 bf b7 49 80 00 00 	movabs $0x8049b7,%rdi
  802dc3:	00 00 00 
  802dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcb:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802dd2:	00 00 00 
  802dd5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ddc:	eb 2d                	jmp    802e0b <read+0xd3>
	}
	if (!dev->dev_read)
  802dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802de6:	48 85 c0             	test   %rax,%rax
  802de9:	75 07                	jne    802df2 <read+0xba>
		return -E_NOT_SUPP;
  802deb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df0:	eb 19                	jmp    802e0b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dfa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dfe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e02:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e06:	48 89 cf             	mov    %rcx,%rdi
  802e09:	ff d0                	callq  *%rax
}
  802e0b:	c9                   	leaveq 
  802e0c:	c3                   	retq   

0000000000802e0d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e0d:	55                   	push   %rbp
  802e0e:	48 89 e5             	mov    %rsp,%rbp
  802e11:	48 83 ec 30          	sub    $0x30,%rsp
  802e15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e27:	eb 49                	jmp    802e72 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2c:	48 98                	cltq   
  802e2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e32:	48 29 c2             	sub    %rax,%rdx
  802e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e38:	48 63 c8             	movslq %eax,%rcx
  802e3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e3f:	48 01 c1             	add    %rax,%rcx
  802e42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e45:	48 89 ce             	mov    %rcx,%rsi
  802e48:	89 c7                	mov    %eax,%edi
  802e4a:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
  802e56:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e5d:	79 05                	jns    802e64 <readn+0x57>
			return m;
  802e5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e62:	eb 1c                	jmp    802e80 <readn+0x73>
		if (m == 0)
  802e64:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e68:	75 02                	jne    802e6c <readn+0x5f>
			break;
  802e6a:	eb 11                	jmp    802e7d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e6f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e75:	48 98                	cltq   
  802e77:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e7b:	72 ac                	jb     802e29 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802e7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e80:	c9                   	leaveq 
  802e81:	c3                   	retq   

0000000000802e82 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e82:	55                   	push   %rbp
  802e83:	48 89 e5             	mov    %rsp,%rbp
  802e86:	48 83 ec 40          	sub    $0x40,%rsp
  802e8a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e95:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e9c:	48 89 d6             	mov    %rdx,%rsi
  802e9f:	89 c7                	mov    %eax,%edi
  802ea1:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	callq  *%rax
  802ead:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb4:	78 24                	js     802eda <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eba:	8b 00                	mov    (%rax),%eax
  802ebc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ec0:	48 89 d6             	mov    %rdx,%rsi
  802ec3:	89 c7                	mov    %eax,%edi
  802ec5:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
  802ed1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed8:	79 05                	jns    802edf <write+0x5d>
		return r;
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	eb 42                	jmp    802f21 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee3:	8b 40 08             	mov    0x8(%rax),%eax
  802ee6:	83 e0 03             	and    $0x3,%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	75 07                	jne    802ef4 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802eed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef2:	eb 2d                	jmp    802f21 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ef4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802efc:	48 85 c0             	test   %rax,%rax
  802eff:	75 07                	jne    802f08 <write+0x86>
		return -E_NOT_SUPP;
  802f01:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f06:	eb 19                	jmp    802f21 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f10:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f14:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f18:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f1c:	48 89 cf             	mov    %rcx,%rdi
  802f1f:	ff d0                	callq  *%rax
}
  802f21:	c9                   	leaveq 
  802f22:	c3                   	retq   

0000000000802f23 <seek>:

int
seek(int fdnum, off_t offset)
{
  802f23:	55                   	push   %rbp
  802f24:	48 89 e5             	mov    %rsp,%rbp
  802f27:	48 83 ec 18          	sub    $0x18,%rsp
  802f2b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f2e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f31:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f38:	48 89 d6             	mov    %rdx,%rsi
  802f3b:	89 c7                	mov    %eax,%edi
  802f3d:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f50:	79 05                	jns    802f57 <seek+0x34>
		return r;
  802f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f55:	eb 0f                	jmp    802f66 <seek+0x43>
	fd->fd_offset = offset;
  802f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f66:	c9                   	leaveq 
  802f67:	c3                   	retq   

0000000000802f68 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f68:	55                   	push   %rbp
  802f69:	48 89 e5             	mov    %rsp,%rbp
  802f6c:	48 83 ec 30          	sub    $0x30,%rsp
  802f70:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f73:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f7d:	48 89 d6             	mov    %rdx,%rsi
  802f80:	89 c7                	mov    %eax,%edi
  802f82:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
  802f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f95:	78 24                	js     802fbb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9b:	8b 00                	mov    (%rax),%eax
  802f9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fa1:	48 89 d6             	mov    %rdx,%rsi
  802fa4:	89 c7                	mov    %eax,%edi
  802fa6:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  802fad:	00 00 00 
  802fb0:	ff d0                	callq  *%rax
  802fb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb9:	79 05                	jns    802fc0 <ftruncate+0x58>
		return r;
  802fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbe:	eb 72                	jmp    803032 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc4:	8b 40 08             	mov    0x8(%rax),%eax
  802fc7:	83 e0 03             	and    $0x3,%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	75 3a                	jne    803008 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802fd5:	00 00 00 
  802fd8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fdb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fe1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fe4:	89 c6                	mov    %eax,%esi
  802fe6:	48 bf d8 49 80 00 00 	movabs $0x8049d8,%rdi
  802fed:	00 00 00 
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff5:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802ffc:	00 00 00 
  802fff:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803001:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803006:	eb 2a                	jmp    803032 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300c:	48 8b 40 30          	mov    0x30(%rax),%rax
  803010:	48 85 c0             	test   %rax,%rax
  803013:	75 07                	jne    80301c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803015:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80301a:	eb 16                	jmp    803032 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80301c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803020:	48 8b 40 30          	mov    0x30(%rax),%rax
  803024:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803028:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80302b:	89 ce                	mov    %ecx,%esi
  80302d:	48 89 d7             	mov    %rdx,%rdi
  803030:	ff d0                	callq  *%rax
}
  803032:	c9                   	leaveq 
  803033:	c3                   	retq   

0000000000803034 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803034:	55                   	push   %rbp
  803035:	48 89 e5             	mov    %rsp,%rbp
  803038:	48 83 ec 30          	sub    $0x30,%rsp
  80303c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80303f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803043:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803047:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80304a:	48 89 d6             	mov    %rdx,%rsi
  80304d:	89 c7                	mov    %eax,%edi
  80304f:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
  80305b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803062:	78 24                	js     803088 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803068:	8b 00                	mov    (%rax),%eax
  80306a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80306e:	48 89 d6             	mov    %rdx,%rsi
  803071:	89 c7                	mov    %eax,%edi
  803073:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  80307a:	00 00 00 
  80307d:	ff d0                	callq  *%rax
  80307f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803086:	79 05                	jns    80308d <fstat+0x59>
		return r;
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308b:	eb 5e                	jmp    8030eb <fstat+0xb7>
	if (!dev->dev_stat)
  80308d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803091:	48 8b 40 28          	mov    0x28(%rax),%rax
  803095:	48 85 c0             	test   %rax,%rax
  803098:	75 07                	jne    8030a1 <fstat+0x6d>
		return -E_NOT_SUPP;
  80309a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80309f:	eb 4a                	jmp    8030eb <fstat+0xb7>
	stat->st_name[0] = 0;
  8030a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8030a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ac:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8030b3:	00 00 00 
	stat->st_isdir = 0;
  8030b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030c1:	00 00 00 
	stat->st_dev = dev;
  8030c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030df:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030e3:	48 89 ce             	mov    %rcx,%rsi
  8030e6:	48 89 d7             	mov    %rdx,%rdi
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 20          	sub    $0x20,%rsp
  8030f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803101:	be 00 00 00 00       	mov    $0x0,%esi
  803106:	48 89 c7             	mov    %rax,%rdi
  803109:	48 b8 db 31 80 00 00 	movabs $0x8031db,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803118:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311c:	79 05                	jns    803123 <stat+0x36>
		return fd;
  80311e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803121:	eb 2f                	jmp    803152 <stat+0x65>
	r = fstat(fd, stat);
  803123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	48 89 d6             	mov    %rdx,%rsi
  80312d:	89 c7                	mov    %eax,%edi
  80312f:	48 b8 34 30 80 00 00 	movabs $0x803034,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80313e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803141:	89 c7                	mov    %eax,%edi
  803143:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
	return r;
  80314f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803152:	c9                   	leaveq 
  803153:	c3                   	retq   

0000000000803154 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 10          	sub    $0x10,%rsp
  80315c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80315f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803163:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80316a:	00 00 00 
  80316d:	8b 00                	mov    (%rax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	75 1d                	jne    803190 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803173:	bf 01 00 00 00       	mov    $0x1,%edi
  803178:	48 b8 ae 27 80 00 00 	movabs $0x8027ae,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
  803184:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80318b:	00 00 00 
  80318e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803190:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803197:	00 00 00 
  80319a:	8b 00                	mov    (%rax),%eax
  80319c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80319f:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031a4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8031ab:	00 00 00 
  8031ae:	89 c7                	mov    %eax,%edi
  8031b0:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c5:	48 89 c6             	mov    %rax,%rsi
  8031c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8031cd:	48 b8 28 26 80 00 00 	movabs $0x802628,%rax
  8031d4:	00 00 00 
  8031d7:	ff d0                	callq  *%rax
}
  8031d9:	c9                   	leaveq 
  8031da:	c3                   	retq   

00000000008031db <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031db:	55                   	push   %rbp
  8031dc:	48 89 e5             	mov    %rsp,%rbp
  8031df:	48 83 ec 30          	sub    $0x30,%rsp
  8031e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031e7:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8031ea:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8031f1:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8031f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8031ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803204:	75 08                	jne    80320e <open+0x33>
	{
		return r;
  803206:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803209:	e9 f2 00 00 00       	jmpq   803300 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80320e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803212:	48 89 c7             	mov    %rax,%rdi
  803215:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
  803221:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803224:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80322b:	7e 0a                	jle    803237 <open+0x5c>
	{
		return -E_BAD_PATH;
  80322d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803232:	e9 c9 00 00 00       	jmpq   803300 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  803237:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80323e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80323f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803243:	48 89 c7             	mov    %rax,%rdi
  803246:	48 b8 6e 28 80 00 00 	movabs $0x80286e,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
  803252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803259:	78 09                	js     803264 <open+0x89>
  80325b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325f:	48 85 c0             	test   %rax,%rax
  803262:	75 08                	jne    80326c <open+0x91>
		{
			return r;
  803264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803267:	e9 94 00 00 00       	jmpq   803300 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80326c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803270:	ba 00 04 00 00       	mov    $0x400,%edx
  803275:	48 89 c6             	mov    %rax,%rsi
  803278:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80327f:	00 00 00 
  803282:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80328e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803295:	00 00 00 
  803298:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80329b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8032a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a5:	48 89 c6             	mov    %rax,%rsi
  8032a8:	bf 01 00 00 00       	mov    $0x1,%edi
  8032ad:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
  8032b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c0:	79 2b                	jns    8032ed <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8032c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c6:	be 00 00 00 00       	mov    $0x0,%esi
  8032cb:	48 89 c7             	mov    %rax,%rdi
  8032ce:	48 b8 96 29 80 00 00 	movabs $0x802996,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032e1:	79 05                	jns    8032e8 <open+0x10d>
			{
				return d;
  8032e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032e6:	eb 18                	jmp    803300 <open+0x125>
			}
			return r;
  8032e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032eb:	eb 13                	jmp    803300 <open+0x125>
		}	
		return fd2num(fd_store);
  8032ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f1:	48 89 c7             	mov    %rax,%rdi
  8032f4:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803300:	c9                   	leaveq 
  803301:	c3                   	retq   

0000000000803302 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803302:	55                   	push   %rbp
  803303:	48 89 e5             	mov    %rsp,%rbp
  803306:	48 83 ec 10          	sub    $0x10,%rsp
  80330a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80330e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803312:	8b 50 0c             	mov    0xc(%rax),%edx
  803315:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80331c:	00 00 00 
  80331f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803321:	be 00 00 00 00       	mov    $0x0,%esi
  803326:	bf 06 00 00 00       	mov    $0x6,%edi
  80332b:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
}
  803337:	c9                   	leaveq 
  803338:	c3                   	retq   

0000000000803339 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803339:	55                   	push   %rbp
  80333a:	48 89 e5             	mov    %rsp,%rbp
  80333d:	48 83 ec 30          	sub    $0x30,%rsp
  803341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803349:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80334d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803354:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803359:	74 07                	je     803362 <devfile_read+0x29>
  80335b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803360:	75 07                	jne    803369 <devfile_read+0x30>
		return -E_INVAL;
  803362:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803367:	eb 77                	jmp    8033e0 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336d:	8b 50 0c             	mov    0xc(%rax),%edx
  803370:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803377:	00 00 00 
  80337a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80337c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803383:	00 00 00 
  803386:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80338a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80338e:	be 00 00 00 00       	mov    $0x0,%esi
  803393:	bf 03 00 00 00       	mov    $0x3,%edi
  803398:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
  8033a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ab:	7f 05                	jg     8033b2 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b0:	eb 2e                	jmp    8033e0 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8033b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b5:	48 63 d0             	movslq %eax,%rdx
  8033b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8033c3:	00 00 00 
  8033c6:	48 89 c7             	mov    %rax,%rdi
  8033c9:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8033d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8033e0:	c9                   	leaveq 
  8033e1:	c3                   	retq   

00000000008033e2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8033e2:	55                   	push   %rbp
  8033e3:	48 89 e5             	mov    %rsp,%rbp
  8033e6:	48 83 ec 30          	sub    $0x30,%rsp
  8033ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8033f6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8033fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803402:	74 07                	je     80340b <devfile_write+0x29>
  803404:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803409:	75 08                	jne    803413 <devfile_write+0x31>
		return r;
  80340b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340e:	e9 9a 00 00 00       	jmpq   8034ad <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803417:	8b 50 0c             	mov    0xc(%rax),%edx
  80341a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803421:	00 00 00 
  803424:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803426:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80342d:	00 
  80342e:	76 08                	jbe    803438 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803430:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803437:	00 
	}
	fsipcbuf.write.req_n = n;
  803438:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80343f:	00 00 00 
  803442:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803446:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80344a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80344e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803452:	48 89 c6             	mov    %rax,%rsi
  803455:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80345c:	00 00 00 
  80345f:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80346b:	be 00 00 00 00       	mov    $0x0,%esi
  803470:	bf 04 00 00 00       	mov    $0x4,%edi
  803475:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803488:	7f 20                	jg     8034aa <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80348a:	48 bf fe 49 80 00 00 	movabs $0x8049fe,%rdi
  803491:	00 00 00 
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8034a0:	00 00 00 
  8034a3:	ff d2                	callq  *%rdx
		return r;
  8034a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a8:	eb 03                	jmp    8034ad <devfile_write+0xcb>
	}
	return r;
  8034aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8034ad:	c9                   	leaveq 
  8034ae:	c3                   	retq   

00000000008034af <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034af:	55                   	push   %rbp
  8034b0:	48 89 e5             	mov    %rsp,%rbp
  8034b3:	48 83 ec 20          	sub    $0x20,%rsp
  8034b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8034bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034cd:	00 00 00 
  8034d0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8034d2:	be 00 00 00 00       	mov    $0x0,%esi
  8034d7:	bf 05 00 00 00       	mov    $0x5,%edi
  8034dc:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
  8034e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ef:	79 05                	jns    8034f6 <devfile_stat+0x47>
		return r;
  8034f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f4:	eb 56                	jmp    80354c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803501:	00 00 00 
  803504:	48 89 c7             	mov    %rax,%rdi
  803507:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803513:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80351a:	00 00 00 
  80351d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803527:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80352d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803534:	00 00 00 
  803537:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80353d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803541:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803547:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80354c:	c9                   	leaveq 
  80354d:	c3                   	retq   

000000000080354e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80354e:	55                   	push   %rbp
  80354f:	48 89 e5             	mov    %rsp,%rbp
  803552:	48 83 ec 10          	sub    $0x10,%rsp
  803556:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80355a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80355d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803561:	8b 50 0c             	mov    0xc(%rax),%edx
  803564:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80356b:	00 00 00 
  80356e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803570:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803577:	00 00 00 
  80357a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80357d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803580:	be 00 00 00 00       	mov    $0x0,%esi
  803585:	bf 02 00 00 00       	mov    $0x2,%edi
  80358a:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
}
  803596:	c9                   	leaveq 
  803597:	c3                   	retq   

0000000000803598 <remove>:

// Delete a file
int
remove(const char *path)
{
  803598:	55                   	push   %rbp
  803599:	48 89 e5             	mov    %rsp,%rbp
  80359c:	48 83 ec 10          	sub    $0x10,%rsp
  8035a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8035a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a8:	48 89 c7             	mov    %rax,%rdi
  8035ab:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035bc:	7e 07                	jle    8035c5 <remove+0x2d>
		return -E_BAD_PATH;
  8035be:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8035c3:	eb 33                	jmp    8035f8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8035c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c9:	48 89 c6             	mov    %rax,%rsi
  8035cc:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8035d3:	00 00 00 
  8035d6:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8035dd:	00 00 00 
  8035e0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8035e2:	be 00 00 00 00       	mov    $0x0,%esi
  8035e7:	bf 07 00 00 00       	mov    $0x7,%edi
  8035ec:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
}
  8035f8:	c9                   	leaveq 
  8035f9:	c3                   	retq   

00000000008035fa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8035fa:	55                   	push   %rbp
  8035fb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035fe:	be 00 00 00 00       	mov    $0x0,%esi
  803603:	bf 08 00 00 00       	mov    $0x8,%edi
  803608:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
}
  803614:	5d                   	pop    %rbp
  803615:	c3                   	retq   

0000000000803616 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803616:	55                   	push   %rbp
  803617:	48 89 e5             	mov    %rsp,%rbp
  80361a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803621:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803628:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80362f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803636:	be 00 00 00 00       	mov    $0x0,%esi
  80363b:	48 89 c7             	mov    %rax,%rdi
  80363e:	48 b8 db 31 80 00 00 	movabs $0x8031db,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	79 28                	jns    80367b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	89 c6                	mov    %eax,%esi
  803658:	48 bf 1a 4a 80 00 00 	movabs $0x804a1a,%rdi
  80365f:	00 00 00 
  803662:	b8 00 00 00 00       	mov    $0x0,%eax
  803667:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80366e:	00 00 00 
  803671:	ff d2                	callq  *%rdx
		return fd_src;
  803673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803676:	e9 74 01 00 00       	jmpq   8037ef <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80367b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803682:	be 01 01 00 00       	mov    $0x101,%esi
  803687:	48 89 c7             	mov    %rax,%rdi
  80368a:	48 b8 db 31 80 00 00 	movabs $0x8031db,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803699:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80369d:	79 39                	jns    8036d8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80369f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a2:	89 c6                	mov    %eax,%esi
  8036a4:	48 bf 30 4a 80 00 00 	movabs $0x804a30,%rdi
  8036ab:	00 00 00 
  8036ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b3:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8036ba:	00 00 00 
  8036bd:	ff d2                	callq  *%rdx
		close(fd_src);
  8036bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
		return fd_dest;
  8036d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d3:	e9 17 01 00 00       	jmpq   8037ef <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8036d8:	eb 74                	jmp    80374e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8036da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036dd:	48 63 d0             	movslq %eax,%rdx
  8036e0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ea:	48 89 ce             	mov    %rcx,%rsi
  8036ed:	89 c7                	mov    %eax,%edi
  8036ef:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8036fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803702:	79 4a                	jns    80374e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803704:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803707:	89 c6                	mov    %eax,%esi
  803709:	48 bf 4a 4a 80 00 00 	movabs $0x804a4a,%rdi
  803710:	00 00 00 
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
  803718:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80371f:	00 00 00 
  803722:	ff d2                	callq  *%rdx
			close(fd_src);
  803724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803727:	89 c7                	mov    %eax,%edi
  803729:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  803730:	00 00 00 
  803733:	ff d0                	callq  *%rax
			close(fd_dest);
  803735:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803738:	89 c7                	mov    %eax,%edi
  80373a:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
			return write_size;
  803746:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803749:	e9 a1 00 00 00       	jmpq   8037ef <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80374e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803755:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803758:	ba 00 02 00 00       	mov    $0x200,%edx
  80375d:	48 89 ce             	mov    %rcx,%rsi
  803760:	89 c7                	mov    %eax,%edi
  803762:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  803769:	00 00 00 
  80376c:	ff d0                	callq  *%rax
  80376e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803771:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803775:	0f 8f 5f ff ff ff    	jg     8036da <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80377b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80377f:	79 47                	jns    8037c8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803781:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803784:	89 c6                	mov    %eax,%esi
  803786:	48 bf 5d 4a 80 00 00 	movabs $0x804a5d,%rdi
  80378d:	00 00 00 
  803790:	b8 00 00 00 00       	mov    $0x0,%eax
  803795:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80379c:	00 00 00 
  80379f:	ff d2                	callq  *%rdx
		close(fd_src);
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	89 c7                	mov    %eax,%edi
  8037a6:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
		close(fd_dest);
  8037b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b5:	89 c7                	mov    %eax,%edi
  8037b7:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8037be:	00 00 00 
  8037c1:	ff d0                	callq  *%rax
		return read_size;
  8037c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c6:	eb 27                	jmp    8037ef <copy+0x1d9>
	}
	close(fd_src);
  8037c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cb:	89 c7                	mov    %eax,%edi
  8037cd:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
	close(fd_dest);
  8037d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037dc:	89 c7                	mov    %eax,%edi
  8037de:	48 b8 16 2b 80 00 00 	movabs $0x802b16,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
	return 0;
  8037ea:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
  8037f5:	48 83 ec 18          	sub    $0x18,%rsp
  8037f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8037fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803801:	48 c1 e8 15          	shr    $0x15,%rax
  803805:	48 89 c2             	mov    %rax,%rdx
  803808:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80380f:	01 00 00 
  803812:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803816:	83 e0 01             	and    $0x1,%eax
  803819:	48 85 c0             	test   %rax,%rax
  80381c:	75 07                	jne    803825 <pageref+0x34>
		return 0;
  80381e:	b8 00 00 00 00       	mov    $0x0,%eax
  803823:	eb 53                	jmp    803878 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803829:	48 c1 e8 0c          	shr    $0xc,%rax
  80382d:	48 89 c2             	mov    %rax,%rdx
  803830:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803837:	01 00 00 
  80383a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80383e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803842:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803846:	83 e0 01             	and    $0x1,%eax
  803849:	48 85 c0             	test   %rax,%rax
  80384c:	75 07                	jne    803855 <pageref+0x64>
		return 0;
  80384e:	b8 00 00 00 00       	mov    $0x0,%eax
  803853:	eb 23                	jmp    803878 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803859:	48 c1 e8 0c          	shr    $0xc,%rax
  80385d:	48 89 c2             	mov    %rax,%rdx
  803860:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803867:	00 00 00 
  80386a:	48 c1 e2 04          	shl    $0x4,%rdx
  80386e:	48 01 d0             	add    %rdx,%rax
  803871:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803875:	0f b7 c0             	movzwl %ax,%eax
}
  803878:	c9                   	leaveq 
  803879:	c3                   	retq   

000000000080387a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80387a:	55                   	push   %rbp
  80387b:	48 89 e5             	mov    %rsp,%rbp
  80387e:	53                   	push   %rbx
  80387f:	48 83 ec 38          	sub    $0x38,%rsp
  803883:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803887:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80388b:	48 89 c7             	mov    %rax,%rdi
  80388e:	48 b8 6e 28 80 00 00 	movabs $0x80286e,%rax
  803895:	00 00 00 
  803898:	ff d0                	callq  *%rax
  80389a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80389d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a1:	0f 88 bf 01 00 00    	js     803a66 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8038b0:	48 89 c6             	mov    %rax,%rsi
  8038b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b8:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
  8038c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038cb:	0f 88 95 01 00 00    	js     803a66 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038d1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038d5:	48 89 c7             	mov    %rax,%rdi
  8038d8:	48 b8 6e 28 80 00 00 	movabs $0x80286e,%rax
  8038df:	00 00 00 
  8038e2:	ff d0                	callq  *%rax
  8038e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038eb:	0f 88 5d 01 00 00    	js     803a4e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f5:	ba 07 04 00 00       	mov    $0x407,%edx
  8038fa:	48 89 c6             	mov    %rax,%rsi
  8038fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803902:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803909:	00 00 00 
  80390c:	ff d0                	callq  *%rax
  80390e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803911:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803915:	0f 88 33 01 00 00    	js     803a4e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80391b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391f:	48 89 c7             	mov    %rax,%rdi
  803922:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803932:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803936:	ba 07 04 00 00       	mov    $0x407,%edx
  80393b:	48 89 c6             	mov    %rax,%rsi
  80393e:	bf 00 00 00 00       	mov    $0x0,%edi
  803943:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	callq  *%rax
  80394f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803952:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803956:	79 05                	jns    80395d <pipe+0xe3>
		goto err2;
  803958:	e9 d9 00 00 00       	jmpq   803a36 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80395d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803961:	48 89 c7             	mov    %rax,%rdi
  803964:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
  803970:	48 89 c2             	mov    %rax,%rdx
  803973:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803977:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80397d:	48 89 d1             	mov    %rdx,%rcx
  803980:	ba 00 00 00 00       	mov    $0x0,%edx
  803985:	48 89 c6             	mov    %rax,%rsi
  803988:	bf 00 00 00 00       	mov    $0x0,%edi
  80398d:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
  803999:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80399c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a0:	79 1b                	jns    8039bd <pipe+0x143>
		goto err3;
  8039a2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8039a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a7:	48 89 c6             	mov    %rax,%rsi
  8039aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8039af:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	eb 79                	jmp    803a36 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039c8:	00 00 00 
  8039cb:	8b 12                	mov    (%rdx),%edx
  8039cd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8039cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039de:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039e5:	00 00 00 
  8039e8:	8b 12                	mov    (%rdx),%edx
  8039ea:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8039ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
  803a0a:	89 c2                	mov    %eax,%edx
  803a0c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a10:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a16:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a1e:	48 89 c7             	mov    %rax,%rdi
  803a21:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
  803a2d:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a34:	eb 33                	jmp    803a69 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803a36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a3a:	48 89 c6             	mov    %rax,%rsi
  803a3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a42:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a52:	48 89 c6             	mov    %rax,%rsi
  803a55:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5a:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
err:
	return r;
  803a66:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a69:	48 83 c4 38          	add    $0x38,%rsp
  803a6d:	5b                   	pop    %rbx
  803a6e:	5d                   	pop    %rbp
  803a6f:	c3                   	retq   

0000000000803a70 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a70:	55                   	push   %rbp
  803a71:	48 89 e5             	mov    %rsp,%rbp
  803a74:	53                   	push   %rbx
  803a75:	48 83 ec 28          	sub    $0x28,%rsp
  803a79:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a7d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a81:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a88:	00 00 00 
  803a8b:	48 8b 00             	mov    (%rax),%rax
  803a8e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a94:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9b:	48 89 c7             	mov    %rax,%rdi
  803a9e:	48 b8 f1 37 80 00 00 	movabs $0x8037f1,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
  803aaa:	89 c3                	mov    %eax,%ebx
  803aac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab0:	48 89 c7             	mov    %rax,%rdi
  803ab3:	48 b8 f1 37 80 00 00 	movabs $0x8037f1,%rax
  803aba:	00 00 00 
  803abd:	ff d0                	callq  *%rax
  803abf:	39 c3                	cmp    %eax,%ebx
  803ac1:	0f 94 c0             	sete   %al
  803ac4:	0f b6 c0             	movzbl %al,%eax
  803ac7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803aca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ad1:	00 00 00 
  803ad4:	48 8b 00             	mov    (%rax),%rax
  803ad7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803add:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ae0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ae6:	75 05                	jne    803aed <_pipeisclosed+0x7d>
			return ret;
  803ae8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803aeb:	eb 4f                	jmp    803b3c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803aed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803af3:	74 42                	je     803b37 <_pipeisclosed+0xc7>
  803af5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803af9:	75 3c                	jne    803b37 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803afb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b02:	00 00 00 
  803b05:	48 8b 00             	mov    (%rax),%rax
  803b08:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b0e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b14:	89 c6                	mov    %eax,%esi
  803b16:	48 bf 7d 4a 80 00 00 	movabs $0x804a7d,%rdi
  803b1d:	00 00 00 
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	49 b8 64 06 80 00 00 	movabs $0x800664,%r8
  803b2c:	00 00 00 
  803b2f:	41 ff d0             	callq  *%r8
	}
  803b32:	e9 4a ff ff ff       	jmpq   803a81 <_pipeisclosed+0x11>
  803b37:	e9 45 ff ff ff       	jmpq   803a81 <_pipeisclosed+0x11>
}
  803b3c:	48 83 c4 28          	add    $0x28,%rsp
  803b40:	5b                   	pop    %rbx
  803b41:	5d                   	pop    %rbp
  803b42:	c3                   	retq   

0000000000803b43 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803b43:	55                   	push   %rbp
  803b44:	48 89 e5             	mov    %rsp,%rbp
  803b47:	48 83 ec 30          	sub    $0x30,%rsp
  803b4b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b4e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b52:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b55:	48 89 d6             	mov    %rdx,%rsi
  803b58:	89 c7                	mov    %eax,%edi
  803b5a:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
  803b66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6d:	79 05                	jns    803b74 <pipeisclosed+0x31>
		return r;
  803b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b72:	eb 31                	jmp    803ba5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b78:	48 89 c7             	mov    %rax,%rdi
  803b7b:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803b82:	00 00 00 
  803b85:	ff d0                	callq  *%rax
  803b87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b93:	48 89 d6             	mov    %rdx,%rsi
  803b96:	48 89 c7             	mov    %rax,%rdi
  803b99:	48 b8 70 3a 80 00 00 	movabs $0x803a70,%rax
  803ba0:	00 00 00 
  803ba3:	ff d0                	callq  *%rax
}
  803ba5:	c9                   	leaveq 
  803ba6:	c3                   	retq   

0000000000803ba7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ba7:	55                   	push   %rbp
  803ba8:	48 89 e5             	mov    %rsp,%rbp
  803bab:	48 83 ec 40          	sub    $0x40,%rsp
  803baf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bb3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bb7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803bbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bbf:	48 89 c7             	mov    %rax,%rdi
  803bc2:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
  803bce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bda:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803be1:	00 
  803be2:	e9 92 00 00 00       	jmpq   803c79 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803be7:	eb 41                	jmp    803c2a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803be9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803bee:	74 09                	je     803bf9 <devpipe_read+0x52>
				return i;
  803bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf4:	e9 92 00 00 00       	jmpq   803c8b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c01:	48 89 d6             	mov    %rdx,%rsi
  803c04:	48 89 c7             	mov    %rax,%rdi
  803c07:	48 b8 70 3a 80 00 00 	movabs $0x803a70,%rax
  803c0e:	00 00 00 
  803c11:	ff d0                	callq  *%rax
  803c13:	85 c0                	test   %eax,%eax
  803c15:	74 07                	je     803c1e <devpipe_read+0x77>
				return 0;
  803c17:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1c:	eb 6d                	jmp    803c8b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c1e:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2e:	8b 10                	mov    (%rax),%edx
  803c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c34:	8b 40 04             	mov    0x4(%rax),%eax
  803c37:	39 c2                	cmp    %eax,%edx
  803c39:	74 ae                	je     803be9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c43:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4b:	8b 00                	mov    (%rax),%eax
  803c4d:	99                   	cltd   
  803c4e:	c1 ea 1b             	shr    $0x1b,%edx
  803c51:	01 d0                	add    %edx,%eax
  803c53:	83 e0 1f             	and    $0x1f,%eax
  803c56:	29 d0                	sub    %edx,%eax
  803c58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c5c:	48 98                	cltq   
  803c5e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803c63:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c69:	8b 00                	mov    (%rax),%eax
  803c6b:	8d 50 01             	lea    0x1(%rax),%edx
  803c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c72:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c74:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c81:	0f 82 60 ff ff ff    	jb     803be7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c8b:	c9                   	leaveq 
  803c8c:	c3                   	retq   

0000000000803c8d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c8d:	55                   	push   %rbp
  803c8e:	48 89 e5             	mov    %rsp,%rbp
  803c91:	48 83 ec 40          	sub    $0x40,%rsp
  803c95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c9d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ca1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca5:	48 89 c7             	mov    %rax,%rdi
  803ca8:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803caf:	00 00 00 
  803cb2:	ff d0                	callq  *%rax
  803cb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cc0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cc7:	00 
  803cc8:	e9 8e 00 00 00       	jmpq   803d5b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ccd:	eb 31                	jmp    803d00 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ccf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd7:	48 89 d6             	mov    %rdx,%rsi
  803cda:	48 89 c7             	mov    %rax,%rdi
  803cdd:	48 b8 70 3a 80 00 00 	movabs $0x803a70,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 07                	je     803cf4 <devpipe_write+0x67>
				return 0;
  803ced:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf2:	eb 79                	jmp    803d6d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803cf4:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803cfb:	00 00 00 
  803cfe:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d04:	8b 40 04             	mov    0x4(%rax),%eax
  803d07:	48 63 d0             	movslq %eax,%rdx
  803d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0e:	8b 00                	mov    (%rax),%eax
  803d10:	48 98                	cltq   
  803d12:	48 83 c0 20          	add    $0x20,%rax
  803d16:	48 39 c2             	cmp    %rax,%rdx
  803d19:	73 b4                	jae    803ccf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1f:	8b 40 04             	mov    0x4(%rax),%eax
  803d22:	99                   	cltd   
  803d23:	c1 ea 1b             	shr    $0x1b,%edx
  803d26:	01 d0                	add    %edx,%eax
  803d28:	83 e0 1f             	and    $0x1f,%eax
  803d2b:	29 d0                	sub    %edx,%eax
  803d2d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d31:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d35:	48 01 ca             	add    %rcx,%rdx
  803d38:	0f b6 0a             	movzbl (%rdx),%ecx
  803d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d3f:	48 98                	cltq   
  803d41:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d49:	8b 40 04             	mov    0x4(%rax),%eax
  803d4c:	8d 50 01             	lea    0x1(%rax),%edx
  803d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d53:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d56:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d5f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d63:	0f 82 64 ff ff ff    	jb     803ccd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d6d:	c9                   	leaveq 
  803d6e:	c3                   	retq   

0000000000803d6f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d6f:	55                   	push   %rbp
  803d70:	48 89 e5             	mov    %rsp,%rbp
  803d73:	48 83 ec 20          	sub    $0x20,%rsp
  803d77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d83:	48 89 c7             	mov    %rax,%rdi
  803d86:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803d8d:	00 00 00 
  803d90:	ff d0                	callq  *%rax
  803d92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d9a:	48 be 90 4a 80 00 00 	movabs $0x804a90,%rsi
  803da1:	00 00 00 
  803da4:	48 89 c7             	mov    %rax,%rdi
  803da7:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db7:	8b 50 04             	mov    0x4(%rax),%edx
  803dba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dbe:	8b 00                	mov    (%rax),%eax
  803dc0:	29 c2                	sub    %eax,%edx
  803dc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803dcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803dd7:	00 00 00 
	stat->st_dev = &devpipe;
  803dda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dde:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803de5:	00 00 00 
  803de8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803df4:	c9                   	leaveq 
  803df5:	c3                   	retq   

0000000000803df6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803df6:	55                   	push   %rbp
  803df7:	48 89 e5             	mov    %rsp,%rbp
  803dfa:	48 83 ec 10          	sub    $0x10,%rsp
  803dfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e06:	48 89 c6             	mov    %rax,%rsi
  803e09:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0e:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e1e:	48 89 c7             	mov    %rax,%rdi
  803e21:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  803e28:	00 00 00 
  803e2b:	ff d0                	callq  *%rax
  803e2d:	48 89 c6             	mov    %rax,%rsi
  803e30:	bf 00 00 00 00       	mov    $0x0,%edi
  803e35:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803e3c:	00 00 00 
  803e3f:	ff d0                	callq  *%rax
}
  803e41:	c9                   	leaveq 
  803e42:	c3                   	retq   

0000000000803e43 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e43:	55                   	push   %rbp
  803e44:	48 89 e5             	mov    %rsp,%rbp
  803e47:	48 83 ec 20          	sub    $0x20,%rsp
  803e4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e51:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803e54:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803e58:	be 01 00 00 00       	mov    $0x1,%esi
  803e5d:	48 89 c7             	mov    %rax,%rdi
  803e60:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
}
  803e6c:	c9                   	leaveq 
  803e6d:	c3                   	retq   

0000000000803e6e <getchar>:

int
getchar(void)
{
  803e6e:	55                   	push   %rbp
  803e6f:	48 89 e5             	mov    %rsp,%rbp
  803e72:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e76:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e7a:	ba 01 00 00 00       	mov    $0x1,%edx
  803e7f:	48 89 c6             	mov    %rax,%rsi
  803e82:	bf 00 00 00 00       	mov    $0x0,%edi
  803e87:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  803e8e:	00 00 00 
  803e91:	ff d0                	callq  *%rax
  803e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e9a:	79 05                	jns    803ea1 <getchar+0x33>
		return r;
  803e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e9f:	eb 14                	jmp    803eb5 <getchar+0x47>
	if (r < 1)
  803ea1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea5:	7f 07                	jg     803eae <getchar+0x40>
		return -E_EOF;
  803ea7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803eac:	eb 07                	jmp    803eb5 <getchar+0x47>
	return c;
  803eae:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803eb2:	0f b6 c0             	movzbl %al,%eax
}
  803eb5:	c9                   	leaveq 
  803eb6:	c3                   	retq   

0000000000803eb7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803eb7:	55                   	push   %rbp
  803eb8:	48 89 e5             	mov    %rsp,%rbp
  803ebb:	48 83 ec 20          	sub    $0x20,%rsp
  803ebf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ec2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ec6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec9:	48 89 d6             	mov    %rdx,%rsi
  803ecc:	89 c7                	mov    %eax,%edi
  803ece:	48 b8 06 29 80 00 00 	movabs $0x802906,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
  803eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee1:	79 05                	jns    803ee8 <iscons+0x31>
		return r;
  803ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee6:	eb 1a                	jmp    803f02 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eec:	8b 10                	mov    (%rax),%edx
  803eee:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803ef5:	00 00 00 
  803ef8:	8b 00                	mov    (%rax),%eax
  803efa:	39 c2                	cmp    %eax,%edx
  803efc:	0f 94 c0             	sete   %al
  803eff:	0f b6 c0             	movzbl %al,%eax
}
  803f02:	c9                   	leaveq 
  803f03:	c3                   	retq   

0000000000803f04 <opencons>:

int
opencons(void)
{
  803f04:	55                   	push   %rbp
  803f05:	48 89 e5             	mov    %rsp,%rbp
  803f08:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f0c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f10:	48 89 c7             	mov    %rax,%rdi
  803f13:	48 b8 6e 28 80 00 00 	movabs $0x80286e,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
  803f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f26:	79 05                	jns    803f2d <opencons+0x29>
		return r;
  803f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f2b:	eb 5b                	jmp    803f88 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f31:	ba 07 04 00 00       	mov    $0x407,%edx
  803f36:	48 89 c6             	mov    %rax,%rsi
  803f39:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3e:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803f45:	00 00 00 
  803f48:	ff d0                	callq  *%rax
  803f4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f51:	79 05                	jns    803f58 <opencons+0x54>
		return r;
  803f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f56:	eb 30                	jmp    803f88 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803f58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5c:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803f63:	00 00 00 
  803f66:	8b 12                	mov    (%rdx),%edx
  803f68:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f79:	48 89 c7             	mov    %rax,%rdi
  803f7c:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  803f83:	00 00 00 
  803f86:	ff d0                	callq  *%rax
}
  803f88:	c9                   	leaveq 
  803f89:	c3                   	retq   

0000000000803f8a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f8a:	55                   	push   %rbp
  803f8b:	48 89 e5             	mov    %rsp,%rbp
  803f8e:	48 83 ec 30          	sub    $0x30,%rsp
  803f92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f9a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f9e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fa3:	75 07                	jne    803fac <devcons_read+0x22>
		return 0;
  803fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  803faa:	eb 4b                	jmp    803ff7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803fac:	eb 0c                	jmp    803fba <devcons_read+0x30>
		sys_yield();
  803fae:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803fb5:	00 00 00 
  803fb8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fba:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
  803fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcd:	74 df                	je     803fae <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd3:	79 05                	jns    803fda <devcons_read+0x50>
		return c;
  803fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd8:	eb 1d                	jmp    803ff7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803fda:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803fde:	75 07                	jne    803fe7 <devcons_read+0x5d>
		return 0;
  803fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe5:	eb 10                	jmp    803ff7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fea:	89 c2                	mov    %eax,%edx
  803fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ff0:	88 10                	mov    %dl,(%rax)
	return 1;
  803ff2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ff7:	c9                   	leaveq 
  803ff8:	c3                   	retq   

0000000000803ff9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ff9:	55                   	push   %rbp
  803ffa:	48 89 e5             	mov    %rsp,%rbp
  803ffd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804004:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80400b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804012:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804019:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804020:	eb 76                	jmp    804098 <devcons_write+0x9f>
		m = n - tot;
  804022:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804029:	89 c2                	mov    %eax,%edx
  80402b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402e:	29 c2                	sub    %eax,%edx
  804030:	89 d0                	mov    %edx,%eax
  804032:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804035:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804038:	83 f8 7f             	cmp    $0x7f,%eax
  80403b:	76 07                	jbe    804044 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80403d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804044:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804047:	48 63 d0             	movslq %eax,%rdx
  80404a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404d:	48 63 c8             	movslq %eax,%rcx
  804050:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804057:	48 01 c1             	add    %rax,%rcx
  80405a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804061:	48 89 ce             	mov    %rcx,%rsi
  804064:	48 89 c7             	mov    %rax,%rdi
  804067:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804073:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804076:	48 63 d0             	movslq %eax,%rdx
  804079:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804080:	48 89 d6             	mov    %rdx,%rsi
  804083:	48 89 c7             	mov    %rax,%rdi
  804086:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  80408d:	00 00 00 
  804090:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804092:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804095:	01 45 fc             	add    %eax,-0x4(%rbp)
  804098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409b:	48 98                	cltq   
  80409d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8040a4:	0f 82 78 ff ff ff    	jb     804022 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8040aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040ad:	c9                   	leaveq 
  8040ae:	c3                   	retq   

00000000008040af <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8040af:	55                   	push   %rbp
  8040b0:	48 89 e5             	mov    %rsp,%rbp
  8040b3:	48 83 ec 08          	sub    $0x8,%rsp
  8040b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c0:	c9                   	leaveq 
  8040c1:	c3                   	retq   

00000000008040c2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040c2:	55                   	push   %rbp
  8040c3:	48 89 e5             	mov    %rsp,%rbp
  8040c6:	48 83 ec 10          	sub    $0x10,%rsp
  8040ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8040d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d6:	48 be 9c 4a 80 00 00 	movabs $0x804a9c,%rsi
  8040dd:	00 00 00 
  8040e0:	48 89 c7             	mov    %rax,%rdi
  8040e3:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8040ea:	00 00 00 
  8040ed:	ff d0                	callq  *%rax
	return 0;
  8040ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040f4:	c9                   	leaveq 
  8040f5:	c3                   	retq   

00000000008040f6 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040f6:	55                   	push   %rbp
  8040f7:	48 89 e5             	mov    %rsp,%rbp
  8040fa:	48 83 ec 10          	sub    $0x10,%rsp
  8040fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804102:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804109:	00 00 00 
  80410c:	48 8b 00             	mov    (%rax),%rax
  80410f:	48 85 c0             	test   %rax,%rax
  804112:	0f 85 84 00 00 00    	jne    80419c <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804118:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80411f:	00 00 00 
  804122:	48 8b 00             	mov    (%rax),%rax
  804125:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80412b:	ba 07 00 00 00       	mov    $0x7,%edx
  804130:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804135:	89 c7                	mov    %eax,%edi
  804137:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
  804143:	85 c0                	test   %eax,%eax
  804145:	79 2a                	jns    804171 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804147:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  80414e:	00 00 00 
  804151:	be 23 00 00 00       	mov    $0x23,%esi
  804156:	48 bf cf 4a 80 00 00 	movabs $0x804acf,%rdi
  80415d:	00 00 00 
  804160:	b8 00 00 00 00       	mov    $0x0,%eax
  804165:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  80416c:	00 00 00 
  80416f:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804171:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804178:	00 00 00 
  80417b:	48 8b 00             	mov    (%rax),%rax
  80417e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804184:	48 be af 41 80 00 00 	movabs $0x8041af,%rsi
  80418b:	00 00 00 
  80418e:	89 c7                	mov    %eax,%edi
  804190:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  804197:	00 00 00 
  80419a:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  80419c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041a3:	00 00 00 
  8041a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041aa:	48 89 10             	mov    %rdx,(%rax)
}
  8041ad:	c9                   	leaveq 
  8041ae:	c3                   	retq   

00000000008041af <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8041af:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8041b2:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8041b9:	00 00 00 
call *%rax
  8041bc:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  8041be:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8041c5:	00 
movq 152(%rsp), %rcx  //Load RSP
  8041c6:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8041cd:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  8041ce:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  8041d2:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  8041d5:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8041dc:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  8041dd:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  8041e1:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041e5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041ea:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041ef:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041f4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8041f9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8041fe:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804203:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804208:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80420d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804212:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804217:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80421c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804221:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804226:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80422b:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  80422f:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804233:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804234:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804235:	c3                   	retq   
