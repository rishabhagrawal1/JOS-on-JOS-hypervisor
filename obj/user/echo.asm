
obj/user/echo:     file format elf64-x86-64


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
  80006a:	48 be 40 38 80 00 00 	movabs $0x803840,%rsi
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
  8000ab:	48 be 43 38 80 00 00 	movabs $0x803843,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
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
  80010e:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
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
  800135:	48 be 45 38 80 00 00 	movabs $0x803845,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
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
  8001d9:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
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
  800a15:	48 ba 51 38 80 00 00 	movabs $0x803851,%rdx
  800a1c:	00 00 00 
  800a1f:	be 23 00 00 00       	mov    $0x23,%esi
  800a24:	48 bf 6e 38 80 00 00 	movabs $0x80386e,%rdi
  800a2b:	00 00 00 
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	49 b9 2e 28 80 00 00 	movabs $0x80282e,%r9
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

0000000000800ee3 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  800ee3:	55                   	push   %rbp
  800ee4:	48 89 e5             	mov    %rsp,%rbp
  800ee7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  800eeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ef2:	00 
  800ef3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ef9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800eff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f04:	ba 00 00 00 00       	mov    $0x0,%edx
  800f09:	be 00 00 00 00       	mov    $0x0,%esi
  800f0e:	bf 11 00 00 00       	mov    $0x11,%edi
  800f13:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  800f1f:	c9                   	leaveq 
  800f20:	c3                   	retq   

0000000000800f21 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  800f21:	55                   	push   %rbp
  800f22:	48 89 e5             	mov    %rsp,%rbp
  800f25:	48 83 ec 10          	sub    $0x10,%rsp
  800f29:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  800f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2f:	48 98                	cltq   
  800f31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800f38:	00 
  800f39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800f3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800f45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4a:	48 89 c2             	mov    %rax,%rdx
  800f4d:	be 00 00 00 00       	mov    $0x0,%esi
  800f52:	bf 12 00 00 00       	mov    $0x12,%edi
  800f57:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800f5e:	00 00 00 
  800f61:	ff d0                	callq  *%rax
}
  800f63:	c9                   	leaveq 
  800f64:	c3                   	retq   

0000000000800f65 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  800f65:	55                   	push   %rbp
  800f66:	48 89 e5             	mov    %rsp,%rbp
  800f69:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  800f6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800f74:	00 
  800f75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800f7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800f81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f86:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8b:	be 00 00 00 00       	mov    $0x0,%esi
  800f90:	bf 13 00 00 00       	mov    $0x13,%edi
  800f95:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800f9c:	00 00 00 
  800f9f:	ff d0                	callq  *%rax
}
  800fa1:	c9                   	leaveq 
  800fa2:	c3                   	retq   

0000000000800fa3 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  800fa3:	55                   	push   %rbp
  800fa4:	48 89 e5             	mov    %rsp,%rbp
  800fa7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  800fab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800fb2:	00 
  800fb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800fb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800fbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc9:	be 00 00 00 00       	mov    $0x0,%esi
  800fce:	bf 14 00 00 00       	mov    $0x14,%edi
  800fd3:	48 b8 bd 09 80 00 00 	movabs $0x8009bd,%rax
  800fda:	00 00 00 
  800fdd:	ff d0                	callq  *%rax
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 08          	sub    $0x8,%rsp
  800fe9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ff1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800ff8:	ff ff ff 
  800ffb:	48 01 d0             	add    %rdx,%rax
  800ffe:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801002:	c9                   	leaveq 
  801003:	c3                   	retq   

0000000000801004 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801004:	55                   	push   %rbp
  801005:	48 89 e5             	mov    %rsp,%rbp
  801008:	48 83 ec 08          	sub    $0x8,%rsp
  80100c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801014:	48 89 c7             	mov    %rax,%rdi
  801017:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  80101e:	00 00 00 
  801021:	ff d0                	callq  *%rax
  801023:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801029:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 18          	sub    $0x18,%rsp
  801037:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80103b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801042:	eb 6b                	jmp    8010af <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801047:	48 98                	cltq   
  801049:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80104f:	48 c1 e0 0c          	shl    $0xc,%rax
  801053:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105b:	48 c1 e8 15          	shr    $0x15,%rax
  80105f:	48 89 c2             	mov    %rax,%rdx
  801062:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801069:	01 00 00 
  80106c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801070:	83 e0 01             	and    $0x1,%eax
  801073:	48 85 c0             	test   %rax,%rax
  801076:	74 21                	je     801099 <fd_alloc+0x6a>
  801078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107c:	48 c1 e8 0c          	shr    $0xc,%rax
  801080:	48 89 c2             	mov    %rax,%rdx
  801083:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80108a:	01 00 00 
  80108d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801091:	83 e0 01             	and    $0x1,%eax
  801094:	48 85 c0             	test   %rax,%rax
  801097:	75 12                	jne    8010ab <fd_alloc+0x7c>
			*fd_store = fd;
  801099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010a1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a9:	eb 1a                	jmp    8010c5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010af:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8010b3:	7e 8f                	jle    801044 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8010c0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 20          	sub    $0x20,%rsp
  8010cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8010d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8010da:	78 06                	js     8010e2 <fd_lookup+0x1b>
  8010dc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8010e0:	7e 07                	jle    8010e9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e7:	eb 6c                	jmp    801155 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8010e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8010ec:	48 98                	cltq   
  8010ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8010f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8010f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801100:	48 c1 e8 15          	shr    $0x15,%rax
  801104:	48 89 c2             	mov    %rax,%rdx
  801107:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80110e:	01 00 00 
  801111:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801115:	83 e0 01             	and    $0x1,%eax
  801118:	48 85 c0             	test   %rax,%rax
  80111b:	74 21                	je     80113e <fd_lookup+0x77>
  80111d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801121:	48 c1 e8 0c          	shr    $0xc,%rax
  801125:	48 89 c2             	mov    %rax,%rdx
  801128:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80112f:	01 00 00 
  801132:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801136:	83 e0 01             	and    $0x1,%eax
  801139:	48 85 c0             	test   %rax,%rax
  80113c:	75 07                	jne    801145 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801143:	eb 10                	jmp    801155 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801145:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801149:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80114d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801155:	c9                   	leaveq 
  801156:	c3                   	retq   

0000000000801157 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801157:	55                   	push   %rbp
  801158:	48 89 e5             	mov    %rsp,%rbp
  80115b:	48 83 ec 30          	sub    $0x30,%rsp
  80115f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801163:	89 f0                	mov    %esi,%eax
  801165:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116c:	48 89 c7             	mov    %rax,%rdi
  80116f:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  801176:	00 00 00 
  801179:	ff d0                	callq  *%rax
  80117b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80117f:	48 89 d6             	mov    %rdx,%rsi
  801182:	89 c7                	mov    %eax,%edi
  801184:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  80118b:	00 00 00 
  80118e:	ff d0                	callq  *%rax
  801190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801197:	78 0a                	js     8011a3 <fd_close+0x4c>
	    || fd != fd2)
  801199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8011a1:	74 12                	je     8011b5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8011a3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8011a7:	74 05                	je     8011ae <fd_close+0x57>
  8011a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ac:	eb 05                	jmp    8011b3 <fd_close+0x5c>
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b3:	eb 69                	jmp    80121e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b9:	8b 00                	mov    (%rax),%eax
  8011bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8011bf:	48 89 d6             	mov    %rdx,%rsi
  8011c2:	89 c7                	mov    %eax,%edi
  8011c4:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8011cb:	00 00 00 
  8011ce:	ff d0                	callq  *%rax
  8011d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011d7:	78 2a                	js     801203 <fd_close+0xac>
		if (dev->dev_close)
  8011d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011dd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8011e1:	48 85 c0             	test   %rax,%rax
  8011e4:	74 16                	je     8011fc <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 8b 40 20          	mov    0x20(%rax),%rax
  8011ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011f2:	48 89 d7             	mov    %rdx,%rdi
  8011f5:	ff d0                	callq  *%rax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011fa:	eb 07                	jmp    801203 <fd_close+0xac>
		else
			r = 0;
  8011fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801203:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801207:	48 89 c6             	mov    %rax,%rsi
  80120a:	bf 00 00 00 00       	mov    $0x0,%edi
  80120f:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  801216:	00 00 00 
  801219:	ff d0                	callq  *%rax
	return r;
  80121b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80121e:	c9                   	leaveq 
  80121f:	c3                   	retq   

0000000000801220 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801220:	55                   	push   %rbp
  801221:	48 89 e5             	mov    %rsp,%rbp
  801224:	48 83 ec 20          	sub    $0x20,%rsp
  801228:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80122b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801236:	eb 41                	jmp    801279 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801238:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80123f:	00 00 00 
  801242:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801245:	48 63 d2             	movslq %edx,%rdx
  801248:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80124c:	8b 00                	mov    (%rax),%eax
  80124e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801251:	75 22                	jne    801275 <dev_lookup+0x55>
			*dev = devtab[i];
  801253:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80125a:	00 00 00 
  80125d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801260:	48 63 d2             	movslq %edx,%rdx
  801263:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801267:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	eb 60                	jmp    8012d5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801275:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801279:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801280:	00 00 00 
  801283:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801286:	48 63 d2             	movslq %edx,%rdx
  801289:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80128d:	48 85 c0             	test   %rax,%rax
  801290:	75 a6                	jne    801238 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801292:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801299:	00 00 00 
  80129c:	48 8b 00             	mov    (%rax),%rax
  80129f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8012a5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8012a8:	89 c6                	mov    %eax,%esi
  8012aa:	48 bf 80 38 80 00 00 	movabs $0x803880,%rdi
  8012b1:	00 00 00 
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	48 b9 67 2a 80 00 00 	movabs $0x802a67,%rcx
  8012c0:	00 00 00 
  8012c3:	ff d1                	callq  *%rcx
	*dev = 0;
  8012c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8012d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d5:	c9                   	leaveq 
  8012d6:	c3                   	retq   

00000000008012d7 <close>:

int
close(int fdnum)
{
  8012d7:	55                   	push   %rbp
  8012d8:	48 89 e5             	mov    %rsp,%rbp
  8012db:	48 83 ec 20          	sub    $0x20,%rsp
  8012df:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8012e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8012e9:	48 89 d6             	mov    %rdx,%rsi
  8012ec:	89 c7                	mov    %eax,%edi
  8012ee:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	callq  *%rax
  8012fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801301:	79 05                	jns    801308 <close+0x31>
		return r;
  801303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801306:	eb 18                	jmp    801320 <close+0x49>
	else
		return fd_close(fd, 1);
  801308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130c:	be 01 00 00 00       	mov    $0x1,%esi
  801311:	48 89 c7             	mov    %rax,%rdi
  801314:	48 b8 57 11 80 00 00 	movabs $0x801157,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <close_all>:

void
close_all(void)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801331:	eb 15                	jmp    801348 <close_all+0x26>
		close(i);
  801333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801336:	89 c7                	mov    %eax,%edi
  801338:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  80133f:	00 00 00 
  801342:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801344:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801348:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80134c:	7e e5                	jle    801333 <close_all+0x11>
		close(i);
}
  80134e:	c9                   	leaveq 
  80134f:	c3                   	retq   

0000000000801350 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801350:	55                   	push   %rbp
  801351:	48 89 e5             	mov    %rsp,%rbp
  801354:	48 83 ec 40          	sub    $0x40,%rsp
  801358:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80135b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80135e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801362:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801365:	48 89 d6             	mov    %rdx,%rsi
  801368:	89 c7                	mov    %eax,%edi
  80136a:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
  801376:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80137d:	79 08                	jns    801387 <dup+0x37>
		return r;
  80137f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801382:	e9 70 01 00 00       	jmpq   8014f7 <dup+0x1a7>
	close(newfdnum);
  801387:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80138a:	89 c7                	mov    %eax,%edi
  80138c:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801398:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80139b:	48 98                	cltq   
  80139d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8013a3:	48 c1 e0 0c          	shl    $0xc,%rax
  8013a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	48 89 c7             	mov    %rax,%rdi
  8013b2:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8013b9:	00 00 00 
  8013bc:	ff d0                	callq  *%rax
  8013be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8013c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c6:	48 89 c7             	mov    %rax,%rdi
  8013c9:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8013d0:	00 00 00 
  8013d3:	ff d0                	callq  *%rax
  8013d5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dd:	48 c1 e8 15          	shr    $0x15,%rax
  8013e1:	48 89 c2             	mov    %rax,%rdx
  8013e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8013eb:	01 00 00 
  8013ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8013f2:	83 e0 01             	and    $0x1,%eax
  8013f5:	48 85 c0             	test   %rax,%rax
  8013f8:	74 73                	je     80146d <dup+0x11d>
  8013fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fe:	48 c1 e8 0c          	shr    $0xc,%rax
  801402:	48 89 c2             	mov    %rax,%rdx
  801405:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80140c:	01 00 00 
  80140f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801413:	83 e0 01             	and    $0x1,%eax
  801416:	48 85 c0             	test   %rax,%rax
  801419:	74 52                	je     80146d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80141b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141f:	48 c1 e8 0c          	shr    $0xc,%rax
  801423:	48 89 c2             	mov    %rax,%rdx
  801426:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80142d:	01 00 00 
  801430:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801434:	25 07 0e 00 00       	and    $0xe07,%eax
  801439:	89 c1                	mov    %eax,%ecx
  80143b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801443:	41 89 c8             	mov    %ecx,%r8d
  801446:	48 89 d1             	mov    %rdx,%rcx
  801449:	ba 00 00 00 00       	mov    $0x0,%edx
  80144e:	48 89 c6             	mov    %rax,%rsi
  801451:	bf 00 00 00 00       	mov    $0x0,%edi
  801456:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  80145d:	00 00 00 
  801460:	ff d0                	callq  *%rax
  801462:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801465:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801469:	79 02                	jns    80146d <dup+0x11d>
			goto err;
  80146b:	eb 57                	jmp    8014c4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 c1 e8 0c          	shr    $0xc,%rax
  801475:	48 89 c2             	mov    %rax,%rdx
  801478:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80147f:	01 00 00 
  801482:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801486:	25 07 0e 00 00       	and    $0xe07,%eax
  80148b:	89 c1                	mov    %eax,%ecx
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801495:	41 89 c8             	mov    %ecx,%r8d
  801498:	48 89 d1             	mov    %rdx,%rcx
  80149b:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a0:	48 89 c6             	mov    %rax,%rsi
  8014a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8014a8:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  8014af:	00 00 00 
  8014b2:	ff d0                	callq  *%rax
  8014b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014bb:	79 02                	jns    8014bf <dup+0x16f>
		goto err;
  8014bd:	eb 05                	jmp    8014c4 <dup+0x174>

	return newfdnum;
  8014bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8014c2:	eb 33                	jmp    8014f7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8014c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c8:	48 89 c6             	mov    %rax,%rsi
  8014cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8014d0:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  8014d7:	00 00 00 
  8014da:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8014dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e0:	48 89 c6             	mov    %rax,%rsi
  8014e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e8:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	callq  *%rax
	return r;
  8014f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014f7:	c9                   	leaveq 
  8014f8:	c3                   	retq   

00000000008014f9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014f9:	55                   	push   %rbp
  8014fa:	48 89 e5             	mov    %rsp,%rbp
  8014fd:	48 83 ec 40          	sub    $0x40,%rsp
  801501:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801504:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801508:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801510:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801513:	48 89 d6             	mov    %rdx,%rsi
  801516:	89 c7                	mov    %eax,%edi
  801518:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  80151f:	00 00 00 
  801522:	ff d0                	callq  *%rax
  801524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80152b:	78 24                	js     801551 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801531:	8b 00                	mov    (%rax),%eax
  801533:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801537:	48 89 d6             	mov    %rdx,%rsi
  80153a:	89 c7                	mov    %eax,%edi
  80153c:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  801543:	00 00 00 
  801546:	ff d0                	callq  *%rax
  801548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80154b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80154f:	79 05                	jns    801556 <read+0x5d>
		return r;
  801551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801554:	eb 76                	jmp    8015cc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155a:	8b 40 08             	mov    0x8(%rax),%eax
  80155d:	83 e0 03             	and    $0x3,%eax
  801560:	83 f8 01             	cmp    $0x1,%eax
  801563:	75 3a                	jne    80159f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801565:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80156c:	00 00 00 
  80156f:	48 8b 00             	mov    (%rax),%rax
  801572:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801578:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80157b:	89 c6                	mov    %eax,%esi
  80157d:	48 bf 9f 38 80 00 00 	movabs $0x80389f,%rdi
  801584:	00 00 00 
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	48 b9 67 2a 80 00 00 	movabs $0x802a67,%rcx
  801593:	00 00 00 
  801596:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801598:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159d:	eb 2d                	jmp    8015cc <read+0xd3>
	}
	if (!dev->dev_read)
  80159f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8015a7:	48 85 c0             	test   %rax,%rax
  8015aa:	75 07                	jne    8015b3 <read+0xba>
		return -E_NOT_SUPP;
  8015ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8015b1:	eb 19                	jmp    8015cc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8015b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8015bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015c3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8015c7:	48 89 cf             	mov    %rcx,%rdi
  8015ca:	ff d0                	callq  *%rax
}
  8015cc:	c9                   	leaveq 
  8015cd:	c3                   	retq   

00000000008015ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 30          	sub    $0x30,%rsp
  8015d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8015d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8015e8:	eb 49                	jmp    801633 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ed:	48 98                	cltq   
  8015ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015f3:	48 29 c2             	sub    %rax,%rdx
  8015f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f9:	48 63 c8             	movslq %eax,%rcx
  8015fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801600:	48 01 c1             	add    %rax,%rcx
  801603:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801606:	48 89 ce             	mov    %rcx,%rsi
  801609:	89 c7                	mov    %eax,%edi
  80160b:	48 b8 f9 14 80 00 00 	movabs $0x8014f9,%rax
  801612:	00 00 00 
  801615:	ff d0                	callq  *%rax
  801617:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80161a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80161e:	79 05                	jns    801625 <readn+0x57>
			return m;
  801620:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801623:	eb 1c                	jmp    801641 <readn+0x73>
		if (m == 0)
  801625:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801629:	75 02                	jne    80162d <readn+0x5f>
			break;
  80162b:	eb 11                	jmp    80163e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80162d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801630:	01 45 fc             	add    %eax,-0x4(%rbp)
  801633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801636:	48 98                	cltq   
  801638:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80163c:	72 ac                	jb     8015ea <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80163e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 40          	sub    $0x40,%rsp
  80164b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80164e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801652:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801656:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80165a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80165d:	48 89 d6             	mov    %rdx,%rsi
  801660:	89 c7                	mov    %eax,%edi
  801662:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  801669:	00 00 00 
  80166c:	ff d0                	callq  *%rax
  80166e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801675:	78 24                	js     80169b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167b:	8b 00                	mov    (%rax),%eax
  80167d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801681:	48 89 d6             	mov    %rdx,%rsi
  801684:	89 c7                	mov    %eax,%edi
  801686:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80168d:	00 00 00 
  801690:	ff d0                	callq  *%rax
  801692:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801695:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801699:	79 05                	jns    8016a0 <write+0x5d>
		return r;
  80169b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80169e:	eb 42                	jmp    8016e2 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a4:	8b 40 08             	mov    0x8(%rax),%eax
  8016a7:	83 e0 03             	and    $0x3,%eax
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	75 07                	jne    8016b5 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b3:	eb 2d                	jmp    8016e2 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8016bd:	48 85 c0             	test   %rax,%rax
  8016c0:	75 07                	jne    8016c9 <write+0x86>
		return -E_NOT_SUPP;
  8016c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016c7:	eb 19                	jmp    8016e2 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8016c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8016d1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8016d9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8016dd:	48 89 cf             	mov    %rcx,%rdi
  8016e0:	ff d0                	callq  *%rax
}
  8016e2:	c9                   	leaveq 
  8016e3:	c3                   	retq   

00000000008016e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	48 83 ec 18          	sub    $0x18,%rsp
  8016ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8016ef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f9:	48 89 d6             	mov    %rdx,%rsi
  8016fc:	89 c7                	mov    %eax,%edi
  8016fe:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  801705:	00 00 00 
  801708:	ff d0                	callq  *%rax
  80170a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80170d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801711:	79 05                	jns    801718 <seek+0x34>
		return r;
  801713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801716:	eb 0f                	jmp    801727 <seek+0x43>
	fd->fd_offset = offset;
  801718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80171f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801727:	c9                   	leaveq 
  801728:	c3                   	retq   

0000000000801729 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801729:	55                   	push   %rbp
  80172a:	48 89 e5             	mov    %rsp,%rbp
  80172d:	48 83 ec 30          	sub    $0x30,%rsp
  801731:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801734:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801737:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80173b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80173e:	48 89 d6             	mov    %rdx,%rsi
  801741:	89 c7                	mov    %eax,%edi
  801743:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  80174a:	00 00 00 
  80174d:	ff d0                	callq  *%rax
  80174f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801752:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801756:	78 24                	js     80177c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175c:	8b 00                	mov    (%rax),%eax
  80175e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801762:	48 89 d6             	mov    %rdx,%rsi
  801765:	89 c7                	mov    %eax,%edi
  801767:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
  801773:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801776:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80177a:	79 05                	jns    801781 <ftruncate+0x58>
		return r;
  80177c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80177f:	eb 72                	jmp    8017f3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801785:	8b 40 08             	mov    0x8(%rax),%eax
  801788:	83 e0 03             	and    $0x3,%eax
  80178b:	85 c0                	test   %eax,%eax
  80178d:	75 3a                	jne    8017c9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80178f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801796:	00 00 00 
  801799:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80179c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8017a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8017a5:	89 c6                	mov    %eax,%esi
  8017a7:	48 bf c0 38 80 00 00 	movabs $0x8038c0,%rdi
  8017ae:	00 00 00 
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	48 b9 67 2a 80 00 00 	movabs $0x802a67,%rcx
  8017bd:	00 00 00 
  8017c0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c7:	eb 2a                	jmp    8017f3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8017d1:	48 85 c0             	test   %rax,%rax
  8017d4:	75 07                	jne    8017dd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8017d6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017db:	eb 16                	jmp    8017f3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8017dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8017e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8017ec:	89 ce                	mov    %ecx,%esi
  8017ee:	48 89 d7             	mov    %rdx,%rdi
  8017f1:	ff d0                	callq  *%rax
}
  8017f3:	c9                   	leaveq 
  8017f4:	c3                   	retq   

00000000008017f5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
  8017f9:	48 83 ec 30          	sub    $0x30,%rsp
  8017fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801800:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801804:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801808:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80180b:	48 89 d6             	mov    %rdx,%rsi
  80180e:	89 c7                	mov    %eax,%edi
  801810:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  801817:	00 00 00 
  80181a:	ff d0                	callq  *%rax
  80181c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80181f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801823:	78 24                	js     801849 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801829:	8b 00                	mov    (%rax),%eax
  80182b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80182f:	48 89 d6             	mov    %rdx,%rsi
  801832:	89 c7                	mov    %eax,%edi
  801834:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80183b:	00 00 00 
  80183e:	ff d0                	callq  *%rax
  801840:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801843:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801847:	79 05                	jns    80184e <fstat+0x59>
		return r;
  801849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184c:	eb 5e                	jmp    8018ac <fstat+0xb7>
	if (!dev->dev_stat)
  80184e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801852:	48 8b 40 28          	mov    0x28(%rax),%rax
  801856:	48 85 c0             	test   %rax,%rax
  801859:	75 07                	jne    801862 <fstat+0x6d>
		return -E_NOT_SUPP;
  80185b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801860:	eb 4a                	jmp    8018ac <fstat+0xb7>
	stat->st_name[0] = 0;
  801862:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801866:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  801869:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801874:	00 00 00 
	stat->st_isdir = 0;
  801877:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801882:	00 00 00 
	stat->st_dev = dev;
  801885:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801889:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80188d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  801894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801898:	48 8b 40 28          	mov    0x28(%rax),%rax
  80189c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018a4:	48 89 ce             	mov    %rcx,%rsi
  8018a7:	48 89 d7             	mov    %rdx,%rdi
  8018aa:	ff d0                	callq  *%rax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c2:	be 00 00 00 00       	mov    $0x0,%esi
  8018c7:	48 89 c7             	mov    %rax,%rdi
  8018ca:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  8018d1:	00 00 00 
  8018d4:	ff d0                	callq  *%rax
  8018d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018dd:	79 05                	jns    8018e4 <stat+0x36>
		return fd;
  8018df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e2:	eb 2f                	jmp    801913 <stat+0x65>
	r = fstat(fd, stat);
  8018e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018eb:	48 89 d6             	mov    %rdx,%rsi
  8018ee:	89 c7                	mov    %eax,%edi
  8018f0:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  8018f7:	00 00 00 
  8018fa:	ff d0                	callq  *%rax
  8018fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8018ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801902:	89 c7                	mov    %eax,%edi
  801904:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	callq  *%rax
	return r;
  801910:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 10          	sub    $0x10,%rsp
  80191d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801920:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801924:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80192b:	00 00 00 
  80192e:	8b 00                	mov    (%rax),%eax
  801930:	85 c0                	test   %eax,%eax
  801932:	75 1d                	jne    801951 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801934:	bf 01 00 00 00       	mov    $0x1,%edi
  801939:	48 b8 36 37 80 00 00 	movabs $0x803736,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
  801945:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80194c:	00 00 00 
  80194f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801951:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801958:	00 00 00 
  80195b:	8b 00                	mov    (%rax),%eax
  80195d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801960:	b9 07 00 00 00       	mov    $0x7,%ecx
  801965:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80196c:	00 00 00 
  80196f:	89 c7                	mov    %eax,%edi
  801971:	48 b8 ae 36 80 00 00 	movabs $0x8036ae,%rax
  801978:	00 00 00 
  80197b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80197d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801981:	ba 00 00 00 00       	mov    $0x0,%edx
  801986:	48 89 c6             	mov    %rax,%rsi
  801989:	bf 00 00 00 00       	mov    $0x0,%edi
  80198e:	48 b8 b0 35 80 00 00 	movabs $0x8035b0,%rax
  801995:	00 00 00 
  801998:	ff d0                	callq  *%rax
}
  80199a:	c9                   	leaveq 
  80199b:	c3                   	retq   

000000000080199c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	48 83 ec 30          	sub    $0x30,%rsp
  8019a4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a8:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8019ab:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8019b2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8019b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8019c0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019c5:	75 08                	jne    8019cf <open+0x33>
	{
		return r;
  8019c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ca:	e9 f2 00 00 00       	jmpq   801ac1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	48 89 c7             	mov    %rax,%rdi
  8019d6:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
  8019e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8019e5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8019ec:	7e 0a                	jle    8019f8 <open+0x5c>
	{
		return -E_BAD_PATH;
  8019ee:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8019f3:	e9 c9 00 00 00       	jmpq   801ac1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8019f8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8019ff:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801a00:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801a04:	48 89 c7             	mov    %rax,%rdi
  801a07:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	callq  *%rax
  801a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a1a:	78 09                	js     801a25 <open+0x89>
  801a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a20:	48 85 c0             	test   %rax,%rax
  801a23:	75 08                	jne    801a2d <open+0x91>
		{
			return r;
  801a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a28:	e9 94 00 00 00       	jmpq   801ac1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	ba 00 04 00 00       	mov    $0x400,%edx
  801a36:	48 89 c6             	mov    %rax,%rsi
  801a39:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801a40:	00 00 00 
  801a43:	48 b8 f6 02 80 00 00 	movabs $0x8002f6,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801a4f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a56:	00 00 00 
  801a59:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801a5c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a66:	48 89 c6             	mov    %rax,%rsi
  801a69:	bf 01 00 00 00       	mov    $0x1,%edi
  801a6e:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	callq  *%rax
  801a7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a81:	79 2b                	jns    801aae <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a87:	be 00 00 00 00       	mov    $0x0,%esi
  801a8c:	48 89 c7             	mov    %rax,%rdi
  801a8f:	48 b8 57 11 80 00 00 	movabs $0x801157,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801aa2:	79 05                	jns    801aa9 <open+0x10d>
			{
				return d;
  801aa4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa7:	eb 18                	jmp    801ac1 <open+0x125>
			}
			return r;
  801aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aac:	eb 13                	jmp    801ac1 <open+0x125>
		}	
		return fd2num(fd_store);
  801aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab2:	48 89 c7             	mov    %rax,%rdi
  801ab5:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 10          	sub    $0x10,%rsp
  801acb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801acf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad3:	8b 50 0c             	mov    0xc(%rax),%edx
  801ad6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801add:	00 00 00 
  801ae0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801ae2:	be 00 00 00 00       	mov    $0x0,%esi
  801ae7:	bf 06 00 00 00       	mov    $0x6,%edi
  801aec:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 30          	sub    $0x30,%rsp
  801b02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b0a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801b0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801b15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b1a:	74 07                	je     801b23 <devfile_read+0x29>
  801b1c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b21:	75 07                	jne    801b2a <devfile_read+0x30>
		return -E_INVAL;
  801b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b28:	eb 77                	jmp    801ba1 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2e:	8b 50 0c             	mov    0xc(%rax),%edx
  801b31:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b38:	00 00 00 
  801b3b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801b3d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b44:	00 00 00 
  801b47:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b4b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801b4f:	be 00 00 00 00       	mov    $0x0,%esi
  801b54:	bf 03 00 00 00       	mov    $0x3,%edi
  801b59:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
  801b65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6c:	7f 05                	jg     801b73 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b71:	eb 2e                	jmp    801ba1 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b76:	48 63 d0             	movslq %eax,%rdx
  801b79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b7d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801b84:	00 00 00 
  801b87:	48 89 c7             	mov    %rax,%rdi
  801b8a:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801b96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 30          	sub    $0x30,%rsp
  801bab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801baf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801bb7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801bbe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc3:	74 07                	je     801bcc <devfile_write+0x29>
  801bc5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801bca:	75 08                	jne    801bd4 <devfile_write+0x31>
		return r;
  801bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcf:	e9 9a 00 00 00       	jmpq   801c6e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd8:	8b 50 0c             	mov    0xc(%rax),%edx
  801bdb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801be2:	00 00 00 
  801be5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801be7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801bee:	00 
  801bef:	76 08                	jbe    801bf9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801bf1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801bf8:	00 
	}
	fsipcbuf.write.req_n = n;
  801bf9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c00:	00 00 00 
  801c03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c07:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801c0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c13:	48 89 c6             	mov    %rax,%rsi
  801c16:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801c1d:	00 00 00 
  801c20:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801c2c:	be 00 00 00 00       	mov    $0x0,%esi
  801c31:	bf 04 00 00 00       	mov    $0x4,%edi
  801c36:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801c3d:	00 00 00 
  801c40:	ff d0                	callq  *%rax
  801c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c49:	7f 20                	jg     801c6b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801c4b:	48 bf e6 38 80 00 00 	movabs $0x8038e6,%rdi
  801c52:	00 00 00 
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  801c61:	00 00 00 
  801c64:	ff d2                	callq  *%rdx
		return r;
  801c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c69:	eb 03                	jmp    801c6e <devfile_write+0xcb>
	}
	return r;
  801c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 20          	sub    $0x20,%rsp
  801c78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c84:	8b 50 0c             	mov    0xc(%rax),%edx
  801c87:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c8e:	00 00 00 
  801c91:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c93:	be 00 00 00 00       	mov    $0x0,%esi
  801c98:	bf 05 00 00 00       	mov    $0x5,%edi
  801c9d:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
  801ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cb0:	79 05                	jns    801cb7 <devfile_stat+0x47>
		return r;
  801cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb5:	eb 56                	jmp    801d0d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cbb:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801cc2:	00 00 00 
  801cc5:	48 89 c7             	mov    %rax,%rdi
  801cc8:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801cd4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801cdb:	00 00 00 
  801cde:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801ce4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ce8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801cf5:	00 00 00 
  801cf8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801cfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d02:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	48 83 ec 10          	sub    $0x10,%rsp
  801d17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d22:	8b 50 0c             	mov    0xc(%rax),%edx
  801d25:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d2c:	00 00 00 
  801d2f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801d31:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d38:	00 00 00 
  801d3b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d3e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d41:	be 00 00 00 00       	mov    $0x0,%esi
  801d46:	bf 02 00 00 00       	mov    $0x2,%edi
  801d4b:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801d52:	00 00 00 
  801d55:	ff d0                	callq  *%rax
}
  801d57:	c9                   	leaveq 
  801d58:	c3                   	retq   

0000000000801d59 <remove>:

// Delete a file
int
remove(const char *path)
{
  801d59:	55                   	push   %rbp
  801d5a:	48 89 e5             	mov    %rsp,%rbp
  801d5d:	48 83 ec 10          	sub    $0x10,%rsp
  801d61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801d65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d69:	48 89 c7             	mov    %rax,%rdi
  801d6c:	48 b8 f8 01 80 00 00 	movabs $0x8001f8,%rax
  801d73:	00 00 00 
  801d76:	ff d0                	callq  *%rax
  801d78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d7d:	7e 07                	jle    801d86 <remove+0x2d>
		return -E_BAD_PATH;
  801d7f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801d84:	eb 33                	jmp    801db9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8a:	48 89 c6             	mov    %rax,%rsi
  801d8d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801d94:	00 00 00 
  801d97:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801d9e:	00 00 00 
  801da1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801da3:	be 00 00 00 00       	mov    $0x0,%esi
  801da8:	bf 07 00 00 00       	mov    $0x7,%edi
  801dad:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801db4:	00 00 00 
  801db7:	ff d0                	callq  *%rax
}
  801db9:	c9                   	leaveq 
  801dba:	c3                   	retq   

0000000000801dbb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801dbb:	55                   	push   %rbp
  801dbc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	bf 08 00 00 00       	mov    $0x8,%edi
  801dc9:	48 b8 15 19 80 00 00 	movabs $0x801915,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
}
  801dd5:	5d                   	pop    %rbp
  801dd6:	c3                   	retq   

0000000000801dd7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801de2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801de9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801df0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801df7:	be 00 00 00 00       	mov    $0x0,%esi
  801dfc:	48 89 c7             	mov    %rax,%rdi
  801dff:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	callq  *%rax
  801e0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801e0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e12:	79 28                	jns    801e3c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801e14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e17:	89 c6                	mov    %eax,%esi
  801e19:	48 bf 02 39 80 00 00 	movabs $0x803902,%rdi
  801e20:	00 00 00 
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  801e2f:	00 00 00 
  801e32:	ff d2                	callq  *%rdx
		return fd_src;
  801e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e37:	e9 74 01 00 00       	jmpq   801fb0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801e3c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801e43:	be 01 01 00 00       	mov    $0x101,%esi
  801e48:	48 89 c7             	mov    %rax,%rdi
  801e4b:	48 b8 9c 19 80 00 00 	movabs $0x80199c,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	callq  *%rax
  801e57:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801e5a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e5e:	79 39                	jns    801e99 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801e60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e63:	89 c6                	mov    %eax,%esi
  801e65:	48 bf 18 39 80 00 00 	movabs $0x803918,%rdi
  801e6c:	00 00 00 
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e74:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  801e7b:	00 00 00 
  801e7e:	ff d2                	callq  *%rdx
		close(fd_src);
  801e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e83:	89 c7                	mov    %eax,%edi
  801e85:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801e8c:	00 00 00 
  801e8f:	ff d0                	callq  *%rax
		return fd_dest;
  801e91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e94:	e9 17 01 00 00       	jmpq   801fb0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801e99:	eb 74                	jmp    801f0f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801e9b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e9e:	48 63 d0             	movslq %eax,%rdx
  801ea1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801ea8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eab:	48 89 ce             	mov    %rcx,%rsi
  801eae:	89 c7                	mov    %eax,%edi
  801eb0:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
  801ebc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ec3:	79 4a                	jns    801f0f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801ec5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ec8:	89 c6                	mov    %eax,%esi
  801eca:	48 bf 32 39 80 00 00 	movabs $0x803932,%rdi
  801ed1:	00 00 00 
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  801ee0:	00 00 00 
  801ee3:	ff d2                	callq  *%rdx
			close(fd_src);
  801ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee8:	89 c7                	mov    %eax,%edi
  801eea:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801ef1:	00 00 00 
  801ef4:	ff d0                	callq  *%rax
			close(fd_dest);
  801ef6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef9:	89 c7                	mov    %eax,%edi
  801efb:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
			return write_size;
  801f07:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f0a:	e9 a1 00 00 00       	jmpq   801fb0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801f0f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f19:	ba 00 02 00 00       	mov    $0x200,%edx
  801f1e:	48 89 ce             	mov    %rcx,%rsi
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	48 b8 f9 14 80 00 00 	movabs $0x8014f9,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
  801f2f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f36:	0f 8f 5f ff ff ff    	jg     801e9b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f40:	79 47                	jns    801f89 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801f42:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f45:	89 c6                	mov    %eax,%esi
  801f47:	48 bf 45 39 80 00 00 	movabs $0x803945,%rdi
  801f4e:	00 00 00 
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  801f5d:	00 00 00 
  801f60:	ff d2                	callq  *%rdx
		close(fd_src);
  801f62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f65:	89 c7                	mov    %eax,%edi
  801f67:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
		close(fd_dest);
  801f73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f76:	89 c7                	mov    %eax,%edi
  801f78:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
		return read_size;
  801f84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f87:	eb 27                	jmp    801fb0 <copy+0x1d9>
	}
	close(fd_src);
  801f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8c:	89 c7                	mov    %eax,%edi
  801f8e:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
	close(fd_dest);
  801f9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f9d:	89 c7                	mov    %eax,%edi
  801f9f:	48 b8 d7 12 80 00 00 	movabs $0x8012d7,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
	return 0;
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801fb0:	c9                   	leaveq 
  801fb1:	c3                   	retq   

0000000000801fb2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801fb2:	55                   	push   %rbp
  801fb3:	48 89 e5             	mov    %rsp,%rbp
  801fb6:	53                   	push   %rbx
  801fb7:	48 83 ec 38          	sub    $0x38,%rsp
  801fbb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fbf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801fc3:	48 89 c7             	mov    %rax,%rdi
  801fc6:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
  801fd2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fd9:	0f 88 bf 01 00 00    	js     80219e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe3:	ba 07 04 00 00       	mov    $0x407,%edx
  801fe8:	48 89 c6             	mov    %rax,%rsi
  801feb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff0:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
  801ffc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802003:	0f 88 95 01 00 00    	js     80219e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802009:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80200d:	48 89 c7             	mov    %rax,%rdi
  802010:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  802017:	00 00 00 
  80201a:	ff d0                	callq  *%rax
  80201c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80201f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802023:	0f 88 5d 01 00 00    	js     802186 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802029:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80202d:	ba 07 04 00 00       	mov    $0x407,%edx
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 00 00 00       	mov    $0x0,%edi
  80203a:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
  802046:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802049:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80204d:	0f 88 33 01 00 00    	js     802186 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802057:	48 89 c7             	mov    %rax,%rdi
  80205a:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
  802066:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80206e:	ba 07 04 00 00       	mov    $0x407,%edx
  802073:	48 89 c6             	mov    %rax,%rsi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80208a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80208e:	79 05                	jns    802095 <pipe+0xe3>
		goto err2;
  802090:	e9 d9 00 00 00       	jmpq   80216e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802095:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802099:	48 89 c7             	mov    %rax,%rdi
  80209c:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	callq  *%rax
  8020a8:	48 89 c2             	mov    %rax,%rdx
  8020ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020af:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8020b5:	48 89 d1             	mov    %rdx,%rcx
  8020b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bd:	48 89 c6             	mov    %rax,%rsi
  8020c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c5:	48 b8 e3 0b 80 00 00 	movabs $0x800be3,%rax
  8020cc:	00 00 00 
  8020cf:	ff d0                	callq  *%rax
  8020d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020d8:	79 1b                	jns    8020f5 <pipe+0x143>
		goto err3;
  8020da:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8020db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020df:	48 89 c6             	mov    %rax,%rsi
  8020e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e7:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
  8020f3:	eb 79                	jmp    80216e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f9:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  802100:	00 00 00 
  802103:	8b 12                	mov    (%rdx),%edx
  802105:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802107:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802112:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802116:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80211d:	00 00 00 
  802120:	8b 12                	mov    (%rdx),%edx
  802122:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802124:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802128:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80212f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802133:	48 89 c7             	mov    %rax,%rdi
  802136:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
  802142:	89 c2                	mov    %eax,%edx
  802144:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802148:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80214a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80214e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802152:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802156:	48 89 c7             	mov    %rax,%rdi
  802159:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	89 03                	mov    %eax,(%rbx)
	return 0;
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
  80216c:	eb 33                	jmp    8021a1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80216e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802172:	48 89 c6             	mov    %rax,%rsi
  802175:	bf 00 00 00 00       	mov    $0x0,%edi
  80217a:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802186:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218a:	48 89 c6             	mov    %rax,%rsi
  80218d:	bf 00 00 00 00       	mov    $0x0,%edi
  802192:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax
err:
	return r;
  80219e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8021a1:	48 83 c4 38          	add    $0x38,%rsp
  8021a5:	5b                   	pop    %rbx
  8021a6:	5d                   	pop    %rbp
  8021a7:	c3                   	retq   

00000000008021a8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021a8:	55                   	push   %rbp
  8021a9:	48 89 e5             	mov    %rsp,%rbp
  8021ac:	53                   	push   %rbx
  8021ad:	48 83 ec 28          	sub    $0x28,%rsp
  8021b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021b9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021c0:	00 00 00 
  8021c3:	48 8b 00             	mov    (%rax),%rax
  8021c6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8021cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8021cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d3:	48 89 c7             	mov    %rax,%rdi
  8021d6:	48 b8 a8 37 80 00 00 	movabs $0x8037a8,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	89 c3                	mov    %eax,%ebx
  8021e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021e8:	48 89 c7             	mov    %rax,%rdi
  8021eb:	48 b8 a8 37 80 00 00 	movabs $0x8037a8,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
  8021f7:	39 c3                	cmp    %eax,%ebx
  8021f9:	0f 94 c0             	sete   %al
  8021fc:	0f b6 c0             	movzbl %al,%eax
  8021ff:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802202:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802209:	00 00 00 
  80220c:	48 8b 00             	mov    (%rax),%rax
  80220f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802215:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802218:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80221b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80221e:	75 05                	jne    802225 <_pipeisclosed+0x7d>
			return ret;
  802220:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802223:	eb 4f                	jmp    802274 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802225:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802228:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80222b:	74 42                	je     80226f <_pipeisclosed+0xc7>
  80222d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802231:	75 3c                	jne    80226f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802233:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80223a:	00 00 00 
  80223d:	48 8b 00             	mov    (%rax),%rax
  802240:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802246:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802249:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80224c:	89 c6                	mov    %eax,%esi
  80224e:	48 bf 65 39 80 00 00 	movabs $0x803965,%rdi
  802255:	00 00 00 
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	49 b8 67 2a 80 00 00 	movabs $0x802a67,%r8
  802264:	00 00 00 
  802267:	41 ff d0             	callq  *%r8
	}
  80226a:	e9 4a ff ff ff       	jmpq   8021b9 <_pipeisclosed+0x11>
  80226f:	e9 45 ff ff ff       	jmpq   8021b9 <_pipeisclosed+0x11>
}
  802274:	48 83 c4 28          	add    $0x28,%rsp
  802278:	5b                   	pop    %rbx
  802279:	5d                   	pop    %rbp
  80227a:	c3                   	retq   

000000000080227b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80227b:	55                   	push   %rbp
  80227c:	48 89 e5             	mov    %rsp,%rbp
  80227f:	48 83 ec 30          	sub    $0x30,%rsp
  802283:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802286:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80228a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80228d:	48 89 d6             	mov    %rdx,%rsi
  802290:	89 c7                	mov    %eax,%edi
  802292:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
  80229e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a5:	79 05                	jns    8022ac <pipeisclosed+0x31>
		return r;
  8022a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022aa:	eb 31                	jmp    8022dd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8022ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b0:	48 89 c7             	mov    %rax,%rdi
  8022b3:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax
  8022bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8022c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022cb:	48 89 d6             	mov    %rdx,%rsi
  8022ce:	48 89 c7             	mov    %rax,%rdi
  8022d1:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 40          	sub    $0x40,%rsp
  8022e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f7:	48 89 c7             	mov    %rax,%rdi
  8022fa:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80230a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80230e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802312:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802319:	00 
  80231a:	e9 92 00 00 00       	jmpq   8023b1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80231f:	eb 41                	jmp    802362 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802321:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802326:	74 09                	je     802331 <devpipe_read+0x52>
				return i;
  802328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232c:	e9 92 00 00 00       	jmpq   8023c3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802339:	48 89 d6             	mov    %rdx,%rsi
  80233c:	48 89 c7             	mov    %rax,%rdi
  80233f:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	74 07                	je     802356 <devpipe_read+0x77>
				return 0;
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	eb 6d                	jmp    8023c3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802356:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  80235d:	00 00 00 
  802360:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802366:	8b 10                	mov    (%rax),%edx
  802368:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236c:	8b 40 04             	mov    0x4(%rax),%eax
  80236f:	39 c2                	cmp    %eax,%edx
  802371:	74 ae                	je     802321 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802377:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80237f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802383:	8b 00                	mov    (%rax),%eax
  802385:	99                   	cltd   
  802386:	c1 ea 1b             	shr    $0x1b,%edx
  802389:	01 d0                	add    %edx,%eax
  80238b:	83 e0 1f             	and    $0x1f,%eax
  80238e:	29 d0                	sub    %edx,%eax
  802390:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802394:	48 98                	cltq   
  802396:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80239b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80239d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a1:	8b 00                	mov    (%rax),%eax
  8023a3:	8d 50 01             	lea    0x1(%rax),%edx
  8023a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023aa:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8023b9:	0f 82 60 ff ff ff    	jb     80231f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023c3:	c9                   	leaveq 
  8023c4:	c3                   	retq   

00000000008023c5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023c5:	55                   	push   %rbp
  8023c6:	48 89 e5             	mov    %rsp,%rbp
  8023c9:	48 83 ec 40          	sub    $0x40,%rsp
  8023cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023dd:	48 89 c7             	mov    %rax,%rdi
  8023e0:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8023f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8023f8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8023ff:	00 
  802400:	e9 8e 00 00 00       	jmpq   802493 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802405:	eb 31                	jmp    802438 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802407:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80240f:	48 89 d6             	mov    %rdx,%rsi
  802412:	48 89 c7             	mov    %rax,%rdi
  802415:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 07                	je     80242c <devpipe_write+0x67>
				return 0;
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	eb 79                	jmp    8024a5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80242c:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  802433:	00 00 00 
  802436:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243c:	8b 40 04             	mov    0x4(%rax),%eax
  80243f:	48 63 d0             	movslq %eax,%rdx
  802442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802446:	8b 00                	mov    (%rax),%eax
  802448:	48 98                	cltq   
  80244a:	48 83 c0 20          	add    $0x20,%rax
  80244e:	48 39 c2             	cmp    %rax,%rdx
  802451:	73 b4                	jae    802407 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802457:	8b 40 04             	mov    0x4(%rax),%eax
  80245a:	99                   	cltd   
  80245b:	c1 ea 1b             	shr    $0x1b,%edx
  80245e:	01 d0                	add    %edx,%eax
  802460:	83 e0 1f             	and    $0x1f,%eax
  802463:	29 d0                	sub    %edx,%eax
  802465:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802469:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80246d:	48 01 ca             	add    %rcx,%rdx
  802470:	0f b6 0a             	movzbl (%rdx),%ecx
  802473:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802477:	48 98                	cltq   
  802479:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80247d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802481:	8b 40 04             	mov    0x4(%rax),%eax
  802484:	8d 50 01             	lea    0x1(%rax),%edx
  802487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80248e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802497:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80249b:	0f 82 64 ff ff ff    	jb     802405 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024a5:	c9                   	leaveq 
  8024a6:	c3                   	retq   

00000000008024a7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024a7:	55                   	push   %rbp
  8024a8:	48 89 e5             	mov    %rsp,%rbp
  8024ab:	48 83 ec 20          	sub    $0x20,%rsp
  8024af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bb:	48 89 c7             	mov    %rax,%rdi
  8024be:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8024c5:	00 00 00 
  8024c8:	ff d0                	callq  *%rax
  8024ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8024ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d2:	48 be 78 39 80 00 00 	movabs $0x803978,%rsi
  8024d9:	00 00 00 
  8024dc:	48 89 c7             	mov    %rax,%rdi
  8024df:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8024eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ef:	8b 50 04             	mov    0x4(%rax),%edx
  8024f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f6:	8b 00                	mov    (%rax),%eax
  8024f8:	29 c2                	sub    %eax,%edx
  8024fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024fe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802504:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802508:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80250f:	00 00 00 
	stat->st_dev = &devpipe;
  802512:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802516:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  80251d:	00 00 00 
  802520:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 10          	sub    $0x10,%rsp
  802536:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80253a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253e:	48 89 c6             	mov    %rax,%rsi
  802541:	bf 00 00 00 00       	mov    $0x0,%edi
  802546:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802556:	48 89 c7             	mov    %rax,%rdi
  802559:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  802560:	00 00 00 
  802563:	ff d0                	callq  *%rax
  802565:	48 89 c6             	mov    %rax,%rsi
  802568:	bf 00 00 00 00       	mov    $0x0,%edi
  80256d:	48 b8 3e 0c 80 00 00 	movabs $0x800c3e,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
}
  802579:	c9                   	leaveq 
  80257a:	c3                   	retq   

000000000080257b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80257b:	55                   	push   %rbp
  80257c:	48 89 e5             	mov    %rsp,%rbp
  80257f:	48 83 ec 20          	sub    $0x20,%rsp
  802583:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802586:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802589:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80258c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802590:	be 01 00 00 00       	mov    $0x1,%esi
  802595:	48 89 c7             	mov    %rax,%rdi
  802598:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
}
  8025a4:	c9                   	leaveq 
  8025a5:	c3                   	retq   

00000000008025a6 <getchar>:

int
getchar(void)
{
  8025a6:	55                   	push   %rbp
  8025a7:	48 89 e5             	mov    %rsp,%rbp
  8025aa:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025ae:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8025b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8025b7:	48 89 c6             	mov    %rax,%rsi
  8025ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8025bf:	48 b8 f9 14 80 00 00 	movabs $0x8014f9,%rax
  8025c6:	00 00 00 
  8025c9:	ff d0                	callq  *%rax
  8025cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8025ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d2:	79 05                	jns    8025d9 <getchar+0x33>
		return r;
  8025d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d7:	eb 14                	jmp    8025ed <getchar+0x47>
	if (r < 1)
  8025d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dd:	7f 07                	jg     8025e6 <getchar+0x40>
		return -E_EOF;
  8025df:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8025e4:	eb 07                	jmp    8025ed <getchar+0x47>
	return c;
  8025e6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8025ea:	0f b6 c0             	movzbl %al,%eax
}
  8025ed:	c9                   	leaveq 
  8025ee:	c3                   	retq   

00000000008025ef <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025ef:	55                   	push   %rbp
  8025f0:	48 89 e5             	mov    %rsp,%rbp
  8025f3:	48 83 ec 20          	sub    $0x20,%rsp
  8025f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802601:	48 89 d6             	mov    %rdx,%rsi
  802604:	89 c7                	mov    %eax,%edi
  802606:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
  802612:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802615:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802619:	79 05                	jns    802620 <iscons+0x31>
		return r;
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261e:	eb 1a                	jmp    80263a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	8b 10                	mov    (%rax),%edx
  802626:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  80262d:	00 00 00 
  802630:	8b 00                	mov    (%rax),%eax
  802632:	39 c2                	cmp    %eax,%edx
  802634:	0f 94 c0             	sete   %al
  802637:	0f b6 c0             	movzbl %al,%eax
}
  80263a:	c9                   	leaveq 
  80263b:	c3                   	retq   

000000000080263c <opencons>:

int
opencons(void)
{
  80263c:	55                   	push   %rbp
  80263d:	48 89 e5             	mov    %rsp,%rbp
  802640:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802644:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802648:	48 89 c7             	mov    %rax,%rdi
  80264b:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	79 05                	jns    802665 <opencons+0x29>
		return r;
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	eb 5b                	jmp    8026c0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802665:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802669:	ba 07 04 00 00       	mov    $0x407,%edx
  80266e:	48 89 c6             	mov    %rax,%rsi
  802671:	bf 00 00 00 00       	mov    $0x0,%edi
  802676:	48 b8 93 0b 80 00 00 	movabs $0x800b93,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
  802682:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802685:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802689:	79 05                	jns    802690 <opencons+0x54>
		return r;
  80268b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268e:	eb 30                	jmp    8026c0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802694:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  80269b:	00 00 00 
  80269e:	8b 12                	mov    (%rdx),%edx
  8026a0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8026a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8026ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b1:	48 89 c7             	mov    %rax,%rdi
  8026b4:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8026d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026db:	75 07                	jne    8026e4 <devcons_read+0x22>
		return 0;
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	eb 4b                	jmp    80272f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8026e4:	eb 0c                	jmp    8026f2 <devcons_read+0x30>
		sys_yield();
  8026e6:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8026f2:	48 b8 95 0a 80 00 00 	movabs $0x800a95,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
  8026fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802705:	74 df                	je     8026e6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270b:	79 05                	jns    802712 <devcons_read+0x50>
		return c;
  80270d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802710:	eb 1d                	jmp    80272f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802712:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802716:	75 07                	jne    80271f <devcons_read+0x5d>
		return 0;
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
  80271d:	eb 10                	jmp    80272f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80271f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802722:	89 c2                	mov    %eax,%edx
  802724:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802728:	88 10                	mov    %dl,(%rax)
	return 1;
  80272a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80272f:	c9                   	leaveq 
  802730:	c3                   	retq   

0000000000802731 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80273c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802743:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80274a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802758:	eb 76                	jmp    8027d0 <devcons_write+0x9f>
		m = n - tot;
  80275a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802761:	89 c2                	mov    %eax,%edx
  802763:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802766:	29 c2                	sub    %eax,%edx
  802768:	89 d0                	mov    %edx,%eax
  80276a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80276d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802770:	83 f8 7f             	cmp    $0x7f,%eax
  802773:	76 07                	jbe    80277c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802775:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80277c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80277f:	48 63 d0             	movslq %eax,%rdx
  802782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802785:	48 63 c8             	movslq %eax,%rcx
  802788:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80278f:	48 01 c1             	add    %rax,%rcx
  802792:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802799:	48 89 ce             	mov    %rcx,%rsi
  80279c:	48 89 c7             	mov    %rax,%rdi
  80279f:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8027ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ae:	48 63 d0             	movslq %eax,%rdx
  8027b1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	48 89 c7             	mov    %rax,%rdi
  8027be:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027cd:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d3:	48 98                	cltq   
  8027d5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8027dc:	0f 82 78 ff ff ff    	jb     80275a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027e5:	c9                   	leaveq 
  8027e6:	c3                   	retq   

00000000008027e7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8027e7:	55                   	push   %rbp
  8027e8:	48 89 e5             	mov    %rsp,%rbp
  8027eb:	48 83 ec 08          	sub    $0x8,%rsp
  8027ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f8:	c9                   	leaveq 
  8027f9:	c3                   	retq   

00000000008027fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027fa:	55                   	push   %rbp
  8027fb:	48 89 e5             	mov    %rsp,%rbp
  8027fe:	48 83 ec 10          	sub    $0x10,%rsp
  802802:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802806:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80280a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280e:	48 be 84 39 80 00 00 	movabs $0x803984,%rsi
  802815:	00 00 00 
  802818:	48 89 c7             	mov    %rax,%rdi
  80281b:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
	return 0;
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282c:	c9                   	leaveq 
  80282d:	c3                   	retq   

000000000080282e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
  802832:	53                   	push   %rbx
  802833:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80283a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802841:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802847:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80284e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802855:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80285c:	84 c0                	test   %al,%al
  80285e:	74 23                	je     802883 <_panic+0x55>
  802860:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802867:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80286b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80286f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802873:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802877:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80287b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80287f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802883:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80288a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802891:	00 00 00 
  802894:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80289b:	00 00 00 
  80289e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028a2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8028a9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8028b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028b7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8028be:	00 00 00 
  8028c1:	48 8b 18             	mov    (%rax),%rbx
  8028c4:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8028d6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8028dd:	41 89 c8             	mov    %ecx,%r8d
  8028e0:	48 89 d1             	mov    %rdx,%rcx
  8028e3:	48 89 da             	mov    %rbx,%rdx
  8028e6:	89 c6                	mov    %eax,%esi
  8028e8:	48 bf 90 39 80 00 00 	movabs $0x803990,%rdi
  8028ef:	00 00 00 
  8028f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f7:	49 b9 67 2a 80 00 00 	movabs $0x802a67,%r9
  8028fe:	00 00 00 
  802901:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802904:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80290b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802912:	48 89 d6             	mov    %rdx,%rsi
  802915:	48 89 c7             	mov    %rax,%rdi
  802918:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
	cprintf("\n");
  802924:	48 bf b3 39 80 00 00 	movabs $0x8039b3,%rdi
  80292b:	00 00 00 
  80292e:	b8 00 00 00 00       	mov    $0x0,%eax
  802933:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  80293a:	00 00 00 
  80293d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80293f:	cc                   	int3   
  802940:	eb fd                	jmp    80293f <_panic+0x111>

0000000000802942 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	48 83 ec 10          	sub    $0x10,%rsp
  80294a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80294d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  802951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802955:	8b 00                	mov    (%rax),%eax
  802957:	8d 48 01             	lea    0x1(%rax),%ecx
  80295a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295e:	89 0a                	mov    %ecx,(%rdx)
  802960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802963:	89 d1                	mov    %edx,%ecx
  802965:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802969:	48 98                	cltq   
  80296b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80296f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802973:	8b 00                	mov    (%rax),%eax
  802975:	3d ff 00 00 00       	cmp    $0xff,%eax
  80297a:	75 2c                	jne    8029a8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80297c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802980:	8b 00                	mov    (%rax),%eax
  802982:	48 98                	cltq   
  802984:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802988:	48 83 c2 08          	add    $0x8,%rdx
  80298c:	48 89 c6             	mov    %rax,%rsi
  80298f:	48 89 d7             	mov    %rdx,%rdi
  802992:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  802999:	00 00 00 
  80299c:	ff d0                	callq  *%rax
        b->idx = 0;
  80299e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8029a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ac:	8b 40 04             	mov    0x4(%rax),%eax
  8029af:	8d 50 01             	lea    0x1(%rax),%edx
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8029b9:	c9                   	leaveq 
  8029ba:	c3                   	retq   

00000000008029bb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8029bb:	55                   	push   %rbp
  8029bc:	48 89 e5             	mov    %rsp,%rbp
  8029bf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8029c6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8029cd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8029d4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8029db:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8029e2:	48 8b 0a             	mov    (%rdx),%rcx
  8029e5:	48 89 08             	mov    %rcx,(%rax)
  8029e8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029ec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029f0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029f4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8029f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8029ff:	00 00 00 
    b.cnt = 0;
  802a02:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802a09:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802a0c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802a13:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802a1a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802a21:	48 89 c6             	mov    %rax,%rsi
  802a24:	48 bf 42 29 80 00 00 	movabs $0x802942,%rdi
  802a2b:	00 00 00 
  802a2e:	48 b8 1a 2e 80 00 00 	movabs $0x802e1a,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802a3a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802a40:	48 98                	cltq   
  802a42:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802a49:	48 83 c2 08          	add    $0x8,%rdx
  802a4d:	48 89 c6             	mov    %rax,%rsi
  802a50:	48 89 d7             	mov    %rdx,%rdi
  802a53:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802a5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802a65:	c9                   	leaveq 
  802a66:	c3                   	retq   

0000000000802a67 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802a67:	55                   	push   %rbp
  802a68:	48 89 e5             	mov    %rsp,%rbp
  802a6b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802a72:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802a79:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802a80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802a87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a95:	84 c0                	test   %al,%al
  802a97:	74 20                	je     802ab9 <cprintf+0x52>
  802a99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802aa1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802aa5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802aa9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802aad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ab1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ab5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ab9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802ac0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802ac7:	00 00 00 
  802aca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ad1:	00 00 00 
  802ad4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ad8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802adf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ae6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802aed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802af4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802afb:	48 8b 0a             	mov    (%rdx),%rcx
  802afe:	48 89 08             	mov    %rcx,(%rax)
  802b01:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b05:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b09:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b0d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802b11:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802b18:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b1f:	48 89 d6             	mov    %rdx,%rsi
  802b22:	48 89 c7             	mov    %rax,%rdi
  802b25:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802b37:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802b3d:	c9                   	leaveq 
  802b3e:	c3                   	retq   

0000000000802b3f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802b3f:	55                   	push   %rbp
  802b40:	48 89 e5             	mov    %rsp,%rbp
  802b43:	53                   	push   %rbx
  802b44:	48 83 ec 38          	sub    $0x38,%rsp
  802b48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802b54:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802b57:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802b5b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802b5f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b62:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b66:	77 3b                	ja     802ba3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802b68:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802b6b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802b6f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802b72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b76:	ba 00 00 00 00       	mov    $0x0,%edx
  802b7b:	48 f7 f3             	div    %rbx
  802b7e:	48 89 c2             	mov    %rax,%rdx
  802b81:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802b84:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802b87:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8f:	41 89 f9             	mov    %edi,%r9d
  802b92:	48 89 c7             	mov    %rax,%rdi
  802b95:	48 b8 3f 2b 80 00 00 	movabs $0x802b3f,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	eb 1e                	jmp    802bc1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802ba3:	eb 12                	jmp    802bb7 <printnum+0x78>
			putch(padc, putdat);
  802ba5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ba9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb0:	48 89 ce             	mov    %rcx,%rsi
  802bb3:	89 d7                	mov    %edx,%edi
  802bb5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802bb7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802bbb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802bbf:	7f e4                	jg     802ba5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802bc1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802bc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcd:	48 f7 f1             	div    %rcx
  802bd0:	48 89 d0             	mov    %rdx,%rax
  802bd3:	48 ba b0 3b 80 00 00 	movabs $0x803bb0,%rdx
  802bda:	00 00 00 
  802bdd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802be1:	0f be d0             	movsbl %al,%edx
  802be4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bec:	48 89 ce             	mov    %rcx,%rsi
  802bef:	89 d7                	mov    %edx,%edi
  802bf1:	ff d0                	callq  *%rax
}
  802bf3:	48 83 c4 38          	add    $0x38,%rsp
  802bf7:	5b                   	pop    %rbx
  802bf8:	5d                   	pop    %rbp
  802bf9:	c3                   	retq   

0000000000802bfa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802bfa:	55                   	push   %rbp
  802bfb:	48 89 e5             	mov    %rsp,%rbp
  802bfe:	48 83 ec 1c          	sub    $0x1c,%rsp
  802c02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c06:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802c09:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802c0d:	7e 52                	jle    802c61 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c13:	8b 00                	mov    (%rax),%eax
  802c15:	83 f8 30             	cmp    $0x30,%eax
  802c18:	73 24                	jae    802c3e <getuint+0x44>
  802c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	8b 00                	mov    (%rax),%eax
  802c28:	89 c0                	mov    %eax,%eax
  802c2a:	48 01 d0             	add    %rdx,%rax
  802c2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c31:	8b 12                	mov    (%rdx),%edx
  802c33:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c3a:	89 0a                	mov    %ecx,(%rdx)
  802c3c:	eb 17                	jmp    802c55 <getuint+0x5b>
  802c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c42:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c46:	48 89 d0             	mov    %rdx,%rax
  802c49:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c51:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c55:	48 8b 00             	mov    (%rax),%rax
  802c58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c5c:	e9 a3 00 00 00       	jmpq   802d04 <getuint+0x10a>
	else if (lflag)
  802c61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c65:	74 4f                	je     802cb6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6b:	8b 00                	mov    (%rax),%eax
  802c6d:	83 f8 30             	cmp    $0x30,%eax
  802c70:	73 24                	jae    802c96 <getuint+0x9c>
  802c72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c76:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	8b 00                	mov    (%rax),%eax
  802c80:	89 c0                	mov    %eax,%eax
  802c82:	48 01 d0             	add    %rdx,%rax
  802c85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c89:	8b 12                	mov    (%rdx),%edx
  802c8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c92:	89 0a                	mov    %ecx,(%rdx)
  802c94:	eb 17                	jmp    802cad <getuint+0xb3>
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c9e:	48 89 d0             	mov    %rdx,%rax
  802ca1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802ca5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cad:	48 8b 00             	mov    (%rax),%rax
  802cb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802cb4:	eb 4e                	jmp    802d04 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cba:	8b 00                	mov    (%rax),%eax
  802cbc:	83 f8 30             	cmp    $0x30,%eax
  802cbf:	73 24                	jae    802ce5 <getuint+0xeb>
  802cc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccd:	8b 00                	mov    (%rax),%eax
  802ccf:	89 c0                	mov    %eax,%eax
  802cd1:	48 01 d0             	add    %rdx,%rax
  802cd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cd8:	8b 12                	mov    (%rdx),%edx
  802cda:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802cdd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ce1:	89 0a                	mov    %ecx,(%rdx)
  802ce3:	eb 17                	jmp    802cfc <getuint+0x102>
  802ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ced:	48 89 d0             	mov    %rdx,%rax
  802cf0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802cf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cf8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cfc:	8b 00                	mov    (%rax),%eax
  802cfe:	89 c0                	mov    %eax,%eax
  802d00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d08:	c9                   	leaveq 
  802d09:	c3                   	retq   

0000000000802d0a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802d0a:	55                   	push   %rbp
  802d0b:	48 89 e5             	mov    %rsp,%rbp
  802d0e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802d12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d16:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802d19:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802d1d:	7e 52                	jle    802d71 <getint+0x67>
		x=va_arg(*ap, long long);
  802d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d23:	8b 00                	mov    (%rax),%eax
  802d25:	83 f8 30             	cmp    $0x30,%eax
  802d28:	73 24                	jae    802d4e <getint+0x44>
  802d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802d32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d36:	8b 00                	mov    (%rax),%eax
  802d38:	89 c0                	mov    %eax,%eax
  802d3a:	48 01 d0             	add    %rdx,%rax
  802d3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d41:	8b 12                	mov    (%rdx),%edx
  802d43:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802d46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d4a:	89 0a                	mov    %ecx,(%rdx)
  802d4c:	eb 17                	jmp    802d65 <getint+0x5b>
  802d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d52:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802d56:	48 89 d0             	mov    %rdx,%rax
  802d59:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802d5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d65:	48 8b 00             	mov    (%rax),%rax
  802d68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802d6c:	e9 a3 00 00 00       	jmpq   802e14 <getint+0x10a>
	else if (lflag)
  802d71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802d75:	74 4f                	je     802dc6 <getint+0xbc>
		x=va_arg(*ap, long);
  802d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7b:	8b 00                	mov    (%rax),%eax
  802d7d:	83 f8 30             	cmp    $0x30,%eax
  802d80:	73 24                	jae    802da6 <getint+0x9c>
  802d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d86:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8e:	8b 00                	mov    (%rax),%eax
  802d90:	89 c0                	mov    %eax,%eax
  802d92:	48 01 d0             	add    %rdx,%rax
  802d95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d99:	8b 12                	mov    (%rdx),%edx
  802d9b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802d9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802da2:	89 0a                	mov    %ecx,(%rdx)
  802da4:	eb 17                	jmp    802dbd <getint+0xb3>
  802da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802dae:	48 89 d0             	mov    %rdx,%rax
  802db1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802db5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802db9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802dbd:	48 8b 00             	mov    (%rax),%rax
  802dc0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802dc4:	eb 4e                	jmp    802e14 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dca:	8b 00                	mov    (%rax),%eax
  802dcc:	83 f8 30             	cmp    $0x30,%eax
  802dcf:	73 24                	jae    802df5 <getint+0xeb>
  802dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddd:	8b 00                	mov    (%rax),%eax
  802ddf:	89 c0                	mov    %eax,%eax
  802de1:	48 01 d0             	add    %rdx,%rax
  802de4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802de8:	8b 12                	mov    (%rdx),%edx
  802dea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ded:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802df1:	89 0a                	mov    %ecx,(%rdx)
  802df3:	eb 17                	jmp    802e0c <getint+0x102>
  802df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802dfd:	48 89 d0             	mov    %rdx,%rax
  802e00:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802e04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e08:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802e0c:	8b 00                	mov    (%rax),%eax
  802e0e:	48 98                	cltq   
  802e10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e18:	c9                   	leaveq 
  802e19:	c3                   	retq   

0000000000802e1a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802e1a:	55                   	push   %rbp
  802e1b:	48 89 e5             	mov    %rsp,%rbp
  802e1e:	41 54                	push   %r12
  802e20:	53                   	push   %rbx
  802e21:	48 83 ec 60          	sub    $0x60,%rsp
  802e25:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802e29:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802e2d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802e31:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802e35:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e39:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802e3d:	48 8b 0a             	mov    (%rdx),%rcx
  802e40:	48 89 08             	mov    %rcx,(%rax)
  802e43:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802e47:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802e4b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802e4f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802e53:	eb 17                	jmp    802e6c <vprintfmt+0x52>
			if (ch == '\0')
  802e55:	85 db                	test   %ebx,%ebx
  802e57:	0f 84 cc 04 00 00    	je     803329 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802e5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802e61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e65:	48 89 d6             	mov    %rdx,%rsi
  802e68:	89 df                	mov    %ebx,%edi
  802e6a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802e6c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802e70:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802e74:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802e78:	0f b6 00             	movzbl (%rax),%eax
  802e7b:	0f b6 d8             	movzbl %al,%ebx
  802e7e:	83 fb 25             	cmp    $0x25,%ebx
  802e81:	75 d2                	jne    802e55 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802e83:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802e87:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802e8e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802e95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802e9c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802ea3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ea7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802eab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802eaf:	0f b6 00             	movzbl (%rax),%eax
  802eb2:	0f b6 d8             	movzbl %al,%ebx
  802eb5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802eb8:	83 f8 55             	cmp    $0x55,%eax
  802ebb:	0f 87 34 04 00 00    	ja     8032f5 <vprintfmt+0x4db>
  802ec1:	89 c0                	mov    %eax,%eax
  802ec3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802eca:	00 
  802ecb:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  802ed2:	00 00 00 
  802ed5:	48 01 d0             	add    %rdx,%rax
  802ed8:	48 8b 00             	mov    (%rax),%rax
  802edb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802edd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802ee1:	eb c0                	jmp    802ea3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802ee3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802ee7:	eb ba                	jmp    802ea3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802ee9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802ef0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802ef3:	89 d0                	mov    %edx,%eax
  802ef5:	c1 e0 02             	shl    $0x2,%eax
  802ef8:	01 d0                	add    %edx,%eax
  802efa:	01 c0                	add    %eax,%eax
  802efc:	01 d8                	add    %ebx,%eax
  802efe:	83 e8 30             	sub    $0x30,%eax
  802f01:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802f04:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f08:	0f b6 00             	movzbl (%rax),%eax
  802f0b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802f0e:	83 fb 2f             	cmp    $0x2f,%ebx
  802f11:	7e 0c                	jle    802f1f <vprintfmt+0x105>
  802f13:	83 fb 39             	cmp    $0x39,%ebx
  802f16:	7f 07                	jg     802f1f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802f18:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802f1d:	eb d1                	jmp    802ef0 <vprintfmt+0xd6>
			goto process_precision;
  802f1f:	eb 58                	jmp    802f79 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802f21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f24:	83 f8 30             	cmp    $0x30,%eax
  802f27:	73 17                	jae    802f40 <vprintfmt+0x126>
  802f29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f30:	89 c0                	mov    %eax,%eax
  802f32:	48 01 d0             	add    %rdx,%rax
  802f35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f38:	83 c2 08             	add    $0x8,%edx
  802f3b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f3e:	eb 0f                	jmp    802f4f <vprintfmt+0x135>
  802f40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f44:	48 89 d0             	mov    %rdx,%rax
  802f47:	48 83 c2 08          	add    $0x8,%rdx
  802f4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f4f:	8b 00                	mov    (%rax),%eax
  802f51:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802f54:	eb 23                	jmp    802f79 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802f56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f5a:	79 0c                	jns    802f68 <vprintfmt+0x14e>
				width = 0;
  802f5c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802f63:	e9 3b ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>
  802f68:	e9 36 ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802f6d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802f74:	e9 2a ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802f79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f7d:	79 12                	jns    802f91 <vprintfmt+0x177>
				width = precision, precision = -1;
  802f7f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f82:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802f85:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802f8c:	e9 12 ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>
  802f91:	e9 0d ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802f96:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802f9a:	e9 04 ff ff ff       	jmpq   802ea3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802f9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fa2:	83 f8 30             	cmp    $0x30,%eax
  802fa5:	73 17                	jae    802fbe <vprintfmt+0x1a4>
  802fa7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fae:	89 c0                	mov    %eax,%eax
  802fb0:	48 01 d0             	add    %rdx,%rax
  802fb3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802fb6:	83 c2 08             	add    $0x8,%edx
  802fb9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802fbc:	eb 0f                	jmp    802fcd <vprintfmt+0x1b3>
  802fbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802fc2:	48 89 d0             	mov    %rdx,%rax
  802fc5:	48 83 c2 08          	add    $0x8,%rdx
  802fc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fcd:	8b 10                	mov    (%rax),%edx
  802fcf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fd7:	48 89 ce             	mov    %rcx,%rsi
  802fda:	89 d7                	mov    %edx,%edi
  802fdc:	ff d0                	callq  *%rax
			break;
  802fde:	e9 40 03 00 00       	jmpq   803323 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802fe3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fe6:	83 f8 30             	cmp    $0x30,%eax
  802fe9:	73 17                	jae    803002 <vprintfmt+0x1e8>
  802feb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ff2:	89 c0                	mov    %eax,%eax
  802ff4:	48 01 d0             	add    %rdx,%rax
  802ff7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ffa:	83 c2 08             	add    $0x8,%edx
  802ffd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803000:	eb 0f                	jmp    803011 <vprintfmt+0x1f7>
  803002:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803006:	48 89 d0             	mov    %rdx,%rax
  803009:	48 83 c2 08          	add    $0x8,%rdx
  80300d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803011:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803013:	85 db                	test   %ebx,%ebx
  803015:	79 02                	jns    803019 <vprintfmt+0x1ff>
				err = -err;
  803017:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803019:	83 fb 15             	cmp    $0x15,%ebx
  80301c:	7f 16                	jg     803034 <vprintfmt+0x21a>
  80301e:	48 b8 00 3b 80 00 00 	movabs $0x803b00,%rax
  803025:	00 00 00 
  803028:	48 63 d3             	movslq %ebx,%rdx
  80302b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80302f:	4d 85 e4             	test   %r12,%r12
  803032:	75 2e                	jne    803062 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803034:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803038:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80303c:	89 d9                	mov    %ebx,%ecx
  80303e:	48 ba c1 3b 80 00 00 	movabs $0x803bc1,%rdx
  803045:	00 00 00 
  803048:	48 89 c7             	mov    %rax,%rdi
  80304b:	b8 00 00 00 00       	mov    $0x0,%eax
  803050:	49 b8 32 33 80 00 00 	movabs $0x803332,%r8
  803057:	00 00 00 
  80305a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80305d:	e9 c1 02 00 00       	jmpq   803323 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803062:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803066:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80306a:	4c 89 e1             	mov    %r12,%rcx
  80306d:	48 ba ca 3b 80 00 00 	movabs $0x803bca,%rdx
  803074:	00 00 00 
  803077:	48 89 c7             	mov    %rax,%rdi
  80307a:	b8 00 00 00 00       	mov    $0x0,%eax
  80307f:	49 b8 32 33 80 00 00 	movabs $0x803332,%r8
  803086:	00 00 00 
  803089:	41 ff d0             	callq  *%r8
			break;
  80308c:	e9 92 02 00 00       	jmpq   803323 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803091:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803094:	83 f8 30             	cmp    $0x30,%eax
  803097:	73 17                	jae    8030b0 <vprintfmt+0x296>
  803099:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80309d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030a0:	89 c0                	mov    %eax,%eax
  8030a2:	48 01 d0             	add    %rdx,%rax
  8030a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030a8:	83 c2 08             	add    $0x8,%edx
  8030ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8030ae:	eb 0f                	jmp    8030bf <vprintfmt+0x2a5>
  8030b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8030b4:	48 89 d0             	mov    %rdx,%rax
  8030b7:	48 83 c2 08          	add    $0x8,%rdx
  8030bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8030bf:	4c 8b 20             	mov    (%rax),%r12
  8030c2:	4d 85 e4             	test   %r12,%r12
  8030c5:	75 0a                	jne    8030d1 <vprintfmt+0x2b7>
				p = "(null)";
  8030c7:	49 bc cd 3b 80 00 00 	movabs $0x803bcd,%r12
  8030ce:	00 00 00 
			if (width > 0 && padc != '-')
  8030d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8030d5:	7e 3f                	jle    803116 <vprintfmt+0x2fc>
  8030d7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8030db:	74 39                	je     803116 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8030dd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8030e0:	48 98                	cltq   
  8030e2:	48 89 c6             	mov    %rax,%rsi
  8030e5:	4c 89 e7             	mov    %r12,%rdi
  8030e8:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
  8030f4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8030f7:	eb 17                	jmp    803110 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8030f9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8030fd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803101:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803105:	48 89 ce             	mov    %rcx,%rsi
  803108:	89 d7                	mov    %edx,%edi
  80310a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80310c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803110:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803114:	7f e3                	jg     8030f9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803116:	eb 37                	jmp    80314f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803118:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80311c:	74 1e                	je     80313c <vprintfmt+0x322>
  80311e:	83 fb 1f             	cmp    $0x1f,%ebx
  803121:	7e 05                	jle    803128 <vprintfmt+0x30e>
  803123:	83 fb 7e             	cmp    $0x7e,%ebx
  803126:	7e 14                	jle    80313c <vprintfmt+0x322>
					putch('?', putdat);
  803128:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80312c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803130:	48 89 d6             	mov    %rdx,%rsi
  803133:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803138:	ff d0                	callq  *%rax
  80313a:	eb 0f                	jmp    80314b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80313c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803140:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803144:	48 89 d6             	mov    %rdx,%rsi
  803147:	89 df                	mov    %ebx,%edi
  803149:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80314b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80314f:	4c 89 e0             	mov    %r12,%rax
  803152:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803156:	0f b6 00             	movzbl (%rax),%eax
  803159:	0f be d8             	movsbl %al,%ebx
  80315c:	85 db                	test   %ebx,%ebx
  80315e:	74 10                	je     803170 <vprintfmt+0x356>
  803160:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803164:	78 b2                	js     803118 <vprintfmt+0x2fe>
  803166:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80316a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80316e:	79 a8                	jns    803118 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803170:	eb 16                	jmp    803188 <vprintfmt+0x36e>
				putch(' ', putdat);
  803172:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803176:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80317a:	48 89 d6             	mov    %rdx,%rsi
  80317d:	bf 20 00 00 00       	mov    $0x20,%edi
  803182:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803184:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803188:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80318c:	7f e4                	jg     803172 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80318e:	e9 90 01 00 00       	jmpq   803323 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803193:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803197:	be 03 00 00 00       	mov    $0x3,%esi
  80319c:	48 89 c7             	mov    %rax,%rdi
  80319f:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  8031a6:	00 00 00 
  8031a9:	ff d0                	callq  *%rax
  8031ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8031af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b3:	48 85 c0             	test   %rax,%rax
  8031b6:	79 1d                	jns    8031d5 <vprintfmt+0x3bb>
				putch('-', putdat);
  8031b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031c0:	48 89 d6             	mov    %rdx,%rsi
  8031c3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8031c8:	ff d0                	callq  *%rax
				num = -(long long) num;
  8031ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ce:	48 f7 d8             	neg    %rax
  8031d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8031d5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8031dc:	e9 d5 00 00 00       	jmpq   8032b6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8031e1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031e5:	be 03 00 00 00       	mov    $0x3,%esi
  8031ea:	48 89 c7             	mov    %rax,%rdi
  8031ed:	48 b8 fa 2b 80 00 00 	movabs $0x802bfa,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8031fd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803204:	e9 ad 00 00 00       	jmpq   8032b6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803209:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80320c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803210:	89 d6                	mov    %edx,%esi
  803212:	48 89 c7             	mov    %rax,%rdi
  803215:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
  803221:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803225:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80322c:	e9 85 00 00 00       	jmpq   8032b6 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803231:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803235:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803239:	48 89 d6             	mov    %rdx,%rsi
  80323c:	bf 30 00 00 00       	mov    $0x30,%edi
  803241:	ff d0                	callq  *%rax
			putch('x', putdat);
  803243:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803247:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80324b:	48 89 d6             	mov    %rdx,%rsi
  80324e:	bf 78 00 00 00       	mov    $0x78,%edi
  803253:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803255:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803258:	83 f8 30             	cmp    $0x30,%eax
  80325b:	73 17                	jae    803274 <vprintfmt+0x45a>
  80325d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803261:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803264:	89 c0                	mov    %eax,%eax
  803266:	48 01 d0             	add    %rdx,%rax
  803269:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80326c:	83 c2 08             	add    $0x8,%edx
  80326f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803272:	eb 0f                	jmp    803283 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803274:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803278:	48 89 d0             	mov    %rdx,%rax
  80327b:	48 83 c2 08          	add    $0x8,%rdx
  80327f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803283:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803286:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80328a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803291:	eb 23                	jmp    8032b6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803293:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803297:	be 03 00 00 00       	mov    $0x3,%esi
  80329c:	48 89 c7             	mov    %rax,%rdi
  80329f:	48 b8 fa 2b 80 00 00 	movabs $0x802bfa,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
  8032ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8032af:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8032b6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8032bb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8032be:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8032c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8032c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8032cd:	45 89 c1             	mov    %r8d,%r9d
  8032d0:	41 89 f8             	mov    %edi,%r8d
  8032d3:	48 89 c7             	mov    %rax,%rdi
  8032d6:	48 b8 3f 2b 80 00 00 	movabs $0x802b3f,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
			break;
  8032e2:	eb 3f                	jmp    803323 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8032e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8032e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8032ec:	48 89 d6             	mov    %rdx,%rsi
  8032ef:	89 df                	mov    %ebx,%edi
  8032f1:	ff d0                	callq  *%rax
			break;
  8032f3:	eb 2e                	jmp    803323 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8032f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8032f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8032fd:	48 89 d6             	mov    %rdx,%rsi
  803300:	bf 25 00 00 00       	mov    $0x25,%edi
  803305:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803307:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80330c:	eb 05                	jmp    803313 <vprintfmt+0x4f9>
  80330e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803313:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803317:	48 83 e8 01          	sub    $0x1,%rax
  80331b:	0f b6 00             	movzbl (%rax),%eax
  80331e:	3c 25                	cmp    $0x25,%al
  803320:	75 ec                	jne    80330e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803322:	90                   	nop
		}
	}
  803323:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803324:	e9 43 fb ff ff       	jmpq   802e6c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803329:	48 83 c4 60          	add    $0x60,%rsp
  80332d:	5b                   	pop    %rbx
  80332e:	41 5c                	pop    %r12
  803330:	5d                   	pop    %rbp
  803331:	c3                   	retq   

0000000000803332 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803332:	55                   	push   %rbp
  803333:	48 89 e5             	mov    %rsp,%rbp
  803336:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80333d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803344:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80334b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803352:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803359:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803360:	84 c0                	test   %al,%al
  803362:	74 20                	je     803384 <printfmt+0x52>
  803364:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803368:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80336c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803370:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803374:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803378:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80337c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803380:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803384:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80338b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803392:	00 00 00 
  803395:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80339c:	00 00 00 
  80339f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033a3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8033aa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033b1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8033b8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8033bf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033c6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8033cd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033d4:	48 89 c7             	mov    %rax,%rdi
  8033d7:	48 b8 1a 2e 80 00 00 	movabs $0x802e1a,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8033f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f8:	8b 40 10             	mov    0x10(%rax),%eax
  8033fb:	8d 50 01             	lea    0x1(%rax),%edx
  8033fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803402:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803409:	48 8b 10             	mov    (%rax),%rdx
  80340c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803410:	48 8b 40 08          	mov    0x8(%rax),%rax
  803414:	48 39 c2             	cmp    %rax,%rdx
  803417:	73 17                	jae    803430 <sprintputch+0x4b>
		*b->buf++ = ch;
  803419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341d:	48 8b 00             	mov    (%rax),%rax
  803420:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803424:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803428:	48 89 0a             	mov    %rcx,(%rdx)
  80342b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342e:	88 10                	mov    %dl,(%rax)
}
  803430:	c9                   	leaveq 
  803431:	c3                   	retq   

0000000000803432 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803432:	55                   	push   %rbp
  803433:	48 89 e5             	mov    %rsp,%rbp
  803436:	48 83 ec 50          	sub    $0x50,%rsp
  80343a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80343e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803441:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803445:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803449:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80344d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803451:	48 8b 0a             	mov    (%rdx),%rcx
  803454:	48 89 08             	mov    %rcx,(%rax)
  803457:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80345b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80345f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803463:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803467:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80346b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80346f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803472:	48 98                	cltq   
  803474:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803478:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80347c:	48 01 d0             	add    %rdx,%rax
  80347f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803483:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80348a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80348f:	74 06                	je     803497 <vsnprintf+0x65>
  803491:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803495:	7f 07                	jg     80349e <vsnprintf+0x6c>
		return -E_INVAL;
  803497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80349c:	eb 2f                	jmp    8034cd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80349e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8034a2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8034a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034aa:	48 89 c6             	mov    %rax,%rsi
  8034ad:	48 bf e5 33 80 00 00 	movabs $0x8033e5,%rdi
  8034b4:	00 00 00 
  8034b7:	48 b8 1a 2e 80 00 00 	movabs $0x802e1a,%rax
  8034be:	00 00 00 
  8034c1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8034c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8034ca:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8034cd:	c9                   	leaveq 
  8034ce:	c3                   	retq   

00000000008034cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8034cf:	55                   	push   %rbp
  8034d0:	48 89 e5             	mov    %rsp,%rbp
  8034d3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8034da:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8034e1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8034e7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8034ee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8034f5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8034fc:	84 c0                	test   %al,%al
  8034fe:	74 20                	je     803520 <snprintf+0x51>
  803500:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803504:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803508:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80350c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803510:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803514:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803518:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80351c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803520:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803527:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80352e:	00 00 00 
  803531:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803538:	00 00 00 
  80353b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80353f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803546:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80354d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803554:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80355b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803562:	48 8b 0a             	mov    (%rdx),%rcx
  803565:	48 89 08             	mov    %rcx,(%rax)
  803568:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80356c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803570:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803574:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803578:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80357f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803586:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80358c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803593:	48 89 c7             	mov    %rax,%rdi
  803596:	48 b8 32 34 80 00 00 	movabs $0x803432,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
  8035a2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8035a8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8035ae:	c9                   	leaveq 
  8035af:	c3                   	retq   

00000000008035b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8035b0:	55                   	push   %rbp
  8035b1:	48 89 e5             	mov    %rsp,%rbp
  8035b4:	48 83 ec 30          	sub    $0x30,%rsp
  8035b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8035c4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035cb:	00 00 00 
  8035ce:	48 8b 00             	mov    (%rax),%rax
  8035d1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	75 34                	jne    80360f <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8035db:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
  8035e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8035ec:	48 98                	cltq   
  8035ee:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8035f5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035fc:	00 00 00 
  8035ff:	48 01 c2             	add    %rax,%rdx
  803602:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803609:	00 00 00 
  80360c:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80360f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803614:	75 0e                	jne    803624 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803616:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80361d:	00 00 00 
  803620:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803628:	48 89 c7             	mov    %rax,%rdi
  80362b:	48 b8 bc 0d 80 00 00 	movabs $0x800dbc,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80363a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363e:	79 19                	jns    803659 <ipc_recv+0xa9>
		*from_env_store = 0;
  803640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803644:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80364a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803657:	eb 53                	jmp    8036ac <ipc_recv+0xfc>
	}
	if(from_env_store)
  803659:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80365e:	74 19                	je     803679 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803660:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803667:	00 00 00 
  80366a:	48 8b 00             	mov    (%rax),%rax
  80366d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803677:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803679:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80367e:	74 19                	je     803699 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803680:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803687:	00 00 00 
  80368a:	48 8b 00             	mov    (%rax),%rax
  80368d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803697:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803699:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8036a0:	00 00 00 
  8036a3:	48 8b 00             	mov    (%rax),%rax
  8036a6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8036ac:	c9                   	leaveq 
  8036ad:	c3                   	retq   

00000000008036ae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8036ae:	55                   	push   %rbp
  8036af:	48 89 e5             	mov    %rsp,%rbp
  8036b2:	48 83 ec 30          	sub    $0x30,%rsp
  8036b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036b9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036bc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8036c0:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8036c3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8036c8:	75 0e                	jne    8036d8 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8036ca:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8036d1:	00 00 00 
  8036d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8036d8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8036db:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8036de:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e5:	89 c7                	mov    %eax,%edi
  8036e7:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
  8036f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8036f6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8036fa:	75 0c                	jne    803708 <ipc_send+0x5a>
			sys_yield();
  8036fc:	48 b8 55 0b 80 00 00 	movabs $0x800b55,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803708:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80370c:	74 ca                	je     8036d8 <ipc_send+0x2a>
	if(result != 0)
  80370e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803712:	74 20                	je     803734 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803717:	89 c6                	mov    %eax,%esi
  803719:	48 bf 88 3e 80 00 00 	movabs $0x803e88,%rdi
  803720:	00 00 00 
  803723:	b8 00 00 00 00       	mov    $0x0,%eax
  803728:	48 ba 67 2a 80 00 00 	movabs $0x802a67,%rdx
  80372f:	00 00 00 
  803732:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803734:	c9                   	leaveq 
  803735:	c3                   	retq   

0000000000803736 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803736:	55                   	push   %rbp
  803737:	48 89 e5             	mov    %rsp,%rbp
  80373a:	48 83 ec 14          	sub    $0x14,%rsp
  80373e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803741:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803748:	eb 4e                	jmp    803798 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80374a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803751:	00 00 00 
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803757:	48 98                	cltq   
  803759:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803760:	48 01 d0             	add    %rdx,%rax
  803763:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803769:	8b 00                	mov    (%rax),%eax
  80376b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80376e:	75 24                	jne    803794 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803770:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803777:	00 00 00 
  80377a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377d:	48 98                	cltq   
  80377f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803786:	48 01 d0             	add    %rdx,%rax
  803789:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80378f:	8b 40 08             	mov    0x8(%rax),%eax
  803792:	eb 12                	jmp    8037a6 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803794:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803798:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80379f:	7e a9                	jle    80374a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8037a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037a6:	c9                   	leaveq 
  8037a7:	c3                   	retq   

00000000008037a8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8037a8:	55                   	push   %rbp
  8037a9:	48 89 e5             	mov    %rsp,%rbp
  8037ac:	48 83 ec 18          	sub    $0x18,%rsp
  8037b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8037b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b8:	48 c1 e8 15          	shr    $0x15,%rax
  8037bc:	48 89 c2             	mov    %rax,%rdx
  8037bf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037c6:	01 00 00 
  8037c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037cd:	83 e0 01             	and    $0x1,%eax
  8037d0:	48 85 c0             	test   %rax,%rax
  8037d3:	75 07                	jne    8037dc <pageref+0x34>
		return 0;
  8037d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037da:	eb 53                	jmp    80382f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8037dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8037e4:	48 89 c2             	mov    %rax,%rdx
  8037e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037ee:	01 00 00 
  8037f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fd:	83 e0 01             	and    $0x1,%eax
  803800:	48 85 c0             	test   %rax,%rax
  803803:	75 07                	jne    80380c <pageref+0x64>
		return 0;
  803805:	b8 00 00 00 00       	mov    $0x0,%eax
  80380a:	eb 23                	jmp    80382f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80380c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803810:	48 c1 e8 0c          	shr    $0xc,%rax
  803814:	48 89 c2             	mov    %rax,%rdx
  803817:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80381e:	00 00 00 
  803821:	48 c1 e2 04          	shl    $0x4,%rdx
  803825:	48 01 d0             	add    %rdx,%rax
  803828:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80382c:	0f b7 c0             	movzwl %ax,%eax
}
  80382f:	c9                   	leaveq 
  803830:	c3                   	retq   
