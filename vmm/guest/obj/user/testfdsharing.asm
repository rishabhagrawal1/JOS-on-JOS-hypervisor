
vmm/guest/obj/user/testfdsharing:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf e0 44 80 00 00 	movabs $0x8044e0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 9b 2e 80 00 00 	movabs $0x802e9b,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba e5 44 80 00 00 	movabs $0x8044e5,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 37 22 80 00 00 	movabs $0x802237,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba 12 45 80 00 00 	movabs $0x804512,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 3e 16 80 00 00 	movabs $0x80163e,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 98 45 80 00 00 	movabs $0x804598,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf ce 45 80 00 00 	movabs $0x8045ce,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 be 03 80 00 00 	movabs $0x8003be,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 cd 2a 80 00 00 	movabs $0x802acd,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba e8 45 80 00 00 	movabs $0x8045e8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf 0b 46 80 00 00 	movabs $0x80460b,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80034a:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035b:	48 98                	cltq   
  80035d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800364:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80036b:	00 00 00 
  80036e:	48 01 c2             	add    %rax,%rdx
  800371:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800378:	00 00 00 
  80037b:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800382:	7e 14                	jle    800398 <libmain+0x5d>
		binaryname = argv[0];
  800384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800388:	48 8b 10             	mov    (%rax),%rdx
  80038b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800392:	00 00 00 
  800395:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800398:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039f:	48 89 d6             	mov    %rdx,%rsi
  8003a2:	89 c7                	mov    %eax,%edi
  8003a4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003b0:	48 b8 be 03 80 00 00 	movabs $0x8003be,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
}
  8003bc:	c9                   	leaveq 
  8003bd:	c3                   	retq   

00000000008003be <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003be:	55                   	push   %rbp
  8003bf:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003c2:	48 b8 21 28 80 00 00 	movabs $0x802821,%rax
  8003c9:	00 00 00 
  8003cc:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d3:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  8003da:	00 00 00 
  8003dd:	ff d0                	callq  *%rax

}
  8003df:	5d                   	pop    %rbp
  8003e0:	c3                   	retq   

00000000008003e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e1:	55                   	push   %rbp
  8003e2:	48 89 e5             	mov    %rsp,%rbp
  8003e5:	53                   	push   %rbx
  8003e6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003ed:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003fa:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800401:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800408:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80040f:	84 c0                	test   %al,%al
  800411:	74 23                	je     800436 <_panic+0x55>
  800413:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80041a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80041e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800422:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800426:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80042a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80042e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800432:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800436:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80043d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800444:	00 00 00 
  800447:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80044e:	00 00 00 
  800451:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800455:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80045c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800463:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80046a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800471:	00 00 00 
  800474:	48 8b 18             	mov    (%rax),%rbx
  800477:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
  800483:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800489:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800490:	41 89 c8             	mov    %ecx,%r8d
  800493:	48 89 d1             	mov    %rdx,%rcx
  800496:	48 89 da             	mov    %rbx,%rdx
  800499:	89 c6                	mov    %eax,%esi
  80049b:	48 bf 30 46 80 00 00 	movabs $0x804630,%rdi
  8004a2:	00 00 00 
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	49 b9 1a 06 80 00 00 	movabs $0x80061a,%r9
  8004b1:	00 00 00 
  8004b4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004be:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c5:	48 89 d6             	mov    %rdx,%rsi
  8004c8:	48 89 c7             	mov    %rax,%rdi
  8004cb:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
	cprintf("\n");
  8004d7:	48 bf 53 46 80 00 00 	movabs $0x804653,%rdi
  8004de:	00 00 00 
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8004ed:	00 00 00 
  8004f0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004f2:	cc                   	int3   
  8004f3:	eb fd                	jmp    8004f2 <_panic+0x111>

00000000008004f5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004f5:	55                   	push   %rbp
  8004f6:	48 89 e5             	mov    %rsp,%rbp
  8004f9:	48 83 ec 10          	sub    $0x10,%rsp
  8004fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800500:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	8d 48 01             	lea    0x1(%rax),%ecx
  80050d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800511:	89 0a                	mov    %ecx,(%rdx)
  800513:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800516:	89 d1                	mov    %edx,%ecx
  800518:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051c:	48 98                	cltq   
  80051e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800526:	8b 00                	mov    (%rax),%eax
  800528:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052d:	75 2c                	jne    80055b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80052f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	48 98                	cltq   
  800537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053b:	48 83 c2 08          	add    $0x8,%rdx
  80053f:	48 89 c6             	mov    %rax,%rsi
  800542:	48 89 d7             	mov    %rdx,%rdi
  800545:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
        b->idx = 0;
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80055b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055f:	8b 40 04             	mov    0x4(%rax),%eax
  800562:	8d 50 01             	lea    0x1(%rax),%edx
  800565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800569:	89 50 04             	mov    %edx,0x4(%rax)
}
  80056c:	c9                   	leaveq 
  80056d:	c3                   	retq   

000000000080056e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80056e:	55                   	push   %rbp
  80056f:	48 89 e5             	mov    %rsp,%rbp
  800572:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800579:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800580:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800587:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80058e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800595:	48 8b 0a             	mov    (%rdx),%rcx
  800598:	48 89 08             	mov    %rcx,(%rax)
  80059b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005b2:	00 00 00 
    b.cnt = 0;
  8005b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005bc:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005bf:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005c6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005cd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d4:	48 89 c6             	mov    %rax,%rsi
  8005d7:	48 bf f5 04 80 00 00 	movabs $0x8004f5,%rdi
  8005de:	00 00 00 
  8005e1:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005ed:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f3:	48 98                	cltq   
  8005f5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005fc:	48 83 c2 08          	add    $0x8,%rdx
  800600:	48 89 c6             	mov    %rax,%rsi
  800603:	48 89 d7             	mov    %rdx,%rdi
  800606:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800612:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800618:	c9                   	leaveq 
  800619:	c3                   	retq   

000000000080061a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80061a:	55                   	push   %rbp
  80061b:	48 89 e5             	mov    %rsp,%rbp
  80061e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800625:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80062c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800633:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80063a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800641:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800648:	84 c0                	test   %al,%al
  80064a:	74 20                	je     80066c <cprintf+0x52>
  80064c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800650:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800654:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800658:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80065c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800660:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800664:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800668:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80066c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800673:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80067a:	00 00 00 
  80067d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800684:	00 00 00 
  800687:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80068b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800692:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800699:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006a0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006a7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ae:	48 8b 0a             	mov    (%rdx),%rcx
  8006b1:	48 89 08             	mov    %rcx,(%rax)
  8006b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006c4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d2:	48 89 d6             	mov    %rdx,%rsi
  8006d5:	48 89 c7             	mov    %rax,%rdi
  8006d8:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8006df:	00 00 00 
  8006e2:	ff d0                	callq  *%rax
  8006e4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006ea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006f0:	c9                   	leaveq 
  8006f1:	c3                   	retq   

00000000008006f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f2:	55                   	push   %rbp
  8006f3:	48 89 e5             	mov    %rsp,%rbp
  8006f6:	53                   	push   %rbx
  8006f7:	48 83 ec 38          	sub    $0x38,%rsp
  8006fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800703:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800707:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80070a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80070e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800712:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800715:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800719:	77 3b                	ja     800756 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80071e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800722:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	48 f7 f3             	div    %rbx
  800731:	48 89 c2             	mov    %rax,%rdx
  800734:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800737:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80073a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80073e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800742:	41 89 f9             	mov    %edi,%r9d
  800745:	48 89 c7             	mov    %rax,%rdi
  800748:	48 b8 f2 06 80 00 00 	movabs $0x8006f2,%rax
  80074f:	00 00 00 
  800752:	ff d0                	callq  *%rax
  800754:	eb 1e                	jmp    800774 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800756:	eb 12                	jmp    80076a <printnum+0x78>
			putch(padc, putdat);
  800758:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80075c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 89 ce             	mov    %rcx,%rsi
  800766:	89 d7                	mov    %edx,%edi
  800768:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80076a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80076e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800772:	7f e4                	jg     800758 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800774:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	48 f7 f1             	div    %rcx
  800783:	48 89 d0             	mov    %rdx,%rax
  800786:	48 ba 50 48 80 00 00 	movabs $0x804850,%rdx
  80078d:	00 00 00 
  800790:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800794:	0f be d0             	movsbl %al,%edx
  800797:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 89 ce             	mov    %rcx,%rsi
  8007a2:	89 d7                	mov    %edx,%edi
  8007a4:	ff d0                	callq  *%rax
}
  8007a6:	48 83 c4 38          	add    $0x38,%rsp
  8007aa:	5b                   	pop    %rbx
  8007ab:	5d                   	pop    %rbp
  8007ac:	c3                   	retq   

00000000008007ad <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %rbp
  8007ae:	48 89 e5             	mov    %rsp,%rbp
  8007b1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c0:	7e 52                	jle    800814 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	83 f8 30             	cmp    $0x30,%eax
  8007cb:	73 24                	jae    8007f1 <getuint+0x44>
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 c0                	mov    %eax,%eax
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e4:	8b 12                	mov    (%rdx),%edx
  8007e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	89 0a                	mov    %ecx,(%rdx)
  8007ef:	eb 17                	jmp    800808 <getuint+0x5b>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f9:	48 89 d0             	mov    %rdx,%rax
  8007fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800808:	48 8b 00             	mov    (%rax),%rax
  80080b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080f:	e9 a3 00 00 00       	jmpq   8008b7 <getuint+0x10a>
	else if (lflag)
  800814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800818:	74 4f                	je     800869 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	8b 00                	mov    (%rax),%eax
  800820:	83 f8 30             	cmp    $0x30,%eax
  800823:	73 24                	jae    800849 <getuint+0x9c>
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	8b 00                	mov    (%rax),%eax
  800833:	89 c0                	mov    %eax,%eax
  800835:	48 01 d0             	add    %rdx,%rax
  800838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083c:	8b 12                	mov    (%rdx),%edx
  80083e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800841:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800845:	89 0a                	mov    %ecx,(%rdx)
  800847:	eb 17                	jmp    800860 <getuint+0xb3>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800851:	48 89 d0             	mov    %rdx,%rax
  800854:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800858:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800860:	48 8b 00             	mov    (%rax),%rax
  800863:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800867:	eb 4e                	jmp    8008b7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	83 f8 30             	cmp    $0x30,%eax
  800872:	73 24                	jae    800898 <getuint+0xeb>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	8b 00                	mov    (%rax),%eax
  800882:	89 c0                	mov    %eax,%eax
  800884:	48 01 d0             	add    %rdx,%rax
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	8b 12                	mov    (%rdx),%edx
  80088d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800890:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800894:	89 0a                	mov    %ecx,(%rdx)
  800896:	eb 17                	jmp    8008af <getuint+0x102>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a0:	48 89 d0             	mov    %rdx,%rax
  8008a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008af:	8b 00                	mov    (%rax),%eax
  8008b1:	89 c0                	mov    %eax,%eax
  8008b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008bb:	c9                   	leaveq 
  8008bc:	c3                   	retq   

00000000008008bd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008bd:	55                   	push   %rbp
  8008be:	48 89 e5             	mov    %rsp,%rbp
  8008c1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008cc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d0:	7e 52                	jle    800924 <getint+0x67>
		x=va_arg(*ap, long long);
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	83 f8 30             	cmp    $0x30,%eax
  8008db:	73 24                	jae    800901 <getint+0x44>
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	8b 00                	mov    (%rax),%eax
  8008eb:	89 c0                	mov    %eax,%eax
  8008ed:	48 01 d0             	add    %rdx,%rax
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	8b 12                	mov    (%rdx),%edx
  8008f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fd:	89 0a                	mov    %ecx,(%rdx)
  8008ff:	eb 17                	jmp    800918 <getint+0x5b>
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800909:	48 89 d0             	mov    %rdx,%rax
  80090c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800918:	48 8b 00             	mov    (%rax),%rax
  80091b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091f:	e9 a3 00 00 00       	jmpq   8009c7 <getint+0x10a>
	else if (lflag)
  800924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800928:	74 4f                	je     800979 <getint+0xbc>
		x=va_arg(*ap, long);
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	8b 00                	mov    (%rax),%eax
  800930:	83 f8 30             	cmp    $0x30,%eax
  800933:	73 24                	jae    800959 <getint+0x9c>
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	8b 00                	mov    (%rax),%eax
  800943:	89 c0                	mov    %eax,%eax
  800945:	48 01 d0             	add    %rdx,%rax
  800948:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094c:	8b 12                	mov    (%rdx),%edx
  80094e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800951:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800955:	89 0a                	mov    %ecx,(%rdx)
  800957:	eb 17                	jmp    800970 <getint+0xb3>
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800961:	48 89 d0             	mov    %rdx,%rax
  800964:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800970:	48 8b 00             	mov    (%rax),%rax
  800973:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800977:	eb 4e                	jmp    8009c7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	8b 00                	mov    (%rax),%eax
  80097f:	83 f8 30             	cmp    $0x30,%eax
  800982:	73 24                	jae    8009a8 <getint+0xeb>
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	8b 00                	mov    (%rax),%eax
  800992:	89 c0                	mov    %eax,%eax
  800994:	48 01 d0             	add    %rdx,%rax
  800997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099b:	8b 12                	mov    (%rdx),%edx
  80099d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a4:	89 0a                	mov    %ecx,(%rdx)
  8009a6:	eb 17                	jmp    8009bf <getint+0x102>
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b0:	48 89 d0             	mov    %rdx,%rax
  8009b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bf:	8b 00                	mov    (%rax),%eax
  8009c1:	48 98                	cltq   
  8009c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009cb:	c9                   	leaveq 
  8009cc:	c3                   	retq   

00000000008009cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009cd:	55                   	push   %rbp
  8009ce:	48 89 e5             	mov    %rsp,%rbp
  8009d1:	41 54                	push   %r12
  8009d3:	53                   	push   %rbx
  8009d4:	48 83 ec 60          	sub    $0x60,%rsp
  8009d8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009dc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ec:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009f0:	48 8b 0a             	mov    (%rdx),%rcx
  8009f3:	48 89 08             	mov    %rcx,(%rax)
  8009f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a02:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a06:	eb 17                	jmp    800a1f <vprintfmt+0x52>
			if (ch == '\0')
  800a08:	85 db                	test   %ebx,%ebx
  800a0a:	0f 84 cc 04 00 00    	je     800edc <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	48 89 d6             	mov    %rdx,%rsi
  800a1b:	89 df                	mov    %ebx,%edi
  800a1d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a1f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a27:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2b:	0f b6 00             	movzbl (%rax),%eax
  800a2e:	0f b6 d8             	movzbl %al,%ebx
  800a31:	83 fb 25             	cmp    $0x25,%ebx
  800a34:	75 d2                	jne    800a08 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a36:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a3a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a41:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a48:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a4f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a56:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a5e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a62:	0f b6 00             	movzbl (%rax),%eax
  800a65:	0f b6 d8             	movzbl %al,%ebx
  800a68:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a6b:	83 f8 55             	cmp    $0x55,%eax
  800a6e:	0f 87 34 04 00 00    	ja     800ea8 <vprintfmt+0x4db>
  800a74:	89 c0                	mov    %eax,%eax
  800a76:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a7d:	00 
  800a7e:	48 b8 78 48 80 00 00 	movabs $0x804878,%rax
  800a85:	00 00 00 
  800a88:	48 01 d0             	add    %rdx,%rax
  800a8b:	48 8b 00             	mov    (%rax),%rax
  800a8e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a90:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a94:	eb c0                	jmp    800a56 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a96:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a9a:	eb ba                	jmp    800a56 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a9c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aa3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	c1 e0 02             	shl    $0x2,%eax
  800aab:	01 d0                	add    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d8                	add    %ebx,%eax
  800ab1:	83 e8 30             	sub    $0x30,%eax
  800ab4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ab7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800abb:	0f b6 00             	movzbl (%rax),%eax
  800abe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac4:	7e 0c                	jle    800ad2 <vprintfmt+0x105>
  800ac6:	83 fb 39             	cmp    $0x39,%ebx
  800ac9:	7f 07                	jg     800ad2 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800acb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad0:	eb d1                	jmp    800aa3 <vprintfmt+0xd6>
			goto process_precision;
  800ad2:	eb 58                	jmp    800b2c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ad4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad7:	83 f8 30             	cmp    $0x30,%eax
  800ada:	73 17                	jae    800af3 <vprintfmt+0x126>
  800adc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	89 c0                	mov    %eax,%eax
  800ae5:	48 01 d0             	add    %rdx,%rax
  800ae8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aeb:	83 c2 08             	add    $0x8,%edx
  800aee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af1:	eb 0f                	jmp    800b02 <vprintfmt+0x135>
  800af3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af7:	48 89 d0             	mov    %rdx,%rax
  800afa:	48 83 c2 08          	add    $0x8,%rdx
  800afe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b02:	8b 00                	mov    (%rax),%eax
  800b04:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b07:	eb 23                	jmp    800b2c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0d:	79 0c                	jns    800b1b <vprintfmt+0x14e>
				width = 0;
  800b0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b16:	e9 3b ff ff ff       	jmpq   800a56 <vprintfmt+0x89>
  800b1b:	e9 36 ff ff ff       	jmpq   800a56 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b20:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b27:	e9 2a ff ff ff       	jmpq   800a56 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b30:	79 12                	jns    800b44 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b32:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b35:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b38:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b3f:	e9 12 ff ff ff       	jmpq   800a56 <vprintfmt+0x89>
  800b44:	e9 0d ff ff ff       	jmpq   800a56 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b49:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b4d:	e9 04 ff ff ff       	jmpq   800a56 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b55:	83 f8 30             	cmp    $0x30,%eax
  800b58:	73 17                	jae    800b71 <vprintfmt+0x1a4>
  800b5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	89 c0                	mov    %eax,%eax
  800b63:	48 01 d0             	add    %rdx,%rax
  800b66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b69:	83 c2 08             	add    $0x8,%edx
  800b6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x1b3>
  800b71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b75:	48 89 d0             	mov    %rdx,%rax
  800b78:	48 83 c2 08          	add    $0x8,%rdx
  800b7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b80:	8b 10                	mov    (%rax),%edx
  800b82:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8a:	48 89 ce             	mov    %rcx,%rsi
  800b8d:	89 d7                	mov    %edx,%edi
  800b8f:	ff d0                	callq  *%rax
			break;
  800b91:	e9 40 03 00 00       	jmpq   800ed6 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b99:	83 f8 30             	cmp    $0x30,%eax
  800b9c:	73 17                	jae    800bb5 <vprintfmt+0x1e8>
  800b9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba5:	89 c0                	mov    %eax,%eax
  800ba7:	48 01 d0             	add    %rdx,%rax
  800baa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bad:	83 c2 08             	add    $0x8,%edx
  800bb0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb3:	eb 0f                	jmp    800bc4 <vprintfmt+0x1f7>
  800bb5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb9:	48 89 d0             	mov    %rdx,%rax
  800bbc:	48 83 c2 08          	add    $0x8,%rdx
  800bc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bc6:	85 db                	test   %ebx,%ebx
  800bc8:	79 02                	jns    800bcc <vprintfmt+0x1ff>
				err = -err;
  800bca:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bcc:	83 fb 15             	cmp    $0x15,%ebx
  800bcf:	7f 16                	jg     800be7 <vprintfmt+0x21a>
  800bd1:	48 b8 a0 47 80 00 00 	movabs $0x8047a0,%rax
  800bd8:	00 00 00 
  800bdb:	48 63 d3             	movslq %ebx,%rdx
  800bde:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800be2:	4d 85 e4             	test   %r12,%r12
  800be5:	75 2e                	jne    800c15 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800be7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	89 d9                	mov    %ebx,%ecx
  800bf1:	48 ba 61 48 80 00 00 	movabs $0x804861,%rdx
  800bf8:	00 00 00 
  800bfb:	48 89 c7             	mov    %rax,%rdi
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	49 b8 e5 0e 80 00 00 	movabs $0x800ee5,%r8
  800c0a:	00 00 00 
  800c0d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c10:	e9 c1 02 00 00       	jmpq   800ed6 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c15:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1d:	4c 89 e1             	mov    %r12,%rcx
  800c20:	48 ba 6a 48 80 00 00 	movabs $0x80486a,%rdx
  800c27:	00 00 00 
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c32:	49 b8 e5 0e 80 00 00 	movabs $0x800ee5,%r8
  800c39:	00 00 00 
  800c3c:	41 ff d0             	callq  *%r8
			break;
  800c3f:	e9 92 02 00 00       	jmpq   800ed6 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c47:	83 f8 30             	cmp    $0x30,%eax
  800c4a:	73 17                	jae    800c63 <vprintfmt+0x296>
  800c4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c53:	89 c0                	mov    %eax,%eax
  800c55:	48 01 d0             	add    %rdx,%rax
  800c58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c5b:	83 c2 08             	add    $0x8,%edx
  800c5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c61:	eb 0f                	jmp    800c72 <vprintfmt+0x2a5>
  800c63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c67:	48 89 d0             	mov    %rdx,%rax
  800c6a:	48 83 c2 08          	add    $0x8,%rdx
  800c6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c72:	4c 8b 20             	mov    (%rax),%r12
  800c75:	4d 85 e4             	test   %r12,%r12
  800c78:	75 0a                	jne    800c84 <vprintfmt+0x2b7>
				p = "(null)";
  800c7a:	49 bc 6d 48 80 00 00 	movabs $0x80486d,%r12
  800c81:	00 00 00 
			if (width > 0 && padc != '-')
  800c84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c88:	7e 3f                	jle    800cc9 <vprintfmt+0x2fc>
  800c8a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c8e:	74 39                	je     800cc9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c90:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c93:	48 98                	cltq   
  800c95:	48 89 c6             	mov    %rax,%rsi
  800c98:	4c 89 e7             	mov    %r12,%rdi
  800c9b:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
  800ca7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800caa:	eb 17                	jmp    800cc3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cac:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cb0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb8:	48 89 ce             	mov    %rcx,%rsi
  800cbb:	89 d7                	mov    %edx,%edi
  800cbd:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc7:	7f e3                	jg     800cac <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc9:	eb 37                	jmp    800d02 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800ccb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ccf:	74 1e                	je     800cef <vprintfmt+0x322>
  800cd1:	83 fb 1f             	cmp    $0x1f,%ebx
  800cd4:	7e 05                	jle    800cdb <vprintfmt+0x30e>
  800cd6:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd9:	7e 14                	jle    800cef <vprintfmt+0x322>
					putch('?', putdat);
  800cdb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce3:	48 89 d6             	mov    %rdx,%rsi
  800ce6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ceb:	ff d0                	callq  *%rax
  800ced:	eb 0f                	jmp    800cfe <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf7:	48 89 d6             	mov    %rdx,%rsi
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d02:	4c 89 e0             	mov    %r12,%rax
  800d05:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d09:	0f b6 00             	movzbl (%rax),%eax
  800d0c:	0f be d8             	movsbl %al,%ebx
  800d0f:	85 db                	test   %ebx,%ebx
  800d11:	74 10                	je     800d23 <vprintfmt+0x356>
  800d13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d17:	78 b2                	js     800ccb <vprintfmt+0x2fe>
  800d19:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d21:	79 a8                	jns    800ccb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d23:	eb 16                	jmp    800d3b <vprintfmt+0x36e>
				putch(' ', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 20 00 00 00       	mov    $0x20,%edi
  800d35:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3f:	7f e4                	jg     800d25 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d41:	e9 90 01 00 00       	jmpq   800ed6 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4a:	be 03 00 00 00       	mov    $0x3,%esi
  800d4f:	48 89 c7             	mov    %rax,%rdi
  800d52:	48 b8 bd 08 80 00 00 	movabs $0x8008bd,%rax
  800d59:	00 00 00 
  800d5c:	ff d0                	callq  *%rax
  800d5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d66:	48 85 c0             	test   %rax,%rax
  800d69:	79 1d                	jns    800d88 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d73:	48 89 d6             	mov    %rdx,%rsi
  800d76:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d7b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d81:	48 f7 d8             	neg    %rax
  800d84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d88:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d8f:	e9 d5 00 00 00       	jmpq   800e69 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d98:	be 03 00 00 00       	mov    $0x3,%esi
  800d9d:	48 89 c7             	mov    %rax,%rdi
  800da0:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800da7:	00 00 00 
  800daa:	ff d0                	callq  *%rax
  800dac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800db0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db7:	e9 ad 00 00 00       	jmpq   800e69 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800dbc:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800dbf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc3:	89 d6                	mov    %edx,%esi
  800dc5:	48 89 c7             	mov    %rax,%rdi
  800dc8:	48 b8 bd 08 80 00 00 	movabs $0x8008bd,%rax
  800dcf:	00 00 00 
  800dd2:	ff d0                	callq  *%rax
  800dd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800dd8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ddf:	e9 85 00 00 00       	jmpq   800e69 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800de4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dec:	48 89 d6             	mov    %rdx,%rsi
  800def:	bf 30 00 00 00       	mov    $0x30,%edi
  800df4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800df6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfe:	48 89 d6             	mov    %rdx,%rsi
  800e01:	bf 78 00 00 00       	mov    $0x78,%edi
  800e06:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0b:	83 f8 30             	cmp    $0x30,%eax
  800e0e:	73 17                	jae    800e27 <vprintfmt+0x45a>
  800e10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e17:	89 c0                	mov    %eax,%eax
  800e19:	48 01 d0             	add    %rdx,%rax
  800e1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1f:	83 c2 08             	add    $0x8,%edx
  800e22:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e25:	eb 0f                	jmp    800e36 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e2b:	48 89 d0             	mov    %rdx,%rax
  800e2e:	48 83 c2 08          	add    $0x8,%rdx
  800e32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e36:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e3d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e44:	eb 23                	jmp    800e69 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4a:	be 03 00 00 00       	mov    $0x3,%esi
  800e4f:	48 89 c7             	mov    %rax,%rdi
  800e52:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	callq  *%rax
  800e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e62:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e69:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e6e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e71:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e78:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e80:	45 89 c1             	mov    %r8d,%r9d
  800e83:	41 89 f8             	mov    %edi,%r8d
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 f2 06 80 00 00 	movabs $0x8006f2,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
			break;
  800e95:	eb 3f                	jmp    800ed6 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9f:	48 89 d6             	mov    %rdx,%rsi
  800ea2:	89 df                	mov    %ebx,%edi
  800ea4:	ff d0                	callq  *%rax
			break;
  800ea6:	eb 2e                	jmp    800ed6 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb0:	48 89 d6             	mov    %rdx,%rsi
  800eb3:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eba:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebf:	eb 05                	jmp    800ec6 <vprintfmt+0x4f9>
  800ec1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800eca:	48 83 e8 01          	sub    $0x1,%rax
  800ece:	0f b6 00             	movzbl (%rax),%eax
  800ed1:	3c 25                	cmp    $0x25,%al
  800ed3:	75 ec                	jne    800ec1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ed5:	90                   	nop
		}
	}
  800ed6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed7:	e9 43 fb ff ff       	jmpq   800a1f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800edc:	48 83 c4 60          	add    $0x60,%rsp
  800ee0:	5b                   	pop    %rbx
  800ee1:	41 5c                	pop    %r12
  800ee3:	5d                   	pop    %rbp
  800ee4:	c3                   	retq   

0000000000800ee5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ee5:	55                   	push   %rbp
  800ee6:	48 89 e5             	mov    %rsp,%rbp
  800ee9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ef0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ef7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800efe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f05:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f0c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f13:	84 c0                	test   %al,%al
  800f15:	74 20                	je     800f37 <printfmt+0x52>
  800f17:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f1b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f1f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f23:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f27:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f2b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f2f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f33:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f37:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f3e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f45:	00 00 00 
  800f48:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f4f:	00 00 00 
  800f52:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f56:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f5d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f64:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f6b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f72:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f79:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f80:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 10          	sub    $0x10,%rsp
  800fa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fab:	8b 40 10             	mov    0x10(%rax),%eax
  800fae:	8d 50 01             	lea    0x1(%rax),%edx
  800fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbc:	48 8b 10             	mov    (%rax),%rdx
  800fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fc7:	48 39 c2             	cmp    %rax,%rdx
  800fca:	73 17                	jae    800fe3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd0:	48 8b 00             	mov    (%rax),%rax
  800fd3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fdb:	48 89 0a             	mov    %rcx,(%rdx)
  800fde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fe1:	88 10                	mov    %dl,(%rax)
}
  800fe3:	c9                   	leaveq 
  800fe4:	c3                   	retq   

0000000000800fe5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe5:	55                   	push   %rbp
  800fe6:	48 89 e5             	mov    %rsp,%rbp
  800fe9:	48 83 ec 50          	sub    $0x50,%rsp
  800fed:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ff1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ff4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ffc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801000:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801004:	48 8b 0a             	mov    (%rdx),%rcx
  801007:	48 89 08             	mov    %rcx,(%rax)
  80100a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80100e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801012:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801016:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80101a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80101e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801022:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801025:	48 98                	cltq   
  801027:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80102b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102f:	48 01 d0             	add    %rdx,%rax
  801032:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801036:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80103d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801042:	74 06                	je     80104a <vsnprintf+0x65>
  801044:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801048:	7f 07                	jg     801051 <vsnprintf+0x6c>
		return -E_INVAL;
  80104a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104f:	eb 2f                	jmp    801080 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801051:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801055:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801059:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80105d:	48 89 c6             	mov    %rax,%rsi
  801060:	48 bf 98 0f 80 00 00 	movabs $0x800f98,%rdi
  801067:	00 00 00 
  80106a:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  801071:	00 00 00 
  801074:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801076:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80107a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80107d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801080:	c9                   	leaveq 
  801081:	c3                   	retq   

0000000000801082 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80108d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801094:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80109a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010af:	84 c0                	test   %al,%al
  8010b1:	74 20                	je     8010d3 <snprintf+0x51>
  8010b3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010b7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010bb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010bf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010c7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010cb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010cf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010d3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010da:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010e1:	00 00 00 
  8010e4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010eb:	00 00 00 
  8010ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801100:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801107:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80110e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801115:	48 8b 0a             	mov    (%rdx),%rcx
  801118:	48 89 08             	mov    %rcx,(%rax)
  80111b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801123:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801127:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80112b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801132:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801139:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80113f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801146:	48 89 c7             	mov    %rax,%rdi
  801149:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  801150:	00 00 00 
  801153:	ff d0                	callq  *%rax
  801155:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80115b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 83 ec 18          	sub    $0x18,%rsp
  80116b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801176:	eb 09                	jmp    801181 <strlen+0x1e>
		n++;
  801178:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80117c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	0f b6 00             	movzbl (%rax),%eax
  801188:	84 c0                	test   %al,%al
  80118a:	75 ec                	jne    801178 <strlen+0x15>
		n++;
	return n;
  80118c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 20          	sub    $0x20,%rsp
  801199:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a8:	eb 0e                	jmp    8011b8 <strnlen+0x27>
		n++;
  8011aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011bd:	74 0b                	je     8011ca <strnlen+0x39>
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	84 c0                	test   %al,%al
  8011c8:	75 e0                	jne    8011aa <strnlen+0x19>
		n++;
	return n;
  8011ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011cd:	c9                   	leaveq 
  8011ce:	c3                   	retq   

00000000008011cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	48 83 ec 20          	sub    $0x20,%rsp
  8011d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011e7:	90                   	nop
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011fc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801200:	0f b6 12             	movzbl (%rdx),%edx
  801203:	88 10                	mov    %dl,(%rax)
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	84 c0                	test   %al,%al
  80120a:	75 dc                	jne    8011e8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80120c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801210:	c9                   	leaveq 
  801211:	c3                   	retq   

0000000000801212 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801212:	55                   	push   %rbp
  801213:	48 89 e5             	mov    %rsp,%rbp
  801216:	48 83 ec 20          	sub    $0x20,%rsp
  80121a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801226:	48 89 c7             	mov    %rax,%rdi
  801229:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  801230:	00 00 00 
  801233:	ff d0                	callq  *%rax
  801235:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80123b:	48 63 d0             	movslq %eax,%rdx
  80123e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801242:	48 01 c2             	add    %rax,%rdx
  801245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801249:	48 89 c6             	mov    %rax,%rsi
  80124c:	48 89 d7             	mov    %rdx,%rdi
  80124f:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  801256:	00 00 00 
  801259:	ff d0                	callq  *%rax
	return dst;
  80125b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80125f:	c9                   	leaveq 
  801260:	c3                   	retq   

0000000000801261 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	48 83 ec 28          	sub    $0x28,%rsp
  801269:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801271:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801279:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80127d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801284:	00 
  801285:	eb 2a                	jmp    8012b1 <strncpy+0x50>
		*dst++ = *src;
  801287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801293:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801297:	0f b6 12             	movzbl (%rdx),%edx
  80129a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80129c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	84 c0                	test   %al,%al
  8012a5:	74 05                	je     8012ac <strncpy+0x4b>
			src++;
  8012a7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b9:	72 cc                	jb     801287 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012bf:	c9                   	leaveq 
  8012c0:	c3                   	retq   

00000000008012c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012c1:	55                   	push   %rbp
  8012c2:	48 89 e5             	mov    %rsp,%rbp
  8012c5:	48 83 ec 28          	sub    $0x28,%rsp
  8012c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012dd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012e2:	74 3d                	je     801321 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012e4:	eb 1d                	jmp    801303 <strlcpy+0x42>
			*dst++ = *src++;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012fe:	0f b6 12             	movzbl (%rdx),%edx
  801301:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801303:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801308:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130d:	74 0b                	je     80131a <strlcpy+0x59>
  80130f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	75 cc                	jne    8012e6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801321:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801329:	48 29 c2             	sub    %rax,%rdx
  80132c:	48 89 d0             	mov    %rdx,%rax
}
  80132f:	c9                   	leaveq 
  801330:	c3                   	retq   

0000000000801331 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801331:	55                   	push   %rbp
  801332:	48 89 e5             	mov    %rsp,%rbp
  801335:	48 83 ec 10          	sub    $0x10,%rsp
  801339:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801341:	eb 0a                	jmp    80134d <strcmp+0x1c>
		p++, q++;
  801343:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801348:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	84 c0                	test   %al,%al
  801356:	74 12                	je     80136a <strcmp+0x39>
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	0f b6 10             	movzbl (%rax),%edx
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	38 c2                	cmp    %al,%dl
  801368:	74 d9                	je     801343 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	0f b6 00             	movzbl (%rax),%eax
  801371:	0f b6 d0             	movzbl %al,%edx
  801374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801378:	0f b6 00             	movzbl (%rax),%eax
  80137b:	0f b6 c0             	movzbl %al,%eax
  80137e:	29 c2                	sub    %eax,%edx
  801380:	89 d0                	mov    %edx,%eax
}
  801382:	c9                   	leaveq 
  801383:	c3                   	retq   

0000000000801384 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801384:	55                   	push   %rbp
  801385:	48 89 e5             	mov    %rsp,%rbp
  801388:	48 83 ec 18          	sub    $0x18,%rsp
  80138c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801394:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801398:	eb 0f                	jmp    8013a9 <strncmp+0x25>
		n--, p++, q++;
  80139a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80139f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ae:	74 1d                	je     8013cd <strncmp+0x49>
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	84 c0                	test   %al,%al
  8013b9:	74 12                	je     8013cd <strncmp+0x49>
  8013bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bf:	0f b6 10             	movzbl (%rax),%edx
  8013c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c6:	0f b6 00             	movzbl (%rax),%eax
  8013c9:	38 c2                	cmp    %al,%dl
  8013cb:	74 cd                	je     80139a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d2:	75 07                	jne    8013db <strncmp+0x57>
		return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d9:	eb 18                	jmp    8013f3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	0f b6 00             	movzbl (%rax),%eax
  8013e2:	0f b6 d0             	movzbl %al,%edx
  8013e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e9:	0f b6 00             	movzbl (%rax),%eax
  8013ec:	0f b6 c0             	movzbl %al,%eax
  8013ef:	29 c2                	sub    %eax,%edx
  8013f1:	89 d0                	mov    %edx,%eax
}
  8013f3:	c9                   	leaveq 
  8013f4:	c3                   	retq   

00000000008013f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 83 ec 0c          	sub    $0xc,%rsp
  8013fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801401:	89 f0                	mov    %esi,%eax
  801403:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801406:	eb 17                	jmp    80141f <strchr+0x2a>
		if (*s == c)
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801412:	75 06                	jne    80141a <strchr+0x25>
			return (char *) s;
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801418:	eb 15                	jmp    80142f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80141a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	84 c0                	test   %al,%al
  801428:	75 de                	jne    801408 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142f:	c9                   	leaveq 
  801430:	c3                   	retq   

0000000000801431 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801431:	55                   	push   %rbp
  801432:	48 89 e5             	mov    %rsp,%rbp
  801435:	48 83 ec 0c          	sub    $0xc,%rsp
  801439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143d:	89 f0                	mov    %esi,%eax
  80143f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801442:	eb 13                	jmp    801457 <strfind+0x26>
		if (*s == c)
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144e:	75 02                	jne    801452 <strfind+0x21>
			break;
  801450:	eb 10                	jmp    801462 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801452:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	84 c0                	test   %al,%al
  801460:	75 e2                	jne    801444 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 18          	sub    $0x18,%rsp
  801470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801474:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801477:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80147b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801480:	75 06                	jne    801488 <memset+0x20>
		return v;
  801482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801486:	eb 69                	jmp    8014f1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	83 e0 03             	and    $0x3,%eax
  80148f:	48 85 c0             	test   %rax,%rax
  801492:	75 48                	jne    8014dc <memset+0x74>
  801494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	75 3c                	jne    8014dc <memset+0x74>
		c &= 0xFF;
  8014a0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014aa:	c1 e0 18             	shl    $0x18,%eax
  8014ad:	89 c2                	mov    %eax,%edx
  8014af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b2:	c1 e0 10             	shl    $0x10,%eax
  8014b5:	09 c2                	or     %eax,%edx
  8014b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ba:	c1 e0 08             	shl    $0x8,%eax
  8014bd:	09 d0                	or     %edx,%eax
  8014bf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 c1 e8 02          	shr    $0x2,%rax
  8014ca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d4:	48 89 d7             	mov    %rdx,%rdi
  8014d7:	fc                   	cld    
  8014d8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014da:	eb 11                	jmp    8014ed <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014e7:	48 89 d7             	mov    %rdx,%rdi
  8014ea:	fc                   	cld    
  8014eb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 28          	sub    $0x28,%rsp
  8014fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801503:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801507:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80150b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80150f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801513:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80151f:	0f 83 88 00 00 00    	jae    8015ad <memmove+0xba>
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152d:	48 01 d0             	add    %rdx,%rax
  801530:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801534:	76 77                	jbe    8015ad <memmove+0xba>
		s += n;
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154a:	83 e0 03             	and    $0x3,%eax
  80154d:	48 85 c0             	test   %rax,%rax
  801550:	75 3b                	jne    80158d <memmove+0x9a>
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801556:	83 e0 03             	and    $0x3,%eax
  801559:	48 85 c0             	test   %rax,%rax
  80155c:	75 2f                	jne    80158d <memmove+0x9a>
  80155e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801562:	83 e0 03             	and    $0x3,%eax
  801565:	48 85 c0             	test   %rax,%rax
  801568:	75 23                	jne    80158d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156e:	48 83 e8 04          	sub    $0x4,%rax
  801572:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801576:	48 83 ea 04          	sub    $0x4,%rdx
  80157a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80157e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801582:	48 89 c7             	mov    %rax,%rdi
  801585:	48 89 d6             	mov    %rdx,%rsi
  801588:	fd                   	std    
  801589:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80158b:	eb 1d                	jmp    8015aa <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80158d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801591:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801599:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	48 89 d7             	mov    %rdx,%rdi
  8015a4:	48 89 c1             	mov    %rax,%rcx
  8015a7:	fd                   	std    
  8015a8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015aa:	fc                   	cld    
  8015ab:	eb 57                	jmp    801604 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b1:	83 e0 03             	and    $0x3,%eax
  8015b4:	48 85 c0             	test   %rax,%rax
  8015b7:	75 36                	jne    8015ef <memmove+0xfc>
  8015b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bd:	83 e0 03             	and    $0x3,%eax
  8015c0:	48 85 c0             	test   %rax,%rax
  8015c3:	75 2a                	jne    8015ef <memmove+0xfc>
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	83 e0 03             	and    $0x3,%eax
  8015cc:	48 85 c0             	test   %rax,%rax
  8015cf:	75 1e                	jne    8015ef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	48 c1 e8 02          	shr    $0x2,%rax
  8015d9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e4:	48 89 c7             	mov    %rax,%rdi
  8015e7:	48 89 d6             	mov    %rdx,%rsi
  8015ea:	fc                   	cld    
  8015eb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ed:	eb 15                	jmp    801604 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015fb:	48 89 c7             	mov    %rax,%rdi
  8015fe:	48 89 d6             	mov    %rdx,%rsi
  801601:	fc                   	cld    
  801602:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801608:	c9                   	leaveq 
  801609:	c3                   	retq   

000000000080160a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80160a:	55                   	push   %rbp
  80160b:	48 89 e5             	mov    %rsp,%rbp
  80160e:	48 83 ec 18          	sub    $0x18,%rsp
  801612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801616:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80161a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80161e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801622:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	48 89 ce             	mov    %rcx,%rsi
  80162d:	48 89 c7             	mov    %rax,%rdi
  801630:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  801637:	00 00 00 
  80163a:	ff d0                	callq  *%rax
}
  80163c:	c9                   	leaveq 
  80163d:	c3                   	retq   

000000000080163e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80163e:	55                   	push   %rbp
  80163f:	48 89 e5             	mov    %rsp,%rbp
  801642:	48 83 ec 28          	sub    $0x28,%rsp
  801646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80164a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801656:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80165a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801662:	eb 36                	jmp    80169a <memcmp+0x5c>
		if (*s1 != *s2)
  801664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801668:	0f b6 10             	movzbl (%rax),%edx
  80166b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	38 c2                	cmp    %al,%dl
  801674:	74 1a                	je     801690 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	0f b6 d0             	movzbl %al,%edx
  801680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	0f b6 c0             	movzbl %al,%eax
  80168a:	29 c2                	sub    %eax,%edx
  80168c:	89 d0                	mov    %edx,%eax
  80168e:	eb 20                	jmp    8016b0 <memcmp+0x72>
		s1++, s2++;
  801690:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801695:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80169a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016a6:	48 85 c0             	test   %rax,%rax
  8016a9:	75 b9                	jne    801664 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	c9                   	leaveq 
  8016b1:	c3                   	retq   

00000000008016b2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016b2:	55                   	push   %rbp
  8016b3:	48 89 e5             	mov    %rsp,%rbp
  8016b6:	48 83 ec 28          	sub    $0x28,%rsp
  8016ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016cd:	48 01 d0             	add    %rdx,%rax
  8016d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016d4:	eb 15                	jmp    8016eb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016da:	0f b6 10             	movzbl (%rax),%edx
  8016dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016e0:	38 c2                	cmp    %al,%dl
  8016e2:	75 02                	jne    8016e6 <memfind+0x34>
			break;
  8016e4:	eb 0f                	jmp    8016f5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ef:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016f3:	72 e1                	jb     8016d6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016f9:	c9                   	leaveq 
  8016fa:	c3                   	retq   

00000000008016fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016fb:	55                   	push   %rbp
  8016fc:	48 89 e5             	mov    %rsp,%rbp
  8016ff:	48 83 ec 34          	sub    $0x34,%rsp
  801703:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801707:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80170b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801715:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80171c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171d:	eb 05                	jmp    801724 <strtol+0x29>
		s++;
  80171f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801728:	0f b6 00             	movzbl (%rax),%eax
  80172b:	3c 20                	cmp    $0x20,%al
  80172d:	74 f0                	je     80171f <strtol+0x24>
  80172f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801733:	0f b6 00             	movzbl (%rax),%eax
  801736:	3c 09                	cmp    $0x9,%al
  801738:	74 e5                	je     80171f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	3c 2b                	cmp    $0x2b,%al
  801743:	75 07                	jne    80174c <strtol+0x51>
		s++;
  801745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80174a:	eb 17                	jmp    801763 <strtol+0x68>
	else if (*s == '-')
  80174c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801750:	0f b6 00             	movzbl (%rax),%eax
  801753:	3c 2d                	cmp    $0x2d,%al
  801755:	75 0c                	jne    801763 <strtol+0x68>
		s++, neg = 1;
  801757:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801763:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801767:	74 06                	je     80176f <strtol+0x74>
  801769:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80176d:	75 28                	jne    801797 <strtol+0x9c>
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	3c 30                	cmp    $0x30,%al
  801778:	75 1d                	jne    801797 <strtol+0x9c>
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	48 83 c0 01          	add    $0x1,%rax
  801782:	0f b6 00             	movzbl (%rax),%eax
  801785:	3c 78                	cmp    $0x78,%al
  801787:	75 0e                	jne    801797 <strtol+0x9c>
		s += 2, base = 16;
  801789:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80178e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801795:	eb 2c                	jmp    8017c3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801797:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80179b:	75 19                	jne    8017b6 <strtol+0xbb>
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	3c 30                	cmp    $0x30,%al
  8017a6:	75 0e                	jne    8017b6 <strtol+0xbb>
		s++, base = 8;
  8017a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ad:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017b4:	eb 0d                	jmp    8017c3 <strtol+0xc8>
	else if (base == 0)
  8017b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ba:	75 07                	jne    8017c3 <strtol+0xc8>
		base = 10;
  8017bc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3c 2f                	cmp    $0x2f,%al
  8017cc:	7e 1d                	jle    8017eb <strtol+0xf0>
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	3c 39                	cmp    $0x39,%al
  8017d7:	7f 12                	jg     8017eb <strtol+0xf0>
			dig = *s - '0';
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	0f be c0             	movsbl %al,%eax
  8017e3:	83 e8 30             	sub    $0x30,%eax
  8017e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e9:	eb 4e                	jmp    801839 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ef:	0f b6 00             	movzbl (%rax),%eax
  8017f2:	3c 60                	cmp    $0x60,%al
  8017f4:	7e 1d                	jle    801813 <strtol+0x118>
  8017f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fa:	0f b6 00             	movzbl (%rax),%eax
  8017fd:	3c 7a                	cmp    $0x7a,%al
  8017ff:	7f 12                	jg     801813 <strtol+0x118>
			dig = *s - 'a' + 10;
  801801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801805:	0f b6 00             	movzbl (%rax),%eax
  801808:	0f be c0             	movsbl %al,%eax
  80180b:	83 e8 57             	sub    $0x57,%eax
  80180e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801811:	eb 26                	jmp    801839 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	3c 40                	cmp    $0x40,%al
  80181c:	7e 48                	jle    801866 <strtol+0x16b>
  80181e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801822:	0f b6 00             	movzbl (%rax),%eax
  801825:	3c 5a                	cmp    $0x5a,%al
  801827:	7f 3d                	jg     801866 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	0f b6 00             	movzbl (%rax),%eax
  801830:	0f be c0             	movsbl %al,%eax
  801833:	83 e8 37             	sub    $0x37,%eax
  801836:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801839:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80183f:	7c 02                	jl     801843 <strtol+0x148>
			break;
  801841:	eb 23                	jmp    801866 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801843:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801848:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80184b:	48 98                	cltq   
  80184d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801852:	48 89 c2             	mov    %rax,%rdx
  801855:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801858:	48 98                	cltq   
  80185a:	48 01 d0             	add    %rdx,%rax
  80185d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801861:	e9 5d ff ff ff       	jmpq   8017c3 <strtol+0xc8>

	if (endptr)
  801866:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80186b:	74 0b                	je     801878 <strtol+0x17d>
		*endptr = (char *) s;
  80186d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801871:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801875:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801878:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80187c:	74 09                	je     801887 <strtol+0x18c>
  80187e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801882:	48 f7 d8             	neg    %rax
  801885:	eb 04                	jmp    80188b <strtol+0x190>
  801887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <strstr>:

char * strstr(const char *in, const char *str)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 30          	sub    $0x30,%rsp
  801895:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801899:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80189d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a9:	0f b6 00             	movzbl (%rax),%eax
  8018ac:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018af:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018b3:	75 06                	jne    8018bb <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	eb 6b                	jmp    801926 <strstr+0x99>

	len = strlen(str);
  8018bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bf:	48 89 c7             	mov    %rax,%rdi
  8018c2:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	callq  *%rax
  8018ce:	48 98                	cltq   
  8018d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018ea:	75 07                	jne    8018f3 <strstr+0x66>
				return (char *) 0;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	eb 33                	jmp    801926 <strstr+0x99>
		} while (sc != c);
  8018f3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018f7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018fa:	75 d8                	jne    8018d4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801900:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	48 89 ce             	mov    %rcx,%rsi
  80190b:	48 89 c7             	mov    %rax,%rdi
  80190e:	48 b8 84 13 80 00 00 	movabs $0x801384,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
  80191a:	85 c0                	test   %eax,%eax
  80191c:	75 b6                	jne    8018d4 <strstr+0x47>

	return (char *) (in - 1);
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	48 83 e8 01          	sub    $0x1,%rax
}
  801926:	c9                   	leaveq 
  801927:	c3                   	retq   

0000000000801928 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801928:	55                   	push   %rbp
  801929:	48 89 e5             	mov    %rsp,%rbp
  80192c:	53                   	push   %rbx
  80192d:	48 83 ec 48          	sub    $0x48,%rsp
  801931:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801934:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801937:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80193b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80193f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801943:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801947:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80194a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80194e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801952:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801956:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80195a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80195e:	4c 89 c3             	mov    %r8,%rbx
  801961:	cd 30                	int    $0x30
  801963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801967:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80196b:	74 3e                	je     8019ab <syscall+0x83>
  80196d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801972:	7e 37                	jle    8019ab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801978:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80197b:	49 89 d0             	mov    %rdx,%r8
  80197e:	89 c1                	mov    %eax,%ecx
  801980:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  801987:	00 00 00 
  80198a:	be 23 00 00 00       	mov    $0x23,%esi
  80198f:	48 bf 45 4b 80 00 00 	movabs $0x804b45,%rdi
  801996:	00 00 00 
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
  80199e:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8019a5:	00 00 00 
  8019a8:	41 ff d1             	callq  *%r9

	return ret;
  8019ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019af:	48 83 c4 48          	add    $0x48,%rsp
  8019b3:	5b                   	pop    %rbx
  8019b4:	5d                   	pop    %rbp
  8019b5:	c3                   	retq   

00000000008019b6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 83 ec 20          	sub    $0x20,%rsp
  8019be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d5:	00 
  8019d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e2:	48 89 d1             	mov    %rdx,%rcx
  8019e5:	48 89 c2             	mov    %rax,%rdx
  8019e8:	be 00 00 00 00       	mov    $0x0,%esi
  8019ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f2:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  8019f9:	00 00 00 
  8019fc:	ff d0                	callq  *%rax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0f:	00 
  801a10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	be 00 00 00 00       	mov    $0x0,%esi
  801a2b:	bf 01 00 00 00       	mov    $0x1,%edi
  801a30:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801a37:	00 00 00 
  801a3a:	ff d0                	callq  *%rax
}
  801a3c:	c9                   	leaveq 
  801a3d:	c3                   	retq   

0000000000801a3e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a3e:	55                   	push   %rbp
  801a3f:	48 89 e5             	mov    %rsp,%rbp
  801a42:	48 83 ec 10          	sub    $0x10,%rsp
  801a46:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4c:	48 98                	cltq   
  801a4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a55:	00 
  801a56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 03 00 00 00       	mov    $0x3,%edi
  801a74:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a91:	00 
  801a92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa8:	be 00 00 00 00       	mov    $0x0,%esi
  801aad:	bf 02 00 00 00       	mov    $0x2,%edi
  801ab2:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
}
  801abe:	c9                   	leaveq 
  801abf:	c3                   	retq   

0000000000801ac0 <sys_yield>:

void
sys_yield(void)
{
  801ac0:	55                   	push   %rbp
  801ac1:	48 89 e5             	mov    %rsp,%rbp
  801ac4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae6:	be 00 00 00 00       	mov    $0x0,%esi
  801aeb:	bf 0b 00 00 00       	mov    $0xb,%edi
  801af0:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801af7:	00 00 00 
  801afa:	ff d0                	callq  *%rax
}
  801afc:	c9                   	leaveq 
  801afd:	c3                   	retq   

0000000000801afe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	48 83 ec 20          	sub    $0x20,%rsp
  801b06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b13:	48 63 c8             	movslq %eax,%rcx
  801b16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1d:	48 98                	cltq   
  801b1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b26:	00 
  801b27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2d:	49 89 c8             	mov    %rcx,%r8
  801b30:	48 89 d1             	mov    %rdx,%rcx
  801b33:	48 89 c2             	mov    %rax,%rdx
  801b36:	be 01 00 00 00       	mov    $0x1,%esi
  801b3b:	bf 04 00 00 00       	mov    $0x4,%edi
  801b40:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 30          	sub    $0x30,%rsp
  801b56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b64:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b68:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b6b:	48 63 c8             	movslq %eax,%rcx
  801b6e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b75:	48 63 f0             	movslq %eax,%rsi
  801b78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7f:	48 98                	cltq   
  801b81:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b85:	49 89 f9             	mov    %rdi,%r9
  801b88:	49 89 f0             	mov    %rsi,%r8
  801b8b:	48 89 d1             	mov    %rdx,%rcx
  801b8e:	48 89 c2             	mov    %rax,%rdx
  801b91:	be 01 00 00 00       	mov    $0x1,%esi
  801b96:	bf 05 00 00 00       	mov    $0x5,%edi
  801b9b:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 20          	sub    $0x20,%rsp
  801bb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbf:	48 98                	cltq   
  801bc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc8:	00 
  801bc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd5:	48 89 d1             	mov    %rdx,%rcx
  801bd8:	48 89 c2             	mov    %rax,%rdx
  801bdb:	be 01 00 00 00       	mov    $0x1,%esi
  801be0:	bf 06 00 00 00       	mov    $0x6,%edi
  801be5:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	callq  *%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 10          	sub    $0x10,%rsp
  801bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bfe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c04:	48 63 d0             	movslq %eax,%rdx
  801c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0a:	48 98                	cltq   
  801c0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c13:	00 
  801c14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c20:	48 89 d1             	mov    %rdx,%rcx
  801c23:	48 89 c2             	mov    %rax,%rdx
  801c26:	be 01 00 00 00       	mov    $0x1,%esi
  801c2b:	bf 08 00 00 00       	mov    $0x8,%edi
  801c30:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	48 83 ec 20          	sub    $0x20,%rsp
  801c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c54:	48 98                	cltq   
  801c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5d:	00 
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	48 89 d1             	mov    %rdx,%rcx
  801c6d:	48 89 c2             	mov    %rax,%rdx
  801c70:	be 01 00 00 00       	mov    $0x1,%esi
  801c75:	bf 09 00 00 00       	mov    $0x9,%edi
  801c7a:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801c81:	00 00 00 
  801c84:	ff d0                	callq  *%rax
}
  801c86:	c9                   	leaveq 
  801c87:	c3                   	retq   

0000000000801c88 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	48 83 ec 20          	sub    $0x20,%rsp
  801c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
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
  801cbf:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cc4:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 20          	sub    $0x20,%rsp
  801cda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ce5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ce8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ceb:	48 63 f0             	movslq %eax,%rsi
  801cee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf5:	48 98                	cltq   
  801cf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d02:	00 
  801d03:	49 89 f1             	mov    %rsi,%r9
  801d06:	49 89 c8             	mov    %rcx,%r8
  801d09:	48 89 d1             	mov    %rdx,%rcx
  801d0c:	48 89 c2             	mov    %rax,%rdx
  801d0f:	be 00 00 00 00       	mov    $0x0,%esi
  801d14:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d19:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801d20:	00 00 00 
  801d23:	ff d0                	callq  *%rax
}
  801d25:	c9                   	leaveq 
  801d26:	c3                   	retq   

0000000000801d27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d27:	55                   	push   %rbp
  801d28:	48 89 e5             	mov    %rsp,%rbp
  801d2b:	48 83 ec 10          	sub    $0x10,%rsp
  801d2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3e:	00 
  801d3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d50:	48 89 c2             	mov    %rax,%rdx
  801d53:	be 01 00 00 00       	mov    $0x1,%esi
  801d58:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d5d:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7a:	00 
  801d7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d91:	be 00 00 00 00       	mov    $0x0,%esi
  801d96:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d9b:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
}
  801da7:	c9                   	leaveq 
  801da8:	c3                   	retq   

0000000000801da9 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
  801dad:	48 83 ec 30          	sub    $0x30,%rsp
  801db1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dbb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dbf:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dc3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dc6:	48 63 c8             	movslq %eax,%rcx
  801dc9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd0:	48 63 f0             	movslq %eax,%rsi
  801dd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dda:	48 98                	cltq   
  801ddc:	48 89 0c 24          	mov    %rcx,(%rsp)
  801de0:	49 89 f9             	mov    %rdi,%r9
  801de3:	49 89 f0             	mov    %rsi,%r8
  801de6:	48 89 d1             	mov    %rdx,%rcx
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	be 00 00 00 00       	mov    $0x0,%esi
  801df1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801df6:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e02:	c9                   	leaveq 
  801e03:	c3                   	retq   

0000000000801e04 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e04:	55                   	push   %rbp
  801e05:	48 89 e5             	mov    %rsp,%rbp
  801e08:	48 83 ec 20          	sub    $0x20,%rsp
  801e0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e23:	00 
  801e24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e30:	48 89 d1             	mov    %rdx,%rcx
  801e33:	48 89 c2             	mov    %rax,%rdx
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	bf 10 00 00 00       	mov    $0x10,%edi
  801e40:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	callq  *%rax
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 30          	sub    $0x30,%rsp
  801e56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5e:	48 8b 00             	mov    (%rax),%rax
  801e61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e69:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e6d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e73:	83 e0 02             	and    $0x2,%eax
  801e76:	85 c0                	test   %eax,%eax
  801e78:	75 4d                	jne    801ec7 <pgfault+0x79>
  801e7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7e:	48 c1 e8 0c          	shr    $0xc,%rax
  801e82:	48 89 c2             	mov    %rax,%rdx
  801e85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8c:	01 00 00 
  801e8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e93:	25 00 08 00 00       	and    $0x800,%eax
  801e98:	48 85 c0             	test   %rax,%rax
  801e9b:	74 2a                	je     801ec7 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801e9d:	48 ba 58 4b 80 00 00 	movabs $0x804b58,%rdx
  801ea4:	00 00 00 
  801ea7:	be 23 00 00 00       	mov    $0x23,%esi
  801eac:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  801eb3:	00 00 00 
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebb:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801ec2:	00 00 00 
  801ec5:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ec7:	ba 07 00 00 00       	mov    $0x7,%edx
  801ecc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ed1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed6:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  801edd:	00 00 00 
  801ee0:	ff d0                	callq  *%rax
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	0f 85 cd 00 00 00    	jne    801fb7 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef6:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801efc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f04:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f09:	48 89 c6             	mov    %rax,%rsi
  801f0c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f11:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f21:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f27:	48 89 c1             	mov    %rax,%rcx
  801f2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f34:	bf 00 00 00 00       	mov    $0x0,%edi
  801f39:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	callq  *%rax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	79 2a                	jns    801f73 <pgfault+0x125>
				panic("Page map at temp address failed");
  801f49:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  801f50:	00 00 00 
  801f53:	be 30 00 00 00       	mov    $0x30,%esi
  801f58:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  801f5f:	00 00 00 
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
  801f67:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801f6e:	00 00 00 
  801f71:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f73:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f78:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7d:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	79 54                	jns    801fe1 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f8d:	48 ba b8 4b 80 00 00 	movabs $0x804bb8,%rdx
  801f94:	00 00 00 
  801f97:	be 32 00 00 00       	mov    $0x32,%esi
  801f9c:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  801fa3:	00 00 00 
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801fb2:	00 00 00 
  801fb5:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801fb7:	48 ba e0 4b 80 00 00 	movabs $0x804be0,%rdx
  801fbe:	00 00 00 
  801fc1:	be 34 00 00 00       	mov    $0x34,%esi
  801fc6:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  801fcd:	00 00 00 
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801fdc:	00 00 00 
  801fdf:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801fe1:	c9                   	leaveq 
  801fe2:	c3                   	retq   

0000000000801fe3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fe3:	55                   	push   %rbp
  801fe4:	48 89 e5             	mov    %rsp,%rbp
  801fe7:	48 83 ec 20          	sub    $0x20,%rsp
  801feb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fee:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801ff1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ff8:	01 00 00 
  801ffb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ffe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802002:	25 07 0e 00 00       	and    $0xe07,%eax
  802007:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80200a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80200d:	48 c1 e0 0c          	shl    $0xc,%rax
  802011:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	25 00 04 00 00       	and    $0x400,%eax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	74 57                	je     802078 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802021:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802024:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802028:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80202b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202f:	41 89 f0             	mov    %esi,%r8d
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 00 00 00       	mov    $0x0,%edi
  80203a:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	85 c0                	test   %eax,%eax
  802048:	0f 8e 52 01 00 00    	jle    8021a0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80204e:	48 ba 12 4c 80 00 00 	movabs $0x804c12,%rdx
  802055:	00 00 00 
  802058:	be 4e 00 00 00       	mov    $0x4e,%esi
  80205d:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  802064:	00 00 00 
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802073:	00 00 00 
  802076:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207b:	83 e0 02             	and    $0x2,%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 10                	jne    802092 <duppage+0xaf>
  802082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802085:	25 00 08 00 00       	and    $0x800,%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	0f 84 bb 00 00 00    	je     80214d <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802095:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80209a:	80 cc 08             	or     $0x8,%ah
  80209d:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020a3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ae:	41 89 f0             	mov    %esi,%r8d
  8020b1:	48 89 c6             	mov    %rax,%rsi
  8020b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b9:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	callq  *%rax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	7e 2a                	jle    8020f3 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8020c9:	48 ba 12 4c 80 00 00 	movabs $0x804c12,%rdx
  8020d0:	00 00 00 
  8020d3:	be 55 00 00 00       	mov    $0x55,%esi
  8020d8:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  8020df:	00 00 00 
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8020ee:	00 00 00 
  8020f1:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020f3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8020f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fe:	41 89 c8             	mov    %ecx,%r8d
  802101:	48 89 d1             	mov    %rdx,%rcx
  802104:	ba 00 00 00 00       	mov    $0x0,%edx
  802109:	48 89 c6             	mov    %rax,%rsi
  80210c:	bf 00 00 00 00       	mov    $0x0,%edi
  802111:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
  80211d:	85 c0                	test   %eax,%eax
  80211f:	7e 2a                	jle    80214b <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  802121:	48 ba 12 4c 80 00 00 	movabs $0x804c12,%rdx
  802128:	00 00 00 
  80212b:	be 57 00 00 00       	mov    $0x57,%esi
  802130:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  802137:	00 00 00 
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802146:	00 00 00 
  802149:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80214b:	eb 53                	jmp    8021a0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80214d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802150:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802154:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215b:	41 89 f0             	mov    %esi,%r8d
  80215e:	48 89 c6             	mov    %rax,%rsi
  802161:	bf 00 00 00 00       	mov    $0x0,%edi
  802166:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	85 c0                	test   %eax,%eax
  802174:	7e 2a                	jle    8021a0 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802176:	48 ba 12 4c 80 00 00 	movabs $0x804c12,%rdx
  80217d:	00 00 00 
  802180:	be 5b 00 00 00       	mov    $0x5b,%esi
  802185:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  80218c:	00 00 00 
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80219b:	00 00 00 
  80219e:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a5:	c9                   	leaveq 
  8021a6:	c3                   	retq   

00000000008021a7 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
  8021ab:	48 83 ec 18          	sub    $0x18,%rsp
  8021af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8021b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8021bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bf:	48 c1 e8 27          	shr    $0x27,%rax
  8021c3:	48 89 c2             	mov    %rax,%rdx
  8021c6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021cd:	01 00 00 
  8021d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d4:	83 e0 01             	and    $0x1,%eax
  8021d7:	48 85 c0             	test   %rax,%rax
  8021da:	74 51                	je     80222d <pt_is_mapped+0x86>
  8021dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e0:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021e8:	48 89 c2             	mov    %rax,%rdx
  8021eb:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021f2:	01 00 00 
  8021f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f9:	83 e0 01             	and    $0x1,%eax
  8021fc:	48 85 c0             	test   %rax,%rax
  8021ff:	74 2c                	je     80222d <pt_is_mapped+0x86>
  802201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802205:	48 c1 e0 0c          	shl    $0xc,%rax
  802209:	48 c1 e8 15          	shr    $0x15,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	48 85 c0             	test   %rax,%rax
  802224:	74 07                	je     80222d <pt_is_mapped+0x86>
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	eb 05                	jmp    802232 <pt_is_mapped+0x8b>
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	83 e0 01             	and    $0x1,%eax
}
  802235:	c9                   	leaveq 
  802236:	c3                   	retq   

0000000000802237 <fork>:

envid_t
fork(void)
{
  802237:	55                   	push   %rbp
  802238:	48 89 e5             	mov    %rsp,%rbp
  80223b:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80223f:	48 bf 4e 1e 80 00 00 	movabs $0x801e4e,%rdi
  802246:	00 00 00 
  802249:	48 b8 c2 3d 80 00 00 	movabs $0x803dc2,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802255:	b8 07 00 00 00       	mov    $0x7,%eax
  80225a:	cd 30                	int    $0x30
  80225c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80225f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802262:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802269:	79 30                	jns    80229b <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80226b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80226e:	89 c1                	mov    %eax,%ecx
  802270:	48 ba 30 4c 80 00 00 	movabs $0x804c30,%rdx
  802277:	00 00 00 
  80227a:	be 86 00 00 00       	mov    $0x86,%esi
  80227f:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  802286:	00 00 00 
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
  80228e:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  802295:	00 00 00 
  802298:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80229f:	75 3e                	jne    8022df <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8022a1:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022b2:	48 98                	cltq   
  8022b4:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8022bb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022c2:	00 00 00 
  8022c5:	48 01 c2             	add    %rax,%rdx
  8022c8:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8022cf:	00 00 00 
  8022d2:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	e9 d1 01 00 00       	jmpq   8024b0 <fork+0x279>
	}
	uint64_t ad = 0;
  8022df:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022e6:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8022e7:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8022ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022f0:	e9 df 00 00 00       	jmpq   8023d4 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8022f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f9:	48 c1 e8 27          	shr    $0x27,%rax
  8022fd:	48 89 c2             	mov    %rax,%rdx
  802300:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802307:	01 00 00 
  80230a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80230e:	83 e0 01             	and    $0x1,%eax
  802311:	48 85 c0             	test   %rax,%rax
  802314:	0f 84 9e 00 00 00    	je     8023b8 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80231a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802322:	48 89 c2             	mov    %rax,%rdx
  802325:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80232c:	01 00 00 
  80232f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802333:	83 e0 01             	and    $0x1,%eax
  802336:	48 85 c0             	test   %rax,%rax
  802339:	74 73                	je     8023ae <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  80233b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80233f:	48 c1 e8 15          	shr    $0x15,%rax
  802343:	48 89 c2             	mov    %rax,%rdx
  802346:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80234d:	01 00 00 
  802350:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802354:	83 e0 01             	and    $0x1,%eax
  802357:	48 85 c0             	test   %rax,%rax
  80235a:	74 48                	je     8023a4 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80235c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802360:	48 c1 e8 0c          	shr    $0xc,%rax
  802364:	48 89 c2             	mov    %rax,%rdx
  802367:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236e:	01 00 00 
  802371:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802375:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237d:	83 e0 01             	and    $0x1,%eax
  802380:	48 85 c0             	test   %rax,%rax
  802383:	74 47                	je     8023cc <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802389:	48 c1 e8 0c          	shr    $0xc,%rax
  80238d:	89 c2                	mov    %eax,%edx
  80238f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802392:	89 d6                	mov    %edx,%esi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 e3 1f 80 00 00 	movabs $0x801fe3,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	eb 28                	jmp    8023cc <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8023a4:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8023ab:	00 
  8023ac:	eb 1e                	jmp    8023cc <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8023ae:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8023b5:	40 
  8023b6:	eb 14                	jmp    8023cc <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8023b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023bc:	48 c1 e8 27          	shr    $0x27,%rax
  8023c0:	48 83 c0 01          	add    $0x1,%rax
  8023c4:	48 c1 e0 27          	shl    $0x27,%rax
  8023c8:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023cc:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8023d3:	00 
  8023d4:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8023db:	00 
  8023dc:	0f 87 13 ff ff ff    	ja     8022f5 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023e5:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ea:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023ef:	89 c7                	mov    %eax,%edi
  8023f1:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8023fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802400:	ba 07 00 00 00       	mov    $0x7,%edx
  802405:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80240a:	89 c7                	mov    %eax,%edi
  80240c:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  802413:	00 00 00 
  802416:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802418:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80241b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802421:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802426:	ba 00 00 00 00       	mov    $0x0,%edx
  80242b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802430:	89 c7                	mov    %eax,%edi
  802432:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802439:	00 00 00 
  80243c:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80243e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802443:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802448:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80244d:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802459:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80245e:	bf 00 00 00 00       	mov    $0x0,%edi
  802463:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80246f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802476:	00 00 00 
  802479:	48 8b 00             	mov    (%rax),%rax
  80247c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802483:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802486:	48 89 d6             	mov    %rdx,%rsi
  802489:	89 c7                	mov    %eax,%edi
  80248b:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802497:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80249a:	be 02 00 00 00       	mov    $0x2,%esi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax

	return envid;
  8024ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8024b0:	c9                   	leaveq 
  8024b1:	c3                   	retq   

00000000008024b2 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8024b2:	55                   	push   %rbp
  8024b3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8024b6:	48 ba 48 4c 80 00 00 	movabs $0x804c48,%rdx
  8024bd:	00 00 00 
  8024c0:	be bf 00 00 00       	mov    $0xbf,%esi
  8024c5:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  8024cc:	00 00 00 
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8024db:	00 00 00 
  8024de:	ff d1                	callq  *%rcx

00000000008024e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024e0:	55                   	push   %rbp
  8024e1:	48 89 e5             	mov    %rsp,%rbp
  8024e4:	48 83 ec 08          	sub    $0x8,%rsp
  8024e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024f0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024f7:	ff ff ff 
  8024fa:	48 01 d0             	add    %rdx,%rax
  8024fd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802501:	c9                   	leaveq 
  802502:	c3                   	retq   

0000000000802503 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	48 83 ec 08          	sub    $0x8,%rsp
  80250b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80250f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802513:	48 89 c7             	mov    %rax,%rdi
  802516:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802528:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 18          	sub    $0x18,%rsp
  802536:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80253a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802541:	eb 6b                	jmp    8025ae <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802546:	48 98                	cltq   
  802548:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80254e:	48 c1 e0 0c          	shl    $0xc,%rax
  802552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	48 c1 e8 15          	shr    $0x15,%rax
  80255e:	48 89 c2             	mov    %rax,%rdx
  802561:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802568:	01 00 00 
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	83 e0 01             	and    $0x1,%eax
  802572:	48 85 c0             	test   %rax,%rax
  802575:	74 21                	je     802598 <fd_alloc+0x6a>
  802577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257b:	48 c1 e8 0c          	shr    $0xc,%rax
  80257f:	48 89 c2             	mov    %rax,%rdx
  802582:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802589:	01 00 00 
  80258c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802590:	83 e0 01             	and    $0x1,%eax
  802593:	48 85 c0             	test   %rax,%rax
  802596:	75 12                	jne    8025aa <fd_alloc+0x7c>
			*fd_store = fd;
  802598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	eb 1a                	jmp    8025c4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ae:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025b2:	7e 8f                	jle    802543 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025bf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025c4:	c9                   	leaveq 
  8025c5:	c3                   	retq   

00000000008025c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
  8025ca:	48 83 ec 20          	sub    $0x20,%rsp
  8025ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025d9:	78 06                	js     8025e1 <fd_lookup+0x1b>
  8025db:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025df:	7e 07                	jle    8025e8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e6:	eb 6c                	jmp    802654 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025eb:	48 98                	cltq   
  8025ed:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f3:	48 c1 e0 0c          	shl    $0xc,%rax
  8025f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ff:	48 c1 e8 15          	shr    $0x15,%rax
  802603:	48 89 c2             	mov    %rax,%rdx
  802606:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80260d:	01 00 00 
  802610:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802614:	83 e0 01             	and    $0x1,%eax
  802617:	48 85 c0             	test   %rax,%rax
  80261a:	74 21                	je     80263d <fd_lookup+0x77>
  80261c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802620:	48 c1 e8 0c          	shr    $0xc,%rax
  802624:	48 89 c2             	mov    %rax,%rdx
  802627:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80262e:	01 00 00 
  802631:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802635:	83 e0 01             	and    $0x1,%eax
  802638:	48 85 c0             	test   %rax,%rax
  80263b:	75 07                	jne    802644 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80263d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802642:	eb 10                	jmp    802654 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802648:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80264c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 30          	sub    $0x30,%rsp
  80265e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802662:	89 f0                	mov    %esi,%eax
  802664:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266b:	48 89 c7             	mov    %rax,%rdi
  80266e:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80267e:	48 89 d6             	mov    %rdx,%rsi
  802681:	89 c7                	mov    %eax,%edi
  802683:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
  80268f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802692:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802696:	78 0a                	js     8026a2 <fd_close+0x4c>
	    || fd != fd2)
  802698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026a0:	74 12                	je     8026b4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026a2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026a6:	74 05                	je     8026ad <fd_close+0x57>
  8026a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ab:	eb 05                	jmp    8026b2 <fd_close+0x5c>
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	eb 69                	jmp    80271d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b8:	8b 00                	mov    (%rax),%eax
  8026ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026be:	48 89 d6             	mov    %rdx,%rsi
  8026c1:	89 c7                	mov    %eax,%edi
  8026c3:	48 b8 1f 27 80 00 00 	movabs $0x80271f,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	callq  *%rax
  8026cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d6:	78 2a                	js     802702 <fd_close+0xac>
		if (dev->dev_close)
  8026d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026e0:	48 85 c0             	test   %rax,%rax
  8026e3:	74 16                	je     8026fb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026ed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f1:	48 89 d7             	mov    %rdx,%rdi
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f9:	eb 07                	jmp    802702 <fd_close+0xac>
		else
			r = 0;
  8026fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802706:	48 89 c6             	mov    %rax,%rsi
  802709:	bf 00 00 00 00       	mov    $0x0,%edi
  80270e:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
	return r;
  80271a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80271d:	c9                   	leaveq 
  80271e:	c3                   	retq   

000000000080271f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80271f:	55                   	push   %rbp
  802720:	48 89 e5             	mov    %rsp,%rbp
  802723:	48 83 ec 20          	sub    $0x20,%rsp
  802727:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80272a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80272e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802735:	eb 41                	jmp    802778 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802737:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80273e:	00 00 00 
  802741:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802744:	48 63 d2             	movslq %edx,%rdx
  802747:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274b:	8b 00                	mov    (%rax),%eax
  80274d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802750:	75 22                	jne    802774 <dev_lookup+0x55>
			*dev = devtab[i];
  802752:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802759:	00 00 00 
  80275c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80275f:	48 63 d2             	movslq %edx,%rdx
  802762:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80276a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80276d:	b8 00 00 00 00       	mov    $0x0,%eax
  802772:	eb 60                	jmp    8027d4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802774:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802778:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80277f:	00 00 00 
  802782:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802785:	48 63 d2             	movslq %edx,%rdx
  802788:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278c:	48 85 c0             	test   %rax,%rax
  80278f:	75 a6                	jne    802737 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802791:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802798:	00 00 00 
  80279b:	48 8b 00             	mov    (%rax),%rax
  80279e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027a7:	89 c6                	mov    %eax,%esi
  8027a9:	48 bf 60 4c 80 00 00 	movabs $0x804c60,%rdi
  8027b0:	00 00 00 
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  8027bf:	00 00 00 
  8027c2:	ff d1                	callq  *%rcx
	*dev = 0;
  8027c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027d4:	c9                   	leaveq 
  8027d5:	c3                   	retq   

00000000008027d6 <close>:

int
close(int fdnum)
{
  8027d6:	55                   	push   %rbp
  8027d7:	48 89 e5             	mov    %rsp,%rbp
  8027da:	48 83 ec 20          	sub    $0x20,%rsp
  8027de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e8:	48 89 d6             	mov    %rdx,%rsi
  8027eb:	89 c7                	mov    %eax,%edi
  8027ed:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
  8027f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802800:	79 05                	jns    802807 <close+0x31>
		return r;
  802802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802805:	eb 18                	jmp    80281f <close+0x49>
	else
		return fd_close(fd, 1);
  802807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280b:	be 01 00 00 00       	mov    $0x1,%esi
  802810:	48 89 c7             	mov    %rax,%rdi
  802813:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
}
  80281f:	c9                   	leaveq 
  802820:	c3                   	retq   

0000000000802821 <close_all>:

void
close_all(void)
{
  802821:	55                   	push   %rbp
  802822:	48 89 e5             	mov    %rsp,%rbp
  802825:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802830:	eb 15                	jmp    802847 <close_all+0x26>
		close(i);
  802832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802835:	89 c7                	mov    %eax,%edi
  802837:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802843:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802847:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80284b:	7e e5                	jle    802832 <close_all+0x11>
		close(i);
}
  80284d:	c9                   	leaveq 
  80284e:	c3                   	retq   

000000000080284f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80284f:	55                   	push   %rbp
  802850:	48 89 e5             	mov    %rsp,%rbp
  802853:	48 83 ec 40          	sub    $0x40,%rsp
  802857:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80285a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80285d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802861:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802864:	48 89 d6             	mov    %rdx,%rsi
  802867:	89 c7                	mov    %eax,%edi
  802869:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
  802875:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802878:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287c:	79 08                	jns    802886 <dup+0x37>
		return r;
  80287e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802881:	e9 70 01 00 00       	jmpq   8029f6 <dup+0x1a7>
	close(newfdnum);
  802886:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802889:	89 c7                	mov    %eax,%edi
  80288b:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802897:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80289a:	48 98                	cltq   
  80289c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8028a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ae:	48 89 c7             	mov    %rax,%rdi
  8028b1:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c5:	48 89 c7             	mov    %rax,%rdi
  8028c8:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	callq  *%rax
  8028d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dc:	48 c1 e8 15          	shr    $0x15,%rax
  8028e0:	48 89 c2             	mov    %rax,%rdx
  8028e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028ea:	01 00 00 
  8028ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f1:	83 e0 01             	and    $0x1,%eax
  8028f4:	48 85 c0             	test   %rax,%rax
  8028f7:	74 73                	je     80296c <dup+0x11d>
  8028f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802901:	48 89 c2             	mov    %rax,%rdx
  802904:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290b:	01 00 00 
  80290e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802912:	83 e0 01             	and    $0x1,%eax
  802915:	48 85 c0             	test   %rax,%rax
  802918:	74 52                	je     80296c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80291a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291e:	48 c1 e8 0c          	shr    $0xc,%rax
  802922:	48 89 c2             	mov    %rax,%rdx
  802925:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80292c:	01 00 00 
  80292f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802933:	25 07 0e 00 00       	and    $0xe07,%eax
  802938:	89 c1                	mov    %eax,%ecx
  80293a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80293e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802942:	41 89 c8             	mov    %ecx,%r8d
  802945:	48 89 d1             	mov    %rdx,%rcx
  802948:	ba 00 00 00 00       	mov    $0x0,%edx
  80294d:	48 89 c6             	mov    %rax,%rsi
  802950:	bf 00 00 00 00       	mov    $0x0,%edi
  802955:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
  802961:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802964:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802968:	79 02                	jns    80296c <dup+0x11d>
			goto err;
  80296a:	eb 57                	jmp    8029c3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80296c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802970:	48 c1 e8 0c          	shr    $0xc,%rax
  802974:	48 89 c2             	mov    %rax,%rdx
  802977:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80297e:	01 00 00 
  802981:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802985:	25 07 0e 00 00       	and    $0xe07,%eax
  80298a:	89 c1                	mov    %eax,%ecx
  80298c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802990:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802994:	41 89 c8             	mov    %ecx,%r8d
  802997:	48 89 d1             	mov    %rdx,%rcx
  80299a:	ba 00 00 00 00       	mov    $0x0,%edx
  80299f:	48 89 c6             	mov    %rax,%rsi
  8029a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a7:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
  8029b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ba:	79 02                	jns    8029be <dup+0x16f>
		goto err;
  8029bc:	eb 05                	jmp    8029c3 <dup+0x174>

	return newfdnum;
  8029be:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c1:	eb 33                	jmp    8029f6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c7:	48 89 c6             	mov    %rax,%rsi
  8029ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8029cf:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029df:	48 89 c6             	mov    %rax,%rsi
  8029e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e7:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
	return r;
  8029f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	48 83 ec 40          	sub    $0x40,%rsp
  802a00:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a07:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a0b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a0f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a12:	48 89 d6             	mov    %rdx,%rsi
  802a15:	89 c7                	mov    %eax,%edi
  802a17:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2a:	78 24                	js     802a50 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a30:	8b 00                	mov    (%rax),%eax
  802a32:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a36:	48 89 d6             	mov    %rdx,%rsi
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 1f 27 80 00 00 	movabs $0x80271f,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
  802a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4e:	79 05                	jns    802a55 <read+0x5d>
		return r;
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 76                	jmp    802acb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a59:	8b 40 08             	mov    0x8(%rax),%eax
  802a5c:	83 e0 03             	and    $0x3,%eax
  802a5f:	83 f8 01             	cmp    $0x1,%eax
  802a62:	75 3a                	jne    802a9e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a64:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a6b:	00 00 00 
  802a6e:	48 8b 00             	mov    (%rax),%rax
  802a71:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a77:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a7a:	89 c6                	mov    %eax,%esi
  802a7c:	48 bf 7f 4c 80 00 00 	movabs $0x804c7f,%rdi
  802a83:	00 00 00 
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8b:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802a92:	00 00 00 
  802a95:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a9c:	eb 2d                	jmp    802acb <read+0xd3>
	}
	if (!dev->dev_read)
  802a9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa6:	48 85 c0             	test   %rax,%rax
  802aa9:	75 07                	jne    802ab2 <read+0xba>
		return -E_NOT_SUPP;
  802aab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab0:	eb 19                	jmp    802acb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ab2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802abe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ac6:	48 89 cf             	mov    %rcx,%rdi
  802ac9:	ff d0                	callq  *%rax
}
  802acb:	c9                   	leaveq 
  802acc:	c3                   	retq   

0000000000802acd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802acd:	55                   	push   %rbp
  802ace:	48 89 e5             	mov    %rsp,%rbp
  802ad1:	48 83 ec 30          	sub    $0x30,%rsp
  802ad5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ad8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802adc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae7:	eb 49                	jmp    802b32 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aec:	48 98                	cltq   
  802aee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af2:	48 29 c2             	sub    %rax,%rdx
  802af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af8:	48 63 c8             	movslq %eax,%rcx
  802afb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aff:	48 01 c1             	add    %rax,%rcx
  802b02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b05:	48 89 ce             	mov    %rcx,%rsi
  802b08:	89 c7                	mov    %eax,%edi
  802b0a:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
  802b16:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b19:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b1d:	79 05                	jns    802b24 <readn+0x57>
			return m;
  802b1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b22:	eb 1c                	jmp    802b40 <readn+0x73>
		if (m == 0)
  802b24:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b28:	75 02                	jne    802b2c <readn+0x5f>
			break;
  802b2a:	eb 11                	jmp    802b3d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b2f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b35:	48 98                	cltq   
  802b37:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b3b:	72 ac                	jb     802ae9 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b40:	c9                   	leaveq 
  802b41:	c3                   	retq   

0000000000802b42 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b42:	55                   	push   %rbp
  802b43:	48 89 e5             	mov    %rsp,%rbp
  802b46:	48 83 ec 40          	sub    $0x40,%rsp
  802b4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b55:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b5c:	48 89 d6             	mov    %rdx,%rsi
  802b5f:	89 c7                	mov    %eax,%edi
  802b61:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
  802b6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b74:	78 24                	js     802b9a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7a:	8b 00                	mov    (%rax),%eax
  802b7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b80:	48 89 d6             	mov    %rdx,%rsi
  802b83:	89 c7                	mov    %eax,%edi
  802b85:	48 b8 1f 27 80 00 00 	movabs $0x80271f,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	79 05                	jns    802b9f <write+0x5d>
		return r;
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	eb 42                	jmp    802be1 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba3:	8b 40 08             	mov    0x8(%rax),%eax
  802ba6:	83 e0 03             	and    $0x3,%eax
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	75 07                	jne    802bb4 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb2:	eb 2d                	jmp    802be1 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bbc:	48 85 c0             	test   %rax,%rax
  802bbf:	75 07                	jne    802bc8 <write+0x86>
		return -E_NOT_SUPP;
  802bc1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc6:	eb 19                	jmp    802be1 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcc:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bd0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bd4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bdc:	48 89 cf             	mov    %rcx,%rdi
  802bdf:	ff d0                	callq  *%rax
}
  802be1:	c9                   	leaveq 
  802be2:	c3                   	retq   

0000000000802be3 <seek>:

int
seek(int fdnum, off_t offset)
{
  802be3:	55                   	push   %rbp
  802be4:	48 89 e5             	mov    %rsp,%rbp
  802be7:	48 83 ec 18          	sub    $0x18,%rsp
  802beb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bee:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bf1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf8:	48 89 d6             	mov    %rdx,%rsi
  802bfb:	89 c7                	mov    %eax,%edi
  802bfd:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax
  802c09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c10:	79 05                	jns    802c17 <seek+0x34>
		return r;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	eb 0f                	jmp    802c26 <seek+0x43>
	fd->fd_offset = offset;
  802c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c1e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c26:	c9                   	leaveq 
  802c27:	c3                   	retq   

0000000000802c28 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 30          	sub    $0x30,%rsp
  802c30:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c33:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c36:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c3d:	48 89 d6             	mov    %rdx,%rsi
  802c40:	89 c7                	mov    %eax,%edi
  802c42:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
  802c4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c55:	78 24                	js     802c7b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5b:	8b 00                	mov    (%rax),%eax
  802c5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c61:	48 89 d6             	mov    %rdx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 1f 27 80 00 00 	movabs $0x80271f,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c79:	79 05                	jns    802c80 <ftruncate+0x58>
		return r;
  802c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7e:	eb 72                	jmp    802cf2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c84:	8b 40 08             	mov    0x8(%rax),%eax
  802c87:	83 e0 03             	and    $0x3,%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	75 3a                	jne    802cc8 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c8e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802c95:	00 00 00 
  802c98:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c9b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ca1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ca4:	89 c6                	mov    %eax,%esi
  802ca6:	48 bf a0 4c 80 00 00 	movabs $0x804ca0,%rdi
  802cad:	00 00 00 
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802cbc:	00 00 00 
  802cbf:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cc6:	eb 2a                	jmp    802cf2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccc:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cd0:	48 85 c0             	test   %rax,%rax
  802cd3:	75 07                	jne    802cdc <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cd5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cda:	eb 16                	jmp    802cf2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce0:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ce4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ce8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ceb:	89 ce                	mov    %ecx,%esi
  802ced:	48 89 d7             	mov    %rdx,%rdi
  802cf0:	ff d0                	callq  *%rax
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 30          	sub    $0x30,%rsp
  802cfc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d0a:	48 89 d6             	mov    %rdx,%rsi
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
  802d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d22:	78 24                	js     802d48 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d28:	8b 00                	mov    (%rax),%eax
  802d2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2e:	48 89 d6             	mov    %rdx,%rsi
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	48 b8 1f 27 80 00 00 	movabs $0x80271f,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
  802d3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d46:	79 05                	jns    802d4d <fstat+0x59>
		return r;
  802d48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4b:	eb 5e                	jmp    802dab <fstat+0xb7>
	if (!dev->dev_stat)
  802d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d51:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d55:	48 85 c0             	test   %rax,%rax
  802d58:	75 07                	jne    802d61 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d5a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d5f:	eb 4a                	jmp    802dab <fstat+0xb7>
	stat->st_name[0] = 0;
  802d61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d65:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d6c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d73:	00 00 00 
	stat->st_isdir = 0;
  802d76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d81:	00 00 00 
	stat->st_dev = dev;
  802d84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d8c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d97:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d9f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802da3:	48 89 ce             	mov    %rcx,%rsi
  802da6:	48 89 d7             	mov    %rdx,%rdi
  802da9:	ff d0                	callq  *%rax
}
  802dab:	c9                   	leaveq 
  802dac:	c3                   	retq   

0000000000802dad <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dad:	55                   	push   %rbp
  802dae:	48 89 e5             	mov    %rsp,%rbp
  802db1:	48 83 ec 20          	sub    $0x20,%rsp
  802db5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc1:	be 00 00 00 00       	mov    $0x0,%esi
  802dc6:	48 89 c7             	mov    %rax,%rdi
  802dc9:	48 b8 9b 2e 80 00 00 	movabs $0x802e9b,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
  802dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddc:	79 05                	jns    802de3 <stat+0x36>
		return fd;
  802dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de1:	eb 2f                	jmp    802e12 <stat+0x65>
	r = fstat(fd, stat);
  802de3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dea:	48 89 d6             	mov    %rdx,%rsi
  802ded:	89 c7                	mov    %eax,%edi
  802def:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e01:	89 c7                	mov    %eax,%edi
  802e03:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
	return r;
  802e0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e12:	c9                   	leaveq 
  802e13:	c3                   	retq   

0000000000802e14 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e14:	55                   	push   %rbp
  802e15:	48 89 e5             	mov    %rsp,%rbp
  802e18:	48 83 ec 10          	sub    $0x10,%rsp
  802e1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e23:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e2a:	00 00 00 
  802e2d:	8b 00                	mov    (%rax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	75 1d                	jne    802e50 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e33:	bf 01 00 00 00       	mov    $0x1,%edi
  802e38:	48 b8 cd 43 80 00 00 	movabs $0x8043cd,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e4b:	00 00 00 
  802e4e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e50:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e57:	00 00 00 
  802e5a:	8b 00                	mov    (%rax),%eax
  802e5c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e5f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e64:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e6b:	00 00 00 
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e80:	ba 00 00 00 00       	mov    $0x0,%edx
  802e85:	48 89 c6             	mov    %rax,%rsi
  802e88:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8d:	48 b8 02 3f 80 00 00 	movabs $0x803f02,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
}
  802e99:	c9                   	leaveq 
  802e9a:	c3                   	retq   

0000000000802e9b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e9b:	55                   	push   %rbp
  802e9c:	48 89 e5             	mov    %rsp,%rbp
  802e9f:	48 83 ec 30          	sub    $0x30,%rsp
  802ea3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ea7:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802eaa:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802eb1:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ebf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ec4:	75 08                	jne    802ece <open+0x33>
	{
		return r;
  802ec6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec9:	e9 f2 00 00 00       	jmpq   802fc0 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ece:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed2:	48 89 c7             	mov    %rax,%rdi
  802ed5:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
  802ee1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ee4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802eeb:	7e 0a                	jle    802ef7 <open+0x5c>
	{
		return -E_BAD_PATH;
  802eed:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ef2:	e9 c9 00 00 00       	jmpq   802fc0 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ef7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802efe:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802eff:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f03:	48 89 c7             	mov    %rax,%rdi
  802f06:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
  802f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f19:	78 09                	js     802f24 <open+0x89>
  802f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1f:	48 85 c0             	test   %rax,%rax
  802f22:	75 08                	jne    802f2c <open+0x91>
		{
			return r;
  802f24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f27:	e9 94 00 00 00       	jmpq   802fc0 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f30:	ba 00 04 00 00       	mov    $0x400,%edx
  802f35:	48 89 c6             	mov    %rax,%rsi
  802f38:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f3f:	00 00 00 
  802f42:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f4e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f55:	00 00 00 
  802f58:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f5b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f65:	48 89 c6             	mov    %rax,%rsi
  802f68:	bf 01 00 00 00       	mov    $0x1,%edi
  802f6d:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f80:	79 2b                	jns    802fad <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f86:	be 00 00 00 00       	mov    $0x0,%esi
  802f8b:	48 89 c7             	mov    %rax,%rdi
  802f8e:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f9d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fa1:	79 05                	jns    802fa8 <open+0x10d>
			{
				return d;
  802fa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa6:	eb 18                	jmp    802fc0 <open+0x125>
			}
			return r;
  802fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fab:	eb 13                	jmp    802fc0 <open+0x125>
		}	
		return fd2num(fd_store);
  802fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb1:	48 89 c7             	mov    %rax,%rdi
  802fb4:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  802fbb:	00 00 00 
  802fbe:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802fc0:	c9                   	leaveq 
  802fc1:	c3                   	retq   

0000000000802fc2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fc2:	55                   	push   %rbp
  802fc3:	48 89 e5             	mov    %rsp,%rbp
  802fc6:	48 83 ec 10          	sub    $0x10,%rsp
  802fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd2:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdc:	00 00 00 
  802fdf:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fe1:	be 00 00 00 00       	mov    $0x0,%esi
  802fe6:	bf 06 00 00 00       	mov    $0x6,%edi
  802feb:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
}
  802ff7:	c9                   	leaveq 
  802ff8:	c3                   	retq   

0000000000802ff9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ff9:	55                   	push   %rbp
  802ffa:	48 89 e5             	mov    %rsp,%rbp
  802ffd:	48 83 ec 30          	sub    $0x30,%rsp
  803001:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803005:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803009:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80300d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803014:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803019:	74 07                	je     803022 <devfile_read+0x29>
  80301b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803020:	75 07                	jne    803029 <devfile_read+0x30>
		return -E_INVAL;
  803022:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803027:	eb 77                	jmp    8030a0 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302d:	8b 50 0c             	mov    0xc(%rax),%edx
  803030:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803037:	00 00 00 
  80303a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80303c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803043:	00 00 00 
  803046:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80304a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80304e:	be 00 00 00 00       	mov    $0x0,%esi
  803053:	bf 03 00 00 00       	mov    $0x3,%edi
  803058:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  80305f:	00 00 00 
  803062:	ff d0                	callq  *%rax
  803064:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803067:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306b:	7f 05                	jg     803072 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80306d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803070:	eb 2e                	jmp    8030a0 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	48 63 d0             	movslq %eax,%rdx
  803078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80307c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803083:	00 00 00 
  803086:	48 89 c7             	mov    %rax,%rdi
  803089:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  803090:	00 00 00 
  803093:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803095:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803099:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80309d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 30          	sub    $0x30,%rsp
  8030aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8030b6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8030bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030c2:	74 07                	je     8030cb <devfile_write+0x29>
  8030c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030c9:	75 08                	jne    8030d3 <devfile_write+0x31>
		return r;
  8030cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ce:	e9 9a 00 00 00       	jmpq   80316d <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8030da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e1:	00 00 00 
  8030e4:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8030e6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030ed:	00 
  8030ee:	76 08                	jbe    8030f8 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8030f0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030f7:	00 
	}
	fsipcbuf.write.req_n = n;
  8030f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ff:	00 00 00 
  803102:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803106:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80310a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80310e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803112:	48 89 c6             	mov    %rax,%rsi
  803115:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80311c:	00 00 00 
  80311f:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80312b:	be 00 00 00 00       	mov    $0x0,%esi
  803130:	bf 04 00 00 00       	mov    $0x4,%edi
  803135:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  80313c:	00 00 00 
  80313f:	ff d0                	callq  *%rax
  803141:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803144:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803148:	7f 20                	jg     80316a <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80314a:	48 bf c6 4c 80 00 00 	movabs $0x804cc6,%rdi
  803151:	00 00 00 
  803154:	b8 00 00 00 00       	mov    $0x0,%eax
  803159:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  803160:	00 00 00 
  803163:	ff d2                	callq  *%rdx
		return r;
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	eb 03                	jmp    80316d <devfile_write+0xcb>
	}
	return r;
  80316a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80316d:	c9                   	leaveq 
  80316e:	c3                   	retq   

000000000080316f <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80316f:	55                   	push   %rbp
  803170:	48 89 e5             	mov    %rsp,%rbp
  803173:	48 83 ec 20          	sub    $0x20,%rsp
  803177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80317b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80317f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803183:	8b 50 0c             	mov    0xc(%rax),%edx
  803186:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318d:	00 00 00 
  803190:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803192:	be 00 00 00 00       	mov    $0x0,%esi
  803197:	bf 05 00 00 00       	mov    $0x5,%edi
  80319c:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8031a3:	00 00 00 
  8031a6:	ff d0                	callq  *%rax
  8031a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031af:	79 05                	jns    8031b6 <devfile_stat+0x47>
		return r;
  8031b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b4:	eb 56                	jmp    80320c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ba:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031c1:	00 00 00 
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031da:	00 00 00 
  8031dd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031ed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f4:	00 00 00 
  8031f7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803201:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80320c:	c9                   	leaveq 
  80320d:	c3                   	retq   

000000000080320e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80320e:	55                   	push   %rbp
  80320f:	48 89 e5             	mov    %rsp,%rbp
  803212:	48 83 ec 10          	sub    $0x10,%rsp
  803216:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80321a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80321d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803221:	8b 50 0c             	mov    0xc(%rax),%edx
  803224:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80322b:	00 00 00 
  80322e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803230:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803237:	00 00 00 
  80323a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803240:	be 00 00 00 00       	mov    $0x0,%esi
  803245:	bf 02 00 00 00       	mov    $0x2,%edi
  80324a:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
}
  803256:	c9                   	leaveq 
  803257:	c3                   	retq   

0000000000803258 <remove>:

// Delete a file
int
remove(const char *path)
{
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	48 83 ec 10          	sub    $0x10,%rsp
  803260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80327c:	7e 07                	jle    803285 <remove+0x2d>
		return -E_BAD_PATH;
  80327e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803283:	eb 33                	jmp    8032b8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803289:	48 89 c6             	mov    %rax,%rsi
  80328c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803293:	00 00 00 
  803296:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  80329d:	00 00 00 
  8032a0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032a2:	be 00 00 00 00       	mov    $0x0,%esi
  8032a7:	bf 07 00 00 00       	mov    $0x7,%edi
  8032ac:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
}
  8032b8:	c9                   	leaveq 
  8032b9:	c3                   	retq   

00000000008032ba <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032ba:	55                   	push   %rbp
  8032bb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032be:	be 00 00 00 00       	mov    $0x0,%esi
  8032c3:	bf 08 00 00 00       	mov    $0x8,%edi
  8032c8:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
}
  8032d4:	5d                   	pop    %rbp
  8032d5:	c3                   	retq   

00000000008032d6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032d6:	55                   	push   %rbp
  8032d7:	48 89 e5             	mov    %rsp,%rbp
  8032da:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032e1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032e8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032ef:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032f6:	be 00 00 00 00       	mov    $0x0,%esi
  8032fb:	48 89 c7             	mov    %rax,%rdi
  8032fe:	48 b8 9b 2e 80 00 00 	movabs $0x802e9b,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
  80330a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80330d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803311:	79 28                	jns    80333b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803316:	89 c6                	mov    %eax,%esi
  803318:	48 bf e2 4c 80 00 00 	movabs $0x804ce2,%rdi
  80331f:	00 00 00 
  803322:	b8 00 00 00 00       	mov    $0x0,%eax
  803327:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80332e:	00 00 00 
  803331:	ff d2                	callq  *%rdx
		return fd_src;
  803333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803336:	e9 74 01 00 00       	jmpq   8034af <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80333b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803342:	be 01 01 00 00       	mov    $0x101,%esi
  803347:	48 89 c7             	mov    %rax,%rdi
  80334a:	48 b8 9b 2e 80 00 00 	movabs $0x802e9b,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
  803356:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803359:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80335d:	79 39                	jns    803398 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80335f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803362:	89 c6                	mov    %eax,%esi
  803364:	48 bf f8 4c 80 00 00 	movabs $0x804cf8,%rdi
  80336b:	00 00 00 
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80337a:	00 00 00 
  80337d:	ff d2                	callq  *%rdx
		close(fd_src);
  80337f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803382:	89 c7                	mov    %eax,%edi
  803384:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
		return fd_dest;
  803390:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803393:	e9 17 01 00 00       	jmpq   8034af <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803398:	eb 74                	jmp    80340e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80339a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80339d:	48 63 d0             	movslq %eax,%rdx
  8033a0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033aa:	48 89 ce             	mov    %rcx,%rsi
  8033ad:	89 c7                	mov    %eax,%edi
  8033af:	48 b8 42 2b 80 00 00 	movabs $0x802b42,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033be:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033c2:	79 4a                	jns    80340e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033c4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033c7:	89 c6                	mov    %eax,%esi
  8033c9:	48 bf 12 4d 80 00 00 	movabs $0x804d12,%rdi
  8033d0:	00 00 00 
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d8:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8033df:	00 00 00 
  8033e2:	ff d2                	callq  *%rdx
			close(fd_src);
  8033e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e7:	89 c7                	mov    %eax,%edi
  8033e9:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
			close(fd_dest);
  8033f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033f8:	89 c7                	mov    %eax,%edi
  8033fa:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
			return write_size;
  803406:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803409:	e9 a1 00 00 00       	jmpq   8034af <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80340e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803418:	ba 00 02 00 00       	mov    $0x200,%edx
  80341d:	48 89 ce             	mov    %rcx,%rsi
  803420:	89 c7                	mov    %eax,%edi
  803422:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
  80342e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803431:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803435:	0f 8f 5f ff ff ff    	jg     80339a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80343b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80343f:	79 47                	jns    803488 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803441:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803444:	89 c6                	mov    %eax,%esi
  803446:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  80344d:	00 00 00 
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
  803455:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80345c:	00 00 00 
  80345f:	ff d2                	callq  *%rdx
		close(fd_src);
  803461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803464:	89 c7                	mov    %eax,%edi
  803466:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
		close(fd_dest);
  803472:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803475:	89 c7                	mov    %eax,%edi
  803477:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
		return read_size;
  803483:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803486:	eb 27                	jmp    8034af <copy+0x1d9>
	}
	close(fd_src);
  803488:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
	close(fd_dest);
  803499:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80349c:	89 c7                	mov    %eax,%edi
  80349e:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
	return 0;
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034af:	c9                   	leaveq 
  8034b0:	c3                   	retq   

00000000008034b1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034b1:	55                   	push   %rbp
  8034b2:	48 89 e5             	mov    %rsp,%rbp
  8034b5:	53                   	push   %rbx
  8034b6:	48 83 ec 38          	sub    $0x38,%rsp
  8034ba:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034be:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034c2:	48 89 c7             	mov    %rax,%rdi
  8034c5:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
  8034d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d8:	0f 88 bf 01 00 00    	js     80369d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e2:	ba 07 04 00 00       	mov    $0x407,%edx
  8034e7:	48 89 c6             	mov    %rax,%rsi
  8034ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ef:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
  8034fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803502:	0f 88 95 01 00 00    	js     80369d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803508:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80350c:	48 89 c7             	mov    %rax,%rdi
  80350f:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  803516:	00 00 00 
  803519:	ff d0                	callq  *%rax
  80351b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80351e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803522:	0f 88 5d 01 00 00    	js     803685 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803528:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80352c:	ba 07 04 00 00       	mov    $0x407,%edx
  803531:	48 89 c6             	mov    %rax,%rsi
  803534:	bf 00 00 00 00       	mov    $0x0,%edi
  803539:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803548:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80354c:	0f 88 33 01 00 00    	js     803685 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803556:	48 89 c7             	mov    %rax,%rdi
  803559:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
  803565:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803569:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356d:	ba 07 04 00 00       	mov    $0x407,%edx
  803572:	48 89 c6             	mov    %rax,%rsi
  803575:	bf 00 00 00 00       	mov    $0x0,%edi
  80357a:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803589:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80358d:	79 05                	jns    803594 <pipe+0xe3>
		goto err2;
  80358f:	e9 d9 00 00 00       	jmpq   80366d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803594:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803598:	48 89 c7             	mov    %rax,%rdi
  80359b:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
  8035a7:	48 89 c2             	mov    %rax,%rdx
  8035aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ae:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035b4:	48 89 d1             	mov    %rdx,%rcx
  8035b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8035bc:	48 89 c6             	mov    %rax,%rsi
  8035bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c4:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
  8035d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d7:	79 1b                	jns    8035f4 <pipe+0x143>
		goto err3;
  8035d9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035de:	48 89 c6             	mov    %rax,%rsi
  8035e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e6:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	eb 79                	jmp    80366d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035ff:	00 00 00 
  803602:	8b 12                	mov    (%rdx),%edx
  803604:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803611:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803615:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80361c:	00 00 00 
  80361f:	8b 12                	mov    (%rdx),%edx
  803621:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803623:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803627:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80362e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803632:	48 89 c7             	mov    %rax,%rdi
  803635:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
  803641:	89 c2                	mov    %eax,%edx
  803643:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803647:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803649:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80364d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803651:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803655:	48 89 c7             	mov    %rax,%rdi
  803658:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
  803664:	89 03                	mov    %eax,(%rbx)
	return 0;
  803666:	b8 00 00 00 00       	mov    $0x0,%eax
  80366b:	eb 33                	jmp    8036a0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80366d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803671:	48 89 c6             	mov    %rax,%rsi
  803674:	bf 00 00 00 00       	mov    $0x0,%edi
  803679:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803680:	00 00 00 
  803683:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803689:	48 89 c6             	mov    %rax,%rsi
  80368c:	bf 00 00 00 00       	mov    $0x0,%edi
  803691:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803698:	00 00 00 
  80369b:	ff d0                	callq  *%rax
err:
	return r;
  80369d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036a0:	48 83 c4 38          	add    $0x38,%rsp
  8036a4:	5b                   	pop    %rbx
  8036a5:	5d                   	pop    %rbp
  8036a6:	c3                   	retq   

00000000008036a7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036a7:	55                   	push   %rbp
  8036a8:	48 89 e5             	mov    %rsp,%rbp
  8036ab:	53                   	push   %rbx
  8036ac:	48 83 ec 28          	sub    $0x28,%rsp
  8036b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036b8:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8036bf:	00 00 00 
  8036c2:	48 8b 00             	mov    (%rax),%rax
  8036c5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d2:	48 89 c7             	mov    %rax,%rdi
  8036d5:	48 b8 3f 44 80 00 00 	movabs $0x80443f,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	89 c3                	mov    %eax,%ebx
  8036e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e7:	48 89 c7             	mov    %rax,%rdi
  8036ea:	48 b8 3f 44 80 00 00 	movabs $0x80443f,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
  8036f6:	39 c3                	cmp    %eax,%ebx
  8036f8:	0f 94 c0             	sete   %al
  8036fb:	0f b6 c0             	movzbl %al,%eax
  8036fe:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803701:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803708:	00 00 00 
  80370b:	48 8b 00             	mov    (%rax),%rax
  80370e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803714:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803717:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80371d:	75 05                	jne    803724 <_pipeisclosed+0x7d>
			return ret;
  80371f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803722:	eb 4f                	jmp    803773 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803727:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80372a:	74 42                	je     80376e <_pipeisclosed+0xc7>
  80372c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803730:	75 3c                	jne    80376e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803732:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803739:	00 00 00 
  80373c:	48 8b 00             	mov    (%rax),%rax
  80373f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803745:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803748:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374b:	89 c6                	mov    %eax,%esi
  80374d:	48 bf 45 4d 80 00 00 	movabs $0x804d45,%rdi
  803754:	00 00 00 
  803757:	b8 00 00 00 00       	mov    $0x0,%eax
  80375c:	49 b8 1a 06 80 00 00 	movabs $0x80061a,%r8
  803763:	00 00 00 
  803766:	41 ff d0             	callq  *%r8
	}
  803769:	e9 4a ff ff ff       	jmpq   8036b8 <_pipeisclosed+0x11>
  80376e:	e9 45 ff ff ff       	jmpq   8036b8 <_pipeisclosed+0x11>
}
  803773:	48 83 c4 28          	add    $0x28,%rsp
  803777:	5b                   	pop    %rbx
  803778:	5d                   	pop    %rbp
  803779:	c3                   	retq   

000000000080377a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80377a:	55                   	push   %rbp
  80377b:	48 89 e5             	mov    %rsp,%rbp
  80377e:	48 83 ec 30          	sub    $0x30,%rsp
  803782:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803785:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803789:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80378c:	48 89 d6             	mov    %rdx,%rsi
  80378f:	89 c7                	mov    %eax,%edi
  803791:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a4:	79 05                	jns    8037ab <pipeisclosed+0x31>
		return r;
  8037a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a9:	eb 31                	jmp    8037dc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037af:	48 89 c7             	mov    %rax,%rdi
  8037b2:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
  8037be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037ca:	48 89 d6             	mov    %rdx,%rsi
  8037cd:	48 89 c7             	mov    %rax,%rdi
  8037d0:	48 b8 a7 36 80 00 00 	movabs $0x8036a7,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
}
  8037dc:	c9                   	leaveq 
  8037dd:	c3                   	retq   

00000000008037de <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037de:	55                   	push   %rbp
  8037df:	48 89 e5             	mov    %rsp,%rbp
  8037e2:	48 83 ec 40          	sub    $0x40,%rsp
  8037e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f6:	48 89 c7             	mov    %rax,%rdi
  8037f9:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
  803805:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803809:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803811:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803818:	00 
  803819:	e9 92 00 00 00       	jmpq   8038b0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80381e:	eb 41                	jmp    803861 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803820:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803825:	74 09                	je     803830 <devpipe_read+0x52>
				return i;
  803827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382b:	e9 92 00 00 00       	jmpq   8038c2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803830:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803838:	48 89 d6             	mov    %rdx,%rsi
  80383b:	48 89 c7             	mov    %rax,%rdi
  80383e:	48 b8 a7 36 80 00 00 	movabs $0x8036a7,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	74 07                	je     803855 <devpipe_read+0x77>
				return 0;
  80384e:	b8 00 00 00 00       	mov    $0x0,%eax
  803853:	eb 6d                	jmp    8038c2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803855:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803865:	8b 10                	mov    (%rax),%edx
  803867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386b:	8b 40 04             	mov    0x4(%rax),%eax
  80386e:	39 c2                	cmp    %eax,%edx
  803870:	74 ae                	je     803820 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80387a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80387e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803882:	8b 00                	mov    (%rax),%eax
  803884:	99                   	cltd   
  803885:	c1 ea 1b             	shr    $0x1b,%edx
  803888:	01 d0                	add    %edx,%eax
  80388a:	83 e0 1f             	and    $0x1f,%eax
  80388d:	29 d0                	sub    %edx,%eax
  80388f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803893:	48 98                	cltq   
  803895:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80389a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80389c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a0:	8b 00                	mov    (%rax),%eax
  8038a2:	8d 50 01             	lea    0x1(%rax),%edx
  8038a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038b8:	0f 82 60 ff ff ff    	jb     80381e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038c2:	c9                   	leaveq 
  8038c3:	c3                   	retq   

00000000008038c4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038c4:	55                   	push   %rbp
  8038c5:	48 89 e5             	mov    %rsp,%rbp
  8038c8:	48 83 ec 40          	sub    $0x40,%rsp
  8038cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038fe:	00 
  8038ff:	e9 8e 00 00 00       	jmpq   803992 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803904:	eb 31                	jmp    803937 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803906:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390e:	48 89 d6             	mov    %rdx,%rsi
  803911:	48 89 c7             	mov    %rax,%rdi
  803914:	48 b8 a7 36 80 00 00 	movabs $0x8036a7,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
  803920:	85 c0                	test   %eax,%eax
  803922:	74 07                	je     80392b <devpipe_write+0x67>
				return 0;
  803924:	b8 00 00 00 00       	mov    $0x0,%eax
  803929:	eb 79                	jmp    8039a4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80392b:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	8b 40 04             	mov    0x4(%rax),%eax
  80393e:	48 63 d0             	movslq %eax,%rdx
  803941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803945:	8b 00                	mov    (%rax),%eax
  803947:	48 98                	cltq   
  803949:	48 83 c0 20          	add    $0x20,%rax
  80394d:	48 39 c2             	cmp    %rax,%rdx
  803950:	73 b4                	jae    803906 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803956:	8b 40 04             	mov    0x4(%rax),%eax
  803959:	99                   	cltd   
  80395a:	c1 ea 1b             	shr    $0x1b,%edx
  80395d:	01 d0                	add    %edx,%eax
  80395f:	83 e0 1f             	and    $0x1f,%eax
  803962:	29 d0                	sub    %edx,%eax
  803964:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803968:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80396c:	48 01 ca             	add    %rcx,%rdx
  80396f:	0f b6 0a             	movzbl (%rdx),%ecx
  803972:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803976:	48 98                	cltq   
  803978:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80397c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803980:	8b 40 04             	mov    0x4(%rax),%eax
  803983:	8d 50 01             	lea    0x1(%rax),%edx
  803986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80398d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803992:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803996:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80399a:	0f 82 64 ff ff ff    	jb     803904 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039a4:	c9                   	leaveq 
  8039a5:	c3                   	retq   

00000000008039a6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039a6:	55                   	push   %rbp
  8039a7:	48 89 e5             	mov    %rsp,%rbp
  8039aa:	48 83 ec 20          	sub    $0x20,%rsp
  8039ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ba:	48 89 c7             	mov    %rax,%rdi
  8039bd:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8039c4:	00 00 00 
  8039c7:	ff d0                	callq  *%rax
  8039c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d1:	48 be 58 4d 80 00 00 	movabs $0x804d58,%rsi
  8039d8:	00 00 00 
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ee:	8b 50 04             	mov    0x4(%rax),%edx
  8039f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f5:	8b 00                	mov    (%rax),%eax
  8039f7:	29 c2                	sub    %eax,%edx
  8039f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039fd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a07:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a0e:	00 00 00 
	stat->st_dev = &devpipe;
  803a11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a15:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a1c:	00 00 00 
  803a1f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 10          	sub    $0x10,%rsp
  803a35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3d:	48 89 c6             	mov    %rax,%rsi
  803a40:	bf 00 00 00 00       	mov    $0x0,%edi
  803a45:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a55:	48 89 c7             	mov    %rax,%rdi
  803a58:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  803a5f:	00 00 00 
  803a62:	ff d0                	callq  *%rax
  803a64:	48 89 c6             	mov    %rax,%rsi
  803a67:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6c:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803a73:	00 00 00 
  803a76:	ff d0                	callq  *%rax
}
  803a78:	c9                   	leaveq 
  803a79:	c3                   	retq   

0000000000803a7a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803a7a:	55                   	push   %rbp
  803a7b:	48 89 e5             	mov    %rsp,%rbp
  803a7e:	48 83 ec 20          	sub    $0x20,%rsp
  803a82:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803a85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a89:	75 35                	jne    803ac0 <wait+0x46>
  803a8b:	48 b9 5f 4d 80 00 00 	movabs $0x804d5f,%rcx
  803a92:	00 00 00 
  803a95:	48 ba 6a 4d 80 00 00 	movabs $0x804d6a,%rdx
  803a9c:	00 00 00 
  803a9f:	be 09 00 00 00       	mov    $0x9,%esi
  803aa4:	48 bf 7f 4d 80 00 00 	movabs $0x804d7f,%rdi
  803aab:	00 00 00 
  803aae:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab3:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  803aba:	00 00 00 
  803abd:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803ac0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac3:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ac8:	48 98                	cltq   
  803aca:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803ad1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ad8:	00 00 00 
  803adb:	48 01 d0             	add    %rdx,%rax
  803ade:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803ae2:	eb 0c                	jmp    803af0 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803ae4:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803afa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803afd:	75 0e                	jne    803b0d <wait+0x93>
  803aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b03:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803b09:	85 c0                	test   %eax,%eax
  803b0b:	75 d7                	jne    803ae4 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  803b0d:	c9                   	leaveq 
  803b0e:	c3                   	retq   

0000000000803b0f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b0f:	55                   	push   %rbp
  803b10:	48 89 e5             	mov    %rsp,%rbp
  803b13:	48 83 ec 20          	sub    $0x20,%rsp
  803b17:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b1d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b20:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b24:	be 01 00 00 00       	mov    $0x1,%esi
  803b29:	48 89 c7             	mov    %rax,%rdi
  803b2c:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
}
  803b38:	c9                   	leaveq 
  803b39:	c3                   	retq   

0000000000803b3a <getchar>:

int
getchar(void)
{
  803b3a:	55                   	push   %rbp
  803b3b:	48 89 e5             	mov    %rsp,%rbp
  803b3e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b42:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b46:	ba 01 00 00 00       	mov    $0x1,%edx
  803b4b:	48 89 c6             	mov    %rax,%rsi
  803b4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b53:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
  803b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b66:	79 05                	jns    803b6d <getchar+0x33>
		return r;
  803b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6b:	eb 14                	jmp    803b81 <getchar+0x47>
	if (r < 1)
  803b6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b71:	7f 07                	jg     803b7a <getchar+0x40>
		return -E_EOF;
  803b73:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b78:	eb 07                	jmp    803b81 <getchar+0x47>
	return c;
  803b7a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b7e:	0f b6 c0             	movzbl %al,%eax
}
  803b81:	c9                   	leaveq 
  803b82:	c3                   	retq   

0000000000803b83 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b83:	55                   	push   %rbp
  803b84:	48 89 e5             	mov    %rsp,%rbp
  803b87:	48 83 ec 20          	sub    $0x20,%rsp
  803b8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b95:	48 89 d6             	mov    %rdx,%rsi
  803b98:	89 c7                	mov    %eax,%edi
  803b9a:	48 b8 c6 25 80 00 00 	movabs $0x8025c6,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
  803ba6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bad:	79 05                	jns    803bb4 <iscons+0x31>
		return r;
  803baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb2:	eb 1a                	jmp    803bce <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb8:	8b 10                	mov    (%rax),%edx
  803bba:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803bc1:	00 00 00 
  803bc4:	8b 00                	mov    (%rax),%eax
  803bc6:	39 c2                	cmp    %eax,%edx
  803bc8:	0f 94 c0             	sete   %al
  803bcb:	0f b6 c0             	movzbl %al,%eax
}
  803bce:	c9                   	leaveq 
  803bcf:	c3                   	retq   

0000000000803bd0 <opencons>:

int
opencons(void)
{
  803bd0:	55                   	push   %rbp
  803bd1:	48 89 e5             	mov    %rsp,%rbp
  803bd4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803bd8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803bdc:	48 89 c7             	mov    %rax,%rdi
  803bdf:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf2:	79 05                	jns    803bf9 <opencons+0x29>
		return r;
  803bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf7:	eb 5b                	jmp    803c54 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfd:	ba 07 04 00 00       	mov    $0x407,%edx
  803c02:	48 89 c6             	mov    %rax,%rsi
  803c05:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0a:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803c11:	00 00 00 
  803c14:	ff d0                	callq  *%rax
  803c16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c1d:	79 05                	jns    803c24 <opencons+0x54>
		return r;
  803c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c22:	eb 30                	jmp    803c54 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c28:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c2f:	00 00 00 
  803c32:	8b 12                	mov    (%rdx),%edx
  803c34:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c45:	48 89 c7             	mov    %rax,%rdi
  803c48:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  803c4f:	00 00 00 
  803c52:	ff d0                	callq  *%rax
}
  803c54:	c9                   	leaveq 
  803c55:	c3                   	retq   

0000000000803c56 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c56:	55                   	push   %rbp
  803c57:	48 89 e5             	mov    %rsp,%rbp
  803c5a:	48 83 ec 30          	sub    $0x30,%rsp
  803c5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c6a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c6f:	75 07                	jne    803c78 <devcons_read+0x22>
		return 0;
  803c71:	b8 00 00 00 00       	mov    $0x0,%eax
  803c76:	eb 4b                	jmp    803cc3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c78:	eb 0c                	jmp    803c86 <devcons_read+0x30>
		sys_yield();
  803c7a:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803c81:	00 00 00 
  803c84:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c86:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803c8d:	00 00 00 
  803c90:	ff d0                	callq  *%rax
  803c92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c99:	74 df                	je     803c7a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9f:	79 05                	jns    803ca6 <devcons_read+0x50>
		return c;
  803ca1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca4:	eb 1d                	jmp    803cc3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ca6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803caa:	75 07                	jne    803cb3 <devcons_read+0x5d>
		return 0;
  803cac:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb1:	eb 10                	jmp    803cc3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb6:	89 c2                	mov    %eax,%edx
  803cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbc:	88 10                	mov    %dl,(%rax)
	return 1;
  803cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803cd0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803cd7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803cde:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cec:	eb 76                	jmp    803d64 <devcons_write+0x9f>
		m = n - tot;
  803cee:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cf5:	89 c2                	mov    %eax,%edx
  803cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfa:	29 c2                	sub    %eax,%edx
  803cfc:	89 d0                	mov    %edx,%eax
  803cfe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d04:	83 f8 7f             	cmp    $0x7f,%eax
  803d07:	76 07                	jbe    803d10 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d09:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d13:	48 63 d0             	movslq %eax,%rdx
  803d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d19:	48 63 c8             	movslq %eax,%rcx
  803d1c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d23:	48 01 c1             	add    %rax,%rcx
  803d26:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d2d:	48 89 ce             	mov    %rcx,%rsi
  803d30:	48 89 c7             	mov    %rax,%rdi
  803d33:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  803d3a:	00 00 00 
  803d3d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d42:	48 63 d0             	movslq %eax,%rdx
  803d45:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d4c:	48 89 d6             	mov    %rdx,%rsi
  803d4f:	48 89 c7             	mov    %rax,%rdi
  803d52:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  803d59:	00 00 00 
  803d5c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d61:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d67:	48 98                	cltq   
  803d69:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d70:	0f 82 78 ff ff ff    	jb     803cee <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d79:	c9                   	leaveq 
  803d7a:	c3                   	retq   

0000000000803d7b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d7b:	55                   	push   %rbp
  803d7c:	48 89 e5             	mov    %rsp,%rbp
  803d7f:	48 83 ec 08          	sub    $0x8,%rsp
  803d83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d8c:	c9                   	leaveq 
  803d8d:	c3                   	retq   

0000000000803d8e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d8e:	55                   	push   %rbp
  803d8f:	48 89 e5             	mov    %rsp,%rbp
  803d92:	48 83 ec 10          	sub    $0x10,%rsp
  803d96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da2:	48 be 8f 4d 80 00 00 	movabs $0x804d8f,%rsi
  803da9:	00 00 00 
  803dac:	48 89 c7             	mov    %rax,%rdi
  803daf:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
	return 0;
  803dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc0:	c9                   	leaveq 
  803dc1:	c3                   	retq   

0000000000803dc2 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803dc2:	55                   	push   %rbp
  803dc3:	48 89 e5             	mov    %rsp,%rbp
  803dc6:	48 83 ec 10          	sub    $0x10,%rsp
  803dca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803dce:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803dd5:	00 00 00 
  803dd8:	48 8b 00             	mov    (%rax),%rax
  803ddb:	48 85 c0             	test   %rax,%rax
  803dde:	0f 85 84 00 00 00    	jne    803e68 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803de4:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803deb:	00 00 00 
  803dee:	48 8b 00             	mov    (%rax),%rax
  803df1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803df7:	ba 07 00 00 00       	mov    $0x7,%edx
  803dfc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803e01:	89 c7                	mov    %eax,%edi
  803e03:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803e0a:	00 00 00 
  803e0d:	ff d0                	callq  *%rax
  803e0f:	85 c0                	test   %eax,%eax
  803e11:	79 2a                	jns    803e3d <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803e13:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  803e1a:	00 00 00 
  803e1d:	be 23 00 00 00       	mov    $0x23,%esi
  803e22:	48 bf bf 4d 80 00 00 	movabs $0x804dbf,%rdi
  803e29:	00 00 00 
  803e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e31:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  803e38:	00 00 00 
  803e3b:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803e3d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803e44:	00 00 00 
  803e47:	48 8b 00             	mov    (%rax),%rax
  803e4a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e50:	48 be 7b 3e 80 00 00 	movabs $0x803e7b,%rsi
  803e57:	00 00 00 
  803e5a:	89 c7                	mov    %eax,%edi
  803e5c:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  803e63:	00 00 00 
  803e66:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803e68:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e6f:	00 00 00 
  803e72:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e76:	48 89 10             	mov    %rdx,(%rax)
}
  803e79:	c9                   	leaveq 
  803e7a:	c3                   	retq   

0000000000803e7b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803e7b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803e7e:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803e85:	00 00 00 
call *%rax
  803e88:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803e8a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803e91:	00 
movq 152(%rsp), %rcx  //Load RSP
  803e92:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803e99:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803e9a:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803e9e:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803ea1:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803ea8:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803ea9:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803ead:	4c 8b 3c 24          	mov    (%rsp),%r15
  803eb1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803eb6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803ebb:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803ec0:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803ec5:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803eca:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803ecf:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803ed4:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803ed9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803ede:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803ee3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803ee8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803eed:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ef2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ef7:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803efb:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803eff:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803f00:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803f01:	c3                   	retq   

0000000000803f02 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f02:	55                   	push   %rbp
  803f03:	48 89 e5             	mov    %rsp,%rbp
  803f06:	48 83 ec 30          	sub    $0x30,%rsp
  803f0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f12:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f16:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f1d:	00 00 00 
  803f20:	48 8b 00             	mov    (%rax),%rax
  803f23:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f29:	85 c0                	test   %eax,%eax
  803f2b:	75 34                	jne    803f61 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f2d:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803f34:	00 00 00 
  803f37:	ff d0                	callq  *%rax
  803f39:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f3e:	48 98                	cltq   
  803f40:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803f47:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f4e:	00 00 00 
  803f51:	48 01 c2             	add    %rax,%rdx
  803f54:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f5b:	00 00 00 
  803f5e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f61:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f66:	75 0e                	jne    803f76 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803f68:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f6f:	00 00 00 
  803f72:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f7a:	48 89 c7             	mov    %rax,%rdi
  803f7d:	48 b8 27 1d 80 00 00 	movabs $0x801d27,%rax
  803f84:	00 00 00 
  803f87:	ff d0                	callq  *%rax
  803f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f90:	79 19                	jns    803fab <ipc_recv+0xa9>
		*from_env_store = 0;
  803f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f96:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa9:	eb 53                	jmp    803ffe <ipc_recv+0xfc>
	}
	if(from_env_store)
  803fab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fb0:	74 19                	je     803fcb <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803fb2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803fb9:	00 00 00 
  803fbc:	48 8b 00             	mov    (%rax),%rax
  803fbf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc9:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fcb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fd0:	74 19                	je     803feb <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803fd2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803fd9:	00 00 00 
  803fdc:	48 8b 00             	mov    (%rax),%rax
  803fdf:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe9:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803feb:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ff2:	00 00 00 
  803ff5:	48 8b 00             	mov    (%rax),%rax
  803ff8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803ffe:	c9                   	leaveq 
  803fff:	c3                   	retq   

0000000000804000 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804000:	55                   	push   %rbp
  804001:	48 89 e5             	mov    %rsp,%rbp
  804004:	48 83 ec 30          	sub    $0x30,%rsp
  804008:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80400b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80400e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804012:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804015:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80401a:	75 0e                	jne    80402a <ipc_send+0x2a>
		pg = (void*)UTOP;
  80401c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804023:	00 00 00 
  804026:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80402a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80402d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804030:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804034:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804037:	89 c7                	mov    %eax,%edi
  804039:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804048:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80404c:	75 0c                	jne    80405a <ipc_send+0x5a>
			sys_yield();
  80404e:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80405a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80405e:	74 ca                	je     80402a <ipc_send+0x2a>
	if(result != 0)
  804060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804064:	74 20                	je     804086 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804069:	89 c6                	mov    %eax,%esi
  80406b:	48 bf d0 4d 80 00 00 	movabs $0x804dd0,%rdi
  804072:	00 00 00 
  804075:	b8 00 00 00 00       	mov    $0x0,%eax
  80407a:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  804081:	00 00 00 
  804084:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804086:	c9                   	leaveq 
  804087:	c3                   	retq   

0000000000804088 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804088:	55                   	push   %rbp
  804089:	48 89 e5             	mov    %rsp,%rbp
  80408c:	53                   	push   %rbx
  80408d:	48 83 ec 58          	sub    $0x58,%rsp
  804091:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  804095:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804099:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  80409d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8040a4:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8040ab:	00 
  8040ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8040b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8040bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8040c4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8040c8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8040cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d0:	48 c1 e8 27          	shr    $0x27,%rax
  8040d4:	48 89 c2             	mov    %rax,%rdx
  8040d7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8040de:	01 00 00 
  8040e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040e5:	83 e0 01             	and    $0x1,%eax
  8040e8:	48 85 c0             	test   %rax,%rax
  8040eb:	0f 85 91 00 00 00    	jne    804182 <ipc_host_recv+0xfa>
  8040f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8040f9:	48 89 c2             	mov    %rax,%rdx
  8040fc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804103:	01 00 00 
  804106:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80410a:	83 e0 01             	and    $0x1,%eax
  80410d:	48 85 c0             	test   %rax,%rax
  804110:	74 70                	je     804182 <ipc_host_recv+0xfa>
  804112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804116:	48 c1 e8 15          	shr    $0x15,%rax
  80411a:	48 89 c2             	mov    %rax,%rdx
  80411d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804124:	01 00 00 
  804127:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80412b:	83 e0 01             	and    $0x1,%eax
  80412e:	48 85 c0             	test   %rax,%rax
  804131:	74 4f                	je     804182 <ipc_host_recv+0xfa>
  804133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804137:	48 c1 e8 0c          	shr    $0xc,%rax
  80413b:	48 89 c2             	mov    %rax,%rdx
  80413e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804145:	01 00 00 
  804148:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80414c:	83 e0 01             	and    $0x1,%eax
  80414f:	48 85 c0             	test   %rax,%rax
  804152:	74 2e                	je     804182 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804158:	ba 07 04 00 00       	mov    $0x407,%edx
  80415d:	48 89 c6             	mov    %rax,%rsi
  804160:	bf 00 00 00 00       	mov    $0x0,%edi
  804165:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  80416c:	00 00 00 
  80416f:	ff d0                	callq  *%rax
  804171:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804174:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804178:	79 08                	jns    804182 <ipc_host_recv+0xfa>
	    	return result;
  80417a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80417d:	e9 84 00 00 00       	jmpq   804206 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804186:	48 c1 e8 0c          	shr    $0xc,%rax
  80418a:	48 89 c2             	mov    %rax,%rdx
  80418d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804194:	01 00 00 
  804197:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80419b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041a1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8041a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8041aa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041ae:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8041b2:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041b6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8041ba:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8041be:	4c 89 c3             	mov    %r8,%rbx
  8041c1:	0f 01 c1             	vmcall 
  8041c4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8041c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8041cb:	7e 36                	jle    804203 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8041cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8041d0:	41 89 c0             	mov    %eax,%r8d
  8041d3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8041d8:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  8041df:	00 00 00 
  8041e2:	be 67 00 00 00       	mov    $0x67,%esi
  8041e7:	48 bf 15 4e 80 00 00 	movabs $0x804e15,%rdi
  8041ee:	00 00 00 
  8041f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f6:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8041fd:	00 00 00 
  804200:	41 ff d1             	callq  *%r9
	return result;
  804203:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804206:	48 83 c4 58          	add    $0x58,%rsp
  80420a:	5b                   	pop    %rbx
  80420b:	5d                   	pop    %rbp
  80420c:	c3                   	retq   

000000000080420d <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80420d:	55                   	push   %rbp
  80420e:	48 89 e5             	mov    %rsp,%rbp
  804211:	53                   	push   %rbx
  804212:	48 83 ec 68          	sub    $0x68,%rsp
  804216:	89 7d ac             	mov    %edi,-0x54(%rbp)
  804219:	89 75 a8             	mov    %esi,-0x58(%rbp)
  80421c:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804220:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804223:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804227:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80422b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804232:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804239:	00 
  80423a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80423e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804242:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804246:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80424a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804252:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804256:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80425a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425e:	48 c1 e8 27          	shr    $0x27,%rax
  804262:	48 89 c2             	mov    %rax,%rdx
  804265:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80426c:	01 00 00 
  80426f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804273:	83 e0 01             	and    $0x1,%eax
  804276:	48 85 c0             	test   %rax,%rax
  804279:	0f 85 88 00 00 00    	jne    804307 <ipc_host_send+0xfa>
  80427f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804283:	48 c1 e8 1e          	shr    $0x1e,%rax
  804287:	48 89 c2             	mov    %rax,%rdx
  80428a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804291:	01 00 00 
  804294:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804298:	83 e0 01             	and    $0x1,%eax
  80429b:	48 85 c0             	test   %rax,%rax
  80429e:	74 67                	je     804307 <ipc_host_send+0xfa>
  8042a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a4:	48 c1 e8 15          	shr    $0x15,%rax
  8042a8:	48 89 c2             	mov    %rax,%rdx
  8042ab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042b2:	01 00 00 
  8042b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042b9:	83 e0 01             	and    $0x1,%eax
  8042bc:	48 85 c0             	test   %rax,%rax
  8042bf:	74 46                	je     804307 <ipc_host_send+0xfa>
  8042c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8042c9:	48 89 c2             	mov    %rax,%rdx
  8042cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042d3:	01 00 00 
  8042d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042da:	83 e0 01             	and    $0x1,%eax
  8042dd:	48 85 c0             	test   %rax,%rax
  8042e0:	74 25                	je     804307 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8042e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8042ea:	48 89 c2             	mov    %rax,%rdx
  8042ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8042f4:	01 00 00 
  8042f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042fb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804301:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804305:	eb 0e                	jmp    804315 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  804307:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80430e:	00 00 00 
  804311:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804319:	48 89 c6             	mov    %rax,%rsi
  80431c:	48 bf 1f 4e 80 00 00 	movabs $0x804e1f,%rdi
  804323:	00 00 00 
  804326:	b8 00 00 00 00       	mov    $0x0,%eax
  80432b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  804332:	00 00 00 
  804335:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  804337:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80433a:	48 98                	cltq   
  80433c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804340:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804343:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  804347:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80434a:	48 98                	cltq   
  80434c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  804350:	b8 02 00 00 00       	mov    $0x2,%eax
  804355:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804359:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80435d:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  804361:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804365:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  804369:	4c 89 c3             	mov    %r8,%rbx
  80436c:	0f 01 c1             	vmcall 
  80436f:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  804372:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804376:	75 0c                	jne    804384 <ipc_host_send+0x177>
			sys_yield();
  804378:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  80437f:	00 00 00 
  804382:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  804384:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  804388:	74 c6                	je     804350 <ipc_host_send+0x143>
	
	if(result !=0)
  80438a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80438e:	74 36                	je     8043c6 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  804390:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804393:	41 89 c0             	mov    %eax,%r8d
  804396:	b9 02 00 00 00       	mov    $0x2,%ecx
  80439b:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  8043a2:	00 00 00 
  8043a5:	be 94 00 00 00       	mov    $0x94,%esi
  8043aa:	48 bf 15 4e 80 00 00 	movabs $0x804e15,%rdi
  8043b1:	00 00 00 
  8043b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b9:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8043c0:	00 00 00 
  8043c3:	41 ff d1             	callq  *%r9
}
  8043c6:	48 83 c4 68          	add    $0x68,%rsp
  8043ca:	5b                   	pop    %rbx
  8043cb:	5d                   	pop    %rbp
  8043cc:	c3                   	retq   

00000000008043cd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043cd:	55                   	push   %rbp
  8043ce:	48 89 e5             	mov    %rsp,%rbp
  8043d1:	48 83 ec 14          	sub    $0x14,%rsp
  8043d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8043d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043df:	eb 4e                	jmp    80442f <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8043e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043e8:	00 00 00 
  8043eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ee:	48 98                	cltq   
  8043f0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8043f7:	48 01 d0             	add    %rdx,%rax
  8043fa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804400:	8b 00                	mov    (%rax),%eax
  804402:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804405:	75 24                	jne    80442b <ipc_find_env+0x5e>
			return envs[i].env_id;
  804407:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80440e:	00 00 00 
  804411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804414:	48 98                	cltq   
  804416:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80441d:	48 01 d0             	add    %rdx,%rax
  804420:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804426:	8b 40 08             	mov    0x8(%rax),%eax
  804429:	eb 12                	jmp    80443d <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80442b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80442f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804436:	7e a9                	jle    8043e1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80443d:	c9                   	leaveq 
  80443e:	c3                   	retq   

000000000080443f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80443f:	55                   	push   %rbp
  804440:	48 89 e5             	mov    %rsp,%rbp
  804443:	48 83 ec 18          	sub    $0x18,%rsp
  804447:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80444b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80444f:	48 c1 e8 15          	shr    $0x15,%rax
  804453:	48 89 c2             	mov    %rax,%rdx
  804456:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80445d:	01 00 00 
  804460:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804464:	83 e0 01             	and    $0x1,%eax
  804467:	48 85 c0             	test   %rax,%rax
  80446a:	75 07                	jne    804473 <pageref+0x34>
		return 0;
  80446c:	b8 00 00 00 00       	mov    $0x0,%eax
  804471:	eb 53                	jmp    8044c6 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804477:	48 c1 e8 0c          	shr    $0xc,%rax
  80447b:	48 89 c2             	mov    %rax,%rdx
  80447e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804485:	01 00 00 
  804488:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80448c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804494:	83 e0 01             	and    $0x1,%eax
  804497:	48 85 c0             	test   %rax,%rax
  80449a:	75 07                	jne    8044a3 <pageref+0x64>
		return 0;
  80449c:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a1:	eb 23                	jmp    8044c6 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8044ab:	48 89 c2             	mov    %rax,%rdx
  8044ae:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044b5:	00 00 00 
  8044b8:	48 c1 e2 04          	shl    $0x4,%rdx
  8044bc:	48 01 d0             	add    %rdx,%rax
  8044bf:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044c3:	0f b7 c0             	movzwl %ax,%eax
}
  8044c6:	c9                   	leaveq 
  8044c7:	c3                   	retq   
