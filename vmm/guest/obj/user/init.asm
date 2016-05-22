
vmm/guest/obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 69 06 00 00       	callq  8006aa <libmain>
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
  8000a5:	48 bf 00 49 80 00 00 	movabs $0x804900,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
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
  8000f5:	48 bf 10 49 80 00 00 	movabs $0x804910,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 89 09 80 00 00 	movabs $0x800989,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 49 49 80 00 00 	movabs $0x804949,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
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
  800156:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 8f 49 80 00 00 	movabs $0x80498f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be a5 49 80 00 00 	movabs $0x8049a5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be b1 49 80 00 00 	movabs $0x8049b1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
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
  8001fe:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be b4 49 80 00 00 	movabs $0x8049b4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
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
  800247:	48 bf b6 49 80 00 00 	movabs $0x8049b6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf ba 49 80 00 00 	movabs $0x8049ba,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 b8 04 80 00 00 	movabs $0x8004b8,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba cc 49 80 00 00 	movabs $0x8049cc,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf d9 49 80 00 00 	movabs $0x8049d9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba e5 49 80 00 00 	movabs $0x8049e5,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf d9 49 80 00 00 	movabs $0x8049d9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 2c 25 80 00 00 	movabs $0x80252c,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba ff 49 80 00 00 	movabs $0x8049ff,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf d9 49 80 00 00 	movabs $0x8049d9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 07 4a 80 00 00 	movabs $0x804a07,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 1a 4a 80 00 00 	movabs $0x804a1a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 1d 4a 80 00 00 	movabs $0x804a1d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 e1 34 80 00 00 	movabs $0x8034e1,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 22                	jns    8003c8 <umain+0x33b>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
		cprintf("init waiting\n");
		wait(r);
#ifdef VMM_GUEST
		break;
#endif
	}
  8003c6:	eb 90                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c8:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  8003cf:	00 00 00 
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  8003de:	00 00 00 
  8003e1:	ff d2                	callq  *%rdx
		wait(r);
  8003e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e6:	89 c7                	mov    %eax,%edi
  8003e8:	48 b8 a3 42 80 00 00 	movabs $0x8042a3,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
#ifdef VMM_GUEST
		break;
  8003f4:	90                   	nop
#endif
	}
}
  8003f5:	c9                   	leaveq 
  8003f6:	c3                   	retq   

00000000008003f7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003f7:	55                   	push   %rbp
  8003f8:	48 89 e5             	mov    %rsp,%rbp
  8003fb:	48 83 ec 20          	sub    $0x20,%rsp
  8003ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800402:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800405:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800408:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040c:	be 01 00 00 00       	mov    $0x1,%esi
  800411:	48 89 c7             	mov    %rax,%rdi
  800414:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
}
  800420:	c9                   	leaveq 
  800421:	c3                   	retq   

0000000000800422 <getchar>:

int
getchar(void)
{
  800422:	55                   	push   %rbp
  800423:	48 89 e5             	mov    %rsp,%rbp
  800426:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80042e:	ba 01 00 00 00       	mov    $0x1,%edx
  800433:	48 89 c6             	mov    %rax,%rsi
  800436:	bf 00 00 00 00       	mov    $0x0,%edi
  80043b:	48 b8 d5 26 80 00 00 	movabs $0x8026d5,%rax
  800442:	00 00 00 
  800445:	ff d0                	callq  *%rax
  800447:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044e:	79 05                	jns    800455 <getchar+0x33>
		return r;
  800450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800453:	eb 14                	jmp    800469 <getchar+0x47>
	if (r < 1)
  800455:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800459:	7f 07                	jg     800462 <getchar+0x40>
		return -E_EOF;
  80045b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800460:	eb 07                	jmp    800469 <getchar+0x47>
	return c;
  800462:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800466:	0f b6 c0             	movzbl %al,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 20          	sub    $0x20,%rsp
  800473:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800476:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80047d:	48 89 d6             	mov    %rdx,%rsi
  800480:	89 c7                	mov    %eax,%edi
  800482:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
  80048e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800495:	79 05                	jns    80049c <iscons+0x31>
		return r;
  800497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049a:	eb 1a                	jmp    8004b6 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 10                	mov    (%rax),%edx
  8004a2:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  8004a9:	00 00 00 
  8004ac:	8b 00                	mov    (%rax),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	0f 94 c0             	sete   %al
  8004b3:	0f b6 c0             	movzbl %al,%eax
}
  8004b6:	c9                   	leaveq 
  8004b7:	c3                   	retq   

00000000008004b8 <opencons>:

int
opencons(void)
{
  8004b8:	55                   	push   %rbp
  8004b9:	48 89 e5             	mov    %rsp,%rbp
  8004bc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c4:	48 89 c7             	mov    %rax,%rdi
  8004c7:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  8004ce:	00 00 00 
  8004d1:	ff d0                	callq  *%rax
  8004d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004da:	79 05                	jns    8004e1 <opencons+0x29>
		return r;
  8004dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004df:	eb 5b                	jmp    80053c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ea:	48 89 c6             	mov    %rax,%rsi
  8004ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f2:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
  8004fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800501:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800505:	79 05                	jns    80050c <opencons+0x54>
		return r;
  800507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050a:	eb 30                	jmp    80053c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800510:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  800517:	00 00 00 
  80051a:	8b 12                	mov    (%rdx),%edx
  80051c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80051e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800522:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052d:	48 89 c7             	mov    %rax,%rdi
  800530:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  800537:	00 00 00 
  80053a:	ff d0                	callq  *%rax
}
  80053c:	c9                   	leaveq 
  80053d:	c3                   	retq   

000000000080053e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80053e:	55                   	push   %rbp
  80053f:	48 89 e5             	mov    %rsp,%rbp
  800542:	48 83 ec 30          	sub    $0x30,%rsp
  800546:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80054e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800552:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800557:	75 07                	jne    800560 <devcons_read+0x22>
		return 0;
  800559:	b8 00 00 00 00       	mov    $0x0,%eax
  80055e:	eb 4b                	jmp    8005ab <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800560:	eb 0c                	jmp    80056e <devcons_read+0x30>
		sys_yield();
  800562:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80056e:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  800575:	00 00 00 
  800578:	ff d0                	callq  *%rax
  80057a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80057d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800581:	74 df                	je     800562 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800587:	79 05                	jns    80058e <devcons_read+0x50>
		return c;
  800589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058c:	eb 1d                	jmp    8005ab <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80058e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800592:	75 07                	jne    80059b <devcons_read+0x5d>
		return 0;
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	eb 10                	jmp    8005ab <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	89 c2                	mov    %eax,%edx
  8005a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a4:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ab:	c9                   	leaveq 
  8005ac:	c3                   	retq   

00000000008005ad <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005ad:	55                   	push   %rbp
  8005ae:	48 89 e5             	mov    %rsp,%rbp
  8005b1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005b8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005bf:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d4:	eb 76                	jmp    80064c <devcons_write+0x9f>
		m = n - tot;
  8005d6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005dd:	89 c2                	mov    %eax,%edx
  8005df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e2:	29 c2                	sub    %eax,%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ec:	83 f8 7f             	cmp    $0x7f,%eax
  8005ef:	76 07                	jbe    8005f8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fb:	48 63 d0             	movslq %eax,%rdx
  8005fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800601:	48 63 c8             	movslq %eax,%rcx
  800604:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060b:	48 01 c1             	add    %rax,%rcx
  80060e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 62 18 80 00 00 	movabs $0x801862,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  800627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062a:	48 63 d0             	movslq %eax,%rdx
  80062d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800634:	48 89 d6             	mov    %rdx,%rsi
  800637:	48 89 c7             	mov    %rax,%rdi
  80063a:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  800641:	00 00 00 
  800644:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800646:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800649:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80064f:	48 98                	cltq   
  800651:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800658:	0f 82 78 ff ff ff    	jb     8005d6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80065e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	48 83 ec 08          	sub    $0x8,%rsp
  80066b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800674:	c9                   	leaveq 
  800675:	c3                   	retq   

0000000000800676 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800676:	55                   	push   %rbp
  800677:	48 89 e5             	mov    %rsp,%rbp
  80067a:	48 83 ec 10          	sub    $0x10,%rsp
  80067e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800682:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068a:	48 be 4c 4a 80 00 00 	movabs $0x804a4c,%rsi
  800691:	00 00 00 
  800694:	48 89 c7             	mov    %rax,%rdi
  800697:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  80069e:	00 00 00 
  8006a1:	ff d0                	callq  *%rax
	return 0;
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006a8:	c9                   	leaveq 
  8006a9:	c3                   	retq   

00000000008006aa <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006aa:	55                   	push   %rbp
  8006ab:	48 89 e5             	mov    %rsp,%rbp
  8006ae:	48 83 ec 10          	sub    $0x10,%rsp
  8006b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8006b9:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  8006c0:	00 00 00 
  8006c3:	ff d0                	callq  *%rax
  8006c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006ca:	48 98                	cltq   
  8006cc:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8006d3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006da:	00 00 00 
  8006dd:	48 01 c2             	add    %rax,%rdx
  8006e0:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006e7:	00 00 00 
  8006ea:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006f1:	7e 14                	jle    800707 <libmain+0x5d>
		binaryname = argv[0];
  8006f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f7:	48 8b 10             	mov    (%rax),%rdx
  8006fa:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  800701:	00 00 00 
  800704:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80070e:	48 89 d6             	mov    %rdx,%rsi
  800711:	89 c7                	mov    %eax,%edi
  800713:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80071f:	48 b8 2d 07 80 00 00 	movabs $0x80072d,%rax
  800726:	00 00 00 
  800729:	ff d0                	callq  *%rax
}
  80072b:	c9                   	leaveq 
  80072c:	c3                   	retq   

000000000080072d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80072d:	55                   	push   %rbp
  80072e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800731:	48 b8 fe 24 80 00 00 	movabs $0x8024fe,%rax
  800738:	00 00 00 
  80073b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80073d:	bf 00 00 00 00       	mov    $0x0,%edi
  800742:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  800749:	00 00 00 
  80074c:	ff d0                	callq  *%rax

}
  80074e:	5d                   	pop    %rbp
  80074f:	c3                   	retq   

0000000000800750 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	53                   	push   %rbx
  800755:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80075c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800763:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800769:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800770:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800777:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80077e:	84 c0                	test   %al,%al
  800780:	74 23                	je     8007a5 <_panic+0x55>
  800782:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800789:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80078d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800791:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800795:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800799:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80079d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007a1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007a5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007ac:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007b3:	00 00 00 
  8007b6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007bd:	00 00 00 
  8007c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007cb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007d9:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007e0:	00 00 00 
  8007e3:	48 8b 18             	mov    (%rax),%rbx
  8007e6:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	callq  *%rax
  8007f2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8007f8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8007ff:	41 89 c8             	mov    %ecx,%r8d
  800802:	48 89 d1             	mov    %rdx,%rcx
  800805:	48 89 da             	mov    %rbx,%rdx
  800808:	89 c6                	mov    %eax,%esi
  80080a:	48 bf 60 4a 80 00 00 	movabs $0x804a60,%rdi
  800811:	00 00 00 
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
  800819:	49 b9 89 09 80 00 00 	movabs $0x800989,%r9
  800820:	00 00 00 
  800823:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800826:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80082d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800834:	48 89 d6             	mov    %rdx,%rsi
  800837:	48 89 c7             	mov    %rax,%rdi
  80083a:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800841:	00 00 00 
  800844:	ff d0                	callq  *%rax
	cprintf("\n");
  800846:	48 bf 83 4a 80 00 00 	movabs $0x804a83,%rdi
  80084d:	00 00 00 
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  80085c:	00 00 00 
  80085f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800861:	cc                   	int3   
  800862:	eb fd                	jmp    800861 <_panic+0x111>

0000000000800864 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	48 83 ec 10          	sub    $0x10,%rsp
  80086c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80086f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800877:	8b 00                	mov    (%rax),%eax
  800879:	8d 48 01             	lea    0x1(%rax),%ecx
  80087c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800880:	89 0a                	mov    %ecx,(%rdx)
  800882:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800885:	89 d1                	mov    %edx,%ecx
  800887:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80088b:	48 98                	cltq   
  80088d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800895:	8b 00                	mov    (%rax),%eax
  800897:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089c:	75 2c                	jne    8008ca <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80089e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a2:	8b 00                	mov    (%rax),%eax
  8008a4:	48 98                	cltq   
  8008a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008aa:	48 83 c2 08          	add    $0x8,%rdx
  8008ae:	48 89 c6             	mov    %rax,%rsi
  8008b1:	48 89 d7             	mov    %rdx,%rdi
  8008b4:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  8008bb:	00 00 00 
  8008be:	ff d0                	callq  *%rax
        b->idx = 0;
  8008c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ce:	8b 40 04             	mov    0x4(%rax),%eax
  8008d1:	8d 50 01             	lea    0x1(%rax),%edx
  8008d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008db:	c9                   	leaveq 
  8008dc:	c3                   	retq   

00000000008008dd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008dd:	55                   	push   %rbp
  8008de:	48 89 e5             	mov    %rsp,%rbp
  8008e1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008e8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008ef:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8008f6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8008fd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800904:	48 8b 0a             	mov    (%rdx),%rcx
  800907:	48 89 08             	mov    %rcx,(%rax)
  80090a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80090e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800912:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800916:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80091a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800921:	00 00 00 
    b.cnt = 0;
  800924:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80092b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80092e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800935:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80093c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800943:	48 89 c6             	mov    %rax,%rsi
  800946:	48 bf 64 08 80 00 00 	movabs $0x800864,%rdi
  80094d:	00 00 00 
  800950:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  800957:	00 00 00 
  80095a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80095c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800962:	48 98                	cltq   
  800964:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80096b:	48 83 c2 08          	add    $0x8,%rdx
  80096f:	48 89 c6             	mov    %rax,%rsi
  800972:	48 89 d7             	mov    %rdx,%rdi
  800975:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80097c:	00 00 00 
  80097f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800981:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800987:	c9                   	leaveq 
  800988:	c3                   	retq   

0000000000800989 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800989:	55                   	push   %rbp
  80098a:	48 89 e5             	mov    %rsp,%rbp
  80098d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800994:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80099b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009b7:	84 c0                	test   %al,%al
  8009b9:	74 20                	je     8009db <cprintf+0x52>
  8009bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009db:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009e2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009e9:	00 00 00 
  8009ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009f3:	00 00 00 
  8009f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a01:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a08:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a0f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a16:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a1d:	48 8b 0a             	mov    (%rdx),%rcx
  800a20:	48 89 08             	mov    %rcx,(%rax)
  800a23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a33:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a3a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a41:	48 89 d6             	mov    %rdx,%rsi
  800a44:	48 89 c7             	mov    %rax,%rdi
  800a47:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800a4e:	00 00 00 
  800a51:	ff d0                	callq  *%rax
  800a53:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a59:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a5f:	c9                   	leaveq 
  800a60:	c3                   	retq   

0000000000800a61 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a61:	55                   	push   %rbp
  800a62:	48 89 e5             	mov    %rsp,%rbp
  800a65:	53                   	push   %rbx
  800a66:	48 83 ec 38          	sub    $0x38,%rsp
  800a6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a76:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a79:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a7d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a81:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a84:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a88:	77 3b                	ja     800ac5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a8d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a91:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a98:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9d:	48 f7 f3             	div    %rbx
  800aa0:	48 89 c2             	mov    %rax,%rdx
  800aa3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800aa6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800aa9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab1:	41 89 f9             	mov    %edi,%r9d
  800ab4:	48 89 c7             	mov    %rax,%rdi
  800ab7:	48 b8 61 0a 80 00 00 	movabs $0x800a61,%rax
  800abe:	00 00 00 
  800ac1:	ff d0                	callq  *%rax
  800ac3:	eb 1e                	jmp    800ae3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac5:	eb 12                	jmp    800ad9 <printnum+0x78>
			putch(padc, putdat);
  800ac7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800acb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	48 89 ce             	mov    %rcx,%rsi
  800ad5:	89 d7                	mov    %edx,%edi
  800ad7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800add:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800ae1:	7f e4                	jg     800ac7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800ae6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aea:	ba 00 00 00 00       	mov    $0x0,%edx
  800aef:	48 f7 f1             	div    %rcx
  800af2:	48 89 d0             	mov    %rdx,%rax
  800af5:	48 ba 90 4c 80 00 00 	movabs $0x804c90,%rdx
  800afc:	00 00 00 
  800aff:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b03:	0f be d0             	movsbl %al,%edx
  800b06:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0e:	48 89 ce             	mov    %rcx,%rsi
  800b11:	89 d7                	mov    %edx,%edi
  800b13:	ff d0                	callq  *%rax
}
  800b15:	48 83 c4 38          	add    $0x38,%rsp
  800b19:	5b                   	pop    %rbx
  800b1a:	5d                   	pop    %rbp
  800b1b:	c3                   	retq   

0000000000800b1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b28:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800b2b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b2f:	7e 52                	jle    800b83 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	8b 00                	mov    (%rax),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 24                	jae    800b60 <getuint+0x44>
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	8b 00                	mov    (%rax),%eax
  800b4a:	89 c0                	mov    %eax,%eax
  800b4c:	48 01 d0             	add    %rdx,%rax
  800b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b53:	8b 12                	mov    (%rdx),%edx
  800b55:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	89 0a                	mov    %ecx,(%rdx)
  800b5e:	eb 17                	jmp    800b77 <getuint+0x5b>
  800b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b64:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b68:	48 89 d0             	mov    %rdx,%rax
  800b6b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b73:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b77:	48 8b 00             	mov    (%rax),%rax
  800b7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7e:	e9 a3 00 00 00       	jmpq   800c26 <getuint+0x10a>
	else if (lflag)
  800b83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b87:	74 4f                	je     800bd8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8d:	8b 00                	mov    (%rax),%eax
  800b8f:	83 f8 30             	cmp    $0x30,%eax
  800b92:	73 24                	jae    800bb8 <getuint+0x9c>
  800b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b98:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba0:	8b 00                	mov    (%rax),%eax
  800ba2:	89 c0                	mov    %eax,%eax
  800ba4:	48 01 d0             	add    %rdx,%rax
  800ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bab:	8b 12                	mov    (%rdx),%edx
  800bad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb4:	89 0a                	mov    %ecx,(%rdx)
  800bb6:	eb 17                	jmp    800bcf <getuint+0xb3>
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc0:	48 89 d0             	mov    %rdx,%rax
  800bc3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bcf:	48 8b 00             	mov    (%rax),%rax
  800bd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bd6:	eb 4e                	jmp    800c26 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	8b 00                	mov    (%rax),%eax
  800bde:	83 f8 30             	cmp    $0x30,%eax
  800be1:	73 24                	jae    800c07 <getuint+0xeb>
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800beb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bef:	8b 00                	mov    (%rax),%eax
  800bf1:	89 c0                	mov    %eax,%eax
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfa:	8b 12                	mov    (%rdx),%edx
  800bfc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c03:	89 0a                	mov    %ecx,(%rdx)
  800c05:	eb 17                	jmp    800c1e <getuint+0x102>
  800c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c0f:	48 89 d0             	mov    %rdx,%rax
  800c12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c1e:	8b 00                	mov    (%rax),%eax
  800c20:	89 c0                	mov    %eax,%eax
  800c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c2a:	c9                   	leaveq 
  800c2b:	c3                   	retq   

0000000000800c2c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c2c:	55                   	push   %rbp
  800c2d:	48 89 e5             	mov    %rsp,%rbp
  800c30:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c38:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c3b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c3f:	7e 52                	jle    800c93 <getint+0x67>
		x=va_arg(*ap, long long);
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	8b 00                	mov    (%rax),%eax
  800c47:	83 f8 30             	cmp    $0x30,%eax
  800c4a:	73 24                	jae    800c70 <getint+0x44>
  800c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c58:	8b 00                	mov    (%rax),%eax
  800c5a:	89 c0                	mov    %eax,%eax
  800c5c:	48 01 d0             	add    %rdx,%rax
  800c5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c63:	8b 12                	mov    (%rdx),%edx
  800c65:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c6c:	89 0a                	mov    %ecx,(%rdx)
  800c6e:	eb 17                	jmp    800c87 <getint+0x5b>
  800c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c74:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c78:	48 89 d0             	mov    %rdx,%rax
  800c7b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c87:	48 8b 00             	mov    (%rax),%rax
  800c8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c8e:	e9 a3 00 00 00       	jmpq   800d36 <getint+0x10a>
	else if (lflag)
  800c93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c97:	74 4f                	je     800ce8 <getint+0xbc>
		x=va_arg(*ap, long);
  800c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9d:	8b 00                	mov    (%rax),%eax
  800c9f:	83 f8 30             	cmp    $0x30,%eax
  800ca2:	73 24                	jae    800cc8 <getint+0x9c>
  800ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb0:	8b 00                	mov    (%rax),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cbb:	8b 12                	mov    (%rdx),%edx
  800cbd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc4:	89 0a                	mov    %ecx,(%rdx)
  800cc6:	eb 17                	jmp    800cdf <getint+0xb3>
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cd0:	48 89 d0             	mov    %rdx,%rax
  800cd3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cd7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cdb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cdf:	48 8b 00             	mov    (%rax),%rax
  800ce2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ce6:	eb 4e                	jmp    800d36 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cec:	8b 00                	mov    (%rax),%eax
  800cee:	83 f8 30             	cmp    $0x30,%eax
  800cf1:	73 24                	jae    800d17 <getint+0xeb>
  800cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cff:	8b 00                	mov    (%rax),%eax
  800d01:	89 c0                	mov    %eax,%eax
  800d03:	48 01 d0             	add    %rdx,%rax
  800d06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0a:	8b 12                	mov    (%rdx),%edx
  800d0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d13:	89 0a                	mov    %ecx,(%rdx)
  800d15:	eb 17                	jmp    800d2e <getint+0x102>
  800d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d1f:	48 89 d0             	mov    %rdx,%rax
  800d22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d2e:	8b 00                	mov    (%rax),%eax
  800d30:	48 98                	cltq   
  800d32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d3a:	c9                   	leaveq 
  800d3b:	c3                   	retq   

0000000000800d3c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d3c:	55                   	push   %rbp
  800d3d:	48 89 e5             	mov    %rsp,%rbp
  800d40:	41 54                	push   %r12
  800d42:	53                   	push   %rbx
  800d43:	48 83 ec 60          	sub    $0x60,%rsp
  800d47:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d4b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d4f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d53:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d5f:	48 8b 0a             	mov    (%rdx),%rcx
  800d62:	48 89 08             	mov    %rcx,(%rax)
  800d65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d75:	eb 17                	jmp    800d8e <vprintfmt+0x52>
			if (ch == '\0')
  800d77:	85 db                	test   %ebx,%ebx
  800d79:	0f 84 cc 04 00 00    	je     80124b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d87:	48 89 d6             	mov    %rdx,%rsi
  800d8a:	89 df                	mov    %ebx,%edi
  800d8c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d92:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d96:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d9a:	0f b6 00             	movzbl (%rax),%eax
  800d9d:	0f b6 d8             	movzbl %al,%ebx
  800da0:	83 fb 25             	cmp    $0x25,%ebx
  800da3:	75 d2                	jne    800d77 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800da5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800da9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800db0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800db7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dbe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dc5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dcd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dd1:	0f b6 00             	movzbl (%rax),%eax
  800dd4:	0f b6 d8             	movzbl %al,%ebx
  800dd7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800dda:	83 f8 55             	cmp    $0x55,%eax
  800ddd:	0f 87 34 04 00 00    	ja     801217 <vprintfmt+0x4db>
  800de3:	89 c0                	mov    %eax,%eax
  800de5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800dec:	00 
  800ded:	48 b8 b8 4c 80 00 00 	movabs $0x804cb8,%rax
  800df4:	00 00 00 
  800df7:	48 01 d0             	add    %rdx,%rax
  800dfa:	48 8b 00             	mov    (%rax),%rax
  800dfd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800dff:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e03:	eb c0                	jmp    800dc5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e05:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e09:	eb ba                	jmp    800dc5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e0b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e12:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e15:	89 d0                	mov    %edx,%eax
  800e17:	c1 e0 02             	shl    $0x2,%eax
  800e1a:	01 d0                	add    %edx,%eax
  800e1c:	01 c0                	add    %eax,%eax
  800e1e:	01 d8                	add    %ebx,%eax
  800e20:	83 e8 30             	sub    $0x30,%eax
  800e23:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e26:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e2a:	0f b6 00             	movzbl (%rax),%eax
  800e2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e30:	83 fb 2f             	cmp    $0x2f,%ebx
  800e33:	7e 0c                	jle    800e41 <vprintfmt+0x105>
  800e35:	83 fb 39             	cmp    $0x39,%ebx
  800e38:	7f 07                	jg     800e41 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e3f:	eb d1                	jmp    800e12 <vprintfmt+0xd6>
			goto process_precision;
  800e41:	eb 58                	jmp    800e9b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e46:	83 f8 30             	cmp    $0x30,%eax
  800e49:	73 17                	jae    800e62 <vprintfmt+0x126>
  800e4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e52:	89 c0                	mov    %eax,%eax
  800e54:	48 01 d0             	add    %rdx,%rax
  800e57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5a:	83 c2 08             	add    $0x8,%edx
  800e5d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e60:	eb 0f                	jmp    800e71 <vprintfmt+0x135>
  800e62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e66:	48 89 d0             	mov    %rdx,%rax
  800e69:	48 83 c2 08          	add    $0x8,%rdx
  800e6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e71:	8b 00                	mov    (%rax),%eax
  800e73:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e76:	eb 23                	jmp    800e9b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7c:	79 0c                	jns    800e8a <vprintfmt+0x14e>
				width = 0;
  800e7e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e85:	e9 3b ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>
  800e8a:	e9 36 ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e8f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e96:	e9 2a ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800e9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9f:	79 12                	jns    800eb3 <vprintfmt+0x177>
				width = precision, precision = -1;
  800ea1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ea7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800eae:	e9 12 ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>
  800eb3:	e9 0d ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eb8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ebc:	e9 04 ff ff ff       	jmpq   800dc5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ec1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec4:	83 f8 30             	cmp    $0x30,%eax
  800ec7:	73 17                	jae    800ee0 <vprintfmt+0x1a4>
  800ec9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ecd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed0:	89 c0                	mov    %eax,%eax
  800ed2:	48 01 d0             	add    %rdx,%rax
  800ed5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ed8:	83 c2 08             	add    $0x8,%edx
  800edb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ede:	eb 0f                	jmp    800eef <vprintfmt+0x1b3>
  800ee0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ee4:	48 89 d0             	mov    %rdx,%rax
  800ee7:	48 83 c2 08          	add    $0x8,%rdx
  800eeb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eef:	8b 10                	mov    (%rax),%edx
  800ef1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ef5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef9:	48 89 ce             	mov    %rcx,%rsi
  800efc:	89 d7                	mov    %edx,%edi
  800efe:	ff d0                	callq  *%rax
			break;
  800f00:	e9 40 03 00 00       	jmpq   801245 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f08:	83 f8 30             	cmp    $0x30,%eax
  800f0b:	73 17                	jae    800f24 <vprintfmt+0x1e8>
  800f0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f14:	89 c0                	mov    %eax,%eax
  800f16:	48 01 d0             	add    %rdx,%rax
  800f19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f1c:	83 c2 08             	add    $0x8,%edx
  800f1f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f22:	eb 0f                	jmp    800f33 <vprintfmt+0x1f7>
  800f24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f28:	48 89 d0             	mov    %rdx,%rax
  800f2b:	48 83 c2 08          	add    $0x8,%rdx
  800f2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f33:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f35:	85 db                	test   %ebx,%ebx
  800f37:	79 02                	jns    800f3b <vprintfmt+0x1ff>
				err = -err;
  800f39:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f3b:	83 fb 15             	cmp    $0x15,%ebx
  800f3e:	7f 16                	jg     800f56 <vprintfmt+0x21a>
  800f40:	48 b8 e0 4b 80 00 00 	movabs $0x804be0,%rax
  800f47:	00 00 00 
  800f4a:	48 63 d3             	movslq %ebx,%rdx
  800f4d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f51:	4d 85 e4             	test   %r12,%r12
  800f54:	75 2e                	jne    800f84 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5e:	89 d9                	mov    %ebx,%ecx
  800f60:	48 ba a1 4c 80 00 00 	movabs $0x804ca1,%rdx
  800f67:	00 00 00 
  800f6a:	48 89 c7             	mov    %rax,%rdi
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f72:	49 b8 54 12 80 00 00 	movabs $0x801254,%r8
  800f79:	00 00 00 
  800f7c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f7f:	e9 c1 02 00 00       	jmpq   801245 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8c:	4c 89 e1             	mov    %r12,%rcx
  800f8f:	48 ba aa 4c 80 00 00 	movabs $0x804caa,%rdx
  800f96:	00 00 00 
  800f99:	48 89 c7             	mov    %rax,%rdi
  800f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa1:	49 b8 54 12 80 00 00 	movabs $0x801254,%r8
  800fa8:	00 00 00 
  800fab:	41 ff d0             	callq  *%r8
			break;
  800fae:	e9 92 02 00 00       	jmpq   801245 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb6:	83 f8 30             	cmp    $0x30,%eax
  800fb9:	73 17                	jae    800fd2 <vprintfmt+0x296>
  800fbb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc2:	89 c0                	mov    %eax,%eax
  800fc4:	48 01 d0             	add    %rdx,%rax
  800fc7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fca:	83 c2 08             	add    $0x8,%edx
  800fcd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fd0:	eb 0f                	jmp    800fe1 <vprintfmt+0x2a5>
  800fd2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fd6:	48 89 d0             	mov    %rdx,%rax
  800fd9:	48 83 c2 08          	add    $0x8,%rdx
  800fdd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fe1:	4c 8b 20             	mov    (%rax),%r12
  800fe4:	4d 85 e4             	test   %r12,%r12
  800fe7:	75 0a                	jne    800ff3 <vprintfmt+0x2b7>
				p = "(null)";
  800fe9:	49 bc ad 4c 80 00 00 	movabs $0x804cad,%r12
  800ff0:	00 00 00 
			if (width > 0 && padc != '-')
  800ff3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ff7:	7e 3f                	jle    801038 <vprintfmt+0x2fc>
  800ff9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ffd:	74 39                	je     801038 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801002:	48 98                	cltq   
  801004:	48 89 c6             	mov    %rax,%rsi
  801007:	4c 89 e7             	mov    %r12,%rdi
  80100a:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  801011:	00 00 00 
  801014:	ff d0                	callq  *%rax
  801016:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801019:	eb 17                	jmp    801032 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80101b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80101f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801023:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801027:	48 89 ce             	mov    %rcx,%rsi
  80102a:	89 d7                	mov    %edx,%edi
  80102c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80102e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801032:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801036:	7f e3                	jg     80101b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801038:	eb 37                	jmp    801071 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80103a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80103e:	74 1e                	je     80105e <vprintfmt+0x322>
  801040:	83 fb 1f             	cmp    $0x1f,%ebx
  801043:	7e 05                	jle    80104a <vprintfmt+0x30e>
  801045:	83 fb 7e             	cmp    $0x7e,%ebx
  801048:	7e 14                	jle    80105e <vprintfmt+0x322>
					putch('?', putdat);
  80104a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801052:	48 89 d6             	mov    %rdx,%rsi
  801055:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80105a:	ff d0                	callq  *%rax
  80105c:	eb 0f                	jmp    80106d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80105e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801062:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801066:	48 89 d6             	mov    %rdx,%rsi
  801069:	89 df                	mov    %ebx,%edi
  80106b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80106d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801071:	4c 89 e0             	mov    %r12,%rax
  801074:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801078:	0f b6 00             	movzbl (%rax),%eax
  80107b:	0f be d8             	movsbl %al,%ebx
  80107e:	85 db                	test   %ebx,%ebx
  801080:	74 10                	je     801092 <vprintfmt+0x356>
  801082:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801086:	78 b2                	js     80103a <vprintfmt+0x2fe>
  801088:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80108c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801090:	79 a8                	jns    80103a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801092:	eb 16                	jmp    8010aa <vprintfmt+0x36e>
				putch(' ', putdat);
  801094:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801098:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80109c:	48 89 d6             	mov    %rdx,%rsi
  80109f:	bf 20 00 00 00       	mov    $0x20,%edi
  8010a4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010a6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010ae:	7f e4                	jg     801094 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010b0:	e9 90 01 00 00       	jmpq   801245 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010b9:	be 03 00 00 00       	mov    $0x3,%esi
  8010be:	48 89 c7             	mov    %rax,%rdi
  8010c1:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  8010c8:	00 00 00 
  8010cb:	ff d0                	callq  *%rax
  8010cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d5:	48 85 c0             	test   %rax,%rax
  8010d8:	79 1d                	jns    8010f7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8010da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e2:	48 89 d6             	mov    %rdx,%rsi
  8010e5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010ea:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 f7 d8             	neg    %rax
  8010f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8010f7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010fe:	e9 d5 00 00 00       	jmpq   8011d8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801103:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801107:	be 03 00 00 00       	mov    $0x3,%esi
  80110c:	48 89 c7             	mov    %rax,%rdi
  80110f:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801116:	00 00 00 
  801119:	ff d0                	callq  *%rax
  80111b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80111f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801126:	e9 ad 00 00 00       	jmpq   8011d8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80112b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80112e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801132:	89 d6                	mov    %edx,%esi
  801134:	48 89 c7             	mov    %rax,%rdi
  801137:	48 b8 2c 0c 80 00 00 	movabs $0x800c2c,%rax
  80113e:	00 00 00 
  801141:	ff d0                	callq  *%rax
  801143:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801147:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80114e:	e9 85 00 00 00       	jmpq   8011d8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801153:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801157:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80115b:	48 89 d6             	mov    %rdx,%rsi
  80115e:	bf 30 00 00 00       	mov    $0x30,%edi
  801163:	ff d0                	callq  *%rax
			putch('x', putdat);
  801165:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801169:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80116d:	48 89 d6             	mov    %rdx,%rsi
  801170:	bf 78 00 00 00       	mov    $0x78,%edi
  801175:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801177:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80117a:	83 f8 30             	cmp    $0x30,%eax
  80117d:	73 17                	jae    801196 <vprintfmt+0x45a>
  80117f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801183:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801186:	89 c0                	mov    %eax,%eax
  801188:	48 01 d0             	add    %rdx,%rax
  80118b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80118e:	83 c2 08             	add    $0x8,%edx
  801191:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801194:	eb 0f                	jmp    8011a5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801196:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80119a:	48 89 d0             	mov    %rdx,%rax
  80119d:	48 83 c2 08          	add    $0x8,%rdx
  8011a1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011a5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011ac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011b3:	eb 23                	jmp    8011d8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011b9:	be 03 00 00 00       	mov    $0x3,%esi
  8011be:	48 89 c7             	mov    %rax,%rdi
  8011c1:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  8011c8:	00 00 00 
  8011cb:	ff d0                	callq  *%rax
  8011cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011d1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011d8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8011dd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011e0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ef:	45 89 c1             	mov    %r8d,%r9d
  8011f2:	41 89 f8             	mov    %edi,%r8d
  8011f5:	48 89 c7             	mov    %rax,%rdi
  8011f8:	48 b8 61 0a 80 00 00 	movabs $0x800a61,%rax
  8011ff:	00 00 00 
  801202:	ff d0                	callq  *%rax
			break;
  801204:	eb 3f                	jmp    801245 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801206:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80120a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80120e:	48 89 d6             	mov    %rdx,%rsi
  801211:	89 df                	mov    %ebx,%edi
  801213:	ff d0                	callq  *%rax
			break;
  801215:	eb 2e                	jmp    801245 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801217:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80121f:	48 89 d6             	mov    %rdx,%rsi
  801222:	bf 25 00 00 00       	mov    $0x25,%edi
  801227:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801229:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80122e:	eb 05                	jmp    801235 <vprintfmt+0x4f9>
  801230:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801235:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801239:	48 83 e8 01          	sub    $0x1,%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	3c 25                	cmp    $0x25,%al
  801242:	75 ec                	jne    801230 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801244:	90                   	nop
		}
	}
  801245:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801246:	e9 43 fb ff ff       	jmpq   800d8e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80124b:	48 83 c4 60          	add    $0x60,%rsp
  80124f:	5b                   	pop    %rbx
  801250:	41 5c                	pop    %r12
  801252:	5d                   	pop    %rbp
  801253:	c3                   	retq   

0000000000801254 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801254:	55                   	push   %rbp
  801255:	48 89 e5             	mov    %rsp,%rbp
  801258:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80125f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801266:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80126d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801274:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80127b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801282:	84 c0                	test   %al,%al
  801284:	74 20                	je     8012a6 <printfmt+0x52>
  801286:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80128a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80128e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801292:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801296:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80129a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80129e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012a2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012a6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012ad:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012b4:	00 00 00 
  8012b7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012be:	00 00 00 
  8012c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012c5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012cc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012d3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012da:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012e1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012e8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012ef:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012f6:	48 89 c7             	mov    %rax,%rdi
  8012f9:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  801300:	00 00 00 
  801303:	ff d0                	callq  *%rax
	va_end(ap);
}
  801305:	c9                   	leaveq 
  801306:	c3                   	retq   

0000000000801307 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	48 83 ec 10          	sub    $0x10,%rsp
  80130f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801312:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131a:	8b 40 10             	mov    0x10(%rax),%eax
  80131d:	8d 50 01             	lea    0x1(%rax),%edx
  801320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801324:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132b:	48 8b 10             	mov    (%rax),%rdx
  80132e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801332:	48 8b 40 08          	mov    0x8(%rax),%rax
  801336:	48 39 c2             	cmp    %rax,%rdx
  801339:	73 17                	jae    801352 <sprintputch+0x4b>
		*b->buf++ = ch;
  80133b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133f:	48 8b 00             	mov    (%rax),%rax
  801342:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801346:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80134a:	48 89 0a             	mov    %rcx,(%rdx)
  80134d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801350:	88 10                	mov    %dl,(%rax)
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 50          	sub    $0x50,%rsp
  80135c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801360:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801363:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801367:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80136b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80136f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801373:	48 8b 0a             	mov    (%rdx),%rcx
  801376:	48 89 08             	mov    %rcx,(%rax)
  801379:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80137d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801381:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801385:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801389:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80138d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801391:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801394:	48 98                	cltq   
  801396:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80139a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80139e:	48 01 d0             	add    %rdx,%rax
  8013a1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013ac:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013b1:	74 06                	je     8013b9 <vsnprintf+0x65>
  8013b3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013b7:	7f 07                	jg     8013c0 <vsnprintf+0x6c>
		return -E_INVAL;
  8013b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013be:	eb 2f                	jmp    8013ef <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013c0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013c4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013c8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013cc:	48 89 c6             	mov    %rax,%rsi
  8013cf:	48 bf 07 13 80 00 00 	movabs $0x801307,%rdi
  8013d6:	00 00 00 
  8013d9:	48 b8 3c 0d 80 00 00 	movabs $0x800d3c,%rax
  8013e0:	00 00 00 
  8013e3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013e9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013fc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801403:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801409:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801410:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801417:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80141e:	84 c0                	test   %al,%al
  801420:	74 20                	je     801442 <snprintf+0x51>
  801422:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801426:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80142a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80142e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801432:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801436:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80143a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80143e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801442:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801449:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801450:	00 00 00 
  801453:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80145a:	00 00 00 
  80145d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801461:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801468:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80146f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801476:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80147d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801484:	48 8b 0a             	mov    (%rdx),%rcx
  801487:	48 89 08             	mov    %rcx,(%rax)
  80148a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80148e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801492:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801496:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80149a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014a1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014a8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014ae:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014b5:	48 89 c7             	mov    %rax,%rdi
  8014b8:	48 b8 54 13 80 00 00 	movabs $0x801354,%rax
  8014bf:	00 00 00 
  8014c2:	ff d0                	callq  *%rax
  8014c4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014ca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014d0:	c9                   	leaveq 
  8014d1:	c3                   	retq   

00000000008014d2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014d2:	55                   	push   %rbp
  8014d3:	48 89 e5             	mov    %rsp,%rbp
  8014d6:	48 83 ec 18          	sub    $0x18,%rsp
  8014da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014e5:	eb 09                	jmp    8014f0 <strlen+0x1e>
		n++;
  8014e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	84 c0                	test   %al,%al
  8014f9:	75 ec                	jne    8014e7 <strlen+0x15>
		n++;
	return n;
  8014fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014fe:	c9                   	leaveq 
  8014ff:	c3                   	retq   

0000000000801500 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	48 83 ec 20          	sub    $0x20,%rsp
  801508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801510:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801517:	eb 0e                	jmp    801527 <strnlen+0x27>
		n++;
  801519:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80151d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801522:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801527:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80152c:	74 0b                	je     801539 <strnlen+0x39>
  80152e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	84 c0                	test   %al,%al
  801537:	75 e0                	jne    801519 <strnlen+0x19>
		n++;
	return n;
  801539:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80153c:	c9                   	leaveq 
  80153d:	c3                   	retq   

000000000080153e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80153e:	55                   	push   %rbp
  80153f:	48 89 e5             	mov    %rsp,%rbp
  801542:	48 83 ec 20          	sub    $0x20,%rsp
  801546:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80154e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801556:	90                   	nop
  801557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80155f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801563:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801567:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80156b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80156f:	0f b6 12             	movzbl (%rdx),%edx
  801572:	88 10                	mov    %dl,(%rax)
  801574:	0f b6 00             	movzbl (%rax),%eax
  801577:	84 c0                	test   %al,%al
  801579:	75 dc                	jne    801557 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 83 ec 20          	sub    $0x20,%rsp
  801589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801595:	48 89 c7             	mov    %rax,%rdi
  801598:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  80159f:	00 00 00 
  8015a2:	ff d0                	callq  *%rax
  8015a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015aa:	48 63 d0             	movslq %eax,%rdx
  8015ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b1:	48 01 c2             	add    %rax,%rdx
  8015b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015b8:	48 89 c6             	mov    %rax,%rsi
  8015bb:	48 89 d7             	mov    %rdx,%rdi
  8015be:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	callq  *%rax
	return dst;
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ce:	c9                   	leaveq 
  8015cf:	c3                   	retq   

00000000008015d0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015d0:	55                   	push   %rbp
  8015d1:	48 89 e5             	mov    %rsp,%rbp
  8015d4:	48 83 ec 28          	sub    $0x28,%rsp
  8015d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8015ec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015f3:	00 
  8015f4:	eb 2a                	jmp    801620 <strncpy+0x50>
		*dst++ = *src;
  8015f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801602:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801606:	0f b6 12             	movzbl (%rdx),%edx
  801609:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80160b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160f:	0f b6 00             	movzbl (%rax),%eax
  801612:	84 c0                	test   %al,%al
  801614:	74 05                	je     80161b <strncpy+0x4b>
			src++;
  801616:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80161b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801628:	72 cc                	jb     8015f6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80162e:	c9                   	leaveq 
  80162f:	c3                   	retq   

0000000000801630 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
  801634:	48 83 ec 28          	sub    $0x28,%rsp
  801638:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80163c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801640:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801648:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80164c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801651:	74 3d                	je     801690 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801653:	eb 1d                	jmp    801672 <strlcpy+0x42>
			*dst++ = *src++;
  801655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801659:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80165d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801661:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801665:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801669:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80166d:	0f b6 12             	movzbl (%rdx),%edx
  801670:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801672:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801677:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80167c:	74 0b                	je     801689 <strlcpy+0x59>
  80167e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	84 c0                	test   %al,%al
  801687:	75 cc                	jne    801655 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801690:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801698:	48 29 c2             	sub    %rax,%rdx
  80169b:	48 89 d0             	mov    %rdx,%rax
}
  80169e:	c9                   	leaveq 
  80169f:	c3                   	retq   

00000000008016a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a0:	55                   	push   %rbp
  8016a1:	48 89 e5             	mov    %rsp,%rbp
  8016a4:	48 83 ec 10          	sub    $0x10,%rsp
  8016a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016b0:	eb 0a                	jmp    8016bc <strcmp+0x1c>
		p++, q++;
  8016b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	84 c0                	test   %al,%al
  8016c5:	74 12                	je     8016d9 <strcmp+0x39>
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	0f b6 10             	movzbl (%rax),%edx
  8016ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	38 c2                	cmp    %al,%dl
  8016d7:	74 d9                	je     8016b2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	0f b6 d0             	movzbl %al,%edx
  8016e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e7:	0f b6 00             	movzbl (%rax),%eax
  8016ea:	0f b6 c0             	movzbl %al,%eax
  8016ed:	29 c2                	sub    %eax,%edx
  8016ef:	89 d0                	mov    %edx,%eax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 18          	sub    $0x18,%rsp
  8016fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801703:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801707:	eb 0f                	jmp    801718 <strncmp+0x25>
		n--, p++, q++;
  801709:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80170e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801713:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801718:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80171d:	74 1d                	je     80173c <strncmp+0x49>
  80171f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801723:	0f b6 00             	movzbl (%rax),%eax
  801726:	84 c0                	test   %al,%al
  801728:	74 12                	je     80173c <strncmp+0x49>
  80172a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172e:	0f b6 10             	movzbl (%rax),%edx
  801731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	38 c2                	cmp    %al,%dl
  80173a:	74 cd                	je     801709 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80173c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801741:	75 07                	jne    80174a <strncmp+0x57>
		return 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	eb 18                	jmp    801762 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80174a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	0f b6 d0             	movzbl %al,%edx
  801754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801758:	0f b6 00             	movzbl (%rax),%eax
  80175b:	0f b6 c0             	movzbl %al,%eax
  80175e:	29 c2                	sub    %eax,%edx
  801760:	89 d0                	mov    %edx,%eax
}
  801762:	c9                   	leaveq 
  801763:	c3                   	retq   

0000000000801764 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	48 83 ec 0c          	sub    $0xc,%rsp
  80176c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801770:	89 f0                	mov    %esi,%eax
  801772:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801775:	eb 17                	jmp    80178e <strchr+0x2a>
		if (*s == c)
  801777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801781:	75 06                	jne    801789 <strchr+0x25>
			return (char *) s;
  801783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801787:	eb 15                	jmp    80179e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801789:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80178e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	84 c0                	test   %al,%al
  801797:	75 de                	jne    801777 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179e:	c9                   	leaveq 
  80179f:	c3                   	retq   

00000000008017a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a0:	55                   	push   %rbp
  8017a1:	48 89 e5             	mov    %rsp,%rbp
  8017a4:	48 83 ec 0c          	sub    $0xc,%rsp
  8017a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ac:	89 f0                	mov    %esi,%eax
  8017ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017b1:	eb 13                	jmp    8017c6 <strfind+0x26>
		if (*s == c)
  8017b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017bd:	75 02                	jne    8017c1 <strfind+0x21>
			break;
  8017bf:	eb 10                	jmp    8017d1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	84 c0                	test   %al,%al
  8017cf:	75 e2                	jne    8017b3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017d5:	c9                   	leaveq 
  8017d6:	c3                   	retq   

00000000008017d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017d7:	55                   	push   %rbp
  8017d8:	48 89 e5             	mov    %rsp,%rbp
  8017db:	48 83 ec 18          	sub    $0x18,%rsp
  8017df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8017e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8017ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ef:	75 06                	jne    8017f7 <memset+0x20>
		return v;
  8017f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f5:	eb 69                	jmp    801860 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8017f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fb:	83 e0 03             	and    $0x3,%eax
  8017fe:	48 85 c0             	test   %rax,%rax
  801801:	75 48                	jne    80184b <memset+0x74>
  801803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801807:	83 e0 03             	and    $0x3,%eax
  80180a:	48 85 c0             	test   %rax,%rax
  80180d:	75 3c                	jne    80184b <memset+0x74>
		c &= 0xFF;
  80180f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801816:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801819:	c1 e0 18             	shl    $0x18,%eax
  80181c:	89 c2                	mov    %eax,%edx
  80181e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801821:	c1 e0 10             	shl    $0x10,%eax
  801824:	09 c2                	or     %eax,%edx
  801826:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801829:	c1 e0 08             	shl    $0x8,%eax
  80182c:	09 d0                	or     %edx,%eax
  80182e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801835:	48 c1 e8 02          	shr    $0x2,%rax
  801839:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80183c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801840:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801843:	48 89 d7             	mov    %rdx,%rdi
  801846:	fc                   	cld    
  801847:	f3 ab                	rep stos %eax,%es:(%rdi)
  801849:	eb 11                	jmp    80185c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80184b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801852:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801856:	48 89 d7             	mov    %rdx,%rdi
  801859:	fc                   	cld    
  80185a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80185c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801860:	c9                   	leaveq 
  801861:	c3                   	retq   

0000000000801862 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801862:	55                   	push   %rbp
  801863:	48 89 e5             	mov    %rsp,%rbp
  801866:	48 83 ec 28          	sub    $0x28,%rsp
  80186a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80186e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801872:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801876:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80187a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80187e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801882:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80188e:	0f 83 88 00 00 00    	jae    80191c <memmove+0xba>
  801894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801898:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80189c:	48 01 d0             	add    %rdx,%rax
  80189f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018a3:	76 77                	jbe    80191c <memmove+0xba>
		s += n;
  8018a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b9:	83 e0 03             	and    $0x3,%eax
  8018bc:	48 85 c0             	test   %rax,%rax
  8018bf:	75 3b                	jne    8018fc <memmove+0x9a>
  8018c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c5:	83 e0 03             	and    $0x3,%eax
  8018c8:	48 85 c0             	test   %rax,%rax
  8018cb:	75 2f                	jne    8018fc <memmove+0x9a>
  8018cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d1:	83 e0 03             	and    $0x3,%eax
  8018d4:	48 85 c0             	test   %rax,%rax
  8018d7:	75 23                	jne    8018fc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018dd:	48 83 e8 04          	sub    $0x4,%rax
  8018e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e5:	48 83 ea 04          	sub    $0x4,%rdx
  8018e9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018ed:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8018f1:	48 89 c7             	mov    %rax,%rdi
  8018f4:	48 89 d6             	mov    %rdx,%rsi
  8018f7:	fd                   	std    
  8018f8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018fa:	eb 1d                	jmp    801919 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801900:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801904:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801908:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	48 89 d7             	mov    %rdx,%rdi
  801913:	48 89 c1             	mov    %rax,%rcx
  801916:	fd                   	std    
  801917:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801919:	fc                   	cld    
  80191a:	eb 57                	jmp    801973 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80191c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801920:	83 e0 03             	and    $0x3,%eax
  801923:	48 85 c0             	test   %rax,%rax
  801926:	75 36                	jne    80195e <memmove+0xfc>
  801928:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192c:	83 e0 03             	and    $0x3,%eax
  80192f:	48 85 c0             	test   %rax,%rax
  801932:	75 2a                	jne    80195e <memmove+0xfc>
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	83 e0 03             	and    $0x3,%eax
  80193b:	48 85 c0             	test   %rax,%rax
  80193e:	75 1e                	jne    80195e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	48 c1 e8 02          	shr    $0x2,%rax
  801948:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80194b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801953:	48 89 c7             	mov    %rax,%rdi
  801956:	48 89 d6             	mov    %rdx,%rsi
  801959:	fc                   	cld    
  80195a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80195c:	eb 15                	jmp    801973 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80195e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801962:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801966:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80196a:	48 89 c7             	mov    %rax,%rdi
  80196d:	48 89 d6             	mov    %rdx,%rsi
  801970:	fc                   	cld    
  801971:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801977:	c9                   	leaveq 
  801978:	c3                   	retq   

0000000000801979 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801979:	55                   	push   %rbp
  80197a:	48 89 e5             	mov    %rsp,%rbp
  80197d:	48 83 ec 18          	sub    $0x18,%rsp
  801981:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801985:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801989:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80198d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801991:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801995:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801999:	48 89 ce             	mov    %rcx,%rsi
  80199c:	48 89 c7             	mov    %rax,%rdi
  80199f:	48 b8 62 18 80 00 00 	movabs $0x801862,%rax
  8019a6:	00 00 00 
  8019a9:	ff d0                	callq  *%rax
}
  8019ab:	c9                   	leaveq 
  8019ac:	c3                   	retq   

00000000008019ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019ad:	55                   	push   %rbp
  8019ae:	48 89 e5             	mov    %rsp,%rbp
  8019b1:	48 83 ec 28          	sub    $0x28,%rsp
  8019b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019d1:	eb 36                	jmp    801a09 <memcmp+0x5c>
		if (*s1 != *s2)
  8019d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d7:	0f b6 10             	movzbl (%rax),%edx
  8019da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019de:	0f b6 00             	movzbl (%rax),%eax
  8019e1:	38 c2                	cmp    %al,%dl
  8019e3:	74 1a                	je     8019ff <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8019e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	0f b6 d0             	movzbl %al,%edx
  8019ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	0f b6 c0             	movzbl %al,%eax
  8019f9:	29 c2                	sub    %eax,%edx
  8019fb:	89 d0                	mov    %edx,%eax
  8019fd:	eb 20                	jmp    801a1f <memcmp+0x72>
		s1++, s2++;
  8019ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a04:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a11:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a15:	48 85 c0             	test   %rax,%rax
  801a18:	75 b9                	jne    8019d3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1f:	c9                   	leaveq 
  801a20:	c3                   	retq   

0000000000801a21 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a21:	55                   	push   %rbp
  801a22:	48 89 e5             	mov    %rsp,%rbp
  801a25:	48 83 ec 28          	sub    $0x28,%rsp
  801a29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a2d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a3c:	48 01 d0             	add    %rdx,%rax
  801a3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a43:	eb 15                	jmp    801a5a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a49:	0f b6 10             	movzbl (%rax),%edx
  801a4c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a4f:	38 c2                	cmp    %al,%dl
  801a51:	75 02                	jne    801a55 <memfind+0x34>
			break;
  801a53:	eb 0f                	jmp    801a64 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a55:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a5e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a62:	72 e1                	jb     801a45 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	48 83 ec 34          	sub    $0x34,%rsp
  801a72:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a7a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a84:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a8b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a8c:	eb 05                	jmp    801a93 <strtol+0x29>
		s++;
  801a8e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a97:	0f b6 00             	movzbl (%rax),%eax
  801a9a:	3c 20                	cmp    $0x20,%al
  801a9c:	74 f0                	je     801a8e <strtol+0x24>
  801a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa2:	0f b6 00             	movzbl (%rax),%eax
  801aa5:	3c 09                	cmp    $0x9,%al
  801aa7:	74 e5                	je     801a8e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801aa9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aad:	0f b6 00             	movzbl (%rax),%eax
  801ab0:	3c 2b                	cmp    $0x2b,%al
  801ab2:	75 07                	jne    801abb <strtol+0x51>
		s++;
  801ab4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ab9:	eb 17                	jmp    801ad2 <strtol+0x68>
	else if (*s == '-')
  801abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abf:	0f b6 00             	movzbl (%rax),%eax
  801ac2:	3c 2d                	cmp    $0x2d,%al
  801ac4:	75 0c                	jne    801ad2 <strtol+0x68>
		s++, neg = 1;
  801ac6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801acb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ad6:	74 06                	je     801ade <strtol+0x74>
  801ad8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801adc:	75 28                	jne    801b06 <strtol+0x9c>
  801ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae2:	0f b6 00             	movzbl (%rax),%eax
  801ae5:	3c 30                	cmp    $0x30,%al
  801ae7:	75 1d                	jne    801b06 <strtol+0x9c>
  801ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aed:	48 83 c0 01          	add    $0x1,%rax
  801af1:	0f b6 00             	movzbl (%rax),%eax
  801af4:	3c 78                	cmp    $0x78,%al
  801af6:	75 0e                	jne    801b06 <strtol+0x9c>
		s += 2, base = 16;
  801af8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801afd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b04:	eb 2c                	jmp    801b32 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b06:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b0a:	75 19                	jne    801b25 <strtol+0xbb>
  801b0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b10:	0f b6 00             	movzbl (%rax),%eax
  801b13:	3c 30                	cmp    $0x30,%al
  801b15:	75 0e                	jne    801b25 <strtol+0xbb>
		s++, base = 8;
  801b17:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b1c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b23:	eb 0d                	jmp    801b32 <strtol+0xc8>
	else if (base == 0)
  801b25:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b29:	75 07                	jne    801b32 <strtol+0xc8>
		base = 10;
  801b2b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b36:	0f b6 00             	movzbl (%rax),%eax
  801b39:	3c 2f                	cmp    $0x2f,%al
  801b3b:	7e 1d                	jle    801b5a <strtol+0xf0>
  801b3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b41:	0f b6 00             	movzbl (%rax),%eax
  801b44:	3c 39                	cmp    $0x39,%al
  801b46:	7f 12                	jg     801b5a <strtol+0xf0>
			dig = *s - '0';
  801b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	0f be c0             	movsbl %al,%eax
  801b52:	83 e8 30             	sub    $0x30,%eax
  801b55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b58:	eb 4e                	jmp    801ba8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	3c 60                	cmp    $0x60,%al
  801b63:	7e 1d                	jle    801b82 <strtol+0x118>
  801b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b69:	0f b6 00             	movzbl (%rax),%eax
  801b6c:	3c 7a                	cmp    $0x7a,%al
  801b6e:	7f 12                	jg     801b82 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b74:	0f b6 00             	movzbl (%rax),%eax
  801b77:	0f be c0             	movsbl %al,%eax
  801b7a:	83 e8 57             	sub    $0x57,%eax
  801b7d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b80:	eb 26                	jmp    801ba8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b86:	0f b6 00             	movzbl (%rax),%eax
  801b89:	3c 40                	cmp    $0x40,%al
  801b8b:	7e 48                	jle    801bd5 <strtol+0x16b>
  801b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b91:	0f b6 00             	movzbl (%rax),%eax
  801b94:	3c 5a                	cmp    $0x5a,%al
  801b96:	7f 3d                	jg     801bd5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9c:	0f b6 00             	movzbl (%rax),%eax
  801b9f:	0f be c0             	movsbl %al,%eax
  801ba2:	83 e8 37             	sub    $0x37,%eax
  801ba5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bab:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bae:	7c 02                	jl     801bb2 <strtol+0x148>
			break;
  801bb0:	eb 23                	jmp    801bd5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801bb2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bb7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bba:	48 98                	cltq   
  801bbc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801bc1:	48 89 c2             	mov    %rax,%rdx
  801bc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bc7:	48 98                	cltq   
  801bc9:	48 01 d0             	add    %rdx,%rax
  801bcc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bd0:	e9 5d ff ff ff       	jmpq   801b32 <strtol+0xc8>

	if (endptr)
  801bd5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bda:	74 0b                	je     801be7 <strtol+0x17d>
		*endptr = (char *) s;
  801bdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801be0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801be4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801be7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801beb:	74 09                	je     801bf6 <strtol+0x18c>
  801bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bf1:	48 f7 d8             	neg    %rax
  801bf4:	eb 04                	jmp    801bfa <strtol+0x190>
  801bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bfa:	c9                   	leaveq 
  801bfb:	c3                   	retq   

0000000000801bfc <strstr>:

char * strstr(const char *in, const char *str)
{
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	48 83 ec 30          	sub    $0x30,%rsp
  801c04:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c08:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c10:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c14:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c18:	0f b6 00             	movzbl (%rax),%eax
  801c1b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c1e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c22:	75 06                	jne    801c2a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c28:	eb 6b                	jmp    801c95 <strstr+0x99>

	len = strlen(str);
  801c2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c2e:	48 89 c7             	mov    %rax,%rdi
  801c31:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
  801c3d:	48 98                	cltq   
  801c3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c4f:	0f b6 00             	movzbl (%rax),%eax
  801c52:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c55:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c59:	75 07                	jne    801c62 <strstr+0x66>
				return (char *) 0;
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	eb 33                	jmp    801c95 <strstr+0x99>
		} while (sc != c);
  801c62:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c66:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c69:	75 d8                	jne    801c43 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c77:	48 89 ce             	mov    %rcx,%rsi
  801c7a:	48 89 c7             	mov    %rax,%rdi
  801c7d:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  801c84:	00 00 00 
  801c87:	ff d0                	callq  *%rax
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	75 b6                	jne    801c43 <strstr+0x47>

	return (char *) (in - 1);
  801c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c91:	48 83 e8 01          	sub    $0x1,%rax
}
  801c95:	c9                   	leaveq 
  801c96:	c3                   	retq   

0000000000801c97 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c97:	55                   	push   %rbp
  801c98:	48 89 e5             	mov    %rsp,%rbp
  801c9b:	53                   	push   %rbx
  801c9c:	48 83 ec 48          	sub    $0x48,%rsp
  801ca0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ca3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ca6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801caa:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cae:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cb2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cb6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cb9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801cbd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801cc1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801cc5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801cc9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ccd:	4c 89 c3             	mov    %r8,%rbx
  801cd0:	cd 30                	int    $0x30
  801cd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801cd6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cda:	74 3e                	je     801d1a <syscall+0x83>
  801cdc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ce1:	7e 37                	jle    801d1a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ce3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ce7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cea:	49 89 d0             	mov    %rdx,%r8
  801ced:	89 c1                	mov    %eax,%ecx
  801cef:	48 ba 68 4f 80 00 00 	movabs $0x804f68,%rdx
  801cf6:	00 00 00 
  801cf9:	be 23 00 00 00       	mov    $0x23,%esi
  801cfe:	48 bf 85 4f 80 00 00 	movabs $0x804f85,%rdi
  801d05:	00 00 00 
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	49 b9 50 07 80 00 00 	movabs $0x800750,%r9
  801d14:	00 00 00 
  801d17:	41 ff d1             	callq  *%r9

	return ret;
  801d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d1e:	48 83 c4 48          	add    $0x48,%rsp
  801d22:	5b                   	pop    %rbx
  801d23:	5d                   	pop    %rbp
  801d24:	c3                   	retq   

0000000000801d25 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d25:	55                   	push   %rbp
  801d26:	48 89 e5             	mov    %rsp,%rbp
  801d29:	48 83 ec 20          	sub    $0x20,%rsp
  801d2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d44:	00 
  801d45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d51:	48 89 d1             	mov    %rdx,%rcx
  801d54:	48 89 c2             	mov    %rax,%rdx
  801d57:	be 00 00 00 00       	mov    $0x0,%esi
  801d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d61:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801d68:	00 00 00 
  801d6b:	ff d0                	callq  *%rax
}
  801d6d:	c9                   	leaveq 
  801d6e:	c3                   	retq   

0000000000801d6f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d6f:	55                   	push   %rbp
  801d70:	48 89 e5             	mov    %rsp,%rbp
  801d73:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7e:	00 
  801d7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d90:	ba 00 00 00 00       	mov    $0x0,%edx
  801d95:	be 00 00 00 00       	mov    $0x0,%esi
  801d9a:	bf 01 00 00 00       	mov    $0x1,%edi
  801d9f:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 10          	sub    $0x10,%rsp
  801db5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	48 98                	cltq   
  801dbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc4:	00 
  801dc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd6:	48 89 c2             	mov    %rax,%rdx
  801dd9:	be 01 00 00 00       	mov    $0x1,%esi
  801dde:	bf 03 00 00 00       	mov    $0x3,%edi
  801de3:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801dea:	00 00 00 
  801ded:	ff d0                	callq  *%rax
}
  801def:	c9                   	leaveq 
  801df0:	c3                   	retq   

0000000000801df1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801df1:	55                   	push   %rbp
  801df2:	48 89 e5             	mov    %rsp,%rbp
  801df5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801df9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e00:	00 
  801e01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	be 00 00 00 00       	mov    $0x0,%esi
  801e1c:	bf 02 00 00 00       	mov    $0x2,%edi
  801e21:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	callq  *%rax
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <sys_yield>:

void
sys_yield(void)
{
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e3e:	00 
  801e3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e50:	ba 00 00 00 00       	mov    $0x0,%edx
  801e55:	be 00 00 00 00       	mov    $0x0,%esi
  801e5a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e5f:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	callq  *%rax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 20          	sub    $0x20,%rsp
  801e75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e82:	48 63 c8             	movslq %eax,%rcx
  801e85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8c:	48 98                	cltq   
  801e8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e95:	00 
  801e96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9c:	49 89 c8             	mov    %rcx,%r8
  801e9f:	48 89 d1             	mov    %rdx,%rcx
  801ea2:	48 89 c2             	mov    %rax,%rdx
  801ea5:	be 01 00 00 00       	mov    $0x1,%esi
  801eaa:	bf 04 00 00 00       	mov    $0x4,%edi
  801eaf:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	48 83 ec 30          	sub    $0x30,%rsp
  801ec5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ecc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ecf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ed3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ed7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801eda:	48 63 c8             	movslq %eax,%rcx
  801edd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ee1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ee4:	48 63 f0             	movslq %eax,%rsi
  801ee7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eee:	48 98                	cltq   
  801ef0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ef4:	49 89 f9             	mov    %rdi,%r9
  801ef7:	49 89 f0             	mov    %rsi,%r8
  801efa:	48 89 d1             	mov    %rdx,%rcx
  801efd:	48 89 c2             	mov    %rax,%rdx
  801f00:	be 01 00 00 00       	mov    $0x1,%esi
  801f05:	bf 05 00 00 00       	mov    $0x5,%edi
  801f0a:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
}
  801f16:	c9                   	leaveq 
  801f17:	c3                   	retq   

0000000000801f18 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f18:	55                   	push   %rbp
  801f19:	48 89 e5             	mov    %rsp,%rbp
  801f1c:	48 83 ec 20          	sub    $0x20,%rsp
  801f20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2e:	48 98                	cltq   
  801f30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f37:	00 
  801f38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f44:	48 89 d1             	mov    %rdx,%rcx
  801f47:	48 89 c2             	mov    %rax,%rdx
  801f4a:	be 01 00 00 00       	mov    $0x1,%esi
  801f4f:	bf 06 00 00 00       	mov    $0x6,%edi
  801f54:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
}
  801f60:	c9                   	leaveq 
  801f61:	c3                   	retq   

0000000000801f62 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f62:	55                   	push   %rbp
  801f63:	48 89 e5             	mov    %rsp,%rbp
  801f66:	48 83 ec 10          	sub    $0x10,%rsp
  801f6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f73:	48 63 d0             	movslq %eax,%rdx
  801f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f79:	48 98                	cltq   
  801f7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f82:	00 
  801f83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f8f:	48 89 d1             	mov    %rdx,%rcx
  801f92:	48 89 c2             	mov    %rax,%rdx
  801f95:	be 01 00 00 00       	mov    $0x1,%esi
  801f9a:	bf 08 00 00 00       	mov    $0x8,%edi
  801f9f:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	48 83 ec 20          	sub    $0x20,%rsp
  801fb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	48 98                	cltq   
  801fc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fcc:	00 
  801fcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd9:	48 89 d1             	mov    %rdx,%rcx
  801fdc:	48 89 c2             	mov    %rax,%rdx
  801fdf:	be 01 00 00 00       	mov    $0x1,%esi
  801fe4:	bf 09 00 00 00       	mov    $0x9,%edi
  801fe9:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
}
  801ff5:	c9                   	leaveq 
  801ff6:	c3                   	retq   

0000000000801ff7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ff7:	55                   	push   %rbp
  801ff8:	48 89 e5             	mov    %rsp,%rbp
  801ffb:	48 83 ec 20          	sub    $0x20,%rsp
  801fff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802002:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802006:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80200a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200d:	48 98                	cltq   
  80200f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802016:	00 
  802017:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802023:	48 89 d1             	mov    %rdx,%rcx
  802026:	48 89 c2             	mov    %rax,%rdx
  802029:	be 01 00 00 00       	mov    $0x1,%esi
  80202e:	bf 0a 00 00 00       	mov    $0xa,%edi
  802033:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
}
  80203f:	c9                   	leaveq 
  802040:	c3                   	retq   

0000000000802041 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802041:	55                   	push   %rbp
  802042:	48 89 e5             	mov    %rsp,%rbp
  802045:	48 83 ec 20          	sub    $0x20,%rsp
  802049:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80204c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802050:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802054:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802057:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205a:	48 63 f0             	movslq %eax,%rsi
  80205d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802064:	48 98                	cltq   
  802066:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80206a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802071:	00 
  802072:	49 89 f1             	mov    %rsi,%r9
  802075:	49 89 c8             	mov    %rcx,%r8
  802078:	48 89 d1             	mov    %rdx,%rcx
  80207b:	48 89 c2             	mov    %rax,%rdx
  80207e:	be 00 00 00 00       	mov    $0x0,%esi
  802083:	bf 0c 00 00 00       	mov    $0xc,%edi
  802088:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
}
  802094:	c9                   	leaveq 
  802095:	c3                   	retq   

0000000000802096 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802096:	55                   	push   %rbp
  802097:	48 89 e5             	mov    %rsp,%rbp
  80209a:	48 83 ec 10          	sub    $0x10,%rsp
  80209e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020ad:	00 
  8020ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020bf:	48 89 c2             	mov    %rax,%rdx
  8020c2:	be 01 00 00 00       	mov    $0x1,%esi
  8020c7:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020cc:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax
}
  8020d8:	c9                   	leaveq 
  8020d9:	c3                   	retq   

00000000008020da <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8020da:	55                   	push   %rbp
  8020db:	48 89 e5             	mov    %rsp,%rbp
  8020de:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e9:	00 
  8020ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802100:	be 00 00 00 00       	mov    $0x0,%esi
  802105:	bf 0e 00 00 00       	mov    $0xe,%edi
  80210a:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
}
  802116:	c9                   	leaveq 
  802117:	c3                   	retq   

0000000000802118 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802118:	55                   	push   %rbp
  802119:	48 89 e5             	mov    %rsp,%rbp
  80211c:	48 83 ec 30          	sub    $0x30,%rsp
  802120:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802123:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802127:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80212a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80212e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802132:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802135:	48 63 c8             	movslq %eax,%rcx
  802138:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80213c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80213f:	48 63 f0             	movslq %eax,%rsi
  802142:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802149:	48 98                	cltq   
  80214b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80214f:	49 89 f9             	mov    %rdi,%r9
  802152:	49 89 f0             	mov    %rsi,%r8
  802155:	48 89 d1             	mov    %rdx,%rcx
  802158:	48 89 c2             	mov    %rax,%rdx
  80215b:	be 00 00 00 00       	mov    $0x0,%esi
  802160:	bf 0f 00 00 00       	mov    $0xf,%edi
  802165:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802171:	c9                   	leaveq 
  802172:	c3                   	retq   

0000000000802173 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802173:	55                   	push   %rbp
  802174:	48 89 e5             	mov    %rsp,%rbp
  802177:	48 83 ec 20          	sub    $0x20,%rsp
  80217b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80217f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80218b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802192:	00 
  802193:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802199:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80219f:	48 89 d1             	mov    %rdx,%rcx
  8021a2:	48 89 c2             	mov    %rax,%rdx
  8021a5:	be 00 00 00 00       	mov    $0x0,%esi
  8021aa:	bf 10 00 00 00       	mov    $0x10,%edi
  8021af:	48 b8 97 1c 80 00 00 	movabs $0x801c97,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax
}
  8021bb:	c9                   	leaveq 
  8021bc:	c3                   	retq   

00000000008021bd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021bd:	55                   	push   %rbp
  8021be:	48 89 e5             	mov    %rsp,%rbp
  8021c1:	48 83 ec 08          	sub    $0x8,%rsp
  8021c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021cd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021d4:	ff ff ff 
  8021d7:	48 01 d0             	add    %rdx,%rax
  8021da:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021de:	c9                   	leaveq 
  8021df:	c3                   	retq   

00000000008021e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021e0:	55                   	push   %rbp
  8021e1:	48 89 e5             	mov    %rsp,%rbp
  8021e4:	48 83 ec 08          	sub    $0x8,%rsp
  8021e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f0:	48 89 c7             	mov    %rax,%rdi
  8021f3:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  8021fa:	00 00 00 
  8021fd:	ff d0                	callq  *%rax
  8021ff:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802205:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	48 83 ec 18          	sub    $0x18,%rsp
  802213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80221e:	eb 6b                	jmp    80228b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802223:	48 98                	cltq   
  802225:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80222b:	48 c1 e0 0c          	shl    $0xc,%rax
  80222f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802237:	48 c1 e8 15          	shr    $0x15,%rax
  80223b:	48 89 c2             	mov    %rax,%rdx
  80223e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802245:	01 00 00 
  802248:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224c:	83 e0 01             	and    $0x1,%eax
  80224f:	48 85 c0             	test   %rax,%rax
  802252:	74 21                	je     802275 <fd_alloc+0x6a>
  802254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802258:	48 c1 e8 0c          	shr    $0xc,%rax
  80225c:	48 89 c2             	mov    %rax,%rdx
  80225f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802266:	01 00 00 
  802269:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226d:	83 e0 01             	and    $0x1,%eax
  802270:	48 85 c0             	test   %rax,%rax
  802273:	75 12                	jne    802287 <fd_alloc+0x7c>
			*fd_store = fd;
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
  802285:	eb 1a                	jmp    8022a1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802287:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80228b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80228f:	7e 8f                	jle    802220 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802291:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802295:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80229c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022a1:	c9                   	leaveq 
  8022a2:	c3                   	retq   

00000000008022a3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	48 83 ec 20          	sub    $0x20,%rsp
  8022ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022b6:	78 06                	js     8022be <fd_lookup+0x1b>
  8022b8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022bc:	7e 07                	jle    8022c5 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c3:	eb 6c                	jmp    802331 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c8:	48 98                	cltq   
  8022ca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d0:	48 c1 e0 0c          	shl    $0xc,%rax
  8022d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022dc:	48 c1 e8 15          	shr    $0x15,%rax
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022ea:	01 00 00 
  8022ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f1:	83 e0 01             	and    $0x1,%eax
  8022f4:	48 85 c0             	test   %rax,%rax
  8022f7:	74 21                	je     80231a <fd_lookup+0x77>
  8022f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802301:	48 89 c2             	mov    %rax,%rdx
  802304:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80230b:	01 00 00 
  80230e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802312:	83 e0 01             	and    $0x1,%eax
  802315:	48 85 c0             	test   %rax,%rax
  802318:	75 07                	jne    802321 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80231a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80231f:	eb 10                	jmp    802331 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802321:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802325:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802329:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802331:	c9                   	leaveq 
  802332:	c3                   	retq   

0000000000802333 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802333:	55                   	push   %rbp
  802334:	48 89 e5             	mov    %rsp,%rbp
  802337:	48 83 ec 30          	sub    $0x30,%rsp
  80233b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80233f:	89 f0                	mov    %esi,%eax
  802341:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802348:	48 89 c7             	mov    %rax,%rdi
  80234b:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  802352:	00 00 00 
  802355:	ff d0                	callq  *%rax
  802357:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80235b:	48 89 d6             	mov    %rdx,%rsi
  80235e:	89 c7                	mov    %eax,%edi
  802360:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802367:	00 00 00 
  80236a:	ff d0                	callq  *%rax
  80236c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802373:	78 0a                	js     80237f <fd_close+0x4c>
	    || fd != fd2)
  802375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802379:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80237d:	74 12                	je     802391 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80237f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802383:	74 05                	je     80238a <fd_close+0x57>
  802385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802388:	eb 05                	jmp    80238f <fd_close+0x5c>
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
  80238f:	eb 69                	jmp    8023fa <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802395:	8b 00                	mov    (%rax),%eax
  802397:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239b:	48 89 d6             	mov    %rdx,%rsi
  80239e:	89 c7                	mov    %eax,%edi
  8023a0:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  8023a7:	00 00 00 
  8023aa:	ff d0                	callq  *%rax
  8023ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b3:	78 2a                	js     8023df <fd_close+0xac>
		if (dev->dev_close)
  8023b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023bd:	48 85 c0             	test   %rax,%rax
  8023c0:	74 16                	je     8023d8 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023ce:	48 89 d7             	mov    %rdx,%rdi
  8023d1:	ff d0                	callq  *%rax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d6:	eb 07                	jmp    8023df <fd_close+0xac>
		else
			r = 0;
  8023d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e3:	48 89 c6             	mov    %rax,%rsi
  8023e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023eb:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
	return r;
  8023f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 20          	sub    $0x20,%rsp
  802404:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80240b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802412:	eb 41                	jmp    802455 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802414:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80241b:	00 00 00 
  80241e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802421:	48 63 d2             	movslq %edx,%rdx
  802424:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802428:	8b 00                	mov    (%rax),%eax
  80242a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80242d:	75 22                	jne    802451 <dev_lookup+0x55>
			*dev = devtab[i];
  80242f:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802436:	00 00 00 
  802439:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80243c:	48 63 d2             	movslq %edx,%rdx
  80243f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802443:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802447:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
  80244f:	eb 60                	jmp    8024b1 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802451:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802455:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80245c:	00 00 00 
  80245f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802462:	48 63 d2             	movslq %edx,%rdx
  802465:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802469:	48 85 c0             	test   %rax,%rax
  80246c:	75 a6                	jne    802414 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80246e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802475:	00 00 00 
  802478:	48 8b 00             	mov    (%rax),%rax
  80247b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802481:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802484:	89 c6                	mov    %eax,%esi
  802486:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  80248d:	00 00 00 
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	48 b9 89 09 80 00 00 	movabs $0x800989,%rcx
  80249c:	00 00 00 
  80249f:	ff d1                	callq  *%rcx
	*dev = 0;
  8024a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024b1:	c9                   	leaveq 
  8024b2:	c3                   	retq   

00000000008024b3 <close>:

int
close(int fdnum)
{
  8024b3:	55                   	push   %rbp
  8024b4:	48 89 e5             	mov    %rsp,%rbp
  8024b7:	48 83 ec 20          	sub    $0x20,%rsp
  8024bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c5:	48 89 d6             	mov    %rdx,%rsi
  8024c8:	89 c7                	mov    %eax,%edi
  8024ca:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
  8024d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024dd:	79 05                	jns    8024e4 <close+0x31>
		return r;
  8024df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e2:	eb 18                	jmp    8024fc <close+0x49>
	else
		return fd_close(fd, 1);
  8024e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e8:	be 01 00 00 00       	mov    $0x1,%esi
  8024ed:	48 89 c7             	mov    %rax,%rdi
  8024f0:	48 b8 33 23 80 00 00 	movabs $0x802333,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
}
  8024fc:	c9                   	leaveq 
  8024fd:	c3                   	retq   

00000000008024fe <close_all>:

void
close_all(void)
{
  8024fe:	55                   	push   %rbp
  8024ff:	48 89 e5             	mov    %rsp,%rbp
  802502:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802506:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80250d:	eb 15                	jmp    802524 <close_all+0x26>
		close(i);
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	89 c7                	mov    %eax,%edi
  802514:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802520:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802524:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802528:	7e e5                	jle    80250f <close_all+0x11>
		close(i);
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80252c:	55                   	push   %rbp
  80252d:	48 89 e5             	mov    %rsp,%rbp
  802530:	48 83 ec 40          	sub    $0x40,%rsp
  802534:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802537:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80253a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80253e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802541:	48 89 d6             	mov    %rdx,%rsi
  802544:	89 c7                	mov    %eax,%edi
  802546:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax
  802552:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802555:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802559:	79 08                	jns    802563 <dup+0x37>
		return r;
  80255b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255e:	e9 70 01 00 00       	jmpq   8026d3 <dup+0x1a7>
	close(newfdnum);
  802563:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802566:	89 c7                	mov    %eax,%edi
  802568:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  80256f:	00 00 00 
  802572:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802574:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802577:	48 98                	cltq   
  802579:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80257f:	48 c1 e0 0c          	shl    $0xc,%rax
  802583:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258b:	48 89 c7             	mov    %rax,%rdi
  80258e:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
  80259a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80259e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a2:	48 89 c7             	mov    %rax,%rdi
  8025a5:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b9:	48 c1 e8 15          	shr    $0x15,%rax
  8025bd:	48 89 c2             	mov    %rax,%rdx
  8025c0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025c7:	01 00 00 
  8025ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ce:	83 e0 01             	and    $0x1,%eax
  8025d1:	48 85 c0             	test   %rax,%rax
  8025d4:	74 73                	je     802649 <dup+0x11d>
  8025d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025da:	48 c1 e8 0c          	shr    $0xc,%rax
  8025de:	48 89 c2             	mov    %rax,%rdx
  8025e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025e8:	01 00 00 
  8025eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ef:	83 e0 01             	and    $0x1,%eax
  8025f2:	48 85 c0             	test   %rax,%rax
  8025f5:	74 52                	je     802649 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ff:	48 89 c2             	mov    %rax,%rdx
  802602:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802609:	01 00 00 
  80260c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802610:	25 07 0e 00 00       	and    $0xe07,%eax
  802615:	89 c1                	mov    %eax,%ecx
  802617:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80261b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261f:	41 89 c8             	mov    %ecx,%r8d
  802622:	48 89 d1             	mov    %rdx,%rcx
  802625:	ba 00 00 00 00       	mov    $0x0,%edx
  80262a:	48 89 c6             	mov    %rax,%rsi
  80262d:	bf 00 00 00 00       	mov    $0x0,%edi
  802632:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	79 02                	jns    802649 <dup+0x11d>
			goto err;
  802647:	eb 57                	jmp    8026a0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264d:	48 c1 e8 0c          	shr    $0xc,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	25 07 0e 00 00       	and    $0xe07,%eax
  802667:	89 c1                	mov    %eax,%ecx
  802669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802671:	41 89 c8             	mov    %ecx,%r8d
  802674:	48 89 d1             	mov    %rdx,%rcx
  802677:	ba 00 00 00 00       	mov    $0x0,%edx
  80267c:	48 89 c6             	mov    %rax,%rsi
  80267f:	bf 00 00 00 00       	mov    $0x0,%edi
  802684:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
  802690:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802693:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802697:	79 02                	jns    80269b <dup+0x16f>
		goto err;
  802699:	eb 05                	jmp    8026a0 <dup+0x174>

	return newfdnum;
  80269b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80269e:	eb 33                	jmp    8026d3 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a4:	48 89 c6             	mov    %rax,%rsi
  8026a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ac:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026bc:	48 89 c6             	mov    %rax,%rsi
  8026bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c4:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
	return r;
  8026d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026d3:	c9                   	leaveq 
  8026d4:	c3                   	retq   

00000000008026d5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026d5:	55                   	push   %rbp
  8026d6:	48 89 e5             	mov    %rsp,%rbp
  8026d9:	48 83 ec 40          	sub    $0x40,%rsp
  8026dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026e4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026ef:	48 89 d6             	mov    %rdx,%rsi
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802707:	78 24                	js     80272d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270d:	8b 00                	mov    (%rax),%eax
  80270f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	89 c7                	mov    %eax,%edi
  802718:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
  802724:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272b:	79 05                	jns    802732 <read+0x5d>
		return r;
  80272d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802730:	eb 76                	jmp    8027a8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802736:	8b 40 08             	mov    0x8(%rax),%eax
  802739:	83 e0 03             	and    $0x3,%eax
  80273c:	83 f8 01             	cmp    $0x1,%eax
  80273f:	75 3a                	jne    80277b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802741:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802748:	00 00 00 
  80274b:	48 8b 00             	mov    (%rax),%rax
  80274e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802754:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802757:	89 c6                	mov    %eax,%esi
  802759:	48 bf b7 4f 80 00 00 	movabs $0x804fb7,%rdi
  802760:	00 00 00 
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	48 b9 89 09 80 00 00 	movabs $0x800989,%rcx
  80276f:	00 00 00 
  802772:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802774:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802779:	eb 2d                	jmp    8027a8 <read+0xd3>
	}
	if (!dev->dev_read)
  80277b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802783:	48 85 c0             	test   %rax,%rax
  802786:	75 07                	jne    80278f <read+0xba>
		return -E_NOT_SUPP;
  802788:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80278d:	eb 19                	jmp    8027a8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80278f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802793:	48 8b 40 10          	mov    0x10(%rax),%rax
  802797:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80279b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80279f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027a3:	48 89 cf             	mov    %rcx,%rdi
  8027a6:	ff d0                	callq  *%rax
}
  8027a8:	c9                   	leaveq 
  8027a9:	c3                   	retq   

00000000008027aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027aa:	55                   	push   %rbp
  8027ab:	48 89 e5             	mov    %rsp,%rbp
  8027ae:	48 83 ec 30          	sub    $0x30,%rsp
  8027b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027c4:	eb 49                	jmp    80280f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c9:	48 98                	cltq   
  8027cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027cf:	48 29 c2             	sub    %rax,%rdx
  8027d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d5:	48 63 c8             	movslq %eax,%rcx
  8027d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027dc:	48 01 c1             	add    %rax,%rcx
  8027df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027e2:	48 89 ce             	mov    %rcx,%rsi
  8027e5:	89 c7                	mov    %eax,%edi
  8027e7:	48 b8 d5 26 80 00 00 	movabs $0x8026d5,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax
  8027f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027fa:	79 05                	jns    802801 <readn+0x57>
			return m;
  8027fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ff:	eb 1c                	jmp    80281d <readn+0x73>
		if (m == 0)
  802801:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802805:	75 02                	jne    802809 <readn+0x5f>
			break;
  802807:	eb 11                	jmp    80281a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802809:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80280c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80280f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802812:	48 98                	cltq   
  802814:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802818:	72 ac                	jb     8027c6 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80281a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80281d:	c9                   	leaveq 
  80281e:	c3                   	retq   

000000000080281f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80281f:	55                   	push   %rbp
  802820:	48 89 e5             	mov    %rsp,%rbp
  802823:	48 83 ec 40          	sub    $0x40,%rsp
  802827:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80282a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80282e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802832:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802836:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802839:	48 89 d6             	mov    %rdx,%rsi
  80283c:	89 c7                	mov    %eax,%edi
  80283e:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
  80284a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802851:	78 24                	js     802877 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802857:	8b 00                	mov    (%rax),%eax
  802859:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285d:	48 89 d6             	mov    %rdx,%rsi
  802860:	89 c7                	mov    %eax,%edi
  802862:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802871:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802875:	79 05                	jns    80287c <write+0x5d>
		return r;
  802877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287a:	eb 42                	jmp    8028be <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802880:	8b 40 08             	mov    0x8(%rax),%eax
  802883:	83 e0 03             	and    $0x3,%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	75 07                	jne    802891 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80288a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80288f:	eb 2d                	jmp    8028be <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802895:	48 8b 40 18          	mov    0x18(%rax),%rax
  802899:	48 85 c0             	test   %rax,%rax
  80289c:	75 07                	jne    8028a5 <write+0x86>
		return -E_NOT_SUPP;
  80289e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028a3:	eb 19                	jmp    8028be <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8028a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028b1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028b5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028b9:	48 89 cf             	mov    %rcx,%rdi
  8028bc:	ff d0                	callq  *%rax
}
  8028be:	c9                   	leaveq 
  8028bf:	c3                   	retq   

00000000008028c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028c0:	55                   	push   %rbp
  8028c1:	48 89 e5             	mov    %rsp,%rbp
  8028c4:	48 83 ec 18          	sub    $0x18,%rsp
  8028c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d5:	48 89 d6             	mov    %rdx,%rsi
  8028d8:	89 c7                	mov    %eax,%edi
  8028da:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ed:	79 05                	jns    8028f4 <seek+0x34>
		return r;
  8028ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f2:	eb 0f                	jmp    802903 <seek+0x43>
	fd->fd_offset = offset;
  8028f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028fb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802903:	c9                   	leaveq 
  802904:	c3                   	retq   

0000000000802905 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802905:	55                   	push   %rbp
  802906:	48 89 e5             	mov    %rsp,%rbp
  802909:	48 83 ec 30          	sub    $0x30,%rsp
  80290d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802910:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802913:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802917:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80291a:	48 89 d6             	mov    %rdx,%rsi
  80291d:	89 c7                	mov    %eax,%edi
  80291f:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  802926:	00 00 00 
  802929:	ff d0                	callq  *%rax
  80292b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802932:	78 24                	js     802958 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	8b 00                	mov    (%rax),%eax
  80293a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80293e:	48 89 d6             	mov    %rdx,%rsi
  802941:	89 c7                	mov    %eax,%edi
  802943:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802956:	79 05                	jns    80295d <ftruncate+0x58>
		return r;
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295b:	eb 72                	jmp    8029cf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80295d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802961:	8b 40 08             	mov    0x8(%rax),%eax
  802964:	83 e0 03             	and    $0x3,%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	75 3a                	jne    8029a5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80296b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802972:	00 00 00 
  802975:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802978:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80297e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802981:	89 c6                	mov    %eax,%esi
  802983:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  80298a:	00 00 00 
  80298d:	b8 00 00 00 00       	mov    $0x0,%eax
  802992:	48 b9 89 09 80 00 00 	movabs $0x800989,%rcx
  802999:	00 00 00 
  80299c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80299e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a3:	eb 2a                	jmp    8029cf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029ad:	48 85 c0             	test   %rax,%rax
  8029b0:	75 07                	jne    8029b9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029b2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029b7:	eb 16                	jmp    8029cf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029c5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029c8:	89 ce                	mov    %ecx,%esi
  8029ca:	48 89 d7             	mov    %rdx,%rdi
  8029cd:	ff d0                	callq  *%rax
}
  8029cf:	c9                   	leaveq 
  8029d0:	c3                   	retq   

00000000008029d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029d1:	55                   	push   %rbp
  8029d2:	48 89 e5             	mov    %rsp,%rbp
  8029d5:	48 83 ec 30          	sub    $0x30,%rsp
  8029d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029e0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e7:	48 89 d6             	mov    %rdx,%rsi
  8029ea:	89 c7                	mov    %eax,%edi
  8029ec:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax
  8029f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ff:	78 24                	js     802a25 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a05:	8b 00                	mov    (%rax),%eax
  802a07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a0b:	48 89 d6             	mov    %rdx,%rsi
  802a0e:	89 c7                	mov    %eax,%edi
  802a10:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
  802a1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a23:	79 05                	jns    802a2a <fstat+0x59>
		return r;
  802a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a28:	eb 5e                	jmp    802a88 <fstat+0xb7>
	if (!dev->dev_stat)
  802a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a32:	48 85 c0             	test   %rax,%rax
  802a35:	75 07                	jne    802a3e <fstat+0x6d>
		return -E_NOT_SUPP;
  802a37:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a3c:	eb 4a                	jmp    802a88 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a42:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a49:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a50:	00 00 00 
	stat->st_isdir = 0;
  802a53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a57:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a5e:	00 00 00 
	stat->st_dev = dev;
  802a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a69:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a74:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a7c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a80:	48 89 ce             	mov    %rcx,%rsi
  802a83:	48 89 d7             	mov    %rdx,%rdi
  802a86:	ff d0                	callq  *%rax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 20          	sub    $0x20,%rsp
  802a92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9e:	be 00 00 00 00       	mov    $0x0,%esi
  802aa3:	48 89 c7             	mov    %rax,%rdi
  802aa6:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
  802ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab9:	79 05                	jns    802ac0 <stat+0x36>
		return fd;
  802abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abe:	eb 2f                	jmp    802aef <stat+0x65>
	r = fstat(fd, stat);
  802ac0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac7:	48 89 d6             	mov    %rdx,%rsi
  802aca:	89 c7                	mov    %eax,%edi
  802acc:	48 b8 d1 29 80 00 00 	movabs $0x8029d1,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802adb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ade:	89 c7                	mov    %eax,%edi
  802ae0:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
	return r;
  802aec:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802aef:	c9                   	leaveq 
  802af0:	c3                   	retq   

0000000000802af1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802af1:	55                   	push   %rbp
  802af2:	48 89 e5             	mov    %rsp,%rbp
  802af5:	48 83 ec 10          	sub    $0x10,%rsp
  802af9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802afc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b00:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b07:	00 00 00 
  802b0a:	8b 00                	mov    (%rax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	75 1d                	jne    802b2d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b10:	bf 01 00 00 00       	mov    $0x1,%edi
  802b15:	48 b8 03 48 80 00 00 	movabs $0x804803,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
  802b21:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b28:	00 00 00 
  802b2b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b2d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b34:	00 00 00 
  802b37:	8b 00                	mov    (%rax),%eax
  802b39:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b3c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b41:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802b48:	00 00 00 
  802b4b:	89 c7                	mov    %eax,%edi
  802b4d:	48 b8 36 44 80 00 00 	movabs $0x804436,%rax
  802b54:	00 00 00 
  802b57:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b62:	48 89 c6             	mov    %rax,%rsi
  802b65:	bf 00 00 00 00       	mov    $0x0,%edi
  802b6a:	48 b8 38 43 80 00 00 	movabs $0x804338,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
}
  802b76:	c9                   	leaveq 
  802b77:	c3                   	retq   

0000000000802b78 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	48 83 ec 30          	sub    $0x30,%rsp
  802b80:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b84:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802b87:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802b8e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802b9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ba1:	75 08                	jne    802bab <open+0x33>
	{
		return r;
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba6:	e9 f2 00 00 00       	jmpq   802c9d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802bab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802baf:	48 89 c7             	mov    %rax,%rdi
  802bb2:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
  802bbe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bc1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802bc8:	7e 0a                	jle    802bd4 <open+0x5c>
	{
		return -E_BAD_PATH;
  802bca:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bcf:	e9 c9 00 00 00       	jmpq   802c9d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802bd4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802bdb:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802bdc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802be0:	48 89 c7             	mov    %rax,%rdi
  802be3:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
  802bef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf6:	78 09                	js     802c01 <open+0x89>
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	48 85 c0             	test   %rax,%rax
  802bff:	75 08                	jne    802c09 <open+0x91>
		{
			return r;
  802c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c04:	e9 94 00 00 00       	jmpq   802c9d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0d:	ba 00 04 00 00       	mov    $0x400,%edx
  802c12:	48 89 c6             	mov    %rax,%rsi
  802c15:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802c1c:	00 00 00 
  802c1f:	48 b8 d0 15 80 00 00 	movabs $0x8015d0,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c2b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c32:	00 00 00 
  802c35:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c38:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	bf 01 00 00 00       	mov    $0x1,%edi
  802c4a:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	79 2b                	jns    802c8a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c63:	be 00 00 00 00       	mov    $0x0,%esi
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 33 23 80 00 00 	movabs $0x802333,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802c7a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c7e:	79 05                	jns    802c85 <open+0x10d>
			{
				return d;
  802c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c83:	eb 18                	jmp    802c9d <open+0x125>
			}
			return r;
  802c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c88:	eb 13                	jmp    802c9d <open+0x125>
		}	
		return fd2num(fd_store);
  802c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8e:	48 89 c7             	mov    %rax,%rdi
  802c91:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802c9d:	c9                   	leaveq 
  802c9e:	c3                   	retq   

0000000000802c9f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
  802ca3:	48 83 ec 10          	sub    $0x10,%rsp
  802ca7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802caf:	8b 50 0c             	mov    0xc(%rax),%edx
  802cb2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cb9:	00 00 00 
  802cbc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cbe:	be 00 00 00 00       	mov    $0x0,%esi
  802cc3:	bf 06 00 00 00       	mov    $0x6,%edi
  802cc8:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 30          	sub    $0x30,%rsp
  802cde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ce2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ce6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802cf1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cf6:	74 07                	je     802cff <devfile_read+0x29>
  802cf8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cfd:	75 07                	jne    802d06 <devfile_read+0x30>
		return -E_INVAL;
  802cff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d04:	eb 77                	jmp    802d7d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0a:	8b 50 0c             	mov    0xc(%rax),%edx
  802d0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d14:	00 00 00 
  802d17:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d19:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d20:	00 00 00 
  802d23:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d27:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d2b:	be 00 00 00 00       	mov    $0x0,%esi
  802d30:	bf 03 00 00 00       	mov    $0x3,%edi
  802d35:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802d3c:	00 00 00 
  802d3f:	ff d0                	callq  *%rax
  802d41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d48:	7f 05                	jg     802d4f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4d:	eb 2e                	jmp    802d7d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d52:	48 63 d0             	movslq %eax,%rdx
  802d55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d59:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802d60:	00 00 00 
  802d63:	48 89 c7             	mov    %rax,%rdi
  802d66:	48 b8 62 18 80 00 00 	movabs $0x801862,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d7d:	c9                   	leaveq 
  802d7e:	c3                   	retq   

0000000000802d7f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d7f:	55                   	push   %rbp
  802d80:	48 89 e5             	mov    %rsp,%rbp
  802d83:	48 83 ec 30          	sub    $0x30,%rsp
  802d87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802d93:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802d9a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d9f:	74 07                	je     802da8 <devfile_write+0x29>
  802da1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802da6:	75 08                	jne    802db0 <devfile_write+0x31>
		return r;
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	e9 9a 00 00 00       	jmpq   802e4a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db4:	8b 50 0c             	mov    0xc(%rax),%edx
  802db7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dbe:	00 00 00 
  802dc1:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802dc3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802dca:	00 
  802dcb:	76 08                	jbe    802dd5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802dcd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802dd4:	00 
	}
	fsipcbuf.write.req_n = n;
  802dd5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ddc:	00 00 00 
  802ddf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802de3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802de7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802deb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802def:	48 89 c6             	mov    %rax,%rsi
  802df2:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802df9:	00 00 00 
  802dfc:	48 b8 62 18 80 00 00 	movabs $0x801862,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e08:	be 00 00 00 00       	mov    $0x0,%esi
  802e0d:	bf 04 00 00 00       	mov    $0x4,%edi
  802e12:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
  802e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e25:	7f 20                	jg     802e47 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e27:	48 bf fe 4f 80 00 00 	movabs $0x804ffe,%rdi
  802e2e:	00 00 00 
  802e31:	b8 00 00 00 00       	mov    $0x0,%eax
  802e36:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  802e3d:	00 00 00 
  802e40:	ff d2                	callq  *%rdx
		return r;
  802e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e45:	eb 03                	jmp    802e4a <devfile_write+0xcb>
	}
	return r;
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e4a:	c9                   	leaveq 
  802e4b:	c3                   	retq   

0000000000802e4c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e4c:	55                   	push   %rbp
  802e4d:	48 89 e5             	mov    %rsp,%rbp
  802e50:	48 83 ec 20          	sub    $0x20,%rsp
  802e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e60:	8b 50 0c             	mov    0xc(%rax),%edx
  802e63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e6a:	00 00 00 
  802e6d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e6f:	be 00 00 00 00       	mov    $0x0,%esi
  802e74:	bf 05 00 00 00       	mov    $0x5,%edi
  802e79:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	callq  *%rax
  802e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8c:	79 05                	jns    802e93 <devfile_stat+0x47>
		return r;
  802e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e91:	eb 56                	jmp    802ee9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e97:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802e9e:	00 00 00 
  802ea1:	48 89 c7             	mov    %rax,%rdi
  802ea4:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802eb0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eb7:	00 00 00 
  802eba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ec0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802eca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ed1:	00 00 00 
  802ed4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ede:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee9:	c9                   	leaveq 
  802eea:	c3                   	retq   

0000000000802eeb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802eeb:	55                   	push   %rbp
  802eec:	48 89 e5             	mov    %rsp,%rbp
  802eef:	48 83 ec 10          	sub    $0x10,%rsp
  802ef3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ef7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efe:	8b 50 0c             	mov    0xc(%rax),%edx
  802f01:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f08:	00 00 00 
  802f0b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f14:	00 00 00 
  802f17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f1d:	be 00 00 00 00       	mov    $0x0,%esi
  802f22:	bf 02 00 00 00       	mov    $0x2,%edi
  802f27:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
}
  802f33:	c9                   	leaveq 
  802f34:	c3                   	retq   

0000000000802f35 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f35:	55                   	push   %rbp
  802f36:	48 89 e5             	mov    %rsp,%rbp
  802f39:	48 83 ec 10          	sub    $0x10,%rsp
  802f3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f45:	48 89 c7             	mov    %rax,%rdi
  802f48:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
  802f54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f59:	7e 07                	jle    802f62 <remove+0x2d>
		return -E_BAD_PATH;
  802f5b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f60:	eb 33                	jmp    802f95 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f66:	48 89 c6             	mov    %rax,%rsi
  802f69:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802f70:	00 00 00 
  802f73:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f7f:	be 00 00 00 00       	mov    $0x0,%esi
  802f84:	bf 07 00 00 00       	mov    $0x7,%edi
  802f89:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
}
  802f95:	c9                   	leaveq 
  802f96:	c3                   	retq   

0000000000802f97 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f97:	55                   	push   %rbp
  802f98:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f9b:	be 00 00 00 00       	mov    $0x0,%esi
  802fa0:	bf 08 00 00 00       	mov    $0x8,%edi
  802fa5:	48 b8 f1 2a 80 00 00 	movabs $0x802af1,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
}
  802fb1:	5d                   	pop    %rbp
  802fb2:	c3                   	retq   

0000000000802fb3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fb3:	55                   	push   %rbp
  802fb4:	48 89 e5             	mov    %rsp,%rbp
  802fb7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fbe:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fc5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fcc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fd3:	be 00 00 00 00       	mov    $0x0,%esi
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fee:	79 28                	jns    803018 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff3:	89 c6                	mov    %eax,%esi
  802ff5:	48 bf 1a 50 80 00 00 	movabs $0x80501a,%rdi
  802ffc:	00 00 00 
  802fff:	b8 00 00 00 00       	mov    $0x0,%eax
  803004:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  80300b:	00 00 00 
  80300e:	ff d2                	callq  *%rdx
		return fd_src;
  803010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803013:	e9 74 01 00 00       	jmpq   80318c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803018:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80301f:	be 01 01 00 00       	mov    $0x101,%esi
  803024:	48 89 c7             	mov    %rax,%rdi
  803027:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
  803033:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803036:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80303a:	79 39                	jns    803075 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80303c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80303f:	89 c6                	mov    %eax,%esi
  803041:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  803048:	00 00 00 
  80304b:	b8 00 00 00 00       	mov    $0x0,%eax
  803050:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  803057:	00 00 00 
  80305a:	ff d2                	callq  *%rdx
		close(fd_src);
  80305c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305f:	89 c7                	mov    %eax,%edi
  803061:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
		return fd_dest;
  80306d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803070:	e9 17 01 00 00       	jmpq   80318c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803075:	eb 74                	jmp    8030eb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803077:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80307a:	48 63 d0             	movslq %eax,%rdx
  80307d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803084:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803087:	48 89 ce             	mov    %rcx,%rsi
  80308a:	89 c7                	mov    %eax,%edi
  80308c:	48 b8 1f 28 80 00 00 	movabs $0x80281f,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
  803098:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80309b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80309f:	79 4a                	jns    8030eb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030a4:	89 c6                	mov    %eax,%esi
  8030a6:	48 bf 4a 50 80 00 00 	movabs $0x80504a,%rdi
  8030ad:	00 00 00 
  8030b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b5:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  8030bc:	00 00 00 
  8030bf:	ff d2                	callq  *%rdx
			close(fd_src);
  8030c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c4:	89 c7                	mov    %eax,%edi
  8030c6:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
			close(fd_dest);
  8030d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d5:	89 c7                	mov    %eax,%edi
  8030d7:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  8030de:	00 00 00 
  8030e1:	ff d0                	callq  *%rax
			return write_size;
  8030e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030e6:	e9 a1 00 00 00       	jmpq   80318c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030eb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8030fa:	48 89 ce             	mov    %rcx,%rsi
  8030fd:	89 c7                	mov    %eax,%edi
  8030ff:	48 b8 d5 26 80 00 00 	movabs $0x8026d5,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803112:	0f 8f 5f ff ff ff    	jg     803077 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803118:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80311c:	79 47                	jns    803165 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80311e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803121:	89 c6                	mov    %eax,%esi
  803123:	48 bf 5d 50 80 00 00 	movabs $0x80505d,%rdi
  80312a:	00 00 00 
  80312d:	b8 00 00 00 00       	mov    $0x0,%eax
  803132:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  803139:	00 00 00 
  80313c:	ff d2                	callq  *%rdx
		close(fd_src);
  80313e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803141:	89 c7                	mov    %eax,%edi
  803143:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
		close(fd_dest);
  80314f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803152:	89 c7                	mov    %eax,%edi
  803154:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
		return read_size;
  803160:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803163:	eb 27                	jmp    80318c <copy+0x1d9>
	}
	close(fd_src);
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	89 c7                	mov    %eax,%edi
  80316a:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
	close(fd_dest);
  803176:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803179:	89 c7                	mov    %eax,%edi
  80317b:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
	return 0;
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80318c:	c9                   	leaveq 
  80318d:	c3                   	retq   

000000000080318e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80318e:	55                   	push   %rbp
  80318f:	48 89 e5             	mov    %rsp,%rbp
  803192:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803199:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8031a0:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8031a7:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8031ae:	be 00 00 00 00       	mov    $0x0,%esi
  8031b3:	48 89 c7             	mov    %rax,%rdi
  8031b6:	48 b8 78 2b 80 00 00 	movabs $0x802b78,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
  8031c2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031c9:	79 08                	jns    8031d3 <spawn+0x45>
		return r;
  8031cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031ce:	e9 0c 03 00 00       	jmpq   8034df <spawn+0x351>
	fd = r;
  8031d3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031d6:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031d9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8031e0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8031e4:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8031eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031ee:	ba 00 02 00 00       	mov    $0x200,%edx
  8031f3:	48 89 ce             	mov    %rcx,%rsi
  8031f6:	89 c7                	mov    %eax,%edi
  8031f8:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
  803204:	3d 00 02 00 00       	cmp    $0x200,%eax
  803209:	75 0d                	jne    803218 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80320b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320f:	8b 00                	mov    (%rax),%eax
  803211:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803216:	74 43                	je     80325b <spawn+0xcd>
		close(fd);
  803218:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80321b:	89 c7                	mov    %eax,%edi
  80321d:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322d:	8b 00                	mov    (%rax),%eax
  80322f:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803234:	89 c6                	mov    %eax,%esi
  803236:	48 bf 78 50 80 00 00 	movabs $0x805078,%rdi
  80323d:	00 00 00 
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
  803245:	48 b9 89 09 80 00 00 	movabs $0x800989,%rcx
  80324c:	00 00 00 
  80324f:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803251:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803256:	e9 84 02 00 00       	jmpq   8034df <spawn+0x351>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80325b:	b8 07 00 00 00       	mov    $0x7,%eax
  803260:	cd 30                	int    $0x30
  803262:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803265:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803268:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80326b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80326f:	79 08                	jns    803279 <spawn+0xeb>
		return r;
  803271:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803274:	e9 66 02 00 00       	jmpq   8034df <spawn+0x351>
	child = r;
  803279:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80327c:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80327f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803282:	25 ff 03 00 00       	and    $0x3ff,%eax
  803287:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80328e:	00 00 00 
  803291:	48 98                	cltq   
  803293:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80329a:	48 01 d0             	add    %rdx,%rax
  80329d:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8032a4:	48 89 c6             	mov    %rax,%rsi
  8032a7:	b8 18 00 00 00       	mov    $0x18,%eax
  8032ac:	48 89 d7             	mov    %rdx,%rdi
  8032af:	48 89 c1             	mov    %rax,%rcx
  8032b2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032bd:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032c4:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8032cb:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032d2:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8032d9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032dc:	48 89 ce             	mov    %rcx,%rsi
  8032df:	89 c7                	mov    %eax,%edi
  8032e1:	48 b8 49 37 80 00 00 	movabs $0x803749,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032f4:	79 08                	jns    8032fe <spawn+0x170>
		return r;
  8032f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032f9:	e9 e1 01 00 00       	jmpq   8034df <spawn+0x351>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8032fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803302:	48 8b 40 20          	mov    0x20(%rax),%rax
  803306:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80330d:	48 01 d0             	add    %rdx,%rax
  803310:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80331b:	e9 a3 00 00 00       	jmpq   8033c3 <spawn+0x235>
		if (ph->p_type != ELF_PROG_LOAD)
  803320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803324:	8b 00                	mov    (%rax),%eax
  803326:	83 f8 01             	cmp    $0x1,%eax
  803329:	74 05                	je     803330 <spawn+0x1a2>
			continue;
  80332b:	e9 8a 00 00 00       	jmpq   8033ba <spawn+0x22c>
		perm = PTE_P | PTE_U;
  803330:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333b:	8b 40 04             	mov    0x4(%rax),%eax
  80333e:	83 e0 02             	and    $0x2,%eax
  803341:	85 c0                	test   %eax,%eax
  803343:	74 04                	je     803349 <spawn+0x1bb>
			perm |= PTE_W;
  803345:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80334d:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803351:	41 89 c1             	mov    %eax,%r9d
  803354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803358:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80335c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803360:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803368:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80336c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80336f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803372:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803375:	89 3c 24             	mov    %edi,(%rsp)
  803378:	89 c7                	mov    %eax,%edi
  80337a:	48 b8 f2 39 80 00 00 	movabs $0x8039f2,%rax
  803381:	00 00 00 
  803384:	ff d0                	callq  *%rax
  803386:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803389:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80338d:	79 2b                	jns    8033ba <spawn+0x22c>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80338f:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803390:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803393:	89 c7                	mov    %eax,%edi
  803395:	48 b8 ad 1d 80 00 00 	movabs $0x801dad,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
	close(fd);
  8033a1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033a4:	89 c7                	mov    %eax,%edi
  8033a6:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
	return r;
  8033b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033b5:	e9 25 01 00 00       	jmpq   8034df <spawn+0x351>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033be:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8033c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c7:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033cb:	0f b7 c0             	movzwl %ax,%eax
  8033ce:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8033d1:	0f 8f 49 ff ff ff    	jg     803320 <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033d7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033da:	89 c7                	mov    %eax,%edi
  8033dc:	48 b8 b3 24 80 00 00 	movabs $0x8024b3,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
	fd = -1;
  8033e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033ef:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033f2:	89 c7                	mov    %eax,%edi
  8033f4:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
  803400:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803403:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803407:	79 30                	jns    803439 <spawn+0x2ab>
		panic("copy_shared_pages: %e", r);
  803409:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80340c:	89 c1                	mov    %eax,%ecx
  80340e:	48 ba 92 50 80 00 00 	movabs $0x805092,%rdx
  803415:	00 00 00 
  803418:	be 82 00 00 00       	mov    $0x82,%esi
  80341d:	48 bf a8 50 80 00 00 	movabs $0x8050a8,%rdi
  803424:	00 00 00 
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803433:	00 00 00 
  803436:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803439:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803440:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803443:	48 89 d6             	mov    %rdx,%rsi
  803446:	89 c7                	mov    %eax,%edi
  803448:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
  803454:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803457:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80345b:	79 30                	jns    80348d <spawn+0x2ff>
		panic("sys_env_set_trapframe: %e", r);
  80345d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803460:	89 c1                	mov    %eax,%ecx
  803462:	48 ba b4 50 80 00 00 	movabs $0x8050b4,%rdx
  803469:	00 00 00 
  80346c:	be 85 00 00 00       	mov    $0x85,%esi
  803471:	48 bf a8 50 80 00 00 	movabs $0x8050a8,%rdi
  803478:	00 00 00 
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803487:	00 00 00 
  80348a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80348d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803490:	be 02 00 00 00       	mov    $0x2,%esi
  803495:	89 c7                	mov    %eax,%edi
  803497:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
  8034a3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034aa:	79 30                	jns    8034dc <spawn+0x34e>
		panic("sys_env_set_status: %e", r);
  8034ac:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034af:	89 c1                	mov    %eax,%ecx
  8034b1:	48 ba ce 50 80 00 00 	movabs $0x8050ce,%rdx
  8034b8:	00 00 00 
  8034bb:	be 88 00 00 00       	mov    $0x88,%esi
  8034c0:	48 bf a8 50 80 00 00 	movabs $0x8050a8,%rdi
  8034c7:	00 00 00 
  8034ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cf:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8034d6:	00 00 00 
  8034d9:	41 ff d0             	callq  *%r8

	return child;
  8034dc:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8034df:	c9                   	leaveq 
  8034e0:	c3                   	retq   

00000000008034e1 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8034e1:	55                   	push   %rbp
  8034e2:	48 89 e5             	mov    %rsp,%rbp
  8034e5:	41 55                	push   %r13
  8034e7:	41 54                	push   %r12
  8034e9:	53                   	push   %rbx
  8034ea:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8034f1:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8034f8:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8034ff:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803506:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80350d:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803514:	84 c0                	test   %al,%al
  803516:	74 26                	je     80353e <spawnl+0x5d>
  803518:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80351f:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803526:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  80352a:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80352e:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803532:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803536:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80353a:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80353e:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803545:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80354c:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80354f:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803556:	00 00 00 
  803559:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803560:	00 00 00 
  803563:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803567:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80356e:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803575:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80357c:	eb 07                	jmp    803585 <spawnl+0xa4>
		argc++;
  80357e:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803585:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80358b:	83 f8 30             	cmp    $0x30,%eax
  80358e:	73 23                	jae    8035b3 <spawnl+0xd2>
  803590:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803597:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80359d:	89 c0                	mov    %eax,%eax
  80359f:	48 01 d0             	add    %rdx,%rax
  8035a2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8035a8:	83 c2 08             	add    $0x8,%edx
  8035ab:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8035b1:	eb 15                	jmp    8035c8 <spawnl+0xe7>
  8035b3:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8035ba:	48 89 d0             	mov    %rdx,%rax
  8035bd:	48 83 c2 08          	add    $0x8,%rdx
  8035c1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035c8:	48 8b 00             	mov    (%rax),%rax
  8035cb:	48 85 c0             	test   %rax,%rax
  8035ce:	75 ae                	jne    80357e <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035d0:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035d6:	83 c0 02             	add    $0x2,%eax
  8035d9:	48 89 e2             	mov    %rsp,%rdx
  8035dc:	48 89 d3             	mov    %rdx,%rbx
  8035df:	48 63 d0             	movslq %eax,%rdx
  8035e2:	48 83 ea 01          	sub    $0x1,%rdx
  8035e6:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8035ed:	48 63 d0             	movslq %eax,%rdx
  8035f0:	49 89 d4             	mov    %rdx,%r12
  8035f3:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8035f9:	48 63 d0             	movslq %eax,%rdx
  8035fc:	49 89 d2             	mov    %rdx,%r10
  8035ff:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803605:	48 98                	cltq   
  803607:	48 c1 e0 03          	shl    $0x3,%rax
  80360b:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80360f:	b8 10 00 00 00       	mov    $0x10,%eax
  803614:	48 83 e8 01          	sub    $0x1,%rax
  803618:	48 01 d0             	add    %rdx,%rax
  80361b:	bf 10 00 00 00       	mov    $0x10,%edi
  803620:	ba 00 00 00 00       	mov    $0x0,%edx
  803625:	48 f7 f7             	div    %rdi
  803628:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80362c:	48 29 c4             	sub    %rax,%rsp
  80362f:	48 89 e0             	mov    %rsp,%rax
  803632:	48 83 c0 07          	add    $0x7,%rax
  803636:	48 c1 e8 03          	shr    $0x3,%rax
  80363a:	48 c1 e0 03          	shl    $0x3,%rax
  80363e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803645:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80364c:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803653:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803656:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80365c:	8d 50 01             	lea    0x1(%rax),%edx
  80365f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803666:	48 63 d2             	movslq %edx,%rdx
  803669:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803670:	00 

	va_start(vl, arg0);
  803671:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803678:	00 00 00 
  80367b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803682:	00 00 00 
  803685:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803689:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803690:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803697:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80369e:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8036a5:	00 00 00 
  8036a8:	eb 63                	jmp    80370d <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8036aa:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8036b0:	8d 70 01             	lea    0x1(%rax),%esi
  8036b3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036b9:	83 f8 30             	cmp    $0x30,%eax
  8036bc:	73 23                	jae    8036e1 <spawnl+0x200>
  8036be:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8036c5:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036cb:	89 c0                	mov    %eax,%eax
  8036cd:	48 01 d0             	add    %rdx,%rax
  8036d0:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036d6:	83 c2 08             	add    $0x8,%edx
  8036d9:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036df:	eb 15                	jmp    8036f6 <spawnl+0x215>
  8036e1:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8036e8:	48 89 d0             	mov    %rdx,%rax
  8036eb:	48 83 c2 08          	add    $0x8,%rdx
  8036ef:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036f6:	48 8b 08             	mov    (%rax),%rcx
  8036f9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803700:	89 f2                	mov    %esi,%edx
  803702:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803706:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80370d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803713:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803719:	77 8f                	ja     8036aa <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80371b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803722:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803729:	48 89 d6             	mov    %rdx,%rsi
  80372c:	48 89 c7             	mov    %rax,%rdi
  80372f:	48 b8 8e 31 80 00 00 	movabs $0x80318e,%rax
  803736:	00 00 00 
  803739:	ff d0                	callq  *%rax
  80373b:	48 89 dc             	mov    %rbx,%rsp
}
  80373e:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803742:	5b                   	pop    %rbx
  803743:	41 5c                	pop    %r12
  803745:	41 5d                	pop    %r13
  803747:	5d                   	pop    %rbp
  803748:	c3                   	retq   

0000000000803749 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803749:	55                   	push   %rbp
  80374a:	48 89 e5             	mov    %rsp,%rbp
  80374d:	48 83 ec 50          	sub    $0x50,%rsp
  803751:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803754:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803758:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80375c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803763:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80376b:	eb 33                	jmp    8037a0 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80376d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803770:	48 98                	cltq   
  803772:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803779:	00 
  80377a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80377e:	48 01 d0             	add    %rdx,%rax
  803781:	48 8b 00             	mov    (%rax),%rax
  803784:	48 89 c7             	mov    %rax,%rdi
  803787:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	83 c0 01             	add    $0x1,%eax
  803796:	48 98                	cltq   
  803798:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80379c:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8037a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037a3:	48 98                	cltq   
  8037a5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037ac:	00 
  8037ad:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037b1:	48 01 d0             	add    %rdx,%rax
  8037b4:	48 8b 00             	mov    (%rax),%rax
  8037b7:	48 85 c0             	test   %rax,%rax
  8037ba:	75 b1                	jne    80376d <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c0:	48 f7 d8             	neg    %rax
  8037c3:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d9:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037dd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037e0:	83 c2 01             	add    $0x1,%edx
  8037e3:	c1 e2 03             	shl    $0x3,%edx
  8037e6:	48 63 d2             	movslq %edx,%rdx
  8037e9:	48 f7 da             	neg    %rdx
  8037ec:	48 01 d0             	add    %rdx,%rax
  8037ef:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8037f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f7:	48 83 e8 10          	sub    $0x10,%rax
  8037fb:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803801:	77 0a                	ja     80380d <init_stack+0xc4>
		return -E_NO_MEM;
  803803:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803808:	e9 e3 01 00 00       	jmpq   8039f0 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80380d:	ba 07 00 00 00       	mov    $0x7,%edx
  803812:	be 00 00 40 00       	mov    $0x400000,%esi
  803817:	bf 00 00 00 00       	mov    $0x0,%edi
  80381c:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80382b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80382f:	79 08                	jns    803839 <init_stack+0xf0>
		return r;
  803831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803834:	e9 b7 01 00 00       	jmpq   8039f0 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803839:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803840:	e9 8a 00 00 00       	jmpq   8038cf <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803845:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803848:	48 98                	cltq   
  80384a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803851:	00 
  803852:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803856:	48 01 c2             	add    %rax,%rdx
  803859:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80385e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803862:	48 01 c8             	add    %rcx,%rax
  803865:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80386b:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80386e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803871:	48 98                	cltq   
  803873:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80387a:	00 
  80387b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80387f:	48 01 d0             	add    %rdx,%rax
  803882:	48 8b 10             	mov    (%rax),%rdx
  803885:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803889:	48 89 d6             	mov    %rdx,%rsi
  80388c:	48 89 c7             	mov    %rax,%rdi
  80388f:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80389b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80389e:	48 98                	cltq   
  8038a0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038a7:	00 
  8038a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038ac:	48 01 d0             	add    %rdx,%rax
  8038af:	48 8b 00             	mov    (%rax),%rax
  8038b2:	48 89 c7             	mov    %rax,%rdi
  8038b5:	48 b8 d2 14 80 00 00 	movabs $0x8014d2,%rax
  8038bc:	00 00 00 
  8038bf:	ff d0                	callq  *%rax
  8038c1:	48 98                	cltq   
  8038c3:	48 83 c0 01          	add    $0x1,%rax
  8038c7:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038cb:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038cf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038d2:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038d5:	0f 8c 6a ff ff ff    	jl     803845 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038de:	48 98                	cltq   
  8038e0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038e7:	00 
  8038e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ec:	48 01 d0             	add    %rdx,%rax
  8038ef:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038f6:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038fd:	00 
  8038fe:	74 35                	je     803935 <init_stack+0x1ec>
  803900:	48 b9 e8 50 80 00 00 	movabs $0x8050e8,%rcx
  803907:	00 00 00 
  80390a:	48 ba 0e 51 80 00 00 	movabs $0x80510e,%rdx
  803911:	00 00 00 
  803914:	be f1 00 00 00       	mov    $0xf1,%esi
  803919:	48 bf a8 50 80 00 00 	movabs $0x8050a8,%rdi
  803920:	00 00 00 
  803923:	b8 00 00 00 00       	mov    $0x0,%eax
  803928:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  80392f:	00 00 00 
  803932:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803935:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803939:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80393d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803942:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803946:	48 01 c8             	add    %rcx,%rax
  803949:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80394f:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803952:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803956:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80395a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80395d:	48 98                	cltq   
  80395f:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803962:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803967:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80396b:	48 01 d0             	add    %rdx,%rax
  80396e:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803974:	48 89 c2             	mov    %rax,%rdx
  803977:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80397b:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80397e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803981:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803987:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80398c:	89 c2                	mov    %eax,%edx
  80398e:	be 00 00 40 00       	mov    $0x400000,%esi
  803993:	bf 00 00 00 00       	mov    $0x0,%edi
  803998:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
  8039a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039ab:	79 02                	jns    8039af <init_stack+0x266>
		goto error;
  8039ad:	eb 28                	jmp    8039d7 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8039af:	be 00 00 40 00       	mov    $0x400000,%esi
  8039b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b9:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
  8039c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039cc:	79 02                	jns    8039d0 <init_stack+0x287>
		goto error;
  8039ce:	eb 07                	jmp    8039d7 <init_stack+0x28e>

	return 0;
  8039d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d5:	eb 19                	jmp    8039f0 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8039d7:	be 00 00 40 00       	mov    $0x400000,%esi
  8039dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e1:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
	return r;
  8039ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039f0:	c9                   	leaveq 
  8039f1:	c3                   	retq   

00000000008039f2 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039f2:	55                   	push   %rbp
  8039f3:	48 89 e5             	mov    %rsp,%rbp
  8039f6:	48 83 ec 50          	sub    $0x50,%rsp
  8039fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a01:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803a05:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803a08:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803a0c:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803a10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a14:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a20:	74 21                	je     803a43 <map_segment+0x51>
		va -= i;
  803a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a25:	48 98                	cltq   
  803a27:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2e:	48 98                	cltq   
  803a30:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a37:	48 98                	cltq   
  803a39:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a40:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a4a:	e9 79 01 00 00       	jmpq   803bc8 <map_segment+0x1d6>
		if (i >= filesz) {
  803a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a52:	48 98                	cltq   
  803a54:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a58:	72 3c                	jb     803a96 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	48 63 d0             	movslq %eax,%rdx
  803a60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a64:	48 01 d0             	add    %rdx,%rax
  803a67:	48 89 c1             	mov    %rax,%rcx
  803a6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a6d:	8b 55 10             	mov    0x10(%rbp),%edx
  803a70:	48 89 ce             	mov    %rcx,%rsi
  803a73:	89 c7                	mov    %eax,%edi
  803a75:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803a7c:	00 00 00 
  803a7f:	ff d0                	callq  *%rax
  803a81:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a84:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a88:	0f 89 33 01 00 00    	jns    803bc1 <map_segment+0x1cf>
				return r;
  803a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a91:	e9 46 01 00 00       	jmpq   803bdc <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a96:	ba 07 00 00 00       	mov    $0x7,%edx
  803a9b:	be 00 00 40 00       	mov    $0x400000,%esi
  803aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa5:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
  803ab1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ab4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ab8:	79 08                	jns    803ac2 <map_segment+0xd0>
				return r;
  803aba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abd:	e9 1a 01 00 00       	jmpq   803bdc <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac5:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803ac8:	01 c2                	add    %eax,%edx
  803aca:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803acd:	89 d6                	mov    %edx,%esi
  803acf:	89 c7                	mov    %eax,%edi
  803ad1:	48 b8 c0 28 80 00 00 	movabs $0x8028c0,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
  803add:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ae0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ae4:	79 08                	jns    803aee <map_segment+0xfc>
				return r;
  803ae6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae9:	e9 ee 00 00 00       	jmpq   803bdc <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803aee:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af8:	48 98                	cltq   
  803afa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803afe:	48 29 c2             	sub    %rax,%rdx
  803b01:	48 89 d0             	mov    %rdx,%rax
  803b04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b08:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b0b:	48 63 d0             	movslq %eax,%rdx
  803b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b12:	48 39 c2             	cmp    %rax,%rdx
  803b15:	48 0f 47 d0          	cmova  %rax,%rdx
  803b19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b1c:	be 00 00 40 00       	mov    $0x400000,%esi
  803b21:	89 c7                	mov    %eax,%edi
  803b23:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  803b2a:	00 00 00 
  803b2d:	ff d0                	callq  *%rax
  803b2f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b32:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b36:	79 08                	jns    803b40 <map_segment+0x14e>
				return r;
  803b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b3b:	e9 9c 00 00 00       	jmpq   803bdc <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b43:	48 63 d0             	movslq %eax,%rdx
  803b46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b4a:	48 01 d0             	add    %rdx,%rax
  803b4d:	48 89 c2             	mov    %rax,%rdx
  803b50:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b53:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b57:	48 89 d1             	mov    %rdx,%rcx
  803b5a:	89 c2                	mov    %eax,%edx
  803b5c:	be 00 00 40 00       	mov    $0x400000,%esi
  803b61:	bf 00 00 00 00       	mov    $0x0,%edi
  803b66:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
  803b72:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b75:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b79:	79 30                	jns    803bab <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803b7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7e:	89 c1                	mov    %eax,%ecx
  803b80:	48 ba 23 51 80 00 00 	movabs $0x805123,%rdx
  803b87:	00 00 00 
  803b8a:	be 24 01 00 00       	mov    $0x124,%esi
  803b8f:	48 bf a8 50 80 00 00 	movabs $0x8050a8,%rdi
  803b96:	00 00 00 
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  803ba5:	00 00 00 
  803ba8:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803bab:	be 00 00 40 00       	mov    $0x400000,%esi
  803bb0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb5:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803bc1:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcb:	48 98                	cltq   
  803bcd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bd1:	0f 82 78 fe ff ff    	jb     803a4f <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	48 83 ec 20          	sub    $0x20,%rsp
  803be6:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803be9:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803bf0:	00 
  803bf1:	e9 c9 00 00 00       	jmpq   803cbf <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bfa:	48 c1 e8 27          	shr    $0x27,%rax
  803bfe:	48 89 c2             	mov    %rax,%rdx
  803c01:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803c08:	01 00 00 
  803c0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0f:	48 85 c0             	test   %rax,%rax
  803c12:	74 3c                	je     803c50 <copy_shared_pages+0x72>
  803c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c18:	48 c1 e8 1e          	shr    $0x1e,%rax
  803c1c:	48 89 c2             	mov    %rax,%rdx
  803c1f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c26:	01 00 00 
  803c29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2d:	48 85 c0             	test   %rax,%rax
  803c30:	74 1e                	je     803c50 <copy_shared_pages+0x72>
  803c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c36:	48 c1 e8 15          	shr    $0x15,%rax
  803c3a:	48 89 c2             	mov    %rax,%rdx
  803c3d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c44:	01 00 00 
  803c47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4b:	48 85 c0             	test   %rax,%rax
  803c4e:	75 02                	jne    803c52 <copy_shared_pages+0x74>
                continue;
  803c50:	eb 65                	jmp    803cb7 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803c52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c56:	48 c1 e8 0c          	shr    $0xc,%rax
  803c5a:	48 89 c2             	mov    %rax,%rdx
  803c5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c64:	01 00 00 
  803c67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c6b:	25 00 04 00 00       	and    $0x400,%eax
  803c70:	48 85 c0             	test   %rax,%rax
  803c73:	74 42                	je     803cb7 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c79:	48 c1 e8 0c          	shr    $0xc,%rax
  803c7d:	48 89 c2             	mov    %rax,%rdx
  803c80:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c87:	01 00 00 
  803c8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c8e:	25 07 0e 00 00       	and    $0xe07,%eax
  803c93:	89 c6                	mov    %eax,%esi
  803c95:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c9d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ca0:	41 89 f0             	mov    %esi,%r8d
  803ca3:	48 89 c6             	mov    %rax,%rsi
  803ca6:	bf 00 00 00 00       	mov    $0x0,%edi
  803cab:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  803cb2:	00 00 00 
  803cb5:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803cb7:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803cbe:	00 
  803cbf:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803cc6:	00 00 00 
  803cc9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803ccd:	0f 86 23 ff ff ff    	jbe    803bf6 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803cd8:	c9                   	leaveq 
  803cd9:	c3                   	retq   

0000000000803cda <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cda:	55                   	push   %rbp
  803cdb:	48 89 e5             	mov    %rsp,%rbp
  803cde:	53                   	push   %rbx
  803cdf:	48 83 ec 38          	sub    $0x38,%rsp
  803ce3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ce7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ceb:	48 89 c7             	mov    %rax,%rdi
  803cee:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d01:	0f 88 bf 01 00 00    	js     803ec6 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0b:	ba 07 04 00 00       	mov    $0x407,%edx
  803d10:	48 89 c6             	mov    %rax,%rsi
  803d13:	bf 00 00 00 00       	mov    $0x0,%edi
  803d18:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803d1f:	00 00 00 
  803d22:	ff d0                	callq  *%rax
  803d24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d2b:	0f 88 95 01 00 00    	js     803ec6 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d35:	48 89 c7             	mov    %rax,%rdi
  803d38:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  803d3f:	00 00 00 
  803d42:	ff d0                	callq  *%rax
  803d44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d4b:	0f 88 5d 01 00 00    	js     803eae <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d55:	ba 07 04 00 00       	mov    $0x407,%edx
  803d5a:	48 89 c6             	mov    %rax,%rsi
  803d5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d62:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803d69:	00 00 00 
  803d6c:	ff d0                	callq  *%rax
  803d6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d71:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d75:	0f 88 33 01 00 00    	js     803eae <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
  803d8e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d96:	ba 07 04 00 00       	mov    $0x407,%edx
  803d9b:	48 89 c6             	mov    %rax,%rsi
  803d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803da3:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
  803daf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db6:	79 05                	jns    803dbd <pipe+0xe3>
		goto err2;
  803db8:	e9 d9 00 00 00       	jmpq   803e96 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dbd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc1:	48 89 c7             	mov    %rax,%rdi
  803dc4:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803dcb:	00 00 00 
  803dce:	ff d0                	callq  *%rax
  803dd0:	48 89 c2             	mov    %rax,%rdx
  803dd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ddd:	48 89 d1             	mov    %rdx,%rcx
  803de0:	ba 00 00 00 00       	mov    $0x0,%edx
  803de5:	48 89 c6             	mov    %rax,%rsi
  803de8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ded:	48 b8 bd 1e 80 00 00 	movabs $0x801ebd,%rax
  803df4:	00 00 00 
  803df7:	ff d0                	callq  *%rax
  803df9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e00:	79 1b                	jns    803e1d <pipe+0x143>
		goto err3;
  803e02:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e07:	48 89 c6             	mov    %rax,%rsi
  803e0a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0f:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  803e16:	00 00 00 
  803e19:	ff d0                	callq  *%rax
  803e1b:	eb 79                	jmp    803e96 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e21:	48 ba 80 78 80 00 00 	movabs $0x807880,%rdx
  803e28:	00 00 00 
  803e2b:	8b 12                	mov    (%rdx),%edx
  803e2d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3e:	48 ba 80 78 80 00 00 	movabs $0x807880,%rdx
  803e45:	00 00 00 
  803e48:	8b 12                	mov    (%rdx),%edx
  803e4a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e50:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5b:	48 89 c7             	mov    %rax,%rdi
  803e5e:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
  803e6a:	89 c2                	mov    %eax,%edx
  803e6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e70:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e76:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e7e:	48 89 c7             	mov    %rax,%rdi
  803e81:	48 b8 bd 21 80 00 00 	movabs $0x8021bd,%rax
  803e88:	00 00 00 
  803e8b:	ff d0                	callq  *%rax
  803e8d:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e94:	eb 33                	jmp    803ec9 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9a:	48 89 c6             	mov    %rax,%rsi
  803e9d:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea2:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  803ea9:	00 00 00 
  803eac:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb2:	48 89 c6             	mov    %rax,%rsi
  803eb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803eba:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  803ec1:	00 00 00 
  803ec4:	ff d0                	callq  *%rax
err:
	return r;
  803ec6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ec9:	48 83 c4 38          	add    $0x38,%rsp
  803ecd:	5b                   	pop    %rbx
  803ece:	5d                   	pop    %rbp
  803ecf:	c3                   	retq   

0000000000803ed0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ed0:	55                   	push   %rbp
  803ed1:	48 89 e5             	mov    %rsp,%rbp
  803ed4:	53                   	push   %rbx
  803ed5:	48 83 ec 28          	sub    $0x28,%rsp
  803ed9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803edd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ee1:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803ee8:	00 00 00 
  803eeb:	48 8b 00             	mov    (%rax),%rax
  803eee:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ef4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ef7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803efb:	48 89 c7             	mov    %rax,%rdi
  803efe:	48 b8 75 48 80 00 00 	movabs $0x804875,%rax
  803f05:	00 00 00 
  803f08:	ff d0                	callq  *%rax
  803f0a:	89 c3                	mov    %eax,%ebx
  803f0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f10:	48 89 c7             	mov    %rax,%rdi
  803f13:	48 b8 75 48 80 00 00 	movabs $0x804875,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
  803f1f:	39 c3                	cmp    %eax,%ebx
  803f21:	0f 94 c0             	sete   %al
  803f24:	0f b6 c0             	movzbl %al,%eax
  803f27:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f2a:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803f31:	00 00 00 
  803f34:	48 8b 00             	mov    (%rax),%rax
  803f37:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f3d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f43:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f46:	75 05                	jne    803f4d <_pipeisclosed+0x7d>
			return ret;
  803f48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f4b:	eb 4f                	jmp    803f9c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f50:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f53:	74 42                	je     803f97 <_pipeisclosed+0xc7>
  803f55:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f59:	75 3c                	jne    803f97 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f5b:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803f62:	00 00 00 
  803f65:	48 8b 00             	mov    (%rax),%rax
  803f68:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f6e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f74:	89 c6                	mov    %eax,%esi
  803f76:	48 bf 4a 51 80 00 00 	movabs $0x80514a,%rdi
  803f7d:	00 00 00 
  803f80:	b8 00 00 00 00       	mov    $0x0,%eax
  803f85:	49 b8 89 09 80 00 00 	movabs $0x800989,%r8
  803f8c:	00 00 00 
  803f8f:	41 ff d0             	callq  *%r8
	}
  803f92:	e9 4a ff ff ff       	jmpq   803ee1 <_pipeisclosed+0x11>
  803f97:	e9 45 ff ff ff       	jmpq   803ee1 <_pipeisclosed+0x11>
}
  803f9c:	48 83 c4 28          	add    $0x28,%rsp
  803fa0:	5b                   	pop    %rbx
  803fa1:	5d                   	pop    %rbp
  803fa2:	c3                   	retq   

0000000000803fa3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fa3:	55                   	push   %rbp
  803fa4:	48 89 e5             	mov    %rsp,%rbp
  803fa7:	48 83 ec 30          	sub    $0x30,%rsp
  803fab:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fb2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fb5:	48 89 d6             	mov    %rdx,%rsi
  803fb8:	89 c7                	mov    %eax,%edi
  803fba:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
  803fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcd:	79 05                	jns    803fd4 <pipeisclosed+0x31>
		return r;
  803fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd2:	eb 31                	jmp    804005 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd8:	48 89 c7             	mov    %rax,%rdi
  803fdb:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  803fe2:	00 00 00 
  803fe5:	ff d0                	callq  *%rax
  803fe7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ff3:	48 89 d6             	mov    %rdx,%rsi
  803ff6:	48 89 c7             	mov    %rax,%rdi
  803ff9:	48 b8 d0 3e 80 00 00 	movabs $0x803ed0,%rax
  804000:	00 00 00 
  804003:	ff d0                	callq  *%rax
}
  804005:	c9                   	leaveq 
  804006:	c3                   	retq   

0000000000804007 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804007:	55                   	push   %rbp
  804008:	48 89 e5             	mov    %rsp,%rbp
  80400b:	48 83 ec 40          	sub    $0x40,%rsp
  80400f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804013:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804017:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80401b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80401f:	48 89 c7             	mov    %rax,%rdi
  804022:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804032:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804036:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80403a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804041:	00 
  804042:	e9 92 00 00 00       	jmpq   8040d9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804047:	eb 41                	jmp    80408a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804049:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80404e:	74 09                	je     804059 <devpipe_read+0x52>
				return i;
  804050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804054:	e9 92 00 00 00       	jmpq   8040eb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804059:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804061:	48 89 d6             	mov    %rdx,%rsi
  804064:	48 89 c7             	mov    %rax,%rdi
  804067:	48 b8 d0 3e 80 00 00 	movabs $0x803ed0,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
  804073:	85 c0                	test   %eax,%eax
  804075:	74 07                	je     80407e <devpipe_read+0x77>
				return 0;
  804077:	b8 00 00 00 00       	mov    $0x0,%eax
  80407c:	eb 6d                	jmp    8040eb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80407e:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  804085:	00 00 00 
  804088:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80408a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408e:	8b 10                	mov    (%rax),%edx
  804090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804094:	8b 40 04             	mov    0x4(%rax),%eax
  804097:	39 c2                	cmp    %eax,%edx
  804099:	74 ae                	je     804049 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80409b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040a3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ab:	8b 00                	mov    (%rax),%eax
  8040ad:	99                   	cltd   
  8040ae:	c1 ea 1b             	shr    $0x1b,%edx
  8040b1:	01 d0                	add    %edx,%eax
  8040b3:	83 e0 1f             	and    $0x1f,%eax
  8040b6:	29 d0                	sub    %edx,%eax
  8040b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040bc:	48 98                	cltq   
  8040be:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040c3:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c9:	8b 00                	mov    (%rax),%eax
  8040cb:	8d 50 01             	lea    0x1(%rax),%edx
  8040ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040dd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040e1:	0f 82 60 ff ff ff    	jb     804047 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040eb:	c9                   	leaveq 
  8040ec:	c3                   	retq   

00000000008040ed <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040ed:	55                   	push   %rbp
  8040ee:	48 89 e5             	mov    %rsp,%rbp
  8040f1:	48 83 ec 40          	sub    $0x40,%rsp
  8040f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040fd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804101:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804105:	48 89 c7             	mov    %rax,%rdi
  804108:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
  804114:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804118:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804120:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804127:	00 
  804128:	e9 8e 00 00 00       	jmpq   8041bb <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80412d:	eb 31                	jmp    804160 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80412f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804133:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804137:	48 89 d6             	mov    %rdx,%rsi
  80413a:	48 89 c7             	mov    %rax,%rdi
  80413d:	48 b8 d0 3e 80 00 00 	movabs $0x803ed0,%rax
  804144:	00 00 00 
  804147:	ff d0                	callq  *%rax
  804149:	85 c0                	test   %eax,%eax
  80414b:	74 07                	je     804154 <devpipe_write+0x67>
				return 0;
  80414d:	b8 00 00 00 00       	mov    $0x0,%eax
  804152:	eb 79                	jmp    8041cd <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804154:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  80415b:	00 00 00 
  80415e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804164:	8b 40 04             	mov    0x4(%rax),%eax
  804167:	48 63 d0             	movslq %eax,%rdx
  80416a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416e:	8b 00                	mov    (%rax),%eax
  804170:	48 98                	cltq   
  804172:	48 83 c0 20          	add    $0x20,%rax
  804176:	48 39 c2             	cmp    %rax,%rdx
  804179:	73 b4                	jae    80412f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80417b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417f:	8b 40 04             	mov    0x4(%rax),%eax
  804182:	99                   	cltd   
  804183:	c1 ea 1b             	shr    $0x1b,%edx
  804186:	01 d0                	add    %edx,%eax
  804188:	83 e0 1f             	and    $0x1f,%eax
  80418b:	29 d0                	sub    %edx,%eax
  80418d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804191:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804195:	48 01 ca             	add    %rcx,%rdx
  804198:	0f b6 0a             	movzbl (%rdx),%ecx
  80419b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80419f:	48 98                	cltq   
  8041a1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a9:	8b 40 04             	mov    0x4(%rax),%eax
  8041ac:	8d 50 01             	lea    0x1(%rax),%edx
  8041af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041b6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041c3:	0f 82 64 ff ff ff    	jb     80412d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041cd:	c9                   	leaveq 
  8041ce:	c3                   	retq   

00000000008041cf <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041cf:	55                   	push   %rbp
  8041d0:	48 89 e5             	mov    %rsp,%rbp
  8041d3:	48 83 ec 20          	sub    $0x20,%rsp
  8041d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e3:	48 89 c7             	mov    %rax,%rdi
  8041e6:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  8041ed:	00 00 00 
  8041f0:	ff d0                	callq  *%rax
  8041f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041fa:	48 be 5d 51 80 00 00 	movabs $0x80515d,%rsi
  804201:	00 00 00 
  804204:	48 89 c7             	mov    %rax,%rdi
  804207:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  80420e:	00 00 00 
  804211:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804217:	8b 50 04             	mov    0x4(%rax),%edx
  80421a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421e:	8b 00                	mov    (%rax),%eax
  804220:	29 c2                	sub    %eax,%edx
  804222:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804226:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80422c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804230:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804237:	00 00 00 
	stat->st_dev = &devpipe;
  80423a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80423e:	48 b9 80 78 80 00 00 	movabs $0x807880,%rcx
  804245:	00 00 00 
  804248:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80424f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804254:	c9                   	leaveq 
  804255:	c3                   	retq   

0000000000804256 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804256:	55                   	push   %rbp
  804257:	48 89 e5             	mov    %rsp,%rbp
  80425a:	48 83 ec 10          	sub    $0x10,%rsp
  80425e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804266:	48 89 c6             	mov    %rax,%rsi
  804269:	bf 00 00 00 00       	mov    $0x0,%edi
  80426e:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  804275:	00 00 00 
  804278:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80427a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427e:	48 89 c7             	mov    %rax,%rdi
  804281:	48 b8 e0 21 80 00 00 	movabs $0x8021e0,%rax
  804288:	00 00 00 
  80428b:	ff d0                	callq  *%rax
  80428d:	48 89 c6             	mov    %rax,%rsi
  804290:	bf 00 00 00 00       	mov    $0x0,%edi
  804295:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
}
  8042a1:	c9                   	leaveq 
  8042a2:	c3                   	retq   

00000000008042a3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8042a3:	55                   	push   %rbp
  8042a4:	48 89 e5             	mov    %rsp,%rbp
  8042a7:	48 83 ec 20          	sub    $0x20,%rsp
  8042ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8042ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042b2:	75 35                	jne    8042e9 <wait+0x46>
  8042b4:	48 b9 64 51 80 00 00 	movabs $0x805164,%rcx
  8042bb:	00 00 00 
  8042be:	48 ba 6f 51 80 00 00 	movabs $0x80516f,%rdx
  8042c5:	00 00 00 
  8042c8:	be 09 00 00 00       	mov    $0x9,%esi
  8042cd:	48 bf 84 51 80 00 00 	movabs $0x805184,%rdi
  8042d4:	00 00 00 
  8042d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8042dc:	49 b8 50 07 80 00 00 	movabs $0x800750,%r8
  8042e3:	00 00 00 
  8042e6:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8042e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8042f1:	48 98                	cltq   
  8042f3:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8042fa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804301:	00 00 00 
  804304:	48 01 d0             	add    %rdx,%rax
  804307:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80430b:	eb 0c                	jmp    804319 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  80430d:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  804314:	00 00 00 
  804317:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80431d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804323:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804326:	75 0e                	jne    804336 <wait+0x93>
  804328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80432c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804332:	85 c0                	test   %eax,%eax
  804334:	75 d7                	jne    80430d <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804336:	c9                   	leaveq 
  804337:	c3                   	retq   

0000000000804338 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804338:	55                   	push   %rbp
  804339:	48 89 e5             	mov    %rsp,%rbp
  80433c:	48 83 ec 30          	sub    $0x30,%rsp
  804340:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804344:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804348:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80434c:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804353:	00 00 00 
  804356:	48 8b 00             	mov    (%rax),%rax
  804359:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80435f:	85 c0                	test   %eax,%eax
  804361:	75 34                	jne    804397 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  804363:	48 b8 f1 1d 80 00 00 	movabs $0x801df1,%rax
  80436a:	00 00 00 
  80436d:	ff d0                	callq  *%rax
  80436f:	25 ff 03 00 00       	and    $0x3ff,%eax
  804374:	48 98                	cltq   
  804376:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80437d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804384:	00 00 00 
  804387:	48 01 c2             	add    %rax,%rdx
  80438a:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804391:	00 00 00 
  804394:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804397:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80439c:	75 0e                	jne    8043ac <ipc_recv+0x74>
		pg = (void*) UTOP;
  80439e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8043a5:	00 00 00 
  8043a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8043ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b0:	48 89 c7             	mov    %rax,%rdi
  8043b3:	48 b8 96 20 80 00 00 	movabs $0x802096,%rax
  8043ba:	00 00 00 
  8043bd:	ff d0                	callq  *%rax
  8043bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8043c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043c6:	79 19                	jns    8043e1 <ipc_recv+0xa9>
		*from_env_store = 0;
  8043c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043cc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8043d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8043dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043df:	eb 53                	jmp    804434 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8043e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043e6:	74 19                	je     804401 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8043e8:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8043ef:	00 00 00 
  8043f2:	48 8b 00             	mov    (%rax),%rax
  8043f5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8043fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ff:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804401:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804406:	74 19                	je     804421 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804408:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80440f:	00 00 00 
  804412:	48 8b 00             	mov    (%rax),%rax
  804415:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80441b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80441f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804421:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804428:	00 00 00 
  80442b:	48 8b 00             	mov    (%rax),%rax
  80442e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804434:	c9                   	leaveq 
  804435:	c3                   	retq   

0000000000804436 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804436:	55                   	push   %rbp
  804437:	48 89 e5             	mov    %rsp,%rbp
  80443a:	48 83 ec 30          	sub    $0x30,%rsp
  80443e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804441:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804444:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804448:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80444b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804450:	75 0e                	jne    804460 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804452:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804459:	00 00 00 
  80445c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804460:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804463:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804466:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80446a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80446d:	89 c7                	mov    %eax,%edi
  80446f:	48 b8 41 20 80 00 00 	movabs $0x802041,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
  80447b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80447e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804482:	75 0c                	jne    804490 <ipc_send+0x5a>
			sys_yield();
  804484:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  80448b:	00 00 00 
  80448e:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804490:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804494:	74 ca                	je     804460 <ipc_send+0x2a>
	if(result != 0)
  804496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80449a:	74 20                	je     8044bc <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80449c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449f:	89 c6                	mov    %eax,%esi
  8044a1:	48 bf 90 51 80 00 00 	movabs $0x805190,%rdi
  8044a8:	00 00 00 
  8044ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b0:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  8044b7:	00 00 00 
  8044ba:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8044bc:	c9                   	leaveq 
  8044bd:	c3                   	retq   

00000000008044be <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8044be:	55                   	push   %rbp
  8044bf:	48 89 e5             	mov    %rsp,%rbp
  8044c2:	53                   	push   %rbx
  8044c3:	48 83 ec 58          	sub    $0x58,%rsp
  8044c7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  8044cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8044cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  8044d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8044da:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8044e1:	00 
  8044e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044e6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8044ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044ee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8044f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8044fa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8044fe:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804506:	48 c1 e8 27          	shr    $0x27,%rax
  80450a:	48 89 c2             	mov    %rax,%rdx
  80450d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804514:	01 00 00 
  804517:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80451b:	83 e0 01             	and    $0x1,%eax
  80451e:	48 85 c0             	test   %rax,%rax
  804521:	0f 85 91 00 00 00    	jne    8045b8 <ipc_host_recv+0xfa>
  804527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80452b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80452f:	48 89 c2             	mov    %rax,%rdx
  804532:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804539:	01 00 00 
  80453c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804540:	83 e0 01             	and    $0x1,%eax
  804543:	48 85 c0             	test   %rax,%rax
  804546:	74 70                	je     8045b8 <ipc_host_recv+0xfa>
  804548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80454c:	48 c1 e8 15          	shr    $0x15,%rax
  804550:	48 89 c2             	mov    %rax,%rdx
  804553:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80455a:	01 00 00 
  80455d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804561:	83 e0 01             	and    $0x1,%eax
  804564:	48 85 c0             	test   %rax,%rax
  804567:	74 4f                	je     8045b8 <ipc_host_recv+0xfa>
  804569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80456d:	48 c1 e8 0c          	shr    $0xc,%rax
  804571:	48 89 c2             	mov    %rax,%rdx
  804574:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80457b:	01 00 00 
  80457e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804582:	83 e0 01             	and    $0x1,%eax
  804585:	48 85 c0             	test   %rax,%rax
  804588:	74 2e                	je     8045b8 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80458a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80458e:	ba 07 04 00 00       	mov    $0x407,%edx
  804593:	48 89 c6             	mov    %rax,%rsi
  804596:	bf 00 00 00 00       	mov    $0x0,%edi
  80459b:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8045a2:	00 00 00 
  8045a5:	ff d0                	callq  *%rax
  8045a7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8045aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8045ae:	79 08                	jns    8045b8 <ipc_host_recv+0xfa>
	    	return result;
  8045b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045b3:	e9 84 00 00 00       	jmpq   80463c <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8045b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8045c0:	48 89 c2             	mov    %rax,%rdx
  8045c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8045ca:	01 00 00 
  8045cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045d1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8045d7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8045db:	b8 03 00 00 00       	mov    $0x3,%eax
  8045e0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8045e4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8045e8:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8045ec:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8045f0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8045f4:	4c 89 c3             	mov    %r8,%rbx
  8045f7:	0f 01 c1             	vmcall 
  8045fa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  8045fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804601:	7e 36                	jle    804639 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  804603:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804606:	41 89 c0             	mov    %eax,%r8d
  804609:	b9 03 00 00 00       	mov    $0x3,%ecx
  80460e:	48 ba a8 51 80 00 00 	movabs $0x8051a8,%rdx
  804615:	00 00 00 
  804618:	be 67 00 00 00       	mov    $0x67,%esi
  80461d:	48 bf d5 51 80 00 00 	movabs $0x8051d5,%rdi
  804624:	00 00 00 
  804627:	b8 00 00 00 00       	mov    $0x0,%eax
  80462c:	49 b9 50 07 80 00 00 	movabs $0x800750,%r9
  804633:	00 00 00 
  804636:	41 ff d1             	callq  *%r9
	return result;
  804639:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  80463c:	48 83 c4 58          	add    $0x58,%rsp
  804640:	5b                   	pop    %rbx
  804641:	5d                   	pop    %rbp
  804642:	c3                   	retq   

0000000000804643 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804643:	55                   	push   %rbp
  804644:	48 89 e5             	mov    %rsp,%rbp
  804647:	53                   	push   %rbx
  804648:	48 83 ec 68          	sub    $0x68,%rsp
  80464c:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80464f:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804652:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804656:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804659:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80465d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  804661:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804668:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80466f:	00 
  804670:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804674:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804678:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80467c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804684:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804688:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80468c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804690:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804694:	48 c1 e8 27          	shr    $0x27,%rax
  804698:	48 89 c2             	mov    %rax,%rdx
  80469b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8046a2:	01 00 00 
  8046a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046a9:	83 e0 01             	and    $0x1,%eax
  8046ac:	48 85 c0             	test   %rax,%rax
  8046af:	0f 85 88 00 00 00    	jne    80473d <ipc_host_send+0xfa>
  8046b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046b9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8046bd:	48 89 c2             	mov    %rax,%rdx
  8046c0:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8046c7:	01 00 00 
  8046ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046ce:	83 e0 01             	and    $0x1,%eax
  8046d1:	48 85 c0             	test   %rax,%rax
  8046d4:	74 67                	je     80473d <ipc_host_send+0xfa>
  8046d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046da:	48 c1 e8 15          	shr    $0x15,%rax
  8046de:	48 89 c2             	mov    %rax,%rdx
  8046e1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046e8:	01 00 00 
  8046eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046ef:	83 e0 01             	and    $0x1,%eax
  8046f2:	48 85 c0             	test   %rax,%rax
  8046f5:	74 46                	je     80473d <ipc_host_send+0xfa>
  8046f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8046ff:	48 89 c2             	mov    %rax,%rdx
  804702:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804709:	01 00 00 
  80470c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804710:	83 e0 01             	and    $0x1,%eax
  804713:	48 85 c0             	test   %rax,%rax
  804716:	74 25                	je     80473d <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804718:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80471c:	48 c1 e8 0c          	shr    $0xc,%rax
  804720:	48 89 c2             	mov    %rax,%rdx
  804723:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80472a:	01 00 00 
  80472d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804731:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804737:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80473b:	eb 0e                	jmp    80474b <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80473d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804744:	00 00 00 
  804747:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  80474b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80474f:	48 89 c6             	mov    %rax,%rsi
  804752:	48 bf df 51 80 00 00 	movabs $0x8051df,%rdi
  804759:	00 00 00 
  80475c:	b8 00 00 00 00       	mov    $0x0,%eax
  804761:	48 ba 89 09 80 00 00 	movabs $0x800989,%rdx
  804768:	00 00 00 
  80476b:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80476d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  804770:	48 98                	cltq   
  804772:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804776:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804779:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80477d:	8b 45 9c             	mov    -0x64(%rbp),%eax
  804780:	48 98                	cltq   
  804782:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  804786:	b8 02 00 00 00       	mov    $0x2,%eax
  80478b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80478f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804793:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  804797:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80479b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80479f:	4c 89 c3             	mov    %r8,%rbx
  8047a2:	0f 01 c1             	vmcall 
  8047a5:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  8047a8:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8047ac:	75 0c                	jne    8047ba <ipc_host_send+0x177>
			sys_yield();
  8047ae:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  8047b5:	00 00 00 
  8047b8:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8047ba:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8047be:	74 c6                	je     804786 <ipc_host_send+0x143>
	
	if(result !=0)
  8047c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8047c4:	74 36                	je     8047fc <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  8047c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8047c9:	41 89 c0             	mov    %eax,%r8d
  8047cc:	b9 02 00 00 00       	mov    $0x2,%ecx
  8047d1:	48 ba a8 51 80 00 00 	movabs $0x8051a8,%rdx
  8047d8:	00 00 00 
  8047db:	be 94 00 00 00       	mov    $0x94,%esi
  8047e0:	48 bf d5 51 80 00 00 	movabs $0x8051d5,%rdi
  8047e7:	00 00 00 
  8047ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ef:	49 b9 50 07 80 00 00 	movabs $0x800750,%r9
  8047f6:	00 00 00 
  8047f9:	41 ff d1             	callq  *%r9
}
  8047fc:	48 83 c4 68          	add    $0x68,%rsp
  804800:	5b                   	pop    %rbx
  804801:	5d                   	pop    %rbp
  804802:	c3                   	retq   

0000000000804803 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804803:	55                   	push   %rbp
  804804:	48 89 e5             	mov    %rsp,%rbp
  804807:	48 83 ec 14          	sub    $0x14,%rsp
  80480b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80480e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804815:	eb 4e                	jmp    804865 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804817:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80481e:	00 00 00 
  804821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804824:	48 98                	cltq   
  804826:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80482d:	48 01 d0             	add    %rdx,%rax
  804830:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804836:	8b 00                	mov    (%rax),%eax
  804838:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80483b:	75 24                	jne    804861 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80483d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804844:	00 00 00 
  804847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484a:	48 98                	cltq   
  80484c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804853:	48 01 d0             	add    %rdx,%rax
  804856:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80485c:	8b 40 08             	mov    0x8(%rax),%eax
  80485f:	eb 12                	jmp    804873 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804861:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804865:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80486c:	7e a9                	jle    804817 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80486e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804873:	c9                   	leaveq 
  804874:	c3                   	retq   

0000000000804875 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804875:	55                   	push   %rbp
  804876:	48 89 e5             	mov    %rsp,%rbp
  804879:	48 83 ec 18          	sub    $0x18,%rsp
  80487d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804885:	48 c1 e8 15          	shr    $0x15,%rax
  804889:	48 89 c2             	mov    %rax,%rdx
  80488c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804893:	01 00 00 
  804896:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80489a:	83 e0 01             	and    $0x1,%eax
  80489d:	48 85 c0             	test   %rax,%rax
  8048a0:	75 07                	jne    8048a9 <pageref+0x34>
		return 0;
  8048a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a7:	eb 53                	jmp    8048fc <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8048b1:	48 89 c2             	mov    %rax,%rdx
  8048b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048bb:	01 00 00 
  8048be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048ca:	83 e0 01             	and    $0x1,%eax
  8048cd:	48 85 c0             	test   %rax,%rax
  8048d0:	75 07                	jne    8048d9 <pageref+0x64>
		return 0;
  8048d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048d7:	eb 23                	jmp    8048fc <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8048e1:	48 89 c2             	mov    %rax,%rdx
  8048e4:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048eb:	00 00 00 
  8048ee:	48 c1 e2 04          	shl    $0x4,%rdx
  8048f2:	48 01 d0             	add    %rdx,%rax
  8048f5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8048f9:	0f b7 c0             	movzwl %ax,%eax
}
  8048fc:	c9                   	leaveq 
  8048fd:	c3                   	retq   
