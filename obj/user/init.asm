
obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 6c 06 00 00       	callq  8006ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 1c          	sub    $0x1c,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 09 47 80 00 00 	movabs $0x804709,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 80 80 00 00 	movabs $0x808020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be 65 47 80 00 00 	movabs $0x804765,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be 71 47 80 00 00 	movabs $0x804771,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be 74 47 80 00 00 	movabs $0x804774,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf 76 47 80 00 00 	movabs $0x804776,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf 7a 47 80 00 00 	movabs $0x80477a,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba 8c 47 80 00 00 	movabs $0x80478c,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba a5 47 80 00 00 	movabs $0x8047a5,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba bf 47 80 00 00 	movabs $0x8047bf,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf c7 47 80 00 00 	movabs $0x8047c7,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be da 47 80 00 00 	movabs $0x8047da,%rsi
  80037f:	00 00 00 
  800382:	48 bf dd 47 80 00 00 	movabs $0x8047dd,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 e2 35 80 00 00 	movabs $0x8035e2,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf e5 47 80 00 00 	movabs $0x8047e5,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		cprintf("init waiting\n");
		wait(r);
#ifdef VMM_GUEST
		break;
#endif
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c9:	48 bf f9 47 80 00 00 	movabs $0x8047f9,%rdi
  8003d0:	00 00 00 
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8003df:	00 00 00 
  8003e2:	ff d2                	callq  *%rdx
		wait(r);
  8003e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e7:	89 c7                	mov    %eax,%edi
  8003e9:	48 b8 a4 43 80 00 00 	movabs $0x8043a4,%rax
  8003f0:	00 00 00 
  8003f3:	ff d0                	callq  *%rax
#ifdef VMM_GUEST
		break;
#endif
	}
  8003f5:	e9 5e ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003fa <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 83 ec 20          	sub    $0x20,%rsp
  800402:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800408:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80040b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040f:	be 01 00 00 00       	mov    $0x1,%esi
  800414:	48 89 c7             	mov    %rax,%rdi
  800417:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <getchar>:

int
getchar(void)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800431:	ba 01 00 00 00       	mov    $0x1,%edx
  800436:	48 89 c6             	mov    %rax,%rsi
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800451:	79 05                	jns    800458 <getchar+0x33>
		return r;
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	eb 14                	jmp    80046c <getchar+0x47>
	if (r < 1)
  800458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045c:	7f 07                	jg     800465 <getchar+0x40>
		return -E_EOF;
  80045e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800463:	eb 07                	jmp    80046c <getchar+0x47>
	return c;
  800465:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800469:	0f b6 c0             	movzbl %al,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800479:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 05                	jns    80049f <iscons+0x31>
		return r;
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	eb 1a                	jmp    8004b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 10                	mov    (%rax),%edx
  8004a5:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  8004ac:	00 00 00 
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 94 c0             	sete   %al
  8004b6:	0f b6 c0             	movzbl %al,%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <opencons>:

int
opencons(void)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c7:	48 89 c7             	mov    %rax,%rdi
  8004ca:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
  8004d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dd:	79 05                	jns    8004e4 <opencons+0x29>
		return r;
  8004df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e2:	eb 5b                	jmp    80053f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800508:	79 05                	jns    80050f <opencons+0x54>
		return r;
  80050a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050d:	eb 30                	jmp    80053f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  80051a:	00 00 00 
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800525:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	48 89 c7             	mov    %rax,%rdi
  800533:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	callq  *%rax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800555:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80055a:	75 07                	jne    800563 <devcons_read+0x22>
		return 0;
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	eb 4b                	jmp    8005ae <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800563:	eb 0c                	jmp    800571 <devcons_read+0x30>
		sys_yield();
  800565:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800571:	48 b8 72 1d 80 00 00 	movabs $0x801d72,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800584:	74 df                	je     800565 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058a:	79 05                	jns    800591 <devcons_read+0x50>
		return c;
  80058c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058f:	eb 1d                	jmp    8005ae <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800591:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800595:	75 07                	jne    80059e <devcons_read+0x5d>
		return 0;
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	eb 10                	jmp    8005ae <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a1:	89 c2                	mov    %eax,%edx
  8005a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d7:	eb 76                	jmp    80064f <devcons_write+0x9f>
		m = n - tot;
  8005d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005e0:	89 c2                	mov    %eax,%edx
  8005e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ef:	83 f8 7f             	cmp    $0x7f,%eax
  8005f2:	76 07                	jbe    8005fb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fe:	48 63 d0             	movslq %eax,%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 63 c8             	movslq %eax,%rcx
  800607:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060e:	48 01 c1             	add    %rax,%rcx
  800611:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800618:	48 89 ce             	mov    %rcx,%rsi
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80062a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062d:	48 63 d0             	movslq %eax,%rdx
  800630:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800637:	48 89 d6             	mov    %rdx,%rsi
  80063a:	48 89 c7             	mov    %rax,%rdi
  80063d:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  800644:	00 00 00 
  800647:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800649:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80064c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80065b:	0f 82 78 ff ff ff    	jb     8005d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800661:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 83 ec 10          	sub    $0x10,%rsp
  800681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800685:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	48 be 0c 48 80 00 00 	movabs $0x80480c,%rsi
  800694:	00 00 00 
  800697:	48 89 c7             	mov    %rax,%rdi
  80069a:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  8006a1:	00 00 00 
  8006a4:	ff d0                	callq  *%rax
	return 0;
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ab:	c9                   	leaveq 
  8006ac:	c3                   	retq   

00000000008006ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006ad:	55                   	push   %rbp
  8006ae:	48 89 e5             	mov    %rsp,%rbp
  8006b1:	48 83 ec 10          	sub    $0x10,%rsp
  8006b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8006bc:	48 b8 f4 1d 80 00 00 	movabs $0x801df4,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
  8006c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006cd:	48 98                	cltq   
  8006cf:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8006d6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006dd:	00 00 00 
  8006e0:	48 01 c2             	add    %rax,%rdx
  8006e3:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006ea:	00 00 00 
  8006ed:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006f4:	7e 14                	jle    80070a <libmain+0x5d>
		binaryname = argv[0];
  8006f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fa:	48 8b 10             	mov    (%rax),%rdx
  8006fd:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  800704:	00 00 00 
  800707:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80070a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800711:	48 89 d6             	mov    %rdx,%rsi
  800714:	89 c7                	mov    %eax,%edi
  800716:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80071d:	00 00 00 
  800720:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800722:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
}
  80072e:	c9                   	leaveq 
  80072f:	c3                   	retq   

0000000000800730 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800730:	55                   	push   %rbp
  800731:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800734:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  80073b:	00 00 00 
  80073e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800740:	bf 00 00 00 00       	mov    $0x0,%edi
  800745:	48 b8 b0 1d 80 00 00 	movabs $0x801db0,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	callq  *%rax

}
  800751:	5d                   	pop    %rbp
  800752:	c3                   	retq   

0000000000800753 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800753:	55                   	push   %rbp
  800754:	48 89 e5             	mov    %rsp,%rbp
  800757:	53                   	push   %rbx
  800758:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80075f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800766:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80076c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800773:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80077a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800781:	84 c0                	test   %al,%al
  800783:	74 23                	je     8007a8 <_panic+0x55>
  800785:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80078c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800790:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800794:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800798:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80079c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007a0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007a4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007a8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007af:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007b6:	00 00 00 
  8007b9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007c0:	00 00 00 
  8007c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007ce:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007dc:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007e3:	00 00 00 
  8007e6:	48 8b 18             	mov    (%rax),%rbx
  8007e9:	48 b8 f4 1d 80 00 00 	movabs $0x801df4,%rax
  8007f0:	00 00 00 
  8007f3:	ff d0                	callq  *%rax
  8007f5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8007fb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800802:	41 89 c8             	mov    %ecx,%r8d
  800805:	48 89 d1             	mov    %rdx,%rcx
  800808:	48 89 da             	mov    %rbx,%rdx
  80080b:	89 c6                	mov    %eax,%esi
  80080d:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  800814:	00 00 00 
  800817:	b8 00 00 00 00       	mov    $0x0,%eax
  80081c:	49 b9 8c 09 80 00 00 	movabs $0x80098c,%r9
  800823:	00 00 00 
  800826:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800829:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800830:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800837:	48 89 d6             	mov    %rdx,%rsi
  80083a:	48 89 c7             	mov    %rax,%rdi
  80083d:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800844:	00 00 00 
  800847:	ff d0                	callq  *%rax
	cprintf("\n");
  800849:	48 bf 43 48 80 00 00 	movabs $0x804843,%rdi
  800850:	00 00 00 
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80085f:	00 00 00 
  800862:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800864:	cc                   	int3   
  800865:	eb fd                	jmp    800864 <_panic+0x111>

0000000000800867 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 83 ec 10          	sub    $0x10,%rsp
  80086f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800872:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	8d 48 01             	lea    0x1(%rax),%ecx
  80087f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800883:	89 0a                	mov    %ecx,(%rdx)
  800885:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800888:	89 d1                	mov    %edx,%ecx
  80088a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80088e:	48 98                	cltq   
  800890:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089f:	75 2c                	jne    8008cd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a5:	8b 00                	mov    (%rax),%eax
  8008a7:	48 98                	cltq   
  8008a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ad:	48 83 c2 08          	add    $0x8,%rdx
  8008b1:	48 89 c6             	mov    %rax,%rsi
  8008b4:	48 89 d7             	mov    %rdx,%rdi
  8008b7:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  8008be:	00 00 00 
  8008c1:	ff d0                	callq  *%rax
        b->idx = 0;
  8008c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d1:	8b 40 04             	mov    0x4(%rax),%eax
  8008d4:	8d 50 01             	lea    0x1(%rax),%edx
  8008d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008db:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008eb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008f2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8008f9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800900:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800907:	48 8b 0a             	mov    (%rdx),%rcx
  80090a:	48 89 08             	mov    %rcx,(%rax)
  80090d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800911:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800915:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800919:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80091d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800924:	00 00 00 
    b.cnt = 0;
  800927:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80092e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800931:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800938:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80093f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800946:	48 89 c6             	mov    %rax,%rsi
  800949:	48 bf 67 08 80 00 00 	movabs $0x800867,%rdi
  800950:	00 00 00 
  800953:	48 b8 3f 0d 80 00 00 	movabs $0x800d3f,%rax
  80095a:	00 00 00 
  80095d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80095f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800965:	48 98                	cltq   
  800967:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80096e:	48 83 c2 08          	add    $0x8,%rdx
  800972:	48 89 c6             	mov    %rax,%rsi
  800975:	48 89 d7             	mov    %rdx,%rdi
  800978:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  80097f:	00 00 00 
  800982:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800984:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80098a:	c9                   	leaveq 
  80098b:	c3                   	retq   

000000000080098c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80098c:	55                   	push   %rbp
  80098d:	48 89 e5             	mov    %rsp,%rbp
  800990:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800997:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80099e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009a5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009ac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009b3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009ba:	84 c0                	test   %al,%al
  8009bc:	74 20                	je     8009de <cprintf+0x52>
  8009be:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009c2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009c6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009ca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009ce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009d2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009d6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009da:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009de:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009e5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009ec:	00 00 00 
  8009ef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009f6:	00 00 00 
  8009f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009fd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a04:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a0b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a12:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a19:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a20:	48 8b 0a             	mov    (%rdx),%rcx
  800a23:	48 89 08             	mov    %rcx,(%rax)
  800a26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a32:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a36:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a3d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a44:	48 89 d6             	mov    %rdx,%rsi
  800a47:	48 89 c7             	mov    %rax,%rdi
  800a4a:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800a51:	00 00 00 
  800a54:	ff d0                	callq  *%rax
  800a56:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a5c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a62:	c9                   	leaveq 
  800a63:	c3                   	retq   

0000000000800a64 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a64:	55                   	push   %rbp
  800a65:	48 89 e5             	mov    %rsp,%rbp
  800a68:	53                   	push   %rbx
  800a69:	48 83 ec 38          	sub    $0x38,%rsp
  800a6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a79:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a7c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a80:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a84:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a87:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a8b:	77 3b                	ja     800ac8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a90:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a94:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	48 f7 f3             	div    %rbx
  800aa3:	48 89 c2             	mov    %rax,%rdx
  800aa6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800aa9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800aac:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	41 89 f9             	mov    %edi,%r9d
  800ab7:	48 89 c7             	mov    %rax,%rdi
  800aba:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  800ac1:	00 00 00 
  800ac4:	ff d0                	callq  *%rax
  800ac6:	eb 1e                	jmp    800ae6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac8:	eb 12                	jmp    800adc <printnum+0x78>
			putch(padc, putdat);
  800aca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ace:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad5:	48 89 ce             	mov    %rcx,%rsi
  800ad8:	89 d7                	mov    %edx,%edi
  800ada:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800ae0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800ae4:	7f e4                	jg     800aca <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	48 f7 f1             	div    %rcx
  800af5:	48 89 d0             	mov    %rdx,%rax
  800af8:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  800aff:	00 00 00 
  800b02:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b06:	0f be d0             	movsbl %al,%edx
  800b09:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b11:	48 89 ce             	mov    %rcx,%rsi
  800b14:	89 d7                	mov    %edx,%edi
  800b16:	ff d0                	callq  *%rax
}
  800b18:	48 83 c4 38          	add    $0x38,%rsp
  800b1c:	5b                   	pop    %rbx
  800b1d:	5d                   	pop    %rbp
  800b1e:	c3                   	retq   

0000000000800b1f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1f:	55                   	push   %rbp
  800b20:	48 89 e5             	mov    %rsp,%rbp
  800b23:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b2b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b2e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b32:	7e 52                	jle    800b86 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b38:	8b 00                	mov    (%rax),%eax
  800b3a:	83 f8 30             	cmp    $0x30,%eax
  800b3d:	73 24                	jae    800b63 <getuint+0x44>
  800b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b43:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4b:	8b 00                	mov    (%rax),%eax
  800b4d:	89 c0                	mov    %eax,%eax
  800b4f:	48 01 d0             	add    %rdx,%rax
  800b52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b56:	8b 12                	mov    (%rdx),%edx
  800b58:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5f:	89 0a                	mov    %ecx,(%rdx)
  800b61:	eb 17                	jmp    800b7a <getuint+0x5b>
  800b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b67:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b6b:	48 89 d0             	mov    %rdx,%rax
  800b6e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b76:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b7a:	48 8b 00             	mov    (%rax),%rax
  800b7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b81:	e9 a3 00 00 00       	jmpq   800c29 <getuint+0x10a>
	else if (lflag)
  800b86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b8a:	74 4f                	je     800bdb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b90:	8b 00                	mov    (%rax),%eax
  800b92:	83 f8 30             	cmp    $0x30,%eax
  800b95:	73 24                	jae    800bbb <getuint+0x9c>
  800b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba3:	8b 00                	mov    (%rax),%eax
  800ba5:	89 c0                	mov    %eax,%eax
  800ba7:	48 01 d0             	add    %rdx,%rax
  800baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bae:	8b 12                	mov    (%rdx),%edx
  800bb0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb7:	89 0a                	mov    %ecx,(%rdx)
  800bb9:	eb 17                	jmp    800bd2 <getuint+0xb3>
  800bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc3:	48 89 d0             	mov    %rdx,%rax
  800bc6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bd2:	48 8b 00             	mov    (%rax),%rax
  800bd5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd9:	eb 4e                	jmp    800c29 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	83 f8 30             	cmp    $0x30,%eax
  800be4:	73 24                	jae    800c0a <getuint+0xeb>
  800be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf2:	8b 00                	mov    (%rax),%eax
  800bf4:	89 c0                	mov    %eax,%eax
  800bf6:	48 01 d0             	add    %rdx,%rax
  800bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfd:	8b 12                	mov    (%rdx),%edx
  800bff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c06:	89 0a                	mov    %ecx,(%rdx)
  800c08:	eb 17                	jmp    800c21 <getuint+0x102>
  800c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c12:	48 89 d0             	mov    %rdx,%rax
  800c15:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c21:	8b 00                	mov    (%rax),%eax
  800c23:	89 c0                	mov    %eax,%eax
  800c25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c2d:	c9                   	leaveq 
  800c2e:	c3                   	retq   

0000000000800c2f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c2f:	55                   	push   %rbp
  800c30:	48 89 e5             	mov    %rsp,%rbp
  800c33:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c3b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c3e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c42:	7e 52                	jle    800c96 <getint+0x67>
		x=va_arg(*ap, long long);
  800c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c48:	8b 00                	mov    (%rax),%eax
  800c4a:	83 f8 30             	cmp    $0x30,%eax
  800c4d:	73 24                	jae    800c73 <getint+0x44>
  800c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c53:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c5b:	8b 00                	mov    (%rax),%eax
  800c5d:	89 c0                	mov    %eax,%eax
  800c5f:	48 01 d0             	add    %rdx,%rax
  800c62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c66:	8b 12                	mov    (%rdx),%edx
  800c68:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c6f:	89 0a                	mov    %ecx,(%rdx)
  800c71:	eb 17                	jmp    800c8a <getint+0x5b>
  800c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c77:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c7b:	48 89 d0             	mov    %rdx,%rax
  800c7e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c86:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c8a:	48 8b 00             	mov    (%rax),%rax
  800c8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c91:	e9 a3 00 00 00       	jmpq   800d39 <getint+0x10a>
	else if (lflag)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c9a:	74 4f                	je     800ceb <getint+0xbc>
		x=va_arg(*ap, long);
  800c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca0:	8b 00                	mov    (%rax),%eax
  800ca2:	83 f8 30             	cmp    $0x30,%eax
  800ca5:	73 24                	jae    800ccb <getint+0x9c>
  800ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb3:	8b 00                	mov    (%rax),%eax
  800cb5:	89 c0                	mov    %eax,%eax
  800cb7:	48 01 d0             	add    %rdx,%rax
  800cba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cbe:	8b 12                	mov    (%rdx),%edx
  800cc0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cc3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc7:	89 0a                	mov    %ecx,(%rdx)
  800cc9:	eb 17                	jmp    800ce2 <getint+0xb3>
  800ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cd3:	48 89 d0             	mov    %rdx,%rax
  800cd6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cde:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ce2:	48 8b 00             	mov    (%rax),%rax
  800ce5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ce9:	eb 4e                	jmp    800d39 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cef:	8b 00                	mov    (%rax),%eax
  800cf1:	83 f8 30             	cmp    $0x30,%eax
  800cf4:	73 24                	jae    800d1a <getint+0xeb>
  800cf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d02:	8b 00                	mov    (%rax),%eax
  800d04:	89 c0                	mov    %eax,%eax
  800d06:	48 01 d0             	add    %rdx,%rax
  800d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0d:	8b 12                	mov    (%rdx),%edx
  800d0f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d16:	89 0a                	mov    %ecx,(%rdx)
  800d18:	eb 17                	jmp    800d31 <getint+0x102>
  800d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d22:	48 89 d0             	mov    %rdx,%rax
  800d25:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d31:	8b 00                	mov    (%rax),%eax
  800d33:	48 98                	cltq   
  800d35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d3d:	c9                   	leaveq 
  800d3e:	c3                   	retq   

0000000000800d3f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d3f:	55                   	push   %rbp
  800d40:	48 89 e5             	mov    %rsp,%rbp
  800d43:	41 54                	push   %r12
  800d45:	53                   	push   %rbx
  800d46:	48 83 ec 60          	sub    $0x60,%rsp
  800d4a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d4e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d52:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d56:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d62:	48 8b 0a             	mov    (%rdx),%rcx
  800d65:	48 89 08             	mov    %rcx,(%rax)
  800d68:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d6c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d70:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d74:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d78:	eb 17                	jmp    800d91 <vprintfmt+0x52>
			if (ch == '\0')
  800d7a:	85 db                	test   %ebx,%ebx
  800d7c:	0f 84 cc 04 00 00    	je     80124e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8a:	48 89 d6             	mov    %rdx,%rsi
  800d8d:	89 df                	mov    %ebx,%edi
  800d8f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d91:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d95:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d99:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d9d:	0f b6 00             	movzbl (%rax),%eax
  800da0:	0f b6 d8             	movzbl %al,%ebx
  800da3:	83 fb 25             	cmp    $0x25,%ebx
  800da6:	75 d2                	jne    800d7a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800da8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800dac:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800db3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800dba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dc1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dc8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dcc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dd0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dd4:	0f b6 00             	movzbl (%rax),%eax
  800dd7:	0f b6 d8             	movzbl %al,%ebx
  800dda:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ddd:	83 f8 55             	cmp    $0x55,%eax
  800de0:	0f 87 34 04 00 00    	ja     80121a <vprintfmt+0x4db>
  800de6:	89 c0                	mov    %eax,%eax
  800de8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800def:	00 
  800df0:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
  800df7:	00 00 00 
  800dfa:	48 01 d0             	add    %rdx,%rax
  800dfd:	48 8b 00             	mov    (%rax),%rax
  800e00:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800e02:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e06:	eb c0                	jmp    800dc8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e08:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e0c:	eb ba                	jmp    800dc8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e0e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e15:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e18:	89 d0                	mov    %edx,%eax
  800e1a:	c1 e0 02             	shl    $0x2,%eax
  800e1d:	01 d0                	add    %edx,%eax
  800e1f:	01 c0                	add    %eax,%eax
  800e21:	01 d8                	add    %ebx,%eax
  800e23:	83 e8 30             	sub    $0x30,%eax
  800e26:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e29:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e2d:	0f b6 00             	movzbl (%rax),%eax
  800e30:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e33:	83 fb 2f             	cmp    $0x2f,%ebx
  800e36:	7e 0c                	jle    800e44 <vprintfmt+0x105>
  800e38:	83 fb 39             	cmp    $0x39,%ebx
  800e3b:	7f 07                	jg     800e44 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d1                	jmp    800e15 <vprintfmt+0xd6>
			goto process_precision;
  800e44:	eb 58                	jmp    800e9e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e49:	83 f8 30             	cmp    $0x30,%eax
  800e4c:	73 17                	jae    800e65 <vprintfmt+0x126>
  800e4e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e55:	89 c0                	mov    %eax,%eax
  800e57:	48 01 d0             	add    %rdx,%rax
  800e5a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5d:	83 c2 08             	add    $0x8,%edx
  800e60:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e63:	eb 0f                	jmp    800e74 <vprintfmt+0x135>
  800e65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e69:	48 89 d0             	mov    %rdx,%rax
  800e6c:	48 83 c2 08          	add    $0x8,%rdx
  800e70:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e74:	8b 00                	mov    (%rax),%eax
  800e76:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e79:	eb 23                	jmp    800e9e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7f:	79 0c                	jns    800e8d <vprintfmt+0x14e>
				width = 0;
  800e81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e88:	e9 3b ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>
  800e8d:	e9 36 ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e92:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e99:	e9 2a ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800e9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea2:	79 12                	jns    800eb6 <vprintfmt+0x177>
				width = precision, precision = -1;
  800ea4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800eaa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800eb1:	e9 12 ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>
  800eb6:	e9 0d ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ebb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ebf:	e9 04 ff ff ff       	jmpq   800dc8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ec4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec7:	83 f8 30             	cmp    $0x30,%eax
  800eca:	73 17                	jae    800ee3 <vprintfmt+0x1a4>
  800ecc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ed0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed3:	89 c0                	mov    %eax,%eax
  800ed5:	48 01 d0             	add    %rdx,%rax
  800ed8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800edb:	83 c2 08             	add    $0x8,%edx
  800ede:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ee1:	eb 0f                	jmp    800ef2 <vprintfmt+0x1b3>
  800ee3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ee7:	48 89 d0             	mov    %rdx,%rax
  800eea:	48 83 c2 08          	add    $0x8,%rdx
  800eee:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ef2:	8b 10                	mov    (%rax),%edx
  800ef4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ef8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efc:	48 89 ce             	mov    %rcx,%rsi
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	ff d0                	callq  *%rax
			break;
  800f03:	e9 40 03 00 00       	jmpq   801248 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0b:	83 f8 30             	cmp    $0x30,%eax
  800f0e:	73 17                	jae    800f27 <vprintfmt+0x1e8>
  800f10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f17:	89 c0                	mov    %eax,%eax
  800f19:	48 01 d0             	add    %rdx,%rax
  800f1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f1f:	83 c2 08             	add    $0x8,%edx
  800f22:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f25:	eb 0f                	jmp    800f36 <vprintfmt+0x1f7>
  800f27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f2b:	48 89 d0             	mov    %rdx,%rax
  800f2e:	48 83 c2 08          	add    $0x8,%rdx
  800f32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f36:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f38:	85 db                	test   %ebx,%ebx
  800f3a:	79 02                	jns    800f3e <vprintfmt+0x1ff>
				err = -err;
  800f3c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f3e:	83 fb 15             	cmp    $0x15,%ebx
  800f41:	7f 16                	jg     800f59 <vprintfmt+0x21a>
  800f43:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  800f4a:	00 00 00 
  800f4d:	48 63 d3             	movslq %ebx,%rdx
  800f50:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f54:	4d 85 e4             	test   %r12,%r12
  800f57:	75 2e                	jne    800f87 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	89 d9                	mov    %ebx,%ecx
  800f63:	48 ba 61 4a 80 00 00 	movabs $0x804a61,%rdx
  800f6a:	00 00 00 
  800f6d:	48 89 c7             	mov    %rax,%rdi
  800f70:	b8 00 00 00 00       	mov    $0x0,%eax
  800f75:	49 b8 57 12 80 00 00 	movabs $0x801257,%r8
  800f7c:	00 00 00 
  800f7f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f82:	e9 c1 02 00 00       	jmpq   801248 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f87:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8f:	4c 89 e1             	mov    %r12,%rcx
  800f92:	48 ba 6a 4a 80 00 00 	movabs $0x804a6a,%rdx
  800f99:	00 00 00 
  800f9c:	48 89 c7             	mov    %rax,%rdi
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa4:	49 b8 57 12 80 00 00 	movabs $0x801257,%r8
  800fab:	00 00 00 
  800fae:	41 ff d0             	callq  *%r8
			break;
  800fb1:	e9 92 02 00 00       	jmpq   801248 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb9:	83 f8 30             	cmp    $0x30,%eax
  800fbc:	73 17                	jae    800fd5 <vprintfmt+0x296>
  800fbe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc5:	89 c0                	mov    %eax,%eax
  800fc7:	48 01 d0             	add    %rdx,%rax
  800fca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fcd:	83 c2 08             	add    $0x8,%edx
  800fd0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fd3:	eb 0f                	jmp    800fe4 <vprintfmt+0x2a5>
  800fd5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fd9:	48 89 d0             	mov    %rdx,%rax
  800fdc:	48 83 c2 08          	add    $0x8,%rdx
  800fe0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fe4:	4c 8b 20             	mov    (%rax),%r12
  800fe7:	4d 85 e4             	test   %r12,%r12
  800fea:	75 0a                	jne    800ff6 <vprintfmt+0x2b7>
				p = "(null)";
  800fec:	49 bc 6d 4a 80 00 00 	movabs $0x804a6d,%r12
  800ff3:	00 00 00 
			if (width > 0 && padc != '-')
  800ff6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ffa:	7e 3f                	jle    80103b <vprintfmt+0x2fc>
  800ffc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801000:	74 39                	je     80103b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801002:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801005:	48 98                	cltq   
  801007:	48 89 c6             	mov    %rax,%rsi
  80100a:	4c 89 e7             	mov    %r12,%rdi
  80100d:	48 b8 03 15 80 00 00 	movabs $0x801503,%rax
  801014:	00 00 00 
  801017:	ff d0                	callq  *%rax
  801019:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80101c:	eb 17                	jmp    801035 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80101e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801022:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801026:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80102a:	48 89 ce             	mov    %rcx,%rsi
  80102d:	89 d7                	mov    %edx,%edi
  80102f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801031:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801035:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801039:	7f e3                	jg     80101e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80103b:	eb 37                	jmp    801074 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80103d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801041:	74 1e                	je     801061 <vprintfmt+0x322>
  801043:	83 fb 1f             	cmp    $0x1f,%ebx
  801046:	7e 05                	jle    80104d <vprintfmt+0x30e>
  801048:	83 fb 7e             	cmp    $0x7e,%ebx
  80104b:	7e 14                	jle    801061 <vprintfmt+0x322>
					putch('?', putdat);
  80104d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801051:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801055:	48 89 d6             	mov    %rdx,%rsi
  801058:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80105d:	ff d0                	callq  *%rax
  80105f:	eb 0f                	jmp    801070 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801061:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801065:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801069:	48 89 d6             	mov    %rdx,%rsi
  80106c:	89 df                	mov    %ebx,%edi
  80106e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801070:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801074:	4c 89 e0             	mov    %r12,%rax
  801077:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80107b:	0f b6 00             	movzbl (%rax),%eax
  80107e:	0f be d8             	movsbl %al,%ebx
  801081:	85 db                	test   %ebx,%ebx
  801083:	74 10                	je     801095 <vprintfmt+0x356>
  801085:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801089:	78 b2                	js     80103d <vprintfmt+0x2fe>
  80108b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80108f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801093:	79 a8                	jns    80103d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801095:	eb 16                	jmp    8010ad <vprintfmt+0x36e>
				putch(' ', putdat);
  801097:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80109f:	48 89 d6             	mov    %rdx,%rsi
  8010a2:	bf 20 00 00 00       	mov    $0x20,%edi
  8010a7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010a9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010b1:	7f e4                	jg     801097 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010b3:	e9 90 01 00 00       	jmpq   801248 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010bc:	be 03 00 00 00       	mov    $0x3,%esi
  8010c1:	48 89 c7             	mov    %rax,%rdi
  8010c4:	48 b8 2f 0c 80 00 00 	movabs $0x800c2f,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
  8010d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 85 c0             	test   %rax,%rax
  8010db:	79 1d                	jns    8010fa <vprintfmt+0x3bb>
				putch('-', putdat);
  8010dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e5:	48 89 d6             	mov    %rdx,%rsi
  8010e8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010ed:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	48 f7 d8             	neg    %rax
  8010f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010fa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801101:	e9 d5 00 00 00       	jmpq   8011db <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801106:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80110a:	be 03 00 00 00       	mov    $0x3,%esi
  80110f:	48 89 c7             	mov    %rax,%rdi
  801112:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  801119:	00 00 00 
  80111c:	ff d0                	callq  *%rax
  80111e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801122:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801129:	e9 ad 00 00 00       	jmpq   8011db <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80112e:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801131:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801135:	89 d6                	mov    %edx,%esi
  801137:	48 89 c7             	mov    %rax,%rdi
  80113a:	48 b8 2f 0c 80 00 00 	movabs $0x800c2f,%rax
  801141:	00 00 00 
  801144:	ff d0                	callq  *%rax
  801146:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80114a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801151:	e9 85 00 00 00       	jmpq   8011db <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801156:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80115a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80115e:	48 89 d6             	mov    %rdx,%rsi
  801161:	bf 30 00 00 00       	mov    $0x30,%edi
  801166:	ff d0                	callq  *%rax
			putch('x', putdat);
  801168:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80116c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801170:	48 89 d6             	mov    %rdx,%rsi
  801173:	bf 78 00 00 00       	mov    $0x78,%edi
  801178:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80117a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80117d:	83 f8 30             	cmp    $0x30,%eax
  801180:	73 17                	jae    801199 <vprintfmt+0x45a>
  801182:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801186:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801189:	89 c0                	mov    %eax,%eax
  80118b:	48 01 d0             	add    %rdx,%rax
  80118e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801191:	83 c2 08             	add    $0x8,%edx
  801194:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801197:	eb 0f                	jmp    8011a8 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801199:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80119d:	48 89 d0             	mov    %rdx,%rax
  8011a0:	48 83 c2 08          	add    $0x8,%rdx
  8011a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011a8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011af:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011b6:	eb 23                	jmp    8011db <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011bc:	be 03 00 00 00       	mov    $0x3,%esi
  8011c1:	48 89 c7             	mov    %rax,%rdi
  8011c4:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  8011cb:	00 00 00 
  8011ce:	ff d0                	callq  *%rax
  8011d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011d4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011db:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011e0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011e3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011f2:	45 89 c1             	mov    %r8d,%r9d
  8011f5:	41 89 f8             	mov    %edi,%r8d
  8011f8:	48 89 c7             	mov    %rax,%rdi
  8011fb:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  801202:	00 00 00 
  801205:	ff d0                	callq  *%rax
			break;
  801207:	eb 3f                	jmp    801248 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801209:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80120d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801211:	48 89 d6             	mov    %rdx,%rsi
  801214:	89 df                	mov    %ebx,%edi
  801216:	ff d0                	callq  *%rax
			break;
  801218:	eb 2e                	jmp    801248 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80121a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801222:	48 89 d6             	mov    %rdx,%rsi
  801225:	bf 25 00 00 00       	mov    $0x25,%edi
  80122a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80122c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801231:	eb 05                	jmp    801238 <vprintfmt+0x4f9>
  801233:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801238:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80123c:	48 83 e8 01          	sub    $0x1,%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	3c 25                	cmp    $0x25,%al
  801245:	75 ec                	jne    801233 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801247:	90                   	nop
		}
	}
  801248:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801249:	e9 43 fb ff ff       	jmpq   800d91 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80124e:	48 83 c4 60          	add    $0x60,%rsp
  801252:	5b                   	pop    %rbx
  801253:	41 5c                	pop    %r12
  801255:	5d                   	pop    %rbp
  801256:	c3                   	retq   

0000000000801257 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801262:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801269:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801270:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801277:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80127e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801285:	84 c0                	test   %al,%al
  801287:	74 20                	je     8012a9 <printfmt+0x52>
  801289:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80128d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801291:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801295:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801299:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80129d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012a1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012a5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012a9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012b0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012b7:	00 00 00 
  8012ba:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012c1:	00 00 00 
  8012c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012cf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012d6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012dd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012e4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012eb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012f2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012f9:	48 89 c7             	mov    %rax,%rdi
  8012fc:	48 b8 3f 0d 80 00 00 	movabs $0x800d3f,%rax
  801303:	00 00 00 
  801306:	ff d0                	callq  *%rax
	va_end(ap);
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 10          	sub    $0x10,%rsp
  801312:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801315:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131d:	8b 40 10             	mov    0x10(%rax),%eax
  801320:	8d 50 01             	lea    0x1(%rax),%edx
  801323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801327:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80132a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132e:	48 8b 10             	mov    (%rax),%rdx
  801331:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801335:	48 8b 40 08          	mov    0x8(%rax),%rax
  801339:	48 39 c2             	cmp    %rax,%rdx
  80133c:	73 17                	jae    801355 <sprintputch+0x4b>
		*b->buf++ = ch;
  80133e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801342:	48 8b 00             	mov    (%rax),%rax
  801345:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80134d:	48 89 0a             	mov    %rcx,(%rdx)
  801350:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801353:	88 10                	mov    %dl,(%rax)
}
  801355:	c9                   	leaveq 
  801356:	c3                   	retq   

0000000000801357 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	48 83 ec 50          	sub    $0x50,%rsp
  80135f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801363:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801366:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80136a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80136e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801372:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801376:	48 8b 0a             	mov    (%rdx),%rcx
  801379:	48 89 08             	mov    %rcx,(%rax)
  80137c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801380:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801384:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801388:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80138c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801390:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801394:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801397:	48 98                	cltq   
  801399:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80139d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013a1:	48 01 d0             	add    %rdx,%rax
  8013a4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013af:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013b4:	74 06                	je     8013bc <vsnprintf+0x65>
  8013b6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013ba:	7f 07                	jg     8013c3 <vsnprintf+0x6c>
		return -E_INVAL;
  8013bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c1:	eb 2f                	jmp    8013f2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013c3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013c7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013cf:	48 89 c6             	mov    %rax,%rsi
  8013d2:	48 bf 0a 13 80 00 00 	movabs $0x80130a,%rdi
  8013d9:	00 00 00 
  8013dc:	48 b8 3f 0d 80 00 00 	movabs $0x800d3f,%rax
  8013e3:	00 00 00 
  8013e6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013ec:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013ef:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013f2:	c9                   	leaveq 
  8013f3:	c3                   	retq   

00000000008013f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013f4:	55                   	push   %rbp
  8013f5:	48 89 e5             	mov    %rsp,%rbp
  8013f8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013ff:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801406:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80140c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801413:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80141a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801421:	84 c0                	test   %al,%al
  801423:	74 20                	je     801445 <snprintf+0x51>
  801425:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801429:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80142d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801431:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801435:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801439:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80143d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801441:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801445:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80144c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801453:	00 00 00 
  801456:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80145d:	00 00 00 
  801460:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801464:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80146b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801472:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801479:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801480:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801487:	48 8b 0a             	mov    (%rdx),%rcx
  80148a:	48 89 08             	mov    %rcx,(%rax)
  80148d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801491:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801495:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801499:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80149d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014a4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014ab:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014b1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014b8:	48 89 c7             	mov    %rax,%rdi
  8014bb:	48 b8 57 13 80 00 00 	movabs $0x801357,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	callq  *%rax
  8014c7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014cd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 18          	sub    $0x18,%rsp
  8014dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014e8:	eb 09                	jmp    8014f3 <strlen+0x1e>
		n++;
  8014ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	84 c0                	test   %al,%al
  8014fc:	75 ec                	jne    8014ea <strlen+0x15>
		n++;
	return n;
  8014fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 20          	sub    $0x20,%rsp
  80150b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80151a:	eb 0e                	jmp    80152a <strnlen+0x27>
		n++;
  80151c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801520:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801525:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80152a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80152f:	74 0b                	je     80153c <strnlen+0x39>
  801531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	84 c0                	test   %al,%al
  80153a:	75 e0                	jne    80151c <strnlen+0x19>
		n++;
	return n;
  80153c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80153f:	c9                   	leaveq 
  801540:	c3                   	retq   

0000000000801541 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	48 83 ec 20          	sub    $0x20,%rsp
  801549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801555:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801559:	90                   	nop
  80155a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801562:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801566:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80156a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80156e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801572:	0f b6 12             	movzbl (%rdx),%edx
  801575:	88 10                	mov    %dl,(%rax)
  801577:	0f b6 00             	movzbl (%rax),%eax
  80157a:	84 c0                	test   %al,%al
  80157c:	75 dc                	jne    80155a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80157e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801582:	c9                   	leaveq 
  801583:	c3                   	retq   

0000000000801584 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801584:	55                   	push   %rbp
  801585:	48 89 e5             	mov    %rsp,%rbp
  801588:	48 83 ec 20          	sub    $0x20,%rsp
  80158c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801590:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801598:	48 89 c7             	mov    %rax,%rdi
  80159b:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  8015a2:	00 00 00 
  8015a5:	ff d0                	callq  *%rax
  8015a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ad:	48 63 d0             	movslq %eax,%rdx
  8015b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b4:	48 01 c2             	add    %rax,%rdx
  8015b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015bb:	48 89 c6             	mov    %rax,%rsi
  8015be:	48 89 d7             	mov    %rdx,%rdi
  8015c1:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  8015c8:	00 00 00 
  8015cb:	ff d0                	callq  *%rax
	return dst;
  8015cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d1:	c9                   	leaveq 
  8015d2:	c3                   	retq   

00000000008015d3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015d3:	55                   	push   %rbp
  8015d4:	48 89 e5             	mov    %rsp,%rbp
  8015d7:	48 83 ec 28          	sub    $0x28,%rsp
  8015db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015f6:	00 
  8015f7:	eb 2a                	jmp    801623 <strncpy+0x50>
		*dst++ = *src;
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801601:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801605:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801609:	0f b6 12             	movzbl (%rdx),%edx
  80160c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80160e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801612:	0f b6 00             	movzbl (%rax),%eax
  801615:	84 c0                	test   %al,%al
  801617:	74 05                	je     80161e <strncpy+0x4b>
			src++;
  801619:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80161e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80162b:	72 cc                	jb     8015f9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80162d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801631:	c9                   	leaveq 
  801632:	c3                   	retq   

0000000000801633 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	48 83 ec 28          	sub    $0x28,%rsp
  80163b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80163f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801643:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80164f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801654:	74 3d                	je     801693 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801656:	eb 1d                	jmp    801675 <strlcpy+0x42>
			*dst++ = *src++;
  801658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801660:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801664:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801668:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80166c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801670:	0f b6 12             	movzbl (%rdx),%edx
  801673:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801675:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80167a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80167f:	74 0b                	je     80168c <strlcpy+0x59>
  801681:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	84 c0                	test   %al,%al
  80168a:	75 cc                	jne    801658 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80168c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801690:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169b:	48 29 c2             	sub    %rax,%rdx
  80169e:	48 89 d0             	mov    %rdx,%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 10          	sub    $0x10,%rsp
  8016ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016b3:	eb 0a                	jmp    8016bf <strcmp+0x1c>
		p++, q++;
  8016b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	84 c0                	test   %al,%al
  8016c8:	74 12                	je     8016dc <strcmp+0x39>
  8016ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ce:	0f b6 10             	movzbl (%rax),%edx
  8016d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	38 c2                	cmp    %al,%dl
  8016da:	74 d9                	je     8016b5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	0f b6 d0             	movzbl %al,%edx
  8016e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	0f b6 c0             	movzbl %al,%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
}
  8016f4:	c9                   	leaveq 
  8016f5:	c3                   	retq   

00000000008016f6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f6:	55                   	push   %rbp
  8016f7:	48 89 e5             	mov    %rsp,%rbp
  8016fa:	48 83 ec 18          	sub    $0x18,%rsp
  8016fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801702:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801706:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80170a:	eb 0f                	jmp    80171b <strncmp+0x25>
		n--, p++, q++;
  80170c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801711:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801716:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80171b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801720:	74 1d                	je     80173f <strncmp+0x49>
  801722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	84 c0                	test   %al,%al
  80172b:	74 12                	je     80173f <strncmp+0x49>
  80172d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801731:	0f b6 10             	movzbl (%rax),%edx
  801734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	38 c2                	cmp    %al,%dl
  80173d:	74 cd                	je     80170c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80173f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801744:	75 07                	jne    80174d <strncmp+0x57>
		return 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
  80174b:	eb 18                	jmp    801765 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80174d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	0f b6 d0             	movzbl %al,%edx
  801757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175b:	0f b6 00             	movzbl (%rax),%eax
  80175e:	0f b6 c0             	movzbl %al,%eax
  801761:	29 c2                	sub    %eax,%edx
  801763:	89 d0                	mov    %edx,%eax
}
  801765:	c9                   	leaveq 
  801766:	c3                   	retq   

0000000000801767 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	48 83 ec 0c          	sub    $0xc,%rsp
  80176f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801773:	89 f0                	mov    %esi,%eax
  801775:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801778:	eb 17                	jmp    801791 <strchr+0x2a>
		if (*s == c)
  80177a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801784:	75 06                	jne    80178c <strchr+0x25>
			return (char *) s;
  801786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178a:	eb 15                	jmp    8017a1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801795:	0f b6 00             	movzbl (%rax),%eax
  801798:	84 c0                	test   %al,%al
  80179a:	75 de                	jne    80177a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a1:	c9                   	leaveq 
  8017a2:	c3                   	retq   

00000000008017a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	48 83 ec 0c          	sub    $0xc,%rsp
  8017ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017af:	89 f0                	mov    %esi,%eax
  8017b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017b4:	eb 13                	jmp    8017c9 <strfind+0x26>
		if (*s == c)
  8017b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ba:	0f b6 00             	movzbl (%rax),%eax
  8017bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017c0:	75 02                	jne    8017c4 <strfind+0x21>
			break;
  8017c2:	eb 10                	jmp    8017d4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017cd:	0f b6 00             	movzbl (%rax),%eax
  8017d0:	84 c0                	test   %al,%al
  8017d2:	75 e2                	jne    8017b6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017d8:	c9                   	leaveq 
  8017d9:	c3                   	retq   

00000000008017da <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	48 83 ec 18          	sub    $0x18,%rsp
  8017e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f2:	75 06                	jne    8017fa <memset+0x20>
		return v;
  8017f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f8:	eb 69                	jmp    801863 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fe:	83 e0 03             	and    $0x3,%eax
  801801:	48 85 c0             	test   %rax,%rax
  801804:	75 48                	jne    80184e <memset+0x74>
  801806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180a:	83 e0 03             	and    $0x3,%eax
  80180d:	48 85 c0             	test   %rax,%rax
  801810:	75 3c                	jne    80184e <memset+0x74>
		c &= 0xFF;
  801812:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801819:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80181c:	c1 e0 18             	shl    $0x18,%eax
  80181f:	89 c2                	mov    %eax,%edx
  801821:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801824:	c1 e0 10             	shl    $0x10,%eax
  801827:	09 c2                	or     %eax,%edx
  801829:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80182c:	c1 e0 08             	shl    $0x8,%eax
  80182f:	09 d0                	or     %edx,%eax
  801831:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801838:	48 c1 e8 02          	shr    $0x2,%rax
  80183c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80183f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801843:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801846:	48 89 d7             	mov    %rdx,%rdi
  801849:	fc                   	cld    
  80184a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80184c:	eb 11                	jmp    80185f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80184e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801852:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801855:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801859:	48 89 d7             	mov    %rdx,%rdi
  80185c:	fc                   	cld    
  80185d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80185f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801863:	c9                   	leaveq 
  801864:	c3                   	retq   

0000000000801865 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	48 83 ec 28          	sub    $0x28,%rsp
  80186d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801871:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801875:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80187d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801885:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801891:	0f 83 88 00 00 00    	jae    80191f <memmove+0xba>
  801897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80189f:	48 01 d0             	add    %rdx,%rax
  8018a2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018a6:	76 77                	jbe    80191f <memmove+0xba>
		s += n;
  8018a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ac:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bc:	83 e0 03             	and    $0x3,%eax
  8018bf:	48 85 c0             	test   %rax,%rax
  8018c2:	75 3b                	jne    8018ff <memmove+0x9a>
  8018c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c8:	83 e0 03             	and    $0x3,%eax
  8018cb:	48 85 c0             	test   %rax,%rax
  8018ce:	75 2f                	jne    8018ff <memmove+0x9a>
  8018d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d4:	83 e0 03             	and    $0x3,%eax
  8018d7:	48 85 c0             	test   %rax,%rax
  8018da:	75 23                	jne    8018ff <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e0:	48 83 e8 04          	sub    $0x4,%rax
  8018e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e8:	48 83 ea 04          	sub    $0x4,%rdx
  8018ec:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018f0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018f4:	48 89 c7             	mov    %rax,%rdi
  8018f7:	48 89 d6             	mov    %rdx,%rsi
  8018fa:	fd                   	std    
  8018fb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018fd:	eb 1d                	jmp    80191c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801903:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	48 89 d7             	mov    %rdx,%rdi
  801916:	48 89 c1             	mov    %rax,%rcx
  801919:	fd                   	std    
  80191a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80191c:	fc                   	cld    
  80191d:	eb 57                	jmp    801976 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80191f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801923:	83 e0 03             	and    $0x3,%eax
  801926:	48 85 c0             	test   %rax,%rax
  801929:	75 36                	jne    801961 <memmove+0xfc>
  80192b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192f:	83 e0 03             	and    $0x3,%eax
  801932:	48 85 c0             	test   %rax,%rax
  801935:	75 2a                	jne    801961 <memmove+0xfc>
  801937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193b:	83 e0 03             	and    $0x3,%eax
  80193e:	48 85 c0             	test   %rax,%rax
  801941:	75 1e                	jne    801961 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	48 c1 e8 02          	shr    $0x2,%rax
  80194b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80194e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801952:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801956:	48 89 c7             	mov    %rax,%rdi
  801959:	48 89 d6             	mov    %rdx,%rsi
  80195c:	fc                   	cld    
  80195d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80195f:	eb 15                	jmp    801976 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801965:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801969:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80196d:	48 89 c7             	mov    %rax,%rdi
  801970:	48 89 d6             	mov    %rdx,%rsi
  801973:	fc                   	cld    
  801974:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197a:	c9                   	leaveq 
  80197b:	c3                   	retq   

000000000080197c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80197c:	55                   	push   %rbp
  80197d:	48 89 e5             	mov    %rsp,%rbp
  801980:	48 83 ec 18          	sub    $0x18,%rsp
  801984:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801988:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801990:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801994:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199c:	48 89 ce             	mov    %rcx,%rsi
  80199f:	48 89 c7             	mov    %rax,%rdi
  8019a2:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	callq  *%rax
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 28          	sub    $0x28,%rsp
  8019b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019d4:	eb 36                	jmp    801a0c <memcmp+0x5c>
		if (*s1 != *s2)
  8019d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019da:	0f b6 10             	movzbl (%rax),%edx
  8019dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e1:	0f b6 00             	movzbl (%rax),%eax
  8019e4:	38 c2                	cmp    %al,%dl
  8019e6:	74 1a                	je     801a02 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ec:	0f b6 00             	movzbl (%rax),%eax
  8019ef:	0f b6 d0             	movzbl %al,%edx
  8019f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f6:	0f b6 00             	movzbl (%rax),%eax
  8019f9:	0f b6 c0             	movzbl %al,%eax
  8019fc:	29 c2                	sub    %eax,%edx
  8019fe:	89 d0                	mov    %edx,%eax
  801a00:	eb 20                	jmp    801a22 <memcmp+0x72>
		s1++, s2++;
  801a02:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a07:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a18:	48 85 c0             	test   %rax,%rax
  801a1b:	75 b9                	jne    8019d6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a22:	c9                   	leaveq 
  801a23:	c3                   	retq   

0000000000801a24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a24:	55                   	push   %rbp
  801a25:	48 89 e5             	mov    %rsp,%rbp
  801a28:	48 83 ec 28          	sub    $0x28,%rsp
  801a2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a30:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a3f:	48 01 d0             	add    %rdx,%rax
  801a42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a46:	eb 15                	jmp    801a5d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a4c:	0f b6 10             	movzbl (%rax),%edx
  801a4f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a52:	38 c2                	cmp    %al,%dl
  801a54:	75 02                	jne    801a58 <memfind+0x34>
			break;
  801a56:	eb 0f                	jmp    801a67 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a58:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a61:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a65:	72 e1                	jb     801a48 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 34          	sub    $0x34,%rsp
  801a75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a7d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a87:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a8e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a8f:	eb 05                	jmp    801a96 <strtol+0x29>
		s++;
  801a91:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9a:	0f b6 00             	movzbl (%rax),%eax
  801a9d:	3c 20                	cmp    $0x20,%al
  801a9f:	74 f0                	je     801a91 <strtol+0x24>
  801aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa5:	0f b6 00             	movzbl (%rax),%eax
  801aa8:	3c 09                	cmp    $0x9,%al
  801aaa:	74 e5                	je     801a91 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801aac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab0:	0f b6 00             	movzbl (%rax),%eax
  801ab3:	3c 2b                	cmp    $0x2b,%al
  801ab5:	75 07                	jne    801abe <strtol+0x51>
		s++;
  801ab7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801abc:	eb 17                	jmp    801ad5 <strtol+0x68>
	else if (*s == '-')
  801abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac2:	0f b6 00             	movzbl (%rax),%eax
  801ac5:	3c 2d                	cmp    $0x2d,%al
  801ac7:	75 0c                	jne    801ad5 <strtol+0x68>
		s++, neg = 1;
  801ac9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ad9:	74 06                	je     801ae1 <strtol+0x74>
  801adb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801adf:	75 28                	jne    801b09 <strtol+0x9c>
  801ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae5:	0f b6 00             	movzbl (%rax),%eax
  801ae8:	3c 30                	cmp    $0x30,%al
  801aea:	75 1d                	jne    801b09 <strtol+0x9c>
  801aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af0:	48 83 c0 01          	add    $0x1,%rax
  801af4:	0f b6 00             	movzbl (%rax),%eax
  801af7:	3c 78                	cmp    $0x78,%al
  801af9:	75 0e                	jne    801b09 <strtol+0x9c>
		s += 2, base = 16;
  801afb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b00:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b07:	eb 2c                	jmp    801b35 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b09:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b0d:	75 19                	jne    801b28 <strtol+0xbb>
  801b0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b13:	0f b6 00             	movzbl (%rax),%eax
  801b16:	3c 30                	cmp    $0x30,%al
  801b18:	75 0e                	jne    801b28 <strtol+0xbb>
		s++, base = 8;
  801b1a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b1f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b26:	eb 0d                	jmp    801b35 <strtol+0xc8>
	else if (base == 0)
  801b28:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b2c:	75 07                	jne    801b35 <strtol+0xc8>
		base = 10;
  801b2e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b39:	0f b6 00             	movzbl (%rax),%eax
  801b3c:	3c 2f                	cmp    $0x2f,%al
  801b3e:	7e 1d                	jle    801b5d <strtol+0xf0>
  801b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b44:	0f b6 00             	movzbl (%rax),%eax
  801b47:	3c 39                	cmp    $0x39,%al
  801b49:	7f 12                	jg     801b5d <strtol+0xf0>
			dig = *s - '0';
  801b4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4f:	0f b6 00             	movzbl (%rax),%eax
  801b52:	0f be c0             	movsbl %al,%eax
  801b55:	83 e8 30             	sub    $0x30,%eax
  801b58:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b5b:	eb 4e                	jmp    801bab <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b61:	0f b6 00             	movzbl (%rax),%eax
  801b64:	3c 60                	cmp    $0x60,%al
  801b66:	7e 1d                	jle    801b85 <strtol+0x118>
  801b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6c:	0f b6 00             	movzbl (%rax),%eax
  801b6f:	3c 7a                	cmp    $0x7a,%al
  801b71:	7f 12                	jg     801b85 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	0f be c0             	movsbl %al,%eax
  801b7d:	83 e8 57             	sub    $0x57,%eax
  801b80:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b83:	eb 26                	jmp    801bab <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b89:	0f b6 00             	movzbl (%rax),%eax
  801b8c:	3c 40                	cmp    $0x40,%al
  801b8e:	7e 48                	jle    801bd8 <strtol+0x16b>
  801b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b94:	0f b6 00             	movzbl (%rax),%eax
  801b97:	3c 5a                	cmp    $0x5a,%al
  801b99:	7f 3d                	jg     801bd8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9f:	0f b6 00             	movzbl (%rax),%eax
  801ba2:	0f be c0             	movsbl %al,%eax
  801ba5:	83 e8 37             	sub    $0x37,%eax
  801ba8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801bab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bb1:	7c 02                	jl     801bb5 <strtol+0x148>
			break;
  801bb3:	eb 23                	jmp    801bd8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801bb5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bba:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bbd:	48 98                	cltq   
  801bbf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801bc4:	48 89 c2             	mov    %rax,%rdx
  801bc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bca:	48 98                	cltq   
  801bcc:	48 01 d0             	add    %rdx,%rax
  801bcf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bd3:	e9 5d ff ff ff       	jmpq   801b35 <strtol+0xc8>

	if (endptr)
  801bd8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bdd:	74 0b                	je     801bea <strtol+0x17d>
		*endptr = (char *) s;
  801bdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801be3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801be7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bee:	74 09                	je     801bf9 <strtol+0x18c>
  801bf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf4:	48 f7 d8             	neg    %rax
  801bf7:	eb 04                	jmp    801bfd <strtol+0x190>
  801bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bfd:	c9                   	leaveq 
  801bfe:	c3                   	retq   

0000000000801bff <strstr>:

char * strstr(const char *in, const char *str)
{
  801bff:	55                   	push   %rbp
  801c00:	48 89 e5             	mov    %rsp,%rbp
  801c03:	48 83 ec 30          	sub    $0x30,%rsp
  801c07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c13:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c17:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c1b:	0f b6 00             	movzbl (%rax),%eax
  801c1e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c21:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c25:	75 06                	jne    801c2d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2b:	eb 6b                	jmp    801c98 <strstr+0x99>

	len = strlen(str);
  801c2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c31:	48 89 c7             	mov    %rax,%rdi
  801c34:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	callq  *%rax
  801c40:	48 98                	cltq   
  801c42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c4e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c52:	0f b6 00             	movzbl (%rax),%eax
  801c55:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c58:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c5c:	75 07                	jne    801c65 <strstr+0x66>
				return (char *) 0;
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c63:	eb 33                	jmp    801c98 <strstr+0x99>
		} while (sc != c);
  801c65:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c69:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c6c:	75 d8                	jne    801c46 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c72:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7a:	48 89 ce             	mov    %rcx,%rsi
  801c7d:	48 89 c7             	mov    %rax,%rdi
  801c80:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  801c87:	00 00 00 
  801c8a:	ff d0                	callq  *%rax
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	75 b6                	jne    801c46 <strstr+0x47>

	return (char *) (in - 1);
  801c90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c94:	48 83 e8 01          	sub    $0x1,%rax
}
  801c98:	c9                   	leaveq 
  801c99:	c3                   	retq   

0000000000801c9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c9a:	55                   	push   %rbp
  801c9b:	48 89 e5             	mov    %rsp,%rbp
  801c9e:	53                   	push   %rbx
  801c9f:	48 83 ec 48          	sub    $0x48,%rsp
  801ca3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ca6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ca9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cb1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cb5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cb9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cbc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cc0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cc4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cc8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ccc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cd0:	4c 89 c3             	mov    %r8,%rbx
  801cd3:	cd 30                	int    $0x30
  801cd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801cd9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cdd:	74 3e                	je     801d1d <syscall+0x83>
  801cdf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ce4:	7e 37                	jle    801d1d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ce6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ced:	49 89 d0             	mov    %rdx,%r8
  801cf0:	89 c1                	mov    %eax,%ecx
  801cf2:	48 ba 28 4d 80 00 00 	movabs $0x804d28,%rdx
  801cf9:	00 00 00 
  801cfc:	be 23 00 00 00       	mov    $0x23,%esi
  801d01:	48 bf 45 4d 80 00 00 	movabs $0x804d45,%rdi
  801d08:	00 00 00 
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	49 b9 53 07 80 00 00 	movabs $0x800753,%r9
  801d17:	00 00 00 
  801d1a:	41 ff d1             	callq  *%r9

	return ret;
  801d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d21:	48 83 c4 48          	add    $0x48,%rsp
  801d25:	5b                   	pop    %rbx
  801d26:	5d                   	pop    %rbp
  801d27:	c3                   	retq   

0000000000801d28 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d28:	55                   	push   %rbp
  801d29:	48 89 e5             	mov    %rsp,%rbp
  801d2c:	48 83 ec 20          	sub    $0x20,%rsp
  801d30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d47:	00 
  801d48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d54:	48 89 d1             	mov    %rdx,%rcx
  801d57:	48 89 c2             	mov    %rax,%rdx
  801d5a:	be 00 00 00 00       	mov    $0x0,%esi
  801d5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d64:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
}
  801d70:	c9                   	leaveq 
  801d71:	c3                   	retq   

0000000000801d72 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d72:	55                   	push   %rbp
  801d73:	48 89 e5             	mov    %rsp,%rbp
  801d76:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d81:	00 
  801d82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d93:	ba 00 00 00 00       	mov    $0x0,%edx
  801d98:	be 00 00 00 00       	mov    $0x0,%esi
  801d9d:	bf 01 00 00 00       	mov    $0x1,%edi
  801da2:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
}
  801dae:	c9                   	leaveq 
  801daf:	c3                   	retq   

0000000000801db0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801db0:	55                   	push   %rbp
  801db1:	48 89 e5             	mov    %rsp,%rbp
  801db4:	48 83 ec 10          	sub    $0x10,%rsp
  801db8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbe:	48 98                	cltq   
  801dc0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc7:	00 
  801dc8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd9:	48 89 c2             	mov    %rax,%rdx
  801ddc:	be 01 00 00 00       	mov    $0x1,%esi
  801de1:	bf 03 00 00 00       	mov    $0x3,%edi
  801de6:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
}
  801df2:	c9                   	leaveq 
  801df3:	c3                   	retq   

0000000000801df4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801dfc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e03:	00 
  801e04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e10:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e15:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1a:	be 00 00 00 00       	mov    $0x0,%esi
  801e1f:	bf 02 00 00 00       	mov    $0x2,%edi
  801e24:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801e2b:	00 00 00 
  801e2e:	ff d0                	callq  *%rax
}
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <sys_yield>:

void
sys_yield(void)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e41:	00 
  801e42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e53:	ba 00 00 00 00       	mov    $0x0,%edx
  801e58:	be 00 00 00 00       	mov    $0x0,%esi
  801e5d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e62:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	callq  *%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e85:	48 63 c8             	movslq %eax,%rcx
  801e88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8f:	48 98                	cltq   
  801e91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e98:	00 
  801e99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9f:	49 89 c8             	mov    %rcx,%r8
  801ea2:	48 89 d1             	mov    %rdx,%rcx
  801ea5:	48 89 c2             	mov    %rax,%rdx
  801ea8:	be 01 00 00 00       	mov    $0x1,%esi
  801ead:	bf 04 00 00 00       	mov    $0x4,%edi
  801eb2:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	callq  *%rax
}
  801ebe:	c9                   	leaveq 
  801ebf:	c3                   	retq   

0000000000801ec0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
  801ec4:	48 83 ec 30          	sub    $0x30,%rsp
  801ec8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ecb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ecf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ed2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ed6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801eda:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801edd:	48 63 c8             	movslq %eax,%rcx
  801ee0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ee4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ee7:	48 63 f0             	movslq %eax,%rsi
  801eea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef1:	48 98                	cltq   
  801ef3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ef7:	49 89 f9             	mov    %rdi,%r9
  801efa:	49 89 f0             	mov    %rsi,%r8
  801efd:	48 89 d1             	mov    %rdx,%rcx
  801f00:	48 89 c2             	mov    %rax,%rdx
  801f03:	be 01 00 00 00       	mov    $0x1,%esi
  801f08:	bf 05 00 00 00       	mov    $0x5,%edi
  801f0d:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
}
  801f19:	c9                   	leaveq 
  801f1a:	c3                   	retq   

0000000000801f1b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f1b:	55                   	push   %rbp
  801f1c:	48 89 e5             	mov    %rsp,%rbp
  801f1f:	48 83 ec 20          	sub    $0x20,%rsp
  801f23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f31:	48 98                	cltq   
  801f33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3a:	00 
  801f3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f47:	48 89 d1             	mov    %rdx,%rcx
  801f4a:	48 89 c2             	mov    %rax,%rdx
  801f4d:	be 01 00 00 00       	mov    $0x1,%esi
  801f52:	bf 06 00 00 00       	mov    $0x6,%edi
  801f57:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
}
  801f63:	c9                   	leaveq 
  801f64:	c3                   	retq   

0000000000801f65 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	48 83 ec 10          	sub    $0x10,%rsp
  801f6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f70:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f76:	48 63 d0             	movslq %eax,%rdx
  801f79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7c:	48 98                	cltq   
  801f7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f85:	00 
  801f86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f92:	48 89 d1             	mov    %rdx,%rcx
  801f95:	48 89 c2             	mov    %rax,%rdx
  801f98:	be 01 00 00 00       	mov    $0x1,%esi
  801f9d:	bf 08 00 00 00       	mov    $0x8,%edi
  801fa2:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801fa9:	00 00 00 
  801fac:	ff d0                	callq  *%rax
}
  801fae:	c9                   	leaveq 
  801faf:	c3                   	retq   

0000000000801fb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fb0:	55                   	push   %rbp
  801fb1:	48 89 e5             	mov    %rsp,%rbp
  801fb4:	48 83 ec 20          	sub    $0x20,%rsp
  801fb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc6:	48 98                	cltq   
  801fc8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fcf:	00 
  801fd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdc:	48 89 d1             	mov    %rdx,%rcx
  801fdf:	48 89 c2             	mov    %rax,%rdx
  801fe2:	be 01 00 00 00       	mov    $0x1,%esi
  801fe7:	bf 09 00 00 00       	mov    $0x9,%edi
  801fec:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
}
  801ff8:	c9                   	leaveq 
  801ff9:	c3                   	retq   

0000000000801ffa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ffa:	55                   	push   %rbp
  801ffb:	48 89 e5             	mov    %rsp,%rbp
  801ffe:	48 83 ec 20          	sub    $0x20,%rsp
  802002:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802005:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802009:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802010:	48 98                	cltq   
  802012:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802019:	00 
  80201a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802020:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802026:	48 89 d1             	mov    %rdx,%rcx
  802029:	48 89 c2             	mov    %rax,%rdx
  80202c:	be 01 00 00 00       	mov    $0x1,%esi
  802031:	bf 0a 00 00 00       	mov    $0xa,%edi
  802036:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
}
  802042:	c9                   	leaveq 
  802043:	c3                   	retq   

0000000000802044 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	48 83 ec 20          	sub    $0x20,%rsp
  80204c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80204f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802053:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802057:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80205a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205d:	48 63 f0             	movslq %eax,%rsi
  802060:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802067:	48 98                	cltq   
  802069:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80206d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802074:	00 
  802075:	49 89 f1             	mov    %rsi,%r9
  802078:	49 89 c8             	mov    %rcx,%r8
  80207b:	48 89 d1             	mov    %rdx,%rcx
  80207e:	48 89 c2             	mov    %rax,%rdx
  802081:	be 00 00 00 00       	mov    $0x0,%esi
  802086:	bf 0c 00 00 00       	mov    $0xc,%edi
  80208b:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
}
  802097:	c9                   	leaveq 
  802098:	c3                   	retq   

0000000000802099 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802099:	55                   	push   %rbp
  80209a:	48 89 e5             	mov    %rsp,%rbp
  80209d:	48 83 ec 10          	sub    $0x10,%rsp
  8020a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020b0:	00 
  8020b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c2:	48 89 c2             	mov    %rax,%rdx
  8020c5:	be 01 00 00 00       	mov    $0x1,%esi
  8020ca:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020cf:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
}
  8020db:	c9                   	leaveq 
  8020dc:	c3                   	retq   

00000000008020dd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8020dd:	55                   	push   %rbp
  8020de:	48 89 e5             	mov    %rsp,%rbp
  8020e1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020ec:	00 
  8020ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802103:	be 00 00 00 00       	mov    $0x0,%esi
  802108:	bf 0e 00 00 00       	mov    $0xe,%edi
  80210d:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
}
  802119:	c9                   	leaveq 
  80211a:	c3                   	retq   

000000000080211b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80211b:	55                   	push   %rbp
  80211c:	48 89 e5             	mov    %rsp,%rbp
  80211f:	48 83 ec 30          	sub    $0x30,%rsp
  802123:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802126:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80212a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80212d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802131:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802135:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802138:	48 63 c8             	movslq %eax,%rcx
  80213b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80213f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802142:	48 63 f0             	movslq %eax,%rsi
  802145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214c:	48 98                	cltq   
  80214e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802152:	49 89 f9             	mov    %rdi,%r9
  802155:	49 89 f0             	mov    %rsi,%r8
  802158:	48 89 d1             	mov    %rdx,%rcx
  80215b:	48 89 c2             	mov    %rax,%rdx
  80215e:	be 00 00 00 00       	mov    $0x0,%esi
  802163:	bf 0f 00 00 00       	mov    $0xf,%edi
  802168:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  80216f:	00 00 00 
  802172:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802174:	c9                   	leaveq 
  802175:	c3                   	retq   

0000000000802176 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802176:	55                   	push   %rbp
  802177:	48 89 e5             	mov    %rsp,%rbp
  80217a:	48 83 ec 20          	sub    $0x20,%rsp
  80217e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802182:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80218a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802195:	00 
  802196:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80219c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a2:	48 89 d1             	mov    %rdx,%rcx
  8021a5:	48 89 c2             	mov    %rax,%rdx
  8021a8:	be 00 00 00 00       	mov    $0x0,%esi
  8021ad:	bf 10 00 00 00       	mov    $0x10,%edi
  8021b2:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8021b9:	00 00 00 
  8021bc:	ff d0                	callq  *%rax
}
  8021be:	c9                   	leaveq 
  8021bf:	c3                   	retq   

00000000008021c0 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8021c0:	55                   	push   %rbp
  8021c1:	48 89 e5             	mov    %rsp,%rbp
  8021c4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8021c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021cf:	00 
  8021d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e6:	be 00 00 00 00       	mov    $0x0,%esi
  8021eb:	bf 11 00 00 00       	mov    $0x11,%edi
  8021f0:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 10          	sub    $0x10,%rsp
  802206:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220c:	48 98                	cltq   
  80220e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802215:	00 
  802216:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80221c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802222:	b9 00 00 00 00       	mov    $0x0,%ecx
  802227:	48 89 c2             	mov    %rax,%rdx
  80222a:	be 00 00 00 00       	mov    $0x0,%esi
  80222f:	bf 12 00 00 00       	mov    $0x12,%edi
  802234:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	callq  *%rax
}
  802240:	c9                   	leaveq 
  802241:	c3                   	retq   

0000000000802242 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802242:	55                   	push   %rbp
  802243:	48 89 e5             	mov    %rsp,%rbp
  802246:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80224a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802251:	00 
  802252:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802258:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80225e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802263:	ba 00 00 00 00       	mov    $0x0,%edx
  802268:	be 00 00 00 00       	mov    $0x0,%esi
  80226d:	bf 13 00 00 00       	mov    $0x13,%edi
  802272:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
}
  80227e:	c9                   	leaveq 
  80227f:	c3                   	retq   

0000000000802280 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802280:	55                   	push   %rbp
  802281:	48 89 e5             	mov    %rsp,%rbp
  802284:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802288:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80228f:	00 
  802290:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802296:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80229c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a6:	be 00 00 00 00       	mov    $0x0,%esi
  8022ab:	bf 14 00 00 00       	mov    $0x14,%edi
  8022b0:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
}
  8022bc:	c9                   	leaveq 
  8022bd:	c3                   	retq   

00000000008022be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022be:	55                   	push   %rbp
  8022bf:	48 89 e5             	mov    %rsp,%rbp
  8022c2:	48 83 ec 08          	sub    $0x8,%rsp
  8022c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022ce:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022d5:	ff ff ff 
  8022d8:	48 01 d0             	add    %rdx,%rax
  8022db:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8022df:	c9                   	leaveq 
  8022e0:	c3                   	retq   

00000000008022e1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8022e1:	55                   	push   %rbp
  8022e2:	48 89 e5             	mov    %rsp,%rbp
  8022e5:	48 83 ec 08          	sub    $0x8,%rsp
  8022e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8022ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f1:	48 89 c7             	mov    %rax,%rdi
  8022f4:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  8022fb:	00 00 00 
  8022fe:	ff d0                	callq  *%rax
  802300:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802306:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80230a:	c9                   	leaveq 
  80230b:	c3                   	retq   

000000000080230c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 18          	sub    $0x18,%rsp
  802314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231f:	eb 6b                	jmp    80238c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802324:	48 98                	cltq   
  802326:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80232c:	48 c1 e0 0c          	shl    $0xc,%rax
  802330:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802334:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802338:	48 c1 e8 15          	shr    $0x15,%rax
  80233c:	48 89 c2             	mov    %rax,%rdx
  80233f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802346:	01 00 00 
  802349:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234d:	83 e0 01             	and    $0x1,%eax
  802350:	48 85 c0             	test   %rax,%rax
  802353:	74 21                	je     802376 <fd_alloc+0x6a>
  802355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802359:	48 c1 e8 0c          	shr    $0xc,%rax
  80235d:	48 89 c2             	mov    %rax,%rdx
  802360:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802367:	01 00 00 
  80236a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80236e:	83 e0 01             	and    $0x1,%eax
  802371:	48 85 c0             	test   %rax,%rax
  802374:	75 12                	jne    802388 <fd_alloc+0x7c>
			*fd_store = fd;
  802376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80237e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	eb 1a                	jmp    8023a2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802388:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80238c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802390:	7e 8f                	jle    802321 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802396:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80239d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023a2:	c9                   	leaveq 
  8023a3:	c3                   	retq   

00000000008023a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	48 83 ec 20          	sub    $0x20,%rsp
  8023ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023b7:	78 06                	js     8023bf <fd_lookup+0x1b>
  8023b9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023bd:	7e 07                	jle    8023c6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023c4:	eb 6c                	jmp    802432 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023c9:	48 98                	cltq   
  8023cb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8023d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023dd:	48 c1 e8 15          	shr    $0x15,%rax
  8023e1:	48 89 c2             	mov    %rax,%rdx
  8023e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023eb:	01 00 00 
  8023ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f2:	83 e0 01             	and    $0x1,%eax
  8023f5:	48 85 c0             	test   %rax,%rax
  8023f8:	74 21                	je     80241b <fd_lookup+0x77>
  8023fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fe:	48 c1 e8 0c          	shr    $0xc,%rax
  802402:	48 89 c2             	mov    %rax,%rdx
  802405:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80240c:	01 00 00 
  80240f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802413:	83 e0 01             	and    $0x1,%eax
  802416:	48 85 c0             	test   %rax,%rax
  802419:	75 07                	jne    802422 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80241b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802420:	eb 10                	jmp    802432 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802422:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802426:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80242a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 30          	sub    $0x30,%rsp
  80243c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802440:	89 f0                	mov    %esi,%eax
  802442:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802449:	48 89 c7             	mov    %rax,%rdi
  80244c:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  802453:	00 00 00 
  802456:	ff d0                	callq  *%rax
  802458:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245c:	48 89 d6             	mov    %rdx,%rsi
  80245f:	89 c7                	mov    %eax,%edi
  802461:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802468:	00 00 00 
  80246b:	ff d0                	callq  *%rax
  80246d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802474:	78 0a                	js     802480 <fd_close+0x4c>
	    || fd != fd2)
  802476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80247e:	74 12                	je     802492 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802480:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802484:	74 05                	je     80248b <fd_close+0x57>
  802486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802489:	eb 05                	jmp    802490 <fd_close+0x5c>
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	eb 69                	jmp    8024fb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802496:	8b 00                	mov    (%rax),%eax
  802498:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80249c:	48 89 d6             	mov    %rdx,%rsi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 fd 24 80 00 00 	movabs $0x8024fd,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b4:	78 2a                	js     8024e0 <fd_close+0xac>
		if (dev->dev_close)
  8024b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ba:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024be:	48 85 c0             	test   %rax,%rax
  8024c1:	74 16                	je     8024d9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024cf:	48 89 d7             	mov    %rdx,%rdi
  8024d2:	ff d0                	callq  *%rax
  8024d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d7:	eb 07                	jmp    8024e0 <fd_close+0xac>
		else
			r = 0;
  8024d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8024e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e4:	48 89 c6             	mov    %rax,%rsi
  8024e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ec:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax
	return r;
  8024f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024fb:	c9                   	leaveq 
  8024fc:	c3                   	retq   

00000000008024fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024fd:	55                   	push   %rbp
  8024fe:	48 89 e5             	mov    %rsp,%rbp
  802501:	48 83 ec 20          	sub    $0x20,%rsp
  802505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802508:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80250c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802513:	eb 41                	jmp    802556 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802515:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80251c:	00 00 00 
  80251f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802522:	48 63 d2             	movslq %edx,%rdx
  802525:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802529:	8b 00                	mov    (%rax),%eax
  80252b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80252e:	75 22                	jne    802552 <dev_lookup+0x55>
			*dev = devtab[i];
  802530:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802537:	00 00 00 
  80253a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80253d:	48 63 d2             	movslq %edx,%rdx
  802540:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802544:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802548:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	eb 60                	jmp    8025b2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802552:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802556:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80255d:	00 00 00 
  802560:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802563:	48 63 d2             	movslq %edx,%rdx
  802566:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256a:	48 85 c0             	test   %rax,%rax
  80256d:	75 a6                	jne    802515 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80256f:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802576:	00 00 00 
  802579:	48 8b 00             	mov    (%rax),%rax
  80257c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802582:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802585:	89 c6                	mov    %eax,%esi
  802587:	48 bf 58 4d 80 00 00 	movabs $0x804d58,%rdi
  80258e:	00 00 00 
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
  802596:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80259d:	00 00 00 
  8025a0:	ff d1                	callq  *%rcx
	*dev = 0;
  8025a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025b2:	c9                   	leaveq 
  8025b3:	c3                   	retq   

00000000008025b4 <close>:

int
close(int fdnum)
{
  8025b4:	55                   	push   %rbp
  8025b5:	48 89 e5             	mov    %rsp,%rbp
  8025b8:	48 83 ec 20          	sub    $0x20,%rsp
  8025bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	89 c7                	mov    %eax,%edi
  8025cb:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <close+0x31>
		return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 18                	jmp    8025fd <close+0x49>
	else
		return fd_close(fd, 1);
  8025e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e9:	be 01 00 00 00       	mov    $0x1,%esi
  8025ee:	48 89 c7             	mov    %rax,%rdi
  8025f1:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
}
  8025fd:	c9                   	leaveq 
  8025fe:	c3                   	retq   

00000000008025ff <close_all>:

void
close_all(void)
{
  8025ff:	55                   	push   %rbp
  802600:	48 89 e5             	mov    %rsp,%rbp
  802603:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802607:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80260e:	eb 15                	jmp    802625 <close_all+0x26>
		close(i);
  802610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802613:	89 c7                	mov    %eax,%edi
  802615:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  80261c:	00 00 00 
  80261f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802621:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802625:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802629:	7e e5                	jle    802610 <close_all+0x11>
		close(i);
}
  80262b:	c9                   	leaveq 
  80262c:	c3                   	retq   

000000000080262d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80262d:	55                   	push   %rbp
  80262e:	48 89 e5             	mov    %rsp,%rbp
  802631:	48 83 ec 40          	sub    $0x40,%rsp
  802635:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802638:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80263b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80263f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802642:	48 89 d6             	mov    %rdx,%rsi
  802645:	89 c7                	mov    %eax,%edi
  802647:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
  802653:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802656:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265a:	79 08                	jns    802664 <dup+0x37>
		return r;
  80265c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265f:	e9 70 01 00 00       	jmpq   8027d4 <dup+0x1a7>
	close(newfdnum);
  802664:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802667:	89 c7                	mov    %eax,%edi
  802669:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  802670:	00 00 00 
  802673:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802675:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802678:	48 98                	cltq   
  80267a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802680:	48 c1 e0 0c          	shl    $0xc,%rax
  802684:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80268c:	48 89 c7             	mov    %rax,%rdi
  80268f:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
  80269b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80269f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a3:	48 89 c7             	mov    %rax,%rdi
  8026a6:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
  8026b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ba:	48 c1 e8 15          	shr    $0x15,%rax
  8026be:	48 89 c2             	mov    %rax,%rdx
  8026c1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026c8:	01 00 00 
  8026cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026cf:	83 e0 01             	and    $0x1,%eax
  8026d2:	48 85 c0             	test   %rax,%rax
  8026d5:	74 73                	je     80274a <dup+0x11d>
  8026d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026db:	48 c1 e8 0c          	shr    $0xc,%rax
  8026df:	48 89 c2             	mov    %rax,%rdx
  8026e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026e9:	01 00 00 
  8026ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f0:	83 e0 01             	and    $0x1,%eax
  8026f3:	48 85 c0             	test   %rax,%rax
  8026f6:	74 52                	je     80274a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802700:	48 89 c2             	mov    %rax,%rdx
  802703:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80270a:	01 00 00 
  80270d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802711:	25 07 0e 00 00       	and    $0xe07,%eax
  802716:	89 c1                	mov    %eax,%ecx
  802718:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	41 89 c8             	mov    %ecx,%r8d
  802723:	48 89 d1             	mov    %rdx,%rcx
  802726:	ba 00 00 00 00       	mov    $0x0,%edx
  80272b:	48 89 c6             	mov    %rax,%rsi
  80272e:	bf 00 00 00 00       	mov    $0x0,%edi
  802733:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
  80273f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802746:	79 02                	jns    80274a <dup+0x11d>
			goto err;
  802748:	eb 57                	jmp    8027a1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80274a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80274e:	48 c1 e8 0c          	shr    $0xc,%rax
  802752:	48 89 c2             	mov    %rax,%rdx
  802755:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80275c:	01 00 00 
  80275f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802763:	25 07 0e 00 00       	and    $0xe07,%eax
  802768:	89 c1                	mov    %eax,%ecx
  80276a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802772:	41 89 c8             	mov    %ecx,%r8d
  802775:	48 89 d1             	mov    %rdx,%rcx
  802778:	ba 00 00 00 00       	mov    $0x0,%edx
  80277d:	48 89 c6             	mov    %rax,%rsi
  802780:	bf 00 00 00 00       	mov    $0x0,%edi
  802785:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
  802791:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802794:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802798:	79 02                	jns    80279c <dup+0x16f>
		goto err;
  80279a:	eb 05                	jmp    8027a1 <dup+0x174>

	return newfdnum;
  80279c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80279f:	eb 33                	jmp    8027d4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a5:	48 89 c6             	mov    %rax,%rsi
  8027a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ad:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027bd:	48 89 c6             	mov    %rax,%rsi
  8027c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c5:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
	return r;
  8027d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d4:	c9                   	leaveq 
  8027d5:	c3                   	retq   

00000000008027d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027d6:	55                   	push   %rbp
  8027d7:	48 89 e5             	mov    %rsp,%rbp
  8027da:	48 83 ec 40          	sub    $0x40,%rsp
  8027de:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027e9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027f0:	48 89 d6             	mov    %rdx,%rsi
  8027f3:	89 c7                	mov    %eax,%edi
  8027f5:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
  802801:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802804:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802808:	78 24                	js     80282e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80280a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280e:	8b 00                	mov    (%rax),%eax
  802810:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802814:	48 89 d6             	mov    %rdx,%rsi
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 fd 24 80 00 00 	movabs $0x8024fd,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802828:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282c:	79 05                	jns    802833 <read+0x5d>
		return r;
  80282e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802831:	eb 76                	jmp    8028a9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802837:	8b 40 08             	mov    0x8(%rax),%eax
  80283a:	83 e0 03             	and    $0x3,%eax
  80283d:	83 f8 01             	cmp    $0x1,%eax
  802840:	75 3a                	jne    80287c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802842:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802849:	00 00 00 
  80284c:	48 8b 00             	mov    (%rax),%rax
  80284f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802855:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802858:	89 c6                	mov    %eax,%esi
  80285a:	48 bf 77 4d 80 00 00 	movabs $0x804d77,%rdi
  802861:	00 00 00 
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  802870:	00 00 00 
  802873:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80287a:	eb 2d                	jmp    8028a9 <read+0xd3>
	}
	if (!dev->dev_read)
  80287c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802880:	48 8b 40 10          	mov    0x10(%rax),%rax
  802884:	48 85 c0             	test   %rax,%rax
  802887:	75 07                	jne    802890 <read+0xba>
		return -E_NOT_SUPP;
  802889:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80288e:	eb 19                	jmp    8028a9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802894:	48 8b 40 10          	mov    0x10(%rax),%rax
  802898:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80289c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028a0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028a4:	48 89 cf             	mov    %rcx,%rdi
  8028a7:	ff d0                	callq  *%rax
}
  8028a9:	c9                   	leaveq 
  8028aa:	c3                   	retq   

00000000008028ab <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028ab:	55                   	push   %rbp
  8028ac:	48 89 e5             	mov    %rsp,%rbp
  8028af:	48 83 ec 30          	sub    $0x30,%rsp
  8028b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028c5:	eb 49                	jmp    802910 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ca:	48 98                	cltq   
  8028cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d0:	48 29 c2             	sub    %rax,%rdx
  8028d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d6:	48 63 c8             	movslq %eax,%rcx
  8028d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028dd:	48 01 c1             	add    %rax,%rcx
  8028e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e3:	48 89 ce             	mov    %rcx,%rsi
  8028e6:	89 c7                	mov    %eax,%edi
  8028e8:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
  8028f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028fb:	79 05                	jns    802902 <readn+0x57>
			return m;
  8028fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802900:	eb 1c                	jmp    80291e <readn+0x73>
		if (m == 0)
  802902:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802906:	75 02                	jne    80290a <readn+0x5f>
			break;
  802908:	eb 11                	jmp    80291b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80290a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80290d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802913:	48 98                	cltq   
  802915:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802919:	72 ac                	jb     8028c7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80291b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80291e:	c9                   	leaveq 
  80291f:	c3                   	retq   

0000000000802920 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802920:	55                   	push   %rbp
  802921:	48 89 e5             	mov    %rsp,%rbp
  802924:	48 83 ec 40          	sub    $0x40,%rsp
  802928:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80292b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80292f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802933:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802937:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80293a:	48 89 d6             	mov    %rdx,%rsi
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
  80294b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802952:	78 24                	js     802978 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	8b 00                	mov    (%rax),%eax
  80295a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80295e:	48 89 d6             	mov    %rdx,%rsi
  802961:	89 c7                	mov    %eax,%edi
  802963:	48 b8 fd 24 80 00 00 	movabs $0x8024fd,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	callq  *%rax
  80296f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802976:	79 05                	jns    80297d <write+0x5d>
		return r;
  802978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297b:	eb 42                	jmp    8029bf <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80297d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802981:	8b 40 08             	mov    0x8(%rax),%eax
  802984:	83 e0 03             	and    $0x3,%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 07                	jne    802992 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80298b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802990:	eb 2d                	jmp    8029bf <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802996:	48 8b 40 18          	mov    0x18(%rax),%rax
  80299a:	48 85 c0             	test   %rax,%rax
  80299d:	75 07                	jne    8029a6 <write+0x86>
		return -E_NOT_SUPP;
  80299f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029a4:	eb 19                	jmp    8029bf <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8029a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029aa:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029ba:	48 89 cf             	mov    %rcx,%rdi
  8029bd:	ff d0                	callq  *%rax
}
  8029bf:	c9                   	leaveq 
  8029c0:	c3                   	retq   

00000000008029c1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029c1:	55                   	push   %rbp
  8029c2:	48 89 e5             	mov    %rsp,%rbp
  8029c5:	48 83 ec 18          	sub    $0x18,%rsp
  8029c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029cc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029d6:	48 89 d6             	mov    %rdx,%rsi
  8029d9:	89 c7                	mov    %eax,%edi
  8029db:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8029e2:	00 00 00 
  8029e5:	ff d0                	callq  *%rax
  8029e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ee:	79 05                	jns    8029f5 <seek+0x34>
		return r;
  8029f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f3:	eb 0f                	jmp    802a04 <seek+0x43>
	fd->fd_offset = offset;
  8029f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029fc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a04:	c9                   	leaveq 
  802a05:	c3                   	retq   

0000000000802a06 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a06:	55                   	push   %rbp
  802a07:	48 89 e5             	mov    %rsp,%rbp
  802a0a:	48 83 ec 30          	sub    $0x30,%rsp
  802a0e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a11:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1b:	48 89 d6             	mov    %rdx,%rsi
  802a1e:	89 c7                	mov    %eax,%edi
  802a20:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a33:	78 24                	js     802a59 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a39:	8b 00                	mov    (%rax),%eax
  802a3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3f:	48 89 d6             	mov    %rdx,%rsi
  802a42:	89 c7                	mov    %eax,%edi
  802a44:	48 b8 fd 24 80 00 00 	movabs $0x8024fd,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
  802a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a57:	79 05                	jns    802a5e <ftruncate+0x58>
		return r;
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	eb 72                	jmp    802ad0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a62:	8b 40 08             	mov    0x8(%rax),%eax
  802a65:	83 e0 03             	and    $0x3,%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	75 3a                	jne    802aa6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a6c:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802a73:	00 00 00 
  802a76:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a82:	89 c6                	mov    %eax,%esi
  802a84:	48 bf 98 4d 80 00 00 	movabs $0x804d98,%rdi
  802a8b:	00 00 00 
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a93:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  802a9a:	00 00 00 
  802a9d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa4:	eb 2a                	jmp    802ad0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802aae:	48 85 c0             	test   %rax,%rax
  802ab1:	75 07                	jne    802aba <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ab3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab8:	eb 16                	jmp    802ad0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ac2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ac9:	89 ce                	mov    %ecx,%esi
  802acb:	48 89 d7             	mov    %rdx,%rdi
  802ace:	ff d0                	callq  *%rax
}
  802ad0:	c9                   	leaveq 
  802ad1:	c3                   	retq   

0000000000802ad2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ad2:	55                   	push   %rbp
  802ad3:	48 89 e5             	mov    %rsp,%rbp
  802ad6:	48 83 ec 30          	sub    $0x30,%rsp
  802ada:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802add:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ae1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae8:	48 89 d6             	mov    %rdx,%rsi
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b00:	78 24                	js     802b26 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b06:	8b 00                	mov    (%rax),%eax
  802b08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0c:	48 89 d6             	mov    %rdx,%rsi
  802b0f:	89 c7                	mov    %eax,%edi
  802b11:	48 b8 fd 24 80 00 00 	movabs $0x8024fd,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b24:	79 05                	jns    802b2b <fstat+0x59>
		return r;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	eb 5e                	jmp    802b89 <fstat+0xb7>
	if (!dev->dev_stat)
  802b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b33:	48 85 c0             	test   %rax,%rax
  802b36:	75 07                	jne    802b3f <fstat+0x6d>
		return -E_NOT_SUPP;
  802b38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b3d:	eb 4a                	jmp    802b89 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b43:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b4a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b51:	00 00 00 
	stat->st_isdir = 0;
  802b54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b58:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b5f:	00 00 00 
	stat->st_dev = dev;
  802b62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b6a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b75:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b7d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b81:	48 89 ce             	mov    %rcx,%rsi
  802b84:	48 89 d7             	mov    %rdx,%rdi
  802b87:	ff d0                	callq  *%rax
}
  802b89:	c9                   	leaveq 
  802b8a:	c3                   	retq   

0000000000802b8b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b8b:	55                   	push   %rbp
  802b8c:	48 89 e5             	mov    %rsp,%rbp
  802b8f:	48 83 ec 20          	sub    $0x20,%rsp
  802b93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9f:	be 00 00 00 00       	mov    $0x0,%esi
  802ba4:	48 89 c7             	mov    %rax,%rdi
  802ba7:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
  802bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bba:	79 05                	jns    802bc1 <stat+0x36>
		return fd;
  802bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbf:	eb 2f                	jmp    802bf0 <stat+0x65>
	r = fstat(fd, stat);
  802bc1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc8:	48 89 d6             	mov    %rdx,%rsi
  802bcb:	89 c7                	mov    %eax,%edi
  802bcd:	48 b8 d2 2a 80 00 00 	movabs $0x802ad2,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
  802bd9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
	return r;
  802bed:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bf0:	c9                   	leaveq 
  802bf1:	c3                   	retq   

0000000000802bf2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bf2:	55                   	push   %rbp
  802bf3:	48 89 e5             	mov    %rsp,%rbp
  802bf6:	48 83 ec 10          	sub    $0x10,%rsp
  802bfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c08:	00 00 00 
  802c0b:	8b 00                	mov    (%rax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	75 1d                	jne    802c2e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c11:	bf 01 00 00 00       	mov    $0x1,%edi
  802c16:	48 b8 bf 45 80 00 00 	movabs $0x8045bf,%rax
  802c1d:	00 00 00 
  802c20:	ff d0                	callq  *%rax
  802c22:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c29:	00 00 00 
  802c2c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c2e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c35:	00 00 00 
  802c38:	8b 00                	mov    (%rax),%eax
  802c3a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c3d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c42:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802c49:	00 00 00 
  802c4c:	89 c7                	mov    %eax,%edi
  802c4e:	48 b8 37 45 80 00 00 	movabs $0x804537,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c63:	48 89 c6             	mov    %rax,%rsi
  802c66:	bf 00 00 00 00       	mov    $0x0,%edi
  802c6b:	48 b8 39 44 80 00 00 	movabs $0x804439,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
}
  802c77:	c9                   	leaveq 
  802c78:	c3                   	retq   

0000000000802c79 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c79:	55                   	push   %rbp
  802c7a:	48 89 e5             	mov    %rsp,%rbp
  802c7d:	48 83 ec 30          	sub    $0x30,%rsp
  802c81:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c85:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802c88:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802c8f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802c9d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ca2:	75 08                	jne    802cac <open+0x33>
	{
		return r;
  802ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca7:	e9 f2 00 00 00       	jmpq   802d9e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb0:	48 89 c7             	mov    %rax,%rdi
  802cb3:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
  802cbf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cc2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802cc9:	7e 0a                	jle    802cd5 <open+0x5c>
	{
		return -E_BAD_PATH;
  802ccb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cd0:	e9 c9 00 00 00       	jmpq   802d9e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802cd5:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802cdc:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802cdd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ce1:	48 89 c7             	mov    %rax,%rdi
  802ce4:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
  802cf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf7:	78 09                	js     802d02 <open+0x89>
  802cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfd:	48 85 c0             	test   %rax,%rax
  802d00:	75 08                	jne    802d0a <open+0x91>
		{
			return r;
  802d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d05:	e9 94 00 00 00       	jmpq   802d9e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d0e:	ba 00 04 00 00       	mov    $0x400,%edx
  802d13:	48 89 c6             	mov    %rax,%rsi
  802d16:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802d1d:	00 00 00 
  802d20:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  802d27:	00 00 00 
  802d2a:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802d2c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d33:	00 00 00 
  802d36:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802d39:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d43:	48 89 c6             	mov    %rax,%rsi
  802d46:	bf 01 00 00 00       	mov    $0x1,%edi
  802d4b:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5e:	79 2b                	jns    802d8b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d64:	be 00 00 00 00       	mov    $0x0,%esi
  802d69:	48 89 c7             	mov    %rax,%rdi
  802d6c:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802d73:	00 00 00 
  802d76:	ff d0                	callq  *%rax
  802d78:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802d7b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d7f:	79 05                	jns    802d86 <open+0x10d>
			{
				return d;
  802d81:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d84:	eb 18                	jmp    802d9e <open+0x125>
			}
			return r;
  802d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d89:	eb 13                	jmp    802d9e <open+0x125>
		}	
		return fd2num(fd_store);
  802d8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8f:	48 89 c7             	mov    %rax,%rdi
  802d92:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802d9e:	c9                   	leaveq 
  802d9f:	c3                   	retq   

0000000000802da0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802da0:	55                   	push   %rbp
  802da1:	48 89 e5             	mov    %rsp,%rbp
  802da4:	48 83 ec 10          	sub    $0x10,%rsp
  802da8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802dac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db0:	8b 50 0c             	mov    0xc(%rax),%edx
  802db3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dba:	00 00 00 
  802dbd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802dbf:	be 00 00 00 00       	mov    $0x0,%esi
  802dc4:	bf 06 00 00 00       	mov    $0x6,%edi
  802dc9:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
}
  802dd5:	c9                   	leaveq 
  802dd6:	c3                   	retq   

0000000000802dd7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802dd7:	55                   	push   %rbp
  802dd8:	48 89 e5             	mov    %rsp,%rbp
  802ddb:	48 83 ec 30          	sub    $0x30,%rsp
  802ddf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802de3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802de7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802df2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df7:	74 07                	je     802e00 <devfile_read+0x29>
  802df9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dfe:	75 07                	jne    802e07 <devfile_read+0x30>
		return -E_INVAL;
  802e00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e05:	eb 77                	jmp    802e7e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0b:	8b 50 0c             	mov    0xc(%rax),%edx
  802e0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e15:	00 00 00 
  802e18:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e1a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e21:	00 00 00 
  802e24:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e28:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802e2c:	be 00 00 00 00       	mov    $0x0,%esi
  802e31:	bf 03 00 00 00       	mov    $0x3,%edi
  802e36:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
  802e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e49:	7f 05                	jg     802e50 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4e:	eb 2e                	jmp    802e7e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e53:	48 63 d0             	movslq %eax,%rdx
  802e56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e5a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802e61:	00 00 00 
  802e64:	48 89 c7             	mov    %rax,%rdi
  802e67:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  802e6e:	00 00 00 
  802e71:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802e73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e7e:	c9                   	leaveq 
  802e7f:	c3                   	retq   

0000000000802e80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e80:	55                   	push   %rbp
  802e81:	48 89 e5             	mov    %rsp,%rbp
  802e84:	48 83 ec 30          	sub    $0x30,%rsp
  802e88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e90:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802e94:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802e9b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ea0:	74 07                	je     802ea9 <devfile_write+0x29>
  802ea2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ea7:	75 08                	jne    802eb1 <devfile_write+0x31>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	e9 9a 00 00 00       	jmpq   802f4b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb5:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ebf:	00 00 00 
  802ec2:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802ec4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ecb:	00 
  802ecc:	76 08                	jbe    802ed6 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ece:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ed5:	00 
	}
	fsipcbuf.write.req_n = n;
  802ed6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802edd:	00 00 00 
  802ee0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ee4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ee8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef0:	48 89 c6             	mov    %rax,%rsi
  802ef3:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802efa:	00 00 00 
  802efd:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  802f04:	00 00 00 
  802f07:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f09:	be 00 00 00 00       	mov    $0x0,%esi
  802f0e:	bf 04 00 00 00       	mov    $0x4,%edi
  802f13:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  802f1a:	00 00 00 
  802f1d:	ff d0                	callq  *%rax
  802f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f26:	7f 20                	jg     802f48 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f28:	48 bf be 4d 80 00 00 	movabs $0x804dbe,%rdi
  802f2f:	00 00 00 
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  802f3e:	00 00 00 
  802f41:	ff d2                	callq  *%rdx
		return r;
  802f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f46:	eb 03                	jmp    802f4b <devfile_write+0xcb>
	}
	return r;
  802f48:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802f4b:	c9                   	leaveq 
  802f4c:	c3                   	retq   

0000000000802f4d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f4d:	55                   	push   %rbp
  802f4e:	48 89 e5             	mov    %rsp,%rbp
  802f51:	48 83 ec 20          	sub    $0x20,%rsp
  802f55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f61:	8b 50 0c             	mov    0xc(%rax),%edx
  802f64:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f6b:	00 00 00 
  802f6e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f70:	be 00 00 00 00       	mov    $0x0,%esi
  802f75:	bf 05 00 00 00       	mov    $0x5,%edi
  802f7a:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
  802f86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8d:	79 05                	jns    802f94 <devfile_stat+0x47>
		return r;
  802f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f92:	eb 56                	jmp    802fea <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f98:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802f9f:	00 00 00 
  802fa2:	48 89 c7             	mov    %rax,%rdi
  802fa5:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fb1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fb8:	00 00 00 
  802fbb:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fcb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fd2:	00 00 00 
  802fd5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fea:	c9                   	leaveq 
  802feb:	c3                   	retq   

0000000000802fec <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fec:	55                   	push   %rbp
  802fed:	48 89 e5             	mov    %rsp,%rbp
  802ff0:	48 83 ec 10          	sub    $0x10,%rsp
  802ff4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ff8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fff:	8b 50 0c             	mov    0xc(%rax),%edx
  803002:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803009:	00 00 00 
  80300c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80300e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803015:	00 00 00 
  803018:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80301b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80301e:	be 00 00 00 00       	mov    $0x0,%esi
  803023:	bf 02 00 00 00       	mov    $0x2,%edi
  803028:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
}
  803034:	c9                   	leaveq 
  803035:	c3                   	retq   

0000000000803036 <remove>:

// Delete a file
int
remove(const char *path)
{
  803036:	55                   	push   %rbp
  803037:	48 89 e5             	mov    %rsp,%rbp
  80303a:	48 83 ec 10          	sub    $0x10,%rsp
  80303e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803046:	48 89 c7             	mov    %rax,%rdi
  803049:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  803050:	00 00 00 
  803053:	ff d0                	callq  *%rax
  803055:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80305a:	7e 07                	jle    803063 <remove+0x2d>
		return -E_BAD_PATH;
  80305c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803061:	eb 33                	jmp    803096 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803067:	48 89 c6             	mov    %rax,%rsi
  80306a:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803071:	00 00 00 
  803074:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803080:	be 00 00 00 00       	mov    $0x0,%esi
  803085:	bf 07 00 00 00       	mov    $0x7,%edi
  80308a:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
}
  803096:	c9                   	leaveq 
  803097:	c3                   	retq   

0000000000803098 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803098:	55                   	push   %rbp
  803099:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80309c:	be 00 00 00 00       	mov    $0x0,%esi
  8030a1:	bf 08 00 00 00       	mov    $0x8,%edi
  8030a6:	48 b8 f2 2b 80 00 00 	movabs $0x802bf2,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
}
  8030b2:	5d                   	pop    %rbp
  8030b3:	c3                   	retq   

00000000008030b4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030b4:	55                   	push   %rbp
  8030b5:	48 89 e5             	mov    %rsp,%rbp
  8030b8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030bf:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030c6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030cd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030d4:	be 00 00 00 00       	mov    $0x0,%esi
  8030d9:	48 89 c7             	mov    %rax,%rdi
  8030dc:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
  8030e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ef:	79 28                	jns    803119 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	89 c6                	mov    %eax,%esi
  8030f6:	48 bf da 4d 80 00 00 	movabs $0x804dda,%rdi
  8030fd:	00 00 00 
  803100:	b8 00 00 00 00       	mov    $0x0,%eax
  803105:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80310c:	00 00 00 
  80310f:	ff d2                	callq  *%rdx
		return fd_src;
  803111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803114:	e9 74 01 00 00       	jmpq   80328d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803119:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803120:	be 01 01 00 00       	mov    $0x101,%esi
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
  803134:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803137:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80313b:	79 39                	jns    803176 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80313d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803140:	89 c6                	mov    %eax,%esi
  803142:	48 bf f0 4d 80 00 00 	movabs $0x804df0,%rdi
  803149:	00 00 00 
  80314c:	b8 00 00 00 00       	mov    $0x0,%eax
  803151:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  803158:	00 00 00 
  80315b:	ff d2                	callq  *%rdx
		close(fd_src);
  80315d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803160:	89 c7                	mov    %eax,%edi
  803162:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
		return fd_dest;
  80316e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803171:	e9 17 01 00 00       	jmpq   80328d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803176:	eb 74                	jmp    8031ec <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803178:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80317b:	48 63 d0             	movslq %eax,%rdx
  80317e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803185:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803188:	48 89 ce             	mov    %rcx,%rsi
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 20 29 80 00 00 	movabs $0x802920,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80319c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031a0:	79 4a                	jns    8031ec <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8031a2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031a5:	89 c6                	mov    %eax,%esi
  8031a7:	48 bf 0a 4e 80 00 00 	movabs $0x804e0a,%rdi
  8031ae:	00 00 00 
  8031b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b6:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8031bd:	00 00 00 
  8031c0:	ff d2                	callq  *%rdx
			close(fd_src);
  8031c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c5:	89 c7                	mov    %eax,%edi
  8031c7:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
			close(fd_dest);
  8031d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d6:	89 c7                	mov    %eax,%edi
  8031d8:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
			return write_size;
  8031e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031e7:	e9 a1 00 00 00       	jmpq   80328d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ec:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f6:	ba 00 02 00 00       	mov    $0x200,%edx
  8031fb:	48 89 ce             	mov    %rcx,%rsi
  8031fe:	89 c7                	mov    %eax,%edi
  803200:	48 b8 d6 27 80 00 00 	movabs $0x8027d6,%rax
  803207:	00 00 00 
  80320a:	ff d0                	callq  *%rax
  80320c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80320f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803213:	0f 8f 5f ff ff ff    	jg     803178 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803219:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80321d:	79 47                	jns    803266 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80321f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803222:	89 c6                	mov    %eax,%esi
  803224:	48 bf 1d 4e 80 00 00 	movabs $0x804e1d,%rdi
  80322b:	00 00 00 
  80322e:	b8 00 00 00 00       	mov    $0x0,%eax
  803233:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  80323a:	00 00 00 
  80323d:	ff d2                	callq  *%rdx
		close(fd_src);
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	89 c7                	mov    %eax,%edi
  803244:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  80324b:	00 00 00 
  80324e:	ff d0                	callq  *%rax
		close(fd_dest);
  803250:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803253:	89 c7                	mov    %eax,%edi
  803255:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
		return read_size;
  803261:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803264:	eb 27                	jmp    80328d <copy+0x1d9>
	}
	close(fd_src);
  803266:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803269:	89 c7                	mov    %eax,%edi
  80326b:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
	close(fd_dest);
  803277:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80327a:	89 c7                	mov    %eax,%edi
  80327c:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
	return 0;
  803288:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80328d:	c9                   	leaveq 
  80328e:	c3                   	retq   

000000000080328f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80328f:	55                   	push   %rbp
  803290:	48 89 e5             	mov    %rsp,%rbp
  803293:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80329a:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8032a1:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8032a8:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8032af:	be 00 00 00 00       	mov    $0x0,%esi
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 79 2c 80 00 00 	movabs $0x802c79,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032ca:	79 08                	jns    8032d4 <spawn+0x45>
		return r;
  8032cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032cf:	e9 0c 03 00 00       	jmpq   8035e0 <spawn+0x351>
	fd = r;
  8032d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032d7:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8032da:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8032e1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8032e5:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8032ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8032ef:	ba 00 02 00 00       	mov    $0x200,%edx
  8032f4:	48 89 ce             	mov    %rcx,%rsi
  8032f7:	89 c7                	mov    %eax,%edi
  8032f9:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  803300:	00 00 00 
  803303:	ff d0                	callq  *%rax
  803305:	3d 00 02 00 00       	cmp    $0x200,%eax
  80330a:	75 0d                	jne    803319 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80330c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803310:	8b 00                	mov    (%rax),%eax
  803312:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803317:	74 43                	je     80335c <spawn+0xcd>
		close(fd);
  803319:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80331c:	89 c7                	mov    %eax,%edi
  80331e:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80332a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332e:	8b 00                	mov    (%rax),%eax
  803330:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803335:	89 c6                	mov    %eax,%esi
  803337:	48 bf 38 4e 80 00 00 	movabs $0x804e38,%rdi
  80333e:	00 00 00 
  803341:	b8 00 00 00 00       	mov    $0x0,%eax
  803346:	48 b9 8c 09 80 00 00 	movabs $0x80098c,%rcx
  80334d:	00 00 00 
  803350:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803352:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803357:	e9 84 02 00 00       	jmpq   8035e0 <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80335c:	b8 07 00 00 00       	mov    $0x7,%eax
  803361:	cd 30                	int    $0x30
  803363:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803366:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803369:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80336c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803370:	79 08                	jns    80337a <spawn+0xeb>
		return r;
  803372:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803375:	e9 66 02 00 00       	jmpq   8035e0 <spawn+0x351>
	child = r;
  80337a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80337d:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803380:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803383:	25 ff 03 00 00       	and    $0x3ff,%eax
  803388:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80338f:	00 00 00 
  803392:	48 98                	cltq   
  803394:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80339b:	48 01 d0             	add    %rdx,%rax
  80339e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8033a5:	48 89 c6             	mov    %rax,%rsi
  8033a8:	b8 18 00 00 00       	mov    $0x18,%eax
  8033ad:	48 89 d7             	mov    %rdx,%rdi
  8033b0:	48 89 c1             	mov    %rax,%rcx
  8033b3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8033b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8033be:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8033c5:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8033cc:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8033d3:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8033da:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033dd:	48 89 ce             	mov    %rcx,%rsi
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 4a 38 80 00 00 	movabs $0x80384a,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
  8033ee:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033f5:	79 08                	jns    8033ff <spawn+0x170>
		return r;
  8033f7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033fa:	e9 e1 01 00 00       	jmpq   8035e0 <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8033ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803403:	48 8b 40 20          	mov    0x20(%rax),%rax
  803407:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80340e:	48 01 d0             	add    %rdx,%rax
  803411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803415:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80341c:	e9 a3 00 00 00       	jmpq   8034c4 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803425:	8b 00                	mov    (%rax),%eax
  803427:	83 f8 01             	cmp    $0x1,%eax
  80342a:	74 05                	je     803431 <spawn+0x1a2>
			continue;
  80342c:	e9 8a 00 00 00       	jmpq   8034bb <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803431:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343c:	8b 40 04             	mov    0x4(%rax),%eax
  80343f:	83 e0 02             	and    $0x2,%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 04                	je     80344a <spawn+0x1bb>
			perm |= PTE_W;
  803446:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80344a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80344e:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803452:	41 89 c1             	mov    %eax,%r9d
  803455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803459:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80345d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803461:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803469:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80346d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803470:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803473:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803476:	89 3c 24             	mov    %edi,(%rsp)
  803479:	89 c7                	mov    %eax,%edi
  80347b:	48 b8 f3 3a 80 00 00 	movabs $0x803af3,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
  803487:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80348a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80348e:	79 2b                	jns    8034bb <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803490:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803491:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803494:	89 c7                	mov    %eax,%edi
  803496:	48 b8 b0 1d 80 00 00 	movabs $0x801db0,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
	close(fd);
  8034a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034a5:	89 c7                	mov    %eax,%edi
  8034a7:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
	return r;
  8034b3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034b6:	e9 25 01 00 00       	jmpq   8035e0 <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8034bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8034bf:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8034c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c8:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8034cc:	0f b7 c0             	movzwl %ax,%eax
  8034cf:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8034d2:	0f 8f 49 ff ff ff    	jg     803421 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8034d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034db:	89 c7                	mov    %eax,%edi
  8034dd:	48 b8 b4 25 80 00 00 	movabs $0x8025b4,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
	fd = -1;
  8034e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8034f0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034f3:	89 c7                	mov    %eax,%edi
  8034f5:	48 b8 df 3c 80 00 00 	movabs $0x803cdf,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803504:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803508:	79 30                	jns    80353a <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  80350a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80350d:	89 c1                	mov    %eax,%ecx
  80350f:	48 ba 52 4e 80 00 00 	movabs $0x804e52,%rdx
  803516:	00 00 00 
  803519:	be 82 00 00 00       	mov    $0x82,%esi
  80351e:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  803525:	00 00 00 
  803528:	b8 00 00 00 00       	mov    $0x0,%eax
  80352d:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803534:	00 00 00 
  803537:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80353a:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803541:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803544:	48 89 d6             	mov    %rdx,%rsi
  803547:	89 c7                	mov    %eax,%edi
  803549:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  803550:	00 00 00 
  803553:	ff d0                	callq  *%rax
  803555:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803558:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80355c:	79 30                	jns    80358e <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  80355e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803561:	89 c1                	mov    %eax,%ecx
  803563:	48 ba 74 4e 80 00 00 	movabs $0x804e74,%rdx
  80356a:	00 00 00 
  80356d:	be 85 00 00 00       	mov    $0x85,%esi
  803572:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  803579:	00 00 00 
  80357c:	b8 00 00 00 00       	mov    $0x0,%eax
  803581:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803588:	00 00 00 
  80358b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80358e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803591:	be 02 00 00 00       	mov    $0x2,%esi
  803596:	89 c7                	mov    %eax,%edi
  803598:	48 b8 65 1f 80 00 00 	movabs $0x801f65,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
  8035a4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035ab:	79 30                	jns    8035dd <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  8035ad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035b0:	89 c1                	mov    %eax,%ecx
  8035b2:	48 ba 8e 4e 80 00 00 	movabs $0x804e8e,%rdx
  8035b9:	00 00 00 
  8035bc:	be 88 00 00 00       	mov    $0x88,%esi
  8035c1:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  8035c8:	00 00 00 
  8035cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d0:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8035d7:	00 00 00 
  8035da:	41 ff d0             	callq  *%r8

	return child;
  8035dd:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8035e0:	c9                   	leaveq 
  8035e1:	c3                   	retq   

00000000008035e2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8035e2:	55                   	push   %rbp
  8035e3:	48 89 e5             	mov    %rsp,%rbp
  8035e6:	41 55                	push   %r13
  8035e8:	41 54                	push   %r12
  8035ea:	53                   	push   %rbx
  8035eb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8035f2:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8035f9:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803600:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803607:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80360e:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803615:	84 c0                	test   %al,%al
  803617:	74 26                	je     80363f <spawnl+0x5d>
  803619:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803620:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803627:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  80362b:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80362f:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803633:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803637:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80363b:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80363f:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803646:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80364d:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803650:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803657:	00 00 00 
  80365a:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803661:	00 00 00 
  803664:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803668:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80366f:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803676:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80367d:	eb 07                	jmp    803686 <spawnl+0xa4>
		argc++;
  80367f:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803686:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80368c:	83 f8 30             	cmp    $0x30,%eax
  80368f:	73 23                	jae    8036b4 <spawnl+0xd2>
  803691:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803698:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80369e:	89 c0                	mov    %eax,%eax
  8036a0:	48 01 d0             	add    %rdx,%rax
  8036a3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036a9:	83 c2 08             	add    $0x8,%edx
  8036ac:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036b2:	eb 15                	jmp    8036c9 <spawnl+0xe7>
  8036b4:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8036bb:	48 89 d0             	mov    %rdx,%rax
  8036be:	48 83 c2 08          	add    $0x8,%rdx
  8036c2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036c9:	48 8b 00             	mov    (%rax),%rax
  8036cc:	48 85 c0             	test   %rax,%rax
  8036cf:	75 ae                	jne    80367f <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8036d1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036d7:	83 c0 02             	add    $0x2,%eax
  8036da:	48 89 e2             	mov    %rsp,%rdx
  8036dd:	48 89 d3             	mov    %rdx,%rbx
  8036e0:	48 63 d0             	movslq %eax,%rdx
  8036e3:	48 83 ea 01          	sub    $0x1,%rdx
  8036e7:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8036ee:	48 63 d0             	movslq %eax,%rdx
  8036f1:	49 89 d4             	mov    %rdx,%r12
  8036f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8036fa:	48 63 d0             	movslq %eax,%rdx
  8036fd:	49 89 d2             	mov    %rdx,%r10
  803700:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803706:	48 98                	cltq   
  803708:	48 c1 e0 03          	shl    $0x3,%rax
  80370c:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803710:	b8 10 00 00 00       	mov    $0x10,%eax
  803715:	48 83 e8 01          	sub    $0x1,%rax
  803719:	48 01 d0             	add    %rdx,%rax
  80371c:	bf 10 00 00 00       	mov    $0x10,%edi
  803721:	ba 00 00 00 00       	mov    $0x0,%edx
  803726:	48 f7 f7             	div    %rdi
  803729:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80372d:	48 29 c4             	sub    %rax,%rsp
  803730:	48 89 e0             	mov    %rsp,%rax
  803733:	48 83 c0 07          	add    $0x7,%rax
  803737:	48 c1 e8 03          	shr    $0x3,%rax
  80373b:	48 c1 e0 03          	shl    $0x3,%rax
  80373f:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803746:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80374d:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803754:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803757:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80375d:	8d 50 01             	lea    0x1(%rax),%edx
  803760:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803767:	48 63 d2             	movslq %edx,%rdx
  80376a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803771:	00 

	va_start(vl, arg0);
  803772:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803779:	00 00 00 
  80377c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803783:	00 00 00 
  803786:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80378a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803791:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803798:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80379f:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8037a6:	00 00 00 
  8037a9:	eb 63                	jmp    80380e <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8037ab:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8037b1:	8d 70 01             	lea    0x1(%rax),%esi
  8037b4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8037ba:	83 f8 30             	cmp    $0x30,%eax
  8037bd:	73 23                	jae    8037e2 <spawnl+0x200>
  8037bf:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8037c6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8037cc:	89 c0                	mov    %eax,%eax
  8037ce:	48 01 d0             	add    %rdx,%rax
  8037d1:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8037d7:	83 c2 08             	add    $0x8,%edx
  8037da:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8037e0:	eb 15                	jmp    8037f7 <spawnl+0x215>
  8037e2:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8037e9:	48 89 d0             	mov    %rdx,%rax
  8037ec:	48 83 c2 08          	add    $0x8,%rdx
  8037f0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8037f7:	48 8b 08             	mov    (%rax),%rcx
  8037fa:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803801:	89 f2                	mov    %esi,%edx
  803803:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803807:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80380e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803814:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80381a:	77 8f                	ja     8037ab <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80381c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803823:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80382a:	48 89 d6             	mov    %rdx,%rsi
  80382d:	48 89 c7             	mov    %rax,%rdi
  803830:	48 b8 8f 32 80 00 00 	movabs $0x80328f,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
  80383c:	48 89 dc             	mov    %rbx,%rsp
}
  80383f:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803843:	5b                   	pop    %rbx
  803844:	41 5c                	pop    %r12
  803846:	41 5d                	pop    %r13
  803848:	5d                   	pop    %rbp
  803849:	c3                   	retq   

000000000080384a <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80384a:	55                   	push   %rbp
  80384b:	48 89 e5             	mov    %rsp,%rbp
  80384e:	48 83 ec 50          	sub    $0x50,%rsp
  803852:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803855:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803859:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80385d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803864:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80386c:	eb 33                	jmp    8038a1 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80386e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803871:	48 98                	cltq   
  803873:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80387a:	00 
  80387b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80387f:	48 01 d0             	add    %rdx,%rax
  803882:	48 8b 00             	mov    (%rax),%rax
  803885:	48 89 c7             	mov    %rax,%rdi
  803888:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
  803894:	83 c0 01             	add    $0x1,%eax
  803897:	48 98                	cltq   
  803899:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80389d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8038a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038a4:	48 98                	cltq   
  8038a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038ad:	00 
  8038ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038b2:	48 01 d0             	add    %rdx,%rax
  8038b5:	48 8b 00             	mov    (%rax),%rax
  8038b8:	48 85 c0             	test   %rax,%rax
  8038bb:	75 b1                	jne    80386e <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8038bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c1:	48 f7 d8             	neg    %rax
  8038c4:	48 05 00 10 40 00    	add    $0x401000,%rax
  8038ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8038ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8038d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038da:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8038de:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038e1:	83 c2 01             	add    $0x1,%edx
  8038e4:	c1 e2 03             	shl    $0x3,%edx
  8038e7:	48 63 d2             	movslq %edx,%rdx
  8038ea:	48 f7 da             	neg    %rdx
  8038ed:	48 01 d0             	add    %rdx,%rax
  8038f0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8038f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f8:	48 83 e8 10          	sub    $0x10,%rax
  8038fc:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803902:	77 0a                	ja     80390e <init_stack+0xc4>
		return -E_NO_MEM;
  803904:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803909:	e9 e3 01 00 00       	jmpq   803af1 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80390e:	ba 07 00 00 00       	mov    $0x7,%edx
  803913:	be 00 00 40 00       	mov    $0x400000,%esi
  803918:	bf 00 00 00 00       	mov    $0x0,%edi
  80391d:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80392c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803930:	79 08                	jns    80393a <init_stack+0xf0>
		return r;
  803932:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803935:	e9 b7 01 00 00       	jmpq   803af1 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80393a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803941:	e9 8a 00 00 00       	jmpq   8039d0 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803946:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803949:	48 98                	cltq   
  80394b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803952:	00 
  803953:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803957:	48 01 c2             	add    %rax,%rdx
  80395a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80395f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803963:	48 01 c8             	add    %rcx,%rax
  803966:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80396c:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80396f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803972:	48 98                	cltq   
  803974:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80397b:	00 
  80397c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803980:	48 01 d0             	add    %rdx,%rax
  803983:	48 8b 10             	mov    (%rax),%rdx
  803986:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80398a:	48 89 d6             	mov    %rdx,%rsi
  80398d:	48 89 c7             	mov    %rax,%rdi
  803990:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  803997:	00 00 00 
  80399a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80399c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80399f:	48 98                	cltq   
  8039a1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8039a8:	00 
  8039a9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8039ad:	48 01 d0             	add    %rdx,%rax
  8039b0:	48 8b 00             	mov    (%rax),%rax
  8039b3:	48 89 c7             	mov    %rax,%rdi
  8039b6:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	48 98                	cltq   
  8039c4:	48 83 c0 01          	add    $0x1,%rax
  8039c8:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8039cc:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8039d0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039d3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8039d6:	0f 8c 6a ff ff ff    	jl     803946 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8039dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039df:	48 98                	cltq   
  8039e1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8039e8:	00 
  8039e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ed:	48 01 d0             	add    %rdx,%rax
  8039f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8039f7:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8039fe:	00 
  8039ff:	74 35                	je     803a36 <init_stack+0x1ec>
  803a01:	48 b9 a8 4e 80 00 00 	movabs $0x804ea8,%rcx
  803a08:	00 00 00 
  803a0b:	48 ba ce 4e 80 00 00 	movabs $0x804ece,%rdx
  803a12:	00 00 00 
  803a15:	be f1 00 00 00       	mov    $0xf1,%esi
  803a1a:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  803a21:	00 00 00 
  803a24:	b8 00 00 00 00       	mov    $0x0,%eax
  803a29:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803a30:	00 00 00 
  803a33:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803a36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a3a:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803a3e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a47:	48 01 c8             	add    %rcx,%rax
  803a4a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803a50:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803a53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a57:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803a5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a5e:	48 98                	cltq   
  803a60:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803a63:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803a68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a6c:	48 01 d0             	add    %rdx,%rax
  803a6f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803a75:	48 89 c2             	mov    %rax,%rdx
  803a78:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803a7c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803a7f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803a82:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803a88:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a8d:	89 c2                	mov    %eax,%edx
  803a8f:	be 00 00 40 00       	mov    $0x400000,%esi
  803a94:	bf 00 00 00 00       	mov    $0x0,%edi
  803a99:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803aa0:	00 00 00 
  803aa3:	ff d0                	callq  *%rax
  803aa5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aac:	79 02                	jns    803ab0 <init_stack+0x266>
		goto error;
  803aae:	eb 28                	jmp    803ad8 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803ab0:	be 00 00 40 00       	mov    $0x400000,%esi
  803ab5:	bf 00 00 00 00       	mov    $0x0,%edi
  803aba:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
  803ac6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803acd:	79 02                	jns    803ad1 <init_stack+0x287>
		goto error;
  803acf:	eb 07                	jmp    803ad8 <init_stack+0x28e>

	return 0;
  803ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad6:	eb 19                	jmp    803af1 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803ad8:	be 00 00 40 00       	mov    $0x400000,%esi
  803add:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae2:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803ae9:	00 00 00 
  803aec:	ff d0                	callq  *%rax
	return r;
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803af1:	c9                   	leaveq 
  803af2:	c3                   	retq   

0000000000803af3 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803af3:	55                   	push   %rbp
  803af4:	48 89 e5             	mov    %rsp,%rbp
  803af7:	48 83 ec 50          	sub    $0x50,%rsp
  803afb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803afe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803b06:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803b09:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803b0d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803b11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b15:	25 ff 0f 00 00       	and    $0xfff,%eax
  803b1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b21:	74 21                	je     803b44 <map_segment+0x51>
		va -= i;
  803b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b26:	48 98                	cltq   
  803b28:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803b2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2f:	48 98                	cltq   
  803b31:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803b35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b38:	48 98                	cltq   
  803b3a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b41:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803b44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b4b:	e9 79 01 00 00       	jmpq   803cc9 <map_segment+0x1d6>
		if (i >= filesz) {
  803b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b53:	48 98                	cltq   
  803b55:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803b59:	72 3c                	jb     803b97 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5e:	48 63 d0             	movslq %eax,%rdx
  803b61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b65:	48 01 d0             	add    %rdx,%rax
  803b68:	48 89 c1             	mov    %rax,%rcx
  803b6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b6e:	8b 55 10             	mov    0x10(%rbp),%edx
  803b71:	48 89 ce             	mov    %rcx,%rsi
  803b74:	89 c7                	mov    %eax,%edi
  803b76:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
  803b82:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b89:	0f 89 33 01 00 00    	jns    803cc2 <map_segment+0x1cf>
				return r;
  803b8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b92:	e9 46 01 00 00       	jmpq   803cdd <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b97:	ba 07 00 00 00       	mov    $0x7,%edx
  803b9c:	be 00 00 40 00       	mov    $0x400000,%esi
  803ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba6:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
  803bb2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803bb5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803bb9:	79 08                	jns    803bc3 <map_segment+0xd0>
				return r;
  803bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bbe:	e9 1a 01 00 00       	jmpq   803cdd <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc6:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803bc9:	01 c2                	add    %eax,%edx
  803bcb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803bce:	89 d6                	mov    %edx,%esi
  803bd0:	89 c7                	mov    %eax,%edi
  803bd2:	48 b8 c1 29 80 00 00 	movabs $0x8029c1,%rax
  803bd9:	00 00 00 
  803bdc:	ff d0                	callq  *%rax
  803bde:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803be1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803be5:	79 08                	jns    803bef <map_segment+0xfc>
				return r;
  803be7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bea:	e9 ee 00 00 00       	jmpq   803cdd <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803bef:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf9:	48 98                	cltq   
  803bfb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803bff:	48 29 c2             	sub    %rax,%rdx
  803c02:	48 89 d0             	mov    %rdx,%rax
  803c05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803c09:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c0c:	48 63 d0             	movslq %eax,%rdx
  803c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c13:	48 39 c2             	cmp    %rax,%rdx
  803c16:	48 0f 47 d0          	cmova  %rax,%rdx
  803c1a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c1d:	be 00 00 40 00       	mov    $0x400000,%esi
  803c22:	89 c7                	mov    %eax,%edi
  803c24:	48 b8 ab 28 80 00 00 	movabs $0x8028ab,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
  803c30:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c33:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c37:	79 08                	jns    803c41 <map_segment+0x14e>
				return r;
  803c39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c3c:	e9 9c 00 00 00       	jmpq   803cdd <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c44:	48 63 d0             	movslq %eax,%rdx
  803c47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4b:	48 01 d0             	add    %rdx,%rax
  803c4e:	48 89 c2             	mov    %rax,%rdx
  803c51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c54:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803c58:	48 89 d1             	mov    %rdx,%rcx
  803c5b:	89 c2                	mov    %eax,%edx
  803c5d:	be 00 00 40 00       	mov    $0x400000,%esi
  803c62:	bf 00 00 00 00       	mov    $0x0,%edi
  803c67:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
  803c73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c7a:	79 30                	jns    803cac <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803c7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c7f:	89 c1                	mov    %eax,%ecx
  803c81:	48 ba e3 4e 80 00 00 	movabs $0x804ee3,%rdx
  803c88:	00 00 00 
  803c8b:	be 24 01 00 00       	mov    $0x124,%esi
  803c90:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  803c97:	00 00 00 
  803c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9f:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  803ca6:	00 00 00 
  803ca9:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803cac:	be 00 00 40 00       	mov    $0x400000,%esi
  803cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb6:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803cc2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccc:	48 98                	cltq   
  803cce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cd2:	0f 82 78 fe ff ff    	jb     803b50 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cdd:	c9                   	leaveq 
  803cde:	c3                   	retq   

0000000000803cdf <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803cdf:	55                   	push   %rbp
  803ce0:	48 89 e5             	mov    %rsp,%rbp
  803ce3:	48 83 ec 20          	sub    $0x20,%rsp
  803ce7:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803cea:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803cf1:	00 
  803cf2:	e9 c9 00 00 00       	jmpq   803dc0 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cfb:	48 c1 e8 27          	shr    $0x27,%rax
  803cff:	48 89 c2             	mov    %rax,%rdx
  803d02:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803d09:	01 00 00 
  803d0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d10:	48 85 c0             	test   %rax,%rax
  803d13:	74 3c                	je     803d51 <copy_shared_pages+0x72>
  803d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d19:	48 c1 e8 1e          	shr    $0x1e,%rax
  803d1d:	48 89 c2             	mov    %rax,%rdx
  803d20:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803d27:	01 00 00 
  803d2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d2e:	48 85 c0             	test   %rax,%rax
  803d31:	74 1e                	je     803d51 <copy_shared_pages+0x72>
  803d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d37:	48 c1 e8 15          	shr    $0x15,%rax
  803d3b:	48 89 c2             	mov    %rax,%rdx
  803d3e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d45:	01 00 00 
  803d48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d4c:	48 85 c0             	test   %rax,%rax
  803d4f:	75 02                	jne    803d53 <copy_shared_pages+0x74>
                continue;
  803d51:	eb 65                	jmp    803db8 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d57:	48 c1 e8 0c          	shr    $0xc,%rax
  803d5b:	48 89 c2             	mov    %rax,%rdx
  803d5e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d65:	01 00 00 
  803d68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d6c:	25 00 04 00 00       	and    $0x400,%eax
  803d71:	48 85 c0             	test   %rax,%rax
  803d74:	74 42                	je     803db8 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d7a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d7e:	48 89 c2             	mov    %rax,%rdx
  803d81:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d88:	01 00 00 
  803d8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d8f:	25 07 0e 00 00       	and    $0xe07,%eax
  803d94:	89 c6                	mov    %eax,%esi
  803d96:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803da1:	41 89 f0             	mov    %esi,%r8d
  803da4:	48 89 c6             	mov    %rax,%rsi
  803da7:	bf 00 00 00 00       	mov    $0x0,%edi
  803dac:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803db3:	00 00 00 
  803db6:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803db8:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803dbf:	00 
  803dc0:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803dc7:	00 00 00 
  803dca:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803dce:	0f 86 23 ff ff ff    	jbe    803cf7 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803dd4:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803dd9:	c9                   	leaveq 
  803dda:	c3                   	retq   

0000000000803ddb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ddb:	55                   	push   %rbp
  803ddc:	48 89 e5             	mov    %rsp,%rbp
  803ddf:	53                   	push   %rbx
  803de0:	48 83 ec 38          	sub    $0x38,%rsp
  803de4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803de8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803dec:	48 89 c7             	mov    %rax,%rdi
  803def:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
  803dfb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e02:	0f 88 bf 01 00 00    	js     803fc7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e0c:	ba 07 04 00 00       	mov    $0x407,%edx
  803e11:	48 89 c6             	mov    %rax,%rsi
  803e14:	bf 00 00 00 00       	mov    $0x0,%edi
  803e19:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803e20:	00 00 00 
  803e23:	ff d0                	callq  *%rax
  803e25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e2c:	0f 88 95 01 00 00    	js     803fc7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e32:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e36:	48 89 c7             	mov    %rax,%rdi
  803e39:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  803e40:	00 00 00 
  803e43:	ff d0                	callq  *%rax
  803e45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e4c:	0f 88 5d 01 00 00    	js     803faf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e56:	ba 07 04 00 00       	mov    $0x407,%edx
  803e5b:	48 89 c6             	mov    %rax,%rsi
  803e5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e63:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
  803e6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e76:	0f 88 33 01 00 00    	js     803faf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e80:	48 89 c7             	mov    %rax,%rdi
  803e83:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  803e8a:	00 00 00 
  803e8d:	ff d0                	callq  *%rax
  803e8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e97:	ba 07 04 00 00       	mov    $0x407,%edx
  803e9c:	48 89 c6             	mov    %rax,%rsi
  803e9f:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea4:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  803eab:	00 00 00 
  803eae:	ff d0                	callq  *%rax
  803eb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb7:	79 05                	jns    803ebe <pipe+0xe3>
		goto err2;
  803eb9:	e9 d9 00 00 00       	jmpq   803f97 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ebe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec2:	48 89 c7             	mov    %rax,%rdi
  803ec5:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  803ecc:	00 00 00 
  803ecf:	ff d0                	callq  *%rax
  803ed1:	48 89 c2             	mov    %rax,%rdx
  803ed4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ede:	48 89 d1             	mov    %rdx,%rcx
  803ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  803ee6:	48 89 c6             	mov    %rax,%rsi
  803ee9:	bf 00 00 00 00       	mov    $0x0,%edi
  803eee:	48 b8 c0 1e 80 00 00 	movabs $0x801ec0,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f01:	79 1b                	jns    803f1e <pipe+0x143>
		goto err3;
  803f03:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f08:	48 89 c6             	mov    %rax,%rsi
  803f0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f10:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	eb 79                	jmp    803f97 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f22:	48 ba 80 78 80 00 00 	movabs $0x807880,%rdx
  803f29:	00 00 00 
  803f2c:	8b 12                	mov    (%rdx),%edx
  803f2e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f3f:	48 ba 80 78 80 00 00 	movabs $0x807880,%rdx
  803f46:	00 00 00 
  803f49:	8b 12                	mov    (%rdx),%edx
  803f4b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f51:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5c:	48 89 c7             	mov    %rax,%rdi
  803f5f:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  803f66:	00 00 00 
  803f69:	ff d0                	callq  *%rax
  803f6b:	89 c2                	mov    %eax,%edx
  803f6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f71:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f77:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7f:	48 89 c7             	mov    %rax,%rdi
  803f82:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  803f89:	00 00 00 
  803f8c:	ff d0                	callq  *%rax
  803f8e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f90:	b8 00 00 00 00       	mov    $0x0,%eax
  803f95:	eb 33                	jmp    803fca <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f9b:	48 89 c6             	mov    %rax,%rsi
  803f9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803fa3:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803faa:	00 00 00 
  803fad:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803faf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb3:	48 89 c6             	mov    %rax,%rsi
  803fb6:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbb:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  803fc2:	00 00 00 
  803fc5:	ff d0                	callq  *%rax
err:
	return r;
  803fc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fca:	48 83 c4 38          	add    $0x38,%rsp
  803fce:	5b                   	pop    %rbx
  803fcf:	5d                   	pop    %rbp
  803fd0:	c3                   	retq   

0000000000803fd1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fd1:	55                   	push   %rbp
  803fd2:	48 89 e5             	mov    %rsp,%rbp
  803fd5:	53                   	push   %rbx
  803fd6:	48 83 ec 28          	sub    $0x28,%rsp
  803fda:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fde:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fe2:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803fe9:	00 00 00 
  803fec:	48 8b 00             	mov    (%rax),%rax
  803fef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ff5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ff8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ffc:	48 89 c7             	mov    %rax,%rdi
  803fff:	48 b8 31 46 80 00 00 	movabs $0x804631,%rax
  804006:	00 00 00 
  804009:	ff d0                	callq  *%rax
  80400b:	89 c3                	mov    %eax,%ebx
  80400d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804011:	48 89 c7             	mov    %rax,%rdi
  804014:	48 b8 31 46 80 00 00 	movabs $0x804631,%rax
  80401b:	00 00 00 
  80401e:	ff d0                	callq  *%rax
  804020:	39 c3                	cmp    %eax,%ebx
  804022:	0f 94 c0             	sete   %al
  804025:	0f b6 c0             	movzbl %al,%eax
  804028:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80402b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804032:	00 00 00 
  804035:	48 8b 00             	mov    (%rax),%rax
  804038:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80403e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804041:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804044:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804047:	75 05                	jne    80404e <_pipeisclosed+0x7d>
			return ret;
  804049:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80404c:	eb 4f                	jmp    80409d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80404e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804051:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804054:	74 42                	je     804098 <_pipeisclosed+0xc7>
  804056:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80405a:	75 3c                	jne    804098 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80405c:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804063:	00 00 00 
  804066:	48 8b 00             	mov    (%rax),%rax
  804069:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80406f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804072:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804075:	89 c6                	mov    %eax,%esi
  804077:	48 bf 0a 4f 80 00 00 	movabs $0x804f0a,%rdi
  80407e:	00 00 00 
  804081:	b8 00 00 00 00       	mov    $0x0,%eax
  804086:	49 b8 8c 09 80 00 00 	movabs $0x80098c,%r8
  80408d:	00 00 00 
  804090:	41 ff d0             	callq  *%r8
	}
  804093:	e9 4a ff ff ff       	jmpq   803fe2 <_pipeisclosed+0x11>
  804098:	e9 45 ff ff ff       	jmpq   803fe2 <_pipeisclosed+0x11>
}
  80409d:	48 83 c4 28          	add    $0x28,%rsp
  8040a1:	5b                   	pop    %rbx
  8040a2:	5d                   	pop    %rbp
  8040a3:	c3                   	retq   

00000000008040a4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040a4:	55                   	push   %rbp
  8040a5:	48 89 e5             	mov    %rsp,%rbp
  8040a8:	48 83 ec 30          	sub    $0x30,%rsp
  8040ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040b6:	48 89 d6             	mov    %rdx,%rsi
  8040b9:	89 c7                	mov    %eax,%edi
  8040bb:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
  8040c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ce:	79 05                	jns    8040d5 <pipeisclosed+0x31>
		return r;
  8040d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d3:	eb 31                	jmp    804106 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d9:	48 89 c7             	mov    %rax,%rdi
  8040dc:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f4:	48 89 d6             	mov    %rdx,%rsi
  8040f7:	48 89 c7             	mov    %rax,%rdi
  8040fa:	48 b8 d1 3f 80 00 00 	movabs $0x803fd1,%rax
  804101:	00 00 00 
  804104:	ff d0                	callq  *%rax
}
  804106:	c9                   	leaveq 
  804107:	c3                   	retq   

0000000000804108 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804108:	55                   	push   %rbp
  804109:	48 89 e5             	mov    %rsp,%rbp
  80410c:	48 83 ec 40          	sub    $0x40,%rsp
  804110:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804114:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804118:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80411c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804120:	48 89 c7             	mov    %rax,%rdi
  804123:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  80412a:	00 00 00 
  80412d:	ff d0                	callq  *%rax
  80412f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804133:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804137:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80413b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804142:	00 
  804143:	e9 92 00 00 00       	jmpq   8041da <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804148:	eb 41                	jmp    80418b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80414a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80414f:	74 09                	je     80415a <devpipe_read+0x52>
				return i;
  804151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804155:	e9 92 00 00 00       	jmpq   8041ec <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80415a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80415e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804162:	48 89 d6             	mov    %rdx,%rsi
  804165:	48 89 c7             	mov    %rax,%rdi
  804168:	48 b8 d1 3f 80 00 00 	movabs $0x803fd1,%rax
  80416f:	00 00 00 
  804172:	ff d0                	callq  *%rax
  804174:	85 c0                	test   %eax,%eax
  804176:	74 07                	je     80417f <devpipe_read+0x77>
				return 0;
  804178:	b8 00 00 00 00       	mov    $0x0,%eax
  80417d:	eb 6d                	jmp    8041ec <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80417f:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804186:	00 00 00 
  804189:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80418b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80418f:	8b 10                	mov    (%rax),%edx
  804191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804195:	8b 40 04             	mov    0x4(%rax),%eax
  804198:	39 c2                	cmp    %eax,%edx
  80419a:	74 ae                	je     80414a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80419c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041a4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ac:	8b 00                	mov    (%rax),%eax
  8041ae:	99                   	cltd   
  8041af:	c1 ea 1b             	shr    $0x1b,%edx
  8041b2:	01 d0                	add    %edx,%eax
  8041b4:	83 e0 1f             	and    $0x1f,%eax
  8041b7:	29 d0                	sub    %edx,%eax
  8041b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041bd:	48 98                	cltq   
  8041bf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041c4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ca:	8b 00                	mov    (%rax),%eax
  8041cc:	8d 50 01             	lea    0x1(%rax),%edx
  8041cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041e2:	0f 82 60 ff ff ff    	jb     804148 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8041e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041ec:	c9                   	leaveq 
  8041ed:	c3                   	retq   

00000000008041ee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041ee:	55                   	push   %rbp
  8041ef:	48 89 e5             	mov    %rsp,%rbp
  8041f2:	48 83 ec 40          	sub    $0x40,%rsp
  8041f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804206:	48 89 c7             	mov    %rax,%rdi
  804209:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  804210:	00 00 00 
  804213:	ff d0                	callq  *%rax
  804215:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804219:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80421d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804221:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804228:	00 
  804229:	e9 8e 00 00 00       	jmpq   8042bc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80422e:	eb 31                	jmp    804261 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804230:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804238:	48 89 d6             	mov    %rdx,%rsi
  80423b:	48 89 c7             	mov    %rax,%rdi
  80423e:	48 b8 d1 3f 80 00 00 	movabs $0x803fd1,%rax
  804245:	00 00 00 
  804248:	ff d0                	callq  *%rax
  80424a:	85 c0                	test   %eax,%eax
  80424c:	74 07                	je     804255 <devpipe_write+0x67>
				return 0;
  80424e:	b8 00 00 00 00       	mov    $0x0,%eax
  804253:	eb 79                	jmp    8042ce <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804255:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80425c:	00 00 00 
  80425f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804265:	8b 40 04             	mov    0x4(%rax),%eax
  804268:	48 63 d0             	movslq %eax,%rdx
  80426b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80426f:	8b 00                	mov    (%rax),%eax
  804271:	48 98                	cltq   
  804273:	48 83 c0 20          	add    $0x20,%rax
  804277:	48 39 c2             	cmp    %rax,%rdx
  80427a:	73 b4                	jae    804230 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80427c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804280:	8b 40 04             	mov    0x4(%rax),%eax
  804283:	99                   	cltd   
  804284:	c1 ea 1b             	shr    $0x1b,%edx
  804287:	01 d0                	add    %edx,%eax
  804289:	83 e0 1f             	and    $0x1f,%eax
  80428c:	29 d0                	sub    %edx,%eax
  80428e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804292:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804296:	48 01 ca             	add    %rcx,%rdx
  804299:	0f b6 0a             	movzbl (%rdx),%ecx
  80429c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042a0:	48 98                	cltq   
  8042a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042aa:	8b 40 04             	mov    0x4(%rax),%eax
  8042ad:	8d 50 01             	lea    0x1(%rax),%edx
  8042b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042c4:	0f 82 64 ff ff ff    	jb     80422e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042ce:	c9                   	leaveq 
  8042cf:	c3                   	retq   

00000000008042d0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042d0:	55                   	push   %rbp
  8042d1:	48 89 e5             	mov    %rsp,%rbp
  8042d4:	48 83 ec 20          	sub    $0x20,%rsp
  8042d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e4:	48 89 c7             	mov    %rax,%rdi
  8042e7:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  8042ee:	00 00 00 
  8042f1:	ff d0                	callq  *%rax
  8042f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042fb:	48 be 1d 4f 80 00 00 	movabs $0x804f1d,%rsi
  804302:	00 00 00 
  804305:	48 89 c7             	mov    %rax,%rdi
  804308:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  80430f:	00 00 00 
  804312:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804318:	8b 50 04             	mov    0x4(%rax),%edx
  80431b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80431f:	8b 00                	mov    (%rax),%eax
  804321:	29 c2                	sub    %eax,%edx
  804323:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804327:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80432d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804331:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804338:	00 00 00 
	stat->st_dev = &devpipe;
  80433b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80433f:	48 b9 80 78 80 00 00 	movabs $0x807880,%rcx
  804346:	00 00 00 
  804349:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804355:	c9                   	leaveq 
  804356:	c3                   	retq   

0000000000804357 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804357:	55                   	push   %rbp
  804358:	48 89 e5             	mov    %rsp,%rbp
  80435b:	48 83 ec 10          	sub    $0x10,%rsp
  80435f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804367:	48 89 c6             	mov    %rax,%rsi
  80436a:	bf 00 00 00 00       	mov    $0x0,%edi
  80436f:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80437b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80437f:	48 89 c7             	mov    %rax,%rdi
  804382:	48 b8 e1 22 80 00 00 	movabs $0x8022e1,%rax
  804389:	00 00 00 
  80438c:	ff d0                	callq  *%rax
  80438e:	48 89 c6             	mov    %rax,%rsi
  804391:	bf 00 00 00 00       	mov    $0x0,%edi
  804396:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  80439d:	00 00 00 
  8043a0:	ff d0                	callq  *%rax
}
  8043a2:	c9                   	leaveq 
  8043a3:	c3                   	retq   

00000000008043a4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8043a4:	55                   	push   %rbp
  8043a5:	48 89 e5             	mov    %rsp,%rbp
  8043a8:	48 83 ec 20          	sub    $0x20,%rsp
  8043ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8043af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b3:	75 35                	jne    8043ea <wait+0x46>
  8043b5:	48 b9 24 4f 80 00 00 	movabs $0x804f24,%rcx
  8043bc:	00 00 00 
  8043bf:	48 ba 2f 4f 80 00 00 	movabs $0x804f2f,%rdx
  8043c6:	00 00 00 
  8043c9:	be 09 00 00 00       	mov    $0x9,%esi
  8043ce:	48 bf 44 4f 80 00 00 	movabs $0x804f44,%rdi
  8043d5:	00 00 00 
  8043d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043dd:	49 b8 53 07 80 00 00 	movabs $0x800753,%r8
  8043e4:	00 00 00 
  8043e7:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8043ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8043f2:	48 98                	cltq   
  8043f4:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8043fb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804402:	00 00 00 
  804405:	48 01 d0             	add    %rdx,%rax
  804408:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80440c:	eb 0c                	jmp    80441a <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  80440e:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804415:	00 00 00 
  804418:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80441a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804424:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804427:	75 0e                	jne    804437 <wait+0x93>
  804429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80442d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804433:	85 c0                	test   %eax,%eax
  804435:	75 d7                	jne    80440e <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804437:	c9                   	leaveq 
  804438:	c3                   	retq   

0000000000804439 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804439:	55                   	push   %rbp
  80443a:	48 89 e5             	mov    %rsp,%rbp
  80443d:	48 83 ec 30          	sub    $0x30,%rsp
  804441:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804445:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804449:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80444d:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804454:	00 00 00 
  804457:	48 8b 00             	mov    (%rax),%rax
  80445a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804460:	85 c0                	test   %eax,%eax
  804462:	75 34                	jne    804498 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804464:	48 b8 f4 1d 80 00 00 	movabs $0x801df4,%rax
  80446b:	00 00 00 
  80446e:	ff d0                	callq  *%rax
  804470:	25 ff 03 00 00       	and    $0x3ff,%eax
  804475:	48 98                	cltq   
  804477:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80447e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804485:	00 00 00 
  804488:	48 01 c2             	add    %rax,%rdx
  80448b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804492:	00 00 00 
  804495:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804498:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80449d:	75 0e                	jne    8044ad <ipc_recv+0x74>
		pg = (void*) UTOP;
  80449f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8044a6:	00 00 00 
  8044a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8044ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b1:	48 89 c7             	mov    %rax,%rdi
  8044b4:	48 b8 99 20 80 00 00 	movabs $0x802099,%rax
  8044bb:	00 00 00 
  8044be:	ff d0                	callq  *%rax
  8044c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8044c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c7:	79 19                	jns    8044e2 <ipc_recv+0xa9>
		*from_env_store = 0;
  8044c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044cd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8044d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044d7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8044dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e0:	eb 53                	jmp    804535 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8044e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8044e7:	74 19                	je     804502 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8044e9:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8044f0:	00 00 00 
  8044f3:	48 8b 00             	mov    (%rax),%rax
  8044f6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8044fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804500:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804502:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804507:	74 19                	je     804522 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804509:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804510:	00 00 00 
  804513:	48 8b 00             	mov    (%rax),%rax
  804516:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80451c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804520:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804522:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804529:	00 00 00 
  80452c:	48 8b 00             	mov    (%rax),%rax
  80452f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804535:	c9                   	leaveq 
  804536:	c3                   	retq   

0000000000804537 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804537:	55                   	push   %rbp
  804538:	48 89 e5             	mov    %rsp,%rbp
  80453b:	48 83 ec 30          	sub    $0x30,%rsp
  80453f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804542:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804545:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804549:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80454c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804551:	75 0e                	jne    804561 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804553:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80455a:	00 00 00 
  80455d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804561:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804564:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804567:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80456b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80456e:	89 c7                	mov    %eax,%edi
  804570:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  804577:	00 00 00 
  80457a:	ff d0                	callq  *%rax
  80457c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80457f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804583:	75 0c                	jne    804591 <ipc_send+0x5a>
			sys_yield();
  804585:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80458c:	00 00 00 
  80458f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804591:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804595:	74 ca                	je     804561 <ipc_send+0x2a>
	if(result != 0)
  804597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80459b:	74 20                	je     8045bd <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80459d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a0:	89 c6                	mov    %eax,%esi
  8045a2:	48 bf 4f 4f 80 00 00 	movabs $0x804f4f,%rdi
  8045a9:	00 00 00 
  8045ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b1:	48 ba 8c 09 80 00 00 	movabs $0x80098c,%rdx
  8045b8:	00 00 00 
  8045bb:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8045bd:	c9                   	leaveq 
  8045be:	c3                   	retq   

00000000008045bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8045bf:	55                   	push   %rbp
  8045c0:	48 89 e5             	mov    %rsp,%rbp
  8045c3:	48 83 ec 14          	sub    $0x14,%rsp
  8045c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8045ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045d1:	eb 4e                	jmp    804621 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8045d3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8045da:	00 00 00 
  8045dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e0:	48 98                	cltq   
  8045e2:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8045e9:	48 01 d0             	add    %rdx,%rax
  8045ec:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8045f2:	8b 00                	mov    (%rax),%eax
  8045f4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8045f7:	75 24                	jne    80461d <ipc_find_env+0x5e>
			return envs[i].env_id;
  8045f9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804600:	00 00 00 
  804603:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804606:	48 98                	cltq   
  804608:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80460f:	48 01 d0             	add    %rdx,%rax
  804612:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804618:	8b 40 08             	mov    0x8(%rax),%eax
  80461b:	eb 12                	jmp    80462f <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80461d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804621:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804628:	7e a9                	jle    8045d3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80462a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80462f:	c9                   	leaveq 
  804630:	c3                   	retq   

0000000000804631 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804631:	55                   	push   %rbp
  804632:	48 89 e5             	mov    %rsp,%rbp
  804635:	48 83 ec 18          	sub    $0x18,%rsp
  804639:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80463d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804641:	48 c1 e8 15          	shr    $0x15,%rax
  804645:	48 89 c2             	mov    %rax,%rdx
  804648:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80464f:	01 00 00 
  804652:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804656:	83 e0 01             	and    $0x1,%eax
  804659:	48 85 c0             	test   %rax,%rax
  80465c:	75 07                	jne    804665 <pageref+0x34>
		return 0;
  80465e:	b8 00 00 00 00       	mov    $0x0,%eax
  804663:	eb 53                	jmp    8046b8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804669:	48 c1 e8 0c          	shr    $0xc,%rax
  80466d:	48 89 c2             	mov    %rax,%rdx
  804670:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804677:	01 00 00 
  80467a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80467e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804686:	83 e0 01             	and    $0x1,%eax
  804689:	48 85 c0             	test   %rax,%rax
  80468c:	75 07                	jne    804695 <pageref+0x64>
		return 0;
  80468e:	b8 00 00 00 00       	mov    $0x0,%eax
  804693:	eb 23                	jmp    8046b8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804699:	48 c1 e8 0c          	shr    $0xc,%rax
  80469d:	48 89 c2             	mov    %rax,%rdx
  8046a0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8046a7:	00 00 00 
  8046aa:	48 c1 e2 04          	shl    $0x4,%rdx
  8046ae:	48 01 d0             	add    %rdx,%rax
  8046b1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8046b5:	0f b7 c0             	movzwl %ax,%eax
}
  8046b8:	c9                   	leaveq 
  8046b9:	c3                   	retq   
