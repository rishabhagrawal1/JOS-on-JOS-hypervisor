
obj/user/testpiperace2:     file format elf64-x86-64


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
  80003c:	e8 e2 02 00 00       	callq  800323 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf e0 41 80 00 00 	movabs $0x8041e0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 97 35 80 00 00 	movabs $0x803597,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 02 42 80 00 00 	movabs $0x804202,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 1d 23 80 00 00 	movabs $0x80231d,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 20 42 80 00 00 	movabs $0x804220,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 35 29 80 00 00 	movabs $0x802935,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001d9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001e0:	00 00 00 
  8001e3:	48 01 d0             	add    %rdx,%rax
  8001e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001ea:	eb 4d                	jmp    800239 <umain+0x1f6>
		if (pipeisclosed(p[0]) != 0) {
  8001ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf 2d 42 80 00 00 	movabs $0x80422d,%rdi
  800208:	00 00 00 
  80020b:	b8 00 00 00 00       	mov    $0x0,%eax
  800210:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800217:	00 00 00 
  80021a:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  80021c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80021f:	89 c7                	mov    %eax,%edi
  800221:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
			exit();
  80022d:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800243:	83 f8 02             	cmp    $0x2,%eax
  800246:	74 a4                	je     8001ec <umain+0x1a9>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800248:	48 bf 49 42 80 00 00 	movabs $0x804249,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba 60 42 80 00 00 	movabs $0x804260,%rdx
  80027f:	00 00 00 
  800282:	be 40 00 00 00       	mov    $0x40,%esi
  800287:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80029d:	00 00 00 
  8002a0:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002a2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002a5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002a9:	48 89 d6             	mov    %rdx,%rsi
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba 8a 42 80 00 00 	movabs $0x80428a,%rdx
  8002cf:	00 00 00 
  8002d2:	be 42 00 00 00       	mov    $0x42,%esi
  8002d7:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf a2 42 80 00 00 	movabs $0x8042a2,%rdi
  80030d:	00 00 00 
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80031c:	00 00 00 
  80031f:	ff d2                	callq  *%rdx
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 83 ec 10          	sub    $0x10,%rsp
  80032b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800332:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800343:	48 98                	cltq   
  800345:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80034c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800353:	00 00 00 
  800356:	48 01 c2             	add    %rax,%rdx
  800359:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800360:	00 00 00 
  800363:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80036a:	7e 14                	jle    800380 <libmain+0x5d>
		binaryname = argv[0];
  80036c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800370:	48 8b 10             	mov    (%rax),%rdx
  800373:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80037a:	00 00 00 
  80037d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800380:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800387:	48 89 d6             	mov    %rdx,%rsi
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800398:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	c9                   	leaveq 
  8003a5:	c3                   	retq   

00000000008003a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003aa:	48 b8 07 29 80 00 00 	movabs $0x802907,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8003bb:	48 b8 26 1a 80 00 00 	movabs $0x801a26,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax

}
  8003c7:	5d                   	pop    %rbp
  8003c8:	c3                   	retq   

00000000008003c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	53                   	push   %rbx
  8003ce:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003d5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003dc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003e2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003e9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003f0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003f7:	84 c0                	test   %al,%al
  8003f9:	74 23                	je     80041e <_panic+0x55>
  8003fb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800402:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800406:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80040a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80040e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800412:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800416:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80041a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80041e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800425:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80042c:	00 00 00 
  80042f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800436:	00 00 00 
  800439:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800444:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80044b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800452:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800459:	00 00 00 
  80045c:	48 8b 18             	mov    (%rax),%rbx
  80045f:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
  80046b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800471:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800478:	41 89 c8             	mov    %ecx,%r8d
  80047b:	48 89 d1             	mov    %rdx,%rcx
  80047e:	48 89 da             	mov    %rbx,%rdx
  800481:	89 c6                	mov    %eax,%esi
  800483:	48 bf c0 42 80 00 00 	movabs $0x8042c0,%rdi
  80048a:	00 00 00 
  80048d:	b8 00 00 00 00       	mov    $0x0,%eax
  800492:	49 b9 02 06 80 00 00 	movabs $0x800602,%r9
  800499:	00 00 00 
  80049c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80049f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ad:	48 89 d6             	mov    %rdx,%rsi
  8004b0:	48 89 c7             	mov    %rax,%rdi
  8004b3:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
	cprintf("\n");
  8004bf:	48 bf e3 42 80 00 00 	movabs $0x8042e3,%rdi
  8004c6:	00 00 00 
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ce:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8004d5:	00 00 00 
  8004d8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004da:	cc                   	int3   
  8004db:	eb fd                	jmp    8004da <_panic+0x111>

00000000008004dd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004dd:	55                   	push   %rbp
  8004de:	48 89 e5             	mov    %rsp,%rbp
  8004e1:	48 83 ec 10          	sub    $0x10,%rsp
  8004e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	8d 48 01             	lea    0x1(%rax),%ecx
  8004f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f9:	89 0a                	mov    %ecx,(%rdx)
  8004fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004fe:	89 d1                	mov    %edx,%ecx
  800500:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800504:	48 98                	cltq   
  800506:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80050a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050e:	8b 00                	mov    (%rax),%eax
  800510:	3d ff 00 00 00       	cmp    $0xff,%eax
  800515:	75 2c                	jne    800543 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80051b:	8b 00                	mov    (%rax),%eax
  80051d:	48 98                	cltq   
  80051f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800523:	48 83 c2 08          	add    $0x8,%rdx
  800527:	48 89 c6             	mov    %rax,%rsi
  80052a:	48 89 d7             	mov    %rdx,%rdi
  80052d:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  800534:	00 00 00 
  800537:	ff d0                	callq  *%rax
        b->idx = 0;
  800539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800547:	8b 40 04             	mov    0x4(%rax),%eax
  80054a:	8d 50 01             	lea    0x1(%rax),%edx
  80054d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800551:	89 50 04             	mov    %edx,0x4(%rax)
}
  800554:	c9                   	leaveq 
  800555:	c3                   	retq   

0000000000800556 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800556:	55                   	push   %rbp
  800557:	48 89 e5             	mov    %rsp,%rbp
  80055a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800561:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800568:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80056f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800576:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80057d:	48 8b 0a             	mov    (%rdx),%rcx
  800580:	48 89 08             	mov    %rcx,(%rax)
  800583:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800587:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80058b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80058f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800593:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80059a:	00 00 00 
    b.cnt = 0;
  80059d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005a4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005a7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005ae:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005b5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005bc:	48 89 c6             	mov    %rax,%rsi
  8005bf:	48 bf dd 04 80 00 00 	movabs $0x8004dd,%rdi
  8005c6:	00 00 00 
  8005c9:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  8005d0:	00 00 00 
  8005d3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005d5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005db:	48 98                	cltq   
  8005dd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005e4:	48 83 c2 08          	add    $0x8,%rdx
  8005e8:	48 89 c6             	mov    %rax,%rsi
  8005eb:	48 89 d7             	mov    %rdx,%rdi
  8005ee:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800600:	c9                   	leaveq 
  800601:	c3                   	retq   

0000000000800602 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800602:	55                   	push   %rbp
  800603:	48 89 e5             	mov    %rsp,%rbp
  800606:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80060d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800614:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80061b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800622:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800629:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800630:	84 c0                	test   %al,%al
  800632:	74 20                	je     800654 <cprintf+0x52>
  800634:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800638:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80063c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800640:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800644:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800648:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80064c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800650:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800654:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80065b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800662:	00 00 00 
  800665:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80066c:	00 00 00 
  80066f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800673:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80067a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800681:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800688:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80068f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800696:	48 8b 0a             	mov    (%rdx),%rcx
  800699:	48 89 08             	mov    %rcx,(%rax)
  80069c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006ac:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006b3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ba:	48 89 d6             	mov    %rdx,%rsi
  8006bd:	48 89 c7             	mov    %rax,%rdi
  8006c0:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  8006c7:	00 00 00 
  8006ca:	ff d0                	callq  *%rax
  8006cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006d8:	c9                   	leaveq 
  8006d9:	c3                   	retq   

00000000008006da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006da:	55                   	push   %rbp
  8006db:	48 89 e5             	mov    %rsp,%rbp
  8006de:	53                   	push   %rbx
  8006df:	48 83 ec 38          	sub    $0x38,%rsp
  8006e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006ef:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006f2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006f6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800701:	77 3b                	ja     80073e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800703:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800706:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80070a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80070d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	48 f7 f3             	div    %rbx
  800719:	48 89 c2             	mov    %rax,%rdx
  80071c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80071f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800722:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072a:	41 89 f9             	mov    %edi,%r9d
  80072d:	48 89 c7             	mov    %rax,%rdi
  800730:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
  80073c:	eb 1e                	jmp    80075c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80073e:	eb 12                	jmp    800752 <printnum+0x78>
			putch(padc, putdat);
  800740:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800744:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 89 ce             	mov    %rcx,%rsi
  80074e:	89 d7                	mov    %edx,%edi
  800750:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800752:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800756:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80075a:	7f e4                	jg     800740 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80075f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800763:	ba 00 00 00 00       	mov    $0x0,%edx
  800768:	48 f7 f1             	div    %rcx
  80076b:	48 89 d0             	mov    %rdx,%rax
  80076e:	48 ba f0 44 80 00 00 	movabs $0x8044f0,%rdx
  800775:	00 00 00 
  800778:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80077c:	0f be d0             	movsbl %al,%edx
  80077f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 89 ce             	mov    %rcx,%rsi
  80078a:	89 d7                	mov    %edx,%edi
  80078c:	ff d0                	callq  *%rax
}
  80078e:	48 83 c4 38          	add    $0x38,%rsp
  800792:	5b                   	pop    %rbx
  800793:	5d                   	pop    %rbp
  800794:	c3                   	retq   

0000000000800795 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800795:	55                   	push   %rbp
  800796:	48 89 e5             	mov    %rsp,%rbp
  800799:	48 83 ec 1c          	sub    $0x1c,%rsp
  80079d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007a1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007a4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007a8:	7e 52                	jle    8007fc <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ae:	8b 00                	mov    (%rax),%eax
  8007b0:	83 f8 30             	cmp    $0x30,%eax
  8007b3:	73 24                	jae    8007d9 <getuint+0x44>
  8007b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	89 c0                	mov    %eax,%eax
  8007c5:	48 01 d0             	add    %rdx,%rax
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	8b 12                	mov    (%rdx),%edx
  8007ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d5:	89 0a                	mov    %ecx,(%rdx)
  8007d7:	eb 17                	jmp    8007f0 <getuint+0x5b>
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e1:	48 89 d0             	mov    %rdx,%rax
  8007e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f0:	48 8b 00             	mov    (%rax),%rax
  8007f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f7:	e9 a3 00 00 00       	jmpq   80089f <getuint+0x10a>
	else if (lflag)
  8007fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800800:	74 4f                	je     800851 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	8b 00                	mov    (%rax),%eax
  800808:	83 f8 30             	cmp    $0x30,%eax
  80080b:	73 24                	jae    800831 <getuint+0x9c>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	8b 00                	mov    (%rax),%eax
  80081b:	89 c0                	mov    %eax,%eax
  80081d:	48 01 d0             	add    %rdx,%rax
  800820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800824:	8b 12                	mov    (%rdx),%edx
  800826:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	89 0a                	mov    %ecx,(%rdx)
  80082f:	eb 17                	jmp    800848 <getuint+0xb3>
  800831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800835:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800839:	48 89 d0             	mov    %rdx,%rax
  80083c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800848:	48 8b 00             	mov    (%rax),%rax
  80084b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084f:	eb 4e                	jmp    80089f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	83 f8 30             	cmp    $0x30,%eax
  80085a:	73 24                	jae    800880 <getuint+0xeb>
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800873:	8b 12                	mov    (%rdx),%edx
  800875:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087c:	89 0a                	mov    %ecx,(%rdx)
  80087e:	eb 17                	jmp    800897 <getuint+0x102>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	8b 00                	mov    (%rax),%eax
  800899:	89 c0                	mov    %eax,%eax
  80089b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80089f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008a3:	c9                   	leaveq 
  8008a4:	c3                   	retq   

00000000008008a5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008a5:	55                   	push   %rbp
  8008a6:	48 89 e5             	mov    %rsp,%rbp
  8008a9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008b1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008b4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008b8:	7e 52                	jle    80090c <getint+0x67>
		x=va_arg(*ap, long long);
  8008ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008be:	8b 00                	mov    (%rax),%eax
  8008c0:	83 f8 30             	cmp    $0x30,%eax
  8008c3:	73 24                	jae    8008e9 <getint+0x44>
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d1:	8b 00                	mov    (%rax),%eax
  8008d3:	89 c0                	mov    %eax,%eax
  8008d5:	48 01 d0             	add    %rdx,%rax
  8008d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dc:	8b 12                	mov    (%rdx),%edx
  8008de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e5:	89 0a                	mov    %ecx,(%rdx)
  8008e7:	eb 17                	jmp    800900 <getint+0x5b>
  8008e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f1:	48 89 d0             	mov    %rdx,%rax
  8008f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800900:	48 8b 00             	mov    (%rax),%rax
  800903:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800907:	e9 a3 00 00 00       	jmpq   8009af <getint+0x10a>
	else if (lflag)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800910:	74 4f                	je     800961 <getint+0xbc>
		x=va_arg(*ap, long);
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	8b 00                	mov    (%rax),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 24                	jae    800941 <getint+0x9c>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	89 c0                	mov    %eax,%eax
  80092d:	48 01 d0             	add    %rdx,%rax
  800930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800934:	8b 12                	mov    (%rdx),%edx
  800936:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	89 0a                	mov    %ecx,(%rdx)
  80093f:	eb 17                	jmp    800958 <getint+0xb3>
  800941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800945:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800949:	48 89 d0             	mov    %rdx,%rax
  80094c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800958:	48 8b 00             	mov    (%rax),%rax
  80095b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095f:	eb 4e                	jmp    8009af <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	8b 00                	mov    (%rax),%eax
  800967:	83 f8 30             	cmp    $0x30,%eax
  80096a:	73 24                	jae    800990 <getint+0xeb>
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	89 c0                	mov    %eax,%eax
  80097c:	48 01 d0             	add    %rdx,%rax
  80097f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800983:	8b 12                	mov    (%rdx),%edx
  800985:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	89 0a                	mov    %ecx,(%rdx)
  80098e:	eb 17                	jmp    8009a7 <getint+0x102>
  800990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800994:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800998:	48 89 d0             	mov    %rdx,%rax
  80099b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a7:	8b 00                	mov    (%rax),%eax
  8009a9:	48 98                	cltq   
  8009ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009b3:	c9                   	leaveq 
  8009b4:	c3                   	retq   

00000000008009b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b5:	55                   	push   %rbp
  8009b6:	48 89 e5             	mov    %rsp,%rbp
  8009b9:	41 54                	push   %r12
  8009bb:	53                   	push   %rbx
  8009bc:	48 83 ec 60          	sub    $0x60,%rsp
  8009c0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009c4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009c8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009cc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009d0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009d4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009d8:	48 8b 0a             	mov    (%rdx),%rcx
  8009db:	48 89 08             	mov    %rcx,(%rax)
  8009de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ee:	eb 17                	jmp    800a07 <vprintfmt+0x52>
			if (ch == '\0')
  8009f0:	85 db                	test   %ebx,%ebx
  8009f2:	0f 84 cc 04 00 00    	je     800ec4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a00:	48 89 d6             	mov    %rdx,%rsi
  800a03:	89 df                	mov    %ebx,%edi
  800a05:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a13:	0f b6 00             	movzbl (%rax),%eax
  800a16:	0f b6 d8             	movzbl %al,%ebx
  800a19:	83 fb 25             	cmp    $0x25,%ebx
  800a1c:	75 d2                	jne    8009f0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a1e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a22:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a37:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a46:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a4a:	0f b6 00             	movzbl (%rax),%eax
  800a4d:	0f b6 d8             	movzbl %al,%ebx
  800a50:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a53:	83 f8 55             	cmp    $0x55,%eax
  800a56:	0f 87 34 04 00 00    	ja     800e90 <vprintfmt+0x4db>
  800a5c:	89 c0                	mov    %eax,%eax
  800a5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a65:	00 
  800a66:	48 b8 18 45 80 00 00 	movabs $0x804518,%rax
  800a6d:	00 00 00 
  800a70:	48 01 d0             	add    %rdx,%rax
  800a73:	48 8b 00             	mov    (%rax),%rax
  800a76:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a78:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a7c:	eb c0                	jmp    800a3e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a7e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a82:	eb ba                	jmp    800a3e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a84:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a8b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a8e:	89 d0                	mov    %edx,%eax
  800a90:	c1 e0 02             	shl    $0x2,%eax
  800a93:	01 d0                	add    %edx,%eax
  800a95:	01 c0                	add    %eax,%eax
  800a97:	01 d8                	add    %ebx,%eax
  800a99:	83 e8 30             	sub    $0x30,%eax
  800a9c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa3:	0f b6 00             	movzbl (%rax),%eax
  800aa6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa9:	83 fb 2f             	cmp    $0x2f,%ebx
  800aac:	7e 0c                	jle    800aba <vprintfmt+0x105>
  800aae:	83 fb 39             	cmp    $0x39,%ebx
  800ab1:	7f 07                	jg     800aba <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab8:	eb d1                	jmp    800a8b <vprintfmt+0xd6>
			goto process_precision;
  800aba:	eb 58                	jmp    800b14 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800abc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abf:	83 f8 30             	cmp    $0x30,%eax
  800ac2:	73 17                	jae    800adb <vprintfmt+0x126>
  800ac4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acb:	89 c0                	mov    %eax,%eax
  800acd:	48 01 d0             	add    %rdx,%rax
  800ad0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad3:	83 c2 08             	add    $0x8,%edx
  800ad6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad9:	eb 0f                	jmp    800aea <vprintfmt+0x135>
  800adb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800adf:	48 89 d0             	mov    %rdx,%rax
  800ae2:	48 83 c2 08          	add    $0x8,%rdx
  800ae6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aea:	8b 00                	mov    (%rax),%eax
  800aec:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aef:	eb 23                	jmp    800b14 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800af1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af5:	79 0c                	jns    800b03 <vprintfmt+0x14e>
				width = 0;
  800af7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800afe:	e9 3b ff ff ff       	jmpq   800a3e <vprintfmt+0x89>
  800b03:	e9 36 ff ff ff       	jmpq   800a3e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b08:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b0f:	e9 2a ff ff ff       	jmpq   800a3e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b18:	79 12                	jns    800b2c <vprintfmt+0x177>
				width = precision, precision = -1;
  800b1a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b1d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b20:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b27:	e9 12 ff ff ff       	jmpq   800a3e <vprintfmt+0x89>
  800b2c:	e9 0d ff ff ff       	jmpq   800a3e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b31:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b35:	e9 04 ff ff ff       	jmpq   800a3e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3d:	83 f8 30             	cmp    $0x30,%eax
  800b40:	73 17                	jae    800b59 <vprintfmt+0x1a4>
  800b42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b49:	89 c0                	mov    %eax,%eax
  800b4b:	48 01 d0             	add    %rdx,%rax
  800b4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b51:	83 c2 08             	add    $0x8,%edx
  800b54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b57:	eb 0f                	jmp    800b68 <vprintfmt+0x1b3>
  800b59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5d:	48 89 d0             	mov    %rdx,%rax
  800b60:	48 83 c2 08          	add    $0x8,%rdx
  800b64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b68:	8b 10                	mov    (%rax),%edx
  800b6a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b72:	48 89 ce             	mov    %rcx,%rsi
  800b75:	89 d7                	mov    %edx,%edi
  800b77:	ff d0                	callq  *%rax
			break;
  800b79:	e9 40 03 00 00       	jmpq   800ebe <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b81:	83 f8 30             	cmp    $0x30,%eax
  800b84:	73 17                	jae    800b9d <vprintfmt+0x1e8>
  800b86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8d:	89 c0                	mov    %eax,%eax
  800b8f:	48 01 d0             	add    %rdx,%rax
  800b92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b95:	83 c2 08             	add    $0x8,%edx
  800b98:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b9b:	eb 0f                	jmp    800bac <vprintfmt+0x1f7>
  800b9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba1:	48 89 d0             	mov    %rdx,%rax
  800ba4:	48 83 c2 08          	add    $0x8,%rdx
  800ba8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bac:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bae:	85 db                	test   %ebx,%ebx
  800bb0:	79 02                	jns    800bb4 <vprintfmt+0x1ff>
				err = -err;
  800bb2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bb4:	83 fb 15             	cmp    $0x15,%ebx
  800bb7:	7f 16                	jg     800bcf <vprintfmt+0x21a>
  800bb9:	48 b8 40 44 80 00 00 	movabs $0x804440,%rax
  800bc0:	00 00 00 
  800bc3:	48 63 d3             	movslq %ebx,%rdx
  800bc6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bca:	4d 85 e4             	test   %r12,%r12
  800bcd:	75 2e                	jne    800bfd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	89 d9                	mov    %ebx,%ecx
  800bd9:	48 ba 01 45 80 00 00 	movabs $0x804501,%rdx
  800be0:	00 00 00 
  800be3:	48 89 c7             	mov    %rax,%rdi
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	49 b8 cd 0e 80 00 00 	movabs $0x800ecd,%r8
  800bf2:	00 00 00 
  800bf5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bf8:	e9 c1 02 00 00       	jmpq   800ebe <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bfd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	4c 89 e1             	mov    %r12,%rcx
  800c08:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  800c0f:	00 00 00 
  800c12:	48 89 c7             	mov    %rax,%rdi
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b8 cd 0e 80 00 00 	movabs $0x800ecd,%r8
  800c21:	00 00 00 
  800c24:	41 ff d0             	callq  *%r8
			break;
  800c27:	e9 92 02 00 00       	jmpq   800ebe <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2f:	83 f8 30             	cmp    $0x30,%eax
  800c32:	73 17                	jae    800c4b <vprintfmt+0x296>
  800c34:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3b:	89 c0                	mov    %eax,%eax
  800c3d:	48 01 d0             	add    %rdx,%rax
  800c40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c43:	83 c2 08             	add    $0x8,%edx
  800c46:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c49:	eb 0f                	jmp    800c5a <vprintfmt+0x2a5>
  800c4b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c4f:	48 89 d0             	mov    %rdx,%rax
  800c52:	48 83 c2 08          	add    $0x8,%rdx
  800c56:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c5a:	4c 8b 20             	mov    (%rax),%r12
  800c5d:	4d 85 e4             	test   %r12,%r12
  800c60:	75 0a                	jne    800c6c <vprintfmt+0x2b7>
				p = "(null)";
  800c62:	49 bc 0d 45 80 00 00 	movabs $0x80450d,%r12
  800c69:	00 00 00 
			if (width > 0 && padc != '-')
  800c6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c70:	7e 3f                	jle    800cb1 <vprintfmt+0x2fc>
  800c72:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c76:	74 39                	je     800cb1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c78:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c7b:	48 98                	cltq   
  800c7d:	48 89 c6             	mov    %rax,%rsi
  800c80:	4c 89 e7             	mov    %r12,%rdi
  800c83:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  800c8a:	00 00 00 
  800c8d:	ff d0                	callq  *%rax
  800c8f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c92:	eb 17                	jmp    800cab <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c94:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca0:	48 89 ce             	mov    %rcx,%rsi
  800ca3:	89 d7                	mov    %edx,%edi
  800ca5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800caf:	7f e3                	jg     800c94 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb1:	eb 37                	jmp    800cea <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cb7:	74 1e                	je     800cd7 <vprintfmt+0x322>
  800cb9:	83 fb 1f             	cmp    $0x1f,%ebx
  800cbc:	7e 05                	jle    800cc3 <vprintfmt+0x30e>
  800cbe:	83 fb 7e             	cmp    $0x7e,%ebx
  800cc1:	7e 14                	jle    800cd7 <vprintfmt+0x322>
					putch('?', putdat);
  800cc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccb:	48 89 d6             	mov    %rdx,%rsi
  800cce:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cd3:	ff d0                	callq  *%rax
  800cd5:	eb 0f                	jmp    800ce6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdf:	48 89 d6             	mov    %rdx,%rsi
  800ce2:	89 df                	mov    %ebx,%edi
  800ce4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ce6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cea:	4c 89 e0             	mov    %r12,%rax
  800ced:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cf1:	0f b6 00             	movzbl (%rax),%eax
  800cf4:	0f be d8             	movsbl %al,%ebx
  800cf7:	85 db                	test   %ebx,%ebx
  800cf9:	74 10                	je     800d0b <vprintfmt+0x356>
  800cfb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cff:	78 b2                	js     800cb3 <vprintfmt+0x2fe>
  800d01:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d05:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d09:	79 a8                	jns    800cb3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d0b:	eb 16                	jmp    800d23 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d15:	48 89 d6             	mov    %rdx,%rsi
  800d18:	bf 20 00 00 00       	mov    $0x20,%edi
  800d1d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d27:	7f e4                	jg     800d0d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d29:	e9 90 01 00 00       	jmpq   800ebe <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d32:	be 03 00 00 00       	mov    $0x3,%esi
  800d37:	48 89 c7             	mov    %rax,%rdi
  800d3a:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  800d41:	00 00 00 
  800d44:	ff d0                	callq  *%rax
  800d46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4e:	48 85 c0             	test   %rax,%rax
  800d51:	79 1d                	jns    800d70 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d63:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d69:	48 f7 d8             	neg    %rax
  800d6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d70:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d77:	e9 d5 00 00 00       	jmpq   800e51 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d80:	be 03 00 00 00       	mov    $0x3,%esi
  800d85:	48 89 c7             	mov    %rax,%rdi
  800d88:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800d8f:	00 00 00 
  800d92:	ff d0                	callq  *%rax
  800d94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d98:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d9f:	e9 ad 00 00 00       	jmpq   800e51 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800da4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800da7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dab:	89 d6                	mov    %edx,%esi
  800dad:	48 89 c7             	mov    %rax,%rdi
  800db0:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	callq  *%rax
  800dbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dc0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dc7:	e9 85 00 00 00       	jmpq   800e51 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800dcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd4:	48 89 d6             	mov    %rdx,%rsi
  800dd7:	bf 30 00 00 00       	mov    $0x30,%edi
  800ddc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de6:	48 89 d6             	mov    %rdx,%rsi
  800de9:	bf 78 00 00 00       	mov    $0x78,%edi
  800dee:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800df0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df3:	83 f8 30             	cmp    $0x30,%eax
  800df6:	73 17                	jae    800e0f <vprintfmt+0x45a>
  800df8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dfc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dff:	89 c0                	mov    %eax,%eax
  800e01:	48 01 d0             	add    %rdx,%rax
  800e04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e07:	83 c2 08             	add    $0x8,%edx
  800e0a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e0d:	eb 0f                	jmp    800e1e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e13:	48 89 d0             	mov    %rdx,%rax
  800e16:	48 83 c2 08          	add    $0x8,%rdx
  800e1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e1e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e25:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e2c:	eb 23                	jmp    800e51 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e32:	be 03 00 00 00       	mov    $0x3,%esi
  800e37:	48 89 c7             	mov    %rax,%rdi
  800e3a:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	callq  *%rax
  800e46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e51:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e56:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e59:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e60:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e68:	45 89 c1             	mov    %r8d,%r9d
  800e6b:	41 89 f8             	mov    %edi,%r8d
  800e6e:	48 89 c7             	mov    %rax,%rdi
  800e71:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800e78:	00 00 00 
  800e7b:	ff d0                	callq  *%rax
			break;
  800e7d:	eb 3f                	jmp    800ebe <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e87:	48 89 d6             	mov    %rdx,%rsi
  800e8a:	89 df                	mov    %ebx,%edi
  800e8c:	ff d0                	callq  *%rax
			break;
  800e8e:	eb 2e                	jmp    800ebe <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e98:	48 89 d6             	mov    %rdx,%rsi
  800e9b:	bf 25 00 00 00       	mov    $0x25,%edi
  800ea0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ea2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ea7:	eb 05                	jmp    800eae <vprintfmt+0x4f9>
  800ea9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800eb2:	48 83 e8 01          	sub    $0x1,%rax
  800eb6:	0f b6 00             	movzbl (%rax),%eax
  800eb9:	3c 25                	cmp    $0x25,%al
  800ebb:	75 ec                	jne    800ea9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ebd:	90                   	nop
		}
	}
  800ebe:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebf:	e9 43 fb ff ff       	jmpq   800a07 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ec4:	48 83 c4 60          	add    $0x60,%rsp
  800ec8:	5b                   	pop    %rbx
  800ec9:	41 5c                	pop    %r12
  800ecb:	5d                   	pop    %rbp
  800ecc:	c3                   	retq   

0000000000800ecd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ecd:	55                   	push   %rbp
  800ece:	48 89 e5             	mov    %rsp,%rbp
  800ed1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ed8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800edf:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ee6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ef4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800efb:	84 c0                	test   %al,%al
  800efd:	74 20                	je     800f1f <printfmt+0x52>
  800eff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f03:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f07:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f0b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f0f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f13:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f17:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f1b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f1f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f26:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f2d:	00 00 00 
  800f30:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f37:	00 00 00 
  800f3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f3e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f45:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f4c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f53:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f5a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f61:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f68:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f6f:	48 89 c7             	mov    %rax,%rdi
  800f72:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  800f79:	00 00 00 
  800f7c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 10          	sub    $0x10,%rsp
  800f88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f93:	8b 40 10             	mov    0x10(%rax),%eax
  800f96:	8d 50 01             	lea    0x1(%rax),%edx
  800f99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa4:	48 8b 10             	mov    (%rax),%rdx
  800fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fab:	48 8b 40 08          	mov    0x8(%rax),%rax
  800faf:	48 39 c2             	cmp    %rax,%rdx
  800fb2:	73 17                	jae    800fcb <sprintputch+0x4b>
		*b->buf++ = ch;
  800fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb8:	48 8b 00             	mov    (%rax),%rax
  800fbb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fc3:	48 89 0a             	mov    %rcx,(%rdx)
  800fc6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fc9:	88 10                	mov    %dl,(%rax)
}
  800fcb:	c9                   	leaveq 
  800fcc:	c3                   	retq   

0000000000800fcd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fcd:	55                   	push   %rbp
  800fce:	48 89 e5             	mov    %rsp,%rbp
  800fd1:	48 83 ec 50          	sub    $0x50,%rsp
  800fd5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fd9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fdc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fe0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fe4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fe8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fec:	48 8b 0a             	mov    (%rdx),%rcx
  800fef:	48 89 08             	mov    %rcx,(%rax)
  800ff2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ffe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801002:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801006:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80100a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80100d:	48 98                	cltq   
  80100f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801013:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801017:	48 01 d0             	add    %rdx,%rax
  80101a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80101e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801025:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80102a:	74 06                	je     801032 <vsnprintf+0x65>
  80102c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801030:	7f 07                	jg     801039 <vsnprintf+0x6c>
		return -E_INVAL;
  801032:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801037:	eb 2f                	jmp    801068 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801039:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80103d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801041:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801045:	48 89 c6             	mov    %rax,%rsi
  801048:	48 bf 80 0f 80 00 00 	movabs $0x800f80,%rdi
  80104f:	00 00 00 
  801052:	48 b8 b5 09 80 00 00 	movabs $0x8009b5,%rax
  801059:	00 00 00 
  80105c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80105e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801062:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801065:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801068:	c9                   	leaveq 
  801069:	c3                   	retq   

000000000080106a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80106a:	55                   	push   %rbp
  80106b:	48 89 e5             	mov    %rsp,%rbp
  80106e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801075:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80107c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801082:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801089:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801090:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801097:	84 c0                	test   %al,%al
  801099:	74 20                	je     8010bb <snprintf+0x51>
  80109b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80109f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010a3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010a7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010af:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010b3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010b7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010bb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010c2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010c9:	00 00 00 
  8010cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010d3:	00 00 00 
  8010d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010ef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010f6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010fd:	48 8b 0a             	mov    (%rdx),%rcx
  801100:	48 89 08             	mov    %rcx,(%rax)
  801103:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801107:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80110b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80110f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801113:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80111a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801121:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801127:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80112e:	48 89 c7             	mov    %rax,%rdi
  801131:	48 b8 cd 0f 80 00 00 	movabs $0x800fcd,%rax
  801138:	00 00 00 
  80113b:	ff d0                	callq  *%rax
  80113d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801143:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801149:	c9                   	leaveq 
  80114a:	c3                   	retq   

000000000080114b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	48 83 ec 18          	sub    $0x18,%rsp
  801153:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80115e:	eb 09                	jmp    801169 <strlen+0x1e>
		n++;
  801160:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801164:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	75 ec                	jne    801160 <strlen+0x15>
		n++;
	return n;
  801174:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801177:	c9                   	leaveq 
  801178:	c3                   	retq   

0000000000801179 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801179:	55                   	push   %rbp
  80117a:	48 89 e5             	mov    %rsp,%rbp
  80117d:	48 83 ec 20          	sub    $0x20,%rsp
  801181:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801185:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801190:	eb 0e                	jmp    8011a0 <strnlen+0x27>
		n++;
  801192:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801196:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80119b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011a5:	74 0b                	je     8011b2 <strnlen+0x39>
  8011a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ab:	0f b6 00             	movzbl (%rax),%eax
  8011ae:	84 c0                	test   %al,%al
  8011b0:	75 e0                	jne    801192 <strnlen+0x19>
		n++;
	return n;
  8011b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b5:	c9                   	leaveq 
  8011b6:	c3                   	retq   

00000000008011b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011b7:	55                   	push   %rbp
  8011b8:	48 89 e5             	mov    %rsp,%rbp
  8011bb:	48 83 ec 20          	sub    $0x20,%rsp
  8011bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011cf:	90                   	nop
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011e4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011e8:	0f b6 12             	movzbl (%rdx),%edx
  8011eb:	88 10                	mov    %dl,(%rax)
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	75 dc                	jne    8011d0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f8:	c9                   	leaveq 
  8011f9:	c3                   	retq   

00000000008011fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011fa:	55                   	push   %rbp
  8011fb:	48 89 e5             	mov    %rsp,%rbp
  8011fe:	48 83 ec 20          	sub    $0x20,%rsp
  801202:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801206:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	48 89 c7             	mov    %rax,%rdi
  801211:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  801218:	00 00 00 
  80121b:	ff d0                	callq  *%rax
  80121d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801223:	48 63 d0             	movslq %eax,%rdx
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122a:	48 01 c2             	add    %rax,%rdx
  80122d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801231:	48 89 c6             	mov    %rax,%rsi
  801234:	48 89 d7             	mov    %rdx,%rdi
  801237:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  80123e:	00 00 00 
  801241:	ff d0                	callq  *%rax
	return dst;
  801243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801247:	c9                   	leaveq 
  801248:	c3                   	retq   

0000000000801249 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	48 83 ec 28          	sub    $0x28,%rsp
  801251:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801259:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801265:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80126c:	00 
  80126d:	eb 2a                	jmp    801299 <strncpy+0x50>
		*dst++ = *src;
  80126f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801273:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801277:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80127b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80127f:	0f b6 12             	movzbl (%rdx),%edx
  801282:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801284:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	84 c0                	test   %al,%al
  80128d:	74 05                	je     801294 <strncpy+0x4b>
			src++;
  80128f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801294:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012a1:	72 cc                	jb     80126f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012a7:	c9                   	leaveq 
  8012a8:	c3                   	retq   

00000000008012a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012a9:	55                   	push   %rbp
  8012aa:	48 89 e5             	mov    %rsp,%rbp
  8012ad:	48 83 ec 28          	sub    $0x28,%rsp
  8012b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012ca:	74 3d                	je     801309 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012cc:	eb 1d                	jmp    8012eb <strlcpy+0x42>
			*dst++ = *src++;
  8012ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012de:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012e2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012e6:	0f b6 12             	movzbl (%rdx),%edx
  8012e9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012f5:	74 0b                	je     801302 <strlcpy+0x59>
  8012f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	75 cc                	jne    8012ce <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801306:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801309:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80130d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801311:	48 29 c2             	sub    %rax,%rdx
  801314:	48 89 d0             	mov    %rdx,%rax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 10          	sub    $0x10,%rsp
  801321:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801325:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801329:	eb 0a                	jmp    801335 <strcmp+0x1c>
		p++, q++;
  80132b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801330:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	84 c0                	test   %al,%al
  80133e:	74 12                	je     801352 <strcmp+0x39>
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	0f b6 10             	movzbl (%rax),%edx
  801347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134b:	0f b6 00             	movzbl (%rax),%eax
  80134e:	38 c2                	cmp    %al,%dl
  801350:	74 d9                	je     80132b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 d0             	movzbl %al,%edx
  80135c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	0f b6 c0             	movzbl %al,%eax
  801366:	29 c2                	sub    %eax,%edx
  801368:	89 d0                	mov    %edx,%eax
}
  80136a:	c9                   	leaveq 
  80136b:	c3                   	retq   

000000000080136c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 18          	sub    $0x18,%rsp
  801374:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801378:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80137c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801380:	eb 0f                	jmp    801391 <strncmp+0x25>
		n--, p++, q++;
  801382:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801387:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801391:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801396:	74 1d                	je     8013b5 <strncmp+0x49>
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	0f b6 00             	movzbl (%rax),%eax
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 12                	je     8013b5 <strncmp+0x49>
  8013a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a7:	0f b6 10             	movzbl (%rax),%edx
  8013aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	38 c2                	cmp    %al,%dl
  8013b3:	74 cd                	je     801382 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ba:	75 07                	jne    8013c3 <strncmp+0x57>
		return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	eb 18                	jmp    8013db <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c7:	0f b6 00             	movzbl (%rax),%eax
  8013ca:	0f b6 d0             	movzbl %al,%edx
  8013cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	0f b6 c0             	movzbl %al,%eax
  8013d7:	29 c2                	sub    %eax,%edx
  8013d9:	89 d0                	mov    %edx,%eax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 0c          	sub    $0xc,%rsp
  8013e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e9:	89 f0                	mov    %esi,%eax
  8013eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ee:	eb 17                	jmp    801407 <strchr+0x2a>
		if (*s == c)
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013fa:	75 06                	jne    801402 <strchr+0x25>
			return (char *) s;
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	eb 15                	jmp    801417 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801402:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	84 c0                	test   %al,%al
  801410:	75 de                	jne    8013f0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801417:	c9                   	leaveq 
  801418:	c3                   	retq   

0000000000801419 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801419:	55                   	push   %rbp
  80141a:	48 89 e5             	mov    %rsp,%rbp
  80141d:	48 83 ec 0c          	sub    $0xc,%rsp
  801421:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801425:	89 f0                	mov    %esi,%eax
  801427:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80142a:	eb 13                	jmp    80143f <strfind+0x26>
		if (*s == c)
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	0f b6 00             	movzbl (%rax),%eax
  801433:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801436:	75 02                	jne    80143a <strfind+0x21>
			break;
  801438:	eb 10                	jmp    80144a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	84 c0                	test   %al,%al
  801448:	75 e2                	jne    80142c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80144a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80144e:	c9                   	leaveq 
  80144f:	c3                   	retq   

0000000000801450 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801450:	55                   	push   %rbp
  801451:	48 89 e5             	mov    %rsp,%rbp
  801454:	48 83 ec 18          	sub    $0x18,%rsp
  801458:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80145f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801463:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801468:	75 06                	jne    801470 <memset+0x20>
		return v;
  80146a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146e:	eb 69                	jmp    8014d9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801474:	83 e0 03             	and    $0x3,%eax
  801477:	48 85 c0             	test   %rax,%rax
  80147a:	75 48                	jne    8014c4 <memset+0x74>
  80147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	48 85 c0             	test   %rax,%rax
  801486:	75 3c                	jne    8014c4 <memset+0x74>
		c &= 0xFF;
  801488:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80148f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801492:	c1 e0 18             	shl    $0x18,%eax
  801495:	89 c2                	mov    %eax,%edx
  801497:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80149a:	c1 e0 10             	shl    $0x10,%eax
  80149d:	09 c2                	or     %eax,%edx
  80149f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a2:	c1 e0 08             	shl    $0x8,%eax
  8014a5:	09 d0                	or     %edx,%eax
  8014a7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ae:	48 c1 e8 02          	shr    $0x2,%rax
  8014b2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014bc:	48 89 d7             	mov    %rdx,%rdi
  8014bf:	fc                   	cld    
  8014c0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014c2:	eb 11                	jmp    8014d5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014cf:	48 89 d7             	mov    %rdx,%rdi
  8014d2:	fc                   	cld    
  8014d3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014d9:	c9                   	leaveq 
  8014da:	c3                   	retq   

00000000008014db <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014db:	55                   	push   %rbp
  8014dc:	48 89 e5             	mov    %rsp,%rbp
  8014df:	48 83 ec 28          	sub    $0x28,%rsp
  8014e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801507:	0f 83 88 00 00 00    	jae    801595 <memmove+0xba>
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801515:	48 01 d0             	add    %rdx,%rax
  801518:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80151c:	76 77                	jbe    801595 <memmove+0xba>
		s += n;
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801532:	83 e0 03             	and    $0x3,%eax
  801535:	48 85 c0             	test   %rax,%rax
  801538:	75 3b                	jne    801575 <memmove+0x9a>
  80153a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153e:	83 e0 03             	and    $0x3,%eax
  801541:	48 85 c0             	test   %rax,%rax
  801544:	75 2f                	jne    801575 <memmove+0x9a>
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	83 e0 03             	and    $0x3,%eax
  80154d:	48 85 c0             	test   %rax,%rax
  801550:	75 23                	jne    801575 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801556:	48 83 e8 04          	sub    $0x4,%rax
  80155a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155e:	48 83 ea 04          	sub    $0x4,%rdx
  801562:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801566:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80156a:	48 89 c7             	mov    %rax,%rdi
  80156d:	48 89 d6             	mov    %rdx,%rsi
  801570:	fd                   	std    
  801571:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801573:	eb 1d                	jmp    801592 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801579:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801581:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	48 89 d7             	mov    %rdx,%rdi
  80158c:	48 89 c1             	mov    %rax,%rcx
  80158f:	fd                   	std    
  801590:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801592:	fc                   	cld    
  801593:	eb 57                	jmp    8015ec <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	48 85 c0             	test   %rax,%rax
  80159f:	75 36                	jne    8015d7 <memmove+0xfc>
  8015a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a5:	83 e0 03             	and    $0x3,%eax
  8015a8:	48 85 c0             	test   %rax,%rax
  8015ab:	75 2a                	jne    8015d7 <memmove+0xfc>
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	83 e0 03             	and    $0x3,%eax
  8015b4:	48 85 c0             	test   %rax,%rax
  8015b7:	75 1e                	jne    8015d7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	48 c1 e8 02          	shr    $0x2,%rax
  8015c1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015cc:	48 89 c7             	mov    %rax,%rdi
  8015cf:	48 89 d6             	mov    %rdx,%rsi
  8015d2:	fc                   	cld    
  8015d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015d5:	eb 15                	jmp    8015ec <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015e3:	48 89 c7             	mov    %rax,%rdi
  8015e6:	48 89 d6             	mov    %rdx,%rsi
  8015e9:	fc                   	cld    
  8015ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f0:	c9                   	leaveq 
  8015f1:	c3                   	retq   

00000000008015f2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	48 83 ec 18          	sub    $0x18,%rsp
  8015fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801602:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80160a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80160e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801612:	48 89 ce             	mov    %rcx,%rsi
  801615:	48 89 c7             	mov    %rax,%rdi
  801618:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80161f:	00 00 00 
  801622:	ff d0                	callq  *%rax
}
  801624:	c9                   	leaveq 
  801625:	c3                   	retq   

0000000000801626 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801626:	55                   	push   %rbp
  801627:	48 89 e5             	mov    %rsp,%rbp
  80162a:	48 83 ec 28          	sub    $0x28,%rsp
  80162e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801632:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801636:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80163a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801646:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80164a:	eb 36                	jmp    801682 <memcmp+0x5c>
		if (*s1 != *s2)
  80164c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801650:	0f b6 10             	movzbl (%rax),%edx
  801653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	38 c2                	cmp    %al,%dl
  80165c:	74 1a                	je     801678 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80165e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	0f b6 d0             	movzbl %al,%edx
  801668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	0f b6 c0             	movzbl %al,%eax
  801672:	29 c2                	sub    %eax,%edx
  801674:	89 d0                	mov    %edx,%eax
  801676:	eb 20                	jmp    801698 <memcmp+0x72>
		s1++, s2++;
  801678:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80168a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80168e:	48 85 c0             	test   %rax,%rax
  801691:	75 b9                	jne    80164c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801698:	c9                   	leaveq 
  801699:	c3                   	retq   

000000000080169a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80169a:	55                   	push   %rbp
  80169b:	48 89 e5             	mov    %rsp,%rbp
  80169e:	48 83 ec 28          	sub    $0x28,%rsp
  8016a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016b5:	48 01 d0             	add    %rdx,%rax
  8016b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016bc:	eb 15                	jmp    8016d3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c2:	0f b6 10             	movzbl (%rax),%edx
  8016c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016c8:	38 c2                	cmp    %al,%dl
  8016ca:	75 02                	jne    8016ce <memfind+0x34>
			break;
  8016cc:	eb 0f                	jmp    8016dd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016db:	72 e1                	jb     8016be <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e1:	c9                   	leaveq 
  8016e2:	c3                   	retq   

00000000008016e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e3:	55                   	push   %rbp
  8016e4:	48 89 e5             	mov    %rsp,%rbp
  8016e7:	48 83 ec 34          	sub    $0x34,%rsp
  8016eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016f3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016fd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801704:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801705:	eb 05                	jmp    80170c <strtol+0x29>
		s++;
  801707:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 20                	cmp    $0x20,%al
  801715:	74 f0                	je     801707 <strtol+0x24>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	3c 09                	cmp    $0x9,%al
  801720:	74 e5                	je     801707 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	3c 2b                	cmp    $0x2b,%al
  80172b:	75 07                	jne    801734 <strtol+0x51>
		s++;
  80172d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801732:	eb 17                	jmp    80174b <strtol+0x68>
	else if (*s == '-')
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 2d                	cmp    $0x2d,%al
  80173d:	75 0c                	jne    80174b <strtol+0x68>
		s++, neg = 1;
  80173f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801744:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80174f:	74 06                	je     801757 <strtol+0x74>
  801751:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801755:	75 28                	jne    80177f <strtol+0x9c>
  801757:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175b:	0f b6 00             	movzbl (%rax),%eax
  80175e:	3c 30                	cmp    $0x30,%al
  801760:	75 1d                	jne    80177f <strtol+0x9c>
  801762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801766:	48 83 c0 01          	add    $0x1,%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	3c 78                	cmp    $0x78,%al
  80176f:	75 0e                	jne    80177f <strtol+0x9c>
		s += 2, base = 16;
  801771:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801776:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80177d:	eb 2c                	jmp    8017ab <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80177f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801783:	75 19                	jne    80179e <strtol+0xbb>
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	3c 30                	cmp    $0x30,%al
  80178e:	75 0e                	jne    80179e <strtol+0xbb>
		s++, base = 8;
  801790:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801795:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80179c:	eb 0d                	jmp    8017ab <strtol+0xc8>
	else if (base == 0)
  80179e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a2:	75 07                	jne    8017ab <strtol+0xc8>
		base = 10;
  8017a4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	3c 2f                	cmp    $0x2f,%al
  8017b4:	7e 1d                	jle    8017d3 <strtol+0xf0>
  8017b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ba:	0f b6 00             	movzbl (%rax),%eax
  8017bd:	3c 39                	cmp    $0x39,%al
  8017bf:	7f 12                	jg     8017d3 <strtol+0xf0>
			dig = *s - '0';
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	0f b6 00             	movzbl (%rax),%eax
  8017c8:	0f be c0             	movsbl %al,%eax
  8017cb:	83 e8 30             	sub    $0x30,%eax
  8017ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017d1:	eb 4e                	jmp    801821 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	0f b6 00             	movzbl (%rax),%eax
  8017da:	3c 60                	cmp    $0x60,%al
  8017dc:	7e 1d                	jle    8017fb <strtol+0x118>
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	0f b6 00             	movzbl (%rax),%eax
  8017e5:	3c 7a                	cmp    $0x7a,%al
  8017e7:	7f 12                	jg     8017fb <strtol+0x118>
			dig = *s - 'a' + 10;
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 57             	sub    $0x57,%eax
  8017f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017f9:	eb 26                	jmp    801821 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ff:	0f b6 00             	movzbl (%rax),%eax
  801802:	3c 40                	cmp    $0x40,%al
  801804:	7e 48                	jle    80184e <strtol+0x16b>
  801806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180a:	0f b6 00             	movzbl (%rax),%eax
  80180d:	3c 5a                	cmp    $0x5a,%al
  80180f:	7f 3d                	jg     80184e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	0f be c0             	movsbl %al,%eax
  80181b:	83 e8 37             	sub    $0x37,%eax
  80181e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801821:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801824:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801827:	7c 02                	jl     80182b <strtol+0x148>
			break;
  801829:	eb 23                	jmp    80184e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80182b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801830:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801833:	48 98                	cltq   
  801835:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80183a:	48 89 c2             	mov    %rax,%rdx
  80183d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801840:	48 98                	cltq   
  801842:	48 01 d0             	add    %rdx,%rax
  801845:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801849:	e9 5d ff ff ff       	jmpq   8017ab <strtol+0xc8>

	if (endptr)
  80184e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801853:	74 0b                	je     801860 <strtol+0x17d>
		*endptr = (char *) s;
  801855:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801859:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80185d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801864:	74 09                	je     80186f <strtol+0x18c>
  801866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186a:	48 f7 d8             	neg    %rax
  80186d:	eb 04                	jmp    801873 <strtol+0x190>
  80186f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801873:	c9                   	leaveq 
  801874:	c3                   	retq   

0000000000801875 <strstr>:

char * strstr(const char *in, const char *str)
{
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	48 83 ec 30          	sub    $0x30,%rsp
  80187d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801881:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801885:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801889:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80188d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801891:	0f b6 00             	movzbl (%rax),%eax
  801894:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801897:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80189b:	75 06                	jne    8018a3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80189d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a1:	eb 6b                	jmp    80190e <strstr+0x99>

	len = strlen(str);
  8018a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a7:	48 89 c7             	mov    %rax,%rdi
  8018aa:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
  8018b6:	48 98                	cltq   
  8018b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018d2:	75 07                	jne    8018db <strstr+0x66>
				return (char *) 0;
  8018d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d9:	eb 33                	jmp    80190e <strstr+0x99>
		} while (sc != c);
  8018db:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018df:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018e2:	75 d8                	jne    8018bc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	48 89 ce             	mov    %rcx,%rsi
  8018f3:	48 89 c7             	mov    %rax,%rdi
  8018f6:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
  801902:	85 c0                	test   %eax,%eax
  801904:	75 b6                	jne    8018bc <strstr+0x47>

	return (char *) (in - 1);
  801906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190a:	48 83 e8 01          	sub    $0x1,%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	53                   	push   %rbx
  801915:	48 83 ec 48          	sub    $0x48,%rsp
  801919:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80191c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80191f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801923:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801927:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80192b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801932:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801936:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80193a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80193e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801942:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801946:	4c 89 c3             	mov    %r8,%rbx
  801949:	cd 30                	int    $0x30
  80194b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80194f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801953:	74 3e                	je     801993 <syscall+0x83>
  801955:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80195a:	7e 37                	jle    801993 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80195c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801960:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801963:	49 89 d0             	mov    %rdx,%r8
  801966:	89 c1                	mov    %eax,%ecx
  801968:	48 ba c8 47 80 00 00 	movabs $0x8047c8,%rdx
  80196f:	00 00 00 
  801972:	be 23 00 00 00       	mov    $0x23,%esi
  801977:	48 bf e5 47 80 00 00 	movabs $0x8047e5,%rdi
  80197e:	00 00 00 
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
  801986:	49 b9 c9 03 80 00 00 	movabs $0x8003c9,%r9
  80198d:	00 00 00 
  801990:	41 ff d1             	callq  *%r9

	return ret;
  801993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801997:	48 83 c4 48          	add    $0x48,%rsp
  80199b:	5b                   	pop    %rbx
  80199c:	5d                   	pop    %rbp
  80199d:	c3                   	retq   

000000000080199e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 20          	sub    $0x20,%rsp
  8019a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bd:	00 
  8019be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ca:	48 89 d1             	mov    %rdx,%rcx
  8019cd:	48 89 c2             	mov    %rax,%rdx
  8019d0:	be 00 00 00 00       	mov    $0x0,%esi
  8019d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019da:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	callq  *%rax
}
  8019e6:	c9                   	leaveq 
  8019e7:	c3                   	retq   

00000000008019e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f7:	00 
  8019f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a09:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0e:	be 00 00 00 00       	mov    $0x0,%esi
  801a13:	bf 01 00 00 00       	mov    $0x1,%edi
  801a18:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801a1f:	00 00 00 
  801a22:	ff d0                	callq  *%rax
}
  801a24:	c9                   	leaveq 
  801a25:	c3                   	retq   

0000000000801a26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a26:	55                   	push   %rbp
  801a27:	48 89 e5             	mov    %rsp,%rbp
  801a2a:	48 83 ec 10          	sub    $0x10,%rsp
  801a2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a34:	48 98                	cltq   
  801a36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3d:	00 
  801a3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4f:	48 89 c2             	mov    %rax,%rdx
  801a52:	be 01 00 00 00       	mov    $0x1,%esi
  801a57:	bf 03 00 00 00       	mov    $0x3,%edi
  801a5c:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a79:	00 
  801a7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a86:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	be 00 00 00 00       	mov    $0x0,%esi
  801a95:	bf 02 00 00 00       	mov    $0x2,%edi
  801a9a:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	callq  *%rax
}
  801aa6:	c9                   	leaveq 
  801aa7:	c3                   	retq   

0000000000801aa8 <sys_yield>:

void
sys_yield(void)
{
  801aa8:	55                   	push   %rbp
  801aa9:	48 89 e5             	mov    %rsp,%rbp
  801aac:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ab0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab7:	00 
  801ab8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ace:	be 00 00 00 00       	mov    $0x0,%esi
  801ad3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ad8:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 20          	sub    $0x20,%rsp
  801aee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801af8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801afb:	48 63 c8             	movslq %eax,%rcx
  801afe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b05:	48 98                	cltq   
  801b07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0e:	00 
  801b0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b15:	49 89 c8             	mov    %rcx,%r8
  801b18:	48 89 d1             	mov    %rdx,%rcx
  801b1b:	48 89 c2             	mov    %rax,%rdx
  801b1e:	be 01 00 00 00       	mov    $0x1,%esi
  801b23:	bf 04 00 00 00       	mov    $0x4,%edi
  801b28:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801b2f:	00 00 00 
  801b32:	ff d0                	callq  *%rax
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 30          	sub    $0x30,%rsp
  801b3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b45:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b4c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b53:	48 63 c8             	movslq %eax,%rcx
  801b56:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5d:	48 63 f0             	movslq %eax,%rsi
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b6d:	49 89 f9             	mov    %rdi,%r9
  801b70:	49 89 f0             	mov    %rsi,%r8
  801b73:	48 89 d1             	mov    %rdx,%rcx
  801b76:	48 89 c2             	mov    %rax,%rdx
  801b79:	be 01 00 00 00       	mov    $0x1,%esi
  801b7e:	bf 05 00 00 00       	mov    $0x5,%edi
  801b83:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801b8a:	00 00 00 
  801b8d:	ff d0                	callq  *%rax
}
  801b8f:	c9                   	leaveq 
  801b90:	c3                   	retq   

0000000000801b91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b91:	55                   	push   %rbp
  801b92:	48 89 e5             	mov    %rsp,%rbp
  801b95:	48 83 ec 20          	sub    $0x20,%rsp
  801b99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ba0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	48 98                	cltq   
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	48 89 d1             	mov    %rdx,%rcx
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	be 01 00 00 00       	mov    $0x1,%esi
  801bc8:	bf 06 00 00 00       	mov    $0x6,%edi
  801bcd:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 10          	sub    $0x10,%rsp
  801be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801be9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bec:	48 63 d0             	movslq %eax,%rdx
  801bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf2:	48 98                	cltq   
  801bf4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfb:	00 
  801bfc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c08:	48 89 d1             	mov    %rdx,%rcx
  801c0b:	48 89 c2             	mov    %rax,%rdx
  801c0e:	be 01 00 00 00       	mov    $0x1,%esi
  801c13:	bf 08 00 00 00       	mov    $0x8,%edi
  801c18:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	48 83 ec 20          	sub    $0x20,%rsp
  801c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	48 98                	cltq   
  801c3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c45:	00 
  801c46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c52:	48 89 d1             	mov    %rdx,%rcx
  801c55:	48 89 c2             	mov    %rax,%rdx
  801c58:	be 01 00 00 00       	mov    $0x1,%esi
  801c5d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c62:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 20          	sub    $0x20,%rsp
  801c78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c86:	48 98                	cltq   
  801c88:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8f:	00 
  801c90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9c:	48 89 d1             	mov    %rdx,%rcx
  801c9f:	48 89 c2             	mov    %rax,%rdx
  801ca2:	be 01 00 00 00       	mov    $0x1,%esi
  801ca7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cac:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
}
  801cb8:	c9                   	leaveq 
  801cb9:	c3                   	retq   

0000000000801cba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	48 83 ec 20          	sub    $0x20,%rsp
  801cc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cc9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ccd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd3:	48 63 f0             	movslq %eax,%rsi
  801cd6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdd:	48 98                	cltq   
  801cdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cea:	00 
  801ceb:	49 89 f1             	mov    %rsi,%r9
  801cee:	49 89 c8             	mov    %rcx,%r8
  801cf1:	48 89 d1             	mov    %rdx,%rcx
  801cf4:	48 89 c2             	mov    %rax,%rdx
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d01:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	48 83 ec 10          	sub    $0x10,%rsp
  801d17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d26:	00 
  801d27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d38:	48 89 c2             	mov    %rax,%rdx
  801d3b:	be 01 00 00 00       	mov    $0x1,%esi
  801d40:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d45:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	callq  *%rax
}
  801d51:	c9                   	leaveq 
  801d52:	c3                   	retq   

0000000000801d53 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
  801d57:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d62:	00 
  801d63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d74:	ba 00 00 00 00       	mov    $0x0,%edx
  801d79:	be 00 00 00 00       	mov    $0x0,%esi
  801d7e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d83:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
}
  801d8f:	c9                   	leaveq 
  801d90:	c3                   	retq   

0000000000801d91 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	48 83 ec 30          	sub    $0x30,%rsp
  801d99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801da3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801da7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dae:	48 63 c8             	movslq %eax,%rcx
  801db1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801db5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db8:	48 63 f0             	movslq %eax,%rsi
  801dbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc2:	48 98                	cltq   
  801dc4:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dc8:	49 89 f9             	mov    %rdi,%r9
  801dcb:	49 89 f0             	mov    %rsi,%r8
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	48 89 c2             	mov    %rax,%rdx
  801dd4:	be 00 00 00 00       	mov    $0x0,%esi
  801dd9:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dde:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 20          	sub    $0x20,%rsp
  801df4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0b:	00 
  801e0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e18:	48 89 d1             	mov    %rdx,%rcx
  801e1b:	48 89 c2             	mov    %rax,%rdx
  801e1e:	be 00 00 00 00       	mov    $0x0,%esi
  801e23:	bf 10 00 00 00       	mov    $0x10,%edi
  801e28:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	callq  *%rax
}
  801e34:	c9                   	leaveq 
  801e35:	c3                   	retq   

0000000000801e36 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
  801e3a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e45:	00 
  801e46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e57:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5c:	be 00 00 00 00       	mov    $0x0,%esi
  801e61:	bf 11 00 00 00       	mov    $0x11,%edi
  801e66:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801e72:	c9                   	leaveq 
  801e73:	c3                   	retq   

0000000000801e74 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 10          	sub    $0x10,%rsp
  801e7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e82:	48 98                	cltq   
  801e84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e8b:	00 
  801e8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e9d:	48 89 c2             	mov    %rax,%rdx
  801ea0:	be 00 00 00 00       	mov    $0x0,%esi
  801ea5:	bf 12 00 00 00       	mov    $0x12,%edi
  801eaa:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801eb1:	00 00 00 
  801eb4:	ff d0                	callq  *%rax
}
  801eb6:	c9                   	leaveq 
  801eb7:	c3                   	retq   

0000000000801eb8 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801eb8:	55                   	push   %rbp
  801eb9:	48 89 e5             	mov    %rsp,%rbp
  801ebc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801ec0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec7:	00 
  801ec8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ece:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ede:	be 00 00 00 00       	mov    $0x0,%esi
  801ee3:	bf 13 00 00 00       	mov    $0x13,%edi
  801ee8:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801eef:	00 00 00 
  801ef2:	ff d0                	callq  *%rax
}
  801ef4:	c9                   	leaveq 
  801ef5:	c3                   	retq   

0000000000801ef6 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801ef6:	55                   	push   %rbp
  801ef7:	48 89 e5             	mov    %rsp,%rbp
  801efa:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801efe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f05:	00 
  801f06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f17:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1c:	be 00 00 00 00       	mov    $0x0,%esi
  801f21:	bf 14 00 00 00       	mov    $0x14,%edi
  801f26:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
}
  801f32:	c9                   	leaveq 
  801f33:	c3                   	retq   

0000000000801f34 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f34:	55                   	push   %rbp
  801f35:	48 89 e5             	mov    %rsp,%rbp
  801f38:	48 83 ec 30          	sub    $0x30,%rsp
  801f3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f44:	48 8b 00             	mov    (%rax),%rax
  801f47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f53:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f59:	83 e0 02             	and    $0x2,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	75 4d                	jne    801fad <pgfault+0x79>
  801f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f64:	48 c1 e8 0c          	shr    $0xc,%rax
  801f68:	48 89 c2             	mov    %rax,%rdx
  801f6b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f72:	01 00 00 
  801f75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f79:	25 00 08 00 00       	and    $0x800,%eax
  801f7e:	48 85 c0             	test   %rax,%rax
  801f81:	74 2a                	je     801fad <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f83:	48 ba f8 47 80 00 00 	movabs $0x8047f8,%rdx
  801f8a:	00 00 00 
  801f8d:	be 23 00 00 00       	mov    $0x23,%esi
  801f92:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  801f99:	00 00 00 
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801fa8:	00 00 00 
  801fab:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801fad:	ba 07 00 00 00       	mov    $0x7,%edx
  801fb2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbc:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	0f 85 cd 00 00 00    	jne    80209d <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fe2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fea:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fef:	48 89 c6             	mov    %rax,%rsi
  801ff2:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ff7:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  801ffe:	00 00 00 
  802001:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802003:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802007:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80200d:	48 89 c1             	mov    %rax,%rcx
  802010:	ba 00 00 00 00       	mov    $0x0,%edx
  802015:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80201a:	bf 00 00 00 00       	mov    $0x0,%edi
  80201f:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802026:	00 00 00 
  802029:	ff d0                	callq  *%rax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	79 2a                	jns    802059 <pgfault+0x125>
				panic("Page map at temp address failed");
  80202f:	48 ba 38 48 80 00 00 	movabs $0x804838,%rdx
  802036:	00 00 00 
  802039:	be 30 00 00 00       	mov    $0x30,%esi
  80203e:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  802045:	00 00 00 
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802054:	00 00 00 
  802057:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802059:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80205e:	bf 00 00 00 00       	mov    $0x0,%edi
  802063:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	callq  *%rax
  80206f:	85 c0                	test   %eax,%eax
  802071:	79 54                	jns    8020c7 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802073:	48 ba 58 48 80 00 00 	movabs $0x804858,%rdx
  80207a:	00 00 00 
  80207d:	be 32 00 00 00       	mov    $0x32,%esi
  802082:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  802089:	00 00 00 
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802098:	00 00 00 
  80209b:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  80209d:	48 ba 80 48 80 00 00 	movabs $0x804880,%rdx
  8020a4:	00 00 00 
  8020a7:	be 34 00 00 00       	mov    $0x34,%esi
  8020ac:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8020b3:	00 00 00 
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8020c2:	00 00 00 
  8020c5:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 83 ec 20          	sub    $0x20,%rsp
  8020d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020d4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8020d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020de:	01 00 00 
  8020e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8020ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8020f0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020f3:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8020fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020fe:	25 00 04 00 00       	and    $0x400,%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 57                	je     80215e <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802107:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80210a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80210e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802115:	41 89 f0             	mov    %esi,%r8d
  802118:	48 89 c6             	mov    %rax,%rsi
  80211b:	bf 00 00 00 00       	mov    $0x0,%edi
  802120:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	0f 8e 52 01 00 00    	jle    802286 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802134:	48 ba b2 48 80 00 00 	movabs $0x8048b2,%rdx
  80213b:	00 00 00 
  80213e:	be 4e 00 00 00       	mov    $0x4e,%esi
  802143:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  80214a:	00 00 00 
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
  802152:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802159:	00 00 00 
  80215c:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  80215e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802161:	83 e0 02             	and    $0x2,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	75 10                	jne    802178 <duppage+0xaf>
  802168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216b:	25 00 08 00 00       	and    $0x800,%eax
  802170:	85 c0                	test   %eax,%eax
  802172:	0f 84 bb 00 00 00    	je     802233 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217b:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802180:	80 cc 08             	or     $0x8,%ah
  802183:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802186:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802189:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80218d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802194:	41 89 f0             	mov    %esi,%r8d
  802197:	48 89 c6             	mov    %rax,%rsi
  80219a:	bf 00 00 00 00       	mov    $0x0,%edi
  80219f:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	callq  *%rax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	7e 2a                	jle    8021d9 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8021af:	48 ba b2 48 80 00 00 	movabs $0x8048b2,%rdx
  8021b6:	00 00 00 
  8021b9:	be 55 00 00 00       	mov    $0x55,%esi
  8021be:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8021c5:	00 00 00 
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cd:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8021d4:	00 00 00 
  8021d7:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021d9:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8021dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e4:	41 89 c8             	mov    %ecx,%r8d
  8021e7:	48 89 d1             	mov    %rdx,%rcx
  8021ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ef:	48 89 c6             	mov    %rax,%rsi
  8021f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f7:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
  802203:	85 c0                	test   %eax,%eax
  802205:	7e 2a                	jle    802231 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802207:	48 ba b2 48 80 00 00 	movabs $0x8048b2,%rdx
  80220e:	00 00 00 
  802211:	be 57 00 00 00       	mov    $0x57,%esi
  802216:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  80221d:	00 00 00 
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
  802225:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80222c:	00 00 00 
  80222f:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802231:	eb 53                	jmp    802286 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802233:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802236:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80223a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80223d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802241:	41 89 f0             	mov    %esi,%r8d
  802244:	48 89 c6             	mov    %rax,%rsi
  802247:	bf 00 00 00 00       	mov    $0x0,%edi
  80224c:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	85 c0                	test   %eax,%eax
  80225a:	7e 2a                	jle    802286 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80225c:	48 ba b2 48 80 00 00 	movabs $0x8048b2,%rdx
  802263:	00 00 00 
  802266:	be 5b 00 00 00       	mov    $0x5b,%esi
  80226b:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  802272:	00 00 00 
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802281:	00 00 00 
  802284:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228b:	c9                   	leaveq 
  80228c:	c3                   	retq   

000000000080228d <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80228d:	55                   	push   %rbp
  80228e:	48 89 e5             	mov    %rsp,%rbp
  802291:	48 83 ec 18          	sub    $0x18,%rsp
  802295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8022a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a5:	48 c1 e8 27          	shr    $0x27,%rax
  8022a9:	48 89 c2             	mov    %rax,%rdx
  8022ac:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022b3:	01 00 00 
  8022b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ba:	83 e0 01             	and    $0x1,%eax
  8022bd:	48 85 c0             	test   %rax,%rax
  8022c0:	74 51                	je     802313 <pt_is_mapped+0x86>
  8022c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c6:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ca:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022ce:	48 89 c2             	mov    %rax,%rdx
  8022d1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022d8:	01 00 00 
  8022db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022df:	83 e0 01             	and    $0x1,%eax
  8022e2:	48 85 c0             	test   %rax,%rax
  8022e5:	74 2c                	je     802313 <pt_is_mapped+0x86>
  8022e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022eb:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ef:	48 c1 e8 15          	shr    $0x15,%rax
  8022f3:	48 89 c2             	mov    %rax,%rdx
  8022f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	83 e0 01             	and    $0x1,%eax
  802307:	48 85 c0             	test   %rax,%rax
  80230a:	74 07                	je     802313 <pt_is_mapped+0x86>
  80230c:	b8 01 00 00 00       	mov    $0x1,%eax
  802311:	eb 05                	jmp    802318 <pt_is_mapped+0x8b>
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	83 e0 01             	and    $0x1,%eax
}
  80231b:	c9                   	leaveq 
  80231c:	c3                   	retq   

000000000080231d <fork>:

envid_t
fork(void)
{
  80231d:	55                   	push   %rbp
  80231e:	48 89 e5             	mov    %rsp,%rbp
  802321:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802325:	48 bf 34 1f 80 00 00 	movabs $0x801f34,%rdi
  80232c:	00 00 00 
  80232f:	48 b8 13 3e 80 00 00 	movabs $0x803e13,%rax
  802336:	00 00 00 
  802339:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80233b:	b8 07 00 00 00       	mov    $0x7,%eax
  802340:	cd 30                	int    $0x30
  802342:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802345:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802348:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80234f:	79 30                	jns    802381 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802351:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802354:	89 c1                	mov    %eax,%ecx
  802356:	48 ba d0 48 80 00 00 	movabs $0x8048d0,%rdx
  80235d:	00 00 00 
  802360:	be 86 00 00 00       	mov    $0x86,%esi
  802365:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  80236c:	00 00 00 
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  80237b:	00 00 00 
  80237e:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802381:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802385:	75 3e                	jne    8023c5 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802387:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	25 ff 03 00 00       	and    $0x3ff,%eax
  802398:	48 98                	cltq   
  80239a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023a8:	00 00 00 
  8023ab:	48 01 c2             	add    %rax,%rdx
  8023ae:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023b5:	00 00 00 
  8023b8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	e9 d1 01 00 00       	jmpq   802596 <fork+0x279>
	}
	uint64_t ad = 0;
  8023c5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023cc:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023cd:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023d6:	e9 df 00 00 00       	jmpq   8024ba <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023df:	48 c1 e8 27          	shr    $0x27,%rax
  8023e3:	48 89 c2             	mov    %rax,%rdx
  8023e6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023ed:	01 00 00 
  8023f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f4:	83 e0 01             	and    $0x1,%eax
  8023f7:	48 85 c0             	test   %rax,%rax
  8023fa:	0f 84 9e 00 00 00    	je     80249e <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802404:	48 c1 e8 1e          	shr    $0x1e,%rax
  802408:	48 89 c2             	mov    %rax,%rdx
  80240b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802412:	01 00 00 
  802415:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802419:	83 e0 01             	and    $0x1,%eax
  80241c:	48 85 c0             	test   %rax,%rax
  80241f:	74 73                	je     802494 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802425:	48 c1 e8 15          	shr    $0x15,%rax
  802429:	48 89 c2             	mov    %rax,%rdx
  80242c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802433:	01 00 00 
  802436:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243a:	83 e0 01             	and    $0x1,%eax
  80243d:	48 85 c0             	test   %rax,%rax
  802440:	74 48                	je     80248a <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802446:	48 c1 e8 0c          	shr    $0xc,%rax
  80244a:	48 89 c2             	mov    %rax,%rdx
  80244d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802454:	01 00 00 
  802457:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80245b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80245f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802463:	83 e0 01             	and    $0x1,%eax
  802466:	48 85 c0             	test   %rax,%rax
  802469:	74 47                	je     8024b2 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80246b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246f:	48 c1 e8 0c          	shr    $0xc,%rax
  802473:	89 c2                	mov    %eax,%edx
  802475:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802478:	89 d6                	mov    %edx,%esi
  80247a:	89 c7                	mov    %eax,%edi
  80247c:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802483:	00 00 00 
  802486:	ff d0                	callq  *%rax
  802488:	eb 28                	jmp    8024b2 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80248a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802491:	00 
  802492:	eb 1e                	jmp    8024b2 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802494:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80249b:	40 
  80249c:	eb 14                	jmp    8024b2 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80249e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a2:	48 c1 e8 27          	shr    $0x27,%rax
  8024a6:	48 83 c0 01          	add    $0x1,%rax
  8024aa:	48 c1 e0 27          	shl    $0x27,%rax
  8024ae:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024b2:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024b9:	00 
  8024ba:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8024c1:	00 
  8024c2:	0f 87 13 ff ff ff    	ja     8023db <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024cb:	ba 07 00 00 00       	mov    $0x7,%edx
  8024d0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024d5:	89 c7                	mov    %eax,%edi
  8024d7:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024e6:	ba 07 00 00 00       	mov    $0x7,%edx
  8024eb:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024f0:	89 c7                	mov    %eax,%edi
  8024f2:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802501:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802507:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80250c:	ba 00 00 00 00       	mov    $0x0,%edx
  802511:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802516:	89 c7                	mov    %eax,%edi
  802518:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802524:	ba 00 10 00 00       	mov    $0x1000,%edx
  802529:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80252e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802533:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80253a:	00 00 00 
  80253d:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80253f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802544:	bf 00 00 00 00       	mov    $0x0,%edi
  802549:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802555:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80255c:	00 00 00 
  80255f:	48 8b 00             	mov    (%rax),%rax
  802562:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802569:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80257d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802580:	be 02 00 00 00       	mov    $0x2,%esi
  802585:	89 c7                	mov    %eax,%edi
  802587:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax

	return envid;
  802593:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802596:	c9                   	leaveq 
  802597:	c3                   	retq   

0000000000802598 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802598:	55                   	push   %rbp
  802599:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80259c:	48 ba e8 48 80 00 00 	movabs $0x8048e8,%rdx
  8025a3:	00 00 00 
  8025a6:	be bf 00 00 00       	mov    $0xbf,%esi
  8025ab:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8025b2:	00 00 00 
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8025c1:	00 00 00 
  8025c4:	ff d1                	callq  *%rcx

00000000008025c6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
  8025ca:	48 83 ec 08          	sub    $0x8,%rsp
  8025ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025dd:	ff ff ff 
  8025e0:	48 01 d0             	add    %rdx,%rax
  8025e3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025e7:	c9                   	leaveq 
  8025e8:	c3                   	retq   

00000000008025e9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025e9:	55                   	push   %rbp
  8025ea:	48 89 e5             	mov    %rsp,%rbp
  8025ed:	48 83 ec 08          	sub    $0x8,%rsp
  8025f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f9:	48 89 c7             	mov    %rax,%rdi
  8025fc:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80260e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802612:	c9                   	leaveq 
  802613:	c3                   	retq   

0000000000802614 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802614:	55                   	push   %rbp
  802615:	48 89 e5             	mov    %rsp,%rbp
  802618:	48 83 ec 18          	sub    $0x18,%rsp
  80261c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802627:	eb 6b                	jmp    802694 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	48 98                	cltq   
  80262e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802634:	48 c1 e0 0c          	shl    $0xc,%rax
  802638:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80263c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802640:	48 c1 e8 15          	shr    $0x15,%rax
  802644:	48 89 c2             	mov    %rax,%rdx
  802647:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80264e:	01 00 00 
  802651:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802655:	83 e0 01             	and    $0x1,%eax
  802658:	48 85 c0             	test   %rax,%rax
  80265b:	74 21                	je     80267e <fd_alloc+0x6a>
  80265d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802661:	48 c1 e8 0c          	shr    $0xc,%rax
  802665:	48 89 c2             	mov    %rax,%rdx
  802668:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80266f:	01 00 00 
  802672:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802676:	83 e0 01             	and    $0x1,%eax
  802679:	48 85 c0             	test   %rax,%rax
  80267c:	75 12                	jne    802690 <fd_alloc+0x7c>
			*fd_store = fd;
  80267e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802682:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802686:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	eb 1a                	jmp    8026aa <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802690:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802694:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802698:	7e 8f                	jle    802629 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026a5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026aa:	c9                   	leaveq 
  8026ab:	c3                   	retq   

00000000008026ac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026ac:	55                   	push   %rbp
  8026ad:	48 89 e5             	mov    %rsp,%rbp
  8026b0:	48 83 ec 20          	sub    $0x20,%rsp
  8026b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026bf:	78 06                	js     8026c7 <fd_lookup+0x1b>
  8026c1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026c5:	7e 07                	jle    8026ce <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026cc:	eb 6c                	jmp    80273a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026d1:	48 98                	cltq   
  8026d3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026d9:	48 c1 e0 0c          	shl    $0xc,%rax
  8026dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026e5:	48 c1 e8 15          	shr    $0x15,%rax
  8026e9:	48 89 c2             	mov    %rax,%rdx
  8026ec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026f3:	01 00 00 
  8026f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026fa:	83 e0 01             	and    $0x1,%eax
  8026fd:	48 85 c0             	test   %rax,%rax
  802700:	74 21                	je     802723 <fd_lookup+0x77>
  802702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802706:	48 c1 e8 0c          	shr    $0xc,%rax
  80270a:	48 89 c2             	mov    %rax,%rdx
  80270d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802714:	01 00 00 
  802717:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271b:	83 e0 01             	and    $0x1,%eax
  80271e:	48 85 c0             	test   %rax,%rax
  802721:	75 07                	jne    80272a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802728:	eb 10                	jmp    80273a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80272a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802732:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273a:	c9                   	leaveq 
  80273b:	c3                   	retq   

000000000080273c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80273c:	55                   	push   %rbp
  80273d:	48 89 e5             	mov    %rsp,%rbp
  802740:	48 83 ec 30          	sub    $0x30,%rsp
  802744:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802748:	89 f0                	mov    %esi,%eax
  80274a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80274d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802751:	48 89 c7             	mov    %rax,%rdi
  802754:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
  802760:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802764:	48 89 d6             	mov    %rdx,%rsi
  802767:	89 c7                	mov    %eax,%edi
  802769:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
  802775:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802778:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277c:	78 0a                	js     802788 <fd_close+0x4c>
	    || fd != fd2)
  80277e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802782:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802786:	74 12                	je     80279a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802788:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80278c:	74 05                	je     802793 <fd_close+0x57>
  80278e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802791:	eb 05                	jmp    802798 <fd_close+0x5c>
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	eb 69                	jmp    802803 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80279a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279e:	8b 00                	mov    (%rax),%eax
  8027a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027a4:	48 89 d6             	mov    %rdx,%rsi
  8027a7:	89 c7                	mov    %eax,%edi
  8027a9:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  8027b0:	00 00 00 
  8027b3:	ff d0                	callq  *%rax
  8027b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bc:	78 2a                	js     8027e8 <fd_close+0xac>
		if (dev->dev_close)
  8027be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027c6:	48 85 c0             	test   %rax,%rax
  8027c9:	74 16                	je     8027e1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cf:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027d3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d7:	48 89 d7             	mov    %rdx,%rdi
  8027da:	ff d0                	callq  *%rax
  8027dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027df:	eb 07                	jmp    8027e8 <fd_close+0xac>
		else
			r = 0;
  8027e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ec:	48 89 c6             	mov    %rax,%rsi
  8027ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f4:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
	return r;
  802800:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802803:	c9                   	leaveq 
  802804:	c3                   	retq   

0000000000802805 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802805:	55                   	push   %rbp
  802806:	48 89 e5             	mov    %rsp,%rbp
  802809:	48 83 ec 20          	sub    $0x20,%rsp
  80280d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802814:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80281b:	eb 41                	jmp    80285e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80281d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802824:	00 00 00 
  802827:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80282a:	48 63 d2             	movslq %edx,%rdx
  80282d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802831:	8b 00                	mov    (%rax),%eax
  802833:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802836:	75 22                	jne    80285a <dev_lookup+0x55>
			*dev = devtab[i];
  802838:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80283f:	00 00 00 
  802842:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802845:	48 63 d2             	movslq %edx,%rdx
  802848:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80284c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802850:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	eb 60                	jmp    8028ba <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80285a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80285e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802865:	00 00 00 
  802868:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80286b:	48 63 d2             	movslq %edx,%rdx
  80286e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802872:	48 85 c0             	test   %rax,%rax
  802875:	75 a6                	jne    80281d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802877:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80287e:	00 00 00 
  802881:	48 8b 00             	mov    (%rax),%rax
  802884:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80288a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80288d:	89 c6                	mov    %eax,%esi
  80288f:	48 bf 00 49 80 00 00 	movabs $0x804900,%rdi
  802896:	00 00 00 
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  8028a5:	00 00 00 
  8028a8:	ff d1                	callq  *%rcx
	*dev = 0;
  8028aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028ba:	c9                   	leaveq 
  8028bb:	c3                   	retq   

00000000008028bc <close>:

int
close(int fdnum)
{
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	48 83 ec 20          	sub    $0x20,%rsp
  8028c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028ce:	48 89 d6             	mov    %rdx,%rsi
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
  8028df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e6:	79 05                	jns    8028ed <close+0x31>
		return r;
  8028e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028eb:	eb 18                	jmp    802905 <close+0x49>
	else
		return fd_close(fd, 1);
  8028ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f1:	be 01 00 00 00       	mov    $0x1,%esi
  8028f6:	48 89 c7             	mov    %rax,%rdi
  8028f9:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  802900:	00 00 00 
  802903:	ff d0                	callq  *%rax
}
  802905:	c9                   	leaveq 
  802906:	c3                   	retq   

0000000000802907 <close_all>:

void
close_all(void)
{
  802907:	55                   	push   %rbp
  802908:	48 89 e5             	mov    %rsp,%rbp
  80290b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80290f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802916:	eb 15                	jmp    80292d <close_all+0x26>
		close(i);
  802918:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291b:	89 c7                	mov    %eax,%edi
  80291d:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802929:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80292d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802931:	7e e5                	jle    802918 <close_all+0x11>
		close(i);
}
  802933:	c9                   	leaveq 
  802934:	c3                   	retq   

0000000000802935 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802935:	55                   	push   %rbp
  802936:	48 89 e5             	mov    %rsp,%rbp
  802939:	48 83 ec 40          	sub    $0x40,%rsp
  80293d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802940:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802943:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802947:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80294a:	48 89 d6             	mov    %rdx,%rsi
  80294d:	89 c7                	mov    %eax,%edi
  80294f:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802962:	79 08                	jns    80296c <dup+0x37>
		return r;
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802967:	e9 70 01 00 00       	jmpq   802adc <dup+0x1a7>
	close(newfdnum);
  80296c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80296f:	89 c7                	mov    %eax,%edi
  802971:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80297d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802980:	48 98                	cltq   
  802982:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802988:	48 c1 e0 0c          	shl    $0xc,%rax
  80298c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ab:	48 89 c7             	mov    %rax,%rdi
  8029ae:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c2:	48 c1 e8 15          	shr    $0x15,%rax
  8029c6:	48 89 c2             	mov    %rax,%rdx
  8029c9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029d0:	01 00 00 
  8029d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d7:	83 e0 01             	and    $0x1,%eax
  8029da:	48 85 c0             	test   %rax,%rax
  8029dd:	74 73                	je     802a52 <dup+0x11d>
  8029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8029e7:	48 89 c2             	mov    %rax,%rdx
  8029ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029f1:	01 00 00 
  8029f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f8:	83 e0 01             	and    $0x1,%eax
  8029fb:	48 85 c0             	test   %rax,%rax
  8029fe:	74 52                	je     802a52 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a04:	48 c1 e8 0c          	shr    $0xc,%rax
  802a08:	48 89 c2             	mov    %rax,%rdx
  802a0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a12:	01 00 00 
  802a15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a19:	25 07 0e 00 00       	and    $0xe07,%eax
  802a1e:	89 c1                	mov    %eax,%ecx
  802a20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a28:	41 89 c8             	mov    %ecx,%r8d
  802a2b:	48 89 d1             	mov    %rdx,%rcx
  802a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a33:	48 89 c6             	mov    %rax,%rsi
  802a36:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3b:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
  802a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4e:	79 02                	jns    802a52 <dup+0x11d>
			goto err;
  802a50:	eb 57                	jmp    802aa9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a56:	48 c1 e8 0c          	shr    $0xc,%rax
  802a5a:	48 89 c2             	mov    %rax,%rdx
  802a5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a64:	01 00 00 
  802a67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6b:	25 07 0e 00 00       	and    $0xe07,%eax
  802a70:	89 c1                	mov    %eax,%ecx
  802a72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a7a:	41 89 c8             	mov    %ecx,%r8d
  802a7d:	48 89 d1             	mov    %rdx,%rcx
  802a80:	ba 00 00 00 00       	mov    $0x0,%edx
  802a85:	48 89 c6             	mov    %rax,%rsi
  802a88:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8d:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	callq  *%rax
  802a99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa0:	79 02                	jns    802aa4 <dup+0x16f>
		goto err;
  802aa2:	eb 05                	jmp    802aa9 <dup+0x174>

	return newfdnum;
  802aa4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802aa7:	eb 33                	jmp    802adc <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aad:	48 89 c6             	mov    %rax,%rsi
  802ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab5:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ac1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac5:	48 89 c6             	mov    %rax,%rsi
  802ac8:	bf 00 00 00 00       	mov    $0x0,%edi
  802acd:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
	return r;
  802ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802adc:	c9                   	leaveq 
  802add:	c3                   	retq   

0000000000802ade <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	48 83 ec 40          	sub    $0x40,%rsp
  802ae6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ae9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802aed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802af1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802af5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802af8:	48 89 d6             	mov    %rdx,%rsi
  802afb:	89 c7                	mov    %eax,%edi
  802afd:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
  802b09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b10:	78 24                	js     802b36 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b16:	8b 00                	mov    (%rax),%eax
  802b18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b1c:	48 89 d6             	mov    %rdx,%rsi
  802b1f:	89 c7                	mov    %eax,%edi
  802b21:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
  802b2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b34:	79 05                	jns    802b3b <read+0x5d>
		return r;
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b39:	eb 76                	jmp    802bb1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3f:	8b 40 08             	mov    0x8(%rax),%eax
  802b42:	83 e0 03             	and    $0x3,%eax
  802b45:	83 f8 01             	cmp    $0x1,%eax
  802b48:	75 3a                	jne    802b84 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b4a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b51:	00 00 00 
  802b54:	48 8b 00             	mov    (%rax),%rax
  802b57:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b5d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b60:	89 c6                	mov    %eax,%esi
  802b62:	48 bf 1f 49 80 00 00 	movabs $0x80491f,%rdi
  802b69:	00 00 00 
  802b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b71:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802b78:	00 00 00 
  802b7b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b82:	eb 2d                	jmp    802bb1 <read+0xd3>
	}
	if (!dev->dev_read)
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b8c:	48 85 c0             	test   %rax,%rax
  802b8f:	75 07                	jne    802b98 <read+0xba>
		return -E_NOT_SUPP;
  802b91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b96:	eb 19                	jmp    802bb1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ba0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ba4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ba8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bac:	48 89 cf             	mov    %rcx,%rdi
  802baf:	ff d0                	callq  *%rax
}
  802bb1:	c9                   	leaveq 
  802bb2:	c3                   	retq   

0000000000802bb3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 30          	sub    $0x30,%rsp
  802bbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bc2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bcd:	eb 49                	jmp    802c18 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd2:	48 98                	cltq   
  802bd4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bd8:	48 29 c2             	sub    %rax,%rdx
  802bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bde:	48 63 c8             	movslq %eax,%rcx
  802be1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be5:	48 01 c1             	add    %rax,%rcx
  802be8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802beb:	48 89 ce             	mov    %rcx,%rsi
  802bee:	89 c7                	mov    %eax,%edi
  802bf0:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c03:	79 05                	jns    802c0a <readn+0x57>
			return m;
  802c05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c08:	eb 1c                	jmp    802c26 <readn+0x73>
		if (m == 0)
  802c0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c0e:	75 02                	jne    802c12 <readn+0x5f>
			break;
  802c10:	eb 11                	jmp    802c23 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c15:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1b:	48 98                	cltq   
  802c1d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c21:	72 ac                	jb     802bcf <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c23:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c26:	c9                   	leaveq 
  802c27:	c3                   	retq   

0000000000802c28 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 40          	sub    $0x40,%rsp
  802c30:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c37:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c3b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c3f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c42:	48 89 d6             	mov    %rdx,%rsi
  802c45:	89 c7                	mov    %eax,%edi
  802c47:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	callq  *%rax
  802c53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5a:	78 24                	js     802c80 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c60:	8b 00                	mov    (%rax),%eax
  802c62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c66:	48 89 d6             	mov    %rdx,%rsi
  802c69:	89 c7                	mov    %eax,%edi
  802c6b:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7e:	79 05                	jns    802c85 <write+0x5d>
		return r;
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	eb 42                	jmp    802cc7 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	8b 40 08             	mov    0x8(%rax),%eax
  802c8c:	83 e0 03             	and    $0x3,%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	75 07                	jne    802c9a <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c98:	eb 2d                	jmp    802cc7 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ca2:	48 85 c0             	test   %rax,%rax
  802ca5:	75 07                	jne    802cae <write+0x86>
		return -E_NOT_SUPP;
  802ca7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cac:	eb 19                	jmp    802cc7 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cb6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cbe:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cc2:	48 89 cf             	mov    %rcx,%rdi
  802cc5:	ff d0                	callq  *%rax
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <seek>:

int
seek(int fdnum, off_t offset)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 83 ec 18          	sub    $0x18,%rsp
  802cd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cdb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cde:	48 89 d6             	mov    %rdx,%rsi
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf6:	79 05                	jns    802cfd <seek+0x34>
		return r;
  802cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfb:	eb 0f                	jmp    802d0c <seek+0x43>
	fd->fd_offset = offset;
  802cfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d01:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d04:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 30          	sub    $0x30,%rsp
  802d16:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d19:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d1c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d23:	48 89 d6             	mov    %rdx,%rsi
  802d26:	89 c7                	mov    %eax,%edi
  802d28:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
  802d34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3b:	78 24                	js     802d61 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d41:	8b 00                	mov    (%rax),%eax
  802d43:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d47:	48 89 d6             	mov    %rdx,%rsi
  802d4a:	89 c7                	mov    %eax,%edi
  802d4c:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802d53:	00 00 00 
  802d56:	ff d0                	callq  *%rax
  802d58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5f:	79 05                	jns    802d66 <ftruncate+0x58>
		return r;
  802d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d64:	eb 72                	jmp    802dd8 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6a:	8b 40 08             	mov    0x8(%rax),%eax
  802d6d:	83 e0 03             	and    $0x3,%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	75 3a                	jne    802dae <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d74:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d7b:	00 00 00 
  802d7e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d81:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d87:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d8a:	89 c6                	mov    %eax,%esi
  802d8c:	48 bf 40 49 80 00 00 	movabs $0x804940,%rdi
  802d93:	00 00 00 
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9b:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802da2:	00 00 00 
  802da5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802da7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dac:	eb 2a                	jmp    802dd8 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802db6:	48 85 c0             	test   %rax,%rax
  802db9:	75 07                	jne    802dc2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dbb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dc0:	eb 16                	jmp    802dd8 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dce:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dd1:	89 ce                	mov    %ecx,%esi
  802dd3:	48 89 d7             	mov    %rdx,%rdi
  802dd6:	ff d0                	callq  *%rax
}
  802dd8:	c9                   	leaveq 
  802dd9:	c3                   	retq   

0000000000802dda <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dda:	55                   	push   %rbp
  802ddb:	48 89 e5             	mov    %rsp,%rbp
  802dde:	48 83 ec 30          	sub    $0x30,%rsp
  802de2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802de5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802de9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ded:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802df0:	48 89 d6             	mov    %rdx,%rsi
  802df3:	89 c7                	mov    %eax,%edi
  802df5:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e08:	78 24                	js     802e2e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0e:	8b 00                	mov    (%rax),%eax
  802e10:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e14:	48 89 d6             	mov    %rdx,%rsi
  802e17:	89 c7                	mov    %eax,%edi
  802e19:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2c:	79 05                	jns    802e33 <fstat+0x59>
		return r;
  802e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e31:	eb 5e                	jmp    802e91 <fstat+0xb7>
	if (!dev->dev_stat)
  802e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e37:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e3b:	48 85 c0             	test   %rax,%rax
  802e3e:	75 07                	jne    802e47 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e40:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e45:	eb 4a                	jmp    802e91 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e4b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e52:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e59:	00 00 00 
	stat->st_isdir = 0;
  802e5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e60:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e67:	00 00 00 
	stat->st_dev = dev;
  802e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e72:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e85:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e89:	48 89 ce             	mov    %rcx,%rsi
  802e8c:	48 89 d7             	mov    %rdx,%rdi
  802e8f:	ff d0                	callq  *%rax
}
  802e91:	c9                   	leaveq 
  802e92:	c3                   	retq   

0000000000802e93 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e93:	55                   	push   %rbp
  802e94:	48 89 e5             	mov    %rsp,%rbp
  802e97:	48 83 ec 20          	sub    $0x20,%rsp
  802e9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea7:	be 00 00 00 00       	mov    $0x0,%esi
  802eac:	48 89 c7             	mov    %rax,%rdi
  802eaf:	48 b8 81 2f 80 00 00 	movabs $0x802f81,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec2:	79 05                	jns    802ec9 <stat+0x36>
		return fd;
  802ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec7:	eb 2f                	jmp    802ef8 <stat+0x65>
	r = fstat(fd, stat);
  802ec9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed0:	48 89 d6             	mov    %rdx,%rsi
  802ed3:	89 c7                	mov    %eax,%edi
  802ed5:	48 b8 da 2d 80 00 00 	movabs $0x802dda,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
  802ee1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee7:	89 c7                	mov    %eax,%edi
  802ee9:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
	return r;
  802ef5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
  802efe:	48 83 ec 10          	sub    $0x10,%rsp
  802f02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f09:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f10:	00 00 00 
  802f13:	8b 00                	mov    (%rax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	75 1d                	jne    802f36 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f19:	bf 01 00 00 00       	mov    $0x1,%edi
  802f1e:	48 b8 d9 40 80 00 00 	movabs $0x8040d9,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f31:	00 00 00 
  802f34:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f36:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f3d:	00 00 00 
  802f40:	8b 00                	mov    (%rax),%eax
  802f42:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f45:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f4a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f51:	00 00 00 
  802f54:	89 c7                	mov    %eax,%edi
  802f56:	48 b8 51 40 80 00 00 	movabs $0x804051,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f66:	ba 00 00 00 00       	mov    $0x0,%edx
  802f6b:	48 89 c6             	mov    %rax,%rsi
  802f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f73:	48 b8 53 3f 80 00 00 	movabs $0x803f53,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
}
  802f7f:	c9                   	leaveq 
  802f80:	c3                   	retq   

0000000000802f81 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f81:	55                   	push   %rbp
  802f82:	48 89 e5             	mov    %rsp,%rbp
  802f85:	48 83 ec 30          	sub    $0x30,%rsp
  802f89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f8d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802f90:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802f97:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802f9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802fa5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802faa:	75 08                	jne    802fb4 <open+0x33>
	{
		return r;
  802fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faf:	e9 f2 00 00 00       	jmpq   8030a6 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb8:	48 89 c7             	mov    %rax,%rdi
  802fbb:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802fc2:	00 00 00 
  802fc5:	ff d0                	callq  *%rax
  802fc7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fca:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802fd1:	7e 0a                	jle    802fdd <open+0x5c>
	{
		return -E_BAD_PATH;
  802fd3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fd8:	e9 c9 00 00 00       	jmpq   8030a6 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802fdd:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802fe4:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802fe5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802fe9:	48 89 c7             	mov    %rax,%rdi
  802fec:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fff:	78 09                	js     80300a <open+0x89>
  803001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803005:	48 85 c0             	test   %rax,%rax
  803008:	75 08                	jne    803012 <open+0x91>
		{
			return r;
  80300a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300d:	e9 94 00 00 00       	jmpq   8030a6 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803016:	ba 00 04 00 00       	mov    $0x400,%edx
  80301b:	48 89 c6             	mov    %rax,%rsi
  80301e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803025:	00 00 00 
  803028:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803034:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80303b:	00 00 00 
  80303e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803041:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304b:	48 89 c6             	mov    %rax,%rsi
  80304e:	bf 01 00 00 00       	mov    $0x1,%edi
  803053:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803066:	79 2b                	jns    803093 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306c:	be 00 00 00 00       	mov    $0x0,%esi
  803071:	48 89 c7             	mov    %rax,%rdi
  803074:	48 b8 3c 27 80 00 00 	movabs $0x80273c,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
  803080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803087:	79 05                	jns    80308e <open+0x10d>
			{
				return d;
  803089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80308c:	eb 18                	jmp    8030a6 <open+0x125>
			}
			return r;
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	eb 13                	jmp    8030a6 <open+0x125>
		}	
		return fd2num(fd_store);
  803093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803097:	48 89 c7             	mov    %rax,%rdi
  80309a:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8030a6:	c9                   	leaveq 
  8030a7:	c3                   	retq   

00000000008030a8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030a8:	55                   	push   %rbp
  8030a9:	48 89 e5             	mov    %rsp,%rbp
  8030ac:	48 83 ec 10          	sub    $0x10,%rsp
  8030b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8030bb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c2:	00 00 00 
  8030c5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030c7:	be 00 00 00 00       	mov    $0x0,%esi
  8030cc:	bf 06 00 00 00       	mov    $0x6,%edi
  8030d1:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	48 83 ec 30          	sub    $0x30,%rsp
  8030e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8030f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8030fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030ff:	74 07                	je     803108 <devfile_read+0x29>
  803101:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803106:	75 07                	jne    80310f <devfile_read+0x30>
		return -E_INVAL;
  803108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80310d:	eb 77                	jmp    803186 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80310f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803113:	8b 50 0c             	mov    0xc(%rax),%edx
  803116:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80311d:	00 00 00 
  803120:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803122:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803129:	00 00 00 
  80312c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803130:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803134:	be 00 00 00 00       	mov    $0x0,%esi
  803139:	bf 03 00 00 00       	mov    $0x3,%edi
  80313e:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803151:	7f 05                	jg     803158 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	eb 2e                	jmp    803186 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315b:	48 63 d0             	movslq %eax,%rdx
  80315e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803162:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803169:	00 00 00 
  80316c:	48 89 c7             	mov    %rax,%rdi
  80316f:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  803176:	00 00 00 
  803179:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80317b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803183:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803186:	c9                   	leaveq 
  803187:	c3                   	retq   

0000000000803188 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803188:	55                   	push   %rbp
  803189:	48 89 e5             	mov    %rsp,%rbp
  80318c:	48 83 ec 30          	sub    $0x30,%rsp
  803190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803194:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803198:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80319c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8031a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031a8:	74 07                	je     8031b1 <devfile_write+0x29>
  8031aa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031af:	75 08                	jne    8031b9 <devfile_write+0x31>
		return r;
  8031b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b4:	e9 9a 00 00 00       	jmpq   803253 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8031c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c7:	00 00 00 
  8031ca:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031cc:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031d3:	00 
  8031d4:	76 08                	jbe    8031de <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031d6:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031dd:	00 
	}
	fsipcbuf.write.req_n = n;
  8031de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e5:	00 00 00 
  8031e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031ec:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8031f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f8:	48 89 c6             	mov    %rax,%rsi
  8031fb:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803202:	00 00 00 
  803205:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803211:	be 00 00 00 00       	mov    $0x0,%esi
  803216:	bf 04 00 00 00       	mov    $0x4,%edi
  80321b:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
  803227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80322a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322e:	7f 20                	jg     803250 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803230:	48 bf 66 49 80 00 00 	movabs $0x804966,%rdi
  803237:	00 00 00 
  80323a:	b8 00 00 00 00       	mov    $0x0,%eax
  80323f:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803246:	00 00 00 
  803249:	ff d2                	callq  *%rdx
		return r;
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324e:	eb 03                	jmp    803253 <devfile_write+0xcb>
	}
	return r;
  803250:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803253:	c9                   	leaveq 
  803254:	c3                   	retq   

0000000000803255 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803255:	55                   	push   %rbp
  803256:	48 89 e5             	mov    %rsp,%rbp
  803259:	48 83 ec 20          	sub    $0x20,%rsp
  80325d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803261:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803269:	8b 50 0c             	mov    0xc(%rax),%edx
  80326c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803273:	00 00 00 
  803276:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803278:	be 00 00 00 00       	mov    $0x0,%esi
  80327d:	bf 05 00 00 00       	mov    $0x5,%edi
  803282:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
  80328e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803295:	79 05                	jns    80329c <devfile_stat+0x47>
		return r;
  803297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329a:	eb 56                	jmp    8032f2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80329c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a0:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032a7:	00 00 00 
  8032aa:	48 89 c7             	mov    %rax,%rdi
  8032ad:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032b9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032c0:	00 00 00 
  8032c3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032cd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032da:	00 00 00 
  8032dd:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8032ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f2:	c9                   	leaveq 
  8032f3:	c3                   	retq   

00000000008032f4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8032f4:	55                   	push   %rbp
  8032f5:	48 89 e5             	mov    %rsp,%rbp
  8032f8:	48 83 ec 10          	sub    $0x10,%rsp
  8032fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803300:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803307:	8b 50 0c             	mov    0xc(%rax),%edx
  80330a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803311:	00 00 00 
  803314:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803316:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80331d:	00 00 00 
  803320:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803323:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803326:	be 00 00 00 00       	mov    $0x0,%esi
  80332b:	bf 02 00 00 00       	mov    $0x2,%edi
  803330:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
}
  80333c:	c9                   	leaveq 
  80333d:	c3                   	retq   

000000000080333e <remove>:

// Delete a file
int
remove(const char *path)
{
  80333e:	55                   	push   %rbp
  80333f:	48 89 e5             	mov    %rsp,%rbp
  803342:	48 83 ec 10          	sub    $0x10,%rsp
  803346:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80334a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803362:	7e 07                	jle    80336b <remove+0x2d>
		return -E_BAD_PATH;
  803364:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803369:	eb 33                	jmp    80339e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80336b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336f:	48 89 c6             	mov    %rax,%rsi
  803372:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803379:	00 00 00 
  80337c:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803388:	be 00 00 00 00       	mov    $0x0,%esi
  80338d:	bf 07 00 00 00       	mov    $0x7,%edi
  803392:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
}
  80339e:	c9                   	leaveq 
  80339f:	c3                   	retq   

00000000008033a0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033a0:	55                   	push   %rbp
  8033a1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033a4:	be 00 00 00 00       	mov    $0x0,%esi
  8033a9:	bf 08 00 00 00       	mov    $0x8,%edi
  8033ae:	48 b8 fa 2e 80 00 00 	movabs $0x802efa,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
}
  8033ba:	5d                   	pop    %rbp
  8033bb:	c3                   	retq   

00000000008033bc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033bc:	55                   	push   %rbp
  8033bd:	48 89 e5             	mov    %rsp,%rbp
  8033c0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033c7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033ce:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033d5:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033dc:	be 00 00 00 00       	mov    $0x0,%esi
  8033e1:	48 89 c7             	mov    %rax,%rdi
  8033e4:	48 b8 81 2f 80 00 00 	movabs $0x802f81,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
  8033f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8033f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f7:	79 28                	jns    803421 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8033f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fc:	89 c6                	mov    %eax,%esi
  8033fe:	48 bf 82 49 80 00 00 	movabs $0x804982,%rdi
  803405:	00 00 00 
  803408:	b8 00 00 00 00       	mov    $0x0,%eax
  80340d:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803414:	00 00 00 
  803417:	ff d2                	callq  *%rdx
		return fd_src;
  803419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341c:	e9 74 01 00 00       	jmpq   803595 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803421:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803428:	be 01 01 00 00       	mov    $0x101,%esi
  80342d:	48 89 c7             	mov    %rax,%rdi
  803430:	48 b8 81 2f 80 00 00 	movabs $0x802f81,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80343f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803443:	79 39                	jns    80347e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803448:	89 c6                	mov    %eax,%esi
  80344a:	48 bf 98 49 80 00 00 	movabs $0x804998,%rdi
  803451:	00 00 00 
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803460:	00 00 00 
  803463:	ff d2                	callq  *%rdx
		close(fd_src);
  803465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803468:	89 c7                	mov    %eax,%edi
  80346a:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  803471:	00 00 00 
  803474:	ff d0                	callq  *%rax
		return fd_dest;
  803476:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803479:	e9 17 01 00 00       	jmpq   803595 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80347e:	eb 74                	jmp    8034f4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803480:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803483:	48 63 d0             	movslq %eax,%rdx
  803486:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80348d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803490:	48 89 ce             	mov    %rcx,%rsi
  803493:	89 c7                	mov    %eax,%edi
  803495:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
  8034a1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034a8:	79 4a                	jns    8034f4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8034aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ad:	89 c6                	mov    %eax,%esi
  8034af:	48 bf b2 49 80 00 00 	movabs $0x8049b2,%rdi
  8034b6:	00 00 00 
  8034b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034be:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8034c5:	00 00 00 
  8034c8:	ff d2                	callq  *%rdx
			close(fd_src);
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cd:	89 c7                	mov    %eax,%edi
  8034cf:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  8034d6:	00 00 00 
  8034d9:	ff d0                	callq  *%rax
			close(fd_dest);
  8034db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034de:	89 c7                	mov    %eax,%edi
  8034e0:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
			return write_size;
  8034ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034ef:	e9 a1 00 00 00       	jmpq   803595 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8034f4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fe:	ba 00 02 00 00       	mov    $0x200,%edx
  803503:	48 89 ce             	mov    %rcx,%rsi
  803506:	89 c7                	mov    %eax,%edi
  803508:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  80350f:	00 00 00 
  803512:	ff d0                	callq  *%rax
  803514:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803517:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80351b:	0f 8f 5f ff ff ff    	jg     803480 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803521:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803525:	79 47                	jns    80356e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803527:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80352a:	89 c6                	mov    %eax,%esi
  80352c:	48 bf c5 49 80 00 00 	movabs $0x8049c5,%rdi
  803533:	00 00 00 
  803536:	b8 00 00 00 00       	mov    $0x0,%eax
  80353b:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803542:	00 00 00 
  803545:	ff d2                	callq  *%rdx
		close(fd_src);
  803547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354a:	89 c7                	mov    %eax,%edi
  80354c:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  803553:	00 00 00 
  803556:	ff d0                	callq  *%rax
		close(fd_dest);
  803558:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80355b:	89 c7                	mov    %eax,%edi
  80355d:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
		return read_size;
  803569:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80356c:	eb 27                	jmp    803595 <copy+0x1d9>
	}
	close(fd_src);
  80356e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803571:	89 c7                	mov    %eax,%edi
  803573:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
	close(fd_dest);
  80357f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803582:	89 c7                	mov    %eax,%edi
  803584:	48 b8 bc 28 80 00 00 	movabs $0x8028bc,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
	return 0;
  803590:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803595:	c9                   	leaveq 
  803596:	c3                   	retq   

0000000000803597 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803597:	55                   	push   %rbp
  803598:	48 89 e5             	mov    %rsp,%rbp
  80359b:	53                   	push   %rbx
  80359c:	48 83 ec 38          	sub    $0x38,%rsp
  8035a0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035a4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035a8:	48 89 c7             	mov    %rax,%rdi
  8035ab:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035be:	0f 88 bf 01 00 00    	js     803783 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8035cd:	48 89 c6             	mov    %rax,%rsi
  8035d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d5:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8035dc:	00 00 00 
  8035df:	ff d0                	callq  *%rax
  8035e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e8:	0f 88 95 01 00 00    	js     803783 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035ee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035f2:	48 89 c7             	mov    %rax,%rdi
  8035f5:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  8035fc:	00 00 00 
  8035ff:	ff d0                	callq  *%rax
  803601:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803604:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803608:	0f 88 5d 01 00 00    	js     80376b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80360e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803612:	ba 07 04 00 00       	mov    $0x407,%edx
  803617:	48 89 c6             	mov    %rax,%rsi
  80361a:	bf 00 00 00 00       	mov    $0x0,%edi
  80361f:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
  80362b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80362e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803632:	0f 88 33 01 00 00    	js     80376b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363c:	48 89 c7             	mov    %rax,%rdi
  80363f:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  803646:	00 00 00 
  803649:	ff d0                	callq  *%rax
  80364b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80364f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803653:	ba 07 04 00 00       	mov    $0x407,%edx
  803658:	48 89 c6             	mov    %rax,%rsi
  80365b:	bf 00 00 00 00       	mov    $0x0,%edi
  803660:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
  80366c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80366f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803673:	79 05                	jns    80367a <pipe+0xe3>
		goto err2;
  803675:	e9 d9 00 00 00       	jmpq   803753 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80367a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367e:	48 89 c7             	mov    %rax,%rdi
  803681:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  803688:	00 00 00 
  80368b:	ff d0                	callq  *%rax
  80368d:	48 89 c2             	mov    %rax,%rdx
  803690:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803694:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80369a:	48 89 d1             	mov    %rdx,%rcx
  80369d:	ba 00 00 00 00       	mov    $0x0,%edx
  8036a2:	48 89 c6             	mov    %rax,%rsi
  8036a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8036aa:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
  8036b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036bd:	79 1b                	jns    8036da <pipe+0x143>
		goto err3;
  8036bf:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c4:	48 89 c6             	mov    %rax,%rsi
  8036c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036cc:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
  8036d8:	eb 79                	jmp    803753 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036de:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036e5:	00 00 00 
  8036e8:	8b 12                	mov    (%rdx),%edx
  8036ea:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036fb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803702:	00 00 00 
  803705:	8b 12                	mov    (%rdx),%edx
  803707:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803709:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803718:	48 89 c7             	mov    %rax,%rdi
  80371b:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
  803727:	89 c2                	mov    %eax,%edx
  803729:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80372d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80372f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803733:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80373b:	48 89 c7             	mov    %rax,%rdi
  80373e:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
  80374a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80374c:	b8 00 00 00 00       	mov    $0x0,%eax
  803751:	eb 33                	jmp    803786 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803753:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803757:	48 89 c6             	mov    %rax,%rsi
  80375a:	bf 00 00 00 00       	mov    $0x0,%edi
  80375f:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803766:	00 00 00 
  803769:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80376b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376f:	48 89 c6             	mov    %rax,%rsi
  803772:	bf 00 00 00 00       	mov    $0x0,%edi
  803777:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
err:
	return r;
  803783:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803786:	48 83 c4 38          	add    $0x38,%rsp
  80378a:	5b                   	pop    %rbx
  80378b:	5d                   	pop    %rbp
  80378c:	c3                   	retq   

000000000080378d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80378d:	55                   	push   %rbp
  80378e:	48 89 e5             	mov    %rsp,%rbp
  803791:	53                   	push   %rbx
  803792:	48 83 ec 28          	sub    $0x28,%rsp
  803796:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80379a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80379e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037a5:	00 00 00 
  8037a8:	48 8b 00             	mov    (%rax),%rax
  8037ab:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b8:	48 89 c7             	mov    %rax,%rdi
  8037bb:	48 b8 4b 41 80 00 00 	movabs $0x80414b,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	89 c3                	mov    %eax,%ebx
  8037c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cd:	48 89 c7             	mov    %rax,%rdi
  8037d0:	48 b8 4b 41 80 00 00 	movabs $0x80414b,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	39 c3                	cmp    %eax,%ebx
  8037de:	0f 94 c0             	sete   %al
  8037e1:	0f b6 c0             	movzbl %al,%eax
  8037e4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037ee:	00 00 00 
  8037f1:	48 8b 00             	mov    (%rax),%rax
  8037f4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037fa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803800:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803803:	75 05                	jne    80380a <_pipeisclosed+0x7d>
			return ret;
  803805:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803808:	eb 4f                	jmp    803859 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80380a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803810:	74 42                	je     803854 <_pipeisclosed+0xc7>
  803812:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803816:	75 3c                	jne    803854 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803818:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80381f:	00 00 00 
  803822:	48 8b 00             	mov    (%rax),%rax
  803825:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80382b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80382e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803831:	89 c6                	mov    %eax,%esi
  803833:	48 bf e5 49 80 00 00 	movabs $0x8049e5,%rdi
  80383a:	00 00 00 
  80383d:	b8 00 00 00 00       	mov    $0x0,%eax
  803842:	49 b8 02 06 80 00 00 	movabs $0x800602,%r8
  803849:	00 00 00 
  80384c:	41 ff d0             	callq  *%r8
	}
  80384f:	e9 4a ff ff ff       	jmpq   80379e <_pipeisclosed+0x11>
  803854:	e9 45 ff ff ff       	jmpq   80379e <_pipeisclosed+0x11>
}
  803859:	48 83 c4 28          	add    $0x28,%rsp
  80385d:	5b                   	pop    %rbx
  80385e:	5d                   	pop    %rbp
  80385f:	c3                   	retq   

0000000000803860 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803860:	55                   	push   %rbp
  803861:	48 89 e5             	mov    %rsp,%rbp
  803864:	48 83 ec 30          	sub    $0x30,%rsp
  803868:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80386b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80386f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803872:	48 89 d6             	mov    %rdx,%rsi
  803875:	89 c7                	mov    %eax,%edi
  803877:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  80387e:	00 00 00 
  803881:	ff d0                	callq  *%rax
  803883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388a:	79 05                	jns    803891 <pipeisclosed+0x31>
		return r;
  80388c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388f:	eb 31                	jmp    8038c2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803895:	48 89 c7             	mov    %rax,%rdi
  803898:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
  8038a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b0:	48 89 d6             	mov    %rdx,%rsi
  8038b3:	48 89 c7             	mov    %rax,%rdi
  8038b6:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
}
  8038c2:	c9                   	leaveq 
  8038c3:	c3                   	retq   

00000000008038c4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038c4:	55                   	push   %rbp
  8038c5:	48 89 e5             	mov    %rsp,%rbp
  8038c8:	48 83 ec 40          	sub    $0x40,%rsp
  8038cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038fe:	00 
  8038ff:	e9 92 00 00 00       	jmpq   803996 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803904:	eb 41                	jmp    803947 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803906:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80390b:	74 09                	je     803916 <devpipe_read+0x52>
				return i;
  80390d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803911:	e9 92 00 00 00       	jmpq   8039a8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80391a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391e:	48 89 d6             	mov    %rdx,%rsi
  803921:	48 89 c7             	mov    %rax,%rdi
  803924:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	85 c0                	test   %eax,%eax
  803932:	74 07                	je     80393b <devpipe_read+0x77>
				return 0;
  803934:	b8 00 00 00 00       	mov    $0x0,%eax
  803939:	eb 6d                	jmp    8039a8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80393b:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394b:	8b 10                	mov    (%rax),%edx
  80394d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803951:	8b 40 04             	mov    0x4(%rax),%eax
  803954:	39 c2                	cmp    %eax,%edx
  803956:	74 ae                	je     803906 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803960:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803968:	8b 00                	mov    (%rax),%eax
  80396a:	99                   	cltd   
  80396b:	c1 ea 1b             	shr    $0x1b,%edx
  80396e:	01 d0                	add    %edx,%eax
  803970:	83 e0 1f             	and    $0x1f,%eax
  803973:	29 d0                	sub    %edx,%eax
  803975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803979:	48 98                	cltq   
  80397b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803980:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803986:	8b 00                	mov    (%rax),%eax
  803988:	8d 50 01             	lea    0x1(%rax),%edx
  80398b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803991:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803996:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80399e:	0f 82 60 ff ff ff    	jb     803904 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039a8:	c9                   	leaveq 
  8039a9:	c3                   	retq   

00000000008039aa <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039aa:	55                   	push   %rbp
  8039ab:	48 89 e5             	mov    %rsp,%rbp
  8039ae:	48 83 ec 40          	sub    $0x40,%rsp
  8039b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c2:	48 89 c7             	mov    %rax,%rdi
  8039c5:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
  8039d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039dd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039e4:	00 
  8039e5:	e9 8e 00 00 00       	jmpq   803a78 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039ea:	eb 31                	jmp    803a1d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f4:	48 89 d6             	mov    %rdx,%rsi
  8039f7:	48 89 c7             	mov    %rax,%rdi
  8039fa:	48 b8 8d 37 80 00 00 	movabs $0x80378d,%rax
  803a01:	00 00 00 
  803a04:	ff d0                	callq  *%rax
  803a06:	85 c0                	test   %eax,%eax
  803a08:	74 07                	je     803a11 <devpipe_write+0x67>
				return 0;
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0f:	eb 79                	jmp    803a8a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a11:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a21:	8b 40 04             	mov    0x4(%rax),%eax
  803a24:	48 63 d0             	movslq %eax,%rdx
  803a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2b:	8b 00                	mov    (%rax),%eax
  803a2d:	48 98                	cltq   
  803a2f:	48 83 c0 20          	add    $0x20,%rax
  803a33:	48 39 c2             	cmp    %rax,%rdx
  803a36:	73 b4                	jae    8039ec <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3c:	8b 40 04             	mov    0x4(%rax),%eax
  803a3f:	99                   	cltd   
  803a40:	c1 ea 1b             	shr    $0x1b,%edx
  803a43:	01 d0                	add    %edx,%eax
  803a45:	83 e0 1f             	and    $0x1f,%eax
  803a48:	29 d0                	sub    %edx,%eax
  803a4a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a52:	48 01 ca             	add    %rcx,%rdx
  803a55:	0f b6 0a             	movzbl (%rdx),%ecx
  803a58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a5c:	48 98                	cltq   
  803a5e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a66:	8b 40 04             	mov    0x4(%rax),%eax
  803a69:	8d 50 01             	lea    0x1(%rax),%edx
  803a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a70:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a73:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a80:	0f 82 64 ff ff ff    	jb     8039ea <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a8a:	c9                   	leaveq 
  803a8b:	c3                   	retq   

0000000000803a8c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a8c:	55                   	push   %rbp
  803a8d:	48 89 e5             	mov    %rsp,%rbp
  803a90:	48 83 ec 20          	sub    $0x20,%rsp
  803a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa0:	48 89 c7             	mov    %rax,%rdi
  803aa3:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
  803aaf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ab3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab7:	48 be f8 49 80 00 00 	movabs $0x8049f8,%rsi
  803abe:	00 00 00 
  803ac1:	48 89 c7             	mov    %rax,%rdi
  803ac4:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad4:	8b 50 04             	mov    0x4(%rax),%edx
  803ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803adb:	8b 00                	mov    (%rax),%eax
  803add:	29 c2                	sub    %eax,%edx
  803adf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ae9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aed:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803af4:	00 00 00 
	stat->st_dev = &devpipe;
  803af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afb:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b02:	00 00 00 
  803b05:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b11:	c9                   	leaveq 
  803b12:	c3                   	retq   

0000000000803b13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b13:	55                   	push   %rbp
  803b14:	48 89 e5             	mov    %rsp,%rbp
  803b17:	48 83 ec 10          	sub    $0x10,%rsp
  803b1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b23:	48 89 c6             	mov    %rax,%rsi
  803b26:	bf 00 00 00 00       	mov    $0x0,%edi
  803b2b:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3b:	48 89 c7             	mov    %rax,%rdi
  803b3e:	48 b8 e9 25 80 00 00 	movabs $0x8025e9,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	48 89 c6             	mov    %rax,%rsi
  803b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b52:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
}
  803b5e:	c9                   	leaveq 
  803b5f:	c3                   	retq   

0000000000803b60 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b60:	55                   	push   %rbp
  803b61:	48 89 e5             	mov    %rsp,%rbp
  803b64:	48 83 ec 20          	sub    $0x20,%rsp
  803b68:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b6e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b71:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b75:	be 01 00 00 00       	mov    $0x1,%esi
  803b7a:	48 89 c7             	mov    %rax,%rdi
  803b7d:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803b84:	00 00 00 
  803b87:	ff d0                	callq  *%rax
}
  803b89:	c9                   	leaveq 
  803b8a:	c3                   	retq   

0000000000803b8b <getchar>:

int
getchar(void)
{
  803b8b:	55                   	push   %rbp
  803b8c:	48 89 e5             	mov    %rsp,%rbp
  803b8f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b93:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b97:	ba 01 00 00 00       	mov    $0x1,%edx
  803b9c:	48 89 c6             	mov    %rax,%rsi
  803b9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba4:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
  803bb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb7:	79 05                	jns    803bbe <getchar+0x33>
		return r;
  803bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbc:	eb 14                	jmp    803bd2 <getchar+0x47>
	if (r < 1)
  803bbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc2:	7f 07                	jg     803bcb <getchar+0x40>
		return -E_EOF;
  803bc4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bc9:	eb 07                	jmp    803bd2 <getchar+0x47>
	return c;
  803bcb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bcf:	0f b6 c0             	movzbl %al,%eax
}
  803bd2:	c9                   	leaveq 
  803bd3:	c3                   	retq   

0000000000803bd4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bd4:	55                   	push   %rbp
  803bd5:	48 89 e5             	mov    %rsp,%rbp
  803bd8:	48 83 ec 20          	sub    $0x20,%rsp
  803bdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bdf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803be3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be6:	48 89 d6             	mov    %rdx,%rsi
  803be9:	89 c7                	mov    %eax,%edi
  803beb:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  803bf2:	00 00 00 
  803bf5:	ff d0                	callq  *%rax
  803bf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bfe:	79 05                	jns    803c05 <iscons+0x31>
		return r;
  803c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c03:	eb 1a                	jmp    803c1f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c09:	8b 10                	mov    (%rax),%edx
  803c0b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c12:	00 00 00 
  803c15:	8b 00                	mov    (%rax),%eax
  803c17:	39 c2                	cmp    %eax,%edx
  803c19:	0f 94 c0             	sete   %al
  803c1c:	0f b6 c0             	movzbl %al,%eax
}
  803c1f:	c9                   	leaveq 
  803c20:	c3                   	retq   

0000000000803c21 <opencons>:

int
opencons(void)
{
  803c21:	55                   	push   %rbp
  803c22:	48 89 e5             	mov    %rsp,%rbp
  803c25:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c29:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c2d:	48 89 c7             	mov    %rax,%rdi
  803c30:	48 b8 14 26 80 00 00 	movabs $0x802614,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
  803c3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c43:	79 05                	jns    803c4a <opencons+0x29>
		return r;
  803c45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c48:	eb 5b                	jmp    803ca5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4e:	ba 07 04 00 00       	mov    $0x407,%edx
  803c53:	48 89 c6             	mov    %rax,%rsi
  803c56:	bf 00 00 00 00       	mov    $0x0,%edi
  803c5b:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
  803c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6e:	79 05                	jns    803c75 <opencons+0x54>
		return r;
  803c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c73:	eb 30                	jmp    803ca5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c80:	00 00 00 
  803c83:	8b 12                	mov    (%rdx),%edx
  803c85:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c96:	48 89 c7             	mov    %rax,%rdi
  803c99:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
}
  803ca5:	c9                   	leaveq 
  803ca6:	c3                   	retq   

0000000000803ca7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ca7:	55                   	push   %rbp
  803ca8:	48 89 e5             	mov    %rsp,%rbp
  803cab:	48 83 ec 30          	sub    $0x30,%rsp
  803caf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cb7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cbb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cc0:	75 07                	jne    803cc9 <devcons_read+0x22>
		return 0;
  803cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc7:	eb 4b                	jmp    803d14 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cc9:	eb 0c                	jmp    803cd7 <devcons_read+0x30>
		sys_yield();
  803ccb:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cd7:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
  803ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cea:	74 df                	je     803ccb <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf0:	79 05                	jns    803cf7 <devcons_read+0x50>
		return c;
  803cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf5:	eb 1d                	jmp    803d14 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803cf7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803cfb:	75 07                	jne    803d04 <devcons_read+0x5d>
		return 0;
  803cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  803d02:	eb 10                	jmp    803d14 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d07:	89 c2                	mov    %eax,%edx
  803d09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0d:	88 10                	mov    %dl,(%rax)
	return 1;
  803d0f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d14:	c9                   	leaveq 
  803d15:	c3                   	retq   

0000000000803d16 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d16:	55                   	push   %rbp
  803d17:	48 89 e5             	mov    %rsp,%rbp
  803d1a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d21:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d28:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d2f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d3d:	eb 76                	jmp    803db5 <devcons_write+0x9f>
		m = n - tot;
  803d3f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d46:	89 c2                	mov    %eax,%edx
  803d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4b:	29 c2                	sub    %eax,%edx
  803d4d:	89 d0                	mov    %edx,%eax
  803d4f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d55:	83 f8 7f             	cmp    $0x7f,%eax
  803d58:	76 07                	jbe    803d61 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d5a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d64:	48 63 d0             	movslq %eax,%rdx
  803d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6a:	48 63 c8             	movslq %eax,%rcx
  803d6d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d74:	48 01 c1             	add    %rax,%rcx
  803d77:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d7e:	48 89 ce             	mov    %rcx,%rsi
  803d81:	48 89 c7             	mov    %rax,%rdi
  803d84:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d93:	48 63 d0             	movslq %eax,%rdx
  803d96:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d9d:	48 89 d6             	mov    %rdx,%rsi
  803da0:	48 89 c7             	mov    %rax,%rdi
  803da3:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803daf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803db2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db8:	48 98                	cltq   
  803dba:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dc1:	0f 82 78 ff ff ff    	jb     803d3f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dca:	c9                   	leaveq 
  803dcb:	c3                   	retq   

0000000000803dcc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803dcc:	55                   	push   %rbp
  803dcd:	48 89 e5             	mov    %rsp,%rbp
  803dd0:	48 83 ec 08          	sub    $0x8,%rsp
  803dd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ddd:	c9                   	leaveq 
  803dde:	c3                   	retq   

0000000000803ddf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ddf:	55                   	push   %rbp
  803de0:	48 89 e5             	mov    %rsp,%rbp
  803de3:	48 83 ec 10          	sub    $0x10,%rsp
  803de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df3:	48 be 04 4a 80 00 00 	movabs $0x804a04,%rsi
  803dfa:	00 00 00 
  803dfd:	48 89 c7             	mov    %rax,%rdi
  803e00:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803e07:	00 00 00 
  803e0a:	ff d0                	callq  *%rax
	return 0;
  803e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e11:	c9                   	leaveq 
  803e12:	c3                   	retq   

0000000000803e13 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803e13:	55                   	push   %rbp
  803e14:	48 89 e5             	mov    %rsp,%rbp
  803e17:	48 83 ec 10          	sub    $0x10,%rsp
  803e1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803e1f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e26:	00 00 00 
  803e29:	48 8b 00             	mov    (%rax),%rax
  803e2c:	48 85 c0             	test   %rax,%rax
  803e2f:	0f 85 84 00 00 00    	jne    803eb9 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803e35:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e3c:	00 00 00 
  803e3f:	48 8b 00             	mov    (%rax),%rax
  803e42:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e48:	ba 07 00 00 00       	mov    $0x7,%edx
  803e4d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803e52:	89 c7                	mov    %eax,%edi
  803e54:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
  803e60:	85 c0                	test   %eax,%eax
  803e62:	79 2a                	jns    803e8e <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803e64:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
  803e6b:	00 00 00 
  803e6e:	be 23 00 00 00       	mov    $0x23,%esi
  803e73:	48 bf 37 4a 80 00 00 	movabs $0x804a37,%rdi
  803e7a:	00 00 00 
  803e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e82:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  803e89:	00 00 00 
  803e8c:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803e8e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e95:	00 00 00 
  803e98:	48 8b 00             	mov    (%rax),%rax
  803e9b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ea1:	48 be cc 3e 80 00 00 	movabs $0x803ecc,%rsi
  803ea8:	00 00 00 
  803eab:	89 c7                	mov    %eax,%edi
  803ead:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803eb9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ec0:	00 00 00 
  803ec3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ec7:	48 89 10             	mov    %rdx,(%rax)
}
  803eca:	c9                   	leaveq 
  803ecb:	c3                   	retq   

0000000000803ecc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803ecc:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803ecf:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803ed6:	00 00 00 
call *%rax
  803ed9:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803edb:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803ee2:	00 
movq 152(%rsp), %rcx  //Load RSP
  803ee3:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803eea:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803eeb:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803eef:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803ef2:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803ef9:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803efa:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803efe:	4c 8b 3c 24          	mov    (%rsp),%r15
  803f02:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803f07:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803f0c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803f11:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803f16:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803f1b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803f20:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803f25:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803f2a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803f2f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803f34:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803f39:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803f3e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803f43:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803f48:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803f4c:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803f50:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803f51:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803f52:	c3                   	retq   

0000000000803f53 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f53:	55                   	push   %rbp
  803f54:	48 89 e5             	mov    %rsp,%rbp
  803f57:	48 83 ec 30          	sub    $0x30,%rsp
  803f5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f6e:	00 00 00 
  803f71:	48 8b 00             	mov    (%rax),%rax
  803f74:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f7a:	85 c0                	test   %eax,%eax
  803f7c:	75 34                	jne    803fb2 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f7e:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
  803f8a:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f8f:	48 98                	cltq   
  803f91:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803f98:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f9f:	00 00 00 
  803fa2:	48 01 c2             	add    %rax,%rdx
  803fa5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fac:	00 00 00 
  803faf:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803fb2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fb7:	75 0e                	jne    803fc7 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803fb9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fc0:	00 00 00 
  803fc3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fcb:	48 89 c7             	mov    %rax,%rdi
  803fce:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  803fd5:	00 00 00 
  803fd8:	ff d0                	callq  *%rax
  803fda:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fe1:	79 19                	jns    803ffc <ipc_recv+0xa9>
		*from_env_store = 0;
  803fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fe7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ff7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ffa:	eb 53                	jmp    80404f <ipc_recv+0xfc>
	}
	if(from_env_store)
  803ffc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804001:	74 19                	je     80401c <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  804003:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80400a:	00 00 00 
  80400d:	48 8b 00             	mov    (%rax),%rax
  804010:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401a:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80401c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804021:	74 19                	je     80403c <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804023:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80402a:	00 00 00 
  80402d:	48 8b 00             	mov    (%rax),%rax
  804030:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804036:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403a:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80403c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804043:	00 00 00 
  804046:	48 8b 00             	mov    (%rax),%rax
  804049:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80404f:	c9                   	leaveq 
  804050:	c3                   	retq   

0000000000804051 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804051:	55                   	push   %rbp
  804052:	48 89 e5             	mov    %rsp,%rbp
  804055:	48 83 ec 30          	sub    $0x30,%rsp
  804059:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80405c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80405f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804063:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804066:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80406b:	75 0e                	jne    80407b <ipc_send+0x2a>
		pg = (void*)UTOP;
  80406d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804074:	00 00 00 
  804077:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80407b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80407e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804081:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804085:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804088:	89 c7                	mov    %eax,%edi
  80408a:	48 b8 ba 1c 80 00 00 	movabs $0x801cba,%rax
  804091:	00 00 00 
  804094:	ff d0                	callq  *%rax
  804096:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804099:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80409d:	75 0c                	jne    8040ab <ipc_send+0x5a>
			sys_yield();
  80409f:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  8040a6:	00 00 00 
  8040a9:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8040ab:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040af:	74 ca                	je     80407b <ipc_send+0x2a>
	if(result != 0)
  8040b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b5:	74 20                	je     8040d7 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8040b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ba:	89 c6                	mov    %eax,%esi
  8040bc:	48 bf 45 4a 80 00 00 	movabs $0x804a45,%rdi
  8040c3:	00 00 00 
  8040c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040cb:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8040d2:	00 00 00 
  8040d5:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8040d7:	c9                   	leaveq 
  8040d8:	c3                   	retq   

00000000008040d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8040d9:	55                   	push   %rbp
  8040da:	48 89 e5             	mov    %rsp,%rbp
  8040dd:	48 83 ec 14          	sub    $0x14,%rsp
  8040e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8040e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040eb:	eb 4e                	jmp    80413b <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8040ed:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8040f4:	00 00 00 
  8040f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fa:	48 98                	cltq   
  8040fc:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804103:	48 01 d0             	add    %rdx,%rax
  804106:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80410c:	8b 00                	mov    (%rax),%eax
  80410e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804111:	75 24                	jne    804137 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804113:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80411a:	00 00 00 
  80411d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804120:	48 98                	cltq   
  804122:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804129:	48 01 d0             	add    %rdx,%rax
  80412c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804132:	8b 40 08             	mov    0x8(%rax),%eax
  804135:	eb 12                	jmp    804149 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804137:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80413b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804142:	7e a9                	jle    8040ed <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804149:	c9                   	leaveq 
  80414a:	c3                   	retq   

000000000080414b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80414b:	55                   	push   %rbp
  80414c:	48 89 e5             	mov    %rsp,%rbp
  80414f:	48 83 ec 18          	sub    $0x18,%rsp
  804153:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80415b:	48 c1 e8 15          	shr    $0x15,%rax
  80415f:	48 89 c2             	mov    %rax,%rdx
  804162:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804169:	01 00 00 
  80416c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804170:	83 e0 01             	and    $0x1,%eax
  804173:	48 85 c0             	test   %rax,%rax
  804176:	75 07                	jne    80417f <pageref+0x34>
		return 0;
  804178:	b8 00 00 00 00       	mov    $0x0,%eax
  80417d:	eb 53                	jmp    8041d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80417f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804183:	48 c1 e8 0c          	shr    $0xc,%rax
  804187:	48 89 c2             	mov    %rax,%rdx
  80418a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804191:	01 00 00 
  804194:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804198:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80419c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a0:	83 e0 01             	and    $0x1,%eax
  8041a3:	48 85 c0             	test   %rax,%rax
  8041a6:	75 07                	jne    8041af <pageref+0x64>
		return 0;
  8041a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ad:	eb 23                	jmp    8041d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8041af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8041b7:	48 89 c2             	mov    %rax,%rdx
  8041ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8041c1:	00 00 00 
  8041c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8041c8:	48 01 d0             	add    %rdx,%rax
  8041cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8041cf:	0f b7 c0             	movzwl %ax,%eax
}
  8041d2:	c9                   	leaveq 
  8041d3:	c3                   	retq   
