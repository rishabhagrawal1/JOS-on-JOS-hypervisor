
vmm/guest/obj/user/testpiperace:     file format elf64-x86-64


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
  800052:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 c1 3a 80 00 00 	movabs $0x803ac1,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 99 44 80 00 00 	movabs $0x804499,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf a2 44 80 00 00 	movabs $0x8044a2,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 81 22 80 00 00 	movabs $0x802281,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba b6 44 80 00 00 	movabs $0x8044b6,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf a2 44 80 00 00 	movabs $0x8044a2,%rdi
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
  800114:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
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
  80012e:	48 b8 8a 3d 80 00 00 	movabs $0x803d8a,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf bf 44 80 00 00 	movabs $0x8044bf,%rdi
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
  80018c:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf da 44 80 00 00 	movabs $0x8044da,%rdi
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
  800214:	48 bf e5 44 80 00 00 	movabs $0x8044e5,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  80022f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800232:	be 0a 00 00 00       	mov    $0xa,%esi
  800237:	89 c7                	mov    %eax,%edi
  800239:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800245:	eb 16                	jmp    80025d <umain+0x21a>
		dup(p[0], 10);
  800247:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80024a:	be 0a 00 00 00       	mov    $0xa,%esi
  80024f:	89 c7                	mov    %eax,%edi
  800251:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
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
  80026c:	48 bf f0 44 80 00 00 	movabs $0x8044f0,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800282:	00 00 00 
  800285:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800287:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80028a:	89 c7                	mov    %eax,%edi
  80028c:	48 b8 8a 3d 80 00 00 	movabs $0x803d8a,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
  800298:	85 c0                	test   %eax,%eax
  80029a:	74 2a                	je     8002c6 <umain+0x283>
		panic("somehow the other end of p[0] got closed!");
  80029c:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  8002a3:	00 00 00 
  8002a6:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002ab:	48 bf a2 44 80 00 00 	movabs $0x8044a2,%rdi
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
  8002d2:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002e5:	79 30                	jns    800317 <umain+0x2d4>
		panic("cannot look up p[0]: %e", r);
  8002e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	48 ba 32 45 80 00 00 	movabs $0x804532,%rdx
  8002f3:	00 00 00 
  8002f6:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002fb:	48 bf a2 44 80 00 00 	movabs $0x8044a2,%rdi
  800302:	00 00 00 
  800305:	b8 00 00 00 00       	mov    $0x0,%eax
  80030a:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  800311:	00 00 00 
  800314:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800317:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
  80032a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  80032e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 38 3a 80 00 00 	movabs $0x803a38,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	83 f8 04             	cmp    $0x4,%eax
  800344:	74 1d                	je     800363 <umain+0x320>
		cprintf("\nchild detected race\n");
  800346:	48 bf 4a 45 80 00 00 	movabs $0x80454a,%rdi
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
  800368:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
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
  80040c:	48 b8 a8 2d 80 00 00 	movabs $0x802da8,%rax
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
  8004e5:	48 bf 80 45 80 00 00 	movabs $0x804580,%rdi
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
  800521:	48 bf a3 45 80 00 00 	movabs $0x8045a3,%rdi
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
  8007d0:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
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
  800ac8:	48 b8 d8 47 80 00 00 	movabs $0x8047d8,%rax
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
  800c1b:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  800c22:	00 00 00 
  800c25:	48 63 d3             	movslq %ebx,%rdx
  800c28:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2c:	4d 85 e4             	test   %r12,%r12
  800c2f:	75 2e                	jne    800c5f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	89 d9                	mov    %ebx,%ecx
  800c3b:	48 ba c1 47 80 00 00 	movabs $0x8047c1,%rdx
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
  800c6a:	48 ba ca 47 80 00 00 	movabs $0x8047ca,%rdx
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
  800cc4:	49 bc cd 47 80 00 00 	movabs $0x8047cd,%r12
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
  8019ca:	48 ba 88 4a 80 00 00 	movabs $0x804a88,%rdx
  8019d1:	00 00 00 
  8019d4:	be 23 00 00 00       	mov    $0x23,%esi
  8019d9:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
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

0000000000801e98 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e98:	55                   	push   %rbp
  801e99:	48 89 e5             	mov    %rsp,%rbp
  801e9c:	48 83 ec 30          	sub    $0x30,%rsp
  801ea0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea8:	48 8b 00             	mov    (%rax),%rax
  801eab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801eaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801eba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ebd:	83 e0 02             	and    $0x2,%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	75 4d                	jne    801f11 <pgfault+0x79>
  801ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec8:	48 c1 e8 0c          	shr    $0xc,%rax
  801ecc:	48 89 c2             	mov    %rax,%rdx
  801ecf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ed6:	01 00 00 
  801ed9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801edd:	25 00 08 00 00       	and    $0x800,%eax
  801ee2:	48 85 c0             	test   %rax,%rax
  801ee5:	74 2a                	je     801f11 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ee7:	48 ba b8 4a 80 00 00 	movabs $0x804ab8,%rdx
  801eee:	00 00 00 
  801ef1:	be 23 00 00 00       	mov    $0x23,%esi
  801ef6:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  801efd:	00 00 00 
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  801f0c:	00 00 00 
  801f0f:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801f11:	ba 07 00 00 00       	mov    $0x7,%edx
  801f16:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f20:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	callq  *%rax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 85 cd 00 00 00    	jne    802001 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f40:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f46:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f4e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f53:	48 89 c6             	mov    %rax,%rsi
  801f56:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f5b:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f71:	48 89 c1             	mov    %rax,%rcx
  801f74:	ba 00 00 00 00       	mov    $0x0,%edx
  801f79:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f83:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	79 2a                	jns    801fbd <pgfault+0x125>
				panic("Page map at temp address failed");
  801f93:	48 ba f8 4a 80 00 00 	movabs $0x804af8,%rdx
  801f9a:	00 00 00 
  801f9d:	be 30 00 00 00       	mov    $0x30,%esi
  801fa2:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  801fa9:	00 00 00 
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  801fb8:	00 00 00 
  801fbb:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801fbd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	callq  *%rax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	79 54                	jns    80202b <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801fd7:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  801fde:	00 00 00 
  801fe1:	be 32 00 00 00       	mov    $0x32,%esi
  801fe6:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  801fed:	00 00 00 
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  801ffc:	00 00 00 
  801fff:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802001:	48 ba 40 4b 80 00 00 	movabs $0x804b40,%rdx
  802008:	00 00 00 
  80200b:	be 34 00 00 00       	mov    $0x34,%esi
  802010:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  802017:	00 00 00 
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802026:	00 00 00 
  802029:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80202b:	c9                   	leaveq 
  80202c:	c3                   	retq   

000000000080202d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80202d:	55                   	push   %rbp
  80202e:	48 89 e5             	mov    %rsp,%rbp
  802031:	48 83 ec 20          	sub    $0x20,%rsp
  802035:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802038:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80203b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802042:	01 00 00 
  802045:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802048:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204c:	25 07 0e 00 00       	and    $0xe07,%eax
  802051:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802054:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802057:	48 c1 e0 0c          	shl    $0xc,%rax
  80205b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  80205f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802062:	25 00 04 00 00       	and    $0x400,%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 57                	je     8020c2 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80206b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80206e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802072:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802079:	41 89 f0             	mov    %esi,%r8d
  80207c:	48 89 c6             	mov    %rax,%rsi
  80207f:	bf 00 00 00 00       	mov    $0x0,%edi
  802084:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	85 c0                	test   %eax,%eax
  802092:	0f 8e 52 01 00 00    	jle    8021ea <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802098:	48 ba 72 4b 80 00 00 	movabs $0x804b72,%rdx
  80209f:	00 00 00 
  8020a2:	be 4e 00 00 00       	mov    $0x4e,%esi
  8020a7:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  8020ae:	00 00 00 
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8020bd:	00 00 00 
  8020c0:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8020c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c5:	83 e0 02             	and    $0x2,%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 10                	jne    8020dc <duppage+0xaf>
  8020cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020cf:	25 00 08 00 00       	and    $0x800,%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	0f 84 bb 00 00 00    	je     802197 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8020dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020df:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8020e4:	80 cc 08             	or     $0x8,%ah
  8020e7:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ed:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020f1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f8:	41 89 f0             	mov    %esi,%r8d
  8020fb:	48 89 c6             	mov    %rax,%rsi
  8020fe:	bf 00 00 00 00       	mov    $0x0,%edi
  802103:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	callq  *%rax
  80210f:	85 c0                	test   %eax,%eax
  802111:	7e 2a                	jle    80213d <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802113:	48 ba 72 4b 80 00 00 	movabs $0x804b72,%rdx
  80211a:	00 00 00 
  80211d:	be 55 00 00 00       	mov    $0x55,%esi
  802122:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  802129:	00 00 00 
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802138:	00 00 00 
  80213b:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80213d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802140:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802148:	41 89 c8             	mov    %ecx,%r8d
  80214b:	48 89 d1             	mov    %rdx,%rcx
  80214e:	ba 00 00 00 00       	mov    $0x0,%edx
  802153:	48 89 c6             	mov    %rax,%rsi
  802156:	bf 00 00 00 00       	mov    $0x0,%edi
  80215b:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
  802167:	85 c0                	test   %eax,%eax
  802169:	7e 2a                	jle    802195 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80216b:	48 ba 72 4b 80 00 00 	movabs $0x804b72,%rdx
  802172:	00 00 00 
  802175:	be 57 00 00 00       	mov    $0x57,%esi
  80217a:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  802181:	00 00 00 
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
  802189:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802190:	00 00 00 
  802193:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802195:	eb 53                	jmp    8021ea <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802197:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80219a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80219e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a5:	41 89 f0             	mov    %esi,%r8d
  8021a8:	48 89 c6             	mov    %rax,%rsi
  8021ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b0:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	7e 2a                	jle    8021ea <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8021c0:	48 ba 72 4b 80 00 00 	movabs $0x804b72,%rdx
  8021c7:	00 00 00 
  8021ca:	be 5b 00 00 00       	mov    $0x5b,%esi
  8021cf:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  8021d6:	00 00 00 
  8021d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021de:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8021e5:	00 00 00 
  8021e8:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ef:	c9                   	leaveq 
  8021f0:	c3                   	retq   

00000000008021f1 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8021f1:	55                   	push   %rbp
  8021f2:	48 89 e5             	mov    %rsp,%rbp
  8021f5:	48 83 ec 18          	sub    $0x18,%rsp
  8021f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802201:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802209:	48 c1 e8 27          	shr    $0x27,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	48 85 c0             	test   %rax,%rax
  802224:	74 51                	je     802277 <pt_is_mapped+0x86>
  802226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222a:	48 c1 e0 0c          	shl    $0xc,%rax
  80222e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802232:	48 89 c2             	mov    %rax,%rdx
  802235:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80223c:	01 00 00 
  80223f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802243:	83 e0 01             	and    $0x1,%eax
  802246:	48 85 c0             	test   %rax,%rax
  802249:	74 2c                	je     802277 <pt_is_mapped+0x86>
  80224b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224f:	48 c1 e0 0c          	shl    $0xc,%rax
  802253:	48 c1 e8 15          	shr    $0x15,%rax
  802257:	48 89 c2             	mov    %rax,%rdx
  80225a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802261:	01 00 00 
  802264:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802268:	83 e0 01             	and    $0x1,%eax
  80226b:	48 85 c0             	test   %rax,%rax
  80226e:	74 07                	je     802277 <pt_is_mapped+0x86>
  802270:	b8 01 00 00 00       	mov    $0x1,%eax
  802275:	eb 05                	jmp    80227c <pt_is_mapped+0x8b>
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	83 e0 01             	and    $0x1,%eax
}
  80227f:	c9                   	leaveq 
  802280:	c3                   	retq   

0000000000802281 <fork>:

envid_t
fork(void)
{
  802281:	55                   	push   %rbp
  802282:	48 89 e5             	mov    %rsp,%rbp
  802285:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802289:	48 bf 98 1e 80 00 00 	movabs $0x801e98,%rdi
  802290:	00 00 00 
  802293:	48 b8 3d 43 80 00 00 	movabs $0x80433d,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80229f:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a4:	cd 30                	int    $0x30
  8022a6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022a9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8022ac:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8022af:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022b3:	79 30                	jns    8022e5 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8022b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022b8:	89 c1                	mov    %eax,%ecx
  8022ba:	48 ba 90 4b 80 00 00 	movabs $0x804b90,%rdx
  8022c1:	00 00 00 
  8022c4:	be 86 00 00 00       	mov    $0x86,%esi
  8022c9:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  8022d0:	00 00 00 
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8022df:	00 00 00 
  8022e2:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8022e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022e9:	75 3e                	jne    802329 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8022eb:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  8022f2:	00 00 00 
  8022f5:	ff d0                	callq  *%rax
  8022f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022fc:	48 98                	cltq   
  8022fe:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802305:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80230c:	00 00 00 
  80230f:	48 01 c2             	add    %rax,%rdx
  802312:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802319:	00 00 00 
  80231c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	e9 d1 01 00 00       	jmpq   8024fa <fork+0x279>
	}
	uint64_t ad = 0;
  802329:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802330:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802331:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802336:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80233a:	e9 df 00 00 00       	jmpq   80241e <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80233f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802343:	48 c1 e8 27          	shr    $0x27,%rax
  802347:	48 89 c2             	mov    %rax,%rdx
  80234a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802351:	01 00 00 
  802354:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802358:	83 e0 01             	and    $0x1,%eax
  80235b:	48 85 c0             	test   %rax,%rax
  80235e:	0f 84 9e 00 00 00    	je     802402 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802368:	48 c1 e8 1e          	shr    $0x1e,%rax
  80236c:	48 89 c2             	mov    %rax,%rdx
  80236f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802376:	01 00 00 
  802379:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237d:	83 e0 01             	and    $0x1,%eax
  802380:	48 85 c0             	test   %rax,%rax
  802383:	74 73                	je     8023f8 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802389:	48 c1 e8 15          	shr    $0x15,%rax
  80238d:	48 89 c2             	mov    %rax,%rdx
  802390:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802397:	01 00 00 
  80239a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239e:	83 e0 01             	and    $0x1,%eax
  8023a1:	48 85 c0             	test   %rax,%rax
  8023a4:	74 48                	je     8023ee <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8023a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ae:	48 89 c2             	mov    %rax,%rdx
  8023b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b8:	01 00 00 
  8023bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	83 e0 01             	and    $0x1,%eax
  8023ca:	48 85 c0             	test   %rax,%rax
  8023cd:	74 47                	je     802416 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8023cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8023d7:	89 c2                	mov    %eax,%edx
  8023d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023dc:	89 d6                	mov    %edx,%esi
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	48 b8 2d 20 80 00 00 	movabs $0x80202d,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	eb 28                	jmp    802416 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8023ee:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023f5:	00 
  8023f6:	eb 1e                	jmp    802416 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023f8:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8023ff:	40 
  802400:	eb 14                	jmp    802416 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802406:	48 c1 e8 27          	shr    $0x27,%rax
  80240a:	48 83 c0 01          	add    $0x1,%rax
  80240e:	48 c1 e0 27          	shl    $0x27,%rax
  802412:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802416:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80241d:	00 
  80241e:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802425:	00 
  802426:	0f 87 13 ff ff ff    	ja     80233f <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80242c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80242f:	ba 07 00 00 00       	mov    $0x7,%edx
  802434:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802439:	89 c7                	mov    %eax,%edi
  80243b:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802447:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244a:	ba 07 00 00 00       	mov    $0x7,%edx
  80244f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802454:	89 c7                	mov    %eax,%edi
  802456:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802462:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802465:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80246b:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802470:	ba 00 00 00 00       	mov    $0x0,%edx
  802475:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80247a:	89 c7                	mov    %eax,%edi
  80247c:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802483:	00 00 00 
  802486:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802488:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802492:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802497:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8024a3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ad:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8024b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024c0:	00 00 00 
  8024c3:	48 8b 00             	mov    (%rax),%rax
  8024c6:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8024cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d0:	48 89 d6             	mov    %rdx,%rsi
  8024d3:	89 c7                	mov    %eax,%edi
  8024d5:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8024dc:	00 00 00 
  8024df:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8024e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024e4:	be 02 00 00 00       	mov    $0x2,%esi
  8024e9:	89 c7                	mov    %eax,%edi
  8024eb:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  8024f2:	00 00 00 
  8024f5:	ff d0                	callq  *%rax

	return envid;
  8024f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024fa:	c9                   	leaveq 
  8024fb:	c3                   	retq   

00000000008024fc <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024fc:	55                   	push   %rbp
  8024fd:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802500:	48 ba a8 4b 80 00 00 	movabs $0x804ba8,%rdx
  802507:	00 00 00 
  80250a:	be bf 00 00 00       	mov    $0xbf,%esi
  80250f:	48 bf ed 4a 80 00 00 	movabs $0x804aed,%rdi
  802516:	00 00 00 
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  802525:	00 00 00 
  802528:	ff d1                	callq  *%rcx

000000000080252a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 30          	sub    $0x30,%rsp
  802532:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802536:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80253a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80253e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802545:	00 00 00 
  802548:	48 8b 00             	mov    (%rax),%rax
  80254b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	75 34                	jne    802589 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802555:	48 b8 cc 1a 80 00 00 	movabs $0x801acc,%rax
  80255c:	00 00 00 
  80255f:	ff d0                	callq  *%rax
  802561:	25 ff 03 00 00       	and    $0x3ff,%eax
  802566:	48 98                	cltq   
  802568:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80256f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802576:	00 00 00 
  802579:	48 01 c2             	add    %rax,%rdx
  80257c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802583:	00 00 00 
  802586:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802589:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80258e:	75 0e                	jne    80259e <ipc_recv+0x74>
		pg = (void*) UTOP;
  802590:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802597:	00 00 00 
  80259a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80259e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a2:	48 89 c7             	mov    %rax,%rdi
  8025a5:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8025b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b8:	79 19                	jns    8025d3 <ipc_recv+0xa9>
		*from_env_store = 0;
  8025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8025c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8025ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d1:	eb 53                	jmp    802626 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8025d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025d8:	74 19                	je     8025f3 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8025da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025e1:	00 00 00 
  8025e4:	48 8b 00             	mov    (%rax),%rax
  8025e7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8025ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f1:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8025f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025f8:	74 19                	je     802613 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8025fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802601:	00 00 00 
  802604:	48 8b 00             	mov    (%rax),%rax
  802607:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80260d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802611:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802613:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80261a:	00 00 00 
  80261d:	48 8b 00             	mov    (%rax),%rax
  802620:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802626:	c9                   	leaveq 
  802627:	c3                   	retq   

0000000000802628 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802628:	55                   	push   %rbp
  802629:	48 89 e5             	mov    %rsp,%rbp
  80262c:	48 83 ec 30          	sub    $0x30,%rsp
  802630:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802633:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802636:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80263a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80263d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802642:	75 0e                	jne    802652 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802644:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80264b:	00 00 00 
  80264e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802652:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802655:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802658:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80265c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80265f:	89 c7                	mov    %eax,%edi
  802661:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802670:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802674:	75 0c                	jne    802682 <ipc_send+0x5a>
			sys_yield();
  802676:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802682:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802686:	74 ca                	je     802652 <ipc_send+0x2a>
	if(result != 0)
  802688:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268c:	74 20                	je     8026ae <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80268e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802691:	89 c6                	mov    %eax,%esi
  802693:	48 bf c0 4b 80 00 00 	movabs $0x804bc0,%rdi
  80269a:	00 00 00 
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a2:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8026a9:	00 00 00 
  8026ac:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8026ae:	c9                   	leaveq 
  8026af:	c3                   	retq   

00000000008026b0 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8026b0:	55                   	push   %rbp
  8026b1:	48 89 e5             	mov    %rsp,%rbp
  8026b4:	53                   	push   %rbx
  8026b5:	48 83 ec 58          	sub    $0x58,%rsp
  8026b9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  8026bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  8026c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8026cc:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8026d3:	00 
  8026d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8026dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8026e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026ec:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8026f0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8026f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f8:	48 c1 e8 27          	shr    $0x27,%rax
  8026fc:	48 89 c2             	mov    %rax,%rdx
  8026ff:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802706:	01 00 00 
  802709:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270d:	83 e0 01             	and    $0x1,%eax
  802710:	48 85 c0             	test   %rax,%rax
  802713:	0f 85 91 00 00 00    	jne    8027aa <ipc_host_recv+0xfa>
  802719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802721:	48 89 c2             	mov    %rax,%rdx
  802724:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80272b:	01 00 00 
  80272e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802732:	83 e0 01             	and    $0x1,%eax
  802735:	48 85 c0             	test   %rax,%rax
  802738:	74 70                	je     8027aa <ipc_host_recv+0xfa>
  80273a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273e:	48 c1 e8 15          	shr    $0x15,%rax
  802742:	48 89 c2             	mov    %rax,%rdx
  802745:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80274c:	01 00 00 
  80274f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802753:	83 e0 01             	and    $0x1,%eax
  802756:	48 85 c0             	test   %rax,%rax
  802759:	74 4f                	je     8027aa <ipc_host_recv+0xfa>
  80275b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275f:	48 c1 e8 0c          	shr    $0xc,%rax
  802763:	48 89 c2             	mov    %rax,%rdx
  802766:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80276d:	01 00 00 
  802770:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802774:	83 e0 01             	and    $0x1,%eax
  802777:	48 85 c0             	test   %rax,%rax
  80277a:	74 2e                	je     8027aa <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80277c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802780:	ba 07 04 00 00       	mov    $0x407,%edx
  802785:	48 89 c6             	mov    %rax,%rsi
  802788:	bf 00 00 00 00       	mov    $0x0,%edi
  80278d:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80279c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8027a0:	79 08                	jns    8027aa <ipc_host_recv+0xfa>
	    	return result;
  8027a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8027a5:	e9 84 00 00 00       	jmpq   80282e <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8027aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b2:	48 89 c2             	mov    %rax,%rdx
  8027b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027bc:	01 00 00 
  8027bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8027c9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8027cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8027d2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8027d6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8027da:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8027de:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027e2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027e6:	4c 89 c3             	mov    %r8,%rbx
  8027e9:	0f 01 c1             	vmcall 
  8027ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8027ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8027f3:	7e 36                	jle    80282b <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8027f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8027f8:	41 89 c0             	mov    %eax,%r8d
  8027fb:	b9 03 00 00 00       	mov    $0x3,%ecx
  802800:	48 ba d8 4b 80 00 00 	movabs $0x804bd8,%rdx
  802807:	00 00 00 
  80280a:	be 67 00 00 00       	mov    $0x67,%esi
  80280f:	48 bf 05 4c 80 00 00 	movabs $0x804c05,%rdi
  802816:	00 00 00 
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
  80281e:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  802825:	00 00 00 
  802828:	41 ff d1             	callq  *%r9
	return result;
  80282b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  80282e:	48 83 c4 58          	add    $0x58,%rsp
  802832:	5b                   	pop    %rbx
  802833:	5d                   	pop    %rbp
  802834:	c3                   	retq   

0000000000802835 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802835:	55                   	push   %rbp
  802836:	48 89 e5             	mov    %rsp,%rbp
  802839:	53                   	push   %rbx
  80283a:	48 83 ec 68          	sub    $0x68,%rsp
  80283e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  802841:	89 75 a8             	mov    %esi,-0x58(%rbp)
  802844:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  802848:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  80284b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80284f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  802853:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  80285a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802861:	00 
  802862:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802866:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80286a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80286e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802876:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80287a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80287e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  802882:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802886:	48 c1 e8 27          	shr    $0x27,%rax
  80288a:	48 89 c2             	mov    %rax,%rdx
  80288d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802894:	01 00 00 
  802897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	0f 85 88 00 00 00    	jne    80292f <ipc_host_send+0xfa>
  8028a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ab:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028af:	48 89 c2             	mov    %rax,%rdx
  8028b2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8028b9:	01 00 00 
  8028bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c0:	83 e0 01             	and    $0x1,%eax
  8028c3:	48 85 c0             	test   %rax,%rax
  8028c6:	74 67                	je     80292f <ipc_host_send+0xfa>
  8028c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028cc:	48 c1 e8 15          	shr    $0x15,%rax
  8028d0:	48 89 c2             	mov    %rax,%rdx
  8028d3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028da:	01 00 00 
  8028dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e1:	83 e0 01             	and    $0x1,%eax
  8028e4:	48 85 c0             	test   %rax,%rax
  8028e7:	74 46                	je     80292f <ipc_host_send+0xfa>
  8028e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8028f1:	48 89 c2             	mov    %rax,%rdx
  8028f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028fb:	01 00 00 
  8028fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802902:	83 e0 01             	and    $0x1,%eax
  802905:	48 85 c0             	test   %rax,%rax
  802908:	74 25                	je     80292f <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  80290a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290e:	48 c1 e8 0c          	shr    $0xc,%rax
  802912:	48 89 c2             	mov    %rax,%rdx
  802915:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80291c:	01 00 00 
  80291f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802923:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802929:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80292d:	eb 0e                	jmp    80293d <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80292f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802936:	00 00 00 
  802939:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  80293d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802941:	48 89 c6             	mov    %rax,%rsi
  802944:	48 bf 0f 4c 80 00 00 	movabs $0x804c0f,%rdi
  80294b:	00 00 00 
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80295a:	00 00 00 
  80295d:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80295f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802962:	48 98                	cltq   
  802964:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  802968:	8b 45 a8             	mov    -0x58(%rbp),%eax
  80296b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80296f:	8b 45 9c             	mov    -0x64(%rbp),%eax
  802972:	48 98                	cltq   
  802974:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  802978:	b8 02 00 00 00       	mov    $0x2,%eax
  80297d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802981:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802985:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  802989:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80298d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802991:	4c 89 c3             	mov    %r8,%rbx
  802994:	0f 01 c1             	vmcall 
  802997:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  80299a:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80299e:	75 0c                	jne    8029ac <ipc_host_send+0x177>
			sys_yield();
  8029a0:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8029ac:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8029b0:	74 c6                	je     802978 <ipc_host_send+0x143>
	
	if(result !=0)
  8029b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8029b6:	74 36                	je     8029ee <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  8029b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029bb:	41 89 c0             	mov    %eax,%r8d
  8029be:	b9 02 00 00 00       	mov    $0x2,%ecx
  8029c3:	48 ba d8 4b 80 00 00 	movabs $0x804bd8,%rdx
  8029ca:	00 00 00 
  8029cd:	be 94 00 00 00       	mov    $0x94,%esi
  8029d2:	48 bf 05 4c 80 00 00 	movabs $0x804c05,%rdi
  8029d9:	00 00 00 
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  8029e8:	00 00 00 
  8029eb:	41 ff d1             	callq  *%r9
}
  8029ee:	48 83 c4 68          	add    $0x68,%rsp
  8029f2:	5b                   	pop    %rbx
  8029f3:	5d                   	pop    %rbp
  8029f4:	c3                   	retq   

00000000008029f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 14          	sub    $0x14,%rsp
  8029fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a07:	eb 4e                	jmp    802a57 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802a09:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a10:	00 00 00 
  802a13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a16:	48 98                	cltq   
  802a18:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a1f:	48 01 d0             	add    %rdx,%rax
  802a22:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a28:	8b 00                	mov    (%rax),%eax
  802a2a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a2d:	75 24                	jne    802a53 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802a2f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a36:	00 00 00 
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	48 98                	cltq   
  802a3e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a45:	48 01 d0             	add    %rdx,%rax
  802a48:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a4e:	8b 40 08             	mov    0x8(%rax),%eax
  802a51:	eb 12                	jmp    802a65 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a53:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a57:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a5e:	7e a9                	jle    802a09 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a65:	c9                   	leaveq 
  802a66:	c3                   	retq   

0000000000802a67 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a67:	55                   	push   %rbp
  802a68:	48 89 e5             	mov    %rsp,%rbp
  802a6b:	48 83 ec 08          	sub    $0x8,%rsp
  802a6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a73:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a77:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a7e:	ff ff ff 
  802a81:	48 01 d0             	add    %rdx,%rax
  802a84:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 08          	sub    $0x8,%rsp
  802a92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a9a:	48 89 c7             	mov    %rax,%rdi
  802a9d:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
  802aa9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802aaf:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 18          	sub    $0x18,%rsp
  802abd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ac1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ac8:	eb 6b                	jmp    802b35 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acd:	48 98                	cltq   
  802acf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ad5:	48 c1 e0 0c          	shl    $0xc,%rax
  802ad9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae1:	48 c1 e8 15          	shr    $0x15,%rax
  802ae5:	48 89 c2             	mov    %rax,%rdx
  802ae8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aef:	01 00 00 
  802af2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af6:	83 e0 01             	and    $0x1,%eax
  802af9:	48 85 c0             	test   %rax,%rax
  802afc:	74 21                	je     802b1f <fd_alloc+0x6a>
  802afe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b02:	48 c1 e8 0c          	shr    $0xc,%rax
  802b06:	48 89 c2             	mov    %rax,%rdx
  802b09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b10:	01 00 00 
  802b13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b17:	83 e0 01             	and    $0x1,%eax
  802b1a:	48 85 c0             	test   %rax,%rax
  802b1d:	75 12                	jne    802b31 <fd_alloc+0x7c>
			*fd_store = fd;
  802b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b27:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2f:	eb 1a                	jmp    802b4b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b31:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b35:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b39:	7e 8f                	jle    802aca <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b46:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b4b:	c9                   	leaveq 
  802b4c:	c3                   	retq   

0000000000802b4d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b4d:	55                   	push   %rbp
  802b4e:	48 89 e5             	mov    %rsp,%rbp
  802b51:	48 83 ec 20          	sub    $0x20,%rsp
  802b55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b60:	78 06                	js     802b68 <fd_lookup+0x1b>
  802b62:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b66:	7e 07                	jle    802b6f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6d:	eb 6c                	jmp    802bdb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b72:	48 98                	cltq   
  802b74:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b7a:	48 c1 e0 0c          	shl    $0xc,%rax
  802b7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b86:	48 c1 e8 15          	shr    $0x15,%rax
  802b8a:	48 89 c2             	mov    %rax,%rdx
  802b8d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b94:	01 00 00 
  802b97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b9b:	83 e0 01             	and    $0x1,%eax
  802b9e:	48 85 c0             	test   %rax,%rax
  802ba1:	74 21                	je     802bc4 <fd_lookup+0x77>
  802ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba7:	48 c1 e8 0c          	shr    $0xc,%rax
  802bab:	48 89 c2             	mov    %rax,%rdx
  802bae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bb5:	01 00 00 
  802bb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bbc:	83 e0 01             	and    $0x1,%eax
  802bbf:	48 85 c0             	test   %rax,%rax
  802bc2:	75 07                	jne    802bcb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bc9:	eb 10                	jmp    802bdb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802bcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bcf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bd3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 30          	sub    $0x30,%rsp
  802be5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802be9:	89 f0                	mov    %esi,%eax
  802beb:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802bee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf2:	48 89 c7             	mov    %rax,%rdi
  802bf5:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  802bfc:	00 00 00 
  802bff:	ff d0                	callq  *%rax
  802c01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c05:	48 89 d6             	mov    %rdx,%rsi
  802c08:	89 c7                	mov    %eax,%edi
  802c0a:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
  802c16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1d:	78 0a                	js     802c29 <fd_close+0x4c>
	    || fd != fd2)
  802c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c23:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c27:	74 12                	je     802c3b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c29:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c2d:	74 05                	je     802c34 <fd_close+0x57>
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	eb 05                	jmp    802c39 <fd_close+0x5c>
  802c34:	b8 00 00 00 00       	mov    $0x0,%eax
  802c39:	eb 69                	jmp    802ca4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c3f:	8b 00                	mov    (%rax),%eax
  802c41:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c45:	48 89 d6             	mov    %rdx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 a6 2c 80 00 00 	movabs $0x802ca6,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	78 2a                	js     802c89 <fd_close+0xac>
		if (dev->dev_close)
  802c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c63:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c67:	48 85 c0             	test   %rax,%rax
  802c6a:	74 16                	je     802c82 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c70:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c78:	48 89 d7             	mov    %rdx,%rdi
  802c7b:	ff d0                	callq  *%rax
  802c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c80:	eb 07                	jmp    802c89 <fd_close+0xac>
		else
			r = 0;
  802c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8d:	48 89 c6             	mov    %rax,%rsi
  802c90:	bf 00 00 00 00       	mov    $0x0,%edi
  802c95:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
	return r;
  802ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ca4:	c9                   	leaveq 
  802ca5:	c3                   	retq   

0000000000802ca6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ca6:	55                   	push   %rbp
  802ca7:	48 89 e5             	mov    %rsp,%rbp
  802caa:	48 83 ec 20          	sub    $0x20,%rsp
  802cae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cbc:	eb 41                	jmp    802cff <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802cbe:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cc5:	00 00 00 
  802cc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ccb:	48 63 d2             	movslq %edx,%rdx
  802cce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cd2:	8b 00                	mov    (%rax),%eax
  802cd4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cd7:	75 22                	jne    802cfb <dev_lookup+0x55>
			*dev = devtab[i];
  802cd9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ce0:	00 00 00 
  802ce3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ce6:	48 63 d2             	movslq %edx,%rdx
  802ce9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802ced:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf9:	eb 60                	jmp    802d5b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802cfb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cff:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802d06:	00 00 00 
  802d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d0c:	48 63 d2             	movslq %edx,%rdx
  802d0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d13:	48 85 c0             	test   %rax,%rax
  802d16:	75 a6                	jne    802cbe <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d18:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d1f:	00 00 00 
  802d22:	48 8b 00             	mov    (%rax),%rax
  802d25:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d2b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d2e:	89 c6                	mov    %eax,%esi
  802d30:	48 bf 20 4c 80 00 00 	movabs $0x804c20,%rdi
  802d37:	00 00 00 
  802d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3f:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  802d46:	00 00 00 
  802d49:	ff d1                	callq  *%rcx
	*dev = 0;
  802d4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d4f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d5b:	c9                   	leaveq 
  802d5c:	c3                   	retq   

0000000000802d5d <close>:

int
close(int fdnum)
{
  802d5d:	55                   	push   %rbp
  802d5e:	48 89 e5             	mov    %rsp,%rbp
  802d61:	48 83 ec 20          	sub    $0x20,%rsp
  802d65:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d68:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d6f:	48 89 d6             	mov    %rdx,%rsi
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
  802d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d87:	79 05                	jns    802d8e <close+0x31>
		return r;
  802d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8c:	eb 18                	jmp    802da6 <close+0x49>
	else
		return fd_close(fd, 1);
  802d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d92:	be 01 00 00 00       	mov    $0x1,%esi
  802d97:	48 89 c7             	mov    %rax,%rdi
  802d9a:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
}
  802da6:	c9                   	leaveq 
  802da7:	c3                   	retq   

0000000000802da8 <close_all>:

void
close_all(void)
{
  802da8:	55                   	push   %rbp
  802da9:	48 89 e5             	mov    %rsp,%rbp
  802dac:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802db0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802db7:	eb 15                	jmp    802dce <close_all+0x26>
		close(i);
  802db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbc:	89 c7                	mov    %eax,%edi
  802dbe:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802dca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802dce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802dd2:	7e e5                	jle    802db9 <close_all+0x11>
		close(i);
}
  802dd4:	c9                   	leaveq 
  802dd5:	c3                   	retq   

0000000000802dd6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802dd6:	55                   	push   %rbp
  802dd7:	48 89 e5             	mov    %rsp,%rbp
  802dda:	48 83 ec 40          	sub    $0x40,%rsp
  802dde:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802de1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802de4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802de8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802deb:	48 89 d6             	mov    %rdx,%rsi
  802dee:	89 c7                	mov    %eax,%edi
  802df0:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
  802dfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e03:	79 08                	jns    802e0d <dup+0x37>
		return r;
  802e05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e08:	e9 70 01 00 00       	jmpq   802f7d <dup+0x1a7>
	close(newfdnum);
  802e0d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e10:	89 c7                	mov    %eax,%edi
  802e12:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e1e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e21:	48 98                	cltq   
  802e23:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e29:	48 c1 e0 0c          	shl    $0xc,%rax
  802e2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e35:	48 89 c7             	mov    %rax,%rdi
  802e38:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4c:	48 89 c7             	mov    %rax,%rdi
  802e4f:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
  802e5b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e63:	48 c1 e8 15          	shr    $0x15,%rax
  802e67:	48 89 c2             	mov    %rax,%rdx
  802e6a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e71:	01 00 00 
  802e74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e78:	83 e0 01             	and    $0x1,%eax
  802e7b:	48 85 c0             	test   %rax,%rax
  802e7e:	74 73                	je     802ef3 <dup+0x11d>
  802e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e84:	48 c1 e8 0c          	shr    $0xc,%rax
  802e88:	48 89 c2             	mov    %rax,%rdx
  802e8b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e92:	01 00 00 
  802e95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e99:	83 e0 01             	and    $0x1,%eax
  802e9c:	48 85 c0             	test   %rax,%rax
  802e9f:	74 52                	je     802ef3 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea5:	48 c1 e8 0c          	shr    $0xc,%rax
  802ea9:	48 89 c2             	mov    %rax,%rdx
  802eac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eb3:	01 00 00 
  802eb6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eba:	25 07 0e 00 00       	and    $0xe07,%eax
  802ebf:	89 c1                	mov    %eax,%ecx
  802ec1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec9:	41 89 c8             	mov    %ecx,%r8d
  802ecc:	48 89 d1             	mov    %rdx,%rcx
  802ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed4:	48 89 c6             	mov    %rax,%rsi
  802ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  802edc:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eef:	79 02                	jns    802ef3 <dup+0x11d>
			goto err;
  802ef1:	eb 57                	jmp    802f4a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ef3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef7:	48 c1 e8 0c          	shr    $0xc,%rax
  802efb:	48 89 c2             	mov    %rax,%rdx
  802efe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f05:	01 00 00 
  802f08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f0c:	25 07 0e 00 00       	and    $0xe07,%eax
  802f11:	89 c1                	mov    %eax,%ecx
  802f13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f1b:	41 89 c8             	mov    %ecx,%r8d
  802f1e:	48 89 d1             	mov    %rdx,%rcx
  802f21:	ba 00 00 00 00       	mov    $0x0,%edx
  802f26:	48 89 c6             	mov    %rax,%rsi
  802f29:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2e:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	callq  *%rax
  802f3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f41:	79 02                	jns    802f45 <dup+0x16f>
		goto err;
  802f43:	eb 05                	jmp    802f4a <dup+0x174>

	return newfdnum;
  802f45:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f48:	eb 33                	jmp    802f7d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4e:	48 89 c6             	mov    %rax,%rsi
  802f51:	bf 00 00 00 00       	mov    $0x0,%edi
  802f56:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f66:	48 89 c6             	mov    %rax,%rsi
  802f69:	bf 00 00 00 00       	mov    $0x0,%edi
  802f6e:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
	return r;
  802f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f7d:	c9                   	leaveq 
  802f7e:	c3                   	retq   

0000000000802f7f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f7f:	55                   	push   %rbp
  802f80:	48 89 e5             	mov    %rsp,%rbp
  802f83:	48 83 ec 40          	sub    $0x40,%rsp
  802f87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f8e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f92:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f96:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f99:	48 89 d6             	mov    %rdx,%rsi
  802f9c:	89 c7                	mov    %eax,%edi
  802f9e:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
  802faa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb1:	78 24                	js     802fd7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb7:	8b 00                	mov    (%rax),%eax
  802fb9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fbd:	48 89 d6             	mov    %rdx,%rsi
  802fc0:	89 c7                	mov    %eax,%edi
  802fc2:	48 b8 a6 2c 80 00 00 	movabs $0x802ca6,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
  802fce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd5:	79 05                	jns    802fdc <read+0x5d>
		return r;
  802fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fda:	eb 76                	jmp    803052 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802fdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe0:	8b 40 08             	mov    0x8(%rax),%eax
  802fe3:	83 e0 03             	and    $0x3,%eax
  802fe6:	83 f8 01             	cmp    $0x1,%eax
  802fe9:	75 3a                	jne    803025 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802feb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ff2:	00 00 00 
  802ff5:	48 8b 00             	mov    (%rax),%rax
  802ff8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ffe:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803001:	89 c6                	mov    %eax,%esi
  803003:	48 bf 3f 4c 80 00 00 	movabs $0x804c3f,%rdi
  80300a:	00 00 00 
  80300d:	b8 00 00 00 00       	mov    $0x0,%eax
  803012:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  803019:	00 00 00 
  80301c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80301e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803023:	eb 2d                	jmp    803052 <read+0xd3>
	}
	if (!dev->dev_read)
  803025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803029:	48 8b 40 10          	mov    0x10(%rax),%rax
  80302d:	48 85 c0             	test   %rax,%rax
  803030:	75 07                	jne    803039 <read+0xba>
		return -E_NOT_SUPP;
  803032:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803037:	eb 19                	jmp    803052 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803041:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803045:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803049:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80304d:	48 89 cf             	mov    %rcx,%rdi
  803050:	ff d0                	callq  *%rax
}
  803052:	c9                   	leaveq 
  803053:	c3                   	retq   

0000000000803054 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803054:	55                   	push   %rbp
  803055:	48 89 e5             	mov    %rsp,%rbp
  803058:	48 83 ec 30          	sub    $0x30,%rsp
  80305c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80305f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803063:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80306e:	eb 49                	jmp    8030b9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803073:	48 98                	cltq   
  803075:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803079:	48 29 c2             	sub    %rax,%rdx
  80307c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307f:	48 63 c8             	movslq %eax,%rcx
  803082:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803086:	48 01 c1             	add    %rax,%rcx
  803089:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80308c:	48 89 ce             	mov    %rcx,%rsi
  80308f:	89 c7                	mov    %eax,%edi
  803091:	48 b8 7f 2f 80 00 00 	movabs $0x802f7f,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
  80309d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030a4:	79 05                	jns    8030ab <readn+0x57>
			return m;
  8030a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a9:	eb 1c                	jmp    8030c7 <readn+0x73>
		if (m == 0)
  8030ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030af:	75 02                	jne    8030b3 <readn+0x5f>
			break;
  8030b1:	eb 11                	jmp    8030c4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bc:	48 98                	cltq   
  8030be:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030c2:	72 ac                	jb     803070 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8030c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 40          	sub    $0x40,%rsp
  8030d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030e3:	48 89 d6             	mov    %rdx,%rsi
  8030e6:	89 c7                	mov    %eax,%edi
  8030e8:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
  8030f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fb:	78 24                	js     803121 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803101:	8b 00                	mov    (%rax),%eax
  803103:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803107:	48 89 d6             	mov    %rdx,%rsi
  80310a:	89 c7                	mov    %eax,%edi
  80310c:	48 b8 a6 2c 80 00 00 	movabs $0x802ca6,%rax
  803113:	00 00 00 
  803116:	ff d0                	callq  *%rax
  803118:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311f:	79 05                	jns    803126 <write+0x5d>
		return r;
  803121:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803124:	eb 42                	jmp    803168 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312a:	8b 40 08             	mov    0x8(%rax),%eax
  80312d:	83 e0 03             	and    $0x3,%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	75 07                	jne    80313b <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803134:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803139:	eb 2d                	jmp    803168 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80313b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803143:	48 85 c0             	test   %rax,%rax
  803146:	75 07                	jne    80314f <write+0x86>
		return -E_NOT_SUPP;
  803148:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80314d:	eb 19                	jmp    803168 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  80314f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803153:	48 8b 40 18          	mov    0x18(%rax),%rax
  803157:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80315b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80315f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803163:	48 89 cf             	mov    %rcx,%rdi
  803166:	ff d0                	callq  *%rax
}
  803168:	c9                   	leaveq 
  803169:	c3                   	retq   

000000000080316a <seek>:

int
seek(int fdnum, off_t offset)
{
  80316a:	55                   	push   %rbp
  80316b:	48 89 e5             	mov    %rsp,%rbp
  80316e:	48 83 ec 18          	sub    $0x18,%rsp
  803172:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803175:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803178:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80317c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80317f:	48 89 d6             	mov    %rdx,%rsi
  803182:	89 c7                	mov    %eax,%edi
  803184:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  80318b:	00 00 00 
  80318e:	ff d0                	callq  *%rax
  803190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803197:	79 05                	jns    80319e <seek+0x34>
		return r;
  803199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319c:	eb 0f                	jmp    8031ad <seek+0x43>
	fd->fd_offset = offset;
  80319e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8031a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ad:	c9                   	leaveq 
  8031ae:	c3                   	retq   

00000000008031af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031af:	55                   	push   %rbp
  8031b0:	48 89 e5             	mov    %rsp,%rbp
  8031b3:	48 83 ec 30          	sub    $0x30,%rsp
  8031b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031ba:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031c4:	48 89 d6             	mov    %rdx,%rsi
  8031c7:	89 c7                	mov    %eax,%edi
  8031c9:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
  8031d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dc:	78 24                	js     803202 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e2:	8b 00                	mov    (%rax),%eax
  8031e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e8:	48 89 d6             	mov    %rdx,%rsi
  8031eb:	89 c7                	mov    %eax,%edi
  8031ed:	48 b8 a6 2c 80 00 00 	movabs $0x802ca6,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803200:	79 05                	jns    803207 <ftruncate+0x58>
		return r;
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803205:	eb 72                	jmp    803279 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320b:	8b 40 08             	mov    0x8(%rax),%eax
  80320e:	83 e0 03             	and    $0x3,%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	75 3a                	jne    80324f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803215:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80321c:	00 00 00 
  80321f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803222:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803228:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80322b:	89 c6                	mov    %eax,%esi
  80322d:	48 bf 60 4c 80 00 00 	movabs $0x804c60,%rdi
  803234:	00 00 00 
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
  80323c:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  803243:	00 00 00 
  803246:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803248:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80324d:	eb 2a                	jmp    803279 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	48 8b 40 30          	mov    0x30(%rax),%rax
  803257:	48 85 c0             	test   %rax,%rax
  80325a:	75 07                	jne    803263 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80325c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803261:	eb 16                	jmp    803279 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803267:	48 8b 40 30          	mov    0x30(%rax),%rax
  80326b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80326f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803272:	89 ce                	mov    %ecx,%esi
  803274:	48 89 d7             	mov    %rdx,%rdi
  803277:	ff d0                	callq  *%rax
}
  803279:	c9                   	leaveq 
  80327a:	c3                   	retq   

000000000080327b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80327b:	55                   	push   %rbp
  80327c:	48 89 e5             	mov    %rsp,%rbp
  80327f:	48 83 ec 30          	sub    $0x30,%rsp
  803283:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803286:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80328a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80328e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803291:	48 89 d6             	mov    %rdx,%rsi
  803294:	89 c7                	mov    %eax,%edi
  803296:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  80329d:	00 00 00 
  8032a0:	ff d0                	callq  *%rax
  8032a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a9:	78 24                	js     8032cf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032af:	8b 00                	mov    (%rax),%eax
  8032b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032b5:	48 89 d6             	mov    %rdx,%rsi
  8032b8:	89 c7                	mov    %eax,%edi
  8032ba:	48 b8 a6 2c 80 00 00 	movabs $0x802ca6,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
  8032c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cd:	79 05                	jns    8032d4 <fstat+0x59>
		return r;
  8032cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d2:	eb 5e                	jmp    803332 <fstat+0xb7>
	if (!dev->dev_stat)
  8032d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032dc:	48 85 c0             	test   %rax,%rax
  8032df:	75 07                	jne    8032e8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032e6:	eb 4a                	jmp    803332 <fstat+0xb7>
	stat->st_name[0] = 0;
  8032e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ec:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8032fa:	00 00 00 
	stat->st_isdir = 0;
  8032fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803301:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803308:	00 00 00 
	stat->st_dev = dev;
  80330b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80330f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803313:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331e:	48 8b 40 28          	mov    0x28(%rax),%rax
  803322:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803326:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80332a:	48 89 ce             	mov    %rcx,%rsi
  80332d:	48 89 d7             	mov    %rdx,%rdi
  803330:	ff d0                	callq  *%rax
}
  803332:	c9                   	leaveq 
  803333:	c3                   	retq   

0000000000803334 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803334:	55                   	push   %rbp
  803335:	48 89 e5             	mov    %rsp,%rbp
  803338:	48 83 ec 20          	sub    $0x20,%rsp
  80333c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803340:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803348:	be 00 00 00 00       	mov    $0x0,%esi
  80334d:	48 89 c7             	mov    %rax,%rdi
  803350:	48 b8 22 34 80 00 00 	movabs $0x803422,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803363:	79 05                	jns    80336a <stat+0x36>
		return fd;
  803365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803368:	eb 2f                	jmp    803399 <stat+0x65>
	r = fstat(fd, stat);
  80336a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80336e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803371:	48 89 d6             	mov    %rdx,%rsi
  803374:	89 c7                	mov    %eax,%edi
  803376:	48 b8 7b 32 80 00 00 	movabs $0x80327b,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	89 c7                	mov    %eax,%edi
  80338a:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
	return r;
  803396:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803399:	c9                   	leaveq 
  80339a:	c3                   	retq   

000000000080339b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80339b:	55                   	push   %rbp
  80339c:	48 89 e5             	mov    %rsp,%rbp
  80339f:	48 83 ec 10          	sub    $0x10,%rsp
  8033a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8033aa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033b1:	00 00 00 
  8033b4:	8b 00                	mov    (%rax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	75 1d                	jne    8033d7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8033bf:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
  8033cb:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8033d2:	00 00 00 
  8033d5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033d7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033de:	00 00 00 
  8033e1:	8b 00                	mov    (%rax),%eax
  8033e3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033eb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8033f2:	00 00 00 
  8033f5:	89 c7                	mov    %eax,%edi
  8033f7:	48 b8 28 26 80 00 00 	movabs $0x802628,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803407:	ba 00 00 00 00       	mov    $0x0,%edx
  80340c:	48 89 c6             	mov    %rax,%rsi
  80340f:	bf 00 00 00 00       	mov    $0x0,%edi
  803414:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 30          	sub    $0x30,%rsp
  80342a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80342e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803431:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803438:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80343f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803446:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80344b:	75 08                	jne    803455 <open+0x33>
	{
		return r;
  80344d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803450:	e9 f2 00 00 00       	jmpq   803547 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803459:	48 89 c7             	mov    %rax,%rdi
  80345c:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
  803468:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80346b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  803472:	7e 0a                	jle    80347e <open+0x5c>
	{
		return -E_BAD_PATH;
  803474:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803479:	e9 c9 00 00 00       	jmpq   803547 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80347e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803485:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803486:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80348a:	48 89 c7             	mov    %rax,%rdi
  80348d:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a0:	78 09                	js     8034ab <open+0x89>
  8034a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a6:	48 85 c0             	test   %rax,%rax
  8034a9:	75 08                	jne    8034b3 <open+0x91>
		{
			return r;
  8034ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ae:	e9 94 00 00 00       	jmpq   803547 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8034b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b7:	ba 00 04 00 00       	mov    $0x400,%edx
  8034bc:	48 89 c6             	mov    %rax,%rsi
  8034bf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8034c6:	00 00 00 
  8034c9:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8034d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034dc:	00 00 00 
  8034df:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8034e2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8034e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ec:	48 89 c6             	mov    %rax,%rsi
  8034ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8034f4:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 2b                	jns    803534 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350d:	be 00 00 00 00       	mov    $0x0,%esi
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
  803521:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803524:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803528:	79 05                	jns    80352f <open+0x10d>
			{
				return d;
  80352a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352d:	eb 18                	jmp    803547 <open+0x125>
			}
			return r;
  80352f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803532:	eb 13                	jmp    803547 <open+0x125>
		}	
		return fd2num(fd_store);
  803534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803538:	48 89 c7             	mov    %rax,%rdi
  80353b:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803547:	c9                   	leaveq 
  803548:	c3                   	retq   

0000000000803549 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803549:	55                   	push   %rbp
  80354a:	48 89 e5             	mov    %rsp,%rbp
  80354d:	48 83 ec 10          	sub    $0x10,%rsp
  803551:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803559:	8b 50 0c             	mov    0xc(%rax),%edx
  80355c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803563:	00 00 00 
  803566:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803568:	be 00 00 00 00       	mov    $0x0,%esi
  80356d:	bf 06 00 00 00       	mov    $0x6,%edi
  803572:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
}
  80357e:	c9                   	leaveq 
  80357f:	c3                   	retq   

0000000000803580 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803580:	55                   	push   %rbp
  803581:	48 89 e5             	mov    %rsp,%rbp
  803584:	48 83 ec 30          	sub    $0x30,%rsp
  803588:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80358c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803590:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80359b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035a0:	74 07                	je     8035a9 <devfile_read+0x29>
  8035a2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035a7:	75 07                	jne    8035b0 <devfile_read+0x30>
		return -E_INVAL;
  8035a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8035ae:	eb 77                	jmp    803627 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8035b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035be:	00 00 00 
  8035c1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035c3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035ca:	00 00 00 
  8035cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035d1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8035d5:	be 00 00 00 00       	mov    $0x0,%esi
  8035da:	bf 03 00 00 00       	mov    $0x3,%edi
  8035df:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  8035e6:	00 00 00 
  8035e9:	ff d0                	callq  *%rax
  8035eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f2:	7f 05                	jg     8035f9 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8035f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f7:	eb 2e                	jmp    803627 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8035f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fc:	48 63 d0             	movslq %eax,%rdx
  8035ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803603:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80360a:	00 00 00 
  80360d:	48 89 c7             	mov    %rax,%rdi
  803610:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80361c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803620:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803624:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803627:	c9                   	leaveq 
  803628:	c3                   	retq   

0000000000803629 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803629:	55                   	push   %rbp
  80362a:	48 89 e5             	mov    %rsp,%rbp
  80362d:	48 83 ec 30          	sub    $0x30,%rsp
  803631:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803635:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803639:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80363d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803644:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803649:	74 07                	je     803652 <devfile_write+0x29>
  80364b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803650:	75 08                	jne    80365a <devfile_write+0x31>
		return r;
  803652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803655:	e9 9a 00 00 00       	jmpq   8036f4 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80365a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365e:	8b 50 0c             	mov    0xc(%rax),%edx
  803661:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803668:	00 00 00 
  80366b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80366d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803674:	00 
  803675:	76 08                	jbe    80367f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803677:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80367e:	00 
	}
	fsipcbuf.write.req_n = n;
  80367f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803686:	00 00 00 
  803689:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80368d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803691:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803695:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803699:	48 89 c6             	mov    %rax,%rsi
  80369c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8036a3:	00 00 00 
  8036a6:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8036b2:	be 00 00 00 00       	mov    $0x0,%esi
  8036b7:	bf 04 00 00 00       	mov    $0x4,%edi
  8036bc:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036cf:	7f 20                	jg     8036f1 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8036d1:	48 bf 86 4c 80 00 00 	movabs $0x804c86,%rdi
  8036d8:	00 00 00 
  8036db:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e0:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8036e7:	00 00 00 
  8036ea:	ff d2                	callq  *%rdx
		return r;
  8036ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ef:	eb 03                	jmp    8036f4 <devfile_write+0xcb>
	}
	return r;
  8036f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8036f4:	c9                   	leaveq 
  8036f5:	c3                   	retq   

00000000008036f6 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8036f6:	55                   	push   %rbp
  8036f7:	48 89 e5             	mov    %rsp,%rbp
  8036fa:	48 83 ec 20          	sub    $0x20,%rsp
  8036fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803702:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370a:	8b 50 0c             	mov    0xc(%rax),%edx
  80370d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803714:	00 00 00 
  803717:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803719:	be 00 00 00 00       	mov    $0x0,%esi
  80371e:	bf 05 00 00 00       	mov    $0x5,%edi
  803723:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  80372a:	00 00 00 
  80372d:	ff d0                	callq  *%rax
  80372f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803732:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803736:	79 05                	jns    80373d <devfile_stat+0x47>
		return r;
  803738:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373b:	eb 56                	jmp    803793 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80373d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803741:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803748:	00 00 00 
  80374b:	48 89 c7             	mov    %rax,%rdi
  80374e:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803755:	00 00 00 
  803758:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80375a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803761:	00 00 00 
  803764:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80376a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803774:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80377b:	00 00 00 
  80377e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803784:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803788:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80378e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803793:	c9                   	leaveq 
  803794:	c3                   	retq   

0000000000803795 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803795:	55                   	push   %rbp
  803796:	48 89 e5             	mov    %rsp,%rbp
  803799:	48 83 ec 10          	sub    $0x10,%rsp
  80379d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8037a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8037ab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8037b2:	00 00 00 
  8037b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8037b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8037be:	00 00 00 
  8037c1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037c4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8037c7:	be 00 00 00 00       	mov    $0x0,%esi
  8037cc:	bf 02 00 00 00       	mov    $0x2,%edi
  8037d1:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  8037d8:	00 00 00 
  8037db:	ff d0                	callq  *%rax
}
  8037dd:	c9                   	leaveq 
  8037de:	c3                   	retq   

00000000008037df <remove>:

// Delete a file
int
remove(const char *path)
{
  8037df:	55                   	push   %rbp
  8037e0:	48 89 e5             	mov    %rsp,%rbp
  8037e3:	48 83 ec 10          	sub    $0x10,%rsp
  8037e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8037eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ef:	48 89 c7             	mov    %rax,%rdi
  8037f2:	48 b8 ad 11 80 00 00 	movabs $0x8011ad,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
  8037fe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803803:	7e 07                	jle    80380c <remove+0x2d>
		return -E_BAD_PATH;
  803805:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80380a:	eb 33                	jmp    80383f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80380c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803810:	48 89 c6             	mov    %rax,%rsi
  803813:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80381a:	00 00 00 
  80381d:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803824:	00 00 00 
  803827:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803829:	be 00 00 00 00       	mov    $0x0,%esi
  80382e:	bf 07 00 00 00       	mov    $0x7,%edi
  803833:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803845:	be 00 00 00 00       	mov    $0x0,%esi
  80384a:	bf 08 00 00 00       	mov    $0x8,%edi
  80384f:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
}
  80385b:	5d                   	pop    %rbp
  80385c:	c3                   	retq   

000000000080385d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
  803861:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803868:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80386f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803876:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80387d:	be 00 00 00 00       	mov    $0x0,%esi
  803882:	48 89 c7             	mov    %rax,%rdi
  803885:	48 b8 22 34 80 00 00 	movabs $0x803422,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
  803891:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803894:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803898:	79 28                	jns    8038c2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80389a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389d:	89 c6                	mov    %eax,%esi
  80389f:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  8038a6:	00 00 00 
  8038a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ae:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8038b5:	00 00 00 
  8038b8:	ff d2                	callq  *%rdx
		return fd_src;
  8038ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bd:	e9 74 01 00 00       	jmpq   803a36 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8038c2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8038c9:	be 01 01 00 00       	mov    $0x101,%esi
  8038ce:	48 89 c7             	mov    %rax,%rdi
  8038d1:	48 b8 22 34 80 00 00 	movabs $0x803422,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
  8038dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8038e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038e4:	79 39                	jns    80391f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8038e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e9:	89 c6                	mov    %eax,%esi
  8038eb:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  8038f2:	00 00 00 
  8038f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fa:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803901:	00 00 00 
  803904:	ff d2                	callq  *%rdx
		close(fd_src);
  803906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803909:	89 c7                	mov    %eax,%edi
  80390b:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
		return fd_dest;
  803917:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80391a:	e9 17 01 00 00       	jmpq   803a36 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80391f:	eb 74                	jmp    803995 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803921:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803924:	48 63 d0             	movslq %eax,%rdx
  803927:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80392e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803931:	48 89 ce             	mov    %rcx,%rsi
  803934:	89 c7                	mov    %eax,%edi
  803936:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
  803942:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803945:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803949:	79 4a                	jns    803995 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80394b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80394e:	89 c6                	mov    %eax,%esi
  803950:	48 bf d2 4c 80 00 00 	movabs $0x804cd2,%rdi
  803957:	00 00 00 
  80395a:	b8 00 00 00 00       	mov    $0x0,%eax
  80395f:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  803966:	00 00 00 
  803969:	ff d2                	callq  *%rdx
			close(fd_src);
  80396b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396e:	89 c7                	mov    %eax,%edi
  803970:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803977:	00 00 00 
  80397a:	ff d0                	callq  *%rax
			close(fd_dest);
  80397c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80397f:	89 c7                	mov    %eax,%edi
  803981:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
			return write_size;
  80398d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803990:	e9 a1 00 00 00       	jmpq   803a36 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803995:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80399c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399f:	ba 00 02 00 00       	mov    $0x200,%edx
  8039a4:	48 89 ce             	mov    %rcx,%rsi
  8039a7:	89 c7                	mov    %eax,%edi
  8039a9:	48 b8 7f 2f 80 00 00 	movabs $0x802f7f,%rax
  8039b0:	00 00 00 
  8039b3:	ff d0                	callq  *%rax
  8039b5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039bc:	0f 8f 5f ff ff ff    	jg     803921 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8039c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039c6:	79 47                	jns    803a0f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8039c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039cb:	89 c6                	mov    %eax,%esi
  8039cd:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  8039d4:	00 00 00 
  8039d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dc:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8039e3:	00 00 00 
  8039e6:	ff d2                	callq  *%rdx
		close(fd_src);
  8039e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039eb:	89 c7                	mov    %eax,%edi
  8039ed:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
		close(fd_dest);
  8039f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039fc:	89 c7                	mov    %eax,%edi
  8039fe:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
		return read_size;
  803a0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a0d:	eb 27                	jmp    803a36 <copy+0x1d9>
	}
	close(fd_src);
  803a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a12:	89 c7                	mov    %eax,%edi
  803a14:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
	close(fd_dest);
  803a20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a23:	89 c7                	mov    %eax,%edi
  803a25:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
	return 0;
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803a36:	c9                   	leaveq 
  803a37:	c3                   	retq   

0000000000803a38 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a38:	55                   	push   %rbp
  803a39:	48 89 e5             	mov    %rsp,%rbp
  803a3c:	48 83 ec 18          	sub    $0x18,%rsp
  803a40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803a44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a48:	48 c1 e8 15          	shr    $0x15,%rax
  803a4c:	48 89 c2             	mov    %rax,%rdx
  803a4f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a56:	01 00 00 
  803a59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a5d:	83 e0 01             	and    $0x1,%eax
  803a60:	48 85 c0             	test   %rax,%rax
  803a63:	75 07                	jne    803a6c <pageref+0x34>
		return 0;
  803a65:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6a:	eb 53                	jmp    803abf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a70:	48 c1 e8 0c          	shr    $0xc,%rax
  803a74:	48 89 c2             	mov    %rax,%rdx
  803a77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a7e:	01 00 00 
  803a81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8d:	83 e0 01             	and    $0x1,%eax
  803a90:	48 85 c0             	test   %rax,%rax
  803a93:	75 07                	jne    803a9c <pageref+0x64>
		return 0;
  803a95:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9a:	eb 23                	jmp    803abf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa0:	48 c1 e8 0c          	shr    $0xc,%rax
  803aa4:	48 89 c2             	mov    %rax,%rdx
  803aa7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803aae:	00 00 00 
  803ab1:	48 c1 e2 04          	shl    $0x4,%rdx
  803ab5:	48 01 d0             	add    %rdx,%rax
  803ab8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803abc:	0f b7 c0             	movzwl %ax,%eax
}
  803abf:	c9                   	leaveq 
  803ac0:	c3                   	retq   

0000000000803ac1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ac1:	55                   	push   %rbp
  803ac2:	48 89 e5             	mov    %rsp,%rbp
  803ac5:	53                   	push   %rbx
  803ac6:	48 83 ec 38          	sub    $0x38,%rsp
  803aca:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ace:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ad2:	48 89 c7             	mov    %rax,%rdi
  803ad5:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
  803ae1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ae4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ae8:	0f 88 bf 01 00 00    	js     803cad <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af2:	ba 07 04 00 00       	mov    $0x407,%edx
  803af7:	48 89 c6             	mov    %rax,%rsi
  803afa:	bf 00 00 00 00       	mov    $0x0,%edi
  803aff:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
  803b0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b12:	0f 88 95 01 00 00    	js     803cad <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b18:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b1c:	48 89 c7             	mov    %rax,%rdi
  803b1f:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
  803b2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b32:	0f 88 5d 01 00 00    	js     803c95 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3c:	ba 07 04 00 00       	mov    $0x407,%edx
  803b41:	48 89 c6             	mov    %rax,%rsi
  803b44:	bf 00 00 00 00       	mov    $0x0,%edi
  803b49:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
  803b55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b5c:	0f 88 33 01 00 00    	js     803c95 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b66:	48 89 c7             	mov    %rax,%rdi
  803b69:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
  803b75:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7d:	ba 07 04 00 00       	mov    $0x407,%edx
  803b82:	48 89 c6             	mov    %rax,%rsi
  803b85:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8a:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b9d:	79 05                	jns    803ba4 <pipe+0xe3>
		goto err2;
  803b9f:	e9 d9 00 00 00       	jmpq   803c7d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ba4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba8:	48 89 c7             	mov    %rax,%rdi
  803bab:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
  803bb7:	48 89 c2             	mov    %rax,%rdx
  803bba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbe:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803bc4:	48 89 d1             	mov    %rdx,%rcx
  803bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  803bcc:	48 89 c6             	mov    %rax,%rsi
  803bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd4:	48 b8 98 1b 80 00 00 	movabs $0x801b98,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
  803be0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803be7:	79 1b                	jns    803c04 <pipe+0x143>
		goto err3;
  803be9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803bea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bee:	48 89 c6             	mov    %rax,%rsi
  803bf1:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf6:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax
  803c02:	eb 79                	jmp    803c7d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c08:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c0f:	00 00 00 
  803c12:	8b 12                	mov    (%rdx),%edx
  803c14:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c25:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c2c:	00 00 00 
  803c2f:	8b 12                	mov    (%rdx),%edx
  803c31:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c42:	48 89 c7             	mov    %rax,%rdi
  803c45:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  803c4c:	00 00 00 
  803c4f:	ff d0                	callq  *%rax
  803c51:	89 c2                	mov    %eax,%edx
  803c53:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c57:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c59:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c5d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c65:	48 89 c7             	mov    %rax,%rdi
  803c68:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  803c6f:	00 00 00 
  803c72:	ff d0                	callq  *%rax
  803c74:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c76:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7b:	eb 33                	jmp    803cb0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803c7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c81:	48 89 c6             	mov    %rax,%rsi
  803c84:	bf 00 00 00 00       	mov    $0x0,%edi
  803c89:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c99:	48 89 c6             	mov    %rax,%rsi
  803c9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca1:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
err:
	return r;
  803cad:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803cb0:	48 83 c4 38          	add    $0x38,%rsp
  803cb4:	5b                   	pop    %rbx
  803cb5:	5d                   	pop    %rbp
  803cb6:	c3                   	retq   

0000000000803cb7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803cb7:	55                   	push   %rbp
  803cb8:	48 89 e5             	mov    %rsp,%rbp
  803cbb:	53                   	push   %rbx
  803cbc:	48 83 ec 28          	sub    $0x28,%rsp
  803cc0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cc4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cc8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ccf:	00 00 00 
  803cd2:	48 8b 00             	mov    (%rax),%rax
  803cd5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cdb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803cde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce2:	48 89 c7             	mov    %rax,%rdi
  803ce5:	48 b8 38 3a 80 00 00 	movabs $0x803a38,%rax
  803cec:	00 00 00 
  803cef:	ff d0                	callq  *%rax
  803cf1:	89 c3                	mov    %eax,%ebx
  803cf3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf7:	48 89 c7             	mov    %rax,%rdi
  803cfa:	48 b8 38 3a 80 00 00 	movabs $0x803a38,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
  803d06:	39 c3                	cmp    %eax,%ebx
  803d08:	0f 94 c0             	sete   %al
  803d0b:	0f b6 c0             	movzbl %al,%eax
  803d0e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d11:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d18:	00 00 00 
  803d1b:	48 8b 00             	mov    (%rax),%rax
  803d1e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d24:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d2d:	75 05                	jne    803d34 <_pipeisclosed+0x7d>
			return ret;
  803d2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803d32:	eb 4f                	jmp    803d83 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d37:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d3a:	74 42                	je     803d7e <_pipeisclosed+0xc7>
  803d3c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d40:	75 3c                	jne    803d7e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d42:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d49:	00 00 00 
  803d4c:	48 8b 00             	mov    (%rax),%rax
  803d4f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d55:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5b:	89 c6                	mov    %eax,%esi
  803d5d:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  803d64:	00 00 00 
  803d67:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6c:	49 b8 64 06 80 00 00 	movabs $0x800664,%r8
  803d73:	00 00 00 
  803d76:	41 ff d0             	callq  *%r8
	}
  803d79:	e9 4a ff ff ff       	jmpq   803cc8 <_pipeisclosed+0x11>
  803d7e:	e9 45 ff ff ff       	jmpq   803cc8 <_pipeisclosed+0x11>
}
  803d83:	48 83 c4 28          	add    $0x28,%rsp
  803d87:	5b                   	pop    %rbx
  803d88:	5d                   	pop    %rbp
  803d89:	c3                   	retq   

0000000000803d8a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803d8a:	55                   	push   %rbp
  803d8b:	48 89 e5             	mov    %rsp,%rbp
  803d8e:	48 83 ec 30          	sub    $0x30,%rsp
  803d92:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d95:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d9c:	48 89 d6             	mov    %rdx,%rsi
  803d9f:	89 c7                	mov    %eax,%edi
  803da1:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
  803dad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db4:	79 05                	jns    803dbb <pipeisclosed+0x31>
		return r;
  803db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db9:	eb 31                	jmp    803dec <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dbf:	48 89 c7             	mov    %rax,%rdi
  803dc2:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803dc9:	00 00 00 
  803dcc:	ff d0                	callq  *%rax
  803dce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dda:	48 89 d6             	mov    %rdx,%rsi
  803ddd:	48 89 c7             	mov    %rax,%rdi
  803de0:	48 b8 b7 3c 80 00 00 	movabs $0x803cb7,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
}
  803dec:	c9                   	leaveq 
  803ded:	c3                   	retq   

0000000000803dee <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dee:	55                   	push   %rbp
  803def:	48 89 e5             	mov    %rsp,%rbp
  803df2:	48 83 ec 40          	sub    $0x40,%rsp
  803df6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dfa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dfe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e06:	48 89 c7             	mov    %rax,%rdi
  803e09:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	callq  *%rax
  803e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e21:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e28:	00 
  803e29:	e9 92 00 00 00       	jmpq   803ec0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803e2e:	eb 41                	jmp    803e71 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e30:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e35:	74 09                	je     803e40 <devpipe_read+0x52>
				return i;
  803e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e3b:	e9 92 00 00 00       	jmpq   803ed2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e48:	48 89 d6             	mov    %rdx,%rsi
  803e4b:	48 89 c7             	mov    %rax,%rdi
  803e4e:	48 b8 b7 3c 80 00 00 	movabs $0x803cb7,%rax
  803e55:	00 00 00 
  803e58:	ff d0                	callq  *%rax
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	74 07                	je     803e65 <devpipe_read+0x77>
				return 0;
  803e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e63:	eb 6d                	jmp    803ed2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e65:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e75:	8b 10                	mov    (%rax),%edx
  803e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7b:	8b 40 04             	mov    0x4(%rax),%eax
  803e7e:	39 c2                	cmp    %eax,%edx
  803e80:	74 ae                	je     803e30 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e8a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e92:	8b 00                	mov    (%rax),%eax
  803e94:	99                   	cltd   
  803e95:	c1 ea 1b             	shr    $0x1b,%edx
  803e98:	01 d0                	add    %edx,%eax
  803e9a:	83 e0 1f             	and    $0x1f,%eax
  803e9d:	29 d0                	sub    %edx,%eax
  803e9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea3:	48 98                	cltq   
  803ea5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803eaa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb0:	8b 00                	mov    (%rax),%eax
  803eb2:	8d 50 01             	lea    0x1(%rax),%edx
  803eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ebb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ec8:	0f 82 60 ff ff ff    	jb     803e2e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ed2:	c9                   	leaveq 
  803ed3:	c3                   	retq   

0000000000803ed4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ed4:	55                   	push   %rbp
  803ed5:	48 89 e5             	mov    %rsp,%rbp
  803ed8:	48 83 ec 40          	sub    $0x40,%rsp
  803edc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ee0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ee4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eec:	48 89 c7             	mov    %rax,%rdi
  803eef:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803ef6:	00 00 00 
  803ef9:	ff d0                	callq  *%rax
  803efb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f07:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f0e:	00 
  803f0f:	e9 8e 00 00 00       	jmpq   803fa2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f14:	eb 31                	jmp    803f47 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1e:	48 89 d6             	mov    %rdx,%rsi
  803f21:	48 89 c7             	mov    %rax,%rdi
  803f24:	48 b8 b7 3c 80 00 00 	movabs $0x803cb7,%rax
  803f2b:	00 00 00 
  803f2e:	ff d0                	callq  *%rax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	74 07                	je     803f3b <devpipe_write+0x67>
				return 0;
  803f34:	b8 00 00 00 00       	mov    $0x0,%eax
  803f39:	eb 79                	jmp    803fb4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f3b:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f4b:	8b 40 04             	mov    0x4(%rax),%eax
  803f4e:	48 63 d0             	movslq %eax,%rdx
  803f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f55:	8b 00                	mov    (%rax),%eax
  803f57:	48 98                	cltq   
  803f59:	48 83 c0 20          	add    $0x20,%rax
  803f5d:	48 39 c2             	cmp    %rax,%rdx
  803f60:	73 b4                	jae    803f16 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f66:	8b 40 04             	mov    0x4(%rax),%eax
  803f69:	99                   	cltd   
  803f6a:	c1 ea 1b             	shr    $0x1b,%edx
  803f6d:	01 d0                	add    %edx,%eax
  803f6f:	83 e0 1f             	and    $0x1f,%eax
  803f72:	29 d0                	sub    %edx,%eax
  803f74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f78:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f7c:	48 01 ca             	add    %rcx,%rdx
  803f7f:	0f b6 0a             	movzbl (%rdx),%ecx
  803f82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f86:	48 98                	cltq   
  803f88:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f90:	8b 40 04             	mov    0x4(%rax),%eax
  803f93:	8d 50 01             	lea    0x1(%rax),%edx
  803f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f9a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f9d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803faa:	0f 82 64 ff ff ff    	jb     803f14 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fb4:	c9                   	leaveq 
  803fb5:	c3                   	retq   

0000000000803fb6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803fb6:	55                   	push   %rbp
  803fb7:	48 89 e5             	mov    %rsp,%rbp
  803fba:	48 83 ec 20          	sub    $0x20,%rsp
  803fbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803fc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fca:	48 89 c7             	mov    %rax,%rdi
  803fcd:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803fd4:	00 00 00 
  803fd7:	ff d0                	callq  *%rax
  803fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803fdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fe1:	48 be 18 4d 80 00 00 	movabs $0x804d18,%rsi
  803fe8:	00 00 00 
  803feb:	48 89 c7             	mov    %rax,%rdi
  803fee:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  803ff5:	00 00 00 
  803ff8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ffe:	8b 50 04             	mov    0x4(%rax),%edx
  804001:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804005:	8b 00                	mov    (%rax),%eax
  804007:	29 c2                	sub    %eax,%edx
  804009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804013:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804017:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80401e:	00 00 00 
	stat->st_dev = &devpipe;
  804021:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804025:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80402c:	00 00 00 
  80402f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80403b:	c9                   	leaveq 
  80403c:	c3                   	retq   

000000000080403d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80403d:	55                   	push   %rbp
  80403e:	48 89 e5             	mov    %rsp,%rbp
  804041:	48 83 ec 10          	sub    $0x10,%rsp
  804045:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404d:	48 89 c6             	mov    %rax,%rsi
  804050:	bf 00 00 00 00       	mov    $0x0,%edi
  804055:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  80405c:	00 00 00 
  80405f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804065:	48 89 c7             	mov    %rax,%rdi
  804068:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  80406f:	00 00 00 
  804072:	ff d0                	callq  *%rax
  804074:	48 89 c6             	mov    %rax,%rsi
  804077:	bf 00 00 00 00       	mov    $0x0,%edi
  80407c:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  804083:	00 00 00 
  804086:	ff d0                	callq  *%rax
}
  804088:	c9                   	leaveq 
  804089:	c3                   	retq   

000000000080408a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80408a:	55                   	push   %rbp
  80408b:	48 89 e5             	mov    %rsp,%rbp
  80408e:	48 83 ec 20          	sub    $0x20,%rsp
  804092:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804095:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804098:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80409b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80409f:	be 01 00 00 00       	mov    $0x1,%esi
  8040a4:	48 89 c7             	mov    %rax,%rdi
  8040a7:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
}
  8040b3:	c9                   	leaveq 
  8040b4:	c3                   	retq   

00000000008040b5 <getchar>:

int
getchar(void)
{
  8040b5:	55                   	push   %rbp
  8040b6:	48 89 e5             	mov    %rsp,%rbp
  8040b9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040bd:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040c1:	ba 01 00 00 00       	mov    $0x1,%edx
  8040c6:	48 89 c6             	mov    %rax,%rsi
  8040c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ce:	48 b8 7f 2f 80 00 00 	movabs $0x802f7f,%rax
  8040d5:	00 00 00 
  8040d8:	ff d0                	callq  *%rax
  8040da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8040dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e1:	79 05                	jns    8040e8 <getchar+0x33>
		return r;
  8040e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e6:	eb 14                	jmp    8040fc <getchar+0x47>
	if (r < 1)
  8040e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ec:	7f 07                	jg     8040f5 <getchar+0x40>
		return -E_EOF;
  8040ee:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8040f3:	eb 07                	jmp    8040fc <getchar+0x47>
	return c;
  8040f5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8040f9:	0f b6 c0             	movzbl %al,%eax
}
  8040fc:	c9                   	leaveq 
  8040fd:	c3                   	retq   

00000000008040fe <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040fe:	55                   	push   %rbp
  8040ff:	48 89 e5             	mov    %rsp,%rbp
  804102:	48 83 ec 20          	sub    $0x20,%rsp
  804106:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804109:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80410d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804110:	48 89 d6             	mov    %rdx,%rsi
  804113:	89 c7                	mov    %eax,%edi
  804115:	48 b8 4d 2b 80 00 00 	movabs $0x802b4d,%rax
  80411c:	00 00 00 
  80411f:	ff d0                	callq  *%rax
  804121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804128:	79 05                	jns    80412f <iscons+0x31>
		return r;
  80412a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80412d:	eb 1a                	jmp    804149 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80412f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804133:	8b 10                	mov    (%rax),%edx
  804135:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80413c:	00 00 00 
  80413f:	8b 00                	mov    (%rax),%eax
  804141:	39 c2                	cmp    %eax,%edx
  804143:	0f 94 c0             	sete   %al
  804146:	0f b6 c0             	movzbl %al,%eax
}
  804149:	c9                   	leaveq 
  80414a:	c3                   	retq   

000000000080414b <opencons>:

int
opencons(void)
{
  80414b:	55                   	push   %rbp
  80414c:	48 89 e5             	mov    %rsp,%rbp
  80414f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804153:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804157:	48 89 c7             	mov    %rax,%rdi
  80415a:	48 b8 b5 2a 80 00 00 	movabs $0x802ab5,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
  804166:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416d:	79 05                	jns    804174 <opencons+0x29>
		return r;
  80416f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804172:	eb 5b                	jmp    8041cf <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804178:	ba 07 04 00 00       	mov    $0x407,%edx
  80417d:	48 89 c6             	mov    %rax,%rsi
  804180:	bf 00 00 00 00       	mov    $0x0,%edi
  804185:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80418c:	00 00 00 
  80418f:	ff d0                	callq  *%rax
  804191:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804194:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804198:	79 05                	jns    80419f <opencons+0x54>
		return r;
  80419a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419d:	eb 30                	jmp    8041cf <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80419f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a3:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8041aa:	00 00 00 
  8041ad:	8b 12                	mov    (%rdx),%edx
  8041af:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8041b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c0:	48 89 c7             	mov    %rax,%rdi
  8041c3:	48 b8 67 2a 80 00 00 	movabs $0x802a67,%rax
  8041ca:	00 00 00 
  8041cd:	ff d0                	callq  *%rax
}
  8041cf:	c9                   	leaveq 
  8041d0:	c3                   	retq   

00000000008041d1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041d1:	55                   	push   %rbp
  8041d2:	48 89 e5             	mov    %rsp,%rbp
  8041d5:	48 83 ec 30          	sub    $0x30,%rsp
  8041d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8041e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8041ea:	75 07                	jne    8041f3 <devcons_read+0x22>
		return 0;
  8041ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f1:	eb 4b                	jmp    80423e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8041f3:	eb 0c                	jmp    804201 <devcons_read+0x30>
		sys_yield();
  8041f5:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8041fc:	00 00 00 
  8041ff:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804201:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  804208:	00 00 00 
  80420b:	ff d0                	callq  *%rax
  80420d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804214:	74 df                	je     8041f5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80421a:	79 05                	jns    804221 <devcons_read+0x50>
		return c;
  80421c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421f:	eb 1d                	jmp    80423e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804221:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804225:	75 07                	jne    80422e <devcons_read+0x5d>
		return 0;
  804227:	b8 00 00 00 00       	mov    $0x0,%eax
  80422c:	eb 10                	jmp    80423e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80422e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804231:	89 c2                	mov    %eax,%edx
  804233:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804237:	88 10                	mov    %dl,(%rax)
	return 1;
  804239:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80423e:	c9                   	leaveq 
  80423f:	c3                   	retq   

0000000000804240 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804240:	55                   	push   %rbp
  804241:	48 89 e5             	mov    %rsp,%rbp
  804244:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80424b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804252:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804259:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804267:	eb 76                	jmp    8042df <devcons_write+0x9f>
		m = n - tot;
  804269:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804270:	89 c2                	mov    %eax,%edx
  804272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804275:	29 c2                	sub    %eax,%edx
  804277:	89 d0                	mov    %edx,%eax
  804279:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80427c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80427f:	83 f8 7f             	cmp    $0x7f,%eax
  804282:	76 07                	jbe    80428b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804284:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80428b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80428e:	48 63 d0             	movslq %eax,%rdx
  804291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804294:	48 63 c8             	movslq %eax,%rcx
  804297:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80429e:	48 01 c1             	add    %rax,%rcx
  8042a1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042a8:	48 89 ce             	mov    %rcx,%rsi
  8042ab:	48 89 c7             	mov    %rax,%rdi
  8042ae:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8042b5:	00 00 00 
  8042b8:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042bd:	48 63 d0             	movslq %eax,%rdx
  8042c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042c7:	48 89 d6             	mov    %rdx,%rsi
  8042ca:	48 89 c7             	mov    %rax,%rdi
  8042cd:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8042d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042dc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8042df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e2:	48 98                	cltq   
  8042e4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8042eb:	0f 82 78 ff ff ff    	jb     804269 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8042f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042f4:	c9                   	leaveq 
  8042f5:	c3                   	retq   

00000000008042f6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8042f6:	55                   	push   %rbp
  8042f7:	48 89 e5             	mov    %rsp,%rbp
  8042fa:	48 83 ec 08          	sub    $0x8,%rsp
  8042fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804307:	c9                   	leaveq 
  804308:	c3                   	retq   

0000000000804309 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804309:	55                   	push   %rbp
  80430a:	48 89 e5             	mov    %rsp,%rbp
  80430d:	48 83 ec 10          	sub    $0x10,%rsp
  804311:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804315:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431d:	48 be 24 4d 80 00 00 	movabs $0x804d24,%rsi
  804324:	00 00 00 
  804327:	48 89 c7             	mov    %rax,%rdi
  80432a:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  804331:	00 00 00 
  804334:	ff d0                	callq  *%rax
	return 0;
  804336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80433b:	c9                   	leaveq 
  80433c:	c3                   	retq   

000000000080433d <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80433d:	55                   	push   %rbp
  80433e:	48 89 e5             	mov    %rsp,%rbp
  804341:	48 83 ec 10          	sub    $0x10,%rsp
  804345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804349:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804350:	00 00 00 
  804353:	48 8b 00             	mov    (%rax),%rax
  804356:	48 85 c0             	test   %rax,%rax
  804359:	0f 85 84 00 00 00    	jne    8043e3 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80435f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804366:	00 00 00 
  804369:	48 8b 00             	mov    (%rax),%rax
  80436c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804372:	ba 07 00 00 00       	mov    $0x7,%edx
  804377:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80437c:	89 c7                	mov    %eax,%edi
  80437e:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  804385:	00 00 00 
  804388:	ff d0                	callq  *%rax
  80438a:	85 c0                	test   %eax,%eax
  80438c:	79 2a                	jns    8043b8 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80438e:	48 ba 30 4d 80 00 00 	movabs $0x804d30,%rdx
  804395:	00 00 00 
  804398:	be 23 00 00 00       	mov    $0x23,%esi
  80439d:	48 bf 57 4d 80 00 00 	movabs $0x804d57,%rdi
  8043a4:	00 00 00 
  8043a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ac:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  8043b3:	00 00 00 
  8043b6:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8043b8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043bf:	00 00 00 
  8043c2:	48 8b 00             	mov    (%rax),%rax
  8043c5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043cb:	48 be f6 43 80 00 00 	movabs $0x8043f6,%rsi
  8043d2:	00 00 00 
  8043d5:	89 c7                	mov    %eax,%edi
  8043d7:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8043de:	00 00 00 
  8043e1:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8043e3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8043ea:	00 00 00 
  8043ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043f1:	48 89 10             	mov    %rdx,(%rax)
}
  8043f4:	c9                   	leaveq 
  8043f5:	c3                   	retq   

00000000008043f6 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8043f6:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8043f9:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  804400:	00 00 00 
call *%rax
  804403:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  804405:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80440c:	00 
movq 152(%rsp), %rcx  //Load RSP
  80440d:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804414:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  804415:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  804419:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  80441c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804423:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  804424:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  804428:	4c 8b 3c 24          	mov    (%rsp),%r15
  80442c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804431:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804436:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80443b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804440:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804445:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80444a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80444f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804454:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804459:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80445e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804463:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804468:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80446d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804472:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  804476:	48 83 c4 08          	add    $0x8,%rsp
popfq
  80447a:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  80447b:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  80447c:	c3                   	retq   
