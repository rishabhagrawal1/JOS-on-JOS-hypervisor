
obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf c0 3c 80 00 00 	movabs $0x803cc0,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 08 31 80 00 00 	movabs $0x803108,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba c5 3c 80 00 00 	movabs $0x803cc5,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba eb 3c 80 00 00 	movabs $0x803ceb,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb 00 3d 80 00 00 	movabs $0x803d00,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be 04 3d 80 00 00 	movabs $0x803d04,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba 0c 3d 80 00 00 	movabs $0x803d0c,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e7:	48 b8 1f 1a 80 00 00 	movabs $0x801a1f,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f8:	48 98                	cltq   
  8002fa:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800301:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800308:	00 00 00 
  80030b:	48 01 c2             	add    %rax,%rdx
  80030e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800315:	00 00 00 
  800318:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80031f:	7e 14                	jle    800335 <libmain+0x5d>
		binaryname = argv[0];
  800321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800325:	48 8b 10             	mov    (%rax),%rdx
  800328:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80032f:	00 00 00 
  800332:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033c:	48 89 d6             	mov    %rdx,%rsi
  80033f:	89 c7                	mov    %eax,%edi
  800341:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80034d:	48 b8 5b 03 80 00 00 	movabs $0x80035b,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	c9                   	leaveq 
  80035a:	c3                   	retq   

000000000080035b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80035f:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  800366:	00 00 00 
  800369:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80036b:	bf 00 00 00 00       	mov    $0x0,%edi
  800370:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax

}
  80037c:	5d                   	pop    %rbp
  80037d:	c3                   	retq   

000000000080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037e:	55                   	push   %rbp
  80037f:	48 89 e5             	mov    %rsp,%rbp
  800382:	53                   	push   %rbx
  800383:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80038a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800391:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800397:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80039e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003a5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ac:	84 c0                	test   %al,%al
  8003ae:	74 23                	je     8003d3 <_panic+0x55>
  8003b0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003b7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003bb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003bf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003c3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003c7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003cb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003cf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003d3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003da:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003e1:	00 00 00 
  8003e4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003eb:	00 00 00 
  8003ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003f9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800400:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800407:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80040e:	00 00 00 
  800411:	48 8b 18             	mov    (%rax),%rbx
  800414:	48 b8 1f 1a 80 00 00 	movabs $0x801a1f,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
  800420:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800426:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80042d:	41 89 c8             	mov    %ecx,%r8d
  800430:	48 89 d1             	mov    %rdx,%rcx
  800433:	48 89 da             	mov    %rbx,%rdx
  800436:	89 c6                	mov    %eax,%esi
  800438:	48 bf 28 3d 80 00 00 	movabs $0x803d28,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b9 b7 05 80 00 00 	movabs $0x8005b7,%r9
  80044e:	00 00 00 
  800451:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80045b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800462:	48 89 d6             	mov    %rdx,%rsi
  800465:	48 89 c7             	mov    %rax,%rdi
  800468:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80046f:	00 00 00 
  800472:	ff d0                	callq  *%rax
	cprintf("\n");
  800474:	48 bf 4b 3d 80 00 00 	movabs $0x803d4b,%rdi
  80047b:	00 00 00 
  80047e:	b8 00 00 00 00       	mov    $0x0,%eax
  800483:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  80048a:	00 00 00 
  80048d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80048f:	cc                   	int3   
  800490:	eb fd                	jmp    80048f <_panic+0x111>

0000000000800492 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 10          	sub    $0x10,%rsp
  80049a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a5:	8b 00                	mov    (%rax),%eax
  8004a7:	8d 48 01             	lea    0x1(%rax),%ecx
  8004aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ae:	89 0a                	mov    %ecx,(%rdx)
  8004b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b3:	89 d1                	mov    %edx,%ecx
  8004b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b9:	48 98                	cltq   
  8004bb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c3:	8b 00                	mov    (%rax),%eax
  8004c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ca:	75 2c                	jne    8004f8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	48 98                	cltq   
  8004d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d8:	48 83 c2 08          	add    $0x8,%rdx
  8004dc:	48 89 c6             	mov    %rax,%rsi
  8004df:	48 89 d7             	mov    %rdx,%rdi
  8004e2:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8004e9:	00 00 00 
  8004ec:	ff d0                	callq  *%rax
        b->idx = 0;
  8004ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fc:	8b 40 04             	mov    0x4(%rax),%eax
  8004ff:	8d 50 01             	lea    0x1(%rax),%edx
  800502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800506:	89 50 04             	mov    %edx,0x4(%rax)
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800516:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80051d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800524:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80052b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800532:	48 8b 0a             	mov    (%rdx),%rcx
  800535:	48 89 08             	mov    %rcx,(%rax)
  800538:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800540:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800544:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800548:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80054f:	00 00 00 
    b.cnt = 0;
  800552:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800559:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80055c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800563:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80056a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800571:	48 89 c6             	mov    %rax,%rsi
  800574:	48 bf 92 04 80 00 00 	movabs $0x800492,%rdi
  80057b:	00 00 00 
  80057e:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800585:	00 00 00 
  800588:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80058a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800590:	48 98                	cltq   
  800592:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800599:	48 83 c2 08          	add    $0x8,%rdx
  80059d:	48 89 c6             	mov    %rax,%rsi
  8005a0:	48 89 d7             	mov    %rdx,%rdi
  8005a3:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005af:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   

00000000008005b7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005b7:	55                   	push   %rbp
  8005b8:	48 89 e5             	mov    %rsp,%rbp
  8005bb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005c2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005c9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005d0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005d7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005de:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005e5:	84 c0                	test   %al,%al
  8005e7:	74 20                	je     800609 <cprintf+0x52>
  8005e9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005ed:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005f1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005f5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005f9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005fd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800601:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800605:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800609:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800610:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800617:	00 00 00 
  80061a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800621:	00 00 00 
  800624:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800628:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80062f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800636:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80063d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800644:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80064b:	48 8b 0a             	mov    (%rdx),%rcx
  80064e:	48 89 08             	mov    %rcx,(%rax)
  800651:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800655:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800659:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800661:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800668:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80066f:	48 89 d6             	mov    %rdx,%rsi
  800672:	48 89 c7             	mov    %rax,%rdi
  800675:	48 b8 0b 05 80 00 00 	movabs $0x80050b,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
  800681:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800687:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80068d:	c9                   	leaveq 
  80068e:	c3                   	retq   

000000000080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %rbp
  800690:	48 89 e5             	mov    %rsp,%rbp
  800693:	53                   	push   %rbx
  800694:	48 83 ec 38          	sub    $0x38,%rsp
  800698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80069c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006a4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006a7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006ab:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006b6:	77 3b                	ja     8006f3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006bb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006bf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	48 f7 f3             	div    %rbx
  8006ce:	48 89 c2             	mov    %rax,%rdx
  8006d1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006d7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	41 89 f9             	mov    %edi,%r9d
  8006e2:	48 89 c7             	mov    %rax,%rdi
  8006e5:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	callq  *%rax
  8006f1:	eb 1e                	jmp    800711 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f3:	eb 12                	jmp    800707 <printnum+0x78>
			putch(padc, putdat);
  8006f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006f9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 89 ce             	mov    %rcx,%rsi
  800703:	89 d7                	mov    %edx,%edi
  800705:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800707:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80070b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80070f:	7f e4                	jg     8006f5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800711:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	48 f7 f1             	div    %rcx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 ba 50 3f 80 00 00 	movabs $0x803f50,%rdx
  80072a:	00 00 00 
  80072d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800731:	0f be d0             	movsbl %al,%edx
  800734:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 89 ce             	mov    %rcx,%rsi
  80073f:	89 d7                	mov    %edx,%edi
  800741:	ff d0                	callq  *%rax
}
  800743:	48 83 c4 38          	add    $0x38,%rsp
  800747:	5b                   	pop    %rbx
  800748:	5d                   	pop    %rbp
  800749:	c3                   	retq   

000000000080074a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800756:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800759:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80075d:	7e 52                	jle    8007b1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	83 f8 30             	cmp    $0x30,%eax
  800768:	73 24                	jae    80078e <getuint+0x44>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	8b 12                	mov    (%rdx),%edx
  800783:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	89 0a                	mov    %ecx,(%rdx)
  80078c:	eb 17                	jmp    8007a5 <getuint+0x5b>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800796:	48 89 d0             	mov    %rdx,%rax
  800799:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a5:	48 8b 00             	mov    (%rax),%rax
  8007a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ac:	e9 a3 00 00 00       	jmpq   800854 <getuint+0x10a>
	else if (lflag)
  8007b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007b5:	74 4f                	je     800806 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 24                	jae    8007e6 <getuint+0x9c>
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	89 c0                	mov    %eax,%eax
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	8b 12                	mov    (%rdx),%edx
  8007db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	89 0a                	mov    %ecx,(%rdx)
  8007e4:	eb 17                	jmp    8007fd <getuint+0xb3>
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ee:	48 89 d0             	mov    %rdx,%rax
  8007f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fd:	48 8b 00             	mov    (%rax),%rax
  800800:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800804:	eb 4e                	jmp    800854 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getuint+0xeb>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getuint+0x102>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800858:	c9                   	leaveq 
  800859:	c3                   	retq   

000000000080085a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80085a:	55                   	push   %rbp
  80085b:	48 89 e5             	mov    %rsp,%rbp
  80085e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800866:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800869:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80086d:	7e 52                	jle    8008c1 <getint+0x67>
		x=va_arg(*ap, long long);
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	8b 00                	mov    (%rax),%eax
  800875:	83 f8 30             	cmp    $0x30,%eax
  800878:	73 24                	jae    80089e <getint+0x44>
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	8b 00                	mov    (%rax),%eax
  800888:	89 c0                	mov    %eax,%eax
  80088a:	48 01 d0             	add    %rdx,%rax
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	8b 12                	mov    (%rdx),%edx
  800893:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800896:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089a:	89 0a                	mov    %ecx,(%rdx)
  80089c:	eb 17                	jmp    8008b5 <getint+0x5b>
  80089e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a6:	48 89 d0             	mov    %rdx,%rax
  8008a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008b5:	48 8b 00             	mov    (%rax),%rax
  8008b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008bc:	e9 a3 00 00 00       	jmpq   800964 <getint+0x10a>
	else if (lflag)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008c5:	74 4f                	je     800916 <getint+0xbc>
		x=va_arg(*ap, long);
  8008c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cb:	8b 00                	mov    (%rax),%eax
  8008cd:	83 f8 30             	cmp    $0x30,%eax
  8008d0:	73 24                	jae    8008f6 <getint+0x9c>
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e9:	8b 12                	mov    (%rdx),%edx
  8008eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f2:	89 0a                	mov    %ecx,(%rdx)
  8008f4:	eb 17                	jmp    80090d <getint+0xb3>
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008fe:	48 89 d0             	mov    %rdx,%rax
  800901:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800905:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800909:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800914:	eb 4e                	jmp    800964 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800916:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091a:	8b 00                	mov    (%rax),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 24                	jae    800945 <getint+0xeb>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	8b 12                	mov    (%rdx),%edx
  80093a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	89 0a                	mov    %ecx,(%rdx)
  800943:	eb 17                	jmp    80095c <getint+0x102>
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80094d:	48 89 d0             	mov    %rdx,%rax
  800950:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800958:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	48 98                	cltq   
  800960:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800964:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800968:	c9                   	leaveq 
  800969:	c3                   	retq   

000000000080096a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096a:	55                   	push   %rbp
  80096b:	48 89 e5             	mov    %rsp,%rbp
  80096e:	41 54                	push   %r12
  800970:	53                   	push   %rbx
  800971:	48 83 ec 60          	sub    $0x60,%rsp
  800975:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800979:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80097d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800981:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800985:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800989:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80098d:	48 8b 0a             	mov    (%rdx),%rcx
  800990:	48 89 08             	mov    %rcx,(%rax)
  800993:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800997:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80099b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80099f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a3:	eb 17                	jmp    8009bc <vprintfmt+0x52>
			if (ch == '\0')
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	0f 84 cc 04 00 00    	je     800e79 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8009ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b5:	48 89 d6             	mov    %rdx,%rsi
  8009b8:	89 df                	mov    %ebx,%edi
  8009ba:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f b6 d8             	movzbl %al,%ebx
  8009ce:	83 fb 25             	cmp    $0x25,%ebx
  8009d1:	75 d2                	jne    8009a5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009d7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ff:	0f b6 00             	movzbl (%rax),%eax
  800a02:	0f b6 d8             	movzbl %al,%ebx
  800a05:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a08:	83 f8 55             	cmp    $0x55,%eax
  800a0b:	0f 87 34 04 00 00    	ja     800e45 <vprintfmt+0x4db>
  800a11:	89 c0                	mov    %eax,%eax
  800a13:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a1a:	00 
  800a1b:	48 b8 78 3f 80 00 00 	movabs $0x803f78,%rax
  800a22:	00 00 00 
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	48 8b 00             	mov    (%rax),%rax
  800a2b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a2d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a31:	eb c0                	jmp    8009f3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a33:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a37:	eb ba                	jmp    8009f3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a39:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a40:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a43:	89 d0                	mov    %edx,%eax
  800a45:	c1 e0 02             	shl    $0x2,%eax
  800a48:	01 d0                	add    %edx,%eax
  800a4a:	01 c0                	add    %eax,%eax
  800a4c:	01 d8                	add    %ebx,%eax
  800a4e:	83 e8 30             	sub    $0x30,%eax
  800a51:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a58:	0f b6 00             	movzbl (%rax),%eax
  800a5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a61:	7e 0c                	jle    800a6f <vprintfmt+0x105>
  800a63:	83 fb 39             	cmp    $0x39,%ebx
  800a66:	7f 07                	jg     800a6f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a68:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6d:	eb d1                	jmp    800a40 <vprintfmt+0xd6>
			goto process_precision;
  800a6f:	eb 58                	jmp    800ac9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	83 f8 30             	cmp    $0x30,%eax
  800a77:	73 17                	jae    800a90 <vprintfmt+0x126>
  800a79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a88:	83 c2 08             	add    $0x8,%edx
  800a8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8e:	eb 0f                	jmp    800a9f <vprintfmt+0x135>
  800a90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a94:	48 89 d0             	mov    %rdx,%rax
  800a97:	48 83 c2 08          	add    $0x8,%rdx
  800a9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9f:	8b 00                	mov    (%rax),%eax
  800aa1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800aa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aaa:	79 0c                	jns    800ab8 <vprintfmt+0x14e>
				width = 0;
  800aac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ab3:	e9 3b ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>
  800ab8:	e9 36 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800abd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ac4:	e9 2a ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ac9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acd:	79 12                	jns    800ae1 <vprintfmt+0x177>
				width = precision, precision = -1;
  800acf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ad5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800adc:	e9 12 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>
  800ae1:	e9 0d ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aea:	e9 04 ff ff ff       	jmpq   8009f3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800aef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af2:	83 f8 30             	cmp    $0x30,%eax
  800af5:	73 17                	jae    800b0e <vprintfmt+0x1a4>
  800af7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afe:	89 c0                	mov    %eax,%eax
  800b00:	48 01 d0             	add    %rdx,%rax
  800b03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b06:	83 c2 08             	add    $0x8,%edx
  800b09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0c:	eb 0f                	jmp    800b1d <vprintfmt+0x1b3>
  800b0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b12:	48 89 d0             	mov    %rdx,%rax
  800b15:	48 83 c2 08          	add    $0x8,%rdx
  800b19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1d:	8b 10                	mov    (%rax),%edx
  800b1f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 ce             	mov    %rcx,%rsi
  800b2a:	89 d7                	mov    %edx,%edi
  800b2c:	ff d0                	callq  *%rax
			break;
  800b2e:	e9 40 03 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b36:	83 f8 30             	cmp    $0x30,%eax
  800b39:	73 17                	jae    800b52 <vprintfmt+0x1e8>
  800b3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	89 c0                	mov    %eax,%eax
  800b44:	48 01 d0             	add    %rdx,%rax
  800b47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4a:	83 c2 08             	add    $0x8,%edx
  800b4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b50:	eb 0f                	jmp    800b61 <vprintfmt+0x1f7>
  800b52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b56:	48 89 d0             	mov    %rdx,%rax
  800b59:	48 83 c2 08          	add    $0x8,%rdx
  800b5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b61:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	79 02                	jns    800b69 <vprintfmt+0x1ff>
				err = -err;
  800b67:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b69:	83 fb 15             	cmp    $0x15,%ebx
  800b6c:	7f 16                	jg     800b84 <vprintfmt+0x21a>
  800b6e:	48 b8 a0 3e 80 00 00 	movabs $0x803ea0,%rax
  800b75:	00 00 00 
  800b78:	48 63 d3             	movslq %ebx,%rdx
  800b7b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b7f:	4d 85 e4             	test   %r12,%r12
  800b82:	75 2e                	jne    800bb2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	89 d9                	mov    %ebx,%ecx
  800b8e:	48 ba 61 3f 80 00 00 	movabs $0x803f61,%rdx
  800b95:	00 00 00 
  800b98:	48 89 c7             	mov    %rax,%rdi
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba0:	49 b8 82 0e 80 00 00 	movabs $0x800e82,%r8
  800ba7:	00 00 00 
  800baa:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bad:	e9 c1 02 00 00       	jmpq   800e73 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	4c 89 e1             	mov    %r12,%rcx
  800bbd:	48 ba 6a 3f 80 00 00 	movabs $0x803f6a,%rdx
  800bc4:	00 00 00 
  800bc7:	48 89 c7             	mov    %rax,%rdi
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcf:	49 b8 82 0e 80 00 00 	movabs $0x800e82,%r8
  800bd6:	00 00 00 
  800bd9:	41 ff d0             	callq  *%r8
			break;
  800bdc:	e9 92 02 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 30             	cmp    $0x30,%eax
  800be7:	73 17                	jae    800c00 <vprintfmt+0x296>
  800be9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf0:	89 c0                	mov    %eax,%eax
  800bf2:	48 01 d0             	add    %rdx,%rax
  800bf5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf8:	83 c2 08             	add    $0x8,%edx
  800bfb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfe:	eb 0f                	jmp    800c0f <vprintfmt+0x2a5>
  800c00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c04:	48 89 d0             	mov    %rdx,%rax
  800c07:	48 83 c2 08          	add    $0x8,%rdx
  800c0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0f:	4c 8b 20             	mov    (%rax),%r12
  800c12:	4d 85 e4             	test   %r12,%r12
  800c15:	75 0a                	jne    800c21 <vprintfmt+0x2b7>
				p = "(null)";
  800c17:	49 bc 6d 3f 80 00 00 	movabs $0x803f6d,%r12
  800c1e:	00 00 00 
			if (width > 0 && padc != '-')
  800c21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c25:	7e 3f                	jle    800c66 <vprintfmt+0x2fc>
  800c27:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c2b:	74 39                	je     800c66 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c30:	48 98                	cltq   
  800c32:	48 89 c6             	mov    %rax,%rsi
  800c35:	4c 89 e7             	mov    %r12,%rdi
  800c38:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
  800c44:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c47:	eb 17                	jmp    800c60 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c49:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c4d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c55:	48 89 ce             	mov    %rcx,%rsi
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c64:	7f e3                	jg     800c49 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c66:	eb 37                	jmp    800c9f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c6c:	74 1e                	je     800c8c <vprintfmt+0x322>
  800c6e:	83 fb 1f             	cmp    $0x1f,%ebx
  800c71:	7e 05                	jle    800c78 <vprintfmt+0x30e>
  800c73:	83 fb 7e             	cmp    $0x7e,%ebx
  800c76:	7e 14                	jle    800c8c <vprintfmt+0x322>
					putch('?', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c88:	ff d0                	callq  *%rax
  800c8a:	eb 0f                	jmp    800c9b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	89 df                	mov    %ebx,%edi
  800c99:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c9b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c9f:	4c 89 e0             	mov    %r12,%rax
  800ca2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ca6:	0f b6 00             	movzbl (%rax),%eax
  800ca9:	0f be d8             	movsbl %al,%ebx
  800cac:	85 db                	test   %ebx,%ebx
  800cae:	74 10                	je     800cc0 <vprintfmt+0x356>
  800cb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cb4:	78 b2                	js     800c68 <vprintfmt+0x2fe>
  800cb6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cba:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbe:	79 a8                	jns    800c68 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc0:	eb 16                	jmp    800cd8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800cc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cca:	48 89 d6             	mov    %rdx,%rsi
  800ccd:	bf 20 00 00 00       	mov    $0x20,%edi
  800cd2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cdc:	7f e4                	jg     800cc2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cde:	e9 90 01 00 00       	jmpq   800e73 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ce3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce7:	be 03 00 00 00       	mov    $0x3,%esi
  800cec:	48 89 c7             	mov    %rax,%rdi
  800cef:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
  800cfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d03:	48 85 c0             	test   %rax,%rax
  800d06:	79 1d                	jns    800d25 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d10:	48 89 d6             	mov    %rdx,%rsi
  800d13:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d18:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1e:	48 f7 d8             	neg    %rax
  800d21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d25:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2c:	e9 d5 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d31:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d35:	be 03 00 00 00       	mov    $0x3,%esi
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
  800d49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d4d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d54:	e9 ad 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d59:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800d6c:	00 00 00 
  800d6f:	ff d0                	callq  *%rax
  800d71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d75:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d7c:	e9 85 00 00 00       	jmpq   800e06 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d89:	48 89 d6             	mov    %rdx,%rsi
  800d8c:	bf 30 00 00 00       	mov    $0x30,%edi
  800d91:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 d6             	mov    %rdx,%rsi
  800d9e:	bf 78 00 00 00       	mov    $0x78,%edi
  800da3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800da5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da8:	83 f8 30             	cmp    $0x30,%eax
  800dab:	73 17                	jae    800dc4 <vprintfmt+0x45a>
  800dad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db4:	89 c0                	mov    %eax,%eax
  800db6:	48 01 d0             	add    %rdx,%rax
  800db9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbc:	83 c2 08             	add    $0x8,%edx
  800dbf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc2:	eb 0f                	jmp    800dd3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800dc4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc8:	48 89 d0             	mov    %rdx,%rax
  800dcb:	48 83 c2 08          	add    $0x8,%rdx
  800dcf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dda:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800de1:	eb 23                	jmp    800e06 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800de3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de7:	be 03 00 00 00       	mov    $0x3,%esi
  800dec:	48 89 c7             	mov    %rax,%rdi
  800def:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800df6:	00 00 00 
  800df9:	ff d0                	callq  *%rax
  800dfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dff:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e06:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e0b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e0e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e15:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1d:	45 89 c1             	mov    %r8d,%r9d
  800e20:	41 89 f8             	mov    %edi,%r8d
  800e23:	48 89 c7             	mov    %rax,%rdi
  800e26:	48 b8 8f 06 80 00 00 	movabs $0x80068f,%rax
  800e2d:	00 00 00 
  800e30:	ff d0                	callq  *%rax
			break;
  800e32:	eb 3f                	jmp    800e73 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3c:	48 89 d6             	mov    %rdx,%rsi
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	ff d0                	callq  *%rax
			break;
  800e43:	eb 2e                	jmp    800e73 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4d:	48 89 d6             	mov    %rdx,%rsi
  800e50:	bf 25 00 00 00       	mov    $0x25,%edi
  800e55:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e5c:	eb 05                	jmp    800e63 <vprintfmt+0x4f9>
  800e5e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e63:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e67:	48 83 e8 01          	sub    $0x1,%rax
  800e6b:	0f b6 00             	movzbl (%rax),%eax
  800e6e:	3c 25                	cmp    $0x25,%al
  800e70:	75 ec                	jne    800e5e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e72:	90                   	nop
		}
	}
  800e73:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e74:	e9 43 fb ff ff       	jmpq   8009bc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e79:	48 83 c4 60          	add    $0x60,%rsp
  800e7d:	5b                   	pop    %rbx
  800e7e:	41 5c                	pop    %r12
  800e80:	5d                   	pop    %rbp
  800e81:	c3                   	retq   

0000000000800e82 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e82:	55                   	push   %rbp
  800e83:	48 89 e5             	mov    %rsp,%rbp
  800e86:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e8d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e94:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e9b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ea2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ea9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 20                	je     800ed4 <printfmt+0x52>
  800eb4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eb8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ebc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ec0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ec4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ec8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ecc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ed0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ed4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800edb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ee2:	00 00 00 
  800ee5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800eec:	00 00 00 
  800eef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ef3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800efa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f01:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f08:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f0f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f16:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f1d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f24:	48 89 c7             	mov    %rax,%rdi
  800f27:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 83 ec 10          	sub    $0x10,%rsp
  800f3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f48:	8b 40 10             	mov    0x10(%rax),%eax
  800f4b:	8d 50 01             	lea    0x1(%rax),%edx
  800f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f52:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f59:	48 8b 10             	mov    (%rax),%rdx
  800f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f60:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f64:	48 39 c2             	cmp    %rax,%rdx
  800f67:	73 17                	jae    800f80 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	48 8b 00             	mov    (%rax),%rax
  800f70:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f74:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f78:	48 89 0a             	mov    %rcx,(%rdx)
  800f7b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f7e:	88 10                	mov    %dl,(%rax)
}
  800f80:	c9                   	leaveq 
  800f81:	c3                   	retq   

0000000000800f82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f82:	55                   	push   %rbp
  800f83:	48 89 e5             	mov    %rsp,%rbp
  800f86:	48 83 ec 50          	sub    $0x50,%rsp
  800f8a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f8e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f91:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f95:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f99:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f9d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fa1:	48 8b 0a             	mov    (%rdx),%rcx
  800fa4:	48 89 08             	mov    %rcx,(%rax)
  800fa7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800faf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fb7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fbf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fc2:	48 98                	cltq   
  800fc4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fcc:	48 01 d0             	add    %rdx,%rax
  800fcf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fda:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fdf:	74 06                	je     800fe7 <vsnprintf+0x65>
  800fe1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fe5:	7f 07                	jg     800fee <vsnprintf+0x6c>
		return -E_INVAL;
  800fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fec:	eb 2f                	jmp    80101d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fee:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ff2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ff6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ffa:	48 89 c6             	mov    %rax,%rsi
  800ffd:	48 bf 35 0f 80 00 00 	movabs $0x800f35,%rdi
  801004:	00 00 00 
  801007:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801013:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801017:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80101a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80102a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801031:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801037:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801045:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104c:	84 c0                	test   %al,%al
  80104e:	74 20                	je     801070 <snprintf+0x51>
  801050:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801054:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801058:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801060:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801064:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801068:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801070:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801077:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80107e:	00 00 00 
  801081:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801088:	00 00 00 
  80108b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801096:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010b2:	48 8b 0a             	mov    (%rdx),%rcx
  8010b5:	48 89 08             	mov    %rcx,(%rax)
  8010b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010c8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010cf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010d6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010e3:	48 89 c7             	mov    %rax,%rdi
  8010e6:	48 b8 82 0f 80 00 00 	movabs $0x800f82,%rax
  8010ed:	00 00 00 
  8010f0:	ff d0                	callq  *%rax
  8010f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 18          	sub    $0x18,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80110c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801113:	eb 09                	jmp    80111e <strlen+0x1e>
		n++;
  801115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	75 ec                	jne    801115 <strlen+0x15>
		n++;
	return n;
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 20          	sub    $0x20,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80113e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801145:	eb 0e                	jmp    801155 <strnlen+0x27>
		n++;
  801147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80115a:	74 0b                	je     801167 <strnlen+0x39>
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	75 e0                	jne    801147 <strnlen+0x19>
		n++;
	return n;
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 20          	sub    $0x20,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80117c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801184:	90                   	nop
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80118d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801191:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801195:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801199:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80119d:	0f b6 12             	movzbl (%rdx),%edx
  8011a0:	88 10                	mov    %dl,(%rax)
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 dc                	jne    801185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 20          	sub    $0x20,%rsp
  8011b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	48 89 c7             	mov    %rax,%rdi
  8011c6:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d8:	48 63 d0             	movslq %eax,%rdx
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 01 c2             	add    %rax,%rdx
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	48 89 c6             	mov    %rax,%rsi
  8011e9:	48 89 d7             	mov    %rdx,%rdi
  8011ec:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8011f3:	00 00 00 
  8011f6:	ff d0                	callq  *%rax
	return dst;
  8011f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 28          	sub    $0x28,%rsp
  801206:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80120e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801216:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80121a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801221:	00 
  801222:	eb 2a                	jmp    80124e <strncpy+0x50>
		*dst++ = *src;
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801234:	0f b6 12             	movzbl (%rdx),%edx
  801237:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	84 c0                	test   %al,%al
  801242:	74 05                	je     801249 <strncpy+0x4b>
			src++;
  801244:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801249:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801256:	72 cc                	jb     801224 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80125c:	c9                   	leaveq 
  80125d:	c3                   	retq   

000000000080125e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80125e:	55                   	push   %rbp
  80125f:	48 89 e5             	mov    %rsp,%rbp
  801262:	48 83 ec 28          	sub    $0x28,%rsp
  801266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80127a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127f:	74 3d                	je     8012be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801281:	eb 1d                	jmp    8012a0 <strlcpy+0x42>
			*dst++ = *src++;
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80128f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801293:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801297:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80129b:	0f b6 12             	movzbl (%rdx),%edx
  80129e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012aa:	74 0b                	je     8012b7 <strlcpy+0x59>
  8012ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b0:	0f b6 00             	movzbl (%rax),%eax
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 cc                	jne    801283 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	48 29 c2             	sub    %rax,%rdx
  8012c9:	48 89 d0             	mov    %rdx,%rax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 10          	sub    $0x10,%rsp
  8012d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012de:	eb 0a                	jmp    8012ea <strcmp+0x1c>
		p++, q++;
  8012e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	84 c0                	test   %al,%al
  8012f3:	74 12                	je     801307 <strcmp+0x39>
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	0f b6 10             	movzbl (%rax),%edx
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	38 c2                	cmp    %al,%dl
  801305:	74 d9                	je     8012e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
}
  80131f:	c9                   	leaveq 
  801320:	c3                   	retq   

0000000000801321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801321:	55                   	push   %rbp
  801322:	48 89 e5             	mov    %rsp,%rbp
  801325:	48 83 ec 18          	sub    $0x18,%rsp
  801329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801335:	eb 0f                	jmp    801346 <strncmp+0x25>
		n--, p++, q++;
  801337:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80133c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801341:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801346:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134b:	74 1d                	je     80136a <strncmp+0x49>
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	84 c0                	test   %al,%al
  801356:	74 12                	je     80136a <strncmp+0x49>
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	0f b6 10             	movzbl (%rax),%edx
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	38 c2                	cmp    %al,%dl
  801368:	74 cd                	je     801337 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80136a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80136f:	75 07                	jne    801378 <strncmp+0x57>
		return 0;
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	eb 18                	jmp    801390 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	0f b6 d0             	movzbl %al,%edx
  801382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	0f b6 c0             	movzbl %al,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
}
  801390:	c9                   	leaveq 
  801391:	c3                   	retq   

0000000000801392 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801392:	55                   	push   %rbp
  801393:	48 89 e5             	mov    %rsp,%rbp
  801396:	48 83 ec 0c          	sub    $0xc,%rsp
  80139a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139e:	89 f0                	mov    %esi,%eax
  8013a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013a3:	eb 17                	jmp    8013bc <strchr+0x2a>
		if (*s == c)
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	0f b6 00             	movzbl (%rax),%eax
  8013ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013af:	75 06                	jne    8013b7 <strchr+0x25>
			return (char *) s;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 15                	jmp    8013cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 de                	jne    8013a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8013d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013da:	89 f0                	mov    %esi,%eax
  8013dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013df:	eb 13                	jmp    8013f4 <strfind+0x26>
		if (*s == c)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013eb:	75 02                	jne    8013ef <strfind+0x21>
			break;
  8013ed:	eb 10                	jmp    8013ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	0f b6 00             	movzbl (%rax),%eax
  8013fb:	84 c0                	test   %al,%al
  8013fd:	75 e2                	jne    8013e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801403:	c9                   	leaveq 
  801404:	c3                   	retq   

0000000000801405 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801405:	55                   	push   %rbp
  801406:	48 89 e5             	mov    %rsp,%rbp
  801409:	48 83 ec 18          	sub    $0x18,%rsp
  80140d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801411:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801414:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801418:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141d:	75 06                	jne    801425 <memset+0x20>
		return v;
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	eb 69                	jmp    80148e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 48                	jne    801479 <memset+0x74>
  801431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801435:	83 e0 03             	and    $0x3,%eax
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	75 3c                	jne    801479 <memset+0x74>
		c &= 0xFF;
  80143d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801444:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801447:	c1 e0 18             	shl    $0x18,%eax
  80144a:	89 c2                	mov    %eax,%edx
  80144c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144f:	c1 e0 10             	shl    $0x10,%eax
  801452:	09 c2                	or     %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801457:	c1 e0 08             	shl    $0x8,%eax
  80145a:	09 d0                	or     %edx,%eax
  80145c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801463:	48 c1 e8 02          	shr    $0x2,%rax
  801467:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80146a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801471:	48 89 d7             	mov    %rdx,%rdi
  801474:	fc                   	cld    
  801475:	f3 ab                	rep stos %eax,%es:(%rdi)
  801477:	eb 11                	jmp    80148a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801479:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801480:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801484:	48 89 d7             	mov    %rdx,%rdi
  801487:	fc                   	cld    
  801488:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 28          	sub    $0x28,%rsp
  801498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014bc:	0f 83 88 00 00 00    	jae    80154a <memmove+0xba>
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ca:	48 01 d0             	add    %rdx,%rax
  8014cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014d1:	76 77                	jbe    80154a <memmove+0xba>
		s += n;
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	83 e0 03             	and    $0x3,%eax
  8014ea:	48 85 c0             	test   %rax,%rax
  8014ed:	75 3b                	jne    80152a <memmove+0x9a>
  8014ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f3:	83 e0 03             	and    $0x3,%eax
  8014f6:	48 85 c0             	test   %rax,%rax
  8014f9:	75 2f                	jne    80152a <memmove+0x9a>
  8014fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ff:	83 e0 03             	and    $0x3,%eax
  801502:	48 85 c0             	test   %rax,%rax
  801505:	75 23                	jne    80152a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	48 83 e8 04          	sub    $0x4,%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 83 ea 04          	sub    $0x4,%rdx
  801517:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80151b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80151f:	48 89 c7             	mov    %rax,%rdi
  801522:	48 89 d6             	mov    %rdx,%rsi
  801525:	fd                   	std    
  801526:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801528:	eb 1d                	jmp    801547 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80152a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801536:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 89 d7             	mov    %rdx,%rdi
  801541:	48 89 c1             	mov    %rax,%rcx
  801544:	fd                   	std    
  801545:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801547:	fc                   	cld    
  801548:	eb 57                	jmp    8015a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	83 e0 03             	and    $0x3,%eax
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 36                	jne    80158c <memmove+0xfc>
  801556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155a:	83 e0 03             	and    $0x3,%eax
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	75 2a                	jne    80158c <memmove+0xfc>
  801562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801566:	83 e0 03             	and    $0x3,%eax
  801569:	48 85 c0             	test   %rax,%rax
  80156c:	75 1e                	jne    80158c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	48 c1 e8 02          	shr    $0x2,%rax
  801576:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801581:	48 89 c7             	mov    %rax,%rdi
  801584:	48 89 d6             	mov    %rdx,%rsi
  801587:	fc                   	cld    
  801588:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80158a:	eb 15                	jmp    8015a1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801594:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801598:	48 89 c7             	mov    %rax,%rdi
  80159b:	48 89 d6             	mov    %rdx,%rsi
  80159e:	fc                   	cld    
  80159f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a5:	c9                   	leaveq 
  8015a6:	c3                   	retq   

00000000008015a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	48 83 ec 18          	sub    $0x18,%rsp
  8015af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	48 89 ce             	mov    %rcx,%rsi
  8015ca:	48 89 c7             	mov    %rax,%rdi
  8015cd:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	callq  *%rax
}
  8015d9:	c9                   	leaveq 
  8015da:	c3                   	retq   

00000000008015db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	48 83 ec 28          	sub    $0x28,%rsp
  8015e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015ff:	eb 36                	jmp    801637 <memcmp+0x5c>
		if (*s1 != *s2)
  801601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801605:	0f b6 10             	movzbl (%rax),%edx
  801608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160c:	0f b6 00             	movzbl (%rax),%eax
  80160f:	38 c2                	cmp    %al,%dl
  801611:	74 1a                	je     80162d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	0f b6 d0             	movzbl %al,%edx
  80161d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	0f b6 c0             	movzbl %al,%eax
  801627:	29 c2                	sub    %eax,%edx
  801629:	89 d0                	mov    %edx,%eax
  80162b:	eb 20                	jmp    80164d <memcmp+0x72>
		s1++, s2++;
  80162d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80163f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801643:	48 85 c0             	test   %rax,%rax
  801646:	75 b9                	jne    801601 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 28          	sub    $0x28,%rsp
  801657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80165b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80165e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166a:	48 01 d0             	add    %rdx,%rax
  80166d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801671:	eb 15                	jmp    801688 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801677:	0f b6 10             	movzbl (%rax),%edx
  80167a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80167d:	38 c2                	cmp    %al,%dl
  80167f:	75 02                	jne    801683 <memfind+0x34>
			break;
  801681:	eb 0f                	jmp    801692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801683:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801690:	72 e1                	jb     801673 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801696:	c9                   	leaveq 
  801697:	c3                   	retq   

0000000000801698 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801698:	55                   	push   %rbp
  801699:	48 89 e5             	mov    %rsp,%rbp
  80169c:	48 83 ec 34          	sub    $0x34,%rsp
  8016a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ba:	eb 05                	jmp    8016c1 <strtol+0x29>
		s++;
  8016bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	3c 20                	cmp    $0x20,%al
  8016ca:	74 f0                	je     8016bc <strtol+0x24>
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 09                	cmp    $0x9,%al
  8016d5:	74 e5                	je     8016bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 2b                	cmp    $0x2b,%al
  8016e0:	75 07                	jne    8016e9 <strtol+0x51>
		s++;
  8016e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e7:	eb 17                	jmp    801700 <strtol+0x68>
	else if (*s == '-')
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	3c 2d                	cmp    $0x2d,%al
  8016f2:	75 0c                	jne    801700 <strtol+0x68>
		s++, neg = 1;
  8016f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801700:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801704:	74 06                	je     80170c <strtol+0x74>
  801706:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80170a:	75 28                	jne    801734 <strtol+0x9c>
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 30                	cmp    $0x30,%al
  801715:	75 1d                	jne    801734 <strtol+0x9c>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	48 83 c0 01          	add    $0x1,%rax
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	3c 78                	cmp    $0x78,%al
  801724:	75 0e                	jne    801734 <strtol+0x9c>
		s += 2, base = 16;
  801726:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80172b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801732:	eb 2c                	jmp    801760 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801734:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801738:	75 19                	jne    801753 <strtol+0xbb>
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	3c 30                	cmp    $0x30,%al
  801743:	75 0e                	jne    801753 <strtol+0xbb>
		s++, base = 8;
  801745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80174a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801751:	eb 0d                	jmp    801760 <strtol+0xc8>
	else if (base == 0)
  801753:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801757:	75 07                	jne    801760 <strtol+0xc8>
		base = 10;
  801759:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 2f                	cmp    $0x2f,%al
  801769:	7e 1d                	jle    801788 <strtol+0xf0>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 39                	cmp    $0x39,%al
  801774:	7f 12                	jg     801788 <strtol+0xf0>
			dig = *s - '0';
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	0f be c0             	movsbl %al,%eax
  801780:	83 e8 30             	sub    $0x30,%eax
  801783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801786:	eb 4e                	jmp    8017d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 60                	cmp    $0x60,%al
  801791:	7e 1d                	jle    8017b0 <strtol+0x118>
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	3c 7a                	cmp    $0x7a,%al
  80179c:	7f 12                	jg     8017b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	0f be c0             	movsbl %al,%eax
  8017a8:	83 e8 57             	sub    $0x57,%eax
  8017ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ae:	eb 26                	jmp    8017d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b4:	0f b6 00             	movzbl (%rax),%eax
  8017b7:	3c 40                	cmp    $0x40,%al
  8017b9:	7e 48                	jle    801803 <strtol+0x16b>
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	3c 5a                	cmp    $0x5a,%al
  8017c4:	7f 3d                	jg     801803 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	0f be c0             	movsbl %al,%eax
  8017d0:	83 e8 37             	sub    $0x37,%eax
  8017d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017dc:	7c 02                	jl     8017e0 <strtol+0x148>
			break;
  8017de:	eb 23                	jmp    801803 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017e8:	48 98                	cltq   
  8017ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017ef:	48 89 c2             	mov    %rax,%rdx
  8017f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017f5:	48 98                	cltq   
  8017f7:	48 01 d0             	add    %rdx,%rax
  8017fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017fe:	e9 5d ff ff ff       	jmpq   801760 <strtol+0xc8>

	if (endptr)
  801803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801808:	74 0b                	je     801815 <strtol+0x17d>
		*endptr = (char *) s;
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801819:	74 09                	je     801824 <strtol+0x18c>
  80181b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181f:	48 f7 d8             	neg    %rax
  801822:	eb 04                	jmp    801828 <strtol+0x190>
  801824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <strstr>:

char * strstr(const char *in, const char *str)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 30          	sub    $0x30,%rsp
  801832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80183a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801842:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80184c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801850:	75 06                	jne    801858 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	eb 6b                	jmp    8018c3 <strstr+0x99>

	len = strlen(str);
  801858:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80185c:	48 89 c7             	mov    %rax,%rdi
  80185f:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
  80186b:	48 98                	cltq   
  80186d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801883:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801887:	75 07                	jne    801890 <strstr+0x66>
				return (char *) 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	eb 33                	jmp    8018c3 <strstr+0x99>
		} while (sc != c);
  801890:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801894:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801897:	75 d8                	jne    801871 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a5:	48 89 ce             	mov    %rcx,%rsi
  8018a8:	48 89 c7             	mov    %rax,%rdi
  8018ab:	48 b8 21 13 80 00 00 	movabs $0x801321,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	callq  *%rax
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	75 b6                	jne    801871 <strstr+0x47>

	return (char *) (in - 1);
  8018bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8018c3:	c9                   	leaveq 
  8018c4:	c3                   	retq   

00000000008018c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018c5:	55                   	push   %rbp
  8018c6:	48 89 e5             	mov    %rsp,%rbp
  8018c9:	53                   	push   %rbx
  8018ca:	48 83 ec 48          	sub    $0x48,%rsp
  8018ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018fb:	4c 89 c3             	mov    %r8,%rbx
  8018fe:	cd 30                	int    $0x30
  801900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801904:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801908:	74 3e                	je     801948 <syscall+0x83>
  80190a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80190f:	7e 37                	jle    801948 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801915:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801918:	49 89 d0             	mov    %rdx,%r8
  80191b:	89 c1                	mov    %eax,%ecx
  80191d:	48 ba 28 42 80 00 00 	movabs $0x804228,%rdx
  801924:	00 00 00 
  801927:	be 23 00 00 00       	mov    $0x23,%esi
  80192c:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801933:	00 00 00 
  801936:	b8 00 00 00 00       	mov    $0x0,%eax
  80193b:	49 b9 7e 03 80 00 00 	movabs $0x80037e,%r9
  801942:	00 00 00 
  801945:	41 ff d1             	callq  *%r9

	return ret;
  801948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80194c:	48 83 c4 48          	add    $0x48,%rsp
  801950:	5b                   	pop    %rbx
  801951:	5d                   	pop    %rbp
  801952:	c3                   	retq   

0000000000801953 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801953:	55                   	push   %rbp
  801954:	48 89 e5             	mov    %rsp,%rbp
  801957:	48 83 ec 20          	sub    $0x20,%rsp
  80195b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80195f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801972:	00 
  801973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197f:	48 89 d1             	mov    %rdx,%rcx
  801982:	48 89 c2             	mov    %rax,%rdx
  801985:	be 00 00 00 00       	mov    $0x0,%esi
  80198a:	bf 00 00 00 00       	mov    $0x0,%edi
  80198f:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801996:	00 00 00 
  801999:	ff d0                	callq  *%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <sys_cgetc>:

int
sys_cgetc(void)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ac:	00 
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	be 00 00 00 00       	mov    $0x0,%esi
  8019c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8019cd:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	callq  *%rax
}
  8019d9:	c9                   	leaveq 
  8019da:	c3                   	retq   

00000000008019db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 10          	sub    $0x10,%rsp
  8019e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e9:	48 98                	cltq   
  8019eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f2:	00 
  8019f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a04:	48 89 c2             	mov    %rax,%rdx
  801a07:	be 01 00 00 00       	mov    $0x1,%esi
  801a0c:	bf 03 00 00 00       	mov    $0x3,%edi
  801a11:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a18:	00 00 00 
  801a1b:	ff d0                	callq  *%rax
}
  801a1d:	c9                   	leaveq 
  801a1e:	c3                   	retq   

0000000000801a1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a1f:	55                   	push   %rbp
  801a20:	48 89 e5             	mov    %rsp,%rbp
  801a23:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2e:	00 
  801a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	ba 00 00 00 00       	mov    $0x0,%edx
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a4f:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
}
  801a5b:	c9                   	leaveq 
  801a5c:	c3                   	retq   

0000000000801a5d <sys_yield>:

void
sys_yield(void)
{
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6c:	00 
  801a6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a83:	be 00 00 00 00       	mov    $0x0,%esi
  801a88:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a8d:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 20          	sub    $0x20,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aaa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab0:	48 63 c8             	movslq %eax,%rcx
  801ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	48 98                	cltq   
  801abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac3:	00 
  801ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aca:	49 89 c8             	mov    %rcx,%r8
  801acd:	48 89 d1             	mov    %rdx,%rcx
  801ad0:	48 89 c2             	mov    %rax,%rdx
  801ad3:	be 01 00 00 00       	mov    $0x1,%esi
  801ad8:	bf 04 00 00 00       	mov    $0x4,%edi
  801add:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	callq  *%rax
}
  801ae9:	c9                   	leaveq 
  801aea:	c3                   	retq   

0000000000801aeb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801aeb:	55                   	push   %rbp
  801aec:	48 89 e5             	mov    %rsp,%rbp
  801aef:	48 83 ec 30          	sub    $0x30,%rsp
  801af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801afa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801afd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b08:	48 63 c8             	movslq %eax,%rcx
  801b0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b12:	48 63 f0             	movslq %eax,%rsi
  801b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1c:	48 98                	cltq   
  801b1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b22:	49 89 f9             	mov    %rdi,%r9
  801b25:	49 89 f0             	mov    %rsi,%r8
  801b28:	48 89 d1             	mov    %rdx,%rcx
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	be 01 00 00 00       	mov    $0x1,%esi
  801b33:	bf 05 00 00 00       	mov    $0x5,%edi
  801b38:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
}
  801b44:	c9                   	leaveq 
  801b45:	c3                   	retq   

0000000000801b46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	48 83 ec 20          	sub    $0x20,%rsp
  801b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5c:	48 98                	cltq   
  801b5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b65:	00 
  801b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b72:	48 89 d1             	mov    %rdx,%rcx
  801b75:	48 89 c2             	mov    %rax,%rdx
  801b78:	be 01 00 00 00       	mov    $0x1,%esi
  801b7d:	bf 06 00 00 00       	mov    $0x6,%edi
  801b82:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 10          	sub    $0x10,%rsp
  801b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba1:	48 63 d0             	movslq %eax,%rdx
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	48 98                	cltq   
  801ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb0:	00 
  801bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bbd:	48 89 d1             	mov    %rdx,%rcx
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	be 01 00 00 00       	mov    $0x1,%esi
  801bc8:	bf 08 00 00 00       	mov    $0x8,%edi
  801bcd:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 20          	sub    $0x20,%rsp
  801be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf1:	48 98                	cltq   
  801bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfa:	00 
  801bfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c07:	48 89 d1             	mov    %rdx,%rcx
  801c0a:	48 89 c2             	mov    %rax,%rdx
  801c0d:	be 01 00 00 00       	mov    $0x1,%esi
  801c12:	bf 09 00 00 00       	mov    $0x9,%edi
  801c17:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
}
  801c23:	c9                   	leaveq 
  801c24:	c3                   	retq   

0000000000801c25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
  801c29:	48 83 ec 20          	sub    $0x20,%rsp
  801c2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3b:	48 98                	cltq   
  801c3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c44:	00 
  801c45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c51:	48 89 d1             	mov    %rdx,%rcx
  801c54:	48 89 c2             	mov    %rax,%rdx
  801c57:	be 01 00 00 00       	mov    $0x1,%esi
  801c5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c61:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 20          	sub    $0x20,%rsp
  801c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c88:	48 63 f0             	movslq %eax,%rsi
  801c8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9f:	00 
  801ca0:	49 89 f1             	mov    %rsi,%r9
  801ca3:	49 89 c8             	mov    %rcx,%r8
  801ca6:	48 89 d1             	mov    %rdx,%rcx
  801ca9:	48 89 c2             	mov    %rax,%rdx
  801cac:	be 00 00 00 00       	mov    $0x0,%esi
  801cb1:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cb6:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	callq  *%rax
}
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 10          	sub    $0x10,%rsp
  801ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdb:	00 
  801cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ced:	48 89 c2             	mov    %rax,%rdx
  801cf0:	be 01 00 00 00       	mov    $0x1,%esi
  801cf5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cfa:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d17:	00 
  801d18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	be 00 00 00 00       	mov    $0x0,%esi
  801d33:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d38:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 30          	sub    $0x30,%rsp
  801d4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d55:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d5c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d63:	48 63 c8             	movslq %eax,%rcx
  801d66:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6d:	48 63 f0             	movslq %eax,%rsi
  801d70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d77:	48 98                	cltq   
  801d79:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d7d:	49 89 f9             	mov    %rdi,%r9
  801d80:	49 89 f0             	mov    %rsi,%r8
  801d83:	48 89 d1             	mov    %rdx,%rcx
  801d86:	48 89 c2             	mov    %rax,%rdx
  801d89:	be 00 00 00 00       	mov    $0x0,%esi
  801d8e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d93:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801d9a:	00 00 00 
  801d9d:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d9f:	c9                   	leaveq 
  801da0:	c3                   	retq   

0000000000801da1 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	48 83 ec 20          	sub    $0x20,%rsp
  801da9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801db1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc0:	00 
  801dc1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dcd:	48 89 d1             	mov    %rdx,%rcx
  801dd0:	48 89 c2             	mov    %rax,%rdx
  801dd3:	be 00 00 00 00       	mov    $0x0,%esi
  801dd8:	bf 10 00 00 00       	mov    $0x10,%edi
  801ddd:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	callq  *%rax
}
  801de9:	c9                   	leaveq 
  801dea:	c3                   	retq   

0000000000801deb <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801deb:	55                   	push   %rbp
  801dec:	48 89 e5             	mov    %rsp,%rbp
  801def:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801df3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfa:	00 
  801dfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	bf 11 00 00 00       	mov    $0x11,%edi
  801e1b:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801e27:	c9                   	leaveq 
  801e28:	c3                   	retq   

0000000000801e29 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	48 83 ec 10          	sub    $0x10,%rsp
  801e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e37:	48 98                	cltq   
  801e39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e40:	00 
  801e41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e52:	48 89 c2             	mov    %rax,%rdx
  801e55:	be 00 00 00 00       	mov    $0x0,%esi
  801e5a:	bf 12 00 00 00       	mov    $0x12,%edi
  801e5f:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	callq  *%rax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801e75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e7c:	00 
  801e7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e93:	be 00 00 00 00       	mov    $0x0,%esi
  801e98:	bf 13 00 00 00       	mov    $0x13,%edi
  801e9d:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	callq  *%rax
}
  801ea9:	c9                   	leaveq 
  801eaa:	c3                   	retq   

0000000000801eab <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801eab:	55                   	push   %rbp
  801eac:	48 89 e5             	mov    %rsp,%rbp
  801eaf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801eb3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eba:	00 
  801ebb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed1:	be 00 00 00 00       	mov    $0x0,%esi
  801ed6:	bf 14 00 00 00       	mov    $0x14,%edi
  801edb:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
}
  801ee7:	c9                   	leaveq 
  801ee8:	c3                   	retq   

0000000000801ee9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ee9:	55                   	push   %rbp
  801eea:	48 89 e5             	mov    %rsp,%rbp
  801eed:	48 83 ec 08          	sub    $0x8,%rsp
  801ef1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ef5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f00:	ff ff ff 
  801f03:	48 01 d0             	add    %rdx,%rax
  801f06:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f0a:	c9                   	leaveq 
  801f0b:	c3                   	retq   

0000000000801f0c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f0c:	55                   	push   %rbp
  801f0d:	48 89 e5             	mov    %rsp,%rbp
  801f10:	48 83 ec 08          	sub    $0x8,%rsp
  801f14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1c:	48 89 c7             	mov    %rax,%rdi
  801f1f:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f31:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
  801f3b:	48 83 ec 18          	sub    $0x18,%rsp
  801f3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4a:	eb 6b                	jmp    801fb7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4f:	48 98                	cltq   
  801f51:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f57:	48 c1 e0 0c          	shl    $0xc,%rax
  801f5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f63:	48 c1 e8 15          	shr    $0x15,%rax
  801f67:	48 89 c2             	mov    %rax,%rdx
  801f6a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f71:	01 00 00 
  801f74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f78:	83 e0 01             	and    $0x1,%eax
  801f7b:	48 85 c0             	test   %rax,%rax
  801f7e:	74 21                	je     801fa1 <fd_alloc+0x6a>
  801f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f84:	48 c1 e8 0c          	shr    $0xc,%rax
  801f88:	48 89 c2             	mov    %rax,%rdx
  801f8b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f92:	01 00 00 
  801f95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f99:	83 e0 01             	and    $0x1,%eax
  801f9c:	48 85 c0             	test   %rax,%rax
  801f9f:	75 12                	jne    801fb3 <fd_alloc+0x7c>
			*fd_store = fd;
  801fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	eb 1a                	jmp    801fcd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fb3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fb7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fbb:	7e 8f                	jle    801f4c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fc8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fcd:	c9                   	leaveq 
  801fce:	c3                   	retq   

0000000000801fcf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fcf:	55                   	push   %rbp
  801fd0:	48 89 e5             	mov    %rsp,%rbp
  801fd3:	48 83 ec 20          	sub    $0x20,%rsp
  801fd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fde:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fe2:	78 06                	js     801fea <fd_lookup+0x1b>
  801fe4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fe8:	7e 07                	jle    801ff1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fef:	eb 6c                	jmp    80205d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ff1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff4:	48 98                	cltq   
  801ff6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ffc:	48 c1 e0 0c          	shl    $0xc,%rax
  802000:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802008:	48 c1 e8 15          	shr    $0x15,%rax
  80200c:	48 89 c2             	mov    %rax,%rdx
  80200f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802016:	01 00 00 
  802019:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201d:	83 e0 01             	and    $0x1,%eax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	74 21                	je     802046 <fd_lookup+0x77>
  802025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802029:	48 c1 e8 0c          	shr    $0xc,%rax
  80202d:	48 89 c2             	mov    %rax,%rdx
  802030:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802037:	01 00 00 
  80203a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203e:	83 e0 01             	and    $0x1,%eax
  802041:	48 85 c0             	test   %rax,%rax
  802044:	75 07                	jne    80204d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80204b:	eb 10                	jmp    80205d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80204d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802051:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802055:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205d:	c9                   	leaveq 
  80205e:	c3                   	retq   

000000000080205f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80205f:	55                   	push   %rbp
  802060:	48 89 e5             	mov    %rsp,%rbp
  802063:	48 83 ec 30          	sub    $0x30,%rsp
  802067:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80206b:	89 f0                	mov    %esi,%eax
  80206d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802074:	48 89 c7             	mov    %rax,%rdi
  802077:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802087:	48 89 d6             	mov    %rdx,%rsi
  80208a:	89 c7                	mov    %eax,%edi
  80208c:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802093:	00 00 00 
  802096:	ff d0                	callq  *%rax
  802098:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80209b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209f:	78 0a                	js     8020ab <fd_close+0x4c>
	    || fd != fd2)
  8020a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020a9:	74 12                	je     8020bd <fd_close+0x5e>
		return (must_exist ? r : 0);
  8020ab:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020af:	74 05                	je     8020b6 <fd_close+0x57>
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b4:	eb 05                	jmp    8020bb <fd_close+0x5c>
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	eb 69                	jmp    802126 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c1:	8b 00                	mov    (%rax),%eax
  8020c3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020c7:	48 89 d6             	mov    %rdx,%rsi
  8020ca:	89 c7                	mov    %eax,%edi
  8020cc:	48 b8 28 21 80 00 00 	movabs $0x802128,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020df:	78 2a                	js     80210b <fd_close+0xac>
		if (dev->dev_close)
  8020e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020e9:	48 85 c0             	test   %rax,%rax
  8020ec:	74 16                	je     802104 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020fa:	48 89 d7             	mov    %rdx,%rdi
  8020fd:	ff d0                	callq  *%rax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802102:	eb 07                	jmp    80210b <fd_close+0xac>
		else
			r = 0;
  802104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80210b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210f:	48 89 c6             	mov    %rax,%rsi
  802112:	bf 00 00 00 00       	mov    $0x0,%edi
  802117:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
	return r;
  802123:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802126:	c9                   	leaveq 
  802127:	c3                   	retq   

0000000000802128 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802128:	55                   	push   %rbp
  802129:	48 89 e5             	mov    %rsp,%rbp
  80212c:	48 83 ec 20          	sub    $0x20,%rsp
  802130:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802133:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80213e:	eb 41                	jmp    802181 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802140:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802147:	00 00 00 
  80214a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80214d:	48 63 d2             	movslq %edx,%rdx
  802150:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802154:	8b 00                	mov    (%rax),%eax
  802156:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802159:	75 22                	jne    80217d <dev_lookup+0x55>
			*dev = devtab[i];
  80215b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802162:	00 00 00 
  802165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802168:	48 63 d2             	movslq %edx,%rdx
  80216b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80216f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802173:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	eb 60                	jmp    8021dd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80217d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802181:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802188:	00 00 00 
  80218b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80218e:	48 63 d2             	movslq %edx,%rdx
  802191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802195:	48 85 c0             	test   %rax,%rax
  802198:	75 a6                	jne    802140 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80219a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021a1:	00 00 00 
  8021a4:	48 8b 00             	mov    (%rax),%rax
  8021a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ad:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021b0:	89 c6                	mov    %eax,%esi
  8021b2:	48 bf 58 42 80 00 00 	movabs $0x804258,%rdi
  8021b9:	00 00 00 
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  8021c8:	00 00 00 
  8021cb:	ff d1                	callq  *%rcx
	*dev = 0;
  8021cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021dd:	c9                   	leaveq 
  8021de:	c3                   	retq   

00000000008021df <close>:

int
close(int fdnum)
{
  8021df:	55                   	push   %rbp
  8021e0:	48 89 e5             	mov    %rsp,%rbp
  8021e3:	48 83 ec 20          	sub    $0x20,%rsp
  8021e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f1:	48 89 d6             	mov    %rdx,%rsi
  8021f4:	89 c7                	mov    %eax,%edi
  8021f6:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	callq  *%rax
  802202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802209:	79 05                	jns    802210 <close+0x31>
		return r;
  80220b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220e:	eb 18                	jmp    802228 <close+0x49>
	else
		return fd_close(fd, 1);
  802210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802214:	be 01 00 00 00       	mov    $0x1,%esi
  802219:	48 89 c7             	mov    %rax,%rdi
  80221c:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
}
  802228:	c9                   	leaveq 
  802229:	c3                   	retq   

000000000080222a <close_all>:

void
close_all(void)
{
  80222a:	55                   	push   %rbp
  80222b:	48 89 e5             	mov    %rsp,%rbp
  80222e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802239:	eb 15                	jmp    802250 <close_all+0x26>
		close(i);
  80223b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223e:	89 c7                	mov    %eax,%edi
  802240:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802247:	00 00 00 
  80224a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80224c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802250:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802254:	7e e5                	jle    80223b <close_all+0x11>
		close(i);
}
  802256:	c9                   	leaveq 
  802257:	c3                   	retq   

0000000000802258 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802258:	55                   	push   %rbp
  802259:	48 89 e5             	mov    %rsp,%rbp
  80225c:	48 83 ec 40          	sub    $0x40,%rsp
  802260:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802263:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802266:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80226a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80226d:	48 89 d6             	mov    %rdx,%rsi
  802270:	89 c7                	mov    %eax,%edi
  802272:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802281:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802285:	79 08                	jns    80228f <dup+0x37>
		return r;
  802287:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228a:	e9 70 01 00 00       	jmpq   8023ff <dup+0x1a7>
	close(newfdnum);
  80228f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802292:	89 c7                	mov    %eax,%edi
  802294:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  80229b:	00 00 00 
  80229e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a3:	48 98                	cltq   
  8022a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8022af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b7:	48 89 c7             	mov    %rax,%rdi
  8022ba:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8022c1:	00 00 00 
  8022c4:	ff d0                	callq  *%rax
  8022c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 89 c7             	mov    %rax,%rdi
  8022d1:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8022e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e5:	48 c1 e8 15          	shr    $0x15,%rax
  8022e9:	48 89 c2             	mov    %rax,%rdx
  8022ec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f3:	01 00 00 
  8022f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fa:	83 e0 01             	and    $0x1,%eax
  8022fd:	48 85 c0             	test   %rax,%rax
  802300:	74 73                	je     802375 <dup+0x11d>
  802302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802306:	48 c1 e8 0c          	shr    $0xc,%rax
  80230a:	48 89 c2             	mov    %rax,%rdx
  80230d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802314:	01 00 00 
  802317:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231b:	83 e0 01             	and    $0x1,%eax
  80231e:	48 85 c0             	test   %rax,%rax
  802321:	74 52                	je     802375 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802327:	48 c1 e8 0c          	shr    $0xc,%rax
  80232b:	48 89 c2             	mov    %rax,%rdx
  80232e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802335:	01 00 00 
  802338:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233c:	25 07 0e 00 00       	and    $0xe07,%eax
  802341:	89 c1                	mov    %eax,%ecx
  802343:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	41 89 c8             	mov    %ecx,%r8d
  80234e:	48 89 d1             	mov    %rdx,%rcx
  802351:	ba 00 00 00 00       	mov    $0x0,%edx
  802356:	48 89 c6             	mov    %rax,%rsi
  802359:	bf 00 00 00 00       	mov    $0x0,%edi
  80235e:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  802365:	00 00 00 
  802368:	ff d0                	callq  *%rax
  80236a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802371:	79 02                	jns    802375 <dup+0x11d>
			goto err;
  802373:	eb 57                	jmp    8023cc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802379:	48 c1 e8 0c          	shr    $0xc,%rax
  80237d:	48 89 c2             	mov    %rax,%rdx
  802380:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802387:	01 00 00 
  80238a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238e:	25 07 0e 00 00       	and    $0xe07,%eax
  802393:	89 c1                	mov    %eax,%ecx
  802395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802399:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239d:	41 89 c8             	mov    %ecx,%r8d
  8023a0:	48 89 d1             	mov    %rdx,%rcx
  8023a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a8:	48 89 c6             	mov    %rax,%rsi
  8023ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b0:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
  8023bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c3:	79 02                	jns    8023c7 <dup+0x16f>
		goto err;
  8023c5:	eb 05                	jmp    8023cc <dup+0x174>

	return newfdnum;
  8023c7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023ca:	eb 33                	jmp    8023ff <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8023cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d0:	48 89 c6             	mov    %rax,%rsi
  8023d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d8:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e8:	48 89 c6             	mov    %rax,%rsi
  8023eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f0:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8023f7:	00 00 00 
  8023fa:	ff d0                	callq  *%rax
	return r;
  8023fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023ff:	c9                   	leaveq 
  802400:	c3                   	retq   

0000000000802401 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802401:	55                   	push   %rbp
  802402:	48 89 e5             	mov    %rsp,%rbp
  802405:	48 83 ec 40          	sub    $0x40,%rsp
  802409:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802410:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802414:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802418:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80241b:	48 89 d6             	mov    %rdx,%rsi
  80241e:	89 c7                	mov    %eax,%edi
  802420:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax
  80242c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802433:	78 24                	js     802459 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	8b 00                	mov    (%rax),%eax
  80243b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243f:	48 89 d6             	mov    %rdx,%rsi
  802442:	89 c7                	mov    %eax,%edi
  802444:	48 b8 28 21 80 00 00 	movabs $0x802128,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	callq  *%rax
  802450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802457:	79 05                	jns    80245e <read+0x5d>
		return r;
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245c:	eb 76                	jmp    8024d4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80245e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802462:	8b 40 08             	mov    0x8(%rax),%eax
  802465:	83 e0 03             	and    $0x3,%eax
  802468:	83 f8 01             	cmp    $0x1,%eax
  80246b:	75 3a                	jne    8024a7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80246d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802474:	00 00 00 
  802477:	48 8b 00             	mov    (%rax),%rax
  80247a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802480:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802483:	89 c6                	mov    %eax,%esi
  802485:	48 bf 77 42 80 00 00 	movabs $0x804277,%rdi
  80248c:	00 00 00 
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  80249b:	00 00 00 
  80249e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a5:	eb 2d                	jmp    8024d4 <read+0xd3>
	}
	if (!dev->dev_read)
  8024a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ab:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024af:	48 85 c0             	test   %rax,%rax
  8024b2:	75 07                	jne    8024bb <read+0xba>
		return -E_NOT_SUPP;
  8024b4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b9:	eb 19                	jmp    8024d4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024cb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024cf:	48 89 cf             	mov    %rcx,%rdi
  8024d2:	ff d0                	callq  *%rax
}
  8024d4:	c9                   	leaveq 
  8024d5:	c3                   	retq   

00000000008024d6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024d6:	55                   	push   %rbp
  8024d7:	48 89 e5             	mov    %rsp,%rbp
  8024da:	48 83 ec 30          	sub    $0x30,%rsp
  8024de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024f0:	eb 49                	jmp    80253b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	48 98                	cltq   
  8024f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024fb:	48 29 c2             	sub    %rax,%rdx
  8024fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802501:	48 63 c8             	movslq %eax,%rcx
  802504:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802508:	48 01 c1             	add    %rax,%rcx
  80250b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250e:	48 89 ce             	mov    %rcx,%rsi
  802511:	89 c7                	mov    %eax,%edi
  802513:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  80251a:	00 00 00 
  80251d:	ff d0                	callq  *%rax
  80251f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802522:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802526:	79 05                	jns    80252d <readn+0x57>
			return m;
  802528:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80252b:	eb 1c                	jmp    802549 <readn+0x73>
		if (m == 0)
  80252d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802531:	75 02                	jne    802535 <readn+0x5f>
			break;
  802533:	eb 11                	jmp    802546 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802535:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802538:	01 45 fc             	add    %eax,-0x4(%rbp)
  80253b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253e:	48 98                	cltq   
  802540:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802544:	72 ac                	jb     8024f2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802546:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802549:	c9                   	leaveq 
  80254a:	c3                   	retq   

000000000080254b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80254b:	55                   	push   %rbp
  80254c:	48 89 e5             	mov    %rsp,%rbp
  80254f:	48 83 ec 40          	sub    $0x40,%rsp
  802553:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802556:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80255a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80255e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802562:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802565:	48 89 d6             	mov    %rdx,%rsi
  802568:	89 c7                	mov    %eax,%edi
  80256a:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
  802576:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257d:	78 24                	js     8025a3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	8b 00                	mov    (%rax),%eax
  802585:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802589:	48 89 d6             	mov    %rdx,%rsi
  80258c:	89 c7                	mov    %eax,%edi
  80258e:	48 b8 28 21 80 00 00 	movabs $0x802128,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
  80259a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a1:	79 05                	jns    8025a8 <write+0x5d>
		return r;
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	eb 42                	jmp    8025ea <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ac:	8b 40 08             	mov    0x8(%rax),%eax
  8025af:	83 e0 03             	and    $0x3,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	75 07                	jne    8025bd <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025bb:	eb 2d                	jmp    8025ea <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025c5:	48 85 c0             	test   %rax,%rax
  8025c8:	75 07                	jne    8025d1 <write+0x86>
		return -E_NOT_SUPP;
  8025ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025cf:	eb 19                	jmp    8025ea <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8025d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025e1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025e5:	48 89 cf             	mov    %rcx,%rdi
  8025e8:	ff d0                	callq  *%rax
}
  8025ea:	c9                   	leaveq 
  8025eb:	c3                   	retq   

00000000008025ec <seek>:

int
seek(int fdnum, off_t offset)
{
  8025ec:	55                   	push   %rbp
  8025ed:	48 89 e5             	mov    %rsp,%rbp
  8025f0:	48 83 ec 18          	sub    $0x18,%rsp
  8025f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025f7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802601:	48 89 d6             	mov    %rdx,%rsi
  802604:	89 c7                	mov    %eax,%edi
  802606:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
  802612:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802615:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802619:	79 05                	jns    802620 <seek+0x34>
		return r;
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261e:	eb 0f                	jmp    80262f <seek+0x43>
	fd->fd_offset = offset;
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802627:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262f:	c9                   	leaveq 
  802630:	c3                   	retq   

0000000000802631 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	48 83 ec 30          	sub    $0x30,%rsp
  802639:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80263c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80263f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802643:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802646:	48 89 d6             	mov    %rdx,%rsi
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	78 24                	js     802684 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802664:	8b 00                	mov    (%rax),%eax
  802666:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80266a:	48 89 d6             	mov    %rdx,%rsi
  80266d:	89 c7                	mov    %eax,%edi
  80266f:	48 b8 28 21 80 00 00 	movabs $0x802128,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
  80267b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802682:	79 05                	jns    802689 <ftruncate+0x58>
		return r;
  802684:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802687:	eb 72                	jmp    8026fb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268d:	8b 40 08             	mov    0x8(%rax),%eax
  802690:	83 e0 03             	and    $0x3,%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	75 3a                	jne    8026d1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802697:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80269e:	00 00 00 
  8026a1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026aa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ad:	89 c6                	mov    %eax,%esi
  8026af:	48 bf 98 42 80 00 00 	movabs $0x804298,%rdi
  8026b6:	00 00 00 
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	48 b9 b7 05 80 00 00 	movabs $0x8005b7,%rcx
  8026c5:	00 00 00 
  8026c8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026cf:	eb 2a                	jmp    8026fb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026d9:	48 85 c0             	test   %rax,%rax
  8026dc:	75 07                	jne    8026e5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026de:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026e3:	eb 16                	jmp    8026fb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026f1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026f4:	89 ce                	mov    %ecx,%esi
  8026f6:	48 89 d7             	mov    %rdx,%rdi
  8026f9:	ff d0                	callq  *%rax
}
  8026fb:	c9                   	leaveq 
  8026fc:	c3                   	retq   

00000000008026fd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026fd:	55                   	push   %rbp
  8026fe:	48 89 e5             	mov    %rsp,%rbp
  802701:	48 83 ec 30          	sub    $0x30,%rsp
  802705:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802708:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80270c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802710:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	89 c7                	mov    %eax,%edi
  802718:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
  802724:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272b:	78 24                	js     802751 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80272d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802731:	8b 00                	mov    (%rax),%eax
  802733:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802737:	48 89 d6             	mov    %rdx,%rsi
  80273a:	89 c7                	mov    %eax,%edi
  80273c:	48 b8 28 21 80 00 00 	movabs $0x802128,%rax
  802743:	00 00 00 
  802746:	ff d0                	callq  *%rax
  802748:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274f:	79 05                	jns    802756 <fstat+0x59>
		return r;
  802751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802754:	eb 5e                	jmp    8027b4 <fstat+0xb7>
	if (!dev->dev_stat)
  802756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80275e:	48 85 c0             	test   %rax,%rax
  802761:	75 07                	jne    80276a <fstat+0x6d>
		return -E_NOT_SUPP;
  802763:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802768:	eb 4a                	jmp    8027b4 <fstat+0xb7>
	stat->st_name[0] = 0;
  80276a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80276e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802775:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80277c:	00 00 00 
	stat->st_isdir = 0;
  80277f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802783:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80278a:	00 00 00 
	stat->st_dev = dev;
  80278d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802791:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802795:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80279c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027a8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027ac:	48 89 ce             	mov    %rcx,%rsi
  8027af:	48 89 d7             	mov    %rdx,%rdi
  8027b2:	ff d0                	callq  *%rax
}
  8027b4:	c9                   	leaveq 
  8027b5:	c3                   	retq   

00000000008027b6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	48 83 ec 20          	sub    $0x20,%rsp
  8027be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	be 00 00 00 00       	mov    $0x0,%esi
  8027cf:	48 89 c7             	mov    %rax,%rdi
  8027d2:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  8027d9:	00 00 00 
  8027dc:	ff d0                	callq  *%rax
  8027de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e5:	79 05                	jns    8027ec <stat+0x36>
		return fd;
  8027e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ea:	eb 2f                	jmp    80281b <stat+0x65>
	r = fstat(fd, stat);
  8027ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f3:	48 89 d6             	mov    %rdx,%rsi
  8027f6:	89 c7                	mov    %eax,%edi
  8027f8:	48 b8 fd 26 80 00 00 	movabs $0x8026fd,%rax
  8027ff:	00 00 00 
  802802:	ff d0                	callq  *%rax
  802804:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	89 c7                	mov    %eax,%edi
  80280c:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
	return r;
  802818:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 10          	sub    $0x10,%rsp
  802825:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802828:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80282c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802833:	00 00 00 
  802836:	8b 00                	mov    (%rax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	75 1d                	jne    802859 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80283c:	bf 01 00 00 00       	mov    $0x1,%edi
  802841:	48 b8 c0 3b 80 00 00 	movabs $0x803bc0,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax
  80284d:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802854:	00 00 00 
  802857:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802859:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802860:	00 00 00 
  802863:	8b 00                	mov    (%rax),%eax
  802865:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802868:	b9 07 00 00 00       	mov    $0x7,%ecx
  80286d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802874:	00 00 00 
  802877:	89 c7                	mov    %eax,%edi
  802879:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802889:	ba 00 00 00 00       	mov    $0x0,%edx
  80288e:	48 89 c6             	mov    %rax,%rsi
  802891:	bf 00 00 00 00       	mov    $0x0,%edi
  802896:	48 b8 3a 3a 80 00 00 	movabs $0x803a3a,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
}
  8028a2:	c9                   	leaveq 
  8028a3:	c3                   	retq   

00000000008028a4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	48 83 ec 30          	sub    $0x30,%rsp
  8028ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028b0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8028b3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8028ba:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8028c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8028c8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028cd:	75 08                	jne    8028d7 <open+0x33>
	{
		return r;
  8028cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d2:	e9 f2 00 00 00       	jmpq   8029c9 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8028d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028db:	48 89 c7             	mov    %rax,%rdi
  8028de:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028ed:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8028f4:	7e 0a                	jle    802900 <open+0x5c>
	{
		return -E_BAD_PATH;
  8028f6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028fb:	e9 c9 00 00 00       	jmpq   8029c9 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802900:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802907:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802908:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80290c:	48 89 c7             	mov    %rax,%rdi
  80290f:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802922:	78 09                	js     80292d <open+0x89>
  802924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802928:	48 85 c0             	test   %rax,%rax
  80292b:	75 08                	jne    802935 <open+0x91>
		{
			return r;
  80292d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802930:	e9 94 00 00 00       	jmpq   8029c9 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802939:	ba 00 04 00 00       	mov    $0x400,%edx
  80293e:	48 89 c6             	mov    %rax,%rsi
  802941:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802948:	00 00 00 
  80294b:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  802952:	00 00 00 
  802955:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802957:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295e:	00 00 00 
  802961:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802964:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80296a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296e:	48 89 c6             	mov    %rax,%rsi
  802971:	bf 01 00 00 00       	mov    $0x1,%edi
  802976:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
  802982:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802985:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802989:	79 2b                	jns    8029b6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80298b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298f:	be 00 00 00 00       	mov    $0x0,%esi
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8029a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029aa:	79 05                	jns    8029b1 <open+0x10d>
			{
				return d;
  8029ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029af:	eb 18                	jmp    8029c9 <open+0x125>
			}
			return r;
  8029b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b4:	eb 13                	jmp    8029c9 <open+0x125>
		}	
		return fd2num(fd_store);
  8029b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ba:	48 89 c7             	mov    %rax,%rdi
  8029bd:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8029c9:	c9                   	leaveq 
  8029ca:	c3                   	retq   

00000000008029cb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029cb:	55                   	push   %rbp
  8029cc:	48 89 e5             	mov    %rsp,%rbp
  8029cf:	48 83 ec 10          	sub    $0x10,%rsp
  8029d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029db:	8b 50 0c             	mov    0xc(%rax),%edx
  8029de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029e5:	00 00 00 
  8029e8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029ea:	be 00 00 00 00       	mov    $0x0,%esi
  8029ef:	bf 06 00 00 00       	mov    $0x6,%edi
  8029f4:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax
}
  802a00:	c9                   	leaveq 
  802a01:	c3                   	retq   

0000000000802a02 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a02:	55                   	push   %rbp
  802a03:	48 89 e5             	mov    %rsp,%rbp
  802a06:	48 83 ec 30          	sub    $0x30,%rsp
  802a0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a12:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802a16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802a1d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a22:	74 07                	je     802a2b <devfile_read+0x29>
  802a24:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a29:	75 07                	jne    802a32 <devfile_read+0x30>
		return -E_INVAL;
  802a2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a30:	eb 77                	jmp    802aa9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a36:	8b 50 0c             	mov    0xc(%rax),%edx
  802a39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a40:	00 00 00 
  802a43:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4c:	00 00 00 
  802a4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a53:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a57:	be 00 00 00 00       	mov    $0x0,%esi
  802a5c:	bf 03 00 00 00       	mov    $0x3,%edi
  802a61:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a74:	7f 05                	jg     802a7b <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a79:	eb 2e                	jmp    802aa9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7e:	48 63 d0             	movslq %eax,%rdx
  802a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a85:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a8c:	00 00 00 
  802a8f:	48 89 c7             	mov    %rax,%rdi
  802a92:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802a99:	00 00 00 
  802a9c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802aa9:	c9                   	leaveq 
  802aaa:	c3                   	retq   

0000000000802aab <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802aab:	55                   	push   %rbp
  802aac:	48 89 e5             	mov    %rsp,%rbp
  802aaf:	48 83 ec 30          	sub    $0x30,%rsp
  802ab3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ab7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802abb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802abf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802ac6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802acb:	74 07                	je     802ad4 <devfile_write+0x29>
  802acd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ad2:	75 08                	jne    802adc <devfile_write+0x31>
		return r;
  802ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad7:	e9 9a 00 00 00       	jmpq   802b76 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ae3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aea:	00 00 00 
  802aed:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802aef:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802af6:	00 
  802af7:	76 08                	jbe    802b01 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802af9:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802b00:	00 
	}
	fsipcbuf.write.req_n = n;
  802b01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b08:	00 00 00 
  802b0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b0f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802b13:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1b:	48 89 c6             	mov    %rax,%rsi
  802b1e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802b25:	00 00 00 
  802b28:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  802b2f:	00 00 00 
  802b32:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802b34:	be 00 00 00 00       	mov    $0x0,%esi
  802b39:	bf 04 00 00 00       	mov    $0x4,%edi
  802b3e:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802b45:	00 00 00 
  802b48:	ff d0                	callq  *%rax
  802b4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b51:	7f 20                	jg     802b73 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802b53:	48 bf be 42 80 00 00 	movabs $0x8042be,%rdi
  802b5a:	00 00 00 
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802b69:	00 00 00 
  802b6c:	ff d2                	callq  *%rdx
		return r;
  802b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b71:	eb 03                	jmp    802b76 <devfile_write+0xcb>
	}
	return r;
  802b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b76:	c9                   	leaveq 
  802b77:	c3                   	retq   

0000000000802b78 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	48 83 ec 20          	sub    $0x20,%rsp
  802b80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b8f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b96:	00 00 00 
  802b99:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b9b:	be 00 00 00 00       	mov    $0x0,%esi
  802ba0:	bf 05 00 00 00       	mov    $0x5,%edi
  802ba5:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802bac:	00 00 00 
  802baf:	ff d0                	callq  *%rax
  802bb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb8:	79 05                	jns    802bbf <devfile_stat+0x47>
		return r;
  802bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbd:	eb 56                	jmp    802c15 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802bca:	00 00 00 
  802bcd:	48 89 c7             	mov    %rax,%rdi
  802bd0:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802bdc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802be3:	00 00 00 
  802be6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bf6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bfd:	00 00 00 
  802c00:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c0a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c15:	c9                   	leaveq 
  802c16:	c3                   	retq   

0000000000802c17 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c17:	55                   	push   %rbp
  802c18:	48 89 e5             	mov    %rsp,%rbp
  802c1b:	48 83 ec 10          	sub    $0x10,%rsp
  802c1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c23:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c2a:	8b 50 0c             	mov    0xc(%rax),%edx
  802c2d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c34:	00 00 00 
  802c37:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c40:	00 00 00 
  802c43:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c46:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c49:	be 00 00 00 00       	mov    $0x0,%esi
  802c4e:	bf 02 00 00 00       	mov    $0x2,%edi
  802c53:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	callq  *%rax
}
  802c5f:	c9                   	leaveq 
  802c60:	c3                   	retq   

0000000000802c61 <remove>:

// Delete a file
int
remove(const char *path)
{
  802c61:	55                   	push   %rbp
  802c62:	48 89 e5             	mov    %rsp,%rbp
  802c65:	48 83 ec 10          	sub    $0x10,%rsp
  802c69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c71:	48 89 c7             	mov    %rax,%rdi
  802c74:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
  802c80:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c85:	7e 07                	jle    802c8e <remove+0x2d>
		return -E_BAD_PATH;
  802c87:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c8c:	eb 33                	jmp    802cc1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c92:	48 89 c6             	mov    %rax,%rsi
  802c95:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c9c:	00 00 00 
  802c9f:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cab:	be 00 00 00 00       	mov    $0x0,%esi
  802cb0:	bf 07 00 00 00       	mov    $0x7,%edi
  802cb5:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	callq  *%rax
}
  802cc1:	c9                   	leaveq 
  802cc2:	c3                   	retq   

0000000000802cc3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802cc3:	55                   	push   %rbp
  802cc4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cc7:	be 00 00 00 00       	mov    $0x0,%esi
  802ccc:	bf 08 00 00 00       	mov    $0x8,%edi
  802cd1:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
}
  802cdd:	5d                   	pop    %rbp
  802cde:	c3                   	retq   

0000000000802cdf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802cdf:	55                   	push   %rbp
  802ce0:	48 89 e5             	mov    %rsp,%rbp
  802ce3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802cea:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802cf1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802cf8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802cff:	be 00 00 00 00       	mov    $0x0,%esi
  802d04:	48 89 c7             	mov    %rax,%rdi
  802d07:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
  802d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d1a:	79 28                	jns    802d44 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1f:	89 c6                	mov    %eax,%esi
  802d21:	48 bf da 42 80 00 00 	movabs $0x8042da,%rdi
  802d28:	00 00 00 
  802d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d30:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d37:	00 00 00 
  802d3a:	ff d2                	callq  *%rdx
		return fd_src;
  802d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3f:	e9 74 01 00 00       	jmpq   802eb8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d44:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d4b:	be 01 01 00 00       	mov    $0x101,%esi
  802d50:	48 89 c7             	mov    %rax,%rdi
  802d53:	48 b8 a4 28 80 00 00 	movabs $0x8028a4,%rax
  802d5a:	00 00 00 
  802d5d:	ff d0                	callq  *%rax
  802d5f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d62:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d66:	79 39                	jns    802da1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d6b:	89 c6                	mov    %eax,%esi
  802d6d:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  802d74:	00 00 00 
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7c:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802d83:	00 00 00 
  802d86:	ff d2                	callq  *%rdx
		close(fd_src);
  802d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8b:	89 c7                	mov    %eax,%edi
  802d8d:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
		return fd_dest;
  802d99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d9c:	e9 17 01 00 00       	jmpq   802eb8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802da1:	eb 74                	jmp    802e17 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802da3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802da6:	48 63 d0             	movslq %eax,%rdx
  802da9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802db0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db3:	48 89 ce             	mov    %rcx,%rsi
  802db6:	89 c7                	mov    %eax,%edi
  802db8:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
  802dc4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802dcb:	79 4a                	jns    802e17 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802dcd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dd0:	89 c6                	mov    %eax,%esi
  802dd2:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802dd9:	00 00 00 
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802de8:	00 00 00 
  802deb:	ff d2                	callq  *%rdx
			close(fd_src);
  802ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df0:	89 c7                	mov    %eax,%edi
  802df2:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802df9:	00 00 00 
  802dfc:	ff d0                	callq  *%rax
			close(fd_dest);
  802dfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e01:	89 c7                	mov    %eax,%edi
  802e03:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
			return write_size;
  802e0f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e12:	e9 a1 00 00 00       	jmpq   802eb8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e17:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	ba 00 02 00 00       	mov    $0x200,%edx
  802e26:	48 89 ce             	mov    %rcx,%rsi
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e3e:	0f 8f 5f ff ff ff    	jg     802da3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e48:	79 47                	jns    802e91 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e4a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e4d:	89 c6                	mov    %eax,%esi
  802e4f:	48 bf 1d 43 80 00 00 	movabs $0x80431d,%rdi
  802e56:	00 00 00 
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  802e65:	00 00 00 
  802e68:	ff d2                	callq  *%rdx
		close(fd_src);
  802e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6d:	89 c7                	mov    %eax,%edi
  802e6f:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
		close(fd_dest);
  802e7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e7e:	89 c7                	mov    %eax,%edi
  802e80:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	callq  *%rax
		return read_size;
  802e8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e8f:	eb 27                	jmp    802eb8 <copy+0x1d9>
	}
	close(fd_src);
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	89 c7                	mov    %eax,%edi
  802e96:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
	close(fd_dest);
  802ea2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 df 21 80 00 00 	movabs $0x8021df,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
	return 0;
  802eb3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802eb8:	c9                   	leaveq 
  802eb9:	c3                   	retq   

0000000000802eba <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802eba:	55                   	push   %rbp
  802ebb:	48 89 e5             	mov    %rsp,%rbp
  802ebe:	48 83 ec 20          	sub    $0x20,%rsp
  802ec2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eca:	8b 40 0c             	mov    0xc(%rax),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	7e 67                	jle    802f38 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed5:	8b 40 04             	mov    0x4(%rax),%eax
  802ed8:	48 63 d0             	movslq %eax,%rdx
  802edb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edf:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee7:	8b 00                	mov    (%rax),%eax
  802ee9:	48 89 ce             	mov    %rcx,%rsi
  802eec:	89 c7                	mov    %eax,%edi
  802eee:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
  802efa:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f01:	7e 13                	jle    802f16 <writebuf+0x5c>
			b->result += result;
  802f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f07:	8b 50 08             	mov    0x8(%rax),%edx
  802f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f13:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1a:	8b 40 04             	mov    0x4(%rax),%eax
  802f1d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f20:	74 16                	je     802f38 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2b:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802f2f:	89 c2                	mov    %eax,%edx
  802f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f35:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802f38:	c9                   	leaveq 
  802f39:	c3                   	retq   

0000000000802f3a <putch>:

static void
putch(int ch, void *thunk)
{
  802f3a:	55                   	push   %rbp
  802f3b:	48 89 e5             	mov    %rsp,%rbp
  802f3e:	48 83 ec 20          	sub    $0x20,%rsp
  802f42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802f49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f55:	8b 40 04             	mov    0x4(%rax),%eax
  802f58:	8d 48 01             	lea    0x1(%rax),%ecx
  802f5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f5f:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802f62:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f65:	89 d1                	mov    %edx,%ecx
  802f67:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f6b:	48 98                	cltq   
  802f6d:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f75:	8b 40 04             	mov    0x4(%rax),%eax
  802f78:	3d 00 01 00 00       	cmp    $0x100,%eax
  802f7d:	75 1e                	jne    802f9d <putch+0x63>
		writebuf(b);
  802f7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f83:	48 89 c7             	mov    %rax,%rdi
  802f86:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
		b->idx = 0;
  802f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f9d:	c9                   	leaveq 
  802f9e:	c3                   	retq   

0000000000802f9f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f9f:	55                   	push   %rbp
  802fa0:	48 89 e5             	mov    %rsp,%rbp
  802fa3:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802faa:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802fb0:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802fb7:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802fbe:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802fc4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802fca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802fd1:	00 00 00 
	b.result = 0;
  802fd4:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802fdb:	00 00 00 
	b.error = 1;
  802fde:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802fe5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802fe8:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802fef:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802ff6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ffd:	48 89 c6             	mov    %rax,%rsi
  803000:	48 bf 3a 2f 80 00 00 	movabs $0x802f3a,%rdi
  803007:	00 00 00 
  80300a:	48 b8 6a 09 80 00 00 	movabs $0x80096a,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803016:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	7e 16                	jle    803036 <vfprintf+0x97>
		writebuf(&b);
  803020:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803027:	48 89 c7             	mov    %rax,%rdi
  80302a:	48 b8 ba 2e 80 00 00 	movabs $0x802eba,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803036:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 08                	je     803048 <vfprintf+0xa9>
  803040:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803046:	eb 06                	jmp    80304e <vfprintf+0xaf>
  803048:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80304e:	c9                   	leaveq 
  80304f:	c3                   	retq   

0000000000803050 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803050:	55                   	push   %rbp
  803051:	48 89 e5             	mov    %rsp,%rbp
  803054:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80305b:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803061:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803068:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80306f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803076:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80307d:	84 c0                	test   %al,%al
  80307f:	74 20                	je     8030a1 <fprintf+0x51>
  803081:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803085:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803089:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80308d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803091:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803095:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803099:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80309d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030a1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030a8:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8030af:	00 00 00 
  8030b2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030b9:	00 00 00 
  8030bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030c0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030c7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030ce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8030d5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030dc:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8030e3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030e9:	48 89 ce             	mov    %rcx,%rsi
  8030ec:	89 c7                	mov    %eax,%edi
  8030ee:	48 b8 9f 2f 80 00 00 	movabs $0x802f9f,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803100:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803106:	c9                   	leaveq 
  803107:	c3                   	retq   

0000000000803108 <printf>:

int
printf(const char *fmt, ...)
{
  803108:	55                   	push   %rbp
  803109:	48 89 e5             	mov    %rsp,%rbp
  80310c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803113:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80311a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803121:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803128:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80312f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803136:	84 c0                	test   %al,%al
  803138:	74 20                	je     80315a <printf+0x52>
  80313a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80313e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803142:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803146:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80314a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80314e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803152:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803156:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80315a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803161:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803168:	00 00 00 
  80316b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803172:	00 00 00 
  803175:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803179:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803180:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803187:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80318e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803195:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80319c:	48 89 c6             	mov    %rax,%rsi
  80319f:	bf 01 00 00 00       	mov    $0x1,%edi
  8031a4:	48 b8 9f 2f 80 00 00 	movabs $0x802f9f,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
  8031b0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031bc:	c9                   	leaveq 
  8031bd:	c3                   	retq   

00000000008031be <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031be:	55                   	push   %rbp
  8031bf:	48 89 e5             	mov    %rsp,%rbp
  8031c2:	53                   	push   %rbx
  8031c3:	48 83 ec 38          	sub    $0x38,%rsp
  8031c7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031cb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031cf:	48 89 c7             	mov    %rax,%rdi
  8031d2:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031e5:	0f 88 bf 01 00 00    	js     8033aa <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8031f4:	48 89 c6             	mov    %rax,%rsi
  8031f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8031fc:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
  803208:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80320b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80320f:	0f 88 95 01 00 00    	js     8033aa <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803215:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803219:	48 89 c7             	mov    %rax,%rdi
  80321c:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80322f:	0f 88 5d 01 00 00    	js     803392 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803235:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803239:	ba 07 04 00 00       	mov    $0x407,%edx
  80323e:	48 89 c6             	mov    %rax,%rsi
  803241:	bf 00 00 00 00       	mov    $0x0,%edi
  803246:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
  803252:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803255:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803259:	0f 88 33 01 00 00    	js     803392 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80325f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803263:	48 89 c7             	mov    %rax,%rdi
  803266:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
  803272:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803276:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80327a:	ba 07 04 00 00       	mov    $0x407,%edx
  80327f:	48 89 c6             	mov    %rax,%rsi
  803282:	bf 00 00 00 00       	mov    $0x0,%edi
  803287:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329a:	79 05                	jns    8032a1 <pipe+0xe3>
		goto err2;
  80329c:	e9 d9 00 00 00       	jmpq   80337a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a5:	48 89 c7             	mov    %rax,%rdi
  8032a8:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	48 89 c2             	mov    %rax,%rdx
  8032b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032c1:	48 89 d1             	mov    %rdx,%rcx
  8032c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c9:	48 89 c6             	mov    %rax,%rsi
  8032cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d1:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
  8032dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e4:	79 1b                	jns    803301 <pipe+0x143>
		goto err3;
  8032e6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032eb:	48 89 c6             	mov    %rax,%rsi
  8032ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f3:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
  8032ff:	eb 79                	jmp    80337a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803305:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80330c:	00 00 00 
  80330f:	8b 12                	mov    (%rdx),%edx
  803311:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803313:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803317:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80331e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803322:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803329:	00 00 00 
  80332c:	8b 12                	mov    (%rdx),%edx
  80332e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803330:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803334:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80333b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80333f:	48 89 c7             	mov    %rax,%rdi
  803342:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
  80334e:	89 c2                	mov    %eax,%edx
  803350:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803354:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803356:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80335a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80335e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803362:	48 89 c7             	mov    %rax,%rdi
  803365:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 03                	mov    %eax,(%rbx)
	return 0;
  803373:	b8 00 00 00 00       	mov    $0x0,%eax
  803378:	eb 33                	jmp    8033ad <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80337a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337e:	48 89 c6             	mov    %rax,%rsi
  803381:	bf 00 00 00 00       	mov    $0x0,%edi
  803386:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803396:	48 89 c6             	mov    %rax,%rsi
  803399:	bf 00 00 00 00       	mov    $0x0,%edi
  80339e:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
err:
	return r;
  8033aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033ad:	48 83 c4 38          	add    $0x38,%rsp
  8033b1:	5b                   	pop    %rbx
  8033b2:	5d                   	pop    %rbp
  8033b3:	c3                   	retq   

00000000008033b4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033b4:	55                   	push   %rbp
  8033b5:	48 89 e5             	mov    %rsp,%rbp
  8033b8:	53                   	push   %rbx
  8033b9:	48 83 ec 28          	sub    $0x28,%rsp
  8033bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033c5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033cc:	00 00 00 
  8033cf:	48 8b 00             	mov    (%rax),%rax
  8033d2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033df:	48 89 c7             	mov    %rax,%rdi
  8033e2:	48 b8 32 3c 80 00 00 	movabs $0x803c32,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
  8033ee:	89 c3                	mov    %eax,%ebx
  8033f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f4:	48 89 c7             	mov    %rax,%rdi
  8033f7:	48 b8 32 3c 80 00 00 	movabs $0x803c32,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
  803403:	39 c3                	cmp    %eax,%ebx
  803405:	0f 94 c0             	sete   %al
  803408:	0f b6 c0             	movzbl %al,%eax
  80340b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80340e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803415:	00 00 00 
  803418:	48 8b 00             	mov    (%rax),%rax
  80341b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803421:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803427:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80342a:	75 05                	jne    803431 <_pipeisclosed+0x7d>
			return ret;
  80342c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80342f:	eb 4f                	jmp    803480 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803431:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803434:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803437:	74 42                	je     80347b <_pipeisclosed+0xc7>
  803439:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80343d:	75 3c                	jne    80347b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80343f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803446:	00 00 00 
  803449:	48 8b 00             	mov    (%rax),%rax
  80344c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803452:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803455:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803458:	89 c6                	mov    %eax,%esi
  80345a:	48 bf 3d 43 80 00 00 	movabs $0x80433d,%rdi
  803461:	00 00 00 
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
  803469:	49 b8 b7 05 80 00 00 	movabs $0x8005b7,%r8
  803470:	00 00 00 
  803473:	41 ff d0             	callq  *%r8
	}
  803476:	e9 4a ff ff ff       	jmpq   8033c5 <_pipeisclosed+0x11>
  80347b:	e9 45 ff ff ff       	jmpq   8033c5 <_pipeisclosed+0x11>
}
  803480:	48 83 c4 28          	add    $0x28,%rsp
  803484:	5b                   	pop    %rbx
  803485:	5d                   	pop    %rbp
  803486:	c3                   	retq   

0000000000803487 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803487:	55                   	push   %rbp
  803488:	48 89 e5             	mov    %rsp,%rbp
  80348b:	48 83 ec 30          	sub    $0x30,%rsp
  80348f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803492:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803496:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803499:	48 89 d6             	mov    %rdx,%rsi
  80349c:	89 c7                	mov    %eax,%edi
  80349e:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b1:	79 05                	jns    8034b8 <pipeisclosed+0x31>
		return r;
  8034b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b6:	eb 31                	jmp    8034e9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bc:	48 89 c7             	mov    %rax,%rdi
  8034bf:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
  8034cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034d7:	48 89 d6             	mov    %rdx,%rsi
  8034da:	48 89 c7             	mov    %rax,%rdi
  8034dd:	48 b8 b4 33 80 00 00 	movabs $0x8033b4,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 83 ec 40          	sub    $0x40,%rsp
  8034f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803503:	48 89 c7             	mov    %rax,%rdi
  803506:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803516:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80351e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803525:	00 
  803526:	e9 92 00 00 00       	jmpq   8035bd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80352b:	eb 41                	jmp    80356e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80352d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803532:	74 09                	je     80353d <devpipe_read+0x52>
				return i;
  803534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803538:	e9 92 00 00 00       	jmpq   8035cf <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80353d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803541:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803545:	48 89 d6             	mov    %rdx,%rsi
  803548:	48 89 c7             	mov    %rax,%rdi
  80354b:	48 b8 b4 33 80 00 00 	movabs $0x8033b4,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 07                	je     803562 <devpipe_read+0x77>
				return 0;
  80355b:	b8 00 00 00 00       	mov    $0x0,%eax
  803560:	eb 6d                	jmp    8035cf <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803562:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80356e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803572:	8b 10                	mov    (%rax),%edx
  803574:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803578:	8b 40 04             	mov    0x4(%rax),%eax
  80357b:	39 c2                	cmp    %eax,%edx
  80357d:	74 ae                	je     80352d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80357f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803587:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80358b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358f:	8b 00                	mov    (%rax),%eax
  803591:	99                   	cltd   
  803592:	c1 ea 1b             	shr    $0x1b,%edx
  803595:	01 d0                	add    %edx,%eax
  803597:	83 e0 1f             	and    $0x1f,%eax
  80359a:	29 d0                	sub    %edx,%eax
  80359c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035a0:	48 98                	cltq   
  8035a2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035a7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ad:	8b 00                	mov    (%rax),%eax
  8035af:	8d 50 01             	lea    0x1(%rax),%edx
  8035b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035c5:	0f 82 60 ff ff ff    	jb     80352b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035cf:	c9                   	leaveq 
  8035d0:	c3                   	retq   

00000000008035d1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035d1:	55                   	push   %rbp
  8035d2:	48 89 e5             	mov    %rsp,%rbp
  8035d5:	48 83 ec 40          	sub    $0x40,%rsp
  8035d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e9:	48 89 c7             	mov    %rax,%rdi
  8035ec:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
  8035f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803600:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803604:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80360b:	00 
  80360c:	e9 8e 00 00 00       	jmpq   80369f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803611:	eb 31                	jmp    803644 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803613:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361b:	48 89 d6             	mov    %rdx,%rsi
  80361e:	48 89 c7             	mov    %rax,%rdi
  803621:	48 b8 b4 33 80 00 00 	movabs $0x8033b4,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 07                	je     803638 <devpipe_write+0x67>
				return 0;
  803631:	b8 00 00 00 00       	mov    $0x0,%eax
  803636:	eb 79                	jmp    8036b1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803638:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803648:	8b 40 04             	mov    0x4(%rax),%eax
  80364b:	48 63 d0             	movslq %eax,%rdx
  80364e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803652:	8b 00                	mov    (%rax),%eax
  803654:	48 98                	cltq   
  803656:	48 83 c0 20          	add    $0x20,%rax
  80365a:	48 39 c2             	cmp    %rax,%rdx
  80365d:	73 b4                	jae    803613 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80365f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803663:	8b 40 04             	mov    0x4(%rax),%eax
  803666:	99                   	cltd   
  803667:	c1 ea 1b             	shr    $0x1b,%edx
  80366a:	01 d0                	add    %edx,%eax
  80366c:	83 e0 1f             	and    $0x1f,%eax
  80366f:	29 d0                	sub    %edx,%eax
  803671:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803675:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803679:	48 01 ca             	add    %rcx,%rdx
  80367c:	0f b6 0a             	movzbl (%rdx),%ecx
  80367f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803683:	48 98                	cltq   
  803685:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368d:	8b 40 04             	mov    0x4(%rax),%eax
  803690:	8d 50 01             	lea    0x1(%rax),%edx
  803693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803697:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80369a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80369f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036a7:	0f 82 64 ff ff ff    	jb     803611 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 20          	sub    $0x20,%rsp
  8036bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c7:	48 89 c7             	mov    %rax,%rdi
  8036ca:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
  8036d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036de:	48 be 50 43 80 00 00 	movabs $0x804350,%rsi
  8036e5:	00 00 00 
  8036e8:	48 89 c7             	mov    %rax,%rdi
  8036eb:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036fb:	8b 50 04             	mov    0x4(%rax),%edx
  8036fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803702:	8b 00                	mov    (%rax),%eax
  803704:	29 c2                	sub    %eax,%edx
  803706:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803710:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803714:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80371b:	00 00 00 
	stat->st_dev = &devpipe;
  80371e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803722:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803729:	00 00 00 
  80372c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 10          	sub    $0x10,%rsp
  803742:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374a:	48 89 c6             	mov    %rax,%rsi
  80374d:	bf 00 00 00 00       	mov    $0x0,%edi
  803752:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80375e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803762:	48 89 c7             	mov    %rax,%rdi
  803765:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
  803771:	48 89 c6             	mov    %rax,%rsi
  803774:	bf 00 00 00 00       	mov    $0x0,%edi
  803779:	48 b8 46 1b 80 00 00 	movabs $0x801b46,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
}
  803785:	c9                   	leaveq 
  803786:	c3                   	retq   

0000000000803787 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803787:	55                   	push   %rbp
  803788:	48 89 e5             	mov    %rsp,%rbp
  80378b:	48 83 ec 20          	sub    $0x20,%rsp
  80378f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803792:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803795:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803798:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80379c:	be 01 00 00 00       	mov    $0x1,%esi
  8037a1:	48 89 c7             	mov    %rax,%rdi
  8037a4:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
}
  8037b0:	c9                   	leaveq 
  8037b1:	c3                   	retq   

00000000008037b2 <getchar>:

int
getchar(void)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037ba:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037be:	ba 01 00 00 00       	mov    $0x1,%edx
  8037c3:	48 89 c6             	mov    %rax,%rsi
  8037c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037cb:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
  8037d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037de:	79 05                	jns    8037e5 <getchar+0x33>
		return r;
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e3:	eb 14                	jmp    8037f9 <getchar+0x47>
	if (r < 1)
  8037e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e9:	7f 07                	jg     8037f2 <getchar+0x40>
		return -E_EOF;
  8037eb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037f0:	eb 07                	jmp    8037f9 <getchar+0x47>
	return c;
  8037f2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037f6:	0f b6 c0             	movzbl %al,%eax
}
  8037f9:	c9                   	leaveq 
  8037fa:	c3                   	retq   

00000000008037fb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037fb:	55                   	push   %rbp
  8037fc:	48 89 e5             	mov    %rsp,%rbp
  8037ff:	48 83 ec 20          	sub    $0x20,%rsp
  803803:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803806:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80380a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380d:	48 89 d6             	mov    %rdx,%rsi
  803810:	89 c7                	mov    %eax,%edi
  803812:	48 b8 cf 1f 80 00 00 	movabs $0x801fcf,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
  80381e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803821:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803825:	79 05                	jns    80382c <iscons+0x31>
		return r;
  803827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382a:	eb 1a                	jmp    803846 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80382c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803830:	8b 10                	mov    (%rax),%edx
  803832:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803839:	00 00 00 
  80383c:	8b 00                	mov    (%rax),%eax
  80383e:	39 c2                	cmp    %eax,%edx
  803840:	0f 94 c0             	sete   %al
  803843:	0f b6 c0             	movzbl %al,%eax
}
  803846:	c9                   	leaveq 
  803847:	c3                   	retq   

0000000000803848 <opencons>:

int
opencons(void)
{
  803848:	55                   	push   %rbp
  803849:	48 89 e5             	mov    %rsp,%rbp
  80384c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803850:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803854:	48 89 c7             	mov    %rax,%rdi
  803857:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  80385e:	00 00 00 
  803861:	ff d0                	callq  *%rax
  803863:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803866:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386a:	79 05                	jns    803871 <opencons+0x29>
		return r;
  80386c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386f:	eb 5b                	jmp    8038cc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803875:	ba 07 04 00 00       	mov    $0x407,%edx
  80387a:	48 89 c6             	mov    %rax,%rsi
  80387d:	bf 00 00 00 00       	mov    $0x0,%edi
  803882:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
  80388e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803895:	79 05                	jns    80389c <opencons+0x54>
		return r;
  803897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389a:	eb 30                	jmp    8038cc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80389c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a0:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8038a7:	00 00 00 
  8038aa:	8b 12                	mov    (%rdx),%edx
  8038ac:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bd:	48 89 c7             	mov    %rax,%rdi
  8038c0:	48 b8 e9 1e 80 00 00 	movabs $0x801ee9,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
}
  8038cc:	c9                   	leaveq 
  8038cd:	c3                   	retq   

00000000008038ce <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ce:	55                   	push   %rbp
  8038cf:	48 89 e5             	mov    %rsp,%rbp
  8038d2:	48 83 ec 30          	sub    $0x30,%rsp
  8038d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038e2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038e7:	75 07                	jne    8038f0 <devcons_read+0x22>
		return 0;
  8038e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ee:	eb 4b                	jmp    80393b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038f0:	eb 0c                	jmp    8038fe <devcons_read+0x30>
		sys_yield();
  8038f2:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  8038f9:	00 00 00 
  8038fc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038fe:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80390d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803911:	74 df                	je     8038f2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803917:	79 05                	jns    80391e <devcons_read+0x50>
		return c;
  803919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391c:	eb 1d                	jmp    80393b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80391e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803922:	75 07                	jne    80392b <devcons_read+0x5d>
		return 0;
  803924:	b8 00 00 00 00       	mov    $0x0,%eax
  803929:	eb 10                	jmp    80393b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80392b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392e:	89 c2                	mov    %eax,%edx
  803930:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803934:	88 10                	mov    %dl,(%rax)
	return 1;
  803936:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803948:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80394f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803956:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80395d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803964:	eb 76                	jmp    8039dc <devcons_write+0x9f>
		m = n - tot;
  803966:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80396d:	89 c2                	mov    %eax,%edx
  80396f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803972:	29 c2                	sub    %eax,%edx
  803974:	89 d0                	mov    %edx,%eax
  803976:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803979:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80397c:	83 f8 7f             	cmp    $0x7f,%eax
  80397f:	76 07                	jbe    803988 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803981:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803988:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80398b:	48 63 d0             	movslq %eax,%rdx
  80398e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803991:	48 63 c8             	movslq %eax,%rcx
  803994:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80399b:	48 01 c1             	add    %rax,%rcx
  80399e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039a5:	48 89 ce             	mov    %rcx,%rsi
  8039a8:	48 89 c7             	mov    %rax,%rdi
  8039ab:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  8039b2:	00 00 00 
  8039b5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ba:	48 63 d0             	movslq %eax,%rdx
  8039bd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039c4:	48 89 d6             	mov    %rdx,%rsi
  8039c7:	48 89 c7             	mov    %rax,%rdi
  8039ca:	48 b8 53 19 80 00 00 	movabs $0x801953,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039d9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039df:	48 98                	cltq   
  8039e1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039e8:	0f 82 78 ff ff ff    	jb     803966 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 83 ec 08          	sub    $0x8,%rsp
  8039fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a04:	c9                   	leaveq 
  803a05:	c3                   	retq   

0000000000803a06 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a06:	55                   	push   %rbp
  803a07:	48 89 e5             	mov    %rsp,%rbp
  803a0a:	48 83 ec 10          	sub    $0x10,%rsp
  803a0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1a:	48 be 5c 43 80 00 00 	movabs $0x80435c,%rsi
  803a21:	00 00 00 
  803a24:	48 89 c7             	mov    %rax,%rdi
  803a27:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  803a2e:	00 00 00 
  803a31:	ff d0                	callq  *%rax
	return 0;
  803a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a38:	c9                   	leaveq 
  803a39:	c3                   	retq   

0000000000803a3a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a3a:	55                   	push   %rbp
  803a3b:	48 89 e5             	mov    %rsp,%rbp
  803a3e:	48 83 ec 30          	sub    $0x30,%rsp
  803a42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803a4e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a55:	00 00 00 
  803a58:	48 8b 00             	mov    (%rax),%rax
  803a5b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a61:	85 c0                	test   %eax,%eax
  803a63:	75 34                	jne    803a99 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a65:	48 b8 1f 1a 80 00 00 	movabs $0x801a1f,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
  803a71:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a76:	48 98                	cltq   
  803a78:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803a7f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a86:	00 00 00 
  803a89:	48 01 c2             	add    %rax,%rdx
  803a8c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a93:	00 00 00 
  803a96:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a99:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a9e:	75 0e                	jne    803aae <ipc_recv+0x74>
		pg = (void*) UTOP;
  803aa0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803aa7:	00 00 00 
  803aaa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803aae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab2:	48 89 c7             	mov    %rax,%rdi
  803ab5:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803abc:	00 00 00 
  803abf:	ff d0                	callq  *%rax
  803ac1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803ac4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac8:	79 19                	jns    803ae3 <ipc_recv+0xa9>
		*from_env_store = 0;
  803aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ace:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae1:	eb 53                	jmp    803b36 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803ae3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ae8:	74 19                	je     803b03 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803aea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803af1:	00 00 00 
  803af4:	48 8b 00             	mov    (%rax),%rax
  803af7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b01:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803b03:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b08:	74 19                	je     803b23 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803b0a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b11:	00 00 00 
  803b14:	48 8b 00             	mov    (%rax),%rax
  803b17:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b21:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803b23:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b2a:	00 00 00 
  803b2d:	48 8b 00             	mov    (%rax),%rax
  803b30:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803b36:	c9                   	leaveq 
  803b37:	c3                   	retq   

0000000000803b38 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b38:	55                   	push   %rbp
  803b39:	48 89 e5             	mov    %rsp,%rbp
  803b3c:	48 83 ec 30          	sub    $0x30,%rsp
  803b40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b43:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b46:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b4a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803b4d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b52:	75 0e                	jne    803b62 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803b54:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b5b:	00 00 00 
  803b5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b62:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b65:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b68:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b6f:	89 c7                	mov    %eax,%edi
  803b71:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  803b78:	00 00 00 
  803b7b:	ff d0                	callq  *%rax
  803b7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803b80:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b84:	75 0c                	jne    803b92 <ipc_send+0x5a>
			sys_yield();
  803b86:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b92:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b96:	74 ca                	je     803b62 <ipc_send+0x2a>
	if(result != 0)
  803b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9c:	74 20                	je     803bbe <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba1:	89 c6                	mov    %eax,%esi
  803ba3:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  803baa:	00 00 00 
  803bad:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb2:	48 ba b7 05 80 00 00 	movabs $0x8005b7,%rdx
  803bb9:	00 00 00 
  803bbc:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803bbe:	c9                   	leaveq 
  803bbf:	c3                   	retq   

0000000000803bc0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bc0:	55                   	push   %rbp
  803bc1:	48 89 e5             	mov    %rsp,%rbp
  803bc4:	48 83 ec 14          	sub    $0x14,%rsp
  803bc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bd2:	eb 4e                	jmp    803c22 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803bd4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803bdb:	00 00 00 
  803bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be1:	48 98                	cltq   
  803be3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803bea:	48 01 d0             	add    %rdx,%rax
  803bed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803bf3:	8b 00                	mov    (%rax),%eax
  803bf5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bf8:	75 24                	jne    803c1e <ipc_find_env+0x5e>
			return envs[i].env_id;
  803bfa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c01:	00 00 00 
  803c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c07:	48 98                	cltq   
  803c09:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803c10:	48 01 d0             	add    %rdx,%rax
  803c13:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c19:	8b 40 08             	mov    0x8(%rax),%eax
  803c1c:	eb 12                	jmp    803c30 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803c1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c22:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c29:	7e a9                	jle    803bd4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803c2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c30:	c9                   	leaveq 
  803c31:	c3                   	retq   

0000000000803c32 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c32:	55                   	push   %rbp
  803c33:	48 89 e5             	mov    %rsp,%rbp
  803c36:	48 83 ec 18          	sub    $0x18,%rsp
  803c3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c42:	48 c1 e8 15          	shr    $0x15,%rax
  803c46:	48 89 c2             	mov    %rax,%rdx
  803c49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c50:	01 00 00 
  803c53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c57:	83 e0 01             	and    $0x1,%eax
  803c5a:	48 85 c0             	test   %rax,%rax
  803c5d:	75 07                	jne    803c66 <pageref+0x34>
		return 0;
  803c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c64:	eb 53                	jmp    803cb9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6a:	48 c1 e8 0c          	shr    $0xc,%rax
  803c6e:	48 89 c2             	mov    %rax,%rdx
  803c71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c78:	01 00 00 
  803c7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c87:	83 e0 01             	and    $0x1,%eax
  803c8a:	48 85 c0             	test   %rax,%rax
  803c8d:	75 07                	jne    803c96 <pageref+0x64>
		return 0;
  803c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c94:	eb 23                	jmp    803cb9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c9a:	48 c1 e8 0c          	shr    $0xc,%rax
  803c9e:	48 89 c2             	mov    %rax,%rdx
  803ca1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ca8:	00 00 00 
  803cab:	48 c1 e2 04          	shl    $0x4,%rdx
  803caf:	48 01 d0             	add    %rdx,%rax
  803cb2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cb6:	0f b7 c0             	movzwl %ax,%eax
}
  803cb9:	c9                   	leaveq 
  803cba:	c3                   	retq   
