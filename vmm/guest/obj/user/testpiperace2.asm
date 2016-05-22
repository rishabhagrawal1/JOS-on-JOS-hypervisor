
vmm/guest/obj/user/testpiperace2:     file format elf64-x86-64


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
  800052:	48 bf 20 44 80 00 00 	movabs $0x804420,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 99 34 80 00 00 	movabs $0x803499,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 42 44 80 00 00 	movabs $0x804442,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 1f 22 80 00 00 	movabs $0x80221f,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
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
  80010d:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
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
  800151:	48 bf 69 44 80 00 00 	movabs $0x804469,%rdi
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
  800176:	48 b8 37 28 80 00 00 	movabs $0x802837,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
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
  8001f1:	48 b8 62 37 80 00 00 	movabs $0x803762,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 38                	je     800239 <umain+0x1f6>
			cprintf("\nRACE: pipe appears closed\n");
  800201:	48 bf 6d 44 80 00 00 	movabs $0x80446d,%rdi
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
  800248:	48 bf 89 44 80 00 00 	movabs $0x804489,%rdi
  80024f:	00 00 00 
  800252:	b8 00 00 00 00       	mov    $0x0,%eax
  800257:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  80025e:	00 00 00 
  800261:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800263:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 62 37 80 00 00 	movabs $0x803762,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
  800274:	85 c0                	test   %eax,%eax
  800276:	74 2a                	je     8002a2 <umain+0x25f>
		panic("somehow the other end of p[0] got closed!");
  800278:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  80027f:	00 00 00 
  800282:	be 40 00 00 00       	mov    $0x40,%esi
  800287:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
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
  8002ae:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax
  8002ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c1:	79 30                	jns    8002f3 <umain+0x2b0>
		panic("cannot look up p[0]: %e", r);
  8002c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002c6:	89 c1                	mov    %eax,%ecx
  8002c8:	48 ba ca 44 80 00 00 	movabs $0x8044ca,%rdx
  8002cf:	00 00 00 
  8002d2:	be 42 00 00 00       	mov    $0x42,%esi
  8002d7:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  8002ed:	00 00 00 
  8002f0:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002f7:	48 89 c7             	mov    %rax,%rdi
  8002fa:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800306:	48 bf e2 44 80 00 00 	movabs $0x8044e2,%rdi
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
  8003aa:	48 b8 09 28 80 00 00 	movabs $0x802809,%rax
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
  800483:	48 bf 00 45 80 00 00 	movabs $0x804500,%rdi
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
  8004bf:	48 bf 23 45 80 00 00 	movabs $0x804523,%rdi
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
  80076e:	48 ba 30 47 80 00 00 	movabs $0x804730,%rdx
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
  800a66:	48 b8 58 47 80 00 00 	movabs $0x804758,%rax
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
  800bb9:	48 b8 80 46 80 00 00 	movabs $0x804680,%rax
  800bc0:	00 00 00 
  800bc3:	48 63 d3             	movslq %ebx,%rdx
  800bc6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bca:	4d 85 e4             	test   %r12,%r12
  800bcd:	75 2e                	jne    800bfd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	89 d9                	mov    %ebx,%ecx
  800bd9:	48 ba 41 47 80 00 00 	movabs $0x804741,%rdx
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
  800c08:	48 ba 4a 47 80 00 00 	movabs $0x80474a,%rdx
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
  800c62:	49 bc 4d 47 80 00 00 	movabs $0x80474d,%r12
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
  801968:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  80196f:	00 00 00 
  801972:	be 23 00 00 00       	mov    $0x23,%esi
  801977:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
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

0000000000801e36 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
  801e3a:	48 83 ec 30          	sub    $0x30,%rsp
  801e3e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e46:	48 8b 00             	mov    (%rax),%rax
  801e49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e51:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e55:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e58:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e5b:	83 e0 02             	and    $0x2,%eax
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	75 4d                	jne    801eaf <pgfault+0x79>
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e74:	01 00 00 
  801e77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7b:	25 00 08 00 00       	and    $0x800,%eax
  801e80:	48 85 c0             	test   %rax,%rax
  801e83:	74 2a                	je     801eaf <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e85:	48 ba 38 4a 80 00 00 	movabs $0x804a38,%rdx
  801e8c:	00 00 00 
  801e8f:	be 23 00 00 00       	mov    $0x23,%esi
  801e94:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  801e9b:	00 00 00 
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea3:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801eaa:	00 00 00 
  801ead:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801eaf:	ba 07 00 00 00       	mov    $0x7,%edx
  801eb4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebe:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	0f 85 cd 00 00 00    	jne    801f9f <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ed2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ede:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ee4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801ee8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eec:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ef1:	48 89 c6             	mov    %rax,%rsi
  801ef4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ef9:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  801f00:	00 00 00 
  801f03:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f09:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f0f:	48 89 c1             	mov    %rax,%rcx
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
  801f17:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f21:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	callq  *%rax
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	79 2a                	jns    801f5b <pgfault+0x125>
				panic("Page map at temp address failed");
  801f31:	48 ba 78 4a 80 00 00 	movabs $0x804a78,%rdx
  801f38:	00 00 00 
  801f3b:	be 30 00 00 00       	mov    $0x30,%esi
  801f40:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  801f47:	00 00 00 
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801f56:	00 00 00 
  801f59:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f5b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f60:	bf 00 00 00 00       	mov    $0x0,%edi
  801f65:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	79 54                	jns    801fc9 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f75:	48 ba 98 4a 80 00 00 	movabs $0x804a98,%rdx
  801f7c:	00 00 00 
  801f7f:	be 32 00 00 00       	mov    $0x32,%esi
  801f84:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  801f8b:	00 00 00 
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801f9a:	00 00 00 
  801f9d:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f9f:	48 ba c0 4a 80 00 00 	movabs $0x804ac0,%rdx
  801fa6:	00 00 00 
  801fa9:	be 34 00 00 00       	mov    $0x34,%esi
  801fae:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  801fb5:	00 00 00 
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  801fc4:	00 00 00 
  801fc7:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fc9:	c9                   	leaveq 
  801fca:	c3                   	retq   

0000000000801fcb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fcb:	55                   	push   %rbp
  801fcc:	48 89 e5             	mov    %rsp,%rbp
  801fcf:	48 83 ec 20          	sub    $0x20,%rsp
  801fd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801fd9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe0:	01 00 00 
  801fe3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fe6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fea:	25 07 0e 00 00       	and    $0xe07,%eax
  801fef:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801ff2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ff5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802000:	25 00 04 00 00       	and    $0x400,%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	74 57                	je     802060 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802009:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80200c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802010:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802017:	41 89 f0             	mov    %esi,%r8d
  80201a:	48 89 c6             	mov    %rax,%rsi
  80201d:	bf 00 00 00 00       	mov    $0x0,%edi
  802022:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
  80202e:	85 c0                	test   %eax,%eax
  802030:	0f 8e 52 01 00 00    	jle    802188 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802036:	48 ba f2 4a 80 00 00 	movabs $0x804af2,%rdx
  80203d:	00 00 00 
  802040:	be 4e 00 00 00       	mov    $0x4e,%esi
  802045:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  80204c:	00 00 00 
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80205b:	00 00 00 
  80205e:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802063:	83 e0 02             	and    $0x2,%eax
  802066:	85 c0                	test   %eax,%eax
  802068:	75 10                	jne    80207a <duppage+0xaf>
  80206a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206d:	25 00 08 00 00       	and    $0x800,%eax
  802072:	85 c0                	test   %eax,%eax
  802074:	0f 84 bb 00 00 00    	je     802135 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80207a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207d:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802082:	80 cc 08             	or     $0x8,%ah
  802085:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802088:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80208b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80208f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802096:	41 89 f0             	mov    %esi,%r8d
  802099:	48 89 c6             	mov    %rax,%rsi
  80209c:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a1:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	7e 2a                	jle    8020db <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020b1:	48 ba f2 4a 80 00 00 	movabs $0x804af2,%rdx
  8020b8:	00 00 00 
  8020bb:	be 55 00 00 00       	mov    $0x55,%esi
  8020c0:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  8020c7:	00 00 00 
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8020d6:	00 00 00 
  8020d9:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020db:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e6:	41 89 c8             	mov    %ecx,%r8d
  8020e9:	48 89 d1             	mov    %rdx,%rcx
  8020ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f1:	48 89 c6             	mov    %rax,%rsi
  8020f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f9:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	85 c0                	test   %eax,%eax
  802107:	7e 2a                	jle    802133 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802109:	48 ba f2 4a 80 00 00 	movabs $0x804af2,%rdx
  802110:	00 00 00 
  802113:	be 57 00 00 00       	mov    $0x57,%esi
  802118:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  80211f:	00 00 00 
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  80212e:	00 00 00 
  802131:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802133:	eb 53                	jmp    802188 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802135:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802138:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80213c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80213f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802143:	41 89 f0             	mov    %esi,%r8d
  802146:	48 89 c6             	mov    %rax,%rsi
  802149:	bf 00 00 00 00       	mov    $0x0,%edi
  80214e:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802155:	00 00 00 
  802158:	ff d0                	callq  *%rax
  80215a:	85 c0                	test   %eax,%eax
  80215c:	7e 2a                	jle    802188 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80215e:	48 ba f2 4a 80 00 00 	movabs $0x804af2,%rdx
  802165:	00 00 00 
  802168:	be 5b 00 00 00       	mov    $0x5b,%esi
  80216d:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  802174:	00 00 00 
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
  80217c:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  802183:	00 00 00 
  802186:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218d:	c9                   	leaveq 
  80218e:	c3                   	retq   

000000000080218f <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80218f:	55                   	push   %rbp
  802190:	48 89 e5             	mov    %rsp,%rbp
  802193:	48 83 ec 18          	sub    $0x18,%rsp
  802197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80219b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a7:	48 c1 e8 27          	shr    $0x27,%rax
  8021ab:	48 89 c2             	mov    %rax,%rdx
  8021ae:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021b5:	01 00 00 
  8021b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bc:	83 e0 01             	and    $0x1,%eax
  8021bf:	48 85 c0             	test   %rax,%rax
  8021c2:	74 51                	je     802215 <pt_is_mapped+0x86>
  8021c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c8:	48 c1 e0 0c          	shl    $0xc,%rax
  8021cc:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021d0:	48 89 c2             	mov    %rax,%rdx
  8021d3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021da:	01 00 00 
  8021dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e1:	83 e0 01             	and    $0x1,%eax
  8021e4:	48 85 c0             	test   %rax,%rax
  8021e7:	74 2c                	je     802215 <pt_is_mapped+0x86>
  8021e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ed:	48 c1 e0 0c          	shl    $0xc,%rax
  8021f1:	48 c1 e8 15          	shr    $0x15,%rax
  8021f5:	48 89 c2             	mov    %rax,%rdx
  8021f8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ff:	01 00 00 
  802202:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802206:	83 e0 01             	and    $0x1,%eax
  802209:	48 85 c0             	test   %rax,%rax
  80220c:	74 07                	je     802215 <pt_is_mapped+0x86>
  80220e:	b8 01 00 00 00       	mov    $0x1,%eax
  802213:	eb 05                	jmp    80221a <pt_is_mapped+0x8b>
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	83 e0 01             	and    $0x1,%eax
}
  80221d:	c9                   	leaveq 
  80221e:	c3                   	retq   

000000000080221f <fork>:

envid_t
fork(void)
{
  80221f:	55                   	push   %rbp
  802220:	48 89 e5             	mov    %rsp,%rbp
  802223:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802227:	48 bf 36 1e 80 00 00 	movabs $0x801e36,%rdi
  80222e:	00 00 00 
  802231:	48 b8 15 3d 80 00 00 	movabs $0x803d15,%rax
  802238:	00 00 00 
  80223b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80223d:	b8 07 00 00 00       	mov    $0x7,%eax
  802242:	cd 30                	int    $0x30
  802244:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802247:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80224a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80224d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802251:	79 30                	jns    802283 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802253:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802256:	89 c1                	mov    %eax,%ecx
  802258:	48 ba 10 4b 80 00 00 	movabs $0x804b10,%rdx
  80225f:	00 00 00 
  802262:	be 86 00 00 00       	mov    $0x86,%esi
  802267:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  80226e:	00 00 00 
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
  802276:	49 b8 c9 03 80 00 00 	movabs $0x8003c9,%r8
  80227d:	00 00 00 
  802280:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802283:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802287:	75 3e                	jne    8022c7 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802289:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	25 ff 03 00 00       	and    $0x3ff,%eax
  80229a:	48 98                	cltq   
  80229c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8022a3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022aa:	00 00 00 
  8022ad:	48 01 c2             	add    %rax,%rdx
  8022b0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022b7:	00 00 00 
  8022ba:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c2:	e9 d1 01 00 00       	jmpq   802498 <fork+0x279>
	}
	uint64_t ad = 0;
  8022c7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022ce:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022cf:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022d8:	e9 df 00 00 00       	jmpq   8023bc <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e1:	48 c1 e8 27          	shr    $0x27,%rax
  8022e5:	48 89 c2             	mov    %rax,%rdx
  8022e8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022ef:	01 00 00 
  8022f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f6:	83 e0 01             	and    $0x1,%eax
  8022f9:	48 85 c0             	test   %rax,%rax
  8022fc:	0f 84 9e 00 00 00    	je     8023a0 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802306:	48 c1 e8 1e          	shr    $0x1e,%rax
  80230a:	48 89 c2             	mov    %rax,%rdx
  80230d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802314:	01 00 00 
  802317:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231b:	83 e0 01             	and    $0x1,%eax
  80231e:	48 85 c0             	test   %rax,%rax
  802321:	74 73                	je     802396 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802327:	48 c1 e8 15          	shr    $0x15,%rax
  80232b:	48 89 c2             	mov    %rax,%rdx
  80232e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802335:	01 00 00 
  802338:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233c:	83 e0 01             	and    $0x1,%eax
  80233f:	48 85 c0             	test   %rax,%rax
  802342:	74 48                	je     80238c <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802348:	48 c1 e8 0c          	shr    $0xc,%rax
  80234c:	48 89 c2             	mov    %rax,%rdx
  80234f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802356:	01 00 00 
  802359:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802365:	83 e0 01             	and    $0x1,%eax
  802368:	48 85 c0             	test   %rax,%rax
  80236b:	74 47                	je     8023b4 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80236d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802371:	48 c1 e8 0c          	shr    $0xc,%rax
  802375:	89 c2                	mov    %eax,%edx
  802377:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80237a:	89 d6                	mov    %edx,%esi
  80237c:	89 c7                	mov    %eax,%edi
  80237e:	48 b8 cb 1f 80 00 00 	movabs $0x801fcb,%rax
  802385:	00 00 00 
  802388:	ff d0                	callq  *%rax
  80238a:	eb 28                	jmp    8023b4 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80238c:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802393:	00 
  802394:	eb 1e                	jmp    8023b4 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802396:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80239d:	40 
  80239e:	eb 14                	jmp    8023b4 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8023a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a4:	48 c1 e8 27          	shr    $0x27,%rax
  8023a8:	48 83 c0 01          	add    $0x1,%rax
  8023ac:	48 c1 e0 27          	shl    $0x27,%rax
  8023b0:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023b4:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023bb:	00 
  8023bc:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023c3:	00 
  8023c4:	0f 87 13 ff ff ff    	ja     8022dd <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023cd:	ba 07 00 00 00       	mov    $0x7,%edx
  8023d2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023d7:	89 c7                	mov    %eax,%edi
  8023d9:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8023e0:	00 00 00 
  8023e3:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ed:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023f2:	89 c7                	mov    %eax,%edi
  8023f4:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802403:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802409:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80240e:	ba 00 00 00 00       	mov    $0x0,%edx
  802413:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802418:	89 c7                	mov    %eax,%edi
  80241a:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802426:	ba 00 10 00 00       	mov    $0x1000,%edx
  80242b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802430:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802435:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802441:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802446:	bf 00 00 00 00       	mov    $0x0,%edi
  80244b:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802457:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80245e:	00 00 00 
  802461:	48 8b 00             	mov    (%rax),%rax
  802464:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80246b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246e:	48 89 d6             	mov    %rdx,%rsi
  802471:	89 c7                	mov    %eax,%edi
  802473:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80247f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802482:	be 02 00 00 00       	mov    $0x2,%esi
  802487:	89 c7                	mov    %eax,%edi
  802489:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  802490:	00 00 00 
  802493:	ff d0                	callq  *%rax

	return envid;
  802495:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <sfork>:

	
// Challenge!
int
sfork(void)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80249e:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  8024a5:	00 00 00 
  8024a8:	be bf 00 00 00       	mov    $0xbf,%esi
  8024ad:	48 bf 6d 4a 80 00 00 	movabs $0x804a6d,%rdi
  8024b4:	00 00 00 
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  8024c3:	00 00 00 
  8024c6:	ff d1                	callq  *%rcx

00000000008024c8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	48 83 ec 08          	sub    $0x8,%rsp
  8024d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024d8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024df:	ff ff ff 
  8024e2:	48 01 d0             	add    %rdx,%rax
  8024e5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024e9:	c9                   	leaveq 
  8024ea:	c3                   	retq   

00000000008024eb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
  8024ef:	48 83 ec 08          	sub    $0x8,%rsp
  8024f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fb:	48 89 c7             	mov    %rax,%rdi
  8024fe:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802505:	00 00 00 
  802508:	ff d0                	callq  *%rax
  80250a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802510:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802514:	c9                   	leaveq 
  802515:	c3                   	retq   

0000000000802516 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802516:	55                   	push   %rbp
  802517:	48 89 e5             	mov    %rsp,%rbp
  80251a:	48 83 ec 18          	sub    $0x18,%rsp
  80251e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802522:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802529:	eb 6b                	jmp    802596 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80252b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252e:	48 98                	cltq   
  802530:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802536:	48 c1 e0 0c          	shl    $0xc,%rax
  80253a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80253e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802542:	48 c1 e8 15          	shr    $0x15,%rax
  802546:	48 89 c2             	mov    %rax,%rdx
  802549:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802550:	01 00 00 
  802553:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802557:	83 e0 01             	and    $0x1,%eax
  80255a:	48 85 c0             	test   %rax,%rax
  80255d:	74 21                	je     802580 <fd_alloc+0x6a>
  80255f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802563:	48 c1 e8 0c          	shr    $0xc,%rax
  802567:	48 89 c2             	mov    %rax,%rdx
  80256a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802571:	01 00 00 
  802574:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802578:	83 e0 01             	and    $0x1,%eax
  80257b:	48 85 c0             	test   %rax,%rax
  80257e:	75 12                	jne    802592 <fd_alloc+0x7c>
			*fd_store = fd;
  802580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802584:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802588:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	eb 1a                	jmp    8025ac <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802592:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802596:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80259a:	7e 8f                	jle    80252b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80259c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025a7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ac:	c9                   	leaveq 
  8025ad:	c3                   	retq   

00000000008025ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
  8025b2:	48 83 ec 20          	sub    $0x20,%rsp
  8025b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025c1:	78 06                	js     8025c9 <fd_lookup+0x1b>
  8025c3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025c7:	7e 07                	jle    8025d0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ce:	eb 6c                	jmp    80263c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d3:	48 98                	cltq   
  8025d5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025db:	48 c1 e0 0c          	shl    $0xc,%rax
  8025df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e7:	48 c1 e8 15          	shr    $0x15,%rax
  8025eb:	48 89 c2             	mov    %rax,%rdx
  8025ee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f5:	01 00 00 
  8025f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fc:	83 e0 01             	and    $0x1,%eax
  8025ff:	48 85 c0             	test   %rax,%rax
  802602:	74 21                	je     802625 <fd_lookup+0x77>
  802604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802608:	48 c1 e8 0c          	shr    $0xc,%rax
  80260c:	48 89 c2             	mov    %rax,%rdx
  80260f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802616:	01 00 00 
  802619:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261d:	83 e0 01             	and    $0x1,%eax
  802620:	48 85 c0             	test   %rax,%rax
  802623:	75 07                	jne    80262c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80262a:	eb 10                	jmp    80263c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80262c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802630:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802634:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	c9                   	leaveq 
  80263d:	c3                   	retq   

000000000080263e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 30          	sub    $0x30,%rsp
  802646:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80264a:	89 f0                	mov    %esi,%eax
  80264c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80264f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802653:	48 89 c7             	mov    %rax,%rdi
  802656:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802666:	48 89 d6             	mov    %rdx,%rsi
  802669:	89 c7                	mov    %eax,%edi
  80266b:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
  802677:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267e:	78 0a                	js     80268a <fd_close+0x4c>
	    || fd != fd2)
  802680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802684:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802688:	74 12                	je     80269c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80268a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80268e:	74 05                	je     802695 <fd_close+0x57>
  802690:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802693:	eb 05                	jmp    80269a <fd_close+0x5c>
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	eb 69                	jmp    802705 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80269c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a0:	8b 00                	mov    (%rax),%eax
  8026a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026a6:	48 89 d6             	mov    %rdx,%rsi
  8026a9:	89 c7                	mov    %eax,%edi
  8026ab:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026be:	78 2a                	js     8026ea <fd_close+0xac>
		if (dev->dev_close)
  8026c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026c8:	48 85 c0             	test   %rax,%rax
  8026cb:	74 16                	je     8026e3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026d9:	48 89 d7             	mov    %rdx,%rdi
  8026dc:	ff d0                	callq  *%rax
  8026de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e1:	eb 07                	jmp    8026ea <fd_close+0xac>
		else
			r = 0;
  8026e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ee:	48 89 c6             	mov    %rax,%rsi
  8026f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f6:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
	return r;
  802702:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   

0000000000802707 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	48 83 ec 20          	sub    $0x20,%rsp
  80270f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802712:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802716:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80271d:	eb 41                	jmp    802760 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80271f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802726:	00 00 00 
  802729:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80272c:	48 63 d2             	movslq %edx,%rdx
  80272f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802733:	8b 00                	mov    (%rax),%eax
  802735:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802738:	75 22                	jne    80275c <dev_lookup+0x55>
			*dev = devtab[i];
  80273a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802741:	00 00 00 
  802744:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802747:	48 63 d2             	movslq %edx,%rdx
  80274a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80274e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802752:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	eb 60                	jmp    8027bc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80275c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802760:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802767:	00 00 00 
  80276a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276d:	48 63 d2             	movslq %edx,%rdx
  802770:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802774:	48 85 c0             	test   %rax,%rax
  802777:	75 a6                	jne    80271f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802779:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802780:	00 00 00 
  802783:	48 8b 00             	mov    (%rax),%rax
  802786:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	48 bf 40 4b 80 00 00 	movabs $0x804b40,%rdi
  802798:	00 00 00 
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  8027a7:	00 00 00 
  8027aa:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027bc:	c9                   	leaveq 
  8027bd:	c3                   	retq   

00000000008027be <close>:

int
close(int fdnum)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	48 83 ec 20          	sub    $0x20,%rsp
  8027c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d0:	48 89 d6             	mov    %rdx,%rsi
  8027d3:	89 c7                	mov    %eax,%edi
  8027d5:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e8:	79 05                	jns    8027ef <close+0x31>
		return r;
  8027ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ed:	eb 18                	jmp    802807 <close+0x49>
	else
		return fd_close(fd, 1);
  8027ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f3:	be 01 00 00 00       	mov    $0x1,%esi
  8027f8:	48 89 c7             	mov    %rax,%rdi
  8027fb:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
}
  802807:	c9                   	leaveq 
  802808:	c3                   	retq   

0000000000802809 <close_all>:

void
close_all(void)
{
  802809:	55                   	push   %rbp
  80280a:	48 89 e5             	mov    %rsp,%rbp
  80280d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802818:	eb 15                	jmp    80282f <close_all+0x26>
		close(i);
  80281a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281d:	89 c7                	mov    %eax,%edi
  80281f:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802826:	00 00 00 
  802829:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80282b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80282f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802833:	7e e5                	jle    80281a <close_all+0x11>
		close(i);
}
  802835:	c9                   	leaveq 
  802836:	c3                   	retq   

0000000000802837 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802837:	55                   	push   %rbp
  802838:	48 89 e5             	mov    %rsp,%rbp
  80283b:	48 83 ec 40          	sub    $0x40,%rsp
  80283f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802842:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802845:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802849:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80284c:	48 89 d6             	mov    %rdx,%rsi
  80284f:	89 c7                	mov    %eax,%edi
  802851:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
  80285d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802864:	79 08                	jns    80286e <dup+0x37>
		return r;
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	e9 70 01 00 00       	jmpq   8029de <dup+0x1a7>
	close(newfdnum);
  80286e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802871:	89 c7                	mov    %eax,%edi
  802873:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80287f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802882:	48 98                	cltq   
  802884:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80288a:	48 c1 e0 0c          	shl    $0xc,%rax
  80288e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802896:	48 89 c7             	mov    %rax,%rdi
  802899:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	callq  *%rax
  8028a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ad:	48 89 c7             	mov    %rax,%rdi
  8028b0:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	callq  *%rax
  8028bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	48 c1 e8 15          	shr    $0x15,%rax
  8028c8:	48 89 c2             	mov    %rax,%rdx
  8028cb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028d2:	01 00 00 
  8028d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d9:	83 e0 01             	and    $0x1,%eax
  8028dc:	48 85 c0             	test   %rax,%rax
  8028df:	74 73                	je     802954 <dup+0x11d>
  8028e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e9:	48 89 c2             	mov    %rax,%rdx
  8028ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f3:	01 00 00 
  8028f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028fa:	83 e0 01             	and    $0x1,%eax
  8028fd:	48 85 c0             	test   %rax,%rax
  802900:	74 52                	je     802954 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802906:	48 c1 e8 0c          	shr    $0xc,%rax
  80290a:	48 89 c2             	mov    %rax,%rdx
  80290d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802914:	01 00 00 
  802917:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291b:	25 07 0e 00 00       	and    $0xe07,%eax
  802920:	89 c1                	mov    %eax,%ecx
  802922:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292a:	41 89 c8             	mov    %ecx,%r8d
  80292d:	48 89 d1             	mov    %rdx,%rcx
  802930:	ba 00 00 00 00       	mov    $0x0,%edx
  802935:	48 89 c6             	mov    %rax,%rsi
  802938:	bf 00 00 00 00       	mov    $0x0,%edi
  80293d:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802950:	79 02                	jns    802954 <dup+0x11d>
			goto err;
  802952:	eb 57                	jmp    8029ab <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802958:	48 c1 e8 0c          	shr    $0xc,%rax
  80295c:	48 89 c2             	mov    %rax,%rdx
  80295f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802966:	01 00 00 
  802969:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296d:	25 07 0e 00 00       	and    $0xe07,%eax
  802972:	89 c1                	mov    %eax,%ecx
  802974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802978:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80297c:	41 89 c8             	mov    %ecx,%r8d
  80297f:	48 89 d1             	mov    %rdx,%rcx
  802982:	ba 00 00 00 00       	mov    $0x0,%edx
  802987:	48 89 c6             	mov    %rax,%rsi
  80298a:	bf 00 00 00 00       	mov    $0x0,%edi
  80298f:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802996:	00 00 00 
  802999:	ff d0                	callq  *%rax
  80299b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a2:	79 02                	jns    8029a6 <dup+0x16f>
		goto err;
  8029a4:	eb 05                	jmp    8029ab <dup+0x174>

	return newfdnum;
  8029a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a9:	eb 33                	jmp    8029de <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029af:	48 89 c6             	mov    %rax,%rsi
  8029b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b7:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c7:	48 89 c6             	mov    %rax,%rsi
  8029ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8029cf:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
	return r;
  8029db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	48 83 ec 40          	sub    $0x40,%rsp
  8029e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fa:	48 89 d6             	mov    %rdx,%rsi
  8029fd:	89 c7                	mov    %eax,%edi
  8029ff:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a12:	78 24                	js     802a38 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	8b 00                	mov    (%rax),%eax
  802a1a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1e:	48 89 d6             	mov    %rdx,%rsi
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	callq  *%rax
  802a2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a36:	79 05                	jns    802a3d <read+0x5d>
		return r;
  802a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3b:	eb 76                	jmp    802ab3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a41:	8b 40 08             	mov    0x8(%rax),%eax
  802a44:	83 e0 03             	and    $0x3,%eax
  802a47:	83 f8 01             	cmp    $0x1,%eax
  802a4a:	75 3a                	jne    802a86 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a4c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a53:	00 00 00 
  802a56:	48 8b 00             	mov    (%rax),%rax
  802a59:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a62:	89 c6                	mov    %eax,%esi
  802a64:	48 bf 5f 4b 80 00 00 	movabs $0x804b5f,%rdi
  802a6b:	00 00 00 
  802a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a73:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802a7a:	00 00 00 
  802a7d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a84:	eb 2d                	jmp    802ab3 <read+0xd3>
	}
	if (!dev->dev_read)
  802a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a8e:	48 85 c0             	test   %rax,%rax
  802a91:	75 07                	jne    802a9a <read+0xba>
		return -E_NOT_SUPP;
  802a93:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a98:	eb 19                	jmp    802ab3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aa6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aaa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aae:	48 89 cf             	mov    %rcx,%rdi
  802ab1:	ff d0                	callq  *%rax
}
  802ab3:	c9                   	leaveq 
  802ab4:	c3                   	retq   

0000000000802ab5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 30          	sub    $0x30,%rsp
  802abd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802acf:	eb 49                	jmp    802b1a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	48 98                	cltq   
  802ad6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ada:	48 29 c2             	sub    %rax,%rdx
  802add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae0:	48 63 c8             	movslq %eax,%rcx
  802ae3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae7:	48 01 c1             	add    %rax,%rcx
  802aea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aed:	48 89 ce             	mov    %rcx,%rsi
  802af0:	89 c7                	mov    %eax,%edi
  802af2:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b01:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b05:	79 05                	jns    802b0c <readn+0x57>
			return m;
  802b07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b0a:	eb 1c                	jmp    802b28 <readn+0x73>
		if (m == 0)
  802b0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b10:	75 02                	jne    802b14 <readn+0x5f>
			break;
  802b12:	eb 11                	jmp    802b25 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b17:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1d:	48 98                	cltq   
  802b1f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b23:	72 ac                	jb     802ad1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b25:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b28:	c9                   	leaveq 
  802b29:	c3                   	retq   

0000000000802b2a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b2a:	55                   	push   %rbp
  802b2b:	48 89 e5             	mov    %rsp,%rbp
  802b2e:	48 83 ec 40          	sub    $0x40,%rsp
  802b32:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b35:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b39:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b41:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b44:	48 89 d6             	mov    %rdx,%rsi
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5c:	78 24                	js     802b82 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b62:	8b 00                	mov    (%rax),%eax
  802b64:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b68:	48 89 d6             	mov    %rdx,%rsi
  802b6b:	89 c7                	mov    %eax,%edi
  802b6d:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b80:	79 05                	jns    802b87 <write+0x5d>
		return r;
  802b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b85:	eb 42                	jmp    802bc9 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8b:	8b 40 08             	mov    0x8(%rax),%eax
  802b8e:	83 e0 03             	and    $0x3,%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	75 07                	jne    802b9c <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b9a:	eb 2d                	jmp    802bc9 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba0:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ba4:	48 85 c0             	test   %rax,%rax
  802ba7:	75 07                	jne    802bb0 <write+0x86>
		return -E_NOT_SUPP;
  802ba9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bae:	eb 19                	jmp    802bc9 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bb8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bbc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bc0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bc4:	48 89 cf             	mov    %rcx,%rdi
  802bc7:	ff d0                	callq  *%rax
}
  802bc9:	c9                   	leaveq 
  802bca:	c3                   	retq   

0000000000802bcb <seek>:

int
seek(int fdnum, off_t offset)
{
  802bcb:	55                   	push   %rbp
  802bcc:	48 89 e5             	mov    %rsp,%rbp
  802bcf:	48 83 ec 18          	sub    $0x18,%rsp
  802bd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bd9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be0:	48 89 d6             	mov    %rdx,%rsi
  802be3:	89 c7                	mov    %eax,%edi
  802be5:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
  802bf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf8:	79 05                	jns    802bff <seek+0x34>
		return r;
  802bfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfd:	eb 0f                	jmp    802c0e <seek+0x43>
	fd->fd_offset = offset;
  802bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c03:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0e:	c9                   	leaveq 
  802c0f:	c3                   	retq   

0000000000802c10 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c10:	55                   	push   %rbp
  802c11:	48 89 e5             	mov    %rsp,%rbp
  802c14:	48 83 ec 30          	sub    $0x30,%rsp
  802c18:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c1b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c1e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c25:	48 89 d6             	mov    %rdx,%rsi
  802c28:	89 c7                	mov    %eax,%edi
  802c2a:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
  802c36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3d:	78 24                	js     802c63 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c43:	8b 00                	mov    (%rax),%eax
  802c45:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c49:	48 89 d6             	mov    %rdx,%rsi
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
  802c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c61:	79 05                	jns    802c68 <ftruncate+0x58>
		return r;
  802c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c66:	eb 72                	jmp    802cda <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6c:	8b 40 08             	mov    0x8(%rax),%eax
  802c6f:	83 e0 03             	and    $0x3,%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	75 3a                	jne    802cb0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c76:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c7d:	00 00 00 
  802c80:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c83:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c89:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c8c:	89 c6                	mov    %eax,%esi
  802c8e:	48 bf 80 4b 80 00 00 	movabs $0x804b80,%rdi
  802c95:	00 00 00 
  802c98:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9d:	48 b9 02 06 80 00 00 	movabs $0x800602,%rcx
  802ca4:	00 00 00 
  802ca7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ca9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cae:	eb 2a                	jmp    802cda <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb4:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cb8:	48 85 c0             	test   %rax,%rax
  802cbb:	75 07                	jne    802cc4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cbd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cc2:	eb 16                	jmp    802cda <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ccc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cd0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802cd3:	89 ce                	mov    %ecx,%esi
  802cd5:	48 89 d7             	mov    %rdx,%rdi
  802cd8:	ff d0                	callq  *%rax
}
  802cda:	c9                   	leaveq 
  802cdb:	c3                   	retq   

0000000000802cdc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cdc:	55                   	push   %rbp
  802cdd:	48 89 e5             	mov    %rsp,%rbp
  802ce0:	48 83 ec 30          	sub    $0x30,%rsp
  802ce4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ceb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf2:	48 89 d6             	mov    %rdx,%rsi
  802cf5:	89 c7                	mov    %eax,%edi
  802cf7:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0a:	78 24                	js     802d30 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d10:	8b 00                	mov    (%rax),%eax
  802d12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d16:	48 89 d6             	mov    %rdx,%rsi
  802d19:	89 c7                	mov    %eax,%edi
  802d1b:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  802d22:	00 00 00 
  802d25:	ff d0                	callq  *%rax
  802d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2e:	79 05                	jns    802d35 <fstat+0x59>
		return r;
  802d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d33:	eb 5e                	jmp    802d93 <fstat+0xb7>
	if (!dev->dev_stat)
  802d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d39:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d3d:	48 85 c0             	test   %rax,%rax
  802d40:	75 07                	jne    802d49 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d42:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d47:	eb 4a                	jmp    802d93 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d4d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d54:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d5b:	00 00 00 
	stat->st_isdir = 0;
  802d5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d62:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d69:	00 00 00 
	stat->st_dev = dev;
  802d6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d74:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d87:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d8b:	48 89 ce             	mov    %rcx,%rsi
  802d8e:	48 89 d7             	mov    %rdx,%rdi
  802d91:	ff d0                	callq  *%rax
}
  802d93:	c9                   	leaveq 
  802d94:	c3                   	retq   

0000000000802d95 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d95:	55                   	push   %rbp
  802d96:	48 89 e5             	mov    %rsp,%rbp
  802d99:	48 83 ec 20          	sub    $0x20,%rsp
  802d9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802da1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802da5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da9:	be 00 00 00 00       	mov    $0x0,%esi
  802dae:	48 89 c7             	mov    %rax,%rdi
  802db1:	48 b8 83 2e 80 00 00 	movabs $0x802e83,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
  802dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc4:	79 05                	jns    802dcb <stat+0x36>
		return fd;
  802dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc9:	eb 2f                	jmp    802dfa <stat+0x65>
	r = fstat(fd, stat);
  802dcb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd2:	48 89 d6             	mov    %rdx,%rsi
  802dd5:	89 c7                	mov    %eax,%edi
  802dd7:	48 b8 dc 2c 80 00 00 	movabs $0x802cdc,%rax
  802dde:	00 00 00 
  802de1:	ff d0                	callq  *%rax
  802de3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
	return r;
  802df7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 10          	sub    $0x10,%rsp
  802e04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e0b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e12:	00 00 00 
  802e15:	8b 00                	mov    (%rax),%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	75 1d                	jne    802e38 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e1b:	bf 01 00 00 00       	mov    $0x1,%edi
  802e20:	48 b8 20 43 80 00 00 	movabs $0x804320,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
  802e2c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e33:	00 00 00 
  802e36:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e3f:	00 00 00 
  802e42:	8b 00                	mov    (%rax),%eax
  802e44:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e47:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e4c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e53:	00 00 00 
  802e56:	89 c7                	mov    %eax,%edi
  802e58:	48 b8 53 3f 80 00 00 	movabs $0x803f53,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e68:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6d:	48 89 c6             	mov    %rax,%rsi
  802e70:	bf 00 00 00 00       	mov    $0x0,%edi
  802e75:	48 b8 55 3e 80 00 00 	movabs $0x803e55,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
}
  802e81:	c9                   	leaveq 
  802e82:	c3                   	retq   

0000000000802e83 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e83:	55                   	push   %rbp
  802e84:	48 89 e5             	mov    %rsp,%rbp
  802e87:	48 83 ec 30          	sub    $0x30,%rsp
  802e8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e8f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e92:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e99:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ea7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802eac:	75 08                	jne    802eb6 <open+0x33>
	{
		return r;
  802eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb1:	e9 f2 00 00 00       	jmpq   802fa8 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eba:	48 89 c7             	mov    %rax,%rdi
  802ebd:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
  802ec9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ecc:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ed3:	7e 0a                	jle    802edf <open+0x5c>
	{
		return -E_BAD_PATH;
  802ed5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802eda:	e9 c9 00 00 00       	jmpq   802fa8 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802edf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802ee6:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802ee7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802eeb:	48 89 c7             	mov    %rax,%rdi
  802eee:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
  802efa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f01:	78 09                	js     802f0c <open+0x89>
  802f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f07:	48 85 c0             	test   %rax,%rax
  802f0a:	75 08                	jne    802f14 <open+0x91>
		{
			return r;
  802f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0f:	e9 94 00 00 00       	jmpq   802fa8 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f18:	ba 00 04 00 00       	mov    $0x400,%edx
  802f1d:	48 89 c6             	mov    %rax,%rsi
  802f20:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f27:	00 00 00 
  802f2a:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f36:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f3d:	00 00 00 
  802f40:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f43:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4d:	48 89 c6             	mov    %rax,%rsi
  802f50:	bf 01 00 00 00       	mov    $0x1,%edi
  802f55:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f68:	79 2b                	jns    802f95 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6e:	be 00 00 00 00       	mov    $0x0,%esi
  802f73:	48 89 c7             	mov    %rax,%rdi
  802f76:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
  802f82:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f89:	79 05                	jns    802f90 <open+0x10d>
			{
				return d;
  802f8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f8e:	eb 18                	jmp    802fa8 <open+0x125>
			}
			return r;
  802f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f93:	eb 13                	jmp    802fa8 <open+0x125>
		}	
		return fd2num(fd_store);
  802f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f99:	48 89 c7             	mov    %rax,%rdi
  802f9c:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802fa8:	c9                   	leaveq 
  802fa9:	c3                   	retq   

0000000000802faa <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802faa:	55                   	push   %rbp
  802fab:	48 89 e5             	mov    %rsp,%rbp
  802fae:	48 83 ec 10          	sub    $0x10,%rsp
  802fb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fba:	8b 50 0c             	mov    0xc(%rax),%edx
  802fbd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc4:	00 00 00 
  802fc7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fc9:	be 00 00 00 00       	mov    $0x0,%esi
  802fce:	bf 06 00 00 00       	mov    $0x6,%edi
  802fd3:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
}
  802fdf:	c9                   	leaveq 
  802fe0:	c3                   	retq   

0000000000802fe1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fe1:	55                   	push   %rbp
  802fe2:	48 89 e5             	mov    %rsp,%rbp
  802fe5:	48 83 ec 30          	sub    $0x30,%rsp
  802fe9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802ffc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803001:	74 07                	je     80300a <devfile_read+0x29>
  803003:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803008:	75 07                	jne    803011 <devfile_read+0x30>
		return -E_INVAL;
  80300a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80300f:	eb 77                	jmp    803088 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803015:	8b 50 0c             	mov    0xc(%rax),%edx
  803018:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80301f:	00 00 00 
  803022:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803024:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302b:	00 00 00 
  80302e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803032:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803036:	be 00 00 00 00       	mov    $0x0,%esi
  80303b:	bf 03 00 00 00       	mov    $0x3,%edi
  803040:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
  80304c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803053:	7f 05                	jg     80305a <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803058:	eb 2e                	jmp    803088 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80305a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305d:	48 63 d0             	movslq %eax,%rdx
  803060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803064:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80306b:	00 00 00 
  80306e:	48 89 c7             	mov    %rax,%rdi
  803071:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80307d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803081:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803085:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803088:	c9                   	leaveq 
  803089:	c3                   	retq   

000000000080308a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80308a:	55                   	push   %rbp
  80308b:	48 89 e5             	mov    %rsp,%rbp
  80308e:	48 83 ec 30          	sub    $0x30,%rsp
  803092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80309a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80309e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030aa:	74 07                	je     8030b3 <devfile_write+0x29>
  8030ac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030b1:	75 08                	jne    8030bb <devfile_write+0x31>
		return r;
  8030b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b6:	e9 9a 00 00 00       	jmpq   803155 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8030c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c9:	00 00 00 
  8030cc:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8030ce:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030d5:	00 
  8030d6:	76 08                	jbe    8030e0 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8030d8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030df:	00 
	}
	fsipcbuf.write.req_n = n;
  8030e0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e7:	00 00 00 
  8030ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030fa:	48 89 c6             	mov    %rax,%rsi
  8030fd:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803104:	00 00 00 
  803107:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803113:	be 00 00 00 00       	mov    $0x0,%esi
  803118:	bf 04 00 00 00       	mov    $0x4,%edi
  80311d:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
  803129:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803130:	7f 20                	jg     803152 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803132:	48 bf a6 4b 80 00 00 	movabs $0x804ba6,%rdi
  803139:	00 00 00 
  80313c:	b8 00 00 00 00       	mov    $0x0,%eax
  803141:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803148:	00 00 00 
  80314b:	ff d2                	callq  *%rdx
		return r;
  80314d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803150:	eb 03                	jmp    803155 <devfile_write+0xcb>
	}
	return r;
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803155:	c9                   	leaveq 
  803156:	c3                   	retq   

0000000000803157 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803157:	55                   	push   %rbp
  803158:	48 89 e5             	mov    %rsp,%rbp
  80315b:	48 83 ec 20          	sub    $0x20,%rsp
  80315f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803163:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80316b:	8b 50 0c             	mov    0xc(%rax),%edx
  80316e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803175:	00 00 00 
  803178:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80317a:	be 00 00 00 00       	mov    $0x0,%esi
  80317f:	bf 05 00 00 00       	mov    $0x5,%edi
  803184:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  80318b:	00 00 00 
  80318e:	ff d0                	callq  *%rax
  803190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803197:	79 05                	jns    80319e <devfile_stat+0x47>
		return r;
  803199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319c:	eb 56                	jmp    8031f4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80319e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031a9:	00 00 00 
  8031ac:	48 89 c7             	mov    %rax,%rdi
  8031af:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031bb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c2:	00 00 00 
  8031c5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031dc:	00 00 00 
  8031df:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f4:	c9                   	leaveq 
  8031f5:	c3                   	retq   

00000000008031f6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031f6:	55                   	push   %rbp
  8031f7:	48 89 e5             	mov    %rsp,%rbp
  8031fa:	48 83 ec 10          	sub    $0x10,%rsp
  8031fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803202:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803209:	8b 50 0c             	mov    0xc(%rax),%edx
  80320c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803213:	00 00 00 
  803216:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803218:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321f:	00 00 00 
  803222:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803225:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803228:	be 00 00 00 00       	mov    $0x0,%esi
  80322d:	bf 02 00 00 00       	mov    $0x2,%edi
  803232:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
}
  80323e:	c9                   	leaveq 
  80323f:	c3                   	retq   

0000000000803240 <remove>:

// Delete a file
int
remove(const char *path)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
  803244:	48 83 ec 10          	sub    $0x10,%rsp
  803248:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80324c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803250:	48 89 c7             	mov    %rax,%rdi
  803253:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  80325a:	00 00 00 
  80325d:	ff d0                	callq  *%rax
  80325f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803264:	7e 07                	jle    80326d <remove+0x2d>
		return -E_BAD_PATH;
  803266:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80326b:	eb 33                	jmp    8032a0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80326d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803271:	48 89 c6             	mov    %rax,%rsi
  803274:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80327b:	00 00 00 
  80327e:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803285:	00 00 00 
  803288:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80328a:	be 00 00 00 00       	mov    $0x0,%esi
  80328f:	bf 07 00 00 00       	mov    $0x7,%edi
  803294:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
}
  8032a0:	c9                   	leaveq 
  8032a1:	c3                   	retq   

00000000008032a2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032a2:	55                   	push   %rbp
  8032a3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032a6:	be 00 00 00 00       	mov    $0x0,%esi
  8032ab:	bf 08 00 00 00       	mov    $0x8,%edi
  8032b0:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
}
  8032bc:	5d                   	pop    %rbp
  8032bd:	c3                   	retq   

00000000008032be <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032be:	55                   	push   %rbp
  8032bf:	48 89 e5             	mov    %rsp,%rbp
  8032c2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032c9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032d0:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032d7:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032de:	be 00 00 00 00       	mov    $0x0,%esi
  8032e3:	48 89 c7             	mov    %rax,%rdi
  8032e6:	48 b8 83 2e 80 00 00 	movabs $0x802e83,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f9:	79 28                	jns    803323 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fe:	89 c6                	mov    %eax,%esi
  803300:	48 bf c2 4b 80 00 00 	movabs $0x804bc2,%rdi
  803307:	00 00 00 
  80330a:	b8 00 00 00 00       	mov    $0x0,%eax
  80330f:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803316:	00 00 00 
  803319:	ff d2                	callq  *%rdx
		return fd_src;
  80331b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331e:	e9 74 01 00 00       	jmpq   803497 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803323:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80332a:	be 01 01 00 00       	mov    $0x101,%esi
  80332f:	48 89 c7             	mov    %rax,%rdi
  803332:	48 b8 83 2e 80 00 00 	movabs $0x802e83,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
  80333e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803341:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803345:	79 39                	jns    803380 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80334a:	89 c6                	mov    %eax,%esi
  80334c:	48 bf d8 4b 80 00 00 	movabs $0x804bd8,%rdi
  803353:	00 00 00 
  803356:	b8 00 00 00 00       	mov    $0x0,%eax
  80335b:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803362:	00 00 00 
  803365:	ff d2                	callq  *%rdx
		close(fd_src);
  803367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336a:	89 c7                	mov    %eax,%edi
  80336c:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
		return fd_dest;
  803378:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337b:	e9 17 01 00 00       	jmpq   803497 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803380:	eb 74                	jmp    8033f6 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803385:	48 63 d0             	movslq %eax,%rdx
  803388:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80338f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803392:	48 89 ce             	mov    %rcx,%rsi
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 2a 2b 80 00 00 	movabs $0x802b2a,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
  8033a3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033aa:	79 4a                	jns    8033f6 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033af:	89 c6                	mov    %eax,%esi
  8033b1:	48 bf f2 4b 80 00 00 	movabs $0x804bf2,%rdi
  8033b8:	00 00 00 
  8033bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c0:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  8033c7:	00 00 00 
  8033ca:	ff d2                	callq  *%rdx
			close(fd_src);
  8033cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cf:	89 c7                	mov    %eax,%edi
  8033d1:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
			close(fd_dest);
  8033dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
			return write_size;
  8033ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033f1:	e9 a1 00 00 00       	jmpq   803497 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033f6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	ba 00 02 00 00       	mov    $0x200,%edx
  803405:	48 89 ce             	mov    %rcx,%rsi
  803408:	89 c7                	mov    %eax,%edi
  80340a:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax
  803416:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80341d:	0f 8f 5f ff ff ff    	jg     803382 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803423:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803427:	79 47                	jns    803470 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803429:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80342c:	89 c6                	mov    %eax,%esi
  80342e:	48 bf 05 4c 80 00 00 	movabs $0x804c05,%rdi
  803435:	00 00 00 
  803438:	b8 00 00 00 00       	mov    $0x0,%eax
  80343d:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803444:	00 00 00 
  803447:	ff d2                	callq  *%rdx
		close(fd_src);
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
		close(fd_dest);
  80345a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80345d:	89 c7                	mov    %eax,%edi
  80345f:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
		return read_size;
  80346b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80346e:	eb 27                	jmp    803497 <copy+0x1d9>
	}
	close(fd_src);
  803470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
	close(fd_dest);
  803481:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803484:	89 c7                	mov    %eax,%edi
  803486:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
	return 0;
  803492:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803497:	c9                   	leaveq 
  803498:	c3                   	retq   

0000000000803499 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803499:	55                   	push   %rbp
  80349a:	48 89 e5             	mov    %rsp,%rbp
  80349d:	53                   	push   %rbx
  80349e:	48 83 ec 38          	sub    $0x38,%rsp
  8034a2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034a6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034aa:	48 89 c7             	mov    %rax,%rdi
  8034ad:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  8034b4:	00 00 00 
  8034b7:	ff d0                	callq  *%rax
  8034b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034c0:	0f 88 bf 01 00 00    	js     803685 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ca:	ba 07 04 00 00       	mov    $0x407,%edx
  8034cf:	48 89 c6             	mov    %rax,%rsi
  8034d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d7:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
  8034e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ea:	0f 88 95 01 00 00    	js     803685 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034f0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
  803503:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803506:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80350a:	0f 88 5d 01 00 00    	js     80366d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803510:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803514:	ba 07 04 00 00       	mov    $0x407,%edx
  803519:	48 89 c6             	mov    %rax,%rsi
  80351c:	bf 00 00 00 00       	mov    $0x0,%edi
  803521:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803530:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803534:	0f 88 33 01 00 00    	js     80366d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80353a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353e:	48 89 c7             	mov    %rax,%rdi
  803541:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  803548:	00 00 00 
  80354b:	ff d0                	callq  *%rax
  80354d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803551:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803555:	ba 07 04 00 00       	mov    $0x407,%edx
  80355a:	48 89 c6             	mov    %rax,%rsi
  80355d:	bf 00 00 00 00       	mov    $0x0,%edi
  803562:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
  80356e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803571:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803575:	79 05                	jns    80357c <pipe+0xe3>
		goto err2;
  803577:	e9 d9 00 00 00       	jmpq   803655 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80357c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803580:	48 89 c7             	mov    %rax,%rdi
  803583:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	48 89 c2             	mov    %rax,%rdx
  803592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803596:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80359c:	48 89 d1             	mov    %rdx,%rcx
  80359f:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a4:	48 89 c6             	mov    %rax,%rsi
  8035a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ac:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
  8035b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035bf:	79 1b                	jns    8035dc <pipe+0x143>
		goto err3;
  8035c1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c6:	48 89 c6             	mov    %rax,%rsi
  8035c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ce:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
  8035da:	eb 79                	jmp    803655 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035e7:	00 00 00 
  8035ea:	8b 12                	mov    (%rdx),%edx
  8035ec:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8035f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035fd:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803604:	00 00 00 
  803607:	8b 12                	mov    (%rdx),%edx
  803609:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80360b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361a:	48 89 c7             	mov    %rax,%rdi
  80361d:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	89 c2                	mov    %eax,%edx
  80362b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80362f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803631:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803635:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803639:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80363d:	48 89 c7             	mov    %rax,%rdi
  803640:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80364e:	b8 00 00 00 00       	mov    $0x0,%eax
  803653:	eb 33                	jmp    803688 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803659:	48 89 c6             	mov    %rax,%rsi
  80365c:	bf 00 00 00 00       	mov    $0x0,%edi
  803661:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803668:	00 00 00 
  80366b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80366d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803671:	48 89 c6             	mov    %rax,%rsi
  803674:	bf 00 00 00 00       	mov    $0x0,%edi
  803679:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803680:	00 00 00 
  803683:	ff d0                	callq  *%rax
err:
	return r;
  803685:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803688:	48 83 c4 38          	add    $0x38,%rsp
  80368c:	5b                   	pop    %rbx
  80368d:	5d                   	pop    %rbp
  80368e:	c3                   	retq   

000000000080368f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80368f:	55                   	push   %rbp
  803690:	48 89 e5             	mov    %rsp,%rbp
  803693:	53                   	push   %rbx
  803694:	48 83 ec 28          	sub    $0x28,%rsp
  803698:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80369c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036a7:	00 00 00 
  8036aa:	48 8b 00             	mov    (%rax),%rax
  8036ad:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ba:	48 89 c7             	mov    %rax,%rdi
  8036bd:	48 b8 92 43 80 00 00 	movabs $0x804392,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	89 c3                	mov    %eax,%ebx
  8036cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036cf:	48 89 c7             	mov    %rax,%rdi
  8036d2:	48 b8 92 43 80 00 00 	movabs $0x804392,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
  8036de:	39 c3                	cmp    %eax,%ebx
  8036e0:	0f 94 c0             	sete   %al
  8036e3:	0f b6 c0             	movzbl %al,%eax
  8036e6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036f0:	00 00 00 
  8036f3:	48 8b 00             	mov    (%rax),%rax
  8036f6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803702:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803705:	75 05                	jne    80370c <_pipeisclosed+0x7d>
			return ret;
  803707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80370a:	eb 4f                	jmp    80375b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80370c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80370f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803712:	74 42                	je     803756 <_pipeisclosed+0xc7>
  803714:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803718:	75 3c                	jne    803756 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80371a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803721:	00 00 00 
  803724:	48 8b 00             	mov    (%rax),%rax
  803727:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80372d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803733:	89 c6                	mov    %eax,%esi
  803735:	48 bf 25 4c 80 00 00 	movabs $0x804c25,%rdi
  80373c:	00 00 00 
  80373f:	b8 00 00 00 00       	mov    $0x0,%eax
  803744:	49 b8 02 06 80 00 00 	movabs $0x800602,%r8
  80374b:	00 00 00 
  80374e:	41 ff d0             	callq  *%r8
	}
  803751:	e9 4a ff ff ff       	jmpq   8036a0 <_pipeisclosed+0x11>
  803756:	e9 45 ff ff ff       	jmpq   8036a0 <_pipeisclosed+0x11>
}
  80375b:	48 83 c4 28          	add    $0x28,%rsp
  80375f:	5b                   	pop    %rbx
  803760:	5d                   	pop    %rbp
  803761:	c3                   	retq   

0000000000803762 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803762:	55                   	push   %rbp
  803763:	48 89 e5             	mov    %rsp,%rbp
  803766:	48 83 ec 30          	sub    $0x30,%rsp
  80376a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80376d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803771:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803774:	48 89 d6             	mov    %rdx,%rsi
  803777:	89 c7                	mov    %eax,%edi
  803779:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
  803785:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803788:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378c:	79 05                	jns    803793 <pipeisclosed+0x31>
		return r;
  80378e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803791:	eb 31                	jmp    8037c4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803797:	48 89 c7             	mov    %rax,%rdi
  80379a:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
  8037a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b2:	48 89 d6             	mov    %rdx,%rsi
  8037b5:	48 89 c7             	mov    %rax,%rdi
  8037b8:	48 b8 8f 36 80 00 00 	movabs $0x80368f,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
}
  8037c4:	c9                   	leaveq 
  8037c5:	c3                   	retq   

00000000008037c6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037c6:	55                   	push   %rbp
  8037c7:	48 89 e5             	mov    %rsp,%rbp
  8037ca:	48 83 ec 40          	sub    $0x40,%rsp
  8037ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
  8037ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037f9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803800:	00 
  803801:	e9 92 00 00 00       	jmpq   803898 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803806:	eb 41                	jmp    803849 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803808:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80380d:	74 09                	je     803818 <devpipe_read+0x52>
				return i;
  80380f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803813:	e9 92 00 00 00       	jmpq   8038aa <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803818:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80381c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803820:	48 89 d6             	mov    %rdx,%rsi
  803823:	48 89 c7             	mov    %rax,%rdi
  803826:	48 b8 8f 36 80 00 00 	movabs $0x80368f,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 07                	je     80383d <devpipe_read+0x77>
				return 0;
  803836:	b8 00 00 00 00       	mov    $0x0,%eax
  80383b:	eb 6d                	jmp    8038aa <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80383d:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384d:	8b 10                	mov    (%rax),%edx
  80384f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803853:	8b 40 04             	mov    0x4(%rax),%eax
  803856:	39 c2                	cmp    %eax,%edx
  803858:	74 ae                	je     803808 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80385a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803862:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386a:	8b 00                	mov    (%rax),%eax
  80386c:	99                   	cltd   
  80386d:	c1 ea 1b             	shr    $0x1b,%edx
  803870:	01 d0                	add    %edx,%eax
  803872:	83 e0 1f             	and    $0x1f,%eax
  803875:	29 d0                	sub    %edx,%eax
  803877:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80387b:	48 98                	cltq   
  80387d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803882:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803888:	8b 00                	mov    (%rax),%eax
  80388a:	8d 50 01             	lea    0x1(%rax),%edx
  80388d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803891:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803893:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038a0:	0f 82 60 ff ff ff    	jb     803806 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038aa:	c9                   	leaveq 
  8038ab:	c3                   	retq   

00000000008038ac <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038ac:	55                   	push   %rbp
  8038ad:	48 89 e5             	mov    %rsp,%rbp
  8038b0:	48 83 ec 40          	sub    $0x40,%rsp
  8038b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038bc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c4:	48 89 c7             	mov    %rax,%rdi
  8038c7:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
  8038d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038df:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038e6:	00 
  8038e7:	e9 8e 00 00 00       	jmpq   80397a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038ec:	eb 31                	jmp    80391f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f6:	48 89 d6             	mov    %rdx,%rsi
  8038f9:	48 89 c7             	mov    %rax,%rdi
  8038fc:	48 b8 8f 36 80 00 00 	movabs $0x80368f,%rax
  803903:	00 00 00 
  803906:	ff d0                	callq  *%rax
  803908:	85 c0                	test   %eax,%eax
  80390a:	74 07                	je     803913 <devpipe_write+0x67>
				return 0;
  80390c:	b8 00 00 00 00       	mov    $0x0,%eax
  803911:	eb 79                	jmp    80398c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803913:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  80391a:	00 00 00 
  80391d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80391f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803923:	8b 40 04             	mov    0x4(%rax),%eax
  803926:	48 63 d0             	movslq %eax,%rdx
  803929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392d:	8b 00                	mov    (%rax),%eax
  80392f:	48 98                	cltq   
  803931:	48 83 c0 20          	add    $0x20,%rax
  803935:	48 39 c2             	cmp    %rax,%rdx
  803938:	73 b4                	jae    8038ee <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80393a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393e:	8b 40 04             	mov    0x4(%rax),%eax
  803941:	99                   	cltd   
  803942:	c1 ea 1b             	shr    $0x1b,%edx
  803945:	01 d0                	add    %edx,%eax
  803947:	83 e0 1f             	and    $0x1f,%eax
  80394a:	29 d0                	sub    %edx,%eax
  80394c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803950:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803954:	48 01 ca             	add    %rcx,%rdx
  803957:	0f b6 0a             	movzbl (%rdx),%ecx
  80395a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80395e:	48 98                	cltq   
  803960:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803968:	8b 40 04             	mov    0x4(%rax),%eax
  80396b:	8d 50 01             	lea    0x1(%rax),%edx
  80396e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803972:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803975:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80397a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803982:	0f 82 64 ff ff ff    	jb     8038ec <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803988:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80398c:	c9                   	leaveq 
  80398d:	c3                   	retq   

000000000080398e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80398e:	55                   	push   %rbp
  80398f:	48 89 e5             	mov    %rsp,%rbp
  803992:	48 83 ec 20          	sub    $0x20,%rsp
  803996:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80399a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80399e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a2:	48 89 c7             	mov    %rax,%rdi
  8039a5:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
  8039b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b9:	48 be 38 4c 80 00 00 	movabs $0x804c38,%rsi
  8039c0:	00 00 00 
  8039c3:	48 89 c7             	mov    %rax,%rdi
  8039c6:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d6:	8b 50 04             	mov    0x4(%rax),%edx
  8039d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039dd:	8b 00                	mov    (%rax),%eax
  8039df:	29 c2                	sub    %eax,%edx
  8039e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ef:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039f6:	00 00 00 
	stat->st_dev = &devpipe;
  8039f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039fd:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a04:	00 00 00 
  803a07:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a13:	c9                   	leaveq 
  803a14:	c3                   	retq   

0000000000803a15 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a15:	55                   	push   %rbp
  803a16:	48 89 e5             	mov    %rsp,%rbp
  803a19:	48 83 ec 10          	sub    $0x10,%rsp
  803a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a25:	48 89 c6             	mov    %rax,%rsi
  803a28:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2d:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803a34:	00 00 00 
  803a37:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3d:	48 89 c7             	mov    %rax,%rdi
  803a40:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	48 89 c6             	mov    %rax,%rsi
  803a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a54:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803a5b:	00 00 00 
  803a5e:	ff d0                	callq  *%rax
}
  803a60:	c9                   	leaveq 
  803a61:	c3                   	retq   

0000000000803a62 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a62:	55                   	push   %rbp
  803a63:	48 89 e5             	mov    %rsp,%rbp
  803a66:	48 83 ec 20          	sub    $0x20,%rsp
  803a6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a70:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a73:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a77:	be 01 00 00 00       	mov    $0x1,%esi
  803a7c:	48 89 c7             	mov    %rax,%rdi
  803a7f:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803a86:	00 00 00 
  803a89:	ff d0                	callq  *%rax
}
  803a8b:	c9                   	leaveq 
  803a8c:	c3                   	retq   

0000000000803a8d <getchar>:

int
getchar(void)
{
  803a8d:	55                   	push   %rbp
  803a8e:	48 89 e5             	mov    %rsp,%rbp
  803a91:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a95:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a99:	ba 01 00 00 00       	mov    $0x1,%edx
  803a9e:	48 89 c6             	mov    %rax,%rsi
  803aa1:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa6:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
  803ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ab5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab9:	79 05                	jns    803ac0 <getchar+0x33>
		return r;
  803abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abe:	eb 14                	jmp    803ad4 <getchar+0x47>
	if (r < 1)
  803ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac4:	7f 07                	jg     803acd <getchar+0x40>
		return -E_EOF;
  803ac6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803acb:	eb 07                	jmp    803ad4 <getchar+0x47>
	return c;
  803acd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ad1:	0f b6 c0             	movzbl %al,%eax
}
  803ad4:	c9                   	leaveq 
  803ad5:	c3                   	retq   

0000000000803ad6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ad6:	55                   	push   %rbp
  803ad7:	48 89 e5             	mov    %rsp,%rbp
  803ada:	48 83 ec 20          	sub    $0x20,%rsp
  803ade:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ae1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ae5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae8:	48 89 d6             	mov    %rdx,%rsi
  803aeb:	89 c7                	mov    %eax,%edi
  803aed:	48 b8 ae 25 80 00 00 	movabs $0x8025ae,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
  803af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b00:	79 05                	jns    803b07 <iscons+0x31>
		return r;
  803b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b05:	eb 1a                	jmp    803b21 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	8b 10                	mov    (%rax),%edx
  803b0d:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b14:	00 00 00 
  803b17:	8b 00                	mov    (%rax),%eax
  803b19:	39 c2                	cmp    %eax,%edx
  803b1b:	0f 94 c0             	sete   %al
  803b1e:	0f b6 c0             	movzbl %al,%eax
}
  803b21:	c9                   	leaveq 
  803b22:	c3                   	retq   

0000000000803b23 <opencons>:

int
opencons(void)
{
  803b23:	55                   	push   %rbp
  803b24:	48 89 e5             	mov    %rsp,%rbp
  803b27:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b2b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b2f:	48 89 c7             	mov    %rax,%rdi
  803b32:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b45:	79 05                	jns    803b4c <opencons+0x29>
		return r;
  803b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4a:	eb 5b                	jmp    803ba7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b50:	ba 07 04 00 00       	mov    $0x407,%edx
  803b55:	48 89 c6             	mov    %rax,%rsi
  803b58:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5d:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b70:	79 05                	jns    803b77 <opencons+0x54>
		return r;
  803b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b75:	eb 30                	jmp    803ba7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7b:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803b82:	00 00 00 
  803b85:	8b 12                	mov    (%rdx),%edx
  803b87:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b98:	48 89 c7             	mov    %rax,%rdi
  803b9b:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	callq  *%rax
}
  803ba7:	c9                   	leaveq 
  803ba8:	c3                   	retq   

0000000000803ba9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ba9:	55                   	push   %rbp
  803baa:	48 89 e5             	mov    %rsp,%rbp
  803bad:	48 83 ec 30          	sub    $0x30,%rsp
  803bb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bbd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bc2:	75 07                	jne    803bcb <devcons_read+0x22>
		return 0;
  803bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc9:	eb 4b                	jmp    803c16 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bcb:	eb 0c                	jmp    803bd9 <devcons_read+0x30>
		sys_yield();
  803bcd:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bd9:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bec:	74 df                	je     803bcd <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803bee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf2:	79 05                	jns    803bf9 <devcons_read+0x50>
		return c;
  803bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf7:	eb 1d                	jmp    803c16 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bf9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bfd:	75 07                	jne    803c06 <devcons_read+0x5d>
		return 0;
  803bff:	b8 00 00 00 00       	mov    $0x0,%eax
  803c04:	eb 10                	jmp    803c16 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c09:	89 c2                	mov    %eax,%edx
  803c0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0f:	88 10                	mov    %dl,(%rax)
	return 1;
  803c11:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c16:	c9                   	leaveq 
  803c17:	c3                   	retq   

0000000000803c18 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c18:	55                   	push   %rbp
  803c19:	48 89 e5             	mov    %rsp,%rbp
  803c1c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c23:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c2a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c31:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c3f:	eb 76                	jmp    803cb7 <devcons_write+0x9f>
		m = n - tot;
  803c41:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c48:	89 c2                	mov    %eax,%edx
  803c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4d:	29 c2                	sub    %eax,%edx
  803c4f:	89 d0                	mov    %edx,%eax
  803c51:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c57:	83 f8 7f             	cmp    $0x7f,%eax
  803c5a:	76 07                	jbe    803c63 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c5c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c66:	48 63 d0             	movslq %eax,%rdx
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	48 63 c8             	movslq %eax,%rcx
  803c6f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c76:	48 01 c1             	add    %rax,%rcx
  803c79:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c80:	48 89 ce             	mov    %rcx,%rsi
  803c83:	48 89 c7             	mov    %rax,%rdi
  803c86:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  803c8d:	00 00 00 
  803c90:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c95:	48 63 d0             	movslq %eax,%rdx
  803c98:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c9f:	48 89 d6             	mov    %rdx,%rsi
  803ca2:	48 89 c7             	mov    %rax,%rdi
  803ca5:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb4:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	48 98                	cltq   
  803cbc:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cc3:	0f 82 78 ff ff ff    	jb     803c41 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ccc:	c9                   	leaveq 
  803ccd:	c3                   	retq   

0000000000803cce <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cce:	55                   	push   %rbp
  803ccf:	48 89 e5             	mov    %rsp,%rbp
  803cd2:	48 83 ec 08          	sub    $0x8,%rsp
  803cd6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cdf:	c9                   	leaveq 
  803ce0:	c3                   	retq   

0000000000803ce1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 10          	sub    $0x10,%rsp
  803ce9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ced:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf5:	48 be 44 4c 80 00 00 	movabs $0x804c44,%rsi
  803cfc:	00 00 00 
  803cff:	48 89 c7             	mov    %rax,%rdi
  803d02:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803d09:	00 00 00 
  803d0c:	ff d0                	callq  *%rax
	return 0;
  803d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d13:	c9                   	leaveq 
  803d14:	c3                   	retq   

0000000000803d15 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d15:	55                   	push   %rbp
  803d16:	48 89 e5             	mov    %rsp,%rbp
  803d19:	48 83 ec 10          	sub    $0x10,%rsp
  803d1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803d21:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d28:	00 00 00 
  803d2b:	48 8b 00             	mov    (%rax),%rax
  803d2e:	48 85 c0             	test   %rax,%rax
  803d31:	0f 85 84 00 00 00    	jne    803dbb <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803d37:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d3e:	00 00 00 
  803d41:	48 8b 00             	mov    (%rax),%rax
  803d44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d4a:	ba 07 00 00 00       	mov    $0x7,%edx
  803d4f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d54:	89 c7                	mov    %eax,%edi
  803d56:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  803d5d:	00 00 00 
  803d60:	ff d0                	callq  *%rax
  803d62:	85 c0                	test   %eax,%eax
  803d64:	79 2a                	jns    803d90 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803d66:	48 ba 50 4c 80 00 00 	movabs $0x804c50,%rdx
  803d6d:	00 00 00 
  803d70:	be 23 00 00 00       	mov    $0x23,%esi
  803d75:	48 bf 77 4c 80 00 00 	movabs $0x804c77,%rdi
  803d7c:	00 00 00 
  803d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d84:	48 b9 c9 03 80 00 00 	movabs $0x8003c9,%rcx
  803d8b:	00 00 00 
  803d8e:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803d90:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d97:	00 00 00 
  803d9a:	48 8b 00             	mov    (%rax),%rax
  803d9d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803da3:	48 be ce 3d 80 00 00 	movabs $0x803dce,%rsi
  803daa:	00 00 00 
  803dad:	89 c7                	mov    %eax,%edi
  803daf:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803dbb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803dc2:	00 00 00 
  803dc5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803dc9:	48 89 10             	mov    %rdx,(%rax)
}
  803dcc:	c9                   	leaveq 
  803dcd:	c3                   	retq   

0000000000803dce <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803dce:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803dd1:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803dd8:	00 00 00 
call *%rax
  803ddb:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803ddd:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803de4:	00 
movq 152(%rsp), %rcx  //Load RSP
  803de5:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803dec:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803ded:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803df1:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803df4:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803dfb:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803dfc:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803e00:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e04:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e09:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e0e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e13:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e18:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e1d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e22:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e27:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e2c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e31:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e36:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e3b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e40:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e45:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e4a:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803e4e:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803e52:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803e53:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803e54:	c3                   	retq   

0000000000803e55 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e55:	55                   	push   %rbp
  803e56:	48 89 e5             	mov    %rsp,%rbp
  803e59:	48 83 ec 30          	sub    $0x30,%rsp
  803e5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e70:	00 00 00 
  803e73:	48 8b 00             	mov    (%rax),%rax
  803e76:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e7c:	85 c0                	test   %eax,%eax
  803e7e:	75 34                	jne    803eb4 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803e80:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  803e87:	00 00 00 
  803e8a:	ff d0                	callq  *%rax
  803e8c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e91:	48 98                	cltq   
  803e93:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803e9a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ea1:	00 00 00 
  803ea4:	48 01 c2             	add    %rax,%rdx
  803ea7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eae:	00 00 00 
  803eb1:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803eb4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eb9:	75 0e                	jne    803ec9 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803ebb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ec2:	00 00 00 
  803ec5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ec9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ecd:	48 89 c7             	mov    %rax,%rdi
  803ed0:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  803ed7:	00 00 00 
  803eda:	ff d0                	callq  *%rax
  803edc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803edf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee3:	79 19                	jns    803efe <ipc_recv+0xa9>
		*from_env_store = 0;
  803ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efc:	eb 53                	jmp    803f51 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803efe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f03:	74 19                	je     803f1e <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803f05:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f0c:	00 00 00 
  803f0f:	48 8b 00             	mov    (%rax),%rax
  803f12:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f1e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f23:	74 19                	je     803f3e <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803f25:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f2c:	00 00 00 
  803f2f:	48 8b 00             	mov    (%rax),%rax
  803f32:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f3c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f3e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f45:	00 00 00 
  803f48:	48 8b 00             	mov    (%rax),%rax
  803f4b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f51:	c9                   	leaveq 
  803f52:	c3                   	retq   

0000000000803f53 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f53:	55                   	push   %rbp
  803f54:	48 89 e5             	mov    %rsp,%rbp
  803f57:	48 83 ec 30          	sub    $0x30,%rsp
  803f5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f5e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f61:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f65:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f6d:	75 0e                	jne    803f7d <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f6f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f76:	00 00 00 
  803f79:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803f7d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f80:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8a:	89 c7                	mov    %eax,%edi
  803f8c:	48 b8 ba 1c 80 00 00 	movabs $0x801cba,%rax
  803f93:	00 00 00 
  803f96:	ff d0                	callq  *%rax
  803f98:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803f9b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f9f:	75 0c                	jne    803fad <ipc_send+0x5a>
			sys_yield();
  803fa1:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  803fa8:	00 00 00 
  803fab:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803fad:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fb1:	74 ca                	je     803f7d <ipc_send+0x2a>
	if(result != 0)
  803fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb7:	74 20                	je     803fd9 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fbc:	89 c6                	mov    %eax,%esi
  803fbe:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  803fc5:	00 00 00 
  803fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcd:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  803fd4:	00 00 00 
  803fd7:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803fd9:	c9                   	leaveq 
  803fda:	c3                   	retq   

0000000000803fdb <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803fdb:	55                   	push   %rbp
  803fdc:	48 89 e5             	mov    %rsp,%rbp
  803fdf:	53                   	push   %rbx
  803fe0:	48 83 ec 58          	sub    $0x58,%rsp
  803fe4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803fe8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803ff0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803ff7:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803ffe:	00 
  803fff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804003:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804007:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80400f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804013:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804017:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80401b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80401f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804023:	48 c1 e8 27          	shr    $0x27,%rax
  804027:	48 89 c2             	mov    %rax,%rdx
  80402a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804031:	01 00 00 
  804034:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804038:	83 e0 01             	and    $0x1,%eax
  80403b:	48 85 c0             	test   %rax,%rax
  80403e:	0f 85 91 00 00 00    	jne    8040d5 <ipc_host_recv+0xfa>
  804044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804048:	48 c1 e8 1e          	shr    $0x1e,%rax
  80404c:	48 89 c2             	mov    %rax,%rdx
  80404f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804056:	01 00 00 
  804059:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80405d:	83 e0 01             	and    $0x1,%eax
  804060:	48 85 c0             	test   %rax,%rax
  804063:	74 70                	je     8040d5 <ipc_host_recv+0xfa>
  804065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804069:	48 c1 e8 15          	shr    $0x15,%rax
  80406d:	48 89 c2             	mov    %rax,%rdx
  804070:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804077:	01 00 00 
  80407a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80407e:	83 e0 01             	and    $0x1,%eax
  804081:	48 85 c0             	test   %rax,%rax
  804084:	74 4f                	je     8040d5 <ipc_host_recv+0xfa>
  804086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80408a:	48 c1 e8 0c          	shr    $0xc,%rax
  80408e:	48 89 c2             	mov    %rax,%rdx
  804091:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804098:	01 00 00 
  80409b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80409f:	83 e0 01             	and    $0x1,%eax
  8040a2:	48 85 c0             	test   %rax,%rax
  8040a5:	74 2e                	je     8040d5 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8040b0:	48 89 c6             	mov    %rax,%rsi
  8040b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8040b8:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8040c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8040cb:	79 08                	jns    8040d5 <ipc_host_recv+0xfa>
	    	return result;
  8040cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8040d0:	e9 84 00 00 00       	jmpq   804159 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8040d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8040dd:	48 89 c2             	mov    %rax,%rdx
  8040e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040e7:	01 00 00 
  8040ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ee:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8040f4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8040f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8040fd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804101:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804105:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  804109:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80410d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804111:	4c 89 c3             	mov    %r8,%rbx
  804114:	0f 01 c1             	vmcall 
  804117:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  80411a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80411e:	7e 36                	jle    804156 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  804120:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804123:	41 89 c0             	mov    %eax,%r8d
  804126:	b9 03 00 00 00       	mov    $0x3,%ecx
  80412b:	48 ba a0 4c 80 00 00 	movabs $0x804ca0,%rdx
  804132:	00 00 00 
  804135:	be 67 00 00 00       	mov    $0x67,%esi
  80413a:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  804141:	00 00 00 
  804144:	b8 00 00 00 00       	mov    $0x0,%eax
  804149:	49 b9 c9 03 80 00 00 	movabs $0x8003c9,%r9
  804150:	00 00 00 
  804153:	41 ff d1             	callq  *%r9
	return result;
  804156:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804159:	48 83 c4 58          	add    $0x58,%rsp
  80415d:	5b                   	pop    %rbx
  80415e:	5d                   	pop    %rbp
  80415f:	c3                   	retq   

0000000000804160 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804160:	55                   	push   %rbp
  804161:	48 89 e5             	mov    %rsp,%rbp
  804164:	53                   	push   %rbx
  804165:	48 83 ec 68          	sub    $0x68,%rsp
  804169:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80416c:	89 75 a8             	mov    %esi,-0x58(%rbp)
  80416f:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804173:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804176:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80417a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80417e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804185:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80418c:	00 
  80418d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804191:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804195:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804199:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80419d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041a5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041a9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8041ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041b1:	48 c1 e8 27          	shr    $0x27,%rax
  8041b5:	48 89 c2             	mov    %rax,%rdx
  8041b8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8041bf:	01 00 00 
  8041c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041c6:	83 e0 01             	and    $0x1,%eax
  8041c9:	48 85 c0             	test   %rax,%rax
  8041cc:	0f 85 88 00 00 00    	jne    80425a <ipc_host_send+0xfa>
  8041d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041d6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8041da:	48 89 c2             	mov    %rax,%rdx
  8041dd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041e4:	01 00 00 
  8041e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041eb:	83 e0 01             	and    $0x1,%eax
  8041ee:	48 85 c0             	test   %rax,%rax
  8041f1:	74 67                	je     80425a <ipc_host_send+0xfa>
  8041f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f7:	48 c1 e8 15          	shr    $0x15,%rax
  8041fb:	48 89 c2             	mov    %rax,%rdx
  8041fe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804205:	01 00 00 
  804208:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80420c:	83 e0 01             	and    $0x1,%eax
  80420f:	48 85 c0             	test   %rax,%rax
  804212:	74 46                	je     80425a <ipc_host_send+0xfa>
  804214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804218:	48 c1 e8 0c          	shr    $0xc,%rax
  80421c:	48 89 c2             	mov    %rax,%rdx
  80421f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804226:	01 00 00 
  804229:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80422d:	83 e0 01             	and    $0x1,%eax
  804230:	48 85 c0             	test   %rax,%rax
  804233:	74 25                	je     80425a <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804235:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804239:	48 c1 e8 0c          	shr    $0xc,%rax
  80423d:	48 89 c2             	mov    %rax,%rdx
  804240:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804247:	01 00 00 
  80424a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80424e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804254:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804258:	eb 0e                	jmp    804268 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80425a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804261:	00 00 00 
  804264:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80426c:	48 89 c6             	mov    %rax,%rsi
  80426f:	48 bf d7 4c 80 00 00 	movabs $0x804cd7,%rdi
  804276:	00 00 00 
  804279:	b8 00 00 00 00       	mov    $0x0,%eax
  80427e:	48 ba 02 06 80 00 00 	movabs $0x800602,%rdx
  804285:	00 00 00 
  804288:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80428a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80428d:	48 98                	cltq   
  80428f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804293:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804296:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80429a:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80429d:	48 98                	cltq   
  80429f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8042a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8042a8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8042ac:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8042b0:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8042b4:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8042b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8042bc:	4c 89 c3             	mov    %r8,%rbx
  8042bf:	0f 01 c1             	vmcall 
  8042c2:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  8042c5:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8042c9:	75 0c                	jne    8042d7 <ipc_host_send+0x177>
			sys_yield();
  8042cb:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  8042d2:	00 00 00 
  8042d5:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8042d7:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8042db:	74 c6                	je     8042a3 <ipc_host_send+0x143>
	
	if(result !=0)
  8042dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8042e1:	74 36                	je     804319 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  8042e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042e6:	41 89 c0             	mov    %eax,%r8d
  8042e9:	b9 02 00 00 00       	mov    $0x2,%ecx
  8042ee:	48 ba a0 4c 80 00 00 	movabs $0x804ca0,%rdx
  8042f5:	00 00 00 
  8042f8:	be 94 00 00 00       	mov    $0x94,%esi
  8042fd:	48 bf cd 4c 80 00 00 	movabs $0x804ccd,%rdi
  804304:	00 00 00 
  804307:	b8 00 00 00 00       	mov    $0x0,%eax
  80430c:	49 b9 c9 03 80 00 00 	movabs $0x8003c9,%r9
  804313:	00 00 00 
  804316:	41 ff d1             	callq  *%r9
}
  804319:	48 83 c4 68          	add    $0x68,%rsp
  80431d:	5b                   	pop    %rbx
  80431e:	5d                   	pop    %rbp
  80431f:	c3                   	retq   

0000000000804320 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804320:	55                   	push   %rbp
  804321:	48 89 e5             	mov    %rsp,%rbp
  804324:	48 83 ec 14          	sub    $0x14,%rsp
  804328:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80432b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804332:	eb 4e                	jmp    804382 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804334:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80433b:	00 00 00 
  80433e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804341:	48 98                	cltq   
  804343:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80434a:	48 01 d0             	add    %rdx,%rax
  80434d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804353:	8b 00                	mov    (%rax),%eax
  804355:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804358:	75 24                	jne    80437e <ipc_find_env+0x5e>
			return envs[i].env_id;
  80435a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804361:	00 00 00 
  804364:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804367:	48 98                	cltq   
  804369:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804370:	48 01 d0             	add    %rdx,%rax
  804373:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804379:	8b 40 08             	mov    0x8(%rax),%eax
  80437c:	eb 12                	jmp    804390 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80437e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804382:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804389:	7e a9                	jle    804334 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80438b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804390:	c9                   	leaveq 
  804391:	c3                   	retq   

0000000000804392 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804392:	55                   	push   %rbp
  804393:	48 89 e5             	mov    %rsp,%rbp
  804396:	48 83 ec 18          	sub    $0x18,%rsp
  80439a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80439e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043a2:	48 c1 e8 15          	shr    $0x15,%rax
  8043a6:	48 89 c2             	mov    %rax,%rdx
  8043a9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043b0:	01 00 00 
  8043b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043b7:	83 e0 01             	and    $0x1,%eax
  8043ba:	48 85 c0             	test   %rax,%rax
  8043bd:	75 07                	jne    8043c6 <pageref+0x34>
		return 0;
  8043bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c4:	eb 53                	jmp    804419 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8043ce:	48 89 c2             	mov    %rax,%rdx
  8043d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043d8:	01 00 00 
  8043db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e7:	83 e0 01             	and    $0x1,%eax
  8043ea:	48 85 c0             	test   %rax,%rax
  8043ed:	75 07                	jne    8043f6 <pageref+0x64>
		return 0;
  8043ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f4:	eb 23                	jmp    804419 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8043fe:	48 89 c2             	mov    %rax,%rdx
  804401:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804408:	00 00 00 
  80440b:	48 c1 e2 04          	shl    $0x4,%rdx
  80440f:	48 01 d0             	add    %rdx,%rax
  804412:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804416:	0f b7 c0             	movzwl %ax,%eax
}
  804419:	c9                   	leaveq 
  80441a:	c3                   	retq   
