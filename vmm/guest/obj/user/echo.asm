
vmm/guest/obj/user/echo:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be 80 3a 80 00 00 	movabs $0x803a80,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 c6 03 80 00 00 	movabs $0x8003c6,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be 83 3a 80 00 00 	movabs $0x803a83,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 45 15 80 00 00 	movabs $0x801545,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 45 15 80 00 00 	movabs $0x801545,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be 85 3a 80 00 00 	movabs $0x803a85,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 45 15 80 00 00 	movabs $0x801545,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800161:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800172:	48 98                	cltq   
  800174:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80017b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800182:	00 00 00 
  800185:	48 01 c2             	add    %rax,%rdx
  800188:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80018f:	00 00 00 
  800192:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800195:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800199:	7e 14                	jle    8001af <libmain+0x5d>
		binaryname = argv[0];
  80019b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019f:	48 8b 10             	mov    (%rax),%rdx
  8001a2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001a9:	00 00 00 
  8001ac:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b6:	48 89 d6             	mov    %rdx,%rsi
  8001b9:	89 c7                	mov    %eax,%edi
  8001bb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c2:	00 00 00 
  8001c5:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001c7:	48 b8 d5 01 80 00 00 	movabs $0x8001d5,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
}
  8001d3:	c9                   	leaveq 
  8001d4:	c3                   	retq   

00000000008001d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001d9:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ea:	48 b8 d3 0a 80 00 00 	movabs $0x800ad3,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	callq  *%rax

}
  8001f6:	5d                   	pop    %rbp
  8001f7:	c3                   	retq   

00000000008001f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8001f8:	55                   	push   %rbp
  8001f9:	48 89 e5             	mov    %rsp,%rbp
  8001fc:	48 83 ec 18          	sub    $0x18,%rsp
  800200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80020b:	eb 09                	jmp    800216 <strlen+0x1e>
		n++;
  80020d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800211:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80021a:	0f b6 00             	movzbl (%rax),%eax
  80021d:	84 c0                	test   %al,%al
  80021f:	75 ec                	jne    80020d <strlen+0x15>
		n++;
	return n;
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 20          	sub    $0x20,%rsp
  80022e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800232:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80023d:	eb 0e                	jmp    80024d <strnlen+0x27>
		n++;
  80023f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800243:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800248:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80024d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800252:	74 0b                	je     80025f <strnlen+0x39>
  800254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800258:	0f b6 00             	movzbl (%rax),%eax
  80025b:	84 c0                	test   %al,%al
  80025d:	75 e0                	jne    80023f <strnlen+0x19>
		n++;
	return n;
  80025f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800262:	c9                   	leaveq 
  800263:	c3                   	retq   

0000000000800264 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	48 83 ec 20          	sub    $0x20,%rsp
  80026c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800270:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800278:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80027c:	90                   	nop
  80027d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800281:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800285:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800289:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80028d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800291:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800295:	0f b6 12             	movzbl (%rdx),%edx
  800298:	88 10                	mov    %dl,(%rax)
  80029a:	0f b6 00             	movzbl (%rax),%eax
  80029d:	84 c0                	test   %al,%al
  80029f:	75 dc                	jne    80027d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 20          	sub    $0x20,%rsp
  8002af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002bb:	48 89 c7             	mov    %rax,%rdi
  8002be:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
  8002ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d0:	48 63 d0             	movslq %eax,%rdx
  8002d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002d7:	48 01 c2             	add    %rax,%rdx
  8002da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002de:	48 89 c6             	mov    %rax,%rsi
  8002e1:	48 89 d7             	mov    %rdx,%rdi
  8002e4:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
	return dst;
  8002f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002f4:	c9                   	leaveq 
  8002f5:	c3                   	retq   

00000000008002f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002f6:	55                   	push   %rbp
  8002f7:	48 89 e5             	mov    %rsp,%rbp
  8002fa:	48 83 ec 28          	sub    $0x28,%rsp
  8002fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800302:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800306:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80030a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80030e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800312:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800319:	00 
  80031a:	eb 2a                	jmp    800346 <strncpy+0x50>
		*dst++ = *src;
  80031c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800320:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800324:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800328:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80032c:	0f b6 12             	movzbl (%rdx),%edx
  80032f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800335:	0f b6 00             	movzbl (%rax),%eax
  800338:	84 c0                	test   %al,%al
  80033a:	74 05                	je     800341 <strncpy+0x4b>
			src++;
  80033c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80034a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80034e:	72 cc                	jb     80031c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800350:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800354:	c9                   	leaveq 
  800355:	c3                   	retq   

0000000000800356 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	48 83 ec 28          	sub    $0x28,%rsp
  80035e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800362:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800366:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80036a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80036e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800372:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800377:	74 3d                	je     8003b6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800379:	eb 1d                	jmp    800398 <strlcpy+0x42>
			*dst++ = *src++;
  80037b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800383:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800387:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80038b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80038f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800393:	0f b6 12             	movzbl (%rdx),%edx
  800396:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800398:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80039d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003a2:	74 0b                	je     8003af <strlcpy+0x59>
  8003a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003a8:	0f b6 00             	movzbl (%rax),%eax
  8003ab:	84 c0                	test   %al,%al
  8003ad:	75 cc                	jne    80037b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003be:	48 29 c2             	sub    %rax,%rdx
  8003c1:	48 89 d0             	mov    %rdx,%rax
}
  8003c4:	c9                   	leaveq 
  8003c5:	c3                   	retq   

00000000008003c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003c6:	55                   	push   %rbp
  8003c7:	48 89 e5             	mov    %rsp,%rbp
  8003ca:	48 83 ec 10          	sub    $0x10,%rsp
  8003ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003d6:	eb 0a                	jmp    8003e2 <strcmp+0x1c>
		p++, q++;
  8003d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e6:	0f b6 00             	movzbl (%rax),%eax
  8003e9:	84 c0                	test   %al,%al
  8003eb:	74 12                	je     8003ff <strcmp+0x39>
  8003ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f1:	0f b6 10             	movzbl (%rax),%edx
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	0f b6 00             	movzbl (%rax),%eax
  8003fb:	38 c2                	cmp    %al,%dl
  8003fd:	74 d9                	je     8003d8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8003ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800403:	0f b6 00             	movzbl (%rax),%eax
  800406:	0f b6 d0             	movzbl %al,%edx
  800409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040d:	0f b6 00             	movzbl (%rax),%eax
  800410:	0f b6 c0             	movzbl %al,%eax
  800413:	29 c2                	sub    %eax,%edx
  800415:	89 d0                	mov    %edx,%eax
}
  800417:	c9                   	leaveq 
  800418:	c3                   	retq   

0000000000800419 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800419:	55                   	push   %rbp
  80041a:	48 89 e5             	mov    %rsp,%rbp
  80041d:	48 83 ec 18          	sub    $0x18,%rsp
  800421:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800425:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800429:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80042d:	eb 0f                	jmp    80043e <strncmp+0x25>
		n--, p++, q++;
  80042f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800434:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800439:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80043e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800443:	74 1d                	je     800462 <strncmp+0x49>
  800445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800449:	0f b6 00             	movzbl (%rax),%eax
  80044c:	84 c0                	test   %al,%al
  80044e:	74 12                	je     800462 <strncmp+0x49>
  800450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800454:	0f b6 10             	movzbl (%rax),%edx
  800457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045b:	0f b6 00             	movzbl (%rax),%eax
  80045e:	38 c2                	cmp    %al,%dl
  800460:	74 cd                	je     80042f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800462:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800467:	75 07                	jne    800470 <strncmp+0x57>
		return 0;
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
  80046e:	eb 18                	jmp    800488 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800474:	0f b6 00             	movzbl (%rax),%eax
  800477:	0f b6 d0             	movzbl %al,%edx
  80047a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047e:	0f b6 00             	movzbl (%rax),%eax
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	29 c2                	sub    %eax,%edx
  800486:	89 d0                	mov    %edx,%eax
}
  800488:	c9                   	leaveq 
  800489:	c3                   	retq   

000000000080048a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 0c          	sub    $0xc,%rsp
  800492:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800496:	89 f0                	mov    %esi,%eax
  800498:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80049b:	eb 17                	jmp    8004b4 <strchr+0x2a>
		if (*s == c)
  80049d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a1:	0f b6 00             	movzbl (%rax),%eax
  8004a4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004a7:	75 06                	jne    8004af <strchr+0x25>
			return (char *) s;
  8004a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ad:	eb 15                	jmp    8004c4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b8:	0f b6 00             	movzbl (%rax),%eax
  8004bb:	84 c0                	test   %al,%al
  8004bd:	75 de                	jne    80049d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c4:	c9                   	leaveq 
  8004c5:	c3                   	retq   

00000000008004c6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004c6:	55                   	push   %rbp
  8004c7:	48 89 e5             	mov    %rsp,%rbp
  8004ca:	48 83 ec 0c          	sub    $0xc,%rsp
  8004ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d2:	89 f0                	mov    %esi,%eax
  8004d4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004d7:	eb 13                	jmp    8004ec <strfind+0x26>
		if (*s == c)
  8004d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004dd:	0f b6 00             	movzbl (%rax),%eax
  8004e0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004e3:	75 02                	jne    8004e7 <strfind+0x21>
			break;
  8004e5:	eb 10                	jmp    8004f7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f0:	0f b6 00             	movzbl (%rax),%eax
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 e2                	jne    8004d9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004fb:	c9                   	leaveq 
  8004fc:	c3                   	retq   

00000000008004fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004fd:	55                   	push   %rbp
  8004fe:	48 89 e5             	mov    %rsp,%rbp
  800501:	48 83 ec 18          	sub    $0x18,%rsp
  800505:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800509:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80050c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800510:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800515:	75 06                	jne    80051d <memset+0x20>
		return v;
  800517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051b:	eb 69                	jmp    800586 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80051d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800521:	83 e0 03             	and    $0x3,%eax
  800524:	48 85 c0             	test   %rax,%rax
  800527:	75 48                	jne    800571 <memset+0x74>
  800529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052d:	83 e0 03             	and    $0x3,%eax
  800530:	48 85 c0             	test   %rax,%rax
  800533:	75 3c                	jne    800571 <memset+0x74>
		c &= 0xFF;
  800535:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80053c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80053f:	c1 e0 18             	shl    $0x18,%eax
  800542:	89 c2                	mov    %eax,%edx
  800544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800547:	c1 e0 10             	shl    $0x10,%eax
  80054a:	09 c2                	or     %eax,%edx
  80054c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054f:	c1 e0 08             	shl    $0x8,%eax
  800552:	09 d0                	or     %edx,%eax
  800554:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	48 c1 e8 02          	shr    $0x2,%rax
  80055f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800562:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800566:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800569:	48 89 d7             	mov    %rdx,%rdi
  80056c:	fc                   	cld    
  80056d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80056f:	eb 11                	jmp    800582 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800571:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800575:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800578:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80057c:	48 89 d7             	mov    %rdx,%rdi
  80057f:	fc                   	cld    
  800580:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800586:	c9                   	leaveq 
  800587:	c3                   	retq   

0000000000800588 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp
  80058c:	48 83 ec 28          	sub    $0x28,%rsp
  800590:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800594:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800598:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80059c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005b4:	0f 83 88 00 00 00    	jae    800642 <memmove+0xba>
  8005ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005c2:	48 01 d0             	add    %rdx,%rax
  8005c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c9:	76 77                	jbe    800642 <memmove+0xba>
		s += n;
  8005cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005df:	83 e0 03             	and    $0x3,%eax
  8005e2:	48 85 c0             	test   %rax,%rax
  8005e5:	75 3b                	jne    800622 <memmove+0x9a>
  8005e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005eb:	83 e0 03             	and    $0x3,%eax
  8005ee:	48 85 c0             	test   %rax,%rax
  8005f1:	75 2f                	jne    800622 <memmove+0x9a>
  8005f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f7:	83 e0 03             	and    $0x3,%eax
  8005fa:	48 85 c0             	test   %rax,%rax
  8005fd:	75 23                	jne    800622 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8005ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800603:	48 83 e8 04          	sub    $0x4,%rax
  800607:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80060b:	48 83 ea 04          	sub    $0x4,%rdx
  80060f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800613:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800617:	48 89 c7             	mov    %rax,%rdi
  80061a:	48 89 d6             	mov    %rdx,%rsi
  80061d:	fd                   	std    
  80061e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800620:	eb 1d                	jmp    80063f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800626:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80062a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800636:	48 89 d7             	mov    %rdx,%rdi
  800639:	48 89 c1             	mov    %rax,%rcx
  80063c:	fd                   	std    
  80063d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80063f:	fc                   	cld    
  800640:	eb 57                	jmp    800699 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800646:	83 e0 03             	and    $0x3,%eax
  800649:	48 85 c0             	test   %rax,%rax
  80064c:	75 36                	jne    800684 <memmove+0xfc>
  80064e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800652:	83 e0 03             	and    $0x3,%eax
  800655:	48 85 c0             	test   %rax,%rax
  800658:	75 2a                	jne    800684 <memmove+0xfc>
  80065a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80065e:	83 e0 03             	and    $0x3,%eax
  800661:	48 85 c0             	test   %rax,%rax
  800664:	75 1e                	jne    800684 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066a:	48 c1 e8 02          	shr    $0x2,%rax
  80066e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800675:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800679:	48 89 c7             	mov    %rax,%rdi
  80067c:	48 89 d6             	mov    %rdx,%rsi
  80067f:	fc                   	cld    
  800680:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800682:	eb 15                	jmp    800699 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800688:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80068c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800690:	48 89 c7             	mov    %rax,%rdi
  800693:	48 89 d6             	mov    %rdx,%rsi
  800696:	fc                   	cld    
  800697:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80069d:	c9                   	leaveq 
  80069e:	c3                   	retq   

000000000080069f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80069f:	55                   	push   %rbp
  8006a0:	48 89 e5             	mov    %rsp,%rbp
  8006a3:	48 83 ec 18          	sub    $0x18,%rsp
  8006a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006bf:	48 89 ce             	mov    %rcx,%rsi
  8006c2:	48 89 c7             	mov    %rax,%rdi
  8006c5:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8006cc:	00 00 00 
  8006cf:	ff d0                	callq  *%rax
}
  8006d1:	c9                   	leaveq 
  8006d2:	c3                   	retq   

00000000008006d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006d3:	55                   	push   %rbp
  8006d4:	48 89 e5             	mov    %rsp,%rbp
  8006d7:	48 83 ec 28          	sub    $0x28,%rsp
  8006db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006f7:	eb 36                	jmp    80072f <memcmp+0x5c>
		if (*s1 != *s2)
  8006f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006fd:	0f b6 10             	movzbl (%rax),%edx
  800700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800704:	0f b6 00             	movzbl (%rax),%eax
  800707:	38 c2                	cmp    %al,%dl
  800709:	74 1a                	je     800725 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80070b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f b6 d0             	movzbl %al,%edx
  800715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800719:	0f b6 00             	movzbl (%rax),%eax
  80071c:	0f b6 c0             	movzbl %al,%eax
  80071f:	29 c2                	sub    %eax,%edx
  800721:	89 d0                	mov    %edx,%eax
  800723:	eb 20                	jmp    800745 <memcmp+0x72>
		s1++, s2++;
  800725:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80072a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80072f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800733:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800737:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80073b:	48 85 c0             	test   %rax,%rax
  80073e:	75 b9                	jne    8006f9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800745:	c9                   	leaveq 
  800746:	c3                   	retq   

0000000000800747 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800747:	55                   	push   %rbp
  800748:	48 89 e5             	mov    %rsp,%rbp
  80074b:	48 83 ec 28          	sub    $0x28,%rsp
  80074f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800753:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80075a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	48 01 d0             	add    %rdx,%rax
  800765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800769:	eb 15                	jmp    800780 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	0f b6 10             	movzbl (%rax),%edx
  800772:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800775:	38 c2                	cmp    %al,%dl
  800777:	75 02                	jne    80077b <memfind+0x34>
			break;
  800779:	eb 0f                	jmp    80078a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80077b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800788:	72 e1                	jb     80076b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80078e:	c9                   	leaveq 
  80078f:	c3                   	retq   

0000000000800790 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800790:	55                   	push   %rbp
  800791:	48 89 e5             	mov    %rsp,%rbp
  800794:	48 83 ec 34          	sub    $0x34,%rsp
  800798:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80079c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007a0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007aa:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007b1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007b2:	eb 05                	jmp    8007b9 <strtol+0x29>
		s++;
  8007b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bd:	0f b6 00             	movzbl (%rax),%eax
  8007c0:	3c 20                	cmp    $0x20,%al
  8007c2:	74 f0                	je     8007b4 <strtol+0x24>
  8007c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c8:	0f b6 00             	movzbl (%rax),%eax
  8007cb:	3c 09                	cmp    $0x9,%al
  8007cd:	74 e5                	je     8007b4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d3:	0f b6 00             	movzbl (%rax),%eax
  8007d6:	3c 2b                	cmp    $0x2b,%al
  8007d8:	75 07                	jne    8007e1 <strtol+0x51>
		s++;
  8007da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007df:	eb 17                	jmp    8007f8 <strtol+0x68>
	else if (*s == '-')
  8007e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e5:	0f b6 00             	movzbl (%rax),%eax
  8007e8:	3c 2d                	cmp    $0x2d,%al
  8007ea:	75 0c                	jne    8007f8 <strtol+0x68>
		s++, neg = 1;
  8007ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8007f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8007fc:	74 06                	je     800804 <strtol+0x74>
  8007fe:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  800802:	75 28                	jne    80082c <strtol+0x9c>
  800804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800808:	0f b6 00             	movzbl (%rax),%eax
  80080b:	3c 30                	cmp    $0x30,%al
  80080d:	75 1d                	jne    80082c <strtol+0x9c>
  80080f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800813:	48 83 c0 01          	add    $0x1,%rax
  800817:	0f b6 00             	movzbl (%rax),%eax
  80081a:	3c 78                	cmp    $0x78,%al
  80081c:	75 0e                	jne    80082c <strtol+0x9c>
		s += 2, base = 16;
  80081e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800823:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80082a:	eb 2c                	jmp    800858 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80082c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800830:	75 19                	jne    80084b <strtol+0xbb>
  800832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800836:	0f b6 00             	movzbl (%rax),%eax
  800839:	3c 30                	cmp    $0x30,%al
  80083b:	75 0e                	jne    80084b <strtol+0xbb>
		s++, base = 8;
  80083d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800842:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800849:	eb 0d                	jmp    800858 <strtol+0xc8>
	else if (base == 0)
  80084b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80084f:	75 07                	jne    800858 <strtol+0xc8>
		base = 10;
  800851:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085c:	0f b6 00             	movzbl (%rax),%eax
  80085f:	3c 2f                	cmp    $0x2f,%al
  800861:	7e 1d                	jle    800880 <strtol+0xf0>
  800863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800867:	0f b6 00             	movzbl (%rax),%eax
  80086a:	3c 39                	cmp    $0x39,%al
  80086c:	7f 12                	jg     800880 <strtol+0xf0>
			dig = *s - '0';
  80086e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800872:	0f b6 00             	movzbl (%rax),%eax
  800875:	0f be c0             	movsbl %al,%eax
  800878:	83 e8 30             	sub    $0x30,%eax
  80087b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80087e:	eb 4e                	jmp    8008ce <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800884:	0f b6 00             	movzbl (%rax),%eax
  800887:	3c 60                	cmp    $0x60,%al
  800889:	7e 1d                	jle    8008a8 <strtol+0x118>
  80088b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088f:	0f b6 00             	movzbl (%rax),%eax
  800892:	3c 7a                	cmp    $0x7a,%al
  800894:	7f 12                	jg     8008a8 <strtol+0x118>
			dig = *s - 'a' + 10;
  800896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089a:	0f b6 00             	movzbl (%rax),%eax
  80089d:	0f be c0             	movsbl %al,%eax
  8008a0:	83 e8 57             	sub    $0x57,%eax
  8008a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008a6:	eb 26                	jmp    8008ce <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ac:	0f b6 00             	movzbl (%rax),%eax
  8008af:	3c 40                	cmp    $0x40,%al
  8008b1:	7e 48                	jle    8008fb <strtol+0x16b>
  8008b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b7:	0f b6 00             	movzbl (%rax),%eax
  8008ba:	3c 5a                	cmp    $0x5a,%al
  8008bc:	7f 3d                	jg     8008fb <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f be c0             	movsbl %al,%eax
  8008c8:	83 e8 37             	sub    $0x37,%eax
  8008cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008d1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008d4:	7c 02                	jl     8008d8 <strtol+0x148>
			break;
  8008d6:	eb 23                	jmp    8008fb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008dd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e0:	48 98                	cltq   
  8008e2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008e7:	48 89 c2             	mov    %rax,%rdx
  8008ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008ed:	48 98                	cltq   
  8008ef:	48 01 d0             	add    %rdx,%rax
  8008f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008f6:	e9 5d ff ff ff       	jmpq   800858 <strtol+0xc8>

	if (endptr)
  8008fb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800900:	74 0b                	je     80090d <strtol+0x17d>
		*endptr = (char *) s;
  800902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800906:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80090a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80090d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800911:	74 09                	je     80091c <strtol+0x18c>
  800913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800917:	48 f7 d8             	neg    %rax
  80091a:	eb 04                	jmp    800920 <strtol+0x190>
  80091c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800920:	c9                   	leaveq 
  800921:	c3                   	retq   

0000000000800922 <strstr>:

char * strstr(const char *in, const char *str)
{
  800922:	55                   	push   %rbp
  800923:	48 89 e5             	mov    %rsp,%rbp
  800926:	48 83 ec 30          	sub    $0x30,%rsp
  80092a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80092e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  800932:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800936:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80093a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80093e:	0f b6 00             	movzbl (%rax),%eax
  800941:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800944:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800948:	75 06                	jne    800950 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80094a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80094e:	eb 6b                	jmp    8009bb <strstr+0x99>

	len = strlen(str);
  800950:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800954:	48 89 c7             	mov    %rax,%rdi
  800957:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  80095e:	00 00 00 
  800961:	ff d0                	callq  *%rax
  800963:	48 98                	cltq   
  800965:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80096d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800971:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800975:	0f b6 00             	movzbl (%rax),%eax
  800978:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80097b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80097f:	75 07                	jne    800988 <strstr+0x66>
				return (char *) 0;
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb 33                	jmp    8009bb <strstr+0x99>
		} while (sc != c);
  800988:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80098c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80098f:	75 d8                	jne    800969 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  800991:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800995:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80099d:	48 89 ce             	mov    %rcx,%rsi
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	48 b8 19 04 80 00 00 	movabs $0x800419,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	75 b6                	jne    800969 <strstr+0x47>

	return (char *) (in - 1);
  8009b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009b7:	48 83 e8 01          	sub    $0x1,%rax
}
  8009bb:	c9                   	leaveq 
  8009bc:	c3                   	retq   

00000000008009bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009bd:	55                   	push   %rbp
  8009be:	48 89 e5             	mov    %rsp,%rbp
  8009c1:	53                   	push   %rbx
  8009c2:	48 83 ec 48          	sub    $0x48,%rsp
  8009c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009cc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009d0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009d4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009d8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009df:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009e3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009e7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009eb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009ef:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009f3:	4c 89 c3             	mov    %r8,%rbx
  8009f6:	cd 30                	int    $0x30
  8009f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8009fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a00:	74 3e                	je     800a40 <syscall+0x83>
  800a02:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a07:	7e 37                	jle    800a40 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a10:	49 89 d0             	mov    %rdx,%r8
  800a13:	89 c1                	mov    %eax,%ecx
  800a15:	48 ba 91 3a 80 00 00 	movabs $0x803a91,%rdx
  800a1c:	00 00 00 
  800a1f:	be 23 00 00 00       	mov    $0x23,%esi
  800a24:	48 bf ae 3a 80 00 00 	movabs $0x803aae,%rdi
  800a2b:	00 00 00 
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	49 b9 30 27 80 00 00 	movabs $0x802730,%r9
  800a3a:	00 00 00 
  800a3d:	41 ff d1             	callq  *%r9

	return ret;
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a44:	48 83 c4 48          	add    $0x48,%rsp
  800a48:	5b                   	pop    %rbx
  800a49:	5d                   	pop    %rbp
  800a4a:	c3                   	retq   

0000000000800a4b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a4b:	55                   	push   %rbp
  800a4c:	48 89 e5             	mov    %rsp,%rbp
  800a4f:	48 83 ec 20          	sub    $0x20,%rsp
  800a53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a6a:	00 
  800a6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a77:	48 89 d1             	mov    %rdx,%rcx
  800a7a:	48 89 c2             	mov    %rax,%rdx
  800a7d:	be 00 00 00 00       	mov    $0x0,%esi
  800a82:	bf 00 00 00 00       	mov    $0x0,%edi
  800a87:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
}
  800a93:	c9                   	leaveq 
  800a94:	c3                   	retq   

0000000000800a95 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a95:	55                   	push   %rbp
  800a96:	48 89 e5             	mov    %rsp,%rbp
  800a99:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aa4:	00 
  800aa5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800aab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ab1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  800abb:	be 00 00 00 00       	mov    $0x0,%esi
  800ac0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
}
  800ad1:	c9                   	leaveq 
  800ad2:	c3                   	retq   

0000000000800ad3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ad3:	55                   	push   %rbp
  800ad4:	48 89 e5             	mov    %rsp,%rbp
  800ad7:	48 83 ec 10          	sub    $0x10,%rsp
  800adb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae1:	48 98                	cltq   
  800ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aea:	00 
  800aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afc:	48 89 c2             	mov    %rax,%rdx
  800aff:	be 01 00 00 00       	mov    $0x1,%esi
  800b04:	bf 03 00 00 00       	mov    $0x3,%edi
  800b09:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b10:	00 00 00 
  800b13:	ff d0                	callq  *%rax
}
  800b15:	c9                   	leaveq 
  800b16:	c3                   	retq   

0000000000800b17 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b17:	55                   	push   %rbp
  800b18:	48 89 e5             	mov    %rsp,%rbp
  800b1b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b26:	00 
  800b27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	be 00 00 00 00       	mov    $0x0,%esi
  800b42:	bf 02 00 00 00       	mov    $0x2,%edi
  800b47:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
}
  800b53:	c9                   	leaveq 
  800b54:	c3                   	retq   

0000000000800b55 <sys_yield>:

void
sys_yield(void)
{
  800b55:	55                   	push   %rbp
  800b56:	48 89 e5             	mov    %rsp,%rbp
  800b59:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b64:	00 
  800b65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	be 00 00 00 00       	mov    $0x0,%esi
  800b80:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b85:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
}
  800b91:	c9                   	leaveq 
  800b92:	c3                   	retq   

0000000000800b93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b93:	55                   	push   %rbp
  800b94:	48 89 e5             	mov    %rsp,%rbp
  800b97:	48 83 ec 20          	sub    $0x20,%rsp
  800b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ba2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800ba5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba8:	48 63 c8             	movslq %eax,%rcx
  800bab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bb2:	48 98                	cltq   
  800bb4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bbb:	00 
  800bbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bc2:	49 89 c8             	mov    %rcx,%r8
  800bc5:	48 89 d1             	mov    %rdx,%rcx
  800bc8:	48 89 c2             	mov    %rax,%rdx
  800bcb:	be 01 00 00 00       	mov    $0x1,%esi
  800bd0:	bf 04 00 00 00       	mov    $0x4,%edi
  800bd5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800bdc:	00 00 00 
  800bdf:	ff d0                	callq  *%rax
}
  800be1:	c9                   	leaveq 
  800be2:	c3                   	retq   

0000000000800be3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be3:	55                   	push   %rbp
  800be4:	48 89 e5             	mov    %rsp,%rbp
  800be7:	48 83 ec 30          	sub    $0x30,%rsp
  800beb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bf2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bf5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bf9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800bfd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c00:	48 63 c8             	movslq %eax,%rcx
  800c03:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c0a:	48 63 f0             	movslq %eax,%rsi
  800c0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c14:	48 98                	cltq   
  800c16:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c1a:	49 89 f9             	mov    %rdi,%r9
  800c1d:	49 89 f0             	mov    %rsi,%r8
  800c20:	48 89 d1             	mov    %rdx,%rcx
  800c23:	48 89 c2             	mov    %rax,%rdx
  800c26:	be 01 00 00 00       	mov    $0x1,%esi
  800c2b:	bf 05 00 00 00       	mov    $0x5,%edi
  800c30:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800c37:	00 00 00 
  800c3a:	ff d0                	callq  *%rax
}
  800c3c:	c9                   	leaveq 
  800c3d:	c3                   	retq   

0000000000800c3e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3e:	55                   	push   %rbp
  800c3f:	48 89 e5             	mov    %rsp,%rbp
  800c42:	48 83 ec 20          	sub    $0x20,%rsp
  800c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c54:	48 98                	cltq   
  800c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c5d:	00 
  800c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c6a:	48 89 d1             	mov    %rdx,%rcx
  800c6d:	48 89 c2             	mov    %rax,%rdx
  800c70:	be 01 00 00 00       	mov    $0x1,%esi
  800c75:	bf 06 00 00 00       	mov    $0x6,%edi
  800c7a:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
}
  800c86:	c9                   	leaveq 
  800c87:	c3                   	retq   

0000000000800c88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c88:	55                   	push   %rbp
  800c89:	48 89 e5             	mov    %rsp,%rbp
  800c8c:	48 83 ec 10          	sub    $0x10,%rsp
  800c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c93:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c99:	48 63 d0             	movslq %eax,%rdx
  800c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c9f:	48 98                	cltq   
  800ca1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ca8:	00 
  800ca9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800caf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cb5:	48 89 d1             	mov    %rdx,%rcx
  800cb8:	48 89 c2             	mov    %rax,%rdx
  800cbb:	be 01 00 00 00       	mov    $0x1,%esi
  800cc0:	bf 08 00 00 00       	mov    $0x8,%edi
  800cc5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
}
  800cd1:	c9                   	leaveq 
  800cd2:	c3                   	retq   

0000000000800cd3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cd3:	55                   	push   %rbp
  800cd4:	48 89 e5             	mov    %rsp,%rbp
  800cd7:	48 83 ec 20          	sub    $0x20,%rsp
  800cdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800ce2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ce9:	48 98                	cltq   
  800ceb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cf2:	00 
  800cf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cff:	48 89 d1             	mov    %rdx,%rcx
  800d02:	48 89 c2             	mov    %rax,%rdx
  800d05:	be 01 00 00 00       	mov    $0x1,%esi
  800d0a:	bf 09 00 00 00       	mov    $0x9,%edi
  800d0f:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
}
  800d1b:	c9                   	leaveq 
  800d1c:	c3                   	retq   

0000000000800d1d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1d:	55                   	push   %rbp
  800d1e:	48 89 e5             	mov    %rsp,%rbp
  800d21:	48 83 ec 20          	sub    $0x20,%rsp
  800d25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d33:	48 98                	cltq   
  800d35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d3c:	00 
  800d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d49:	48 89 d1             	mov    %rdx,%rcx
  800d4c:	48 89 c2             	mov    %rax,%rdx
  800d4f:	be 01 00 00 00       	mov    $0x1,%esi
  800d54:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d59:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	callq  *%rax
}
  800d65:	c9                   	leaveq 
  800d66:	c3                   	retq   

0000000000800d67 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 83 ec 20          	sub    $0x20,%rsp
  800d6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d76:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d7a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d80:	48 63 f0             	movslq %eax,%rsi
  800d83:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d8a:	48 98                	cltq   
  800d8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d97:	00 
  800d98:	49 89 f1             	mov    %rsi,%r9
  800d9b:	49 89 c8             	mov    %rcx,%r8
  800d9e:	48 89 d1             	mov    %rdx,%rcx
  800da1:	48 89 c2             	mov    %rax,%rdx
  800da4:	be 00 00 00 00       	mov    $0x0,%esi
  800da9:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dae:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
}
  800dba:	c9                   	leaveq 
  800dbb:	c3                   	retq   

0000000000800dbc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbc:	55                   	push   %rbp
  800dbd:	48 89 e5             	mov    %rsp,%rbp
  800dc0:	48 83 ec 10          	sub    $0x10,%rsp
  800dc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dcc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800dd3:	00 
  800dd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800dda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800de0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de5:	48 89 c2             	mov    %rax,%rdx
  800de8:	be 01 00 00 00       	mov    $0x1,%esi
  800ded:	bf 0d 00 00 00       	mov    $0xd,%edi
  800df2:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
}
  800dfe:	c9                   	leaveq 
  800dff:	c3                   	retq   

0000000000800e00 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e00:	55                   	push   %rbp
  800e01:	48 89 e5             	mov    %rsp,%rbp
  800e04:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e0f:	00 
  800e10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	be 00 00 00 00       	mov    $0x0,%esi
  800e2b:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e30:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800e37:	00 00 00 
  800e3a:	ff d0                	callq  *%rax
}
  800e3c:	c9                   	leaveq 
  800e3d:	c3                   	retq   

0000000000800e3e <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800e3e:	55                   	push   %rbp
  800e3f:	48 89 e5             	mov    %rsp,%rbp
  800e42:	48 83 ec 30          	sub    $0x30,%rsp
  800e46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e4d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800e50:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e54:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800e58:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e5b:	48 63 c8             	movslq %eax,%rcx
  800e5e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800e62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e65:	48 63 f0             	movslq %eax,%rsi
  800e68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e6f:	48 98                	cltq   
  800e71:	48 89 0c 24          	mov    %rcx,(%rsp)
  800e75:	49 89 f9             	mov    %rdi,%r9
  800e78:	49 89 f0             	mov    %rsi,%r8
  800e7b:	48 89 d1             	mov    %rdx,%rcx
  800e7e:	48 89 c2             	mov    %rax,%rdx
  800e81:	be 00 00 00 00       	mov    $0x0,%esi
  800e86:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e8b:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800e92:	00 00 00 
  800e95:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800e97:	c9                   	leaveq 
  800e98:	c3                   	retq   

0000000000800e99 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800e99:	55                   	push   %rbp
  800e9a:	48 89 e5             	mov    %rsp,%rbp
  800e9d:	48 83 ec 20          	sub    $0x20,%rsp
  800ea1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ea5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ead:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800eb8:	00 
  800eb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ebf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ec5:	48 89 d1             	mov    %rdx,%rcx
  800ec8:	48 89 c2             	mov    %rax,%rdx
  800ecb:	be 00 00 00 00       	mov    $0x0,%esi
  800ed0:	bf 10 00 00 00       	mov    $0x10,%edi
  800ed5:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	callq  *%rax
}
  800ee1:	c9                   	leaveq 
  800ee2:	c3                   	retq   

0000000000800ee3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800ee3:	55                   	push   %rbp
  800ee4:	48 89 e5             	mov    %rsp,%rbp
  800ee7:	48 83 ec 08          	sub    $0x8,%rsp
  800eeb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ef3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800efa:	ff ff ff 
  800efd:	48 01 d0             	add    %rdx,%rax
  800f00:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800f04:	c9                   	leaveq 
  800f05:	c3                   	retq   

0000000000800f06 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	48 83 ec 08          	sub    $0x8,%rsp
  800f0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f16:	48 89 c7             	mov    %rax,%rdi
  800f19:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  800f20:	00 00 00 
  800f23:	ff d0                	callq  *%rax
  800f25:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f2b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f2f:	c9                   	leaveq 
  800f30:	c3                   	retq   

0000000000800f31 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f31:	55                   	push   %rbp
  800f32:	48 89 e5             	mov    %rsp,%rbp
  800f35:	48 83 ec 18          	sub    $0x18,%rsp
  800f39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f44:	eb 6b                	jmp    800fb1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f49:	48 98                	cltq   
  800f4b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f51:	48 c1 e0 0c          	shl    $0xc,%rax
  800f55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5d:	48 c1 e8 15          	shr    $0x15,%rax
  800f61:	48 89 c2             	mov    %rax,%rdx
  800f64:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f6b:	01 00 00 
  800f6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f72:	83 e0 01             	and    $0x1,%eax
  800f75:	48 85 c0             	test   %rax,%rax
  800f78:	74 21                	je     800f9b <fd_alloc+0x6a>
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7e:	48 c1 e8 0c          	shr    $0xc,%rax
  800f82:	48 89 c2             	mov    %rax,%rdx
  800f85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f8c:	01 00 00 
  800f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f93:	83 e0 01             	and    $0x1,%eax
  800f96:	48 85 c0             	test   %rax,%rax
  800f99:	75 12                	jne    800fad <fd_alloc+0x7c>
			*fd_store = fd;
  800f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fa3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	eb 1a                	jmp    800fc7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fb1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fb5:	7e 8f                	jle    800f46 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fc2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fc7:	c9                   	leaveq 
  800fc8:	c3                   	retq   

0000000000800fc9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fc9:	55                   	push   %rbp
  800fca:	48 89 e5             	mov    %rsp,%rbp
  800fcd:	48 83 ec 20          	sub    $0x20,%rsp
  800fd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800fd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800fdc:	78 06                	js     800fe4 <fd_lookup+0x1b>
  800fde:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800fe2:	7e 07                	jle    800feb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fe4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe9:	eb 6c                	jmp    801057 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800feb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fee:	48 98                	cltq   
  800ff0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800ff6:	48 c1 e0 0c          	shl    $0xc,%rax
  800ffa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ffe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801002:	48 c1 e8 15          	shr    $0x15,%rax
  801006:	48 89 c2             	mov    %rax,%rdx
  801009:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801010:	01 00 00 
  801013:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801017:	83 e0 01             	and    $0x1,%eax
  80101a:	48 85 c0             	test   %rax,%rax
  80101d:	74 21                	je     801040 <fd_lookup+0x77>
  80101f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801023:	48 c1 e8 0c          	shr    $0xc,%rax
  801027:	48 89 c2             	mov    %rax,%rdx
  80102a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801031:	01 00 00 
  801034:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801038:	83 e0 01             	and    $0x1,%eax
  80103b:	48 85 c0             	test   %rax,%rax
  80103e:	75 07                	jne    801047 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801040:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801045:	eb 10                	jmp    801057 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801047:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80104b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80104f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801057:	c9                   	leaveq 
  801058:	c3                   	retq   

0000000000801059 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801059:	55                   	push   %rbp
  80105a:	48 89 e5             	mov    %rsp,%rbp
  80105d:	48 83 ec 30          	sub    $0x30,%rsp
  801061:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801065:	89 f0                	mov    %esi,%eax
  801067:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80106a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80106e:	48 89 c7             	mov    %rax,%rdi
  801071:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  801078:	00 00 00 
  80107b:	ff d0                	callq  *%rax
  80107d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801081:	48 89 d6             	mov    %rdx,%rsi
  801084:	89 c7                	mov    %eax,%edi
  801086:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80108d:	00 00 00 
  801090:	ff d0                	callq  *%rax
  801092:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801099:	78 0a                	js     8010a5 <fd_close+0x4c>
	    || fd != fd2)
  80109b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8010a3:	74 12                	je     8010b7 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8010a5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8010a9:	74 05                	je     8010b0 <fd_close+0x57>
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	eb 05                	jmp    8010b5 <fd_close+0x5c>
  8010b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b5:	eb 69                	jmp    801120 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010bb:	8b 00                	mov    (%rax),%eax
  8010bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010c1:	48 89 d6             	mov    %rdx,%rsi
  8010c4:	89 c7                	mov    %eax,%edi
  8010c6:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  8010cd:	00 00 00 
  8010d0:	ff d0                	callq  *%rax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010d9:	78 2a                	js     801105 <fd_close+0xac>
		if (dev->dev_close)
  8010db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010df:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010e3:	48 85 c0             	test   %rax,%rax
  8010e6:	74 16                	je     8010fe <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010f4:	48 89 d7             	mov    %rdx,%rdi
  8010f7:	ff d0                	callq  *%rax
  8010f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010fc:	eb 07                	jmp    801105 <fd_close+0xac>
		else
			r = 0;
  8010fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801105:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801109:	48 89 c6             	mov    %rax,%rsi
  80110c:	bf 00 00 00 00       	mov    $0x0,%edi
  801111:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801118:	00 00 00 
  80111b:	ff d0                	callq  *%rax
	return r;
  80111d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801120:	c9                   	leaveq 
  801121:	c3                   	retq   

0000000000801122 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801122:	55                   	push   %rbp
  801123:	48 89 e5             	mov    %rsp,%rbp
  801126:	48 83 ec 20          	sub    $0x20,%rsp
  80112a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80112d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801138:	eb 41                	jmp    80117b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80113a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801141:	00 00 00 
  801144:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801147:	48 63 d2             	movslq %edx,%rdx
  80114a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80114e:	8b 00                	mov    (%rax),%eax
  801150:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801153:	75 22                	jne    801177 <dev_lookup+0x55>
			*dev = devtab[i];
  801155:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80115c:	00 00 00 
  80115f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801162:	48 63 d2             	movslq %edx,%rdx
  801165:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801169:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	eb 60                	jmp    8011d7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801177:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80117b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801182:	00 00 00 
  801185:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801188:	48 63 d2             	movslq %edx,%rdx
  80118b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80118f:	48 85 c0             	test   %rax,%rax
  801192:	75 a6                	jne    80113a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801194:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80119b:	00 00 00 
  80119e:	48 8b 00             	mov    (%rax),%rax
  8011a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8011a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8011aa:	89 c6                	mov    %eax,%esi
  8011ac:	48 bf c0 3a 80 00 00 	movabs $0x803ac0,%rdi
  8011b3:	00 00 00 
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bb:	48 b9 69 29 80 00 00 	movabs $0x802969,%rcx
  8011c2:	00 00 00 
  8011c5:	ff d1                	callq  *%rcx
	*dev = 0;
  8011c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d7:	c9                   	leaveq 
  8011d8:	c3                   	retq   

00000000008011d9 <close>:

int
close(int fdnum)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	48 83 ec 20          	sub    $0x20,%rsp
  8011e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8011e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011eb:	48 89 d6             	mov    %rdx,%rsi
  8011ee:	89 c7                	mov    %eax,%edi
  8011f0:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	callq  *%rax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801203:	79 05                	jns    80120a <close+0x31>
		return r;
  801205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801208:	eb 18                	jmp    801222 <close+0x49>
	else
		return fd_close(fd, 1);
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	be 01 00 00 00       	mov    $0x1,%esi
  801213:	48 89 c7             	mov    %rax,%rdi
  801216:	48 b8 59 10 80 00 00 	movabs $0x801059,%rax
  80121d:	00 00 00 
  801220:	ff d0                	callq  *%rax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <close_all>:

void
close_all(void)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80122c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801233:	eb 15                	jmp    80124a <close_all+0x26>
		close(i);
  801235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801238:	89 c7                	mov    %eax,%edi
  80123a:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801241:	00 00 00 
  801244:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801246:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80124a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80124e:	7e e5                	jle    801235 <close_all+0x11>
		close(i);
}
  801250:	c9                   	leaveq 
  801251:	c3                   	retq   

0000000000801252 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801252:	55                   	push   %rbp
  801253:	48 89 e5             	mov    %rsp,%rbp
  801256:	48 83 ec 40          	sub    $0x40,%rsp
  80125a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80125d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801260:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801264:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801267:	48 89 d6             	mov    %rdx,%rsi
  80126a:	89 c7                	mov    %eax,%edi
  80126c:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  801273:	00 00 00 
  801276:	ff d0                	callq  *%rax
  801278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80127b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80127f:	79 08                	jns    801289 <dup+0x37>
		return r;
  801281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801284:	e9 70 01 00 00       	jmpq   8013f9 <dup+0x1a7>
	close(newfdnum);
  801289:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80128c:	89 c7                	mov    %eax,%edi
  80128e:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801295:	00 00 00 
  801298:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80129a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80129d:	48 98                	cltq   
  80129f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8012a5:	48 c1 e0 0c          	shl    $0xc,%rax
  8012a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8012ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b1:	48 89 c7             	mov    %rax,%rdi
  8012b4:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  8012bb:	00 00 00 
  8012be:	ff d0                	callq  *%rax
  8012c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
  8012d7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012df:	48 c1 e8 15          	shr    $0x15,%rax
  8012e3:	48 89 c2             	mov    %rax,%rdx
  8012e6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8012ed:	01 00 00 
  8012f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012f4:	83 e0 01             	and    $0x1,%eax
  8012f7:	48 85 c0             	test   %rax,%rax
  8012fa:	74 73                	je     80136f <dup+0x11d>
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	48 c1 e8 0c          	shr    $0xc,%rax
  801304:	48 89 c2             	mov    %rax,%rdx
  801307:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80130e:	01 00 00 
  801311:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801315:	83 e0 01             	and    $0x1,%eax
  801318:	48 85 c0             	test   %rax,%rax
  80131b:	74 52                	je     80136f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801321:	48 c1 e8 0c          	shr    $0xc,%rax
  801325:	48 89 c2             	mov    %rax,%rdx
  801328:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80132f:	01 00 00 
  801332:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801336:	25 07 0e 00 00       	and    $0xe07,%eax
  80133b:	89 c1                	mov    %eax,%ecx
  80133d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801345:	41 89 c8             	mov    %ecx,%r8d
  801348:	48 89 d1             	mov    %rdx,%rcx
  80134b:	ba 00 00 00 00       	mov    $0x0,%edx
  801350:	48 89 c6             	mov    %rax,%rsi
  801353:	bf 00 00 00 00       	mov    $0x0,%edi
  801358:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  80135f:	00 00 00 
  801362:	ff d0                	callq  *%rax
  801364:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80136b:	79 02                	jns    80136f <dup+0x11d>
			goto err;
  80136d:	eb 57                	jmp    8013c6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80136f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801373:	48 c1 e8 0c          	shr    $0xc,%rax
  801377:	48 89 c2             	mov    %rax,%rdx
  80137a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801381:	01 00 00 
  801384:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801388:	25 07 0e 00 00       	and    $0xe07,%eax
  80138d:	89 c1                	mov    %eax,%ecx
  80138f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801393:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801397:	41 89 c8             	mov    %ecx,%r8d
  80139a:	48 89 d1             	mov    %rdx,%rcx
  80139d:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a2:	48 89 c6             	mov    %rax,%rsi
  8013a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8013aa:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  8013b1:	00 00 00 
  8013b4:	ff d0                	callq  *%rax
  8013b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013bd:	79 02                	jns    8013c1 <dup+0x16f>
		goto err;
  8013bf:	eb 05                	jmp    8013c6 <dup+0x174>

	return newfdnum;
  8013c1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013c4:	eb 33                	jmp    8013f9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8013c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ca:	48 89 c6             	mov    %rax,%rsi
  8013cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d2:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  8013d9:	00 00 00 
  8013dc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e2:	48 89 c6             	mov    %rax,%rsi
  8013e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ea:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  8013f1:	00 00 00 
  8013f4:	ff d0                	callq  *%rax
	return r;
  8013f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 40          	sub    $0x40,%rsp
  801403:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801406:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801412:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801415:	48 89 d6             	mov    %rdx,%rsi
  801418:	89 c7                	mov    %eax,%edi
  80141a:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  801421:	00 00 00 
  801424:	ff d0                	callq  *%rax
  801426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801429:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80142d:	78 24                	js     801453 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801433:	8b 00                	mov    (%rax),%eax
  801435:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801439:	48 89 d6             	mov    %rdx,%rsi
  80143c:	89 c7                	mov    %eax,%edi
  80143e:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  801445:	00 00 00 
  801448:	ff d0                	callq  *%rax
  80144a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80144d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801451:	79 05                	jns    801458 <read+0x5d>
		return r;
  801453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801456:	eb 76                	jmp    8014ce <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145c:	8b 40 08             	mov    0x8(%rax),%eax
  80145f:	83 e0 03             	and    $0x3,%eax
  801462:	83 f8 01             	cmp    $0x1,%eax
  801465:	75 3a                	jne    8014a1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801467:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80146e:	00 00 00 
  801471:	48 8b 00             	mov    (%rax),%rax
  801474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80147a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80147d:	89 c6                	mov    %eax,%esi
  80147f:	48 bf df 3a 80 00 00 	movabs $0x803adf,%rdi
  801486:	00 00 00 
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	48 b9 69 29 80 00 00 	movabs $0x802969,%rcx
  801495:	00 00 00 
  801498:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80149a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149f:	eb 2d                	jmp    8014ce <read+0xd3>
	}
	if (!dev->dev_read)
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014a9:	48 85 c0             	test   %rax,%rax
  8014ac:	75 07                	jne    8014b5 <read+0xba>
		return -E_NOT_SUPP;
  8014ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014b3:	eb 19                	jmp    8014ce <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8014b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014c9:	48 89 cf             	mov    %rcx,%rdi
  8014cc:	ff d0                	callq  *%rax
}
  8014ce:	c9                   	leaveq 
  8014cf:	c3                   	retq   

00000000008014d0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014d0:	55                   	push   %rbp
  8014d1:	48 89 e5             	mov    %rsp,%rbp
  8014d4:	48 83 ec 30          	sub    $0x30,%rsp
  8014d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014ea:	eb 49                	jmp    801535 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ef:	48 98                	cltq   
  8014f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014f5:	48 29 c2             	sub    %rax,%rdx
  8014f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014fb:	48 63 c8             	movslq %eax,%rcx
  8014fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801502:	48 01 c1             	add    %rax,%rcx
  801505:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801508:	48 89 ce             	mov    %rcx,%rsi
  80150b:	89 c7                	mov    %eax,%edi
  80150d:	48 b8 fb 13 80 00 00 	movabs $0x8013fb,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
  801519:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80151c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801520:	79 05                	jns    801527 <readn+0x57>
			return m;
  801522:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801525:	eb 1c                	jmp    801543 <readn+0x73>
		if (m == 0)
  801527:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80152b:	75 02                	jne    80152f <readn+0x5f>
			break;
  80152d:	eb 11                	jmp    801540 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80152f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801532:	01 45 fc             	add    %eax,-0x4(%rbp)
  801535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801538:	48 98                	cltq   
  80153a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80153e:	72 ac                	jb     8014ec <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801540:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801543:	c9                   	leaveq 
  801544:	c3                   	retq   

0000000000801545 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	48 83 ec 40          	sub    $0x40,%rsp
  80154d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801550:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801554:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801558:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80155c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80155f:	48 89 d6             	mov    %rdx,%rsi
  801562:	89 c7                	mov    %eax,%edi
  801564:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80156b:	00 00 00 
  80156e:	ff d0                	callq  *%rax
  801570:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801573:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801577:	78 24                	js     80159d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157d:	8b 00                	mov    (%rax),%eax
  80157f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801583:	48 89 d6             	mov    %rdx,%rsi
  801586:	89 c7                	mov    %eax,%edi
  801588:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  80158f:	00 00 00 
  801592:	ff d0                	callq  *%rax
  801594:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80159b:	79 05                	jns    8015a2 <write+0x5d>
		return r;
  80159d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015a0:	eb 42                	jmp    8015e4 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	8b 40 08             	mov    0x8(%rax),%eax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 07                	jne    8015b7 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b5:	eb 2d                	jmp    8015e4 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015bf:	48 85 c0             	test   %rax,%rax
  8015c2:	75 07                	jne    8015cb <write+0x86>
		return -E_NOT_SUPP;
  8015c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8015c9:	eb 19                	jmp    8015e4 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8015cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015d3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8015df:	48 89 cf             	mov    %rcx,%rdi
  8015e2:	ff d0                	callq  *%rax
}
  8015e4:	c9                   	leaveq 
  8015e5:	c3                   	retq   

00000000008015e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e6:	55                   	push   %rbp
  8015e7:	48 89 e5             	mov    %rsp,%rbp
  8015ea:	48 83 ec 18          	sub    $0x18,%rsp
  8015ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015f1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015fb:	48 89 d6             	mov    %rdx,%rsi
  8015fe:	89 c7                	mov    %eax,%edi
  801600:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  801607:	00 00 00 
  80160a:	ff d0                	callq  *%rax
  80160c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80160f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801613:	79 05                	jns    80161a <seek+0x34>
		return r;
  801615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801618:	eb 0f                	jmp    801629 <seek+0x43>
	fd->fd_offset = offset;
  80161a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801621:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801629:	c9                   	leaveq 
  80162a:	c3                   	retq   

000000000080162b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
  80162f:	48 83 ec 30          	sub    $0x30,%rsp
  801633:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801636:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801639:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80163d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801640:	48 89 d6             	mov    %rdx,%rsi
  801643:	89 c7                	mov    %eax,%edi
  801645:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80164c:	00 00 00 
  80164f:	ff d0                	callq  *%rax
  801651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801658:	78 24                	js     80167e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165e:	8b 00                	mov    (%rax),%eax
  801660:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801664:	48 89 d6             	mov    %rdx,%rsi
  801667:	89 c7                	mov    %eax,%edi
  801669:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  801670:	00 00 00 
  801673:	ff d0                	callq  *%rax
  801675:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167c:	79 05                	jns    801683 <ftruncate+0x58>
		return r;
  80167e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801681:	eb 72                	jmp    8016f5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801687:	8b 40 08             	mov    0x8(%rax),%eax
  80168a:	83 e0 03             	and    $0x3,%eax
  80168d:	85 c0                	test   %eax,%eax
  80168f:	75 3a                	jne    8016cb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801691:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801698:	00 00 00 
  80169b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80169e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8016a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016a7:	89 c6                	mov    %eax,%esi
  8016a9:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  8016b0:	00 00 00 
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	48 b9 69 29 80 00 00 	movabs $0x802969,%rcx
  8016bf:	00 00 00 
  8016c2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c9:	eb 2a                	jmp    8016f5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8016cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8016d3:	48 85 c0             	test   %rax,%rax
  8016d6:	75 07                	jne    8016df <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8016d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016dd:	eb 16                	jmp    8016f5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8016df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8016e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016eb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8016ee:	89 ce                	mov    %ecx,%esi
  8016f0:	48 89 d7             	mov    %rdx,%rdi
  8016f3:	ff d0                	callq  *%rax
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	48 83 ec 30          	sub    $0x30,%rsp
  8016ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801702:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801706:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80170a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80170d:	48 89 d6             	mov    %rdx,%rsi
  801710:	89 c7                	mov    %eax,%edi
  801712:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  801719:	00 00 00 
  80171c:	ff d0                	callq  *%rax
  80171e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801721:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801725:	78 24                	js     80174b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172b:	8b 00                	mov    (%rax),%eax
  80172d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801731:	48 89 d6             	mov    %rdx,%rsi
  801734:	89 c7                	mov    %eax,%edi
  801736:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
  801742:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801745:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801749:	79 05                	jns    801750 <fstat+0x59>
		return r;
  80174b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174e:	eb 5e                	jmp    8017ae <fstat+0xb7>
	if (!dev->dev_stat)
  801750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801754:	48 8b 40 28          	mov    0x28(%rax),%rax
  801758:	48 85 c0             	test   %rax,%rax
  80175b:	75 07                	jne    801764 <fstat+0x6d>
		return -E_NOT_SUPP;
  80175d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801762:	eb 4a                	jmp    8017ae <fstat+0xb7>
	stat->st_name[0] = 0;
  801764:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801768:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80176b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801776:	00 00 00 
	stat->st_isdir = 0;
  801779:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801784:	00 00 00 
	stat->st_dev = dev;
  801787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  801796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80179e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017a6:	48 89 ce             	mov    %rcx,%rsi
  8017a9:	48 89 d7             	mov    %rdx,%rdi
  8017ac:	ff d0                	callq  *%rax
}
  8017ae:	c9                   	leaveq 
  8017af:	c3                   	retq   

00000000008017b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 20          	sub    $0x20,%rsp
  8017b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c4:	be 00 00 00 00       	mov    $0x0,%esi
  8017c9:	48 89 c7             	mov    %rax,%rdi
  8017cc:	48 b8 9e 18 80 00 00 	movabs $0x80189e,%rax
  8017d3:	00 00 00 
  8017d6:	ff d0                	callq  *%rax
  8017d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017df:	79 05                	jns    8017e6 <stat+0x36>
		return fd;
  8017e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e4:	eb 2f                	jmp    801815 <stat+0x65>
	r = fstat(fd, stat);
  8017e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ed:	48 89 d6             	mov    %rdx,%rsi
  8017f0:	89 c7                	mov    %eax,%edi
  8017f2:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  8017f9:	00 00 00 
  8017fc:	ff d0                	callq  *%rax
  8017fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801804:	89 c7                	mov    %eax,%edi
  801806:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  80180d:	00 00 00 
  801810:	ff d0                	callq  *%rax
	return r;
  801812:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	48 83 ec 10          	sub    $0x10,%rsp
  80181f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801826:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80182d:	00 00 00 
  801830:	8b 00                	mov    (%rax),%eax
  801832:	85 c0                	test   %eax,%eax
  801834:	75 1d                	jne    801853 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801836:	bf 01 00 00 00       	mov    $0x1,%edi
  80183b:	48 b8 7d 39 80 00 00 	movabs $0x80397d,%rax
  801842:	00 00 00 
  801845:	ff d0                	callq  *%rax
  801847:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80184e:	00 00 00 
  801851:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801853:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80185a:	00 00 00 
  80185d:	8b 00                	mov    (%rax),%eax
  80185f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801862:	b9 07 00 00 00       	mov    $0x7,%ecx
  801867:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80186e:	00 00 00 
  801871:	89 c7                	mov    %eax,%edi
  801873:	48 b8 b0 35 80 00 00 	movabs $0x8035b0,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80187f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801883:	ba 00 00 00 00       	mov    $0x0,%edx
  801888:	48 89 c6             	mov    %rax,%rsi
  80188b:	bf 00 00 00 00       	mov    $0x0,%edi
  801890:	48 b8 b2 34 80 00 00 	movabs $0x8034b2,%rax
  801897:	00 00 00 
  80189a:	ff d0                	callq  *%rax
}
  80189c:	c9                   	leaveq 
  80189d:	c3                   	retq   

000000000080189e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80189e:	55                   	push   %rbp
  80189f:	48 89 e5             	mov    %rsp,%rbp
  8018a2:	48 83 ec 30          	sub    $0x30,%rsp
  8018a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018aa:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8018ad:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8018b4:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8018bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8018c2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018c7:	75 08                	jne    8018d1 <open+0x33>
	{
		return r;
  8018c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cc:	e9 f2 00 00 00       	jmpq   8019c3 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	48 89 c7             	mov    %rax,%rdi
  8018d8:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8018df:	00 00 00 
  8018e2:	ff d0                	callq  *%rax
  8018e4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8018e7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8018ee:	7e 0a                	jle    8018fa <open+0x5c>
	{
		return -E_BAD_PATH;
  8018f0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8018f5:	e9 c9 00 00 00       	jmpq   8019c3 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8018fa:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801901:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801902:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801906:	48 89 c7             	mov    %rax,%rdi
  801909:	48 b8 31 0f 80 00 00 	movabs $0x800f31,%rax
  801910:	00 00 00 
  801913:	ff d0                	callq  *%rax
  801915:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801918:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80191c:	78 09                	js     801927 <open+0x89>
  80191e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801922:	48 85 c0             	test   %rax,%rax
  801925:	75 08                	jne    80192f <open+0x91>
		{
			return r;
  801927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192a:	e9 94 00 00 00       	jmpq   8019c3 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	ba 00 04 00 00       	mov    $0x400,%edx
  801938:	48 89 c6             	mov    %rax,%rsi
  80193b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801942:	00 00 00 
  801945:	48 b8 f6 02 80 00 00 	movabs $0x8002f6,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801951:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801958:	00 00 00 
  80195b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80195e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801968:	48 89 c6             	mov    %rax,%rsi
  80196b:	bf 01 00 00 00       	mov    $0x1,%edi
  801970:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801977:	00 00 00 
  80197a:	ff d0                	callq  *%rax
  80197c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80197f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801983:	79 2b                	jns    8019b0 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801989:	be 00 00 00 00       	mov    $0x0,%esi
  80198e:	48 89 c7             	mov    %rax,%rdi
  801991:	48 b8 59 10 80 00 00 	movabs $0x801059,%rax
  801998:	00 00 00 
  80199b:	ff d0                	callq  *%rax
  80199d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8019a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8019a4:	79 05                	jns    8019ab <open+0x10d>
			{
				return d;
  8019a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a9:	eb 18                	jmp    8019c3 <open+0x125>
			}
			return r;
  8019ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ae:	eb 13                	jmp    8019c3 <open+0x125>
		}	
		return fd2num(fd_store);
  8019b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b4:	48 89 c7             	mov    %rax,%rdi
  8019b7:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  8019be:	00 00 00 
  8019c1:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8019c3:	c9                   	leaveq 
  8019c4:	c3                   	retq   

00000000008019c5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019c5:	55                   	push   %rbp
  8019c6:	48 89 e5             	mov    %rsp,%rbp
  8019c9:	48 83 ec 10          	sub    $0x10,%rsp
  8019cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8019d8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8019df:	00 00 00 
  8019e2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8019e4:	be 00 00 00 00       	mov    $0x0,%esi
  8019e9:	bf 06 00 00 00       	mov    $0x6,%edi
  8019ee:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
}
  8019fa:	c9                   	leaveq 
  8019fb:	c3                   	retq   

00000000008019fc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019fc:	55                   	push   %rbp
  8019fd:	48 89 e5             	mov    %rsp,%rbp
  801a00:	48 83 ec 30          	sub    $0x30,%rsp
  801a04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801a17:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a1c:	74 07                	je     801a25 <devfile_read+0x29>
  801a1e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a23:	75 07                	jne    801a2c <devfile_read+0x30>
		return -E_INVAL;
  801a25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a2a:	eb 77                	jmp    801aa3 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a30:	8b 50 0c             	mov    0xc(%rax),%edx
  801a33:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a3a:	00 00 00 
  801a3d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801a3f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a46:	00 00 00 
  801a49:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801a51:	be 00 00 00 00       	mov    $0x0,%esi
  801a56:	bf 03 00 00 00       	mov    $0x3,%edi
  801a5b:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801a62:	00 00 00 
  801a65:	ff d0                	callq  *%rax
  801a67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a6e:	7f 05                	jg     801a75 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a73:	eb 2e                	jmp    801aa3 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a78:	48 63 d0             	movslq %eax,%rdx
  801a7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a7f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801a86:	00 00 00 
  801a89:	48 89 c7             	mov    %rax,%rdi
  801a8c:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801a98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801aa3:	c9                   	leaveq 
  801aa4:	c3                   	retq   

0000000000801aa5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
  801aa9:	48 83 ec 30          	sub    $0x30,%rsp
  801aad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ab1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ab5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801ab9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801ac0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ac5:	74 07                	je     801ace <devfile_write+0x29>
  801ac7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801acc:	75 08                	jne    801ad6 <devfile_write+0x31>
		return r;
  801ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad1:	e9 9a 00 00 00       	jmpq   801b70 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ada:	8b 50 0c             	mov    0xc(%rax),%edx
  801add:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ae4:	00 00 00 
  801ae7:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801ae9:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801af0:	00 
  801af1:	76 08                	jbe    801afb <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801af3:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801afa:	00 
	}
	fsipcbuf.write.req_n = n;
  801afb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b02:	00 00 00 
  801b05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b09:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801b0d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b15:	48 89 c6             	mov    %rax,%rsi
  801b18:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801b1f:	00 00 00 
  801b22:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801b2e:	be 00 00 00 00       	mov    $0x0,%esi
  801b33:	bf 04 00 00 00       	mov    $0x4,%edi
  801b38:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
  801b44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b4b:	7f 20                	jg     801b6d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801b4d:	48 bf 26 3b 80 00 00 	movabs $0x803b26,%rdi
  801b54:	00 00 00 
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  801b63:	00 00 00 
  801b66:	ff d2                	callq  *%rdx
		return r;
  801b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6b:	eb 03                	jmp    801b70 <devfile_write+0xcb>
	}
	return r;
  801b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 20          	sub    $0x20,%rsp
  801b7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b86:	8b 50 0c             	mov    0xc(%rax),%edx
  801b89:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b90:	00 00 00 
  801b93:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b95:	be 00 00 00 00       	mov    $0x0,%esi
  801b9a:	bf 05 00 00 00       	mov    $0x5,%edi
  801b9f:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
  801bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb2:	79 05                	jns    801bb9 <devfile_stat+0x47>
		return r;
  801bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb7:	eb 56                	jmp    801c0f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bbd:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801bc4:	00 00 00 
  801bc7:	48 89 c7             	mov    %rax,%rdi
  801bca:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801bd1:	00 00 00 
  801bd4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801bd6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bdd:	00 00 00 
  801be0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801be6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bea:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bf0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bf7:	00 00 00 
  801bfa:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801c00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c04:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 10          	sub    $0x10,%rsp
  801c19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c1d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c24:	8b 50 0c             	mov    0xc(%rax),%edx
  801c27:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c2e:	00 00 00 
  801c31:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801c33:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c3a:	00 00 00 
  801c3d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c40:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c43:	be 00 00 00 00       	mov    $0x0,%esi
  801c48:	bf 02 00 00 00       	mov    $0x2,%edi
  801c4d:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <remove>:

// Delete a file
int
remove(const char *path)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 10          	sub    $0x10,%rsp
  801c63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801c67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6b:	48 89 c7             	mov    %rax,%rdi
  801c6e:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
  801c7a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c7f:	7e 07                	jle    801c88 <remove+0x2d>
		return -E_BAD_PATH;
  801c81:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801c86:	eb 33                	jmp    801cbb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8c:	48 89 c6             	mov    %rax,%rsi
  801c8f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801c96:	00 00 00 
  801c99:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801ca5:	be 00 00 00 00       	mov    $0x0,%esi
  801caa:	bf 07 00 00 00       	mov    $0x7,%edi
  801caf:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	callq  *%rax
}
  801cbb:	c9                   	leaveq 
  801cbc:	c3                   	retq   

0000000000801cbd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801cbd:	55                   	push   %rbp
  801cbe:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cc1:	be 00 00 00 00       	mov    $0x0,%esi
  801cc6:	bf 08 00 00 00       	mov    $0x8,%edi
  801ccb:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
}
  801cd7:	5d                   	pop    %rbp
  801cd8:	c3                   	retq   

0000000000801cd9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801ce4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801ceb:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801cf2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801cf9:	be 00 00 00 00       	mov    $0x0,%esi
  801cfe:	48 89 c7             	mov    %rax,%rdi
  801d01:	48 b8 9e 18 80 00 00 	movabs $0x80189e,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
  801d0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801d10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d14:	79 28                	jns    801d3e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d19:	89 c6                	mov    %eax,%esi
  801d1b:	48 bf 42 3b 80 00 00 	movabs $0x803b42,%rdi
  801d22:	00 00 00 
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2a:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  801d31:	00 00 00 
  801d34:	ff d2                	callq  *%rdx
		return fd_src;
  801d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d39:	e9 74 01 00 00       	jmpq   801eb2 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801d3e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801d45:	be 01 01 00 00       	mov    $0x101,%esi
  801d4a:	48 89 c7             	mov    %rax,%rdi
  801d4d:	48 b8 9e 18 80 00 00 	movabs $0x80189e,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	callq  *%rax
  801d59:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801d5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d60:	79 39                	jns    801d9b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801d62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d65:	89 c6                	mov    %eax,%esi
  801d67:	48 bf 58 3b 80 00 00 	movabs $0x803b58,%rdi
  801d6e:	00 00 00 
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  801d7d:	00 00 00 
  801d80:	ff d2                	callq  *%rdx
		close(fd_src);
  801d82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d85:	89 c7                	mov    %eax,%edi
  801d87:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
		return fd_dest;
  801d93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d96:	e9 17 01 00 00       	jmpq   801eb2 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801d9b:	eb 74                	jmp    801e11 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801d9d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801da0:	48 63 d0             	movslq %eax,%rdx
  801da3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801daa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dad:	48 89 ce             	mov    %rcx,%rsi
  801db0:	89 c7                	mov    %eax,%edi
  801db2:	48 b8 45 15 80 00 00 	movabs $0x801545,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	callq  *%rax
  801dbe:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801dc5:	79 4a                	jns    801e11 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801dc7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801dca:	89 c6                	mov    %eax,%esi
  801dcc:	48 bf 72 3b 80 00 00 	movabs $0x803b72,%rdi
  801dd3:	00 00 00 
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddb:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  801de2:	00 00 00 
  801de5:	ff d2                	callq  *%rdx
			close(fd_src);
  801de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dea:	89 c7                	mov    %eax,%edi
  801dec:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801df3:	00 00 00 
  801df6:	ff d0                	callq  *%rax
			close(fd_dest);
  801df8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dfb:	89 c7                	mov    %eax,%edi
  801dfd:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	callq  *%rax
			return write_size;
  801e09:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e0c:	e9 a1 00 00 00       	jmpq   801eb2 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801e11:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1b:	ba 00 02 00 00       	mov    $0x200,%edx
  801e20:	48 89 ce             	mov    %rcx,%rsi
  801e23:	89 c7                	mov    %eax,%edi
  801e25:	48 b8 fb 13 80 00 00 	movabs $0x8013fb,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
  801e31:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e38:	0f 8f 5f ff ff ff    	jg     801d9d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e42:	79 47                	jns    801e8b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801e44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e47:	89 c6                	mov    %eax,%esi
  801e49:	48 bf 85 3b 80 00 00 	movabs $0x803b85,%rdi
  801e50:	00 00 00 
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  801e5f:	00 00 00 
  801e62:	ff d2                	callq  *%rdx
		close(fd_src);
  801e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e67:	89 c7                	mov    %eax,%edi
  801e69:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	callq  *%rax
		close(fd_dest);
  801e75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e78:	89 c7                	mov    %eax,%edi
  801e7a:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801e81:	00 00 00 
  801e84:	ff d0                	callq  *%rax
		return read_size;
  801e86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e89:	eb 27                	jmp    801eb2 <copy+0x1d9>
	}
	close(fd_src);
  801e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8e:	89 c7                	mov    %eax,%edi
  801e90:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
	close(fd_dest);
  801e9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e9f:	89 c7                	mov    %eax,%edi
  801ea1:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax
	return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801eb2:	c9                   	leaveq 
  801eb3:	c3                   	retq   

0000000000801eb4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801eb4:	55                   	push   %rbp
  801eb5:	48 89 e5             	mov    %rsp,%rbp
  801eb8:	53                   	push   %rbx
  801eb9:	48 83 ec 38          	sub    $0x38,%rsp
  801ebd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ec1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801ec5:	48 89 c7             	mov    %rax,%rdi
  801ec8:	48 b8 31 0f 80 00 00 	movabs $0x800f31,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
  801ed4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ed7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801edb:	0f 88 bf 01 00 00    	js     8020a0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee5:	ba 07 04 00 00       	mov    $0x407,%edx
  801eea:	48 89 c6             	mov    %rax,%rsi
  801eed:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef2:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f05:	0f 88 95 01 00 00    	js     8020a0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f0b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f0f:	48 89 c7             	mov    %rax,%rdi
  801f12:	48 b8 31 0f 80 00 00 	movabs $0x800f31,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f25:	0f 88 5d 01 00 00    	js     802088 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f2f:	ba 07 04 00 00       	mov    $0x407,%edx
  801f34:	48 89 c6             	mov    %rax,%rsi
  801f37:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3c:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
  801f48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f4f:	0f 88 33 01 00 00    	js     802088 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f59:	48 89 c7             	mov    %rax,%rdi
  801f5c:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	callq  *%rax
  801f68:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f70:	ba 07 04 00 00       	mov    $0x407,%edx
  801f75:	48 89 c6             	mov    %rax,%rsi
  801f78:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7d:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801f84:	00 00 00 
  801f87:	ff d0                	callq  *%rax
  801f89:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f90:	79 05                	jns    801f97 <pipe+0xe3>
		goto err2;
  801f92:	e9 d9 00 00 00       	jmpq   802070 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f9b:	48 89 c7             	mov    %rax,%rdi
  801f9e:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
  801faa:	48 89 c2             	mov    %rax,%rdx
  801fad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801fb7:	48 89 d1             	mov    %rdx,%rcx
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	48 89 c6             	mov    %rax,%rsi
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	callq  *%rax
  801fd3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fda:	79 1b                	jns    801ff7 <pipe+0x143>
		goto err3;
  801fdc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801fdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe1:	48 89 c6             	mov    %rax,%rsi
  801fe4:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe9:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
  801ff5:	eb 79                	jmp    802070 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ff7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffb:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802002:	00 00 00 
  802005:	8b 12                	mov    (%rdx),%edx
  802007:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802009:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802014:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802018:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80201f:	00 00 00 
  802022:	8b 12                	mov    (%rdx),%edx
  802024:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802026:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80202a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802035:	48 89 c7             	mov    %rax,%rdi
  802038:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  80203f:	00 00 00 
  802042:	ff d0                	callq  *%rax
  802044:	89 c2                	mov    %eax,%edx
  802046:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80204a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80204c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802050:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802058:	48 89 c7             	mov    %rax,%rdi
  80205b:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  802062:	00 00 00 
  802065:	ff d0                	callq  *%rax
  802067:	89 03                	mov    %eax,(%rbx)
	return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	eb 33                	jmp    8020a3 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802070:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802074:	48 89 c6             	mov    %rax,%rsi
  802077:	bf 00 00 00 00       	mov    $0x0,%edi
  80207c:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802083:	00 00 00 
  802086:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208c:	48 89 c6             	mov    %rax,%rsi
  80208f:	bf 00 00 00 00       	mov    $0x0,%edi
  802094:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
err:
	return r;
  8020a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8020a3:	48 83 c4 38          	add    $0x38,%rsp
  8020a7:	5b                   	pop    %rbx
  8020a8:	5d                   	pop    %rbp
  8020a9:	c3                   	retq   

00000000008020aa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020aa:	55                   	push   %rbp
  8020ab:	48 89 e5             	mov    %rsp,%rbp
  8020ae:	53                   	push   %rbx
  8020af:	48 83 ec 28          	sub    $0x28,%rsp
  8020b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020c2:	00 00 00 
  8020c5:	48 8b 00             	mov    (%rax),%rax
  8020c8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8020d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d5:	48 89 c7             	mov    %rax,%rdi
  8020d8:	48 b8 ef 39 80 00 00 	movabs $0x8039ef,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	callq  *%rax
  8020e4:	89 c3                	mov    %eax,%ebx
  8020e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020ea:	48 89 c7             	mov    %rax,%rdi
  8020ed:	48 b8 ef 39 80 00 00 	movabs $0x8039ef,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
  8020f9:	39 c3                	cmp    %eax,%ebx
  8020fb:	0f 94 c0             	sete   %al
  8020fe:	0f b6 c0             	movzbl %al,%eax
  802101:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802104:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80210b:	00 00 00 
  80210e:	48 8b 00             	mov    (%rax),%rax
  802111:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802117:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80211a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802120:	75 05                	jne    802127 <_pipeisclosed+0x7d>
			return ret;
  802122:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802125:	eb 4f                	jmp    802176 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802127:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80212a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80212d:	74 42                	je     802171 <_pipeisclosed+0xc7>
  80212f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802133:	75 3c                	jne    802171 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802135:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80213c:	00 00 00 
  80213f:	48 8b 00             	mov    (%rax),%rax
  802142:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802148:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80214b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80214e:	89 c6                	mov    %eax,%esi
  802150:	48 bf a5 3b 80 00 00 	movabs $0x803ba5,%rdi
  802157:	00 00 00 
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	49 b8 69 29 80 00 00 	movabs $0x802969,%r8
  802166:	00 00 00 
  802169:	41 ff d0             	callq  *%r8
	}
  80216c:	e9 4a ff ff ff       	jmpq   8020bb <_pipeisclosed+0x11>
  802171:	e9 45 ff ff ff       	jmpq   8020bb <_pipeisclosed+0x11>
}
  802176:	48 83 c4 28          	add    $0x28,%rsp
  80217a:	5b                   	pop    %rbx
  80217b:	5d                   	pop    %rbp
  80217c:	c3                   	retq   

000000000080217d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	48 83 ec 30          	sub    $0x30,%rsp
  802185:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802188:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80218c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80218f:	48 89 d6             	mov    %rdx,%rsi
  802192:	89 c7                	mov    %eax,%edi
  802194:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80219b:	00 00 00 
  80219e:	ff d0                	callq  *%rax
  8021a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a7:	79 05                	jns    8021ae <pipeisclosed+0x31>
		return r;
  8021a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ac:	eb 31                	jmp    8021df <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	48 89 c7             	mov    %rax,%rdi
  8021b5:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021cd:	48 89 d6             	mov    %rdx,%rsi
  8021d0:	48 89 c7             	mov    %rax,%rdi
  8021d3:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	callq  *%rax
}
  8021df:	c9                   	leaveq 
  8021e0:	c3                   	retq   

00000000008021e1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021e1:	55                   	push   %rbp
  8021e2:	48 89 e5             	mov    %rsp,%rbp
  8021e5:	48 83 ec 40          	sub    $0x40,%rsp
  8021e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f9:	48 89 c7             	mov    %rax,%rdi
  8021fc:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax
  802208:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80220c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802210:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802214:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80221b:	00 
  80221c:	e9 92 00 00 00       	jmpq   8022b3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802221:	eb 41                	jmp    802264 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802223:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802228:	74 09                	je     802233 <devpipe_read+0x52>
				return i;
  80222a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222e:	e9 92 00 00 00       	jmpq   8022c5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802233:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802237:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223b:	48 89 d6             	mov    %rdx,%rsi
  80223e:	48 89 c7             	mov    %rax,%rdi
  802241:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	74 07                	je     802258 <devpipe_read+0x77>
				return 0;
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	eb 6d                	jmp    8022c5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802258:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802268:	8b 10                	mov    (%rax),%edx
  80226a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226e:	8b 40 04             	mov    0x4(%rax),%eax
  802271:	39 c2                	cmp    %eax,%edx
  802273:	74 ae                	je     802223 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802279:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802285:	8b 00                	mov    (%rax),%eax
  802287:	99                   	cltd   
  802288:	c1 ea 1b             	shr    $0x1b,%edx
  80228b:	01 d0                	add    %edx,%eax
  80228d:	83 e0 1f             	and    $0x1f,%eax
  802290:	29 d0                	sub    %edx,%eax
  802292:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802296:	48 98                	cltq   
  802298:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80229d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a3:	8b 00                	mov    (%rax),%eax
  8022a5:	8d 50 01             	lea    0x1(%rax),%edx
  8022a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ac:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8022bb:	0f 82 60 ff ff ff    	jb     802221 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022c5:	c9                   	leaveq 
  8022c6:	c3                   	retq   

00000000008022c7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022c7:	55                   	push   %rbp
  8022c8:	48 89 e5             	mov    %rsp,%rbp
  8022cb:	48 83 ec 40          	sub    $0x40,%rsp
  8022cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022df:	48 89 c7             	mov    %rax,%rdi
  8022e2:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  8022e9:	00 00 00 
  8022ec:	ff d0                	callq  *%rax
  8022ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8022f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8022fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802301:	00 
  802302:	e9 8e 00 00 00       	jmpq   802395 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802307:	eb 31                	jmp    80233a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802309:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802311:	48 89 d6             	mov    %rdx,%rsi
  802314:	48 89 c7             	mov    %rax,%rdi
  802317:	48 b8 aa 20 80 00 00 	movabs $0x8020aa,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 07                	je     80232e <devpipe_write+0x67>
				return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	eb 79                	jmp    8023a7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80232e:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  802335:	00 00 00 
  802338:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80233a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233e:	8b 40 04             	mov    0x4(%rax),%eax
  802341:	48 63 d0             	movslq %eax,%rdx
  802344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802348:	8b 00                	mov    (%rax),%eax
  80234a:	48 98                	cltq   
  80234c:	48 83 c0 20          	add    $0x20,%rax
  802350:	48 39 c2             	cmp    %rax,%rdx
  802353:	73 b4                	jae    802309 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802359:	8b 40 04             	mov    0x4(%rax),%eax
  80235c:	99                   	cltd   
  80235d:	c1 ea 1b             	shr    $0x1b,%edx
  802360:	01 d0                	add    %edx,%eax
  802362:	83 e0 1f             	and    $0x1f,%eax
  802365:	29 d0                	sub    %edx,%eax
  802367:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80236b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80236f:	48 01 ca             	add    %rcx,%rdx
  802372:	0f b6 0a             	movzbl (%rdx),%ecx
  802375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802379:	48 98                	cltq   
  80237b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80237f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802383:	8b 40 04             	mov    0x4(%rax),%eax
  802386:	8d 50 01             	lea    0x1(%rax),%edx
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802390:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802399:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80239d:	0f 82 64 ff ff ff    	jb     802307 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023a7:	c9                   	leaveq 
  8023a8:	c3                   	retq   

00000000008023a9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023a9:	55                   	push   %rbp
  8023aa:	48 89 e5             	mov    %rsp,%rbp
  8023ad:	48 83 ec 20          	sub    $0x20,%rsp
  8023b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bd:	48 89 c7             	mov    %rax,%rdi
  8023c0:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
  8023cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8023d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d4:	48 be b8 3b 80 00 00 	movabs $0x803bb8,%rsi
  8023db:	00 00 00 
  8023de:	48 89 c7             	mov    %rax,%rdi
  8023e1:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  8023e8:	00 00 00 
  8023eb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8023ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f1:	8b 50 04             	mov    0x4(%rax),%edx
  8023f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f8:	8b 00                	mov    (%rax),%eax
  8023fa:	29 c2                	sub    %eax,%edx
  8023fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802400:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802406:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802411:	00 00 00 
	stat->st_dev = &devpipe;
  802414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802418:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  80241f:	00 00 00 
  802422:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242e:	c9                   	leaveq 
  80242f:	c3                   	retq   

0000000000802430 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	48 83 ec 10          	sub    $0x10,%rsp
  802438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80243c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802440:	48 89 c6             	mov    %rax,%rsi
  802443:	bf 00 00 00 00       	mov    $0x0,%edi
  802448:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802458:	48 89 c7             	mov    %rax,%rdi
  80245b:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
  802467:	48 89 c6             	mov    %rax,%rsi
  80246a:	bf 00 00 00 00       	mov    $0x0,%edi
  80246f:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
}
  80247b:	c9                   	leaveq 
  80247c:	c3                   	retq   

000000000080247d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80247d:	55                   	push   %rbp
  80247e:	48 89 e5             	mov    %rsp,%rbp
  802481:	48 83 ec 20          	sub    $0x20,%rsp
  802485:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802488:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80248e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802492:	be 01 00 00 00       	mov    $0x1,%esi
  802497:	48 89 c7             	mov    %rax,%rdi
  80249a:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
}
  8024a6:	c9                   	leaveq 
  8024a7:	c3                   	retq   

00000000008024a8 <getchar>:

int
getchar(void)
{
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024b0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8024b4:	ba 01 00 00 00       	mov    $0x1,%edx
  8024b9:	48 89 c6             	mov    %rax,%rsi
  8024bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c1:	48 b8 fb 13 80 00 00 	movabs $0x8013fb,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax
  8024cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8024d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d4:	79 05                	jns    8024db <getchar+0x33>
		return r;
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d9:	eb 14                	jmp    8024ef <getchar+0x47>
	if (r < 1)
  8024db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024df:	7f 07                	jg     8024e8 <getchar+0x40>
		return -E_EOF;
  8024e1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8024e6:	eb 07                	jmp    8024ef <getchar+0x47>
	return c;
  8024e8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8024ec:	0f b6 c0             	movzbl %al,%eax
}
  8024ef:	c9                   	leaveq 
  8024f0:	c3                   	retq   

00000000008024f1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024f1:	55                   	push   %rbp
  8024f2:	48 89 e5             	mov    %rsp,%rbp
  8024f5:	48 83 ec 20          	sub    $0x20,%rsp
  8024f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024fc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802500:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802503:	48 89 d6             	mov    %rdx,%rsi
  802506:	89 c7                	mov    %eax,%edi
  802508:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax
  802514:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802517:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251b:	79 05                	jns    802522 <iscons+0x31>
		return r;
  80251d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802520:	eb 1a                	jmp    80253c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802526:	8b 10                	mov    (%rax),%edx
  802528:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  80252f:	00 00 00 
  802532:	8b 00                	mov    (%rax),%eax
  802534:	39 c2                	cmp    %eax,%edx
  802536:	0f 94 c0             	sete   %al
  802539:	0f b6 c0             	movzbl %al,%eax
}
  80253c:	c9                   	leaveq 
  80253d:	c3                   	retq   

000000000080253e <opencons>:

int
opencons(void)
{
  80253e:	55                   	push   %rbp
  80253f:	48 89 e5             	mov    %rsp,%rbp
  802542:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802546:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80254a:	48 89 c7             	mov    %rax,%rdi
  80254d:	48 b8 31 0f 80 00 00 	movabs $0x800f31,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	79 05                	jns    802567 <opencons+0x29>
		return r;
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	eb 5b                	jmp    8025c2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802567:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256b:	ba 07 04 00 00       	mov    $0x407,%edx
  802570:	48 89 c6             	mov    %rax,%rsi
  802573:	bf 00 00 00 00       	mov    $0x0,%edi
  802578:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	79 05                	jns    802592 <opencons+0x54>
		return r;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	eb 30                	jmp    8025c2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802596:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  80259d:	00 00 00 
  8025a0:	8b 12                	mov    (%rdx),%edx
  8025a2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8025a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8025af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b3:	48 89 c7             	mov    %rax,%rdi
  8025b6:	48 b8 e3 0e 80 00 00 	movabs $0x800ee3,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
}
  8025c2:	c9                   	leaveq 
  8025c3:	c3                   	retq   

00000000008025c4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025c4:	55                   	push   %rbp
  8025c5:	48 89 e5             	mov    %rsp,%rbp
  8025c8:	48 83 ec 30          	sub    $0x30,%rsp
  8025cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8025d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025dd:	75 07                	jne    8025e6 <devcons_read+0x22>
		return 0;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	eb 4b                	jmp    802631 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8025e6:	eb 0c                	jmp    8025f4 <devcons_read+0x30>
		sys_yield();
  8025e8:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025f4:	48 b8 95 0a 80 00 00 	movabs $0x800a95,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802607:	74 df                	je     8025e8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802609:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260d:	79 05                	jns    802614 <devcons_read+0x50>
		return c;
  80260f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802612:	eb 1d                	jmp    802631 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802614:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802618:	75 07                	jne    802621 <devcons_read+0x5d>
		return 0;
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	eb 10                	jmp    802631 <devcons_read+0x6d>
	*(char*)vbuf = c;
  802621:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802624:	89 c2                	mov    %eax,%edx
  802626:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262a:	88 10                	mov    %dl,(%rax)
	return 1;
  80262c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802631:	c9                   	leaveq 
  802632:	c3                   	retq   

0000000000802633 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802633:	55                   	push   %rbp
  802634:	48 89 e5             	mov    %rsp,%rbp
  802637:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80263e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802645:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80264c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802653:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80265a:	eb 76                	jmp    8026d2 <devcons_write+0x9f>
		m = n - tot;
  80265c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802663:	89 c2                	mov    %eax,%edx
  802665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802668:	29 c2                	sub    %eax,%edx
  80266a:	89 d0                	mov    %edx,%eax
  80266c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80266f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802672:	83 f8 7f             	cmp    $0x7f,%eax
  802675:	76 07                	jbe    80267e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802677:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80267e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802681:	48 63 d0             	movslq %eax,%rdx
  802684:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802687:	48 63 c8             	movslq %eax,%rcx
  80268a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802691:	48 01 c1             	add    %rax,%rcx
  802694:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80269b:	48 89 ce             	mov    %rcx,%rsi
  80269e:	48 89 c7             	mov    %rax,%rdi
  8026a1:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8026ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026b0:	48 63 d0             	movslq %eax,%rdx
  8026b3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8026ba:	48 89 d6             	mov    %rdx,%rsi
  8026bd:	48 89 c7             	mov    %rax,%rdi
  8026c0:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026cf:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d5:	48 98                	cltq   
  8026d7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8026de:	0f 82 78 ff ff ff    	jb     80265c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e7:	c9                   	leaveq 
  8026e8:	c3                   	retq   

00000000008026e9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8026e9:	55                   	push   %rbp
  8026ea:	48 89 e5             	mov    %rsp,%rbp
  8026ed:	48 83 ec 08          	sub    $0x8,%rsp
  8026f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fa:	c9                   	leaveq 
  8026fb:	c3                   	retq   

00000000008026fc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026fc:	55                   	push   %rbp
  8026fd:	48 89 e5             	mov    %rsp,%rbp
  802700:	48 83 ec 10          	sub    $0x10,%rsp
  802704:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802708:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80270c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802710:	48 be c4 3b 80 00 00 	movabs $0x803bc4,%rsi
  802717:	00 00 00 
  80271a:	48 89 c7             	mov    %rax,%rdi
  80271d:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
	return 0;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272e:	c9                   	leaveq 
  80272f:	c3                   	retq   

0000000000802730 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802730:	55                   	push   %rbp
  802731:	48 89 e5             	mov    %rsp,%rbp
  802734:	53                   	push   %rbx
  802735:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80273c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802743:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802749:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802750:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802757:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80275e:	84 c0                	test   %al,%al
  802760:	74 23                	je     802785 <_panic+0x55>
  802762:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802769:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80276d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802771:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802775:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802779:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80277d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802781:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802785:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80278c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802793:	00 00 00 
  802796:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80279d:	00 00 00 
  8027a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027a4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8027ab:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8027b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027b9:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8027c0:	00 00 00 
  8027c3:	48 8b 18             	mov    (%rax),%rbx
  8027c6:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax
  8027d2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8027d8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027df:	41 89 c8             	mov    %ecx,%r8d
  8027e2:	48 89 d1             	mov    %rdx,%rcx
  8027e5:	48 89 da             	mov    %rbx,%rdx
  8027e8:	89 c6                	mov    %eax,%esi
  8027ea:	48 bf d0 3b 80 00 00 	movabs $0x803bd0,%rdi
  8027f1:	00 00 00 
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	49 b9 69 29 80 00 00 	movabs $0x802969,%r9
  802800:	00 00 00 
  802803:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802806:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80280d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802814:	48 89 d6             	mov    %rdx,%rsi
  802817:	48 89 c7             	mov    %rax,%rdi
  80281a:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
	cprintf("\n");
  802826:	48 bf f3 3b 80 00 00 	movabs $0x803bf3,%rdi
  80282d:	00 00 00 
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
  802835:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  80283c:	00 00 00 
  80283f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802841:	cc                   	int3   
  802842:	eb fd                	jmp    802841 <_panic+0x111>

0000000000802844 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802844:	55                   	push   %rbp
  802845:	48 89 e5             	mov    %rsp,%rbp
  802848:	48 83 ec 10          	sub    $0x10,%rsp
  80284c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80284f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802853:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802857:	8b 00                	mov    (%rax),%eax
  802859:	8d 48 01             	lea    0x1(%rax),%ecx
  80285c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802860:	89 0a                	mov    %ecx,(%rdx)
  802862:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802865:	89 d1                	mov    %edx,%ecx
  802867:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80286b:	48 98                	cltq   
  80286d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802875:	8b 00                	mov    (%rax),%eax
  802877:	3d ff 00 00 00       	cmp    $0xff,%eax
  80287c:	75 2c                	jne    8028aa <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80287e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802882:	8b 00                	mov    (%rax),%eax
  802884:	48 98                	cltq   
  802886:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80288a:	48 83 c2 08          	add    $0x8,%rdx
  80288e:	48 89 c6             	mov    %rax,%rsi
  802891:	48 89 d7             	mov    %rdx,%rdi
  802894:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  80289b:	00 00 00 
  80289e:	ff d0                	callq  *%rax
        b->idx = 0;
  8028a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	8b 40 04             	mov    0x4(%rax),%eax
  8028b1:	8d 50 01             	lea    0x1(%rax),%edx
  8028b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8028bb:	c9                   	leaveq 
  8028bc:	c3                   	retq   

00000000008028bd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8028bd:	55                   	push   %rbp
  8028be:	48 89 e5             	mov    %rsp,%rbp
  8028c1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8028c8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8028cf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8028d6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8028dd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8028e4:	48 8b 0a             	mov    (%rdx),%rcx
  8028e7:	48 89 08             	mov    %rcx,(%rax)
  8028ea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8028ee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8028f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8028f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8028fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802901:	00 00 00 
    b.cnt = 0;
  802904:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80290b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80290e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802915:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80291c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802923:	48 89 c6             	mov    %rax,%rsi
  802926:	48 bf 44 28 80 00 00 	movabs $0x802844,%rdi
  80292d:	00 00 00 
  802930:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802937:	00 00 00 
  80293a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80293c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802942:	48 98                	cltq   
  802944:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80294b:	48 83 c2 08          	add    $0x8,%rdx
  80294f:	48 89 c6             	mov    %rax,%rsi
  802952:	48 89 d7             	mov    %rdx,%rdi
  802955:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802961:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802967:	c9                   	leaveq 
  802968:	c3                   	retq   

0000000000802969 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802969:	55                   	push   %rbp
  80296a:	48 89 e5             	mov    %rsp,%rbp
  80296d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802974:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80297b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802982:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802989:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802990:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802997:	84 c0                	test   %al,%al
  802999:	74 20                	je     8029bb <cprintf+0x52>
  80299b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80299f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8029a3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029a7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029ab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029af:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029b3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8029b7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8029bb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8029c2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8029c9:	00 00 00 
  8029cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8029d3:	00 00 00 
  8029d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8029e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8029ef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8029f6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029fd:	48 8b 0a             	mov    (%rdx),%rcx
  802a00:	48 89 08             	mov    %rcx,(%rax)
  802a03:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a07:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a0b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a0f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802a13:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802a1a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802a21:	48 89 d6             	mov    %rdx,%rsi
  802a24:	48 89 c7             	mov    %rax,%rdi
  802a27:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
  802a33:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802a39:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802a3f:	c9                   	leaveq 
  802a40:	c3                   	retq   

0000000000802a41 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802a41:	55                   	push   %rbp
  802a42:	48 89 e5             	mov    %rsp,%rbp
  802a45:	53                   	push   %rbx
  802a46:	48 83 ec 38          	sub    $0x38,%rsp
  802a4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802a56:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a59:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a5d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a61:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a64:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a68:	77 3b                	ja     802aa5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a6a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a6d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a71:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a78:	ba 00 00 00 00       	mov    $0x0,%edx
  802a7d:	48 f7 f3             	div    %rbx
  802a80:	48 89 c2             	mov    %rax,%rdx
  802a83:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a86:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a89:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a91:	41 89 f9             	mov    %edi,%r9d
  802a94:	48 89 c7             	mov    %rax,%rdi
  802a97:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
  802aa3:	eb 1e                	jmp    802ac3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802aa5:	eb 12                	jmp    802ab9 <printnum+0x78>
			putch(padc, putdat);
  802aa7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802aab:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab2:	48 89 ce             	mov    %rcx,%rsi
  802ab5:	89 d7                	mov    %edx,%edi
  802ab7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802ab9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802abd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802ac1:	7f e4                	jg     802aa7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802ac3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aca:	ba 00 00 00 00       	mov    $0x0,%edx
  802acf:	48 f7 f1             	div    %rcx
  802ad2:	48 89 d0             	mov    %rdx,%rax
  802ad5:	48 ba f0 3d 80 00 00 	movabs $0x803df0,%rdx
  802adc:	00 00 00 
  802adf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802ae3:	0f be d0             	movsbl %al,%edx
  802ae6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aee:	48 89 ce             	mov    %rcx,%rsi
  802af1:	89 d7                	mov    %edx,%edi
  802af3:	ff d0                	callq  *%rax
}
  802af5:	48 83 c4 38          	add    $0x38,%rsp
  802af9:	5b                   	pop    %rbx
  802afa:	5d                   	pop    %rbp
  802afb:	c3                   	retq   

0000000000802afc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802afc:	55                   	push   %rbp
  802afd:	48 89 e5             	mov    %rsp,%rbp
  802b00:	48 83 ec 1c          	sub    $0x1c,%rsp
  802b04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b08:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802b0b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802b0f:	7e 52                	jle    802b63 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802b11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b15:	8b 00                	mov    (%rax),%eax
  802b17:	83 f8 30             	cmp    $0x30,%eax
  802b1a:	73 24                	jae    802b40 <getuint+0x44>
  802b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b20:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b28:	8b 00                	mov    (%rax),%eax
  802b2a:	89 c0                	mov    %eax,%eax
  802b2c:	48 01 d0             	add    %rdx,%rax
  802b2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b33:	8b 12                	mov    (%rdx),%edx
  802b35:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3c:	89 0a                	mov    %ecx,(%rdx)
  802b3e:	eb 17                	jmp    802b57 <getuint+0x5b>
  802b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b44:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b48:	48 89 d0             	mov    %rdx,%rax
  802b4b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b53:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b57:	48 8b 00             	mov    (%rax),%rax
  802b5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b5e:	e9 a3 00 00 00       	jmpq   802c06 <getuint+0x10a>
	else if (lflag)
  802b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b67:	74 4f                	je     802bb8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6d:	8b 00                	mov    (%rax),%eax
  802b6f:	83 f8 30             	cmp    $0x30,%eax
  802b72:	73 24                	jae    802b98 <getuint+0x9c>
  802b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b78:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b80:	8b 00                	mov    (%rax),%eax
  802b82:	89 c0                	mov    %eax,%eax
  802b84:	48 01 d0             	add    %rdx,%rax
  802b87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8b:	8b 12                	mov    (%rdx),%edx
  802b8d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b94:	89 0a                	mov    %ecx,(%rdx)
  802b96:	eb 17                	jmp    802baf <getuint+0xb3>
  802b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ba0:	48 89 d0             	mov    %rdx,%rax
  802ba3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802ba7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802baf:	48 8b 00             	mov    (%rax),%rax
  802bb2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802bb6:	eb 4e                	jmp    802c06 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbc:	8b 00                	mov    (%rax),%eax
  802bbe:	83 f8 30             	cmp    $0x30,%eax
  802bc1:	73 24                	jae    802be7 <getuint+0xeb>
  802bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcf:	8b 00                	mov    (%rax),%eax
  802bd1:	89 c0                	mov    %eax,%eax
  802bd3:	48 01 d0             	add    %rdx,%rax
  802bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bda:	8b 12                	mov    (%rdx),%edx
  802bdc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bdf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802be3:	89 0a                	mov    %ecx,(%rdx)
  802be5:	eb 17                	jmp    802bfe <getuint+0x102>
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bef:	48 89 d0             	mov    %rdx,%rax
  802bf2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bfa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bfe:	8b 00                	mov    (%rax),%eax
  802c00:	89 c0                	mov    %eax,%eax
  802c02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c0a:	c9                   	leaveq 
  802c0b:	c3                   	retq   

0000000000802c0c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802c0c:	55                   	push   %rbp
  802c0d:	48 89 e5             	mov    %rsp,%rbp
  802c10:	48 83 ec 1c          	sub    $0x1c,%rsp
  802c14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c18:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802c1b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802c1f:	7e 52                	jle    802c73 <getint+0x67>
		x=va_arg(*ap, long long);
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	8b 00                	mov    (%rax),%eax
  802c27:	83 f8 30             	cmp    $0x30,%eax
  802c2a:	73 24                	jae    802c50 <getint+0x44>
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c38:	8b 00                	mov    (%rax),%eax
  802c3a:	89 c0                	mov    %eax,%eax
  802c3c:	48 01 d0             	add    %rdx,%rax
  802c3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c43:	8b 12                	mov    (%rdx),%edx
  802c45:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c4c:	89 0a                	mov    %ecx,(%rdx)
  802c4e:	eb 17                	jmp    802c67 <getint+0x5b>
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c58:	48 89 d0             	mov    %rdx,%rax
  802c5b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c63:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c67:	48 8b 00             	mov    (%rax),%rax
  802c6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c6e:	e9 a3 00 00 00       	jmpq   802d16 <getint+0x10a>
	else if (lflag)
  802c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c77:	74 4f                	je     802cc8 <getint+0xbc>
		x=va_arg(*ap, long);
  802c79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7d:	8b 00                	mov    (%rax),%eax
  802c7f:	83 f8 30             	cmp    $0x30,%eax
  802c82:	73 24                	jae    802ca8 <getint+0x9c>
  802c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c88:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c90:	8b 00                	mov    (%rax),%eax
  802c92:	89 c0                	mov    %eax,%eax
  802c94:	48 01 d0             	add    %rdx,%rax
  802c97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9b:	8b 12                	mov    (%rdx),%edx
  802c9d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ca0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca4:	89 0a                	mov    %ecx,(%rdx)
  802ca6:	eb 17                	jmp    802cbf <getint+0xb3>
  802ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802cb0:	48 89 d0             	mov    %rdx,%rax
  802cb3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cbb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cbf:	48 8b 00             	mov    (%rax),%rax
  802cc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802cc6:	eb 4e                	jmp    802d16 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccc:	8b 00                	mov    (%rax),%eax
  802cce:	83 f8 30             	cmp    $0x30,%eax
  802cd1:	73 24                	jae    802cf7 <getint+0xeb>
  802cd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802cdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdf:	8b 00                	mov    (%rax),%eax
  802ce1:	89 c0                	mov    %eax,%eax
  802ce3:	48 01 d0             	add    %rdx,%rax
  802ce6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cea:	8b 12                	mov    (%rdx),%edx
  802cec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802cef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cf3:	89 0a                	mov    %ecx,(%rdx)
  802cf5:	eb 17                	jmp    802d0e <getint+0x102>
  802cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802cff:	48 89 d0             	mov    %rdx,%rax
  802d02:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802d06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d0e:	8b 00                	mov    (%rax),%eax
  802d10:	48 98                	cltq   
  802d12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	41 54                	push   %r12
  802d22:	53                   	push   %rbx
  802d23:	48 83 ec 60          	sub    $0x60,%rsp
  802d27:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802d2b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802d2f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d33:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802d37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d3b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802d3f:	48 8b 0a             	mov    (%rdx),%rcx
  802d42:	48 89 08             	mov    %rcx,(%rax)
  802d45:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802d49:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802d4d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802d51:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d55:	eb 17                	jmp    802d6e <vprintfmt+0x52>
			if (ch == '\0')
  802d57:	85 db                	test   %ebx,%ebx
  802d59:	0f 84 cc 04 00 00    	je     80322b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802d5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d67:	48 89 d6             	mov    %rdx,%rsi
  802d6a:	89 df                	mov    %ebx,%edi
  802d6c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d72:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d76:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d7a:	0f b6 00             	movzbl (%rax),%eax
  802d7d:	0f b6 d8             	movzbl %al,%ebx
  802d80:	83 fb 25             	cmp    $0x25,%ebx
  802d83:	75 d2                	jne    802d57 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d85:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d89:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d90:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d97:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d9e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802da5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802da9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802dad:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802db1:	0f b6 00             	movzbl (%rax),%eax
  802db4:	0f b6 d8             	movzbl %al,%ebx
  802db7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802dba:	83 f8 55             	cmp    $0x55,%eax
  802dbd:	0f 87 34 04 00 00    	ja     8031f7 <vprintfmt+0x4db>
  802dc3:	89 c0                	mov    %eax,%eax
  802dc5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802dcc:	00 
  802dcd:	48 b8 18 3e 80 00 00 	movabs $0x803e18,%rax
  802dd4:	00 00 00 
  802dd7:	48 01 d0             	add    %rdx,%rax
  802dda:	48 8b 00             	mov    (%rax),%rax
  802ddd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802ddf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802de3:	eb c0                	jmp    802da5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802de5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802de9:	eb ba                	jmp    802da5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802deb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802df2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802df5:	89 d0                	mov    %edx,%eax
  802df7:	c1 e0 02             	shl    $0x2,%eax
  802dfa:	01 d0                	add    %edx,%eax
  802dfc:	01 c0                	add    %eax,%eax
  802dfe:	01 d8                	add    %ebx,%eax
  802e00:	83 e8 30             	sub    $0x30,%eax
  802e03:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802e06:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802e0a:	0f b6 00             	movzbl (%rax),%eax
  802e0d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802e10:	83 fb 2f             	cmp    $0x2f,%ebx
  802e13:	7e 0c                	jle    802e21 <vprintfmt+0x105>
  802e15:	83 fb 39             	cmp    $0x39,%ebx
  802e18:	7f 07                	jg     802e21 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e1a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802e1f:	eb d1                	jmp    802df2 <vprintfmt+0xd6>
			goto process_precision;
  802e21:	eb 58                	jmp    802e7b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802e23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e26:	83 f8 30             	cmp    $0x30,%eax
  802e29:	73 17                	jae    802e42 <vprintfmt+0x126>
  802e2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e32:	89 c0                	mov    %eax,%eax
  802e34:	48 01 d0             	add    %rdx,%rax
  802e37:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e3a:	83 c2 08             	add    $0x8,%edx
  802e3d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e40:	eb 0f                	jmp    802e51 <vprintfmt+0x135>
  802e42:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e46:	48 89 d0             	mov    %rdx,%rax
  802e49:	48 83 c2 08          	add    $0x8,%rdx
  802e4d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e51:	8b 00                	mov    (%rax),%eax
  802e53:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802e56:	eb 23                	jmp    802e7b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802e58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e5c:	79 0c                	jns    802e6a <vprintfmt+0x14e>
				width = 0;
  802e5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e65:	e9 3b ff ff ff       	jmpq   802da5 <vprintfmt+0x89>
  802e6a:	e9 36 ff ff ff       	jmpq   802da5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e6f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e76:	e9 2a ff ff ff       	jmpq   802da5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e7f:	79 12                	jns    802e93 <vprintfmt+0x177>
				width = precision, precision = -1;
  802e81:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e84:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e87:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e8e:	e9 12 ff ff ff       	jmpq   802da5 <vprintfmt+0x89>
  802e93:	e9 0d ff ff ff       	jmpq   802da5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e98:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e9c:	e9 04 ff ff ff       	jmpq   802da5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802ea1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ea4:	83 f8 30             	cmp    $0x30,%eax
  802ea7:	73 17                	jae    802ec0 <vprintfmt+0x1a4>
  802ea9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ead:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802eb0:	89 c0                	mov    %eax,%eax
  802eb2:	48 01 d0             	add    %rdx,%rax
  802eb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802eb8:	83 c2 08             	add    $0x8,%edx
  802ebb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ebe:	eb 0f                	jmp    802ecf <vprintfmt+0x1b3>
  802ec0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ec4:	48 89 d0             	mov    %rdx,%rax
  802ec7:	48 83 c2 08          	add    $0x8,%rdx
  802ecb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ecf:	8b 10                	mov    (%rax),%edx
  802ed1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802ed5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ed9:	48 89 ce             	mov    %rcx,%rsi
  802edc:	89 d7                	mov    %edx,%edi
  802ede:	ff d0                	callq  *%rax
			break;
  802ee0:	e9 40 03 00 00       	jmpq   803225 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802ee5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ee8:	83 f8 30             	cmp    $0x30,%eax
  802eeb:	73 17                	jae    802f04 <vprintfmt+0x1e8>
  802eed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ef1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ef4:	89 c0                	mov    %eax,%eax
  802ef6:	48 01 d0             	add    %rdx,%rax
  802ef9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802efc:	83 c2 08             	add    $0x8,%edx
  802eff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f02:	eb 0f                	jmp    802f13 <vprintfmt+0x1f7>
  802f04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f08:	48 89 d0             	mov    %rdx,%rax
  802f0b:	48 83 c2 08          	add    $0x8,%rdx
  802f0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f13:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802f15:	85 db                	test   %ebx,%ebx
  802f17:	79 02                	jns    802f1b <vprintfmt+0x1ff>
				err = -err;
  802f19:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802f1b:	83 fb 15             	cmp    $0x15,%ebx
  802f1e:	7f 16                	jg     802f36 <vprintfmt+0x21a>
  802f20:	48 b8 40 3d 80 00 00 	movabs $0x803d40,%rax
  802f27:	00 00 00 
  802f2a:	48 63 d3             	movslq %ebx,%rdx
  802f2d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802f31:	4d 85 e4             	test   %r12,%r12
  802f34:	75 2e                	jne    802f64 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802f36:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f3e:	89 d9                	mov    %ebx,%ecx
  802f40:	48 ba 01 3e 80 00 00 	movabs $0x803e01,%rdx
  802f47:	00 00 00 
  802f4a:	48 89 c7             	mov    %rax,%rdi
  802f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f52:	49 b8 34 32 80 00 00 	movabs $0x803234,%r8
  802f59:	00 00 00 
  802f5c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f5f:	e9 c1 02 00 00       	jmpq   803225 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f64:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f6c:	4c 89 e1             	mov    %r12,%rcx
  802f6f:	48 ba 0a 3e 80 00 00 	movabs $0x803e0a,%rdx
  802f76:	00 00 00 
  802f79:	48 89 c7             	mov    %rax,%rdi
  802f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f81:	49 b8 34 32 80 00 00 	movabs $0x803234,%r8
  802f88:	00 00 00 
  802f8b:	41 ff d0             	callq  *%r8
			break;
  802f8e:	e9 92 02 00 00       	jmpq   803225 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f96:	83 f8 30             	cmp    $0x30,%eax
  802f99:	73 17                	jae    802fb2 <vprintfmt+0x296>
  802f9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fa2:	89 c0                	mov    %eax,%eax
  802fa4:	48 01 d0             	add    %rdx,%rax
  802fa7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802faa:	83 c2 08             	add    $0x8,%edx
  802fad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802fb0:	eb 0f                	jmp    802fc1 <vprintfmt+0x2a5>
  802fb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802fb6:	48 89 d0             	mov    %rdx,%rax
  802fb9:	48 83 c2 08          	add    $0x8,%rdx
  802fbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fc1:	4c 8b 20             	mov    (%rax),%r12
  802fc4:	4d 85 e4             	test   %r12,%r12
  802fc7:	75 0a                	jne    802fd3 <vprintfmt+0x2b7>
				p = "(null)";
  802fc9:	49 bc 0d 3e 80 00 00 	movabs $0x803e0d,%r12
  802fd0:	00 00 00 
			if (width > 0 && padc != '-')
  802fd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fd7:	7e 3f                	jle    803018 <vprintfmt+0x2fc>
  802fd9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802fdd:	74 39                	je     803018 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802fdf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fe2:	48 98                	cltq   
  802fe4:	48 89 c6             	mov    %rax,%rsi
  802fe7:	4c 89 e7             	mov    %r12,%rdi
  802fea:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
  802ff6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802ff9:	eb 17                	jmp    803012 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802ffb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802fff:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803003:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803007:	48 89 ce             	mov    %rcx,%rsi
  80300a:	89 d7                	mov    %edx,%edi
  80300c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80300e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803012:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803016:	7f e3                	jg     802ffb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803018:	eb 37                	jmp    803051 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80301a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80301e:	74 1e                	je     80303e <vprintfmt+0x322>
  803020:	83 fb 1f             	cmp    $0x1f,%ebx
  803023:	7e 05                	jle    80302a <vprintfmt+0x30e>
  803025:	83 fb 7e             	cmp    $0x7e,%ebx
  803028:	7e 14                	jle    80303e <vprintfmt+0x322>
					putch('?', putdat);
  80302a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80302e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803032:	48 89 d6             	mov    %rdx,%rsi
  803035:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80303a:	ff d0                	callq  *%rax
  80303c:	eb 0f                	jmp    80304d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80303e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803042:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803046:	48 89 d6             	mov    %rdx,%rsi
  803049:	89 df                	mov    %ebx,%edi
  80304b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80304d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803051:	4c 89 e0             	mov    %r12,%rax
  803054:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803058:	0f b6 00             	movzbl (%rax),%eax
  80305b:	0f be d8             	movsbl %al,%ebx
  80305e:	85 db                	test   %ebx,%ebx
  803060:	74 10                	je     803072 <vprintfmt+0x356>
  803062:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803066:	78 b2                	js     80301a <vprintfmt+0x2fe>
  803068:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80306c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803070:	79 a8                	jns    80301a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803072:	eb 16                	jmp    80308a <vprintfmt+0x36e>
				putch(' ', putdat);
  803074:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803078:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80307c:	48 89 d6             	mov    %rdx,%rsi
  80307f:	bf 20 00 00 00       	mov    $0x20,%edi
  803084:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803086:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80308a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80308e:	7f e4                	jg     803074 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803090:	e9 90 01 00 00       	jmpq   803225 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803095:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803099:	be 03 00 00 00       	mov    $0x3,%esi
  80309e:	48 89 c7             	mov    %rax,%rdi
  8030a1:	48 b8 0c 2c 80 00 00 	movabs $0x802c0c,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8030b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b5:	48 85 c0             	test   %rax,%rax
  8030b8:	79 1d                	jns    8030d7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8030ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030c2:	48 89 d6             	mov    %rdx,%rsi
  8030c5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8030ca:	ff d0                	callq  *%rax
				num = -(long long) num;
  8030cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d0:	48 f7 d8             	neg    %rax
  8030d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8030d7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030de:	e9 d5 00 00 00       	jmpq   8031b8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8030e3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030e7:	be 03 00 00 00       	mov    $0x3,%esi
  8030ec:	48 89 c7             	mov    %rax,%rdi
  8030ef:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8030f6:	00 00 00 
  8030f9:	ff d0                	callq  *%rax
  8030fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8030ff:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803106:	e9 ad 00 00 00       	jmpq   8031b8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80310b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80310e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803112:	89 d6                	mov    %edx,%esi
  803114:	48 89 c7             	mov    %rax,%rdi
  803117:	48 b8 0c 2c 80 00 00 	movabs $0x802c0c,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803127:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80312e:	e9 85 00 00 00       	jmpq   8031b8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803133:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803137:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80313b:	48 89 d6             	mov    %rdx,%rsi
  80313e:	bf 30 00 00 00       	mov    $0x30,%edi
  803143:	ff d0                	callq  *%rax
			putch('x', putdat);
  803145:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803149:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80314d:	48 89 d6             	mov    %rdx,%rsi
  803150:	bf 78 00 00 00       	mov    $0x78,%edi
  803155:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803157:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80315a:	83 f8 30             	cmp    $0x30,%eax
  80315d:	73 17                	jae    803176 <vprintfmt+0x45a>
  80315f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803163:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803166:	89 c0                	mov    %eax,%eax
  803168:	48 01 d0             	add    %rdx,%rax
  80316b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80316e:	83 c2 08             	add    $0x8,%edx
  803171:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803174:	eb 0f                	jmp    803185 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803176:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80317a:	48 89 d0             	mov    %rdx,%rax
  80317d:	48 83 c2 08          	add    $0x8,%rdx
  803181:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803185:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803188:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80318c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803193:	eb 23                	jmp    8031b8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803195:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803199:	be 03 00 00 00       	mov    $0x3,%esi
  80319e:	48 89 c7             	mov    %rax,%rdi
  8031a1:	48 b8 fc 2a 80 00 00 	movabs $0x802afc,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8031b1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8031b8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8031bd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031c0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8031c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031c7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8031cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031cf:	45 89 c1             	mov    %r8d,%r9d
  8031d2:	41 89 f8             	mov    %edi,%r8d
  8031d5:	48 89 c7             	mov    %rax,%rdi
  8031d8:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
			break;
  8031e4:	eb 3f                	jmp    803225 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8031e6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031ea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031ee:	48 89 d6             	mov    %rdx,%rsi
  8031f1:	89 df                	mov    %ebx,%edi
  8031f3:	ff d0                	callq  *%rax
			break;
  8031f5:	eb 2e                	jmp    803225 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8031f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031ff:	48 89 d6             	mov    %rdx,%rsi
  803202:	bf 25 00 00 00       	mov    $0x25,%edi
  803207:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803209:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80320e:	eb 05                	jmp    803215 <vprintfmt+0x4f9>
  803210:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803215:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803219:	48 83 e8 01          	sub    $0x1,%rax
  80321d:	0f b6 00             	movzbl (%rax),%eax
  803220:	3c 25                	cmp    $0x25,%al
  803222:	75 ec                	jne    803210 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803224:	90                   	nop
		}
	}
  803225:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803226:	e9 43 fb ff ff       	jmpq   802d6e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80322b:	48 83 c4 60          	add    $0x60,%rsp
  80322f:	5b                   	pop    %rbx
  803230:	41 5c                	pop    %r12
  803232:	5d                   	pop    %rbp
  803233:	c3                   	retq   

0000000000803234 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803234:	55                   	push   %rbp
  803235:	48 89 e5             	mov    %rsp,%rbp
  803238:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80323f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803246:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80324d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803254:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80325b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803262:	84 c0                	test   %al,%al
  803264:	74 20                	je     803286 <printfmt+0x52>
  803266:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80326a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80326e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803272:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803276:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80327a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80327e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803282:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803286:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80328d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803294:	00 00 00 
  803297:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80329e:	00 00 00 
  8032a1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8032ac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032b3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8032ba:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8032c1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032c8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8032cf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8032e5:	c9                   	leaveq 
  8032e6:	c3                   	retq   

00000000008032e7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8032e7:	55                   	push   %rbp
  8032e8:	48 89 e5             	mov    %rsp,%rbp
  8032eb:	48 83 ec 10          	sub    $0x10,%rsp
  8032ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8032f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fa:	8b 40 10             	mov    0x10(%rax),%eax
  8032fd:	8d 50 01             	lea    0x1(%rax),%edx
  803300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803304:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330b:	48 8b 10             	mov    (%rax),%rdx
  80330e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803312:	48 8b 40 08          	mov    0x8(%rax),%rax
  803316:	48 39 c2             	cmp    %rax,%rdx
  803319:	73 17                	jae    803332 <sprintputch+0x4b>
		*b->buf++ = ch;
  80331b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331f:	48 8b 00             	mov    (%rax),%rax
  803322:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803326:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80332a:	48 89 0a             	mov    %rcx,(%rdx)
  80332d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803330:	88 10                	mov    %dl,(%rax)
}
  803332:	c9                   	leaveq 
  803333:	c3                   	retq   

0000000000803334 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803334:	55                   	push   %rbp
  803335:	48 89 e5             	mov    %rsp,%rbp
  803338:	48 83 ec 50          	sub    $0x50,%rsp
  80333c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803340:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803343:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803347:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80334b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80334f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803353:	48 8b 0a             	mov    (%rdx),%rcx
  803356:	48 89 08             	mov    %rcx,(%rax)
  803359:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80335d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803361:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803365:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803369:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80336d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803371:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803374:	48 98                	cltq   
  803376:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80337a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80337e:	48 01 d0             	add    %rdx,%rax
  803381:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803385:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80338c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803391:	74 06                	je     803399 <vsnprintf+0x65>
  803393:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803397:	7f 07                	jg     8033a0 <vsnprintf+0x6c>
		return -E_INVAL;
  803399:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80339e:	eb 2f                	jmp    8033cf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8033a0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8033a4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8033a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033ac:	48 89 c6             	mov    %rax,%rsi
  8033af:	48 bf e7 32 80 00 00 	movabs $0x8032e7,%rdi
  8033b6:	00 00 00 
  8033b9:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8033c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8033cc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8033cf:	c9                   	leaveq 
  8033d0:	c3                   	retq   

00000000008033d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8033d1:	55                   	push   %rbp
  8033d2:	48 89 e5             	mov    %rsp,%rbp
  8033d5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8033dc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8033e3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8033e9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033f0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033f7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033fe:	84 c0                	test   %al,%al
  803400:	74 20                	je     803422 <snprintf+0x51>
  803402:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803406:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80340a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80340e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803412:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803416:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80341a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80341e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803422:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803429:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803430:	00 00 00 
  803433:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80343a:	00 00 00 
  80343d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803441:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803448:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80344f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803456:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80345d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803464:	48 8b 0a             	mov    (%rdx),%rcx
  803467:	48 89 08             	mov    %rcx,(%rax)
  80346a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80346e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803472:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803476:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80347a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803481:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803488:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80348e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 34 33 80 00 00 	movabs $0x803334,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8034aa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034b0:	c9                   	leaveq 
  8034b1:	c3                   	retq   

00000000008034b2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034b2:	55                   	push   %rbp
  8034b3:	48 89 e5             	mov    %rsp,%rbp
  8034b6:	48 83 ec 30          	sub    $0x30,%rsp
  8034ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8034c6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034cd:	00 00 00 
  8034d0:	48 8b 00             	mov    (%rax),%rax
  8034d3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	75 34                	jne    803511 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8034dd:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8034e4:	00 00 00 
  8034e7:	ff d0                	callq  *%rax
  8034e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8034ee:	48 98                	cltq   
  8034f0:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8034f7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034fe:	00 00 00 
  803501:	48 01 c2             	add    %rax,%rdx
  803504:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80350b:	00 00 00 
  80350e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803511:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803516:	75 0e                	jne    803526 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803518:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80351f:	00 00 00 
  803522:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80352a:	48 89 c7             	mov    %rax,%rdi
  80352d:	48 b8 bc 0d 80 00 00 	movabs $0x800dbc,%rax
  803534:	00 00 00 
  803537:	ff d0                	callq  *%rax
  803539:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80353c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803540:	79 19                	jns    80355b <ipc_recv+0xa9>
		*from_env_store = 0;
  803542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803546:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80354c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803550:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803559:	eb 53                	jmp    8035ae <ipc_recv+0xfc>
	}
	if(from_env_store)
  80355b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803560:	74 19                	je     80357b <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803562:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803569:	00 00 00 
  80356c:	48 8b 00             	mov    (%rax),%rax
  80356f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80357b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803580:	74 19                	je     80359b <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803582:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803589:	00 00 00 
  80358c:	48 8b 00             	mov    (%rax),%rax
  80358f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803599:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80359b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035a2:	00 00 00 
  8035a5:	48 8b 00             	mov    (%rax),%rax
  8035a8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8035ae:	c9                   	leaveq 
  8035af:	c3                   	retq   

00000000008035b0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8035b0:	55                   	push   %rbp
  8035b1:	48 89 e5             	mov    %rsp,%rbp
  8035b4:	48 83 ec 30          	sub    $0x30,%rsp
  8035b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035bb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035be:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8035c2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8035c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035ca:	75 0e                	jne    8035da <ipc_send+0x2a>
		pg = (void*)UTOP;
  8035cc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035d3:	00 00 00 
  8035d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8035da:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035dd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e7:	89 c7                	mov    %eax,%edi
  8035e9:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8035f8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8035fc:	75 0c                	jne    80360a <ipc_send+0x5a>
			sys_yield();
  8035fe:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80360a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80360e:	74 ca                	je     8035da <ipc_send+0x2a>
	if(result != 0)
  803610:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803614:	74 20                	je     803636 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803619:	89 c6                	mov    %eax,%esi
  80361b:	48 bf c8 40 80 00 00 	movabs $0x8040c8,%rdi
  803622:	00 00 00 
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
  80362a:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  803631:	00 00 00 
  803634:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803636:	c9                   	leaveq 
  803637:	c3                   	retq   

0000000000803638 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803638:	55                   	push   %rbp
  803639:	48 89 e5             	mov    %rsp,%rbp
  80363c:	53                   	push   %rbx
  80363d:	48 83 ec 58          	sub    $0x58,%rsp
  803641:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803645:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803649:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  80364d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803654:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80365b:	00 
  80365c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803660:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803664:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803668:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80366c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803670:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803674:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803678:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80367c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803680:	48 c1 e8 27          	shr    $0x27,%rax
  803684:	48 89 c2             	mov    %rax,%rdx
  803687:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80368e:	01 00 00 
  803691:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803695:	83 e0 01             	and    $0x1,%eax
  803698:	48 85 c0             	test   %rax,%rax
  80369b:	0f 85 91 00 00 00    	jne    803732 <ipc_host_recv+0xfa>
  8036a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8036a9:	48 89 c2             	mov    %rax,%rdx
  8036ac:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8036b3:	01 00 00 
  8036b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036ba:	83 e0 01             	and    $0x1,%eax
  8036bd:	48 85 c0             	test   %rax,%rax
  8036c0:	74 70                	je     803732 <ipc_host_recv+0xfa>
  8036c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c6:	48 c1 e8 15          	shr    $0x15,%rax
  8036ca:	48 89 c2             	mov    %rax,%rdx
  8036cd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036d4:	01 00 00 
  8036d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036db:	83 e0 01             	and    $0x1,%eax
  8036de:	48 85 c0             	test   %rax,%rax
  8036e1:	74 4f                	je     803732 <ipc_host_recv+0xfa>
  8036e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8036eb:	48 89 c2             	mov    %rax,%rdx
  8036ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036f5:	01 00 00 
  8036f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036fc:	83 e0 01             	and    $0x1,%eax
  8036ff:	48 85 c0             	test   %rax,%rax
  803702:	74 2e                	je     803732 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803708:	ba 07 04 00 00       	mov    $0x407,%edx
  80370d:	48 89 c6             	mov    %rax,%rsi
  803710:	bf 00 00 00 00       	mov    $0x0,%edi
  803715:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803728:	79 08                	jns    803732 <ipc_host_recv+0xfa>
	    	return result;
  80372a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80372d:	e9 84 00 00 00       	jmpq   8037b6 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803736:	48 c1 e8 0c          	shr    $0xc,%rax
  80373a:	48 89 c2             	mov    %rax,%rdx
  80373d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803744:	01 00 00 
  803747:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80374b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803751:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  803755:	b8 03 00 00 00       	mov    $0x3,%eax
  80375a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80375e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803762:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  803766:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80376a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80376e:	4c 89 c3             	mov    %r8,%rbx
  803771:	0f 01 c1             	vmcall 
  803774:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  803777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80377b:	7e 36                	jle    8037b3 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  80377d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803780:	41 89 c0             	mov    %eax,%r8d
  803783:	b9 03 00 00 00       	mov    $0x3,%ecx
  803788:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  80378f:	00 00 00 
  803792:	be 67 00 00 00       	mov    $0x67,%esi
  803797:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  80379e:	00 00 00 
  8037a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a6:	49 b9 30 27 80 00 00 	movabs $0x802730,%r9
  8037ad:	00 00 00 
  8037b0:	41 ff d1             	callq  *%r9
	return result;
  8037b3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  8037b6:	48 83 c4 58          	add    $0x58,%rsp
  8037ba:	5b                   	pop    %rbx
  8037bb:	5d                   	pop    %rbp
  8037bc:	c3                   	retq   

00000000008037bd <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8037bd:	55                   	push   %rbp
  8037be:	48 89 e5             	mov    %rsp,%rbp
  8037c1:	53                   	push   %rbx
  8037c2:	48 83 ec 68          	sub    $0x68,%rsp
  8037c6:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8037c9:	89 75 a8             	mov    %esi,-0x58(%rbp)
  8037cc:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  8037d0:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  8037d3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8037d7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  8037db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8037e2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8037e9:	00 
  8037ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8037f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8037fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803802:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803806:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80380a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80380e:	48 c1 e8 27          	shr    $0x27,%rax
  803812:	48 89 c2             	mov    %rax,%rdx
  803815:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80381c:	01 00 00 
  80381f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803823:	83 e0 01             	and    $0x1,%eax
  803826:	48 85 c0             	test   %rax,%rax
  803829:	0f 85 88 00 00 00    	jne    8038b7 <ipc_host_send+0xfa>
  80382f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803833:	48 c1 e8 1e          	shr    $0x1e,%rax
  803837:	48 89 c2             	mov    %rax,%rdx
  80383a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803841:	01 00 00 
  803844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803848:	83 e0 01             	and    $0x1,%eax
  80384b:	48 85 c0             	test   %rax,%rax
  80384e:	74 67                	je     8038b7 <ipc_host_send+0xfa>
  803850:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803854:	48 c1 e8 15          	shr    $0x15,%rax
  803858:	48 89 c2             	mov    %rax,%rdx
  80385b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803862:	01 00 00 
  803865:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803869:	83 e0 01             	and    $0x1,%eax
  80386c:	48 85 c0             	test   %rax,%rax
  80386f:	74 46                	je     8038b7 <ipc_host_send+0xfa>
  803871:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803875:	48 c1 e8 0c          	shr    $0xc,%rax
  803879:	48 89 c2             	mov    %rax,%rdx
  80387c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803883:	01 00 00 
  803886:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80388a:	83 e0 01             	and    $0x1,%eax
  80388d:	48 85 c0             	test   %rax,%rax
  803890:	74 25                	je     8038b7 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803892:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803896:	48 c1 e8 0c          	shr    $0xc,%rax
  80389a:	48 89 c2             	mov    %rax,%rdx
  80389d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038a4:	01 00 00 
  8038a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038ab:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8038b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8038b5:	eb 0e                	jmp    8038c5 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  8038b7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8038be:	00 00 00 
  8038c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  8038c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c9:	48 89 c6             	mov    %rax,%rsi
  8038cc:	48 bf 17 41 80 00 00 	movabs $0x804117,%rdi
  8038d3:	00 00 00 
  8038d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038db:	48 ba 69 29 80 00 00 	movabs $0x802969,%rdx
  8038e2:	00 00 00 
  8038e5:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  8038e7:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8038ea:	48 98                	cltq   
  8038ec:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8038f0:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8038f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8038f7:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8038fa:	48 98                	cltq   
  8038fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803900:	b8 02 00 00 00       	mov    $0x2,%eax
  803905:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803909:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80390d:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803911:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803915:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803919:	4c 89 c3             	mov    %r8,%rbx
  80391c:	0f 01 c1             	vmcall 
  80391f:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803922:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803926:	75 0c                	jne    803934 <ipc_host_send+0x177>
			sys_yield();
  803928:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803934:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803938:	74 c6                	je     803900 <ipc_host_send+0x143>
	
	if(result !=0)
  80393a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80393e:	74 36                	je     803976 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803940:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803943:	41 89 c0             	mov    %eax,%r8d
  803946:	b9 02 00 00 00       	mov    $0x2,%ecx
  80394b:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  803952:	00 00 00 
  803955:	be 94 00 00 00       	mov    $0x94,%esi
  80395a:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  803961:	00 00 00 
  803964:	b8 00 00 00 00       	mov    $0x0,%eax
  803969:	49 b9 30 27 80 00 00 	movabs $0x802730,%r9
  803970:	00 00 00 
  803973:	41 ff d1             	callq  *%r9
}
  803976:	48 83 c4 68          	add    $0x68,%rsp
  80397a:	5b                   	pop    %rbx
  80397b:	5d                   	pop    %rbp
  80397c:	c3                   	retq   

000000000080397d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 14          	sub    $0x14,%rsp
  803985:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80398f:	eb 4e                	jmp    8039df <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803991:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803998:	00 00 00 
  80399b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399e:	48 98                	cltq   
  8039a0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8039a7:	48 01 d0             	add    %rdx,%rax
  8039aa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8039b0:	8b 00                	mov    (%rax),%eax
  8039b2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039b5:	75 24                	jne    8039db <ipc_find_env+0x5e>
			return envs[i].env_id;
  8039b7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8039be:	00 00 00 
  8039c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c4:	48 98                	cltq   
  8039c6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8039cd:	48 01 d0             	add    %rdx,%rax
  8039d0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8039d6:	8b 40 08             	mov    0x8(%rax),%eax
  8039d9:	eb 12                	jmp    8039ed <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8039db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039df:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8039e6:	7e a9                	jle    803991 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8039e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ed:	c9                   	leaveq 
  8039ee:	c3                   	retq   

00000000008039ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039ef:	55                   	push   %rbp
  8039f0:	48 89 e5             	mov    %rsp,%rbp
  8039f3:	48 83 ec 18          	sub    $0x18,%rsp
  8039f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8039fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ff:	48 c1 e8 15          	shr    $0x15,%rax
  803a03:	48 89 c2             	mov    %rax,%rdx
  803a06:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a0d:	01 00 00 
  803a10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a14:	83 e0 01             	and    $0x1,%eax
  803a17:	48 85 c0             	test   %rax,%rax
  803a1a:	75 07                	jne    803a23 <pageref+0x34>
		return 0;
  803a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a21:	eb 53                	jmp    803a76 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a27:	48 c1 e8 0c          	shr    $0xc,%rax
  803a2b:	48 89 c2             	mov    %rax,%rdx
  803a2e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a35:	01 00 00 
  803a38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a44:	83 e0 01             	and    $0x1,%eax
  803a47:	48 85 c0             	test   %rax,%rax
  803a4a:	75 07                	jne    803a53 <pageref+0x64>
		return 0;
  803a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a51:	eb 23                	jmp    803a76 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a57:	48 c1 e8 0c          	shr    $0xc,%rax
  803a5b:	48 89 c2             	mov    %rax,%rdx
  803a5e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a65:	00 00 00 
  803a68:	48 c1 e2 04          	shl    $0x4,%rdx
  803a6c:	48 01 d0             	add    %rdx,%rax
  803a6f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a73:	0f b7 c0             	movzwl %ax,%eax
}
  803a76:	c9                   	leaveq 
  803a77:	c3                   	retq   
