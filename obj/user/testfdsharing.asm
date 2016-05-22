
obj/user/testfdsharing:     file format elf64-x86-64


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
  800057:	48 bf a0 42 80 00 00 	movabs $0x8042a0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 99 2f 80 00 00 	movabs $0x802f99,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba a5 42 80 00 00 	movabs $0x8042a5,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 cb 2b 80 00 00 	movabs $0x802bcb,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba c8 42 80 00 00 	movabs $0x8042c8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 35 23 80 00 00 	movabs $0x802335,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba d2 42 80 00 00 	movabs $0x8042d2,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
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
  80016e:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf e0 42 80 00 00 	movabs $0x8042e0,%rdi
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
  8001a9:	48 b8 cb 2b 80 00 00 	movabs $0x802bcb,%rax
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
  8001cb:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
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
  800222:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 8e 43 80 00 00 	movabs $0x80438e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
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
  80029f:	48 b8 78 3b 80 00 00 	movabs $0x803b78,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 cb 2b 80 00 00 	movabs $0x802bcb,%rax
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
  8002e1:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf cb 43 80 00 00 	movabs $0x8043cb,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
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
  8003c2:	48 b8 1f 29 80 00 00 	movabs $0x80291f,%rax
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
  80049b:	48 bf f0 43 80 00 00 	movabs $0x8043f0,%rdi
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
  8004d7:	48 bf 13 44 80 00 00 	movabs $0x804413,%rdi
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
  800786:	48 ba 10 46 80 00 00 	movabs $0x804610,%rdx
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
  800a7e:	48 b8 38 46 80 00 00 	movabs $0x804638,%rax
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
  800bd1:	48 b8 60 45 80 00 00 	movabs $0x804560,%rax
  800bd8:	00 00 00 
  800bdb:	48 63 d3             	movslq %ebx,%rdx
  800bde:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800be2:	4d 85 e4             	test   %r12,%r12
  800be5:	75 2e                	jne    800c15 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800be7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	89 d9                	mov    %ebx,%ecx
  800bf1:	48 ba 21 46 80 00 00 	movabs $0x804621,%rdx
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
  800c20:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
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
  800c7a:	49 bc 2d 46 80 00 00 	movabs $0x80462d,%r12
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
  801980:	48 ba e8 48 80 00 00 	movabs $0x8048e8,%rdx
  801987:	00 00 00 
  80198a:	be 23 00 00 00       	mov    $0x23,%esi
  80198f:	48 bf 05 49 80 00 00 	movabs $0x804905,%rdi
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

0000000000801e4e <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801e56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5d:	00 
  801e5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e74:	be 00 00 00 00       	mov    $0x0,%esi
  801e79:	bf 11 00 00 00       	mov    $0x11,%edi
  801e7e:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801e8a:	c9                   	leaveq 
  801e8b:	c3                   	retq   

0000000000801e8c <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e8c:	55                   	push   %rbp
  801e8d:	48 89 e5             	mov    %rsp,%rbp
  801e90:	48 83 ec 10          	sub    $0x10,%rsp
  801e94:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9a:	48 98                	cltq   
  801e9c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea3:	00 
  801ea4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eaa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	be 00 00 00 00       	mov    $0x0,%esi
  801ebd:	bf 12 00 00 00       	mov    $0x12,%edi
  801ec2:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801ec9:	00 00 00 
  801ecc:	ff d0                	callq  *%rax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801ed8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edf:	00 
  801ee0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef6:	be 00 00 00 00       	mov    $0x0,%esi
  801efb:	bf 13 00 00 00       	mov    $0x13,%edi
  801f00:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	callq  *%rax
}
  801f0c:	c9                   	leaveq 
  801f0d:	c3                   	retq   

0000000000801f0e <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801f0e:	55                   	push   %rbp
  801f0f:	48 89 e5             	mov    %rsp,%rbp
  801f12:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801f16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1d:	00 
  801f1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f34:	be 00 00 00 00       	mov    $0x0,%esi
  801f39:	bf 14 00 00 00       	mov    $0x14,%edi
  801f3e:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
}
  801f4a:	c9                   	leaveq 
  801f4b:	c3                   	retq   

0000000000801f4c <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
  801f50:	48 83 ec 30          	sub    $0x30,%rsp
  801f54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f5c:	48 8b 00             	mov    (%rax),%rax
  801f5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f67:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f6b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f71:	83 e0 02             	and    $0x2,%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 4d                	jne    801fc5 <pgfault+0x79>
  801f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f80:	48 89 c2             	mov    %rax,%rdx
  801f83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f8a:	01 00 00 
  801f8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f91:	25 00 08 00 00       	and    $0x800,%eax
  801f96:	48 85 c0             	test   %rax,%rax
  801f99:	74 2a                	je     801fc5 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f9b:	48 ba 18 49 80 00 00 	movabs $0x804918,%rdx
  801fa2:	00 00 00 
  801fa5:	be 23 00 00 00       	mov    $0x23,%esi
  801faa:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  801fb1:	00 00 00 
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801fc0:	00 00 00 
  801fc3:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801fc5:	ba 07 00 00 00       	mov    $0x7,%edx
  801fca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fcf:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd4:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	callq  *%rax
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	0f 85 cd 00 00 00    	jne    8020b5 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ffa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802002:	ba 00 10 00 00       	mov    $0x1000,%edx
  802007:	48 89 c6             	mov    %rax,%rsi
  80200a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80200f:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80201b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80201f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802025:	48 89 c1             	mov    %rax,%rcx
  802028:	ba 00 00 00 00       	mov    $0x0,%edx
  80202d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802032:	bf 00 00 00 00       	mov    $0x0,%edi
  802037:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
  802043:	85 c0                	test   %eax,%eax
  802045:	79 2a                	jns    802071 <pgfault+0x125>
				panic("Page map at temp address failed");
  802047:	48 ba 58 49 80 00 00 	movabs $0x804958,%rdx
  80204e:	00 00 00 
  802051:	be 30 00 00 00       	mov    $0x30,%esi
  802056:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  80205d:	00 00 00 
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
  802065:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80206c:	00 00 00 
  80206f:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802071:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	85 c0                	test   %eax,%eax
  802089:	79 54                	jns    8020df <pgfault+0x193>
				panic("Page unmap from temp location failed");
  80208b:	48 ba 78 49 80 00 00 	movabs $0x804978,%rdx
  802092:	00 00 00 
  802095:	be 32 00 00 00       	mov    $0x32,%esi
  80209a:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8020b0:	00 00 00 
  8020b3:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  8020b5:	48 ba a0 49 80 00 00 	movabs $0x8049a0,%rdx
  8020bc:	00 00 00 
  8020bf:	be 34 00 00 00       	mov    $0x34,%esi
  8020c4:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  8020cb:	00 00 00 
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8020da:	00 00 00 
  8020dd:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8020df:	c9                   	leaveq 
  8020e0:	c3                   	retq   

00000000008020e1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020e1:	55                   	push   %rbp
  8020e2:	48 89 e5             	mov    %rsp,%rbp
  8020e5:	48 83 ec 20          	sub    $0x20,%rsp
  8020e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ec:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8020ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f6:	01 00 00 
  8020f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802100:	25 07 0e 00 00       	and    $0xe07,%eax
  802105:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802108:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80210b:	48 c1 e0 0c          	shl    $0xc,%rax
  80210f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802116:	25 00 04 00 00       	and    $0x400,%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	74 57                	je     802176 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80211f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802122:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802126:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212d:	41 89 f0             	mov    %esi,%r8d
  802130:	48 89 c6             	mov    %rax,%rsi
  802133:	bf 00 00 00 00       	mov    $0x0,%edi
  802138:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 8e 52 01 00 00    	jle    80229e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80214c:	48 ba d2 49 80 00 00 	movabs $0x8049d2,%rdx
  802153:	00 00 00 
  802156:	be 4e 00 00 00       	mov    $0x4e,%esi
  80215b:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  802162:	00 00 00 
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
  80216a:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802171:	00 00 00 
  802174:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802179:	83 e0 02             	and    $0x2,%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	75 10                	jne    802190 <duppage+0xaf>
  802180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802183:	25 00 08 00 00       	and    $0x800,%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	0f 84 bb 00 00 00    	je     80224b <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802193:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802198:	80 cc 08             	or     $0x8,%ah
  80219b:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80219e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021a1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021a5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ac:	41 89 f0             	mov    %esi,%r8d
  8021af:	48 89 c6             	mov    %rax,%rsi
  8021b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b7:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	7e 2a                	jle    8021f1 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8021c7:	48 ba d2 49 80 00 00 	movabs $0x8049d2,%rdx
  8021ce:	00 00 00 
  8021d1:	be 55 00 00 00       	mov    $0x55,%esi
  8021d6:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  8021dd:	00 00 00 
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e5:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8021ec:	00 00 00 
  8021ef:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021f1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8021f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fc:	41 89 c8             	mov    %ecx,%r8d
  8021ff:	48 89 d1             	mov    %rdx,%rcx
  802202:	ba 00 00 00 00       	mov    $0x0,%edx
  802207:	48 89 c6             	mov    %rax,%rsi
  80220a:	bf 00 00 00 00       	mov    $0x0,%edi
  80220f:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802216:	00 00 00 
  802219:	ff d0                	callq  *%rax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	7e 2a                	jle    802249 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80221f:	48 ba d2 49 80 00 00 	movabs $0x8049d2,%rdx
  802226:	00 00 00 
  802229:	be 57 00 00 00       	mov    $0x57,%esi
  80222e:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  802235:	00 00 00 
  802238:	b8 00 00 00 00       	mov    $0x0,%eax
  80223d:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802244:	00 00 00 
  802247:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802249:	eb 53                	jmp    80229e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80224b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80224e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802252:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802259:	41 89 f0             	mov    %esi,%r8d
  80225c:	48 89 c6             	mov    %rax,%rsi
  80225f:	bf 00 00 00 00       	mov    $0x0,%edi
  802264:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	callq  *%rax
  802270:	85 c0                	test   %eax,%eax
  802272:	7e 2a                	jle    80229e <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802274:	48 ba d2 49 80 00 00 	movabs $0x8049d2,%rdx
  80227b:	00 00 00 
  80227e:	be 5b 00 00 00       	mov    $0x5b,%esi
  802283:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  80228a:	00 00 00 
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
  802292:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802299:	00 00 00 
  80229c:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a3:	c9                   	leaveq 
  8022a4:	c3                   	retq   

00000000008022a5 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  8022a5:	55                   	push   %rbp
  8022a6:	48 89 e5             	mov    %rsp,%rbp
  8022a9:	48 83 ec 18          	sub    $0x18,%rsp
  8022ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  8022b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022bd:	48 c1 e8 27          	shr    $0x27,%rax
  8022c1:	48 89 c2             	mov    %rax,%rdx
  8022c4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022cb:	01 00 00 
  8022ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d2:	83 e0 01             	and    $0x1,%eax
  8022d5:	48 85 c0             	test   %rax,%rax
  8022d8:	74 51                	je     80232b <pt_is_mapped+0x86>
  8022da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022de:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e2:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022e6:	48 89 c2             	mov    %rax,%rdx
  8022e9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022f0:	01 00 00 
  8022f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f7:	83 e0 01             	and    $0x1,%eax
  8022fa:	48 85 c0             	test   %rax,%rax
  8022fd:	74 2c                	je     80232b <pt_is_mapped+0x86>
  8022ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802303:	48 c1 e0 0c          	shl    $0xc,%rax
  802307:	48 c1 e8 15          	shr    $0x15,%rax
  80230b:	48 89 c2             	mov    %rax,%rdx
  80230e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802315:	01 00 00 
  802318:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231c:	83 e0 01             	and    $0x1,%eax
  80231f:	48 85 c0             	test   %rax,%rax
  802322:	74 07                	je     80232b <pt_is_mapped+0x86>
  802324:	b8 01 00 00 00       	mov    $0x1,%eax
  802329:	eb 05                	jmp    802330 <pt_is_mapped+0x8b>
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
  802330:	83 e0 01             	and    $0x1,%eax
}
  802333:	c9                   	leaveq 
  802334:	c3                   	retq   

0000000000802335 <fork>:

envid_t
fork(void)
{
  802335:	55                   	push   %rbp
  802336:	48 89 e5             	mov    %rsp,%rbp
  802339:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80233d:	48 bf 4c 1f 80 00 00 	movabs $0x801f4c,%rdi
  802344:	00 00 00 
  802347:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802353:	b8 07 00 00 00       	mov    $0x7,%eax
  802358:	cd 30                	int    $0x30
  80235a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80235d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802360:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802367:	79 30                	jns    802399 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802369:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80236c:	89 c1                	mov    %eax,%ecx
  80236e:	48 ba f0 49 80 00 00 	movabs $0x8049f0,%rdx
  802375:	00 00 00 
  802378:	be 86 00 00 00       	mov    $0x86,%esi
  80237d:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  802384:	00 00 00 
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  802393:	00 00 00 
  802396:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802399:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80239d:	75 3e                	jne    8023dd <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80239f:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
  8023ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023b0:	48 98                	cltq   
  8023b2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023b9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023c0:	00 00 00 
  8023c3:	48 01 c2             	add    %rax,%rdx
  8023c6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8023cd:	00 00 00 
  8023d0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	e9 d1 01 00 00       	jmpq   8025ae <fork+0x279>
	}
	uint64_t ad = 0;
  8023dd:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023e4:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023e5:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023ee:	e9 df 00 00 00       	jmpq   8024d2 <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f7:	48 c1 e8 27          	shr    $0x27,%rax
  8023fb:	48 89 c2             	mov    %rax,%rdx
  8023fe:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802405:	01 00 00 
  802408:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240c:	83 e0 01             	and    $0x1,%eax
  80240f:	48 85 c0             	test   %rax,%rax
  802412:	0f 84 9e 00 00 00    	je     8024b6 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80241c:	48 c1 e8 1e          	shr    $0x1e,%rax
  802420:	48 89 c2             	mov    %rax,%rdx
  802423:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80242a:	01 00 00 
  80242d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802431:	83 e0 01             	and    $0x1,%eax
  802434:	48 85 c0             	test   %rax,%rax
  802437:	74 73                	je     8024ac <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802439:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243d:	48 c1 e8 15          	shr    $0x15,%rax
  802441:	48 89 c2             	mov    %rax,%rdx
  802444:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80244b:	01 00 00 
  80244e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802452:	83 e0 01             	and    $0x1,%eax
  802455:	48 85 c0             	test   %rax,%rax
  802458:	74 48                	je     8024a2 <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80245a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245e:	48 c1 e8 0c          	shr    $0xc,%rax
  802462:	48 89 c2             	mov    %rax,%rdx
  802465:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80246c:	01 00 00 
  80246f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802473:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247b:	83 e0 01             	and    $0x1,%eax
  80247e:	48 85 c0             	test   %rax,%rax
  802481:	74 47                	je     8024ca <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802487:	48 c1 e8 0c          	shr    $0xc,%rax
  80248b:	89 c2                	mov    %eax,%edx
  80248d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802490:	89 d6                	mov    %edx,%esi
  802492:	89 c7                	mov    %eax,%edi
  802494:	48 b8 e1 20 80 00 00 	movabs $0x8020e1,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
  8024a0:	eb 28                	jmp    8024ca <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8024a2:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8024a9:	00 
  8024aa:	eb 1e                	jmp    8024ca <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8024ac:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8024b3:	40 
  8024b4:	eb 14                	jmp    8024ca <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8024b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ba:	48 c1 e8 27          	shr    $0x27,%rax
  8024be:	48 83 c0 01          	add    $0x1,%rax
  8024c2:	48 c1 e0 27          	shl    $0x27,%rax
  8024c6:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024ca:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024d1:	00 
  8024d2:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8024d9:	00 
  8024da:	0f 87 13 ff ff ff    	ja     8023f3 <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024e3:	ba 07 00 00 00       	mov    $0x7,%edx
  8024e8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024ed:	89 c7                	mov    %eax,%edi
  8024ef:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  8024f6:	00 00 00 
  8024f9:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024fe:	ba 07 00 00 00       	mov    $0x7,%edx
  802503:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802508:	89 c7                	mov    %eax,%edi
  80250a:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  802511:	00 00 00 
  802514:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802516:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802519:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80251f:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802524:	ba 00 00 00 00       	mov    $0x0,%edx
  802529:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80252e:	89 c7                	mov    %eax,%edi
  802530:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802537:	00 00 00 
  80253a:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80253c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802541:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802546:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80254b:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  802552:	00 00 00 
  802555:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802557:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80255c:	bf 00 00 00 00       	mov    $0x0,%edi
  802561:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802568:	00 00 00 
  80256b:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80256d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802574:	00 00 00 
  802577:	48 8b 00             	mov    (%rax),%rax
  80257a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802581:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	89 c7                	mov    %eax,%edi
  802589:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802595:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802598:	be 02 00 00 00       	mov    $0x2,%esi
  80259d:	89 c7                	mov    %eax,%edi
  80259f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax

	return envid;
  8025ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8025ae:	c9                   	leaveq 
  8025af:	c3                   	retq   

00000000008025b0 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8025b0:	55                   	push   %rbp
  8025b1:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025b4:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  8025bb:	00 00 00 
  8025be:	be bf 00 00 00       	mov    $0xbf,%esi
  8025c3:	48 bf 4d 49 80 00 00 	movabs $0x80494d,%rdi
  8025ca:	00 00 00 
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8025d9:	00 00 00 
  8025dc:	ff d1                	callq  *%rcx

00000000008025de <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 08          	sub    $0x8,%rsp
  8025e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ee:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025f5:	ff ff ff 
  8025f8:	48 01 d0             	add    %rdx,%rax
  8025fb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 08          	sub    $0x8,%rsp
  802609:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80260d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802611:	48 89 c7             	mov    %rax,%rdi
  802614:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
  802620:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802626:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80262a:	c9                   	leaveq 
  80262b:	c3                   	retq   

000000000080262c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80262c:	55                   	push   %rbp
  80262d:	48 89 e5             	mov    %rsp,%rbp
  802630:	48 83 ec 18          	sub    $0x18,%rsp
  802634:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802638:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80263f:	eb 6b                	jmp    8026ac <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802644:	48 98                	cltq   
  802646:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80264c:	48 c1 e0 0c          	shl    $0xc,%rax
  802650:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802658:	48 c1 e8 15          	shr    $0x15,%rax
  80265c:	48 89 c2             	mov    %rax,%rdx
  80265f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802666:	01 00 00 
  802669:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266d:	83 e0 01             	and    $0x1,%eax
  802670:	48 85 c0             	test   %rax,%rax
  802673:	74 21                	je     802696 <fd_alloc+0x6a>
  802675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802679:	48 c1 e8 0c          	shr    $0xc,%rax
  80267d:	48 89 c2             	mov    %rax,%rdx
  802680:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802687:	01 00 00 
  80268a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268e:	83 e0 01             	and    $0x1,%eax
  802691:	48 85 c0             	test   %rax,%rax
  802694:	75 12                	jne    8026a8 <fd_alloc+0x7c>
			*fd_store = fd;
  802696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a6:	eb 1a                	jmp    8026c2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ac:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026b0:	7e 8f                	jle    802641 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026bd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026c2:	c9                   	leaveq 
  8026c3:	c3                   	retq   

00000000008026c4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026c4:	55                   	push   %rbp
  8026c5:	48 89 e5             	mov    %rsp,%rbp
  8026c8:	48 83 ec 20          	sub    $0x20,%rsp
  8026cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026d7:	78 06                	js     8026df <fd_lookup+0x1b>
  8026d9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026dd:	7e 07                	jle    8026e6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e4:	eb 6c                	jmp    802752 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e9:	48 98                	cltq   
  8026eb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026f1:	48 c1 e0 0c          	shl    $0xc,%rax
  8026f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fd:	48 c1 e8 15          	shr    $0x15,%rax
  802701:	48 89 c2             	mov    %rax,%rdx
  802704:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80270b:	01 00 00 
  80270e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802712:	83 e0 01             	and    $0x1,%eax
  802715:	48 85 c0             	test   %rax,%rax
  802718:	74 21                	je     80273b <fd_lookup+0x77>
  80271a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271e:	48 c1 e8 0c          	shr    $0xc,%rax
  802722:	48 89 c2             	mov    %rax,%rdx
  802725:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272c:	01 00 00 
  80272f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802733:	83 e0 01             	and    $0x1,%eax
  802736:	48 85 c0             	test   %rax,%rax
  802739:	75 07                	jne    802742 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80273b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802740:	eb 10                	jmp    802752 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802746:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80274a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802752:	c9                   	leaveq 
  802753:	c3                   	retq   

0000000000802754 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802754:	55                   	push   %rbp
  802755:	48 89 e5             	mov    %rsp,%rbp
  802758:	48 83 ec 30          	sub    $0x30,%rsp
  80275c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802760:	89 f0                	mov    %esi,%eax
  802762:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802769:	48 89 c7             	mov    %rax,%rdi
  80276c:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802773:	00 00 00 
  802776:	ff d0                	callq  *%rax
  802778:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80277c:	48 89 d6             	mov    %rdx,%rsi
  80277f:	89 c7                	mov    %eax,%edi
  802781:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802788:	00 00 00 
  80278b:	ff d0                	callq  *%rax
  80278d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802790:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802794:	78 0a                	js     8027a0 <fd_close+0x4c>
	    || fd != fd2)
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80279e:	74 12                	je     8027b2 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8027a0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027a4:	74 05                	je     8027ab <fd_close+0x57>
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	eb 05                	jmp    8027b0 <fd_close+0x5c>
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	eb 69                	jmp    80281b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b6:	8b 00                	mov    (%rax),%eax
  8027b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027bc:	48 89 d6             	mov    %rdx,%rsi
  8027bf:	89 c7                	mov    %eax,%edi
  8027c1:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d4:	78 2a                	js     802800 <fd_close+0xac>
		if (dev->dev_close)
  8027d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027da:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027de:	48 85 c0             	test   %rax,%rax
  8027e1:	74 16                	je     8027f9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ef:	48 89 d7             	mov    %rdx,%rdi
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f7:	eb 07                	jmp    802800 <fd_close+0xac>
		else
			r = 0;
  8027f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802804:	48 89 c6             	mov    %rax,%rsi
  802807:	bf 00 00 00 00       	mov    $0x0,%edi
  80280c:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
	return r;
  802818:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 20          	sub    $0x20,%rsp
  802825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802828:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80282c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802833:	eb 41                	jmp    802876 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802835:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80283c:	00 00 00 
  80283f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802842:	48 63 d2             	movslq %edx,%rdx
  802845:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802849:	8b 00                	mov    (%rax),%eax
  80284b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80284e:	75 22                	jne    802872 <dev_lookup+0x55>
			*dev = devtab[i];
  802850:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802857:	00 00 00 
  80285a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80285d:	48 63 d2             	movslq %edx,%rdx
  802860:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802864:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802868:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	eb 60                	jmp    8028d2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802872:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802876:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80287d:	00 00 00 
  802880:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802883:	48 63 d2             	movslq %edx,%rdx
  802886:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80288a:	48 85 c0             	test   %rax,%rax
  80288d:	75 a6                	jne    802835 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80288f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802896:	00 00 00 
  802899:	48 8b 00             	mov    (%rax),%rax
  80289c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028a5:	89 c6                	mov    %eax,%esi
  8028a7:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  8028ae:	00 00 00 
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b6:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  8028bd:	00 00 00 
  8028c0:	ff d1                	callq  *%rcx
	*dev = 0;
  8028c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <close>:

int
close(int fdnum)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 20          	sub    $0x20,%rsp
  8028dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e6:	48 89 d6             	mov    %rdx,%rsi
  8028e9:	89 c7                	mov    %eax,%edi
  8028eb:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  8028f2:	00 00 00 
  8028f5:	ff d0                	callq  *%rax
  8028f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fe:	79 05                	jns    802905 <close+0x31>
		return r;
  802900:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802903:	eb 18                	jmp    80291d <close+0x49>
	else
		return fd_close(fd, 1);
  802905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802909:	be 01 00 00 00       	mov    $0x1,%esi
  80290e:	48 89 c7             	mov    %rax,%rdi
  802911:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
}
  80291d:	c9                   	leaveq 
  80291e:	c3                   	retq   

000000000080291f <close_all>:

void
close_all(void)
{
  80291f:	55                   	push   %rbp
  802920:	48 89 e5             	mov    %rsp,%rbp
  802923:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80292e:	eb 15                	jmp    802945 <close_all+0x26>
		close(i);
  802930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802933:	89 c7                	mov    %eax,%edi
  802935:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802941:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802945:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802949:	7e e5                	jle    802930 <close_all+0x11>
		close(i);
}
  80294b:	c9                   	leaveq 
  80294c:	c3                   	retq   

000000000080294d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80294d:	55                   	push   %rbp
  80294e:	48 89 e5             	mov    %rsp,%rbp
  802951:	48 83 ec 40          	sub    $0x40,%rsp
  802955:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802958:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80295b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80295f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802962:	48 89 d6             	mov    %rdx,%rsi
  802965:	89 c7                	mov    %eax,%edi
  802967:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
  802973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297a:	79 08                	jns    802984 <dup+0x37>
		return r;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297f:	e9 70 01 00 00       	jmpq   802af4 <dup+0x1a7>
	close(newfdnum);
  802984:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802987:	89 c7                	mov    %eax,%edi
  802989:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802995:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802998:	48 98                	cltq   
  80299a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029a0:	48 c1 e0 0c          	shl    $0xc,%rax
  8029a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ac:	48 89 c7             	mov    %rax,%rdi
  8029af:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	callq  *%rax
  8029bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c3:	48 89 c7             	mov    %rax,%rdi
  8029c6:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029da:	48 c1 e8 15          	shr    $0x15,%rax
  8029de:	48 89 c2             	mov    %rax,%rdx
  8029e1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029e8:	01 00 00 
  8029eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ef:	83 e0 01             	and    $0x1,%eax
  8029f2:	48 85 c0             	test   %rax,%rax
  8029f5:	74 73                	je     802a6a <dup+0x11d>
  8029f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8029ff:	48 89 c2             	mov    %rax,%rdx
  802a02:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a09:	01 00 00 
  802a0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a10:	83 e0 01             	and    $0x1,%eax
  802a13:	48 85 c0             	test   %rax,%rax
  802a16:	74 52                	je     802a6a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1c:	48 c1 e8 0c          	shr    $0xc,%rax
  802a20:	48 89 c2             	mov    %rax,%rdx
  802a23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a2a:	01 00 00 
  802a2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a31:	25 07 0e 00 00       	and    $0xe07,%eax
  802a36:	89 c1                	mov    %eax,%ecx
  802a38:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	41 89 c8             	mov    %ecx,%r8d
  802a43:	48 89 d1             	mov    %rdx,%rcx
  802a46:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4b:	48 89 c6             	mov    %rax,%rsi
  802a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a53:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	callq  *%rax
  802a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a66:	79 02                	jns    802a6a <dup+0x11d>
			goto err;
  802a68:	eb 57                	jmp    802ac1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a6e:	48 c1 e8 0c          	shr    $0xc,%rax
  802a72:	48 89 c2             	mov    %rax,%rdx
  802a75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a7c:	01 00 00 
  802a7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a83:	25 07 0e 00 00       	and    $0xe07,%eax
  802a88:	89 c1                	mov    %eax,%ecx
  802a8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a92:	41 89 c8             	mov    %ecx,%r8d
  802a95:	48 89 d1             	mov    %rdx,%rcx
  802a98:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9d:	48 89 c6             	mov    %rax,%rsi
  802aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa5:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
  802ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab8:	79 02                	jns    802abc <dup+0x16f>
		goto err;
  802aba:	eb 05                	jmp    802ac1 <dup+0x174>

	return newfdnum;
  802abc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802abf:	eb 33                	jmp    802af4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac5:	48 89 c6             	mov    %rax,%rsi
  802ac8:	bf 00 00 00 00       	mov    $0x0,%edi
  802acd:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802add:	48 89 c6             	mov    %rax,%rsi
  802ae0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae5:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
	return r;
  802af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802af4:	c9                   	leaveq 
  802af5:	c3                   	retq   

0000000000802af6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802af6:	55                   	push   %rbp
  802af7:	48 89 e5             	mov    %rsp,%rbp
  802afa:	48 83 ec 40          	sub    $0x40,%rsp
  802afe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b09:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b10:	48 89 d6             	mov    %rdx,%rsi
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
  802b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b28:	78 24                	js     802b4e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2e:	8b 00                	mov    (%rax),%eax
  802b30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b34:	48 89 d6             	mov    %rdx,%rsi
  802b37:	89 c7                	mov    %eax,%edi
  802b39:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
  802b45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4c:	79 05                	jns    802b53 <read+0x5d>
		return r;
  802b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b51:	eb 76                	jmp    802bc9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b57:	8b 40 08             	mov    0x8(%rax),%eax
  802b5a:	83 e0 03             	and    $0x3,%eax
  802b5d:	83 f8 01             	cmp    $0x1,%eax
  802b60:	75 3a                	jne    802b9c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b62:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b69:	00 00 00 
  802b6c:	48 8b 00             	mov    (%rax),%rax
  802b6f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b75:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b78:	89 c6                	mov    %eax,%esi
  802b7a:	48 bf 3f 4a 80 00 00 	movabs $0x804a3f,%rdi
  802b81:	00 00 00 
  802b84:	b8 00 00 00 00       	mov    $0x0,%eax
  802b89:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802b90:	00 00 00 
  802b93:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b9a:	eb 2d                	jmp    802bc9 <read+0xd3>
	}
	if (!dev->dev_read)
  802b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba0:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ba4:	48 85 c0             	test   %rax,%rax
  802ba7:	75 07                	jne    802bb0 <read+0xba>
		return -E_NOT_SUPP;
  802ba9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bae:	eb 19                	jmp    802bc9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb4:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bb8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bbc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bc0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bc4:	48 89 cf             	mov    %rcx,%rdi
  802bc7:	ff d0                	callq  *%rax
}
  802bc9:	c9                   	leaveq 
  802bca:	c3                   	retq   

0000000000802bcb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bcb:	55                   	push   %rbp
  802bcc:	48 89 e5             	mov    %rsp,%rbp
  802bcf:	48 83 ec 30          	sub    $0x30,%rsp
  802bd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bda:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802be5:	eb 49                	jmp    802c30 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802be7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bea:	48 98                	cltq   
  802bec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bf0:	48 29 c2             	sub    %rax,%rdx
  802bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf6:	48 63 c8             	movslq %eax,%rcx
  802bf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bfd:	48 01 c1             	add    %rax,%rcx
  802c00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c03:	48 89 ce             	mov    %rcx,%rsi
  802c06:	89 c7                	mov    %eax,%edi
  802c08:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c17:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c1b:	79 05                	jns    802c22 <readn+0x57>
			return m;
  802c1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c20:	eb 1c                	jmp    802c3e <readn+0x73>
		if (m == 0)
  802c22:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c26:	75 02                	jne    802c2a <readn+0x5f>
			break;
  802c28:	eb 11                	jmp    802c3b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c33:	48 98                	cltq   
  802c35:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c39:	72 ac                	jb     802be7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 40          	sub    $0x40,%rsp
  802c48:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c4f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c53:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c57:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c5a:	48 89 d6             	mov    %rdx,%rsi
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
  802c6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c72:	78 24                	js     802c98 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c78:	8b 00                	mov    (%rax),%eax
  802c7a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7e:	48 89 d6             	mov    %rdx,%rsi
  802c81:	89 c7                	mov    %eax,%edi
  802c83:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c96:	79 05                	jns    802c9d <write+0x5d>
		return r;
  802c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9b:	eb 42                	jmp    802cdf <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca1:	8b 40 08             	mov    0x8(%rax),%eax
  802ca4:	83 e0 03             	and    $0x3,%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	75 07                	jne    802cb2 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802cab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cb0:	eb 2d                	jmp    802cdf <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cba:	48 85 c0             	test   %rax,%rax
  802cbd:	75 07                	jne    802cc6 <write+0x86>
		return -E_NOT_SUPP;
  802cbf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cc4:	eb 19                	jmp    802cdf <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cca:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cd2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cd6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cda:	48 89 cf             	mov    %rcx,%rdi
  802cdd:	ff d0                	callq  *%rax
}
  802cdf:	c9                   	leaveq 
  802ce0:	c3                   	retq   

0000000000802ce1 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ce1:	55                   	push   %rbp
  802ce2:	48 89 e5             	mov    %rsp,%rbp
  802ce5:	48 83 ec 18          	sub    $0x18,%rsp
  802ce9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cec:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf6:	48 89 d6             	mov    %rdx,%rsi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
  802d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0e:	79 05                	jns    802d15 <seek+0x34>
		return r;
  802d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d13:	eb 0f                	jmp    802d24 <seek+0x43>
	fd->fd_offset = offset;
  802d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d19:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 30          	sub    $0x30,%rsp
  802d2e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d31:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d34:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d38:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d3b:	48 89 d6             	mov    %rdx,%rsi
  802d3e:	89 c7                	mov    %eax,%edi
  802d40:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
  802d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d53:	78 24                	js     802d79 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d59:	8b 00                	mov    (%rax),%eax
  802d5b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d5f:	48 89 d6             	mov    %rdx,%rsi
  802d62:	89 c7                	mov    %eax,%edi
  802d64:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
  802d70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d77:	79 05                	jns    802d7e <ftruncate+0x58>
		return r;
  802d79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7c:	eb 72                	jmp    802df0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d82:	8b 40 08             	mov    0x8(%rax),%eax
  802d85:	83 e0 03             	and    $0x3,%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	75 3a                	jne    802dc6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d8c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802d93:	00 00 00 
  802d96:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d99:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d9f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da2:	89 c6                	mov    %eax,%esi
  802da4:	48 bf 60 4a 80 00 00 	movabs $0x804a60,%rdi
  802dab:	00 00 00 
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802dba:	00 00 00 
  802dbd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc4:	eb 2a                	jmp    802df0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dce:	48 85 c0             	test   %rax,%rax
  802dd1:	75 07                	jne    802dda <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dd3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dd8:	eb 16                	jmp    802df0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	48 8b 40 30          	mov    0x30(%rax),%rax
  802de2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802de6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802de9:	89 ce                	mov    %ecx,%esi
  802deb:	48 89 d7             	mov    %rdx,%rdi
  802dee:	ff d0                	callq  *%rax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 30          	sub    $0x30,%rsp
  802dfa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dfd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e08:	48 89 d6             	mov    %rdx,%rsi
  802e0b:	89 c7                	mov    %eax,%edi
  802e0d:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
  802e19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e20:	78 24                	js     802e46 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e26:	8b 00                	mov    (%rax),%eax
  802e28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2c:	48 89 d6             	mov    %rdx,%rsi
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
  802e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e44:	79 05                	jns    802e4b <fstat+0x59>
		return r;
  802e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e49:	eb 5e                	jmp    802ea9 <fstat+0xb7>
	if (!dev->dev_stat)
  802e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e53:	48 85 c0             	test   %rax,%rax
  802e56:	75 07                	jne    802e5f <fstat+0x6d>
		return -E_NOT_SUPP;
  802e58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e5d:	eb 4a                	jmp    802ea9 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e63:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e6a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e71:	00 00 00 
	stat->st_isdir = 0;
  802e74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e78:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e7f:	00 00 00 
	stat->st_dev = dev;
  802e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e95:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e9d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ea1:	48 89 ce             	mov    %rcx,%rsi
  802ea4:	48 89 d7             	mov    %rdx,%rdi
  802ea7:	ff d0                	callq  *%rax
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 20          	sub    $0x20,%rsp
  802eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebf:	be 00 00 00 00       	mov    $0x0,%esi
  802ec4:	48 89 c7             	mov    %rax,%rdi
  802ec7:	48 b8 99 2f 80 00 00 	movabs $0x802f99,%rax
  802ece:	00 00 00 
  802ed1:	ff d0                	callq  *%rax
  802ed3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eda:	79 05                	jns    802ee1 <stat+0x36>
		return fd;
  802edc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edf:	eb 2f                	jmp    802f10 <stat+0x65>
	r = fstat(fd, stat);
  802ee1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee8:	48 89 d6             	mov    %rdx,%rsi
  802eeb:	89 c7                	mov    %eax,%edi
  802eed:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
  802ef9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eff:	89 c7                	mov    %eax,%edi
  802f01:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax
	return r;
  802f0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f10:	c9                   	leaveq 
  802f11:	c3                   	retq   

0000000000802f12 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f12:	55                   	push   %rbp
  802f13:	48 89 e5             	mov    %rsp,%rbp
  802f16:	48 83 ec 10          	sub    $0x10,%rsp
  802f1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f21:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f28:	00 00 00 
  802f2b:	8b 00                	mov    (%rax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	75 1d                	jne    802f4e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f31:	bf 01 00 00 00       	mov    $0x1,%edi
  802f36:	48 b8 86 41 80 00 00 	movabs $0x804186,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
  802f42:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f49:	00 00 00 
  802f4c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f4e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f55:	00 00 00 
  802f58:	8b 00                	mov    (%rax),%eax
  802f5a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f5d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f62:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f69:	00 00 00 
  802f6c:	89 c7                	mov    %eax,%edi
  802f6e:	48 b8 fe 40 80 00 00 	movabs $0x8040fe,%rax
  802f75:	00 00 00 
  802f78:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f83:	48 89 c6             	mov    %rax,%rsi
  802f86:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8b:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802f92:	00 00 00 
  802f95:	ff d0                	callq  *%rax
}
  802f97:	c9                   	leaveq 
  802f98:	c3                   	retq   

0000000000802f99 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f99:	55                   	push   %rbp
  802f9a:	48 89 e5             	mov    %rsp,%rbp
  802f9d:	48 83 ec 30          	sub    $0x30,%rsp
  802fa1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fa5:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802fa8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802faf:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802fbd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802fc2:	75 08                	jne    802fcc <open+0x33>
	{
		return r;
  802fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc7:	e9 f2 00 00 00       	jmpq   8030be <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd0:	48 89 c7             	mov    %rax,%rdi
  802fd3:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fe2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802fe9:	7e 0a                	jle    802ff5 <open+0x5c>
	{
		return -E_BAD_PATH;
  802feb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff0:	e9 c9 00 00 00       	jmpq   8030be <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802ff5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802ffc:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802ffd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803001:	48 89 c7             	mov    %rax,%rdi
  803004:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  80300b:	00 00 00 
  80300e:	ff d0                	callq  *%rax
  803010:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803013:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803017:	78 09                	js     803022 <open+0x89>
  803019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301d:	48 85 c0             	test   %rax,%rax
  803020:	75 08                	jne    80302a <open+0x91>
		{
			return r;
  803022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803025:	e9 94 00 00 00       	jmpq   8030be <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80302a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302e:	ba 00 04 00 00       	mov    $0x400,%edx
  803033:	48 89 c6             	mov    %rax,%rsi
  803036:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80303d:	00 00 00 
  803040:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80304c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803053:	00 00 00 
  803056:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803059:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80305f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803063:	48 89 c6             	mov    %rax,%rsi
  803066:	bf 01 00 00 00       	mov    $0x1,%edi
  80306b:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
  803077:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307e:	79 2b                	jns    8030ab <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803084:	be 00 00 00 00       	mov    $0x0,%esi
  803089:	48 89 c7             	mov    %rax,%rdi
  80308c:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
  803098:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80309b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80309f:	79 05                	jns    8030a6 <open+0x10d>
			{
				return d;
  8030a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a4:	eb 18                	jmp    8030be <open+0x125>
			}
			return r;
  8030a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a9:	eb 13                	jmp    8030be <open+0x125>
		}	
		return fd2num(fd_store);
  8030ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030af:	48 89 c7             	mov    %rax,%rdi
  8030b2:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8030be:	c9                   	leaveq 
  8030bf:	c3                   	retq   

00000000008030c0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030c0:	55                   	push   %rbp
  8030c1:	48 89 e5             	mov    %rsp,%rbp
  8030c4:	48 83 ec 10          	sub    $0x10,%rsp
  8030c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030da:	00 00 00 
  8030dd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030df:	be 00 00 00 00       	mov    $0x0,%esi
  8030e4:	bf 06 00 00 00       	mov    $0x6,%edi
  8030e9:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  8030f0:	00 00 00 
  8030f3:	ff d0                	callq  *%rax
}
  8030f5:	c9                   	leaveq 
  8030f6:	c3                   	retq   

00000000008030f7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030f7:	55                   	push   %rbp
  8030f8:	48 89 e5             	mov    %rsp,%rbp
  8030fb:	48 83 ec 30          	sub    $0x30,%rsp
  8030ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803103:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803107:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80310b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803112:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803117:	74 07                	je     803120 <devfile_read+0x29>
  803119:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80311e:	75 07                	jne    803127 <devfile_read+0x30>
		return -E_INVAL;
  803120:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803125:	eb 77                	jmp    80319e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312b:	8b 50 0c             	mov    0xc(%rax),%edx
  80312e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803135:	00 00 00 
  803138:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80313a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803141:	00 00 00 
  803144:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803148:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80314c:	be 00 00 00 00       	mov    $0x0,%esi
  803151:	bf 03 00 00 00       	mov    $0x3,%edi
  803156:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
  803162:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803165:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803169:	7f 05                	jg     803170 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80316b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316e:	eb 2e                	jmp    80319e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803173:	48 63 d0             	movslq %eax,%rdx
  803176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803181:	00 00 00 
  803184:	48 89 c7             	mov    %rax,%rdi
  803187:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803197:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80319b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80319e:	c9                   	leaveq 
  80319f:	c3                   	retq   

00000000008031a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031a0:	55                   	push   %rbp
  8031a1:	48 89 e5             	mov    %rsp,%rbp
  8031a4:	48 83 ec 30          	sub    $0x30,%rsp
  8031a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8031b4:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8031bb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031c0:	74 07                	je     8031c9 <devfile_write+0x29>
  8031c2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031c7:	75 08                	jne    8031d1 <devfile_write+0x31>
		return r;
  8031c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cc:	e9 9a 00 00 00       	jmpq   80326b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8031d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031df:	00 00 00 
  8031e2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031e4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031eb:	00 
  8031ec:	76 08                	jbe    8031f6 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031ee:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031f5:	00 
	}
	fsipcbuf.write.req_n = n;
  8031f6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031fd:	00 00 00 
  803200:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803204:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803208:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803210:	48 89 c6             	mov    %rax,%rsi
  803213:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80321a:	00 00 00 
  80321d:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803229:	be 00 00 00 00       	mov    $0x0,%esi
  80322e:	bf 04 00 00 00       	mov    $0x4,%edi
  803233:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
  80323f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803246:	7f 20                	jg     803268 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803248:	48 bf 86 4a 80 00 00 	movabs $0x804a86,%rdi
  80324f:	00 00 00 
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80325e:	00 00 00 
  803261:	ff d2                	callq  *%rdx
		return r;
  803263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803266:	eb 03                	jmp    80326b <devfile_write+0xcb>
	}
	return r;
  803268:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80326b:	c9                   	leaveq 
  80326c:	c3                   	retq   

000000000080326d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 83 ec 20          	sub    $0x20,%rsp
  803275:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80327d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803281:	8b 50 0c             	mov    0xc(%rax),%edx
  803284:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80328b:	00 00 00 
  80328e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803290:	be 00 00 00 00       	mov    $0x0,%esi
  803295:	bf 05 00 00 00       	mov    $0x5,%edi
  80329a:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
  8032a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ad:	79 05                	jns    8032b4 <devfile_stat+0x47>
		return r;
  8032af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b2:	eb 56                	jmp    80330a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032bf:	00 00 00 
  8032c2:	48 89 c7             	mov    %rax,%rdi
  8032c5:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  8032cc:	00 00 00 
  8032cf:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032d8:	00 00 00 
  8032db:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f2:	00 00 00 
  8032f5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ff:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330a:	c9                   	leaveq 
  80330b:	c3                   	retq   

000000000080330c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80330c:	55                   	push   %rbp
  80330d:	48 89 e5             	mov    %rsp,%rbp
  803310:	48 83 ec 10          	sub    $0x10,%rsp
  803314:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803318:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80331b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80331f:	8b 50 0c             	mov    0xc(%rax),%edx
  803322:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803329:	00 00 00 
  80332c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80332e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803335:	00 00 00 
  803338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80333e:	be 00 00 00 00       	mov    $0x0,%esi
  803343:	bf 02 00 00 00       	mov    $0x2,%edi
  803348:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <remove>:

// Delete a file
int
remove(const char *path)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	48 83 ec 10          	sub    $0x10,%rsp
  80335e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803366:	48 89 c7             	mov    %rax,%rdi
  803369:	48 b8 63 11 80 00 00 	movabs $0x801163,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80337a:	7e 07                	jle    803383 <remove+0x2d>
		return -E_BAD_PATH;
  80337c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803381:	eb 33                	jmp    8033b6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803387:	48 89 c6             	mov    %rax,%rsi
  80338a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803391:	00 00 00 
  803394:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033a0:	be 00 00 00 00       	mov    $0x0,%esi
  8033a5:	bf 07 00 00 00       	mov    $0x7,%edi
  8033aa:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
}
  8033b6:	c9                   	leaveq 
  8033b7:	c3                   	retq   

00000000008033b8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033b8:	55                   	push   %rbp
  8033b9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033bc:	be 00 00 00 00       	mov    $0x0,%esi
  8033c1:	bf 08 00 00 00       	mov    $0x8,%edi
  8033c6:	48 b8 12 2f 80 00 00 	movabs $0x802f12,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
}
  8033d2:	5d                   	pop    %rbp
  8033d3:	c3                   	retq   

00000000008033d4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033d4:	55                   	push   %rbp
  8033d5:	48 89 e5             	mov    %rsp,%rbp
  8033d8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033df:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033e6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033ed:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033f4:	be 00 00 00 00       	mov    $0x0,%esi
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 99 2f 80 00 00 	movabs $0x802f99,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80340b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340f:	79 28                	jns    803439 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803414:	89 c6                	mov    %eax,%esi
  803416:	48 bf a2 4a 80 00 00 	movabs $0x804aa2,%rdi
  80341d:	00 00 00 
  803420:	b8 00 00 00 00       	mov    $0x0,%eax
  803425:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80342c:	00 00 00 
  80342f:	ff d2                	callq  *%rdx
		return fd_src;
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	e9 74 01 00 00       	jmpq   8035ad <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803439:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803440:	be 01 01 00 00       	mov    $0x101,%esi
  803445:	48 89 c7             	mov    %rax,%rdi
  803448:	48 b8 99 2f 80 00 00 	movabs $0x802f99,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
  803454:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803457:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80345b:	79 39                	jns    803496 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80345d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803460:	89 c6                	mov    %eax,%esi
  803462:	48 bf b8 4a 80 00 00 	movabs $0x804ab8,%rdi
  803469:	00 00 00 
  80346c:	b8 00 00 00 00       	mov    $0x0,%eax
  803471:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  803478:	00 00 00 
  80347b:	ff d2                	callq  *%rdx
		close(fd_src);
  80347d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803480:	89 c7                	mov    %eax,%edi
  803482:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
		return fd_dest;
  80348e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803491:	e9 17 01 00 00       	jmpq   8035ad <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803496:	eb 74                	jmp    80350c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803498:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80349b:	48 63 d0             	movslq %eax,%rdx
  80349e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a8:	48 89 ce             	mov    %rcx,%rsi
  8034ab:	89 c7                	mov    %eax,%edi
  8034ad:	48 b8 40 2c 80 00 00 	movabs $0x802c40,%rax
  8034b4:	00 00 00 
  8034b7:	ff d0                	callq  *%rax
  8034b9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034c0:	79 4a                	jns    80350c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8034c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034c5:	89 c6                	mov    %eax,%esi
  8034c7:	48 bf d2 4a 80 00 00 	movabs $0x804ad2,%rdi
  8034ce:	00 00 00 
  8034d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d6:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8034dd:	00 00 00 
  8034e0:	ff d2                	callq  *%rdx
			close(fd_src);
  8034e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e5:	89 c7                	mov    %eax,%edi
  8034e7:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
			close(fd_dest);
  8034f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034f6:	89 c7                	mov    %eax,%edi
  8034f8:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
			return write_size;
  803504:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803507:	e9 a1 00 00 00       	jmpq   8035ad <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80350c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803513:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803516:	ba 00 02 00 00       	mov    $0x200,%edx
  80351b:	48 89 ce             	mov    %rcx,%rsi
  80351e:	89 c7                	mov    %eax,%edi
  803520:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803527:	00 00 00 
  80352a:	ff d0                	callq  *%rax
  80352c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80352f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803533:	0f 8f 5f ff ff ff    	jg     803498 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803539:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80353d:	79 47                	jns    803586 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80353f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803542:	89 c6                	mov    %eax,%esi
  803544:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  80354b:	00 00 00 
  80354e:	b8 00 00 00 00       	mov    $0x0,%eax
  803553:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80355a:	00 00 00 
  80355d:	ff d2                	callq  *%rdx
		close(fd_src);
  80355f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803562:	89 c7                	mov    %eax,%edi
  803564:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80356b:	00 00 00 
  80356e:	ff d0                	callq  *%rax
		close(fd_dest);
  803570:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803573:	89 c7                	mov    %eax,%edi
  803575:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
		return read_size;
  803581:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803584:	eb 27                	jmp    8035ad <copy+0x1d9>
	}
	close(fd_src);
  803586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803589:	89 c7                	mov    %eax,%edi
  80358b:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  803592:	00 00 00 
  803595:	ff d0                	callq  *%rax
	close(fd_dest);
  803597:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80359a:	89 c7                	mov    %eax,%edi
  80359c:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
  8035a3:	00 00 00 
  8035a6:	ff d0                	callq  *%rax
	return 0;
  8035a8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8035ad:	c9                   	leaveq 
  8035ae:	c3                   	retq   

00000000008035af <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035af:	55                   	push   %rbp
  8035b0:	48 89 e5             	mov    %rsp,%rbp
  8035b3:	53                   	push   %rbx
  8035b4:	48 83 ec 38          	sub    $0x38,%rsp
  8035b8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035bc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035c0:	48 89 c7             	mov    %rax,%rdi
  8035c3:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d6:	0f 88 bf 01 00 00    	js     80379b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8035e5:	48 89 c6             	mov    %rax,%rsi
  8035e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ed:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
  8035f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803600:	0f 88 95 01 00 00    	js     80379b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803606:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80360a:	48 89 c7             	mov    %rax,%rdi
  80360d:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  803614:	00 00 00 
  803617:	ff d0                	callq  *%rax
  803619:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803620:	0f 88 5d 01 00 00    	js     803783 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803626:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80362a:	ba 07 04 00 00       	mov    $0x407,%edx
  80362f:	48 89 c6             	mov    %rax,%rsi
  803632:	bf 00 00 00 00       	mov    $0x0,%edi
  803637:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
  803643:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803646:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80364a:	0f 88 33 01 00 00    	js     803783 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803654:	48 89 c7             	mov    %rax,%rdi
  803657:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80366b:	ba 07 04 00 00       	mov    $0x407,%edx
  803670:	48 89 c6             	mov    %rax,%rsi
  803673:	bf 00 00 00 00       	mov    $0x0,%edi
  803678:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80368b:	79 05                	jns    803692 <pipe+0xe3>
		goto err2;
  80368d:	e9 d9 00 00 00       	jmpq   80376b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803692:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803696:	48 89 c7             	mov    %rax,%rdi
  803699:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	48 89 c2             	mov    %rax,%rdx
  8036a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ac:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036b2:	48 89 d1             	mov    %rdx,%rcx
  8036b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8036ba:	48 89 c6             	mov    %rax,%rsi
  8036bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c2:	48 b8 4e 1b 80 00 00 	movabs $0x801b4e,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
  8036ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d5:	79 1b                	jns    8036f2 <pipe+0x143>
		goto err3;
  8036d7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036dc:	48 89 c6             	mov    %rax,%rsi
  8036df:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e4:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
  8036f0:	eb 79                	jmp    80376b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036fd:	00 00 00 
  803700:	8b 12                	mov    (%rdx),%edx
  803702:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803708:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80370f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803713:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80371a:	00 00 00 
  80371d:	8b 12                	mov    (%rdx),%edx
  80371f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803721:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803725:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80372c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803730:	48 89 c7             	mov    %rax,%rdi
  803733:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
  80373f:	89 c2                	mov    %eax,%edx
  803741:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803745:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803747:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80374b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80374f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
  803762:	89 03                	mov    %eax,(%rbx)
	return 0;
  803764:	b8 00 00 00 00       	mov    $0x0,%eax
  803769:	eb 33                	jmp    80379e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80376b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376f:	48 89 c6             	mov    %rax,%rsi
  803772:	bf 00 00 00 00       	mov    $0x0,%edi
  803777:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803787:	48 89 c6             	mov    %rax,%rsi
  80378a:	bf 00 00 00 00       	mov    $0x0,%edi
  80378f:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
err:
	return r;
  80379b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80379e:	48 83 c4 38          	add    $0x38,%rsp
  8037a2:	5b                   	pop    %rbx
  8037a3:	5d                   	pop    %rbp
  8037a4:	c3                   	retq   

00000000008037a5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	53                   	push   %rbx
  8037aa:	48 83 ec 28          	sub    $0x28,%rsp
  8037ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037b6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8037bd:	00 00 00 
  8037c0:	48 8b 00             	mov    (%rax),%rax
  8037c3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
  8037df:	89 c3                	mov    %eax,%ebx
  8037e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e5:	48 89 c7             	mov    %rax,%rdi
  8037e8:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
  8037f4:	39 c3                	cmp    %eax,%ebx
  8037f6:	0f 94 c0             	sete   %al
  8037f9:	0f b6 c0             	movzbl %al,%eax
  8037fc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037ff:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803806:	00 00 00 
  803809:	48 8b 00             	mov    (%rax),%rax
  80380c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803812:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803815:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803818:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80381b:	75 05                	jne    803822 <_pipeisclosed+0x7d>
			return ret;
  80381d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803820:	eb 4f                	jmp    803871 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803822:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803825:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803828:	74 42                	je     80386c <_pipeisclosed+0xc7>
  80382a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80382e:	75 3c                	jne    80386c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803830:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803837:	00 00 00 
  80383a:	48 8b 00             	mov    (%rax),%rax
  80383d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803843:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803849:	89 c6                	mov    %eax,%esi
  80384b:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  803852:	00 00 00 
  803855:	b8 00 00 00 00       	mov    $0x0,%eax
  80385a:	49 b8 1a 06 80 00 00 	movabs $0x80061a,%r8
  803861:	00 00 00 
  803864:	41 ff d0             	callq  *%r8
	}
  803867:	e9 4a ff ff ff       	jmpq   8037b6 <_pipeisclosed+0x11>
  80386c:	e9 45 ff ff ff       	jmpq   8037b6 <_pipeisclosed+0x11>
}
  803871:	48 83 c4 28          	add    $0x28,%rsp
  803875:	5b                   	pop    %rbx
  803876:	5d                   	pop    %rbp
  803877:	c3                   	retq   

0000000000803878 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803878:	55                   	push   %rbp
  803879:	48 89 e5             	mov    %rsp,%rbp
  80387c:	48 83 ec 30          	sub    $0x30,%rsp
  803880:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803883:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803887:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80388a:	48 89 d6             	mov    %rdx,%rsi
  80388d:	89 c7                	mov    %eax,%edi
  80388f:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
  80389b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a2:	79 05                	jns    8038a9 <pipeisclosed+0x31>
		return r;
  8038a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a7:	eb 31                	jmp    8038da <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ad:	48 89 c7             	mov    %rax,%rdi
  8038b0:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038c8:	48 89 d6             	mov    %rdx,%rsi
  8038cb:	48 89 c7             	mov    %rax,%rdi
  8038ce:	48 b8 a5 37 80 00 00 	movabs $0x8037a5,%rax
  8038d5:	00 00 00 
  8038d8:	ff d0                	callq  *%rax
}
  8038da:	c9                   	leaveq 
  8038db:	c3                   	retq   

00000000008038dc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038dc:	55                   	push   %rbp
  8038dd:	48 89 e5             	mov    %rsp,%rbp
  8038e0:	48 83 ec 40          	sub    $0x40,%rsp
  8038e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f4:	48 89 c7             	mov    %rax,%rdi
  8038f7:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
  803903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803907:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80390f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803916:	00 
  803917:	e9 92 00 00 00       	jmpq   8039ae <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80391c:	eb 41                	jmp    80395f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80391e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803923:	74 09                	je     80392e <devpipe_read+0x52>
				return i;
  803925:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803929:	e9 92 00 00 00       	jmpq   8039c0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80392e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803932:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803936:	48 89 d6             	mov    %rdx,%rsi
  803939:	48 89 c7             	mov    %rax,%rdi
  80393c:	48 b8 a5 37 80 00 00 	movabs $0x8037a5,%rax
  803943:	00 00 00 
  803946:	ff d0                	callq  *%rax
  803948:	85 c0                	test   %eax,%eax
  80394a:	74 07                	je     803953 <devpipe_read+0x77>
				return 0;
  80394c:	b8 00 00 00 00       	mov    $0x0,%eax
  803951:	eb 6d                	jmp    8039c0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803953:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80395f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803963:	8b 10                	mov    (%rax),%edx
  803965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803969:	8b 40 04             	mov    0x4(%rax),%eax
  80396c:	39 c2                	cmp    %eax,%edx
  80396e:	74 ae                	je     80391e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803978:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80397c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803980:	8b 00                	mov    (%rax),%eax
  803982:	99                   	cltd   
  803983:	c1 ea 1b             	shr    $0x1b,%edx
  803986:	01 d0                	add    %edx,%eax
  803988:	83 e0 1f             	and    $0x1f,%eax
  80398b:	29 d0                	sub    %edx,%eax
  80398d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803991:	48 98                	cltq   
  803993:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803998:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80399a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399e:	8b 00                	mov    (%rax),%eax
  8039a0:	8d 50 01             	lea    0x1(%rax),%edx
  8039a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039b6:	0f 82 60 ff ff ff    	jb     80391c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039c0:	c9                   	leaveq 
  8039c1:	c3                   	retq   

00000000008039c2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039c2:	55                   	push   %rbp
  8039c3:	48 89 e5             	mov    %rsp,%rbp
  8039c6:	48 83 ec 40          	sub    $0x40,%rsp
  8039ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039da:	48 89 c7             	mov    %rax,%rdi
  8039dd:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
  8039e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039fc:	00 
  8039fd:	e9 8e 00 00 00       	jmpq   803a90 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a02:	eb 31                	jmp    803a35 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0c:	48 89 d6             	mov    %rdx,%rsi
  803a0f:	48 89 c7             	mov    %rax,%rdi
  803a12:	48 b8 a5 37 80 00 00 	movabs $0x8037a5,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax
  803a1e:	85 c0                	test   %eax,%eax
  803a20:	74 07                	je     803a29 <devpipe_write+0x67>
				return 0;
  803a22:	b8 00 00 00 00       	mov    $0x0,%eax
  803a27:	eb 79                	jmp    803aa2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a29:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a39:	8b 40 04             	mov    0x4(%rax),%eax
  803a3c:	48 63 d0             	movslq %eax,%rdx
  803a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a43:	8b 00                	mov    (%rax),%eax
  803a45:	48 98                	cltq   
  803a47:	48 83 c0 20          	add    $0x20,%rax
  803a4b:	48 39 c2             	cmp    %rax,%rdx
  803a4e:	73 b4                	jae    803a04 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a54:	8b 40 04             	mov    0x4(%rax),%eax
  803a57:	99                   	cltd   
  803a58:	c1 ea 1b             	shr    $0x1b,%edx
  803a5b:	01 d0                	add    %edx,%eax
  803a5d:	83 e0 1f             	and    $0x1f,%eax
  803a60:	29 d0                	sub    %edx,%eax
  803a62:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a66:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a6a:	48 01 ca             	add    %rcx,%rdx
  803a6d:	0f b6 0a             	movzbl (%rdx),%ecx
  803a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a74:	48 98                	cltq   
  803a76:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7e:	8b 40 04             	mov    0x4(%rax),%eax
  803a81:	8d 50 01             	lea    0x1(%rax),%edx
  803a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a88:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a94:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a98:	0f 82 64 ff ff ff    	jb     803a02 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803aa2:	c9                   	leaveq 
  803aa3:	c3                   	retq   

0000000000803aa4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803aa4:	55                   	push   %rbp
  803aa5:	48 89 e5             	mov    %rsp,%rbp
  803aa8:	48 83 ec 20          	sub    $0x20,%rsp
  803aac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ab0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab8:	48 89 c7             	mov    %rax,%rdi
  803abb:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
  803ac7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803acf:	48 be 18 4b 80 00 00 	movabs $0x804b18,%rsi
  803ad6:	00 00 00 
  803ad9:	48 89 c7             	mov    %rax,%rdi
  803adc:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  803ae3:	00 00 00 
  803ae6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aec:	8b 50 04             	mov    0x4(%rax),%edx
  803aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af3:	8b 00                	mov    (%rax),%eax
  803af5:	29 c2                	sub    %eax,%edx
  803af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b0c:	00 00 00 
	stat->st_dev = &devpipe;
  803b0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b13:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b1a:	00 00 00 
  803b1d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b29:	c9                   	leaveq 
  803b2a:	c3                   	retq   

0000000000803b2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b2b:	55                   	push   %rbp
  803b2c:	48 89 e5             	mov    %rsp,%rbp
  803b2f:	48 83 ec 10          	sub    $0x10,%rsp
  803b33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3b:	48 89 c6             	mov    %rax,%rsi
  803b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b43:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803b4a:	00 00 00 
  803b4d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b53:	48 89 c7             	mov    %rax,%rdi
  803b56:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
  803b62:	48 89 c6             	mov    %rax,%rsi
  803b65:	bf 00 00 00 00       	mov    $0x0,%edi
  803b6a:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  803b71:	00 00 00 
  803b74:	ff d0                	callq  *%rax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 20          	sub    $0x20,%rsp
  803b80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b87:	75 35                	jne    803bbe <wait+0x46>
  803b89:	48 b9 1f 4b 80 00 00 	movabs $0x804b1f,%rcx
  803b90:	00 00 00 
  803b93:	48 ba 2a 4b 80 00 00 	movabs $0x804b2a,%rdx
  803b9a:	00 00 00 
  803b9d:	be 09 00 00 00       	mov    $0x9,%esi
  803ba2:	48 bf 3f 4b 80 00 00 	movabs $0x804b3f,%rdi
  803ba9:	00 00 00 
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb1:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  803bb8:	00 00 00 
  803bbb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803bbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc1:	25 ff 03 00 00       	and    $0x3ff,%eax
  803bc6:	48 98                	cltq   
  803bc8:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803bcf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803bd6:	00 00 00 
  803bd9:	48 01 d0             	add    %rdx,%rax
  803bdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803be0:	eb 0c                	jmp    803bee <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803be2:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  803bee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803bf8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bfb:	75 0e                	jne    803c0b <wait+0x93>
  803bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c01:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c07:	85 c0                	test   %eax,%eax
  803c09:	75 d7                	jne    803be2 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  803c0b:	c9                   	leaveq 
  803c0c:	c3                   	retq   

0000000000803c0d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c0d:	55                   	push   %rbp
  803c0e:	48 89 e5             	mov    %rsp,%rbp
  803c11:	48 83 ec 20          	sub    $0x20,%rsp
  803c15:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c1b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c1e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c22:	be 01 00 00 00       	mov    $0x1,%esi
  803c27:	48 89 c7             	mov    %rax,%rdi
  803c2a:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  803c31:	00 00 00 
  803c34:	ff d0                	callq  *%rax
}
  803c36:	c9                   	leaveq 
  803c37:	c3                   	retq   

0000000000803c38 <getchar>:

int
getchar(void)
{
  803c38:	55                   	push   %rbp
  803c39:	48 89 e5             	mov    %rsp,%rbp
  803c3c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c40:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c44:	ba 01 00 00 00       	mov    $0x1,%edx
  803c49:	48 89 c6             	mov    %rax,%rsi
  803c4c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c51:	48 b8 f6 2a 80 00 00 	movabs $0x802af6,%rax
  803c58:	00 00 00 
  803c5b:	ff d0                	callq  *%rax
  803c5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c64:	79 05                	jns    803c6b <getchar+0x33>
		return r;
  803c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c69:	eb 14                	jmp    803c7f <getchar+0x47>
	if (r < 1)
  803c6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6f:	7f 07                	jg     803c78 <getchar+0x40>
		return -E_EOF;
  803c71:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c76:	eb 07                	jmp    803c7f <getchar+0x47>
	return c;
  803c78:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c7c:	0f b6 c0             	movzbl %al,%eax
}
  803c7f:	c9                   	leaveq 
  803c80:	c3                   	retq   

0000000000803c81 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c81:	55                   	push   %rbp
  803c82:	48 89 e5             	mov    %rsp,%rbp
  803c85:	48 83 ec 20          	sub    $0x20,%rsp
  803c89:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c8c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c93:	48 89 d6             	mov    %rdx,%rsi
  803c96:	89 c7                	mov    %eax,%edi
  803c98:	48 b8 c4 26 80 00 00 	movabs $0x8026c4,%rax
  803c9f:	00 00 00 
  803ca2:	ff d0                	callq  *%rax
  803ca4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cab:	79 05                	jns    803cb2 <iscons+0x31>
		return r;
  803cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb0:	eb 1a                	jmp    803ccc <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb6:	8b 10                	mov    (%rax),%edx
  803cb8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cbf:	00 00 00 
  803cc2:	8b 00                	mov    (%rax),%eax
  803cc4:	39 c2                	cmp    %eax,%edx
  803cc6:	0f 94 c0             	sete   %al
  803cc9:	0f b6 c0             	movzbl %al,%eax
}
  803ccc:	c9                   	leaveq 
  803ccd:	c3                   	retq   

0000000000803cce <opencons>:

int
opencons(void)
{
  803cce:	55                   	push   %rbp
  803ccf:	48 89 e5             	mov    %rsp,%rbp
  803cd2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803cd6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cda:	48 89 c7             	mov    %rax,%rdi
  803cdd:	48 b8 2c 26 80 00 00 	movabs $0x80262c,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf0:	79 05                	jns    803cf7 <opencons+0x29>
		return r;
  803cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf5:	eb 5b                	jmp    803d52 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfb:	ba 07 04 00 00       	mov    $0x407,%edx
  803d00:	48 89 c6             	mov    %rax,%rsi
  803d03:	bf 00 00 00 00       	mov    $0x0,%edi
  803d08:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803d0f:	00 00 00 
  803d12:	ff d0                	callq  *%rax
  803d14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1b:	79 05                	jns    803d22 <opencons+0x54>
		return r;
  803d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d20:	eb 30                	jmp    803d52 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d26:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d2d:	00 00 00 
  803d30:	8b 12                	mov    (%rdx),%edx
  803d32:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d38:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d43:	48 89 c7             	mov    %rax,%rdi
  803d46:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  803d4d:	00 00 00 
  803d50:	ff d0                	callq  *%rax
}
  803d52:	c9                   	leaveq 
  803d53:	c3                   	retq   

0000000000803d54 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d54:	55                   	push   %rbp
  803d55:	48 89 e5             	mov    %rsp,%rbp
  803d58:	48 83 ec 30          	sub    $0x30,%rsp
  803d5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d68:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d6d:	75 07                	jne    803d76 <devcons_read+0x22>
		return 0;
  803d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d74:	eb 4b                	jmp    803dc1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d76:	eb 0c                	jmp    803d84 <devcons_read+0x30>
		sys_yield();
  803d78:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d84:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
  803d90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d97:	74 df                	je     803d78 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d9d:	79 05                	jns    803da4 <devcons_read+0x50>
		return c;
  803d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da2:	eb 1d                	jmp    803dc1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803da4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803da8:	75 07                	jne    803db1 <devcons_read+0x5d>
		return 0;
  803daa:	b8 00 00 00 00       	mov    $0x0,%eax
  803daf:	eb 10                	jmp    803dc1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db4:	89 c2                	mov    %eax,%edx
  803db6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dba:	88 10                	mov    %dl,(%rax)
	return 1;
  803dbc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dc1:	c9                   	leaveq 
  803dc2:	c3                   	retq   

0000000000803dc3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dc3:	55                   	push   %rbp
  803dc4:	48 89 e5             	mov    %rsp,%rbp
  803dc7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803dce:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803dd5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ddc:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dea:	eb 76                	jmp    803e62 <devcons_write+0x9f>
		m = n - tot;
  803dec:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803df3:	89 c2                	mov    %eax,%edx
  803df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df8:	29 c2                	sub    %eax,%edx
  803dfa:	89 d0                	mov    %edx,%eax
  803dfc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e02:	83 f8 7f             	cmp    $0x7f,%eax
  803e05:	76 07                	jbe    803e0e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e07:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e11:	48 63 d0             	movslq %eax,%rdx
  803e14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e17:	48 63 c8             	movslq %eax,%rcx
  803e1a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e21:	48 01 c1             	add    %rax,%rcx
  803e24:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e2b:	48 89 ce             	mov    %rcx,%rsi
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e40:	48 63 d0             	movslq %eax,%rdx
  803e43:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e4a:	48 89 d6             	mov    %rdx,%rsi
  803e4d:	48 89 c7             	mov    %rax,%rdi
  803e50:	48 b8 b6 19 80 00 00 	movabs $0x8019b6,%rax
  803e57:	00 00 00 
  803e5a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e5f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e65:	48 98                	cltq   
  803e67:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e6e:	0f 82 78 ff ff ff    	jb     803dec <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e74:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e77:	c9                   	leaveq 
  803e78:	c3                   	retq   

0000000000803e79 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e79:	55                   	push   %rbp
  803e7a:	48 89 e5             	mov    %rsp,%rbp
  803e7d:	48 83 ec 08          	sub    $0x8,%rsp
  803e81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e8a:	c9                   	leaveq 
  803e8b:	c3                   	retq   

0000000000803e8c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e8c:	55                   	push   %rbp
  803e8d:	48 89 e5             	mov    %rsp,%rbp
  803e90:	48 83 ec 10          	sub    $0x10,%rsp
  803e94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea0:	48 be 4f 4b 80 00 00 	movabs $0x804b4f,%rsi
  803ea7:	00 00 00 
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
	return 0;
  803eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 10          	sub    $0x10,%rsp
  803ec8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803ecc:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ed3:	00 00 00 
  803ed6:	48 8b 00             	mov    (%rax),%rax
  803ed9:	48 85 c0             	test   %rax,%rax
  803edc:	0f 85 84 00 00 00    	jne    803f66 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803ee2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ee9:	00 00 00 
  803eec:	48 8b 00             	mov    (%rax),%rax
  803eef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ef5:	ba 07 00 00 00       	mov    $0x7,%edx
  803efa:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803eff:	89 c7                	mov    %eax,%edi
  803f01:	48 b8 fe 1a 80 00 00 	movabs $0x801afe,%rax
  803f08:	00 00 00 
  803f0b:	ff d0                	callq  *%rax
  803f0d:	85 c0                	test   %eax,%eax
  803f0f:	79 2a                	jns    803f3b <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803f11:	48 ba 58 4b 80 00 00 	movabs $0x804b58,%rdx
  803f18:	00 00 00 
  803f1b:	be 23 00 00 00       	mov    $0x23,%esi
  803f20:	48 bf 7f 4b 80 00 00 	movabs $0x804b7f,%rdi
  803f27:	00 00 00 
  803f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2f:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  803f36:	00 00 00 
  803f39:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803f3b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f42:	00 00 00 
  803f45:	48 8b 00             	mov    (%rax),%rax
  803f48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f4e:	48 be 79 3f 80 00 00 	movabs $0x803f79,%rsi
  803f55:	00 00 00 
  803f58:	89 c7                	mov    %eax,%edi
  803f5a:	48 b8 88 1c 80 00 00 	movabs $0x801c88,%rax
  803f61:	00 00 00 
  803f64:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803f66:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f6d:	00 00 00 
  803f70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f74:	48 89 10             	mov    %rdx,(%rax)
}
  803f77:	c9                   	leaveq 
  803f78:	c3                   	retq   

0000000000803f79 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803f79:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803f7c:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803f83:	00 00 00 
call *%rax
  803f86:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803f88:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803f8f:	00 
movq 152(%rsp), %rcx  //Load RSP
  803f90:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803f97:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803f98:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803f9c:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803f9f:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803fa6:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803fa7:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803fab:	4c 8b 3c 24          	mov    (%rsp),%r15
  803faf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803fb4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803fb9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803fbe:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803fc3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803fc8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803fcd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803fd2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803fd7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803fdc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803fe1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803fe6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803feb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ff0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ff5:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803ff9:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803ffd:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803ffe:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803fff:	c3                   	retq   

0000000000804000 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804000:	55                   	push   %rbp
  804001:	48 89 e5             	mov    %rsp,%rbp
  804004:	48 83 ec 30          	sub    $0x30,%rsp
  804008:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804010:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804014:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80401b:	00 00 00 
  80401e:	48 8b 00             	mov    (%rax),%rax
  804021:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804027:	85 c0                	test   %eax,%eax
  804029:	75 34                	jne    80405f <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80402b:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  804032:	00 00 00 
  804035:	ff d0                	callq  *%rax
  804037:	25 ff 03 00 00       	and    $0x3ff,%eax
  80403c:	48 98                	cltq   
  80403e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804045:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80404c:	00 00 00 
  80404f:	48 01 c2             	add    %rax,%rdx
  804052:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804059:	00 00 00 
  80405c:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80405f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804064:	75 0e                	jne    804074 <ipc_recv+0x74>
		pg = (void*) UTOP;
  804066:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80406d:	00 00 00 
  804070:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804074:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804078:	48 89 c7             	mov    %rax,%rdi
  80407b:	48 b8 27 1d 80 00 00 	movabs $0x801d27,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
  804087:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80408a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408e:	79 19                	jns    8040a9 <ipc_recv+0xa9>
		*from_env_store = 0;
  804090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804094:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80409a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80409e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8040a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a7:	eb 53                	jmp    8040fc <ipc_recv+0xfc>
	}
	if(from_env_store)
  8040a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040ae:	74 19                	je     8040c9 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8040b0:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8040b7:	00 00 00 
  8040ba:	48 8b 00             	mov    (%rax),%rax
  8040bd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8040c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c7:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8040c9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040ce:	74 19                	je     8040e9 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8040d0:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8040d7:	00 00 00 
  8040da:	48 8b 00             	mov    (%rax),%rax
  8040dd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8040e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040e7:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8040e9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8040f0:	00 00 00 
  8040f3:	48 8b 00             	mov    (%rax),%rax
  8040f6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8040fc:	c9                   	leaveq 
  8040fd:	c3                   	retq   

00000000008040fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040fe:	55                   	push   %rbp
  8040ff:	48 89 e5             	mov    %rsp,%rbp
  804102:	48 83 ec 30          	sub    $0x30,%rsp
  804106:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804109:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80410c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804110:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804113:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804118:	75 0e                	jne    804128 <ipc_send+0x2a>
		pg = (void*)UTOP;
  80411a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804121:	00 00 00 
  804124:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804128:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80412b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80412e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804132:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804135:	89 c7                	mov    %eax,%edi
  804137:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
  804143:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804146:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80414a:	75 0c                	jne    804158 <ipc_send+0x5a>
			sys_yield();
  80414c:	48 b8 c0 1a 80 00 00 	movabs $0x801ac0,%rax
  804153:	00 00 00 
  804156:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804158:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80415c:	74 ca                	je     804128 <ipc_send+0x2a>
	if(result != 0)
  80415e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804162:	74 20                	je     804184 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  804164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804167:	89 c6                	mov    %eax,%esi
  804169:	48 bf 8d 4b 80 00 00 	movabs $0x804b8d,%rdi
  804170:	00 00 00 
  804173:	b8 00 00 00 00       	mov    $0x0,%eax
  804178:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80417f:	00 00 00 
  804182:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  804184:	c9                   	leaveq 
  804185:	c3                   	retq   

0000000000804186 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804186:	55                   	push   %rbp
  804187:	48 89 e5             	mov    %rsp,%rbp
  80418a:	48 83 ec 14          	sub    $0x14,%rsp
  80418e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804198:	eb 4e                	jmp    8041e8 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80419a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041a1:	00 00 00 
  8041a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a7:	48 98                	cltq   
  8041a9:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041b0:	48 01 d0             	add    %rdx,%rax
  8041b3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041b9:	8b 00                	mov    (%rax),%eax
  8041bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8041be:	75 24                	jne    8041e4 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8041c0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041c7:	00 00 00 
  8041ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cd:	48 98                	cltq   
  8041cf:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041d6:	48 01 d0             	add    %rdx,%rax
  8041d9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8041df:	8b 40 08             	mov    0x8(%rax),%eax
  8041e2:	eb 12                	jmp    8041f6 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8041e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8041e8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8041ef:	7e a9                	jle    80419a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8041f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041f6:	c9                   	leaveq 
  8041f7:	c3                   	retq   

00000000008041f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041f8:	55                   	push   %rbp
  8041f9:	48 89 e5             	mov    %rsp,%rbp
  8041fc:	48 83 ec 18          	sub    $0x18,%rsp
  804200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804208:	48 c1 e8 15          	shr    $0x15,%rax
  80420c:	48 89 c2             	mov    %rax,%rdx
  80420f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804216:	01 00 00 
  804219:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80421d:	83 e0 01             	and    $0x1,%eax
  804220:	48 85 c0             	test   %rax,%rax
  804223:	75 07                	jne    80422c <pageref+0x34>
		return 0;
  804225:	b8 00 00 00 00       	mov    $0x0,%eax
  80422a:	eb 53                	jmp    80427f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80422c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804230:	48 c1 e8 0c          	shr    $0xc,%rax
  804234:	48 89 c2             	mov    %rax,%rdx
  804237:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80423e:	01 00 00 
  804241:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804245:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424d:	83 e0 01             	and    $0x1,%eax
  804250:	48 85 c0             	test   %rax,%rax
  804253:	75 07                	jne    80425c <pageref+0x64>
		return 0;
  804255:	b8 00 00 00 00       	mov    $0x0,%eax
  80425a:	eb 23                	jmp    80427f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80425c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804260:	48 c1 e8 0c          	shr    $0xc,%rax
  804264:	48 89 c2             	mov    %rax,%rdx
  804267:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80426e:	00 00 00 
  804271:	48 c1 e2 04          	shl    $0x4,%rdx
  804275:	48 01 d0             	add    %rdx,%rax
  804278:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80427c:	0f b7 c0             	movzwl %ax,%eax
}
  80427f:	c9                   	leaveq 
  804280:	c3                   	retq   
