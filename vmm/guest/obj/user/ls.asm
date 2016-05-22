
vmm/guest/obj/user/ls:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 e0 2b 80 00 00 	movabs $0x802be0,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 40 44 80 00 00 	movabs $0x804440,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 4c 44 80 00 00 	movabs $0x80444c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 ce 2c 80 00 00 	movabs $0x802cce,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 56 44 80 00 00 	movabs $0x804456,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 4c 44 80 00 00 	movabs $0x80444c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 00 29 80 00 00 	movabs $0x802900,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba 62 44 80 00 00 	movabs $0x804462,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 4c 44 80 00 00 	movabs $0x80444c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 c1 05 80 00 00 	movabs $0x8005c1,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba 80 44 80 00 00 	movabs $0x804480,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 4c 44 80 00 00 	movabs $0x80444c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf 9f 44 80 00 00 	movabs $0x80449f,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 32 35 80 00 00 	movabs $0x803532,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 a8 44 80 00 00 	movabs $0x8044a8,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 aa 44 80 00 00 	movabs $0x8044aa,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf ab 44 80 00 00 	movabs $0x8044ab,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 32 35 80 00 00 	movabs $0x803532,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf b0 44 80 00 00 	movabs $0x8044b0,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba 32 35 80 00 00 	movabs $0x803532,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf a8 44 80 00 00 	movabs $0x8044a8,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba 32 35 80 00 00 	movabs $0x803532,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf b3 44 80 00 00 	movabs $0x8044b3,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba 32 35 80 00 00 	movabs $0x803532,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf b5 44 80 00 00 	movabs $0x8044b5,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba 32 35 80 00 00 	movabs $0x803532,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 92 20 80 00 00 	movabs $0x802092,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be aa 44 80 00 00 	movabs $0x8044aa,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf a8 44 80 00 00 	movabs $0x8044a8,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80052a:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053b:	48 98                	cltq   
  80053d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800544:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80054b:	00 00 00 
  80054e:	48 01 c2             	add    %rax,%rdx
  800551:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800558:	00 00 00 
  80055b:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800562:	7e 14                	jle    800578 <libmain+0x5d>
		binaryname = argv[0];
  800564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800568:	48 8b 10             	mov    (%rax),%rdx
  80056b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800572:	00 00 00 
  800575:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800578:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80057f:	48 89 d6             	mov    %rdx,%rsi
  800582:	89 c7                	mov    %eax,%edi
  800584:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  80058b:	00 00 00 
  80058e:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800590:	48 b8 9e 05 80 00 00 	movabs $0x80059e,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005a2:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8005b3:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  8005ba:	00 00 00 
  8005bd:	ff d0                	callq  *%rax

}
  8005bf:	5d                   	pop    %rbp
  8005c0:	c3                   	retq   

00000000008005c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c1:	55                   	push   %rbp
  8005c2:	48 89 e5             	mov    %rsp,%rbp
  8005c5:	53                   	push   %rbx
  8005c6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005cd:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005d4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005da:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005e1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005e8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005ef:	84 c0                	test   %al,%al
  8005f1:	74 23                	je     800616 <_panic+0x55>
  8005f3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005fa:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005fe:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800602:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800606:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80060a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80060e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800612:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800616:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80061d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800624:	00 00 00 
  800627:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80062e:	00 00 00 
  800631:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800635:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80063c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800643:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80064a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800651:	00 00 00 
  800654:	48 8b 18             	mov    (%rax),%rbx
  800657:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  80065e:	00 00 00 
  800661:	ff d0                	callq  *%rax
  800663:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800669:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800670:	41 89 c8             	mov    %ecx,%r8d
  800673:	48 89 d1             	mov    %rdx,%rcx
  800676:	48 89 da             	mov    %rbx,%rdx
  800679:	89 c6                	mov    %eax,%esi
  80067b:	48 bf e0 44 80 00 00 	movabs $0x8044e0,%rdi
  800682:	00 00 00 
  800685:	b8 00 00 00 00       	mov    $0x0,%eax
  80068a:	49 b9 fa 07 80 00 00 	movabs $0x8007fa,%r9
  800691:	00 00 00 
  800694:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800697:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80069e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006a5:	48 89 d6             	mov    %rdx,%rsi
  8006a8:	48 89 c7             	mov    %rax,%rdi
  8006ab:	48 b8 4e 07 80 00 00 	movabs $0x80074e,%rax
  8006b2:	00 00 00 
  8006b5:	ff d0                	callq  *%rax
	cprintf("\n");
  8006b7:	48 bf 03 45 80 00 00 	movabs $0x804503,%rdi
  8006be:	00 00 00 
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  8006cd:	00 00 00 
  8006d0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006d2:	cc                   	int3   
  8006d3:	eb fd                	jmp    8006d2 <_panic+0x111>

00000000008006d5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006d5:	55                   	push   %rbp
  8006d6:	48 89 e5             	mov    %rsp,%rbp
  8006d9:	48 83 ec 10          	sub    $0x10,%rsp
  8006dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	8d 48 01             	lea    0x1(%rax),%ecx
  8006ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f1:	89 0a                	mov    %ecx,(%rdx)
  8006f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006f6:	89 d1                	mov    %edx,%ecx
  8006f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fc:	48 98                	cltq   
  8006fe:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800706:	8b 00                	mov    (%rax),%eax
  800708:	3d ff 00 00 00       	cmp    $0xff,%eax
  80070d:	75 2c                	jne    80073b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	48 98                	cltq   
  800717:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80071b:	48 83 c2 08          	add    $0x8,%rdx
  80071f:	48 89 c6             	mov    %rax,%rsi
  800722:	48 89 d7             	mov    %rdx,%rdi
  800725:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  80072c:	00 00 00 
  80072f:	ff d0                	callq  *%rax
        b->idx = 0;
  800731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800735:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80073b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073f:	8b 40 04             	mov    0x4(%rax),%eax
  800742:	8d 50 01             	lea    0x1(%rax),%edx
  800745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800749:	89 50 04             	mov    %edx,0x4(%rax)
}
  80074c:	c9                   	leaveq 
  80074d:	c3                   	retq   

000000000080074e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80074e:	55                   	push   %rbp
  80074f:	48 89 e5             	mov    %rsp,%rbp
  800752:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800759:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800760:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800767:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80076e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800775:	48 8b 0a             	mov    (%rdx),%rcx
  800778:	48 89 08             	mov    %rcx,(%rax)
  80077b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80077f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800783:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800787:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80078b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800792:	00 00 00 
    b.cnt = 0;
  800795:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80079c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80079f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007a6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007ad:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007b4:	48 89 c6             	mov    %rax,%rsi
  8007b7:	48 bf d5 06 80 00 00 	movabs $0x8006d5,%rdi
  8007be:	00 00 00 
  8007c1:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007cd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007d3:	48 98                	cltq   
  8007d5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007dc:	48 83 c2 08          	add    $0x8,%rdx
  8007e0:	48 89 c6             	mov    %rax,%rsi
  8007e3:	48 89 d7             	mov    %rdx,%rdi
  8007e6:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007f8:	c9                   	leaveq 
  8007f9:	c3                   	retq   

00000000008007fa <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007fa:	55                   	push   %rbp
  8007fb:	48 89 e5             	mov    %rsp,%rbp
  8007fe:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800805:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80080c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800813:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80081a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800821:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800828:	84 c0                	test   %al,%al
  80082a:	74 20                	je     80084c <cprintf+0x52>
  80082c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800830:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800834:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800838:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80083c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800840:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800844:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800848:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80084c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800853:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80085a:	00 00 00 
  80085d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800864:	00 00 00 
  800867:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80086b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800872:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800879:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800880:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800887:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80088e:	48 8b 0a             	mov    (%rdx),%rcx
  800891:	48 89 08             	mov    %rcx,(%rax)
  800894:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800898:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008a4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008b2:	48 89 d6             	mov    %rdx,%rsi
  8008b5:	48 89 c7             	mov    %rax,%rdi
  8008b8:	48 b8 4e 07 80 00 00 	movabs $0x80074e,%rax
  8008bf:	00 00 00 
  8008c2:	ff d0                	callq  *%rax
  8008c4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008d0:	c9                   	leaveq 
  8008d1:	c3                   	retq   

00000000008008d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d2:	55                   	push   %rbp
  8008d3:	48 89 e5             	mov    %rsp,%rbp
  8008d6:	53                   	push   %rbx
  8008d7:	48 83 ec 38          	sub    $0x38,%rsp
  8008db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008e7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008ea:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008ee:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008f2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8008f9:	77 3b                	ja     800936 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008fb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8008fe:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800902:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
  80090e:	48 f7 f3             	div    %rbx
  800911:	48 89 c2             	mov    %rax,%rdx
  800914:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800917:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80091a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	41 89 f9             	mov    %edi,%r9d
  800925:	48 89 c7             	mov    %rax,%rdi
  800928:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  80092f:	00 00 00 
  800932:	ff d0                	callq  *%rax
  800934:	eb 1e                	jmp    800954 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800936:	eb 12                	jmp    80094a <printnum+0x78>
			putch(padc, putdat);
  800938:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80093c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80093f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800943:	48 89 ce             	mov    %rcx,%rsi
  800946:	89 d7                	mov    %edx,%edi
  800948:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80094a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80094e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800952:	7f e4                	jg     800938 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800954:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	48 f7 f1             	div    %rcx
  800963:	48 89 d0             	mov    %rdx,%rax
  800966:	48 ba 10 47 80 00 00 	movabs $0x804710,%rdx
  80096d:	00 00 00 
  800970:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800974:	0f be d0             	movsbl %al,%edx
  800977:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	48 89 ce             	mov    %rcx,%rsi
  800982:	89 d7                	mov    %edx,%edi
  800984:	ff d0                	callq  *%rax
}
  800986:	48 83 c4 38          	add    $0x38,%rsp
  80098a:	5b                   	pop    %rbx
  80098b:	5d                   	pop    %rbp
  80098c:	c3                   	retq   

000000000080098d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80098d:	55                   	push   %rbp
  80098e:	48 89 e5             	mov    %rsp,%rbp
  800991:	48 83 ec 1c          	sub    $0x1c,%rsp
  800995:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800999:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80099c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a0:	7e 52                	jle    8009f4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	8b 00                	mov    (%rax),%eax
  8009a8:	83 f8 30             	cmp    $0x30,%eax
  8009ab:	73 24                	jae    8009d1 <getuint+0x44>
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	8b 00                	mov    (%rax),%eax
  8009bb:	89 c0                	mov    %eax,%eax
  8009bd:	48 01 d0             	add    %rdx,%rax
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	8b 12                	mov    (%rdx),%edx
  8009c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	89 0a                	mov    %ecx,(%rdx)
  8009cf:	eb 17                	jmp    8009e8 <getuint+0x5b>
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d9:	48 89 d0             	mov    %rdx,%rax
  8009dc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e8:	48 8b 00             	mov    (%rax),%rax
  8009eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009ef:	e9 a3 00 00 00       	jmpq   800a97 <getuint+0x10a>
	else if (lflag)
  8009f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009f8:	74 4f                	je     800a49 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8009fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	83 f8 30             	cmp    $0x30,%eax
  800a03:	73 24                	jae    800a29 <getuint+0x9c>
  800a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a09:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	89 c0                	mov    %eax,%eax
  800a15:	48 01 d0             	add    %rdx,%rax
  800a18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1c:	8b 12                	mov    (%rdx),%edx
  800a1e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a25:	89 0a                	mov    %ecx,(%rdx)
  800a27:	eb 17                	jmp    800a40 <getuint+0xb3>
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a31:	48 89 d0             	mov    %rdx,%rax
  800a34:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a40:	48 8b 00             	mov    (%rax),%rax
  800a43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a47:	eb 4e                	jmp    800a97 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4d:	8b 00                	mov    (%rax),%eax
  800a4f:	83 f8 30             	cmp    $0x30,%eax
  800a52:	73 24                	jae    800a78 <getuint+0xeb>
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	8b 00                	mov    (%rax),%eax
  800a62:	89 c0                	mov    %eax,%eax
  800a64:	48 01 d0             	add    %rdx,%rax
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	8b 12                	mov    (%rdx),%edx
  800a6d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a74:	89 0a                	mov    %ecx,(%rdx)
  800a76:	eb 17                	jmp    800a8f <getuint+0x102>
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a80:	48 89 d0             	mov    %rdx,%rax
  800a83:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8f:	8b 00                	mov    (%rax),%eax
  800a91:	89 c0                	mov    %eax,%eax
  800a93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a9b:	c9                   	leaveq 
  800a9c:	c3                   	retq   

0000000000800a9d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a9d:	55                   	push   %rbp
  800a9e:	48 89 e5             	mov    %rsp,%rbp
  800aa1:	48 83 ec 1c          	sub    $0x1c,%rsp
  800aa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aa9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800aac:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ab0:	7e 52                	jle    800b04 <getint+0x67>
		x=va_arg(*ap, long long);
  800ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab6:	8b 00                	mov    (%rax),%eax
  800ab8:	83 f8 30             	cmp    $0x30,%eax
  800abb:	73 24                	jae    800ae1 <getint+0x44>
  800abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac9:	8b 00                	mov    (%rax),%eax
  800acb:	89 c0                	mov    %eax,%eax
  800acd:	48 01 d0             	add    %rdx,%rax
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	8b 12                	mov    (%rdx),%edx
  800ad6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	89 0a                	mov    %ecx,(%rdx)
  800adf:	eb 17                	jmp    800af8 <getint+0x5b>
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af8:	48 8b 00             	mov    (%rax),%rax
  800afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aff:	e9 a3 00 00 00       	jmpq   800ba7 <getint+0x10a>
	else if (lflag)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b08:	74 4f                	je     800b59 <getint+0xbc>
		x=va_arg(*ap, long);
  800b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0e:	8b 00                	mov    (%rax),%eax
  800b10:	83 f8 30             	cmp    $0x30,%eax
  800b13:	73 24                	jae    800b39 <getint+0x9c>
  800b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	8b 00                	mov    (%rax),%eax
  800b23:	89 c0                	mov    %eax,%eax
  800b25:	48 01 d0             	add    %rdx,%rax
  800b28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2c:	8b 12                	mov    (%rdx),%edx
  800b2e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b35:	89 0a                	mov    %ecx,(%rdx)
  800b37:	eb 17                	jmp    800b50 <getint+0xb3>
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b50:	48 8b 00             	mov    (%rax),%rax
  800b53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b57:	eb 4e                	jmp    800ba7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5d:	8b 00                	mov    (%rax),%eax
  800b5f:	83 f8 30             	cmp    $0x30,%eax
  800b62:	73 24                	jae    800b88 <getint+0xeb>
  800b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b68:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	8b 00                	mov    (%rax),%eax
  800b72:	89 c0                	mov    %eax,%eax
  800b74:	48 01 d0             	add    %rdx,%rax
  800b77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7b:	8b 12                	mov    (%rdx),%edx
  800b7d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b84:	89 0a                	mov    %ecx,(%rdx)
  800b86:	eb 17                	jmp    800b9f <getint+0x102>
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b90:	48 89 d0             	mov    %rdx,%rax
  800b93:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b9f:	8b 00                	mov    (%rax),%eax
  800ba1:	48 98                	cltq   
  800ba3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bab:	c9                   	leaveq 
  800bac:	c3                   	retq   

0000000000800bad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bad:	55                   	push   %rbp
  800bae:	48 89 e5             	mov    %rsp,%rbp
  800bb1:	41 54                	push   %r12
  800bb3:	53                   	push   %rbx
  800bb4:	48 83 ec 60          	sub    $0x60,%rsp
  800bb8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bbc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bc0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bc4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bd0:	48 8b 0a             	mov    (%rdx),%rcx
  800bd3:	48 89 08             	mov    %rcx,(%rax)
  800bd6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bda:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bde:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800be2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be6:	eb 17                	jmp    800bff <vprintfmt+0x52>
			if (ch == '\0')
  800be8:	85 db                	test   %ebx,%ebx
  800bea:	0f 84 cc 04 00 00    	je     8010bc <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800bf0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf8:	48 89 d6             	mov    %rdx,%rsi
  800bfb:	89 df                	mov    %ebx,%edi
  800bfd:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bff:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c03:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c07:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c0b:	0f b6 00             	movzbl (%rax),%eax
  800c0e:	0f b6 d8             	movzbl %al,%ebx
  800c11:	83 fb 25             	cmp    $0x25,%ebx
  800c14:	75 d2                	jne    800be8 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c16:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c1a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c21:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c2f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c36:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c3e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c42:	0f b6 00             	movzbl (%rax),%eax
  800c45:	0f b6 d8             	movzbl %al,%ebx
  800c48:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c4b:	83 f8 55             	cmp    $0x55,%eax
  800c4e:	0f 87 34 04 00 00    	ja     801088 <vprintfmt+0x4db>
  800c54:	89 c0                	mov    %eax,%eax
  800c56:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c5d:	00 
  800c5e:	48 b8 38 47 80 00 00 	movabs $0x804738,%rax
  800c65:	00 00 00 
  800c68:	48 01 d0             	add    %rdx,%rax
  800c6b:	48 8b 00             	mov    (%rax),%rax
  800c6e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c70:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c74:	eb c0                	jmp    800c36 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c76:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c7a:	eb ba                	jmp    800c36 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c7c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c83:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c86:	89 d0                	mov    %edx,%eax
  800c88:	c1 e0 02             	shl    $0x2,%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	01 c0                	add    %eax,%eax
  800c8f:	01 d8                	add    %ebx,%eax
  800c91:	83 e8 30             	sub    $0x30,%eax
  800c94:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c97:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c9b:	0f b6 00             	movzbl (%rax),%eax
  800c9e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ca1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ca4:	7e 0c                	jle    800cb2 <vprintfmt+0x105>
  800ca6:	83 fb 39             	cmp    $0x39,%ebx
  800ca9:	7f 07                	jg     800cb2 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cab:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cb0:	eb d1                	jmp    800c83 <vprintfmt+0xd6>
			goto process_precision;
  800cb2:	eb 58                	jmp    800d0c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb7:	83 f8 30             	cmp    $0x30,%eax
  800cba:	73 17                	jae    800cd3 <vprintfmt+0x126>
  800cbc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc3:	89 c0                	mov    %eax,%eax
  800cc5:	48 01 d0             	add    %rdx,%rax
  800cc8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccb:	83 c2 08             	add    $0x8,%edx
  800cce:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd1:	eb 0f                	jmp    800ce2 <vprintfmt+0x135>
  800cd3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd7:	48 89 d0             	mov    %rdx,%rax
  800cda:	48 83 c2 08          	add    $0x8,%rdx
  800cde:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce2:	8b 00                	mov    (%rax),%eax
  800ce4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ce7:	eb 23                	jmp    800d0c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800ce9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ced:	79 0c                	jns    800cfb <vprintfmt+0x14e>
				width = 0;
  800cef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cf6:	e9 3b ff ff ff       	jmpq   800c36 <vprintfmt+0x89>
  800cfb:	e9 36 ff ff ff       	jmpq   800c36 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d00:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d07:	e9 2a ff ff ff       	jmpq   800c36 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d10:	79 12                	jns    800d24 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d12:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d15:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d18:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d1f:	e9 12 ff ff ff       	jmpq   800c36 <vprintfmt+0x89>
  800d24:	e9 0d ff ff ff       	jmpq   800c36 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d29:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d2d:	e9 04 ff ff ff       	jmpq   800c36 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d35:	83 f8 30             	cmp    $0x30,%eax
  800d38:	73 17                	jae    800d51 <vprintfmt+0x1a4>
  800d3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d41:	89 c0                	mov    %eax,%eax
  800d43:	48 01 d0             	add    %rdx,%rax
  800d46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d49:	83 c2 08             	add    $0x8,%edx
  800d4c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d4f:	eb 0f                	jmp    800d60 <vprintfmt+0x1b3>
  800d51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d55:	48 89 d0             	mov    %rdx,%rax
  800d58:	48 83 c2 08          	add    $0x8,%rdx
  800d5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d60:	8b 10                	mov    (%rax),%edx
  800d62:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6a:	48 89 ce             	mov    %rcx,%rsi
  800d6d:	89 d7                	mov    %edx,%edi
  800d6f:	ff d0                	callq  *%rax
			break;
  800d71:	e9 40 03 00 00       	jmpq   8010b6 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d79:	83 f8 30             	cmp    $0x30,%eax
  800d7c:	73 17                	jae    800d95 <vprintfmt+0x1e8>
  800d7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d85:	89 c0                	mov    %eax,%eax
  800d87:	48 01 d0             	add    %rdx,%rax
  800d8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8d:	83 c2 08             	add    $0x8,%edx
  800d90:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d93:	eb 0f                	jmp    800da4 <vprintfmt+0x1f7>
  800d95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d99:	48 89 d0             	mov    %rdx,%rax
  800d9c:	48 83 c2 08          	add    $0x8,%rdx
  800da0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800da6:	85 db                	test   %ebx,%ebx
  800da8:	79 02                	jns    800dac <vprintfmt+0x1ff>
				err = -err;
  800daa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dac:	83 fb 15             	cmp    $0x15,%ebx
  800daf:	7f 16                	jg     800dc7 <vprintfmt+0x21a>
  800db1:	48 b8 60 46 80 00 00 	movabs $0x804660,%rax
  800db8:	00 00 00 
  800dbb:	48 63 d3             	movslq %ebx,%rdx
  800dbe:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dc2:	4d 85 e4             	test   %r12,%r12
  800dc5:	75 2e                	jne    800df5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dc7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dcb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcf:	89 d9                	mov    %ebx,%ecx
  800dd1:	48 ba 21 47 80 00 00 	movabs $0x804721,%rdx
  800dd8:	00 00 00 
  800ddb:	48 89 c7             	mov    %rax,%rdi
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	49 b8 c5 10 80 00 00 	movabs $0x8010c5,%r8
  800dea:	00 00 00 
  800ded:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800df0:	e9 c1 02 00 00       	jmpq   8010b6 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800df5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfd:	4c 89 e1             	mov    %r12,%rcx
  800e00:	48 ba 2a 47 80 00 00 	movabs $0x80472a,%rdx
  800e07:	00 00 00 
  800e0a:	48 89 c7             	mov    %rax,%rdi
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e12:	49 b8 c5 10 80 00 00 	movabs $0x8010c5,%r8
  800e19:	00 00 00 
  800e1c:	41 ff d0             	callq  *%r8
			break;
  800e1f:	e9 92 02 00 00       	jmpq   8010b6 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e27:	83 f8 30             	cmp    $0x30,%eax
  800e2a:	73 17                	jae    800e43 <vprintfmt+0x296>
  800e2c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e33:	89 c0                	mov    %eax,%eax
  800e35:	48 01 d0             	add    %rdx,%rax
  800e38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e3b:	83 c2 08             	add    $0x8,%edx
  800e3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e41:	eb 0f                	jmp    800e52 <vprintfmt+0x2a5>
  800e43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e47:	48 89 d0             	mov    %rdx,%rax
  800e4a:	48 83 c2 08          	add    $0x8,%rdx
  800e4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e52:	4c 8b 20             	mov    (%rax),%r12
  800e55:	4d 85 e4             	test   %r12,%r12
  800e58:	75 0a                	jne    800e64 <vprintfmt+0x2b7>
				p = "(null)";
  800e5a:	49 bc 2d 47 80 00 00 	movabs $0x80472d,%r12
  800e61:	00 00 00 
			if (width > 0 && padc != '-')
  800e64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e68:	7e 3f                	jle    800ea9 <vprintfmt+0x2fc>
  800e6a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e6e:	74 39                	je     800ea9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e70:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e73:	48 98                	cltq   
  800e75:	48 89 c6             	mov    %rax,%rsi
  800e78:	4c 89 e7             	mov    %r12,%rdi
  800e7b:	48 b8 71 13 80 00 00 	movabs $0x801371,%rax
  800e82:	00 00 00 
  800e85:	ff d0                	callq  *%rax
  800e87:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e8a:	eb 17                	jmp    800ea3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e8c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e90:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e98:	48 89 ce             	mov    %rcx,%rsi
  800e9b:	89 d7                	mov    %edx,%edi
  800e9d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ea3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea7:	7f e3                	jg     800e8c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea9:	eb 37                	jmp    800ee2 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800eab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800eaf:	74 1e                	je     800ecf <vprintfmt+0x322>
  800eb1:	83 fb 1f             	cmp    $0x1f,%ebx
  800eb4:	7e 05                	jle    800ebb <vprintfmt+0x30e>
  800eb6:	83 fb 7e             	cmp    $0x7e,%ebx
  800eb9:	7e 14                	jle    800ecf <vprintfmt+0x322>
					putch('?', putdat);
  800ebb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ebf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec3:	48 89 d6             	mov    %rdx,%rsi
  800ec6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ecb:	ff d0                	callq  *%rax
  800ecd:	eb 0f                	jmp    800ede <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ecf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed7:	48 89 d6             	mov    %rdx,%rsi
  800eda:	89 df                	mov    %ebx,%edi
  800edc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ede:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ee2:	4c 89 e0             	mov    %r12,%rax
  800ee5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ee9:	0f b6 00             	movzbl (%rax),%eax
  800eec:	0f be d8             	movsbl %al,%ebx
  800eef:	85 db                	test   %ebx,%ebx
  800ef1:	74 10                	je     800f03 <vprintfmt+0x356>
  800ef3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ef7:	78 b2                	js     800eab <vprintfmt+0x2fe>
  800ef9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800efd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f01:	79 a8                	jns    800eab <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f03:	eb 16                	jmp    800f1b <vprintfmt+0x36e>
				putch(' ', putdat);
  800f05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0d:	48 89 d6             	mov    %rdx,%rsi
  800f10:	bf 20 00 00 00       	mov    $0x20,%edi
  800f15:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f17:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f1f:	7f e4                	jg     800f05 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f21:	e9 90 01 00 00       	jmpq   8010b6 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f2a:	be 03 00 00 00       	mov    $0x3,%esi
  800f2f:	48 89 c7             	mov    %rax,%rdi
  800f32:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  800f39:	00 00 00 
  800f3c:	ff d0                	callq  *%rax
  800f3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f46:	48 85 c0             	test   %rax,%rax
  800f49:	79 1d                	jns    800f68 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f53:	48 89 d6             	mov    %rdx,%rsi
  800f56:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f5b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f61:	48 f7 d8             	neg    %rax
  800f64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f68:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f6f:	e9 d5 00 00 00       	jmpq   801049 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f74:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f78:	be 03 00 00 00       	mov    $0x3,%esi
  800f7d:	48 89 c7             	mov    %rax,%rdi
  800f80:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  800f87:	00 00 00 
  800f8a:	ff d0                	callq  *%rax
  800f8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f90:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f97:	e9 ad 00 00 00       	jmpq   801049 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800f9c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800f9f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fa3:	89 d6                	mov    %edx,%esi
  800fa5:	48 89 c7             	mov    %rax,%rdi
  800fa8:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  800faf:	00 00 00 
  800fb2:	ff d0                	callq  *%rax
  800fb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fb8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fbf:	e9 85 00 00 00       	jmpq   801049 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800fc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fcc:	48 89 d6             	mov    %rdx,%rsi
  800fcf:	bf 30 00 00 00       	mov    $0x30,%edi
  800fd4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fd6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fde:	48 89 d6             	mov    %rdx,%rsi
  800fe1:	bf 78 00 00 00       	mov    $0x78,%edi
  800fe6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fe8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800feb:	83 f8 30             	cmp    $0x30,%eax
  800fee:	73 17                	jae    801007 <vprintfmt+0x45a>
  800ff0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ff4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ff7:	89 c0                	mov    %eax,%eax
  800ff9:	48 01 d0             	add    %rdx,%rax
  800ffc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fff:	83 c2 08             	add    $0x8,%edx
  801002:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801005:	eb 0f                	jmp    801016 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801007:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80100b:	48 89 d0             	mov    %rdx,%rax
  80100e:	48 83 c2 08          	add    $0x8,%rdx
  801012:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801016:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801019:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80101d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801024:	eb 23                	jmp    801049 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801026:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80102a:	be 03 00 00 00       	mov    $0x3,%esi
  80102f:	48 89 c7             	mov    %rax,%rdi
  801032:	48 b8 8d 09 80 00 00 	movabs $0x80098d,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801042:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801049:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80104e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801051:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801054:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801058:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80105c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801060:	45 89 c1             	mov    %r8d,%r9d
  801063:	41 89 f8             	mov    %edi,%r8d
  801066:	48 89 c7             	mov    %rax,%rdi
  801069:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  801070:	00 00 00 
  801073:	ff d0                	callq  *%rax
			break;
  801075:	eb 3f                	jmp    8010b6 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801077:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80107b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80107f:	48 89 d6             	mov    %rdx,%rsi
  801082:	89 df                	mov    %ebx,%edi
  801084:	ff d0                	callq  *%rax
			break;
  801086:	eb 2e                	jmp    8010b6 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801088:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80108c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801090:	48 89 d6             	mov    %rdx,%rsi
  801093:	bf 25 00 00 00       	mov    $0x25,%edi
  801098:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80109a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80109f:	eb 05                	jmp    8010a6 <vprintfmt+0x4f9>
  8010a1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010aa:	48 83 e8 01          	sub    $0x1,%rax
  8010ae:	0f b6 00             	movzbl (%rax),%eax
  8010b1:	3c 25                	cmp    $0x25,%al
  8010b3:	75 ec                	jne    8010a1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010b5:	90                   	nop
		}
	}
  8010b6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010b7:	e9 43 fb ff ff       	jmpq   800bff <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010bc:	48 83 c4 60          	add    $0x60,%rsp
  8010c0:	5b                   	pop    %rbx
  8010c1:	41 5c                	pop    %r12
  8010c3:	5d                   	pop    %rbp
  8010c4:	c3                   	retq   

00000000008010c5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010d0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010d7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 20                	je     801117 <printfmt+0x52>
  8010f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801103:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801107:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801113:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801117:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80111e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801125:	00 00 00 
  801128:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80112f:	00 00 00 
  801132:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801136:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80113d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801144:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80114b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801152:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801159:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801160:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801167:	48 89 c7             	mov    %rax,%rdi
  80116a:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax
	va_end(ap);
}
  801176:	c9                   	leaveq 
  801177:	c3                   	retq   

0000000000801178 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801178:	55                   	push   %rbp
  801179:	48 89 e5             	mov    %rsp,%rbp
  80117c:	48 83 ec 10          	sub    $0x10,%rsp
  801180:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801183:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118b:	8b 40 10             	mov    0x10(%rax),%eax
  80118e:	8d 50 01             	lea    0x1(%rax),%edx
  801191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801195:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119c:	48 8b 10             	mov    (%rax),%rdx
  80119f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011a7:	48 39 c2             	cmp    %rax,%rdx
  8011aa:	73 17                	jae    8011c3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b0:	48 8b 00             	mov    (%rax),%rax
  8011b3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011bb:	48 89 0a             	mov    %rcx,(%rdx)
  8011be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011c1:	88 10                	mov    %dl,(%rax)
}
  8011c3:	c9                   	leaveq 
  8011c4:	c3                   	retq   

00000000008011c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c5:	55                   	push   %rbp
  8011c6:	48 89 e5             	mov    %rsp,%rbp
  8011c9:	48 83 ec 50          	sub    $0x50,%rsp
  8011cd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011d1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011d4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011d8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011dc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011e0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011e4:	48 8b 0a             	mov    (%rdx),%rcx
  8011e7:	48 89 08             	mov    %rcx,(%rax)
  8011ea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011ee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011fe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801202:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801205:	48 98                	cltq   
  801207:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80120b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80120f:	48 01 d0             	add    %rdx,%rax
  801212:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801216:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80121d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801222:	74 06                	je     80122a <vsnprintf+0x65>
  801224:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801228:	7f 07                	jg     801231 <vsnprintf+0x6c>
		return -E_INVAL;
  80122a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122f:	eb 2f                	jmp    801260 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801231:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801235:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801239:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80123d:	48 89 c6             	mov    %rax,%rsi
  801240:	48 bf 78 11 80 00 00 	movabs $0x801178,%rdi
  801247:	00 00 00 
  80124a:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  801251:	00 00 00 
  801254:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801256:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80125a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80125d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80126d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801274:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80127a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801281:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801288:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80128f:	84 c0                	test   %al,%al
  801291:	74 20                	je     8012b3 <snprintf+0x51>
  801293:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801297:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80129b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80129f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012a3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012a7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012ab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012af:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012b3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012ba:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012c1:	00 00 00 
  8012c4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012cb:	00 00 00 
  8012ce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012d9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012e0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012e7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012ee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012f5:	48 8b 0a             	mov    (%rdx),%rcx
  8012f8:	48 89 08             	mov    %rcx,(%rax)
  8012fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801303:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801307:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80130b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801312:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801319:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80131f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801326:	48 89 c7             	mov    %rax,%rdi
  801329:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  801330:	00 00 00 
  801333:	ff d0                	callq  *%rax
  801335:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80133b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801341:	c9                   	leaveq 
  801342:	c3                   	retq   

0000000000801343 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	48 83 ec 18          	sub    $0x18,%rsp
  80134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801356:	eb 09                	jmp    801361 <strlen+0x1e>
		n++;
  801358:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80135c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801365:	0f b6 00             	movzbl (%rax),%eax
  801368:	84 c0                	test   %al,%al
  80136a:	75 ec                	jne    801358 <strlen+0x15>
		n++;
	return n;
  80136c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80136f:	c9                   	leaveq 
  801370:	c3                   	retq   

0000000000801371 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801371:	55                   	push   %rbp
  801372:	48 89 e5             	mov    %rsp,%rbp
  801375:	48 83 ec 20          	sub    $0x20,%rsp
  801379:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801381:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801388:	eb 0e                	jmp    801398 <strnlen+0x27>
		n++;
  80138a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80138e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801393:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801398:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80139d:	74 0b                	je     8013aa <strnlen+0x39>
  80139f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a3:	0f b6 00             	movzbl (%rax),%eax
  8013a6:	84 c0                	test   %al,%al
  8013a8:	75 e0                	jne    80138a <strnlen+0x19>
		n++;
	return n;
  8013aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ad:	c9                   	leaveq 
  8013ae:	c3                   	retq   

00000000008013af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013af:	55                   	push   %rbp
  8013b0:	48 89 e5             	mov    %rsp,%rbp
  8013b3:	48 83 ec 20          	sub    $0x20,%rsp
  8013b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013c7:	90                   	nop
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013dc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013e0:	0f b6 12             	movzbl (%rdx),%edx
  8013e3:	88 10                	mov    %dl,(%rax)
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 dc                	jne    8013c8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013f0:	c9                   	leaveq 
  8013f1:	c3                   	retq   

00000000008013f2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013f2:	55                   	push   %rbp
  8013f3:	48 89 e5             	mov    %rsp,%rbp
  8013f6:	48 83 ec 20          	sub    $0x20,%rsp
  8013fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	48 89 c7             	mov    %rax,%rdi
  801409:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  801410:	00 00 00 
  801413:	ff d0                	callq  *%rax
  801415:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141b:	48 63 d0             	movslq %eax,%rdx
  80141e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801422:	48 01 c2             	add    %rax,%rdx
  801425:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801429:	48 89 c6             	mov    %rax,%rsi
  80142c:	48 89 d7             	mov    %rdx,%rdi
  80142f:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  801436:	00 00 00 
  801439:	ff d0                	callq  *%rax
	return dst;
  80143b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80143f:	c9                   	leaveq 
  801440:	c3                   	retq   

0000000000801441 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801441:	55                   	push   %rbp
  801442:	48 89 e5             	mov    %rsp,%rbp
  801445:	48 83 ec 28          	sub    $0x28,%rsp
  801449:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801451:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801459:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80145d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801464:	00 
  801465:	eb 2a                	jmp    801491 <strncpy+0x50>
		*dst++ = *src;
  801467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801473:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801477:	0f b6 12             	movzbl (%rdx),%edx
  80147a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	84 c0                	test   %al,%al
  801485:	74 05                	je     80148c <strncpy+0x4b>
			src++;
  801487:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80148c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801499:	72 cc                	jb     801467 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80149f:	c9                   	leaveq 
  8014a0:	c3                   	retq   

00000000008014a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014a1:	55                   	push   %rbp
  8014a2:	48 89 e5             	mov    %rsp,%rbp
  8014a5:	48 83 ec 28          	sub    $0x28,%rsp
  8014a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014c2:	74 3d                	je     801501 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014c4:	eb 1d                	jmp    8014e3 <strlcpy+0x42>
			*dst++ = *src++;
  8014c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014da:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014de:	0f b6 12             	movzbl (%rdx),%edx
  8014e1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014e3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ed:	74 0b                	je     8014fa <strlcpy+0x59>
  8014ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	84 c0                	test   %al,%al
  8014f8:	75 cc                	jne    8014c6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801501:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	48 29 c2             	sub    %rax,%rdx
  80150c:	48 89 d0             	mov    %rdx,%rax
}
  80150f:	c9                   	leaveq 
  801510:	c3                   	retq   

0000000000801511 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801511:	55                   	push   %rbp
  801512:	48 89 e5             	mov    %rsp,%rbp
  801515:	48 83 ec 10          	sub    $0x10,%rsp
  801519:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80151d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801521:	eb 0a                	jmp    80152d <strcmp+0x1c>
		p++, q++;
  801523:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801528:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	84 c0                	test   %al,%al
  801536:	74 12                	je     80154a <strcmp+0x39>
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	0f b6 10             	movzbl (%rax),%edx
  80153f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	38 c2                	cmp    %al,%dl
  801548:	74 d9                	je     801523 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	0f b6 d0             	movzbl %al,%edx
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	0f b6 c0             	movzbl %al,%eax
  80155e:	29 c2                	sub    %eax,%edx
  801560:	89 d0                	mov    %edx,%eax
}
  801562:	c9                   	leaveq 
  801563:	c3                   	retq   

0000000000801564 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801564:	55                   	push   %rbp
  801565:	48 89 e5             	mov    %rsp,%rbp
  801568:	48 83 ec 18          	sub    $0x18,%rsp
  80156c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801570:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801574:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801578:	eb 0f                	jmp    801589 <strncmp+0x25>
		n--, p++, q++;
  80157a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80157f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801584:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801589:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158e:	74 1d                	je     8015ad <strncmp+0x49>
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	84 c0                	test   %al,%al
  801599:	74 12                	je     8015ad <strncmp+0x49>
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	0f b6 10             	movzbl (%rax),%edx
  8015a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	38 c2                	cmp    %al,%dl
  8015ab:	74 cd                	je     80157a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b2:	75 07                	jne    8015bb <strncmp+0x57>
		return 0;
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b9:	eb 18                	jmp    8015d3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bf:	0f b6 00             	movzbl (%rax),%eax
  8015c2:	0f b6 d0             	movzbl %al,%edx
  8015c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	0f b6 c0             	movzbl %al,%eax
  8015cf:	29 c2                	sub    %eax,%edx
  8015d1:	89 d0                	mov    %edx,%eax
}
  8015d3:	c9                   	leaveq 
  8015d4:	c3                   	retq   

00000000008015d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	48 83 ec 0c          	sub    $0xc,%rsp
  8015dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e1:	89 f0                	mov    %esi,%eax
  8015e3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015e6:	eb 17                	jmp    8015ff <strchr+0x2a>
		if (*s == c)
  8015e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015f2:	75 06                	jne    8015fa <strchr+0x25>
			return (char *) s;
  8015f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f8:	eb 15                	jmp    80160f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	84 c0                	test   %al,%al
  801608:	75 de                	jne    8015e8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160f:	c9                   	leaveq 
  801610:	c3                   	retq   

0000000000801611 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 0c          	sub    $0xc,%rsp
  801619:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161d:	89 f0                	mov    %esi,%eax
  80161f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801622:	eb 13                	jmp    801637 <strfind+0x26>
		if (*s == c)
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80162e:	75 02                	jne    801632 <strfind+0x21>
			break;
  801630:	eb 10                	jmp    801642 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801632:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163b:	0f b6 00             	movzbl (%rax),%eax
  80163e:	84 c0                	test   %al,%al
  801640:	75 e2                	jne    801624 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801646:	c9                   	leaveq 
  801647:	c3                   	retq   

0000000000801648 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801648:	55                   	push   %rbp
  801649:	48 89 e5             	mov    %rsp,%rbp
  80164c:	48 83 ec 18          	sub    $0x18,%rsp
  801650:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801654:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801657:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80165b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801660:	75 06                	jne    801668 <memset+0x20>
		return v;
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801666:	eb 69                	jmp    8016d1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166c:	83 e0 03             	and    $0x3,%eax
  80166f:	48 85 c0             	test   %rax,%rax
  801672:	75 48                	jne    8016bc <memset+0x74>
  801674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801678:	83 e0 03             	and    $0x3,%eax
  80167b:	48 85 c0             	test   %rax,%rax
  80167e:	75 3c                	jne    8016bc <memset+0x74>
		c &= 0xFF;
  801680:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801687:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80168a:	c1 e0 18             	shl    $0x18,%eax
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801692:	c1 e0 10             	shl    $0x10,%eax
  801695:	09 c2                	or     %eax,%edx
  801697:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80169a:	c1 e0 08             	shl    $0x8,%eax
  80169d:	09 d0                	or     %edx,%eax
  80169f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a6:	48 c1 e8 02          	shr    $0x2,%rax
  8016aa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b4:	48 89 d7             	mov    %rdx,%rdi
  8016b7:	fc                   	cld    
  8016b8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016ba:	eb 11                	jmp    8016cd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016c7:	48 89 d7             	mov    %rdx,%rdi
  8016ca:	fc                   	cld    
  8016cb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d1:	c9                   	leaveq 
  8016d2:	c3                   	retq   

00000000008016d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016d3:	55                   	push   %rbp
  8016d4:	48 89 e5             	mov    %rsp,%rbp
  8016d7:	48 83 ec 28          	sub    $0x28,%rsp
  8016db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016ff:	0f 83 88 00 00 00    	jae    80178d <memmove+0xba>
  801705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801709:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170d:	48 01 d0             	add    %rdx,%rax
  801710:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801714:	76 77                	jbe    80178d <memmove+0xba>
		s += n;
  801716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80171e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801722:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172a:	83 e0 03             	and    $0x3,%eax
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	75 3b                	jne    80176d <memmove+0x9a>
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801736:	83 e0 03             	and    $0x3,%eax
  801739:	48 85 c0             	test   %rax,%rax
  80173c:	75 2f                	jne    80176d <memmove+0x9a>
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	83 e0 03             	and    $0x3,%eax
  801745:	48 85 c0             	test   %rax,%rax
  801748:	75 23                	jne    80176d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80174a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174e:	48 83 e8 04          	sub    $0x4,%rax
  801752:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801756:	48 83 ea 04          	sub    $0x4,%rdx
  80175a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80175e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801762:	48 89 c7             	mov    %rax,%rdi
  801765:	48 89 d6             	mov    %rdx,%rsi
  801768:	fd                   	std    
  801769:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80176b:	eb 1d                	jmp    80178a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80176d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801771:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801779:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80177d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801781:	48 89 d7             	mov    %rdx,%rdi
  801784:	48 89 c1             	mov    %rax,%rcx
  801787:	fd                   	std    
  801788:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80178a:	fc                   	cld    
  80178b:	eb 57                	jmp    8017e4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80178d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801791:	83 e0 03             	and    $0x3,%eax
  801794:	48 85 c0             	test   %rax,%rax
  801797:	75 36                	jne    8017cf <memmove+0xfc>
  801799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179d:	83 e0 03             	and    $0x3,%eax
  8017a0:	48 85 c0             	test   %rax,%rax
  8017a3:	75 2a                	jne    8017cf <memmove+0xfc>
  8017a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a9:	83 e0 03             	and    $0x3,%eax
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	75 1e                	jne    8017cf <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	48 c1 e8 02          	shr    $0x2,%rax
  8017b9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c4:	48 89 c7             	mov    %rax,%rdi
  8017c7:	48 89 d6             	mov    %rdx,%rsi
  8017ca:	fc                   	cld    
  8017cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017cd:	eb 15                	jmp    8017e4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017db:	48 89 c7             	mov    %rax,%rdi
  8017de:	48 89 d6             	mov    %rdx,%rsi
  8017e1:	fc                   	cld    
  8017e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017e8:	c9                   	leaveq 
  8017e9:	c3                   	retq   

00000000008017ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017ea:	55                   	push   %rbp
  8017eb:	48 89 e5             	mov    %rsp,%rbp
  8017ee:	48 83 ec 18          	sub    $0x18,%rsp
  8017f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801802:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801806:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180a:	48 89 ce             	mov    %rcx,%rsi
  80180d:	48 89 c7             	mov    %rax,%rdi
  801810:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  801817:	00 00 00 
  80181a:	ff d0                	callq  *%rax
}
  80181c:	c9                   	leaveq 
  80181d:	c3                   	retq   

000000000080181e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80181e:	55                   	push   %rbp
  80181f:	48 89 e5             	mov    %rsp,%rbp
  801822:	48 83 ec 28          	sub    $0x28,%rsp
  801826:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80182a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80182e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80183a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80183e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801842:	eb 36                	jmp    80187a <memcmp+0x5c>
		if (*s1 != *s2)
  801844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801848:	0f b6 10             	movzbl (%rax),%edx
  80184b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184f:	0f b6 00             	movzbl (%rax),%eax
  801852:	38 c2                	cmp    %al,%dl
  801854:	74 1a                	je     801870 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	0f b6 d0             	movzbl %al,%edx
  801860:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801864:	0f b6 00             	movzbl (%rax),%eax
  801867:	0f b6 c0             	movzbl %al,%eax
  80186a:	29 c2                	sub    %eax,%edx
  80186c:	89 d0                	mov    %edx,%eax
  80186e:	eb 20                	jmp    801890 <memcmp+0x72>
		s1++, s2++;
  801870:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801875:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80187a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801882:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801886:	48 85 c0             	test   %rax,%rax
  801889:	75 b9                	jne    801844 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	c9                   	leaveq 
  801891:	c3                   	retq   

0000000000801892 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801892:	55                   	push   %rbp
  801893:	48 89 e5             	mov    %rsp,%rbp
  801896:	48 83 ec 28          	sub    $0x28,%rsp
  80189a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80189e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ad:	48 01 d0             	add    %rdx,%rax
  8018b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018b4:	eb 15                	jmp    8018cb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ba:	0f b6 10             	movzbl (%rax),%edx
  8018bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018c0:	38 c2                	cmp    %al,%dl
  8018c2:	75 02                	jne    8018c6 <memfind+0x34>
			break;
  8018c4:	eb 0f                	jmp    8018d5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018cf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018d3:	72 e1                	jb     8018b6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d9:	c9                   	leaveq 
  8018da:	c3                   	retq   

00000000008018db <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018db:	55                   	push   %rbp
  8018dc:	48 89 e5             	mov    %rsp,%rbp
  8018df:	48 83 ec 34          	sub    $0x34,%rsp
  8018e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018eb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018f5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018fc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018fd:	eb 05                	jmp    801904 <strtol+0x29>
		s++;
  8018ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	3c 20                	cmp    $0x20,%al
  80190d:	74 f0                	je     8018ff <strtol+0x24>
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	0f b6 00             	movzbl (%rax),%eax
  801916:	3c 09                	cmp    $0x9,%al
  801918:	74 e5                	je     8018ff <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80191a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191e:	0f b6 00             	movzbl (%rax),%eax
  801921:	3c 2b                	cmp    $0x2b,%al
  801923:	75 07                	jne    80192c <strtol+0x51>
		s++;
  801925:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80192a:	eb 17                	jmp    801943 <strtol+0x68>
	else if (*s == '-')
  80192c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801930:	0f b6 00             	movzbl (%rax),%eax
  801933:	3c 2d                	cmp    $0x2d,%al
  801935:	75 0c                	jne    801943 <strtol+0x68>
		s++, neg = 1;
  801937:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80193c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801943:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801947:	74 06                	je     80194f <strtol+0x74>
  801949:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80194d:	75 28                	jne    801977 <strtol+0x9c>
  80194f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801953:	0f b6 00             	movzbl (%rax),%eax
  801956:	3c 30                	cmp    $0x30,%al
  801958:	75 1d                	jne    801977 <strtol+0x9c>
  80195a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195e:	48 83 c0 01          	add    $0x1,%rax
  801962:	0f b6 00             	movzbl (%rax),%eax
  801965:	3c 78                	cmp    $0x78,%al
  801967:	75 0e                	jne    801977 <strtol+0x9c>
		s += 2, base = 16;
  801969:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80196e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801975:	eb 2c                	jmp    8019a3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801977:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80197b:	75 19                	jne    801996 <strtol+0xbb>
  80197d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801981:	0f b6 00             	movzbl (%rax),%eax
  801984:	3c 30                	cmp    $0x30,%al
  801986:	75 0e                	jne    801996 <strtol+0xbb>
		s++, base = 8;
  801988:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801994:	eb 0d                	jmp    8019a3 <strtol+0xc8>
	else if (base == 0)
  801996:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80199a:	75 07                	jne    8019a3 <strtol+0xc8>
		base = 10;
  80199c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a7:	0f b6 00             	movzbl (%rax),%eax
  8019aa:	3c 2f                	cmp    $0x2f,%al
  8019ac:	7e 1d                	jle    8019cb <strtol+0xf0>
  8019ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	3c 39                	cmp    $0x39,%al
  8019b7:	7f 12                	jg     8019cb <strtol+0xf0>
			dig = *s - '0';
  8019b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bd:	0f b6 00             	movzbl (%rax),%eax
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	83 e8 30             	sub    $0x30,%eax
  8019c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019c9:	eb 4e                	jmp    801a19 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cf:	0f b6 00             	movzbl (%rax),%eax
  8019d2:	3c 60                	cmp    $0x60,%al
  8019d4:	7e 1d                	jle    8019f3 <strtol+0x118>
  8019d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019da:	0f b6 00             	movzbl (%rax),%eax
  8019dd:	3c 7a                	cmp    $0x7a,%al
  8019df:	7f 12                	jg     8019f3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e5:	0f b6 00             	movzbl (%rax),%eax
  8019e8:	0f be c0             	movsbl %al,%eax
  8019eb:	83 e8 57             	sub    $0x57,%eax
  8019ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019f1:	eb 26                	jmp    801a19 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	0f b6 00             	movzbl (%rax),%eax
  8019fa:	3c 40                	cmp    $0x40,%al
  8019fc:	7e 48                	jle    801a46 <strtol+0x16b>
  8019fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a02:	0f b6 00             	movzbl (%rax),%eax
  801a05:	3c 5a                	cmp    $0x5a,%al
  801a07:	7f 3d                	jg     801a46 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0d:	0f b6 00             	movzbl (%rax),%eax
  801a10:	0f be c0             	movsbl %al,%eax
  801a13:	83 e8 37             	sub    $0x37,%eax
  801a16:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a1c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a1f:	7c 02                	jl     801a23 <strtol+0x148>
			break;
  801a21:	eb 23                	jmp    801a46 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a23:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a28:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a2b:	48 98                	cltq   
  801a2d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a32:	48 89 c2             	mov    %rax,%rdx
  801a35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 01 d0             	add    %rdx,%rax
  801a3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a41:	e9 5d ff ff ff       	jmpq   8019a3 <strtol+0xc8>

	if (endptr)
  801a46:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a4b:	74 0b                	je     801a58 <strtol+0x17d>
		*endptr = (char *) s;
  801a4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a51:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a55:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a5c:	74 09                	je     801a67 <strtol+0x18c>
  801a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a62:	48 f7 d8             	neg    %rax
  801a65:	eb 04                	jmp    801a6b <strtol+0x190>
  801a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <strstr>:

char * strstr(const char *in, const char *str)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 30          	sub    $0x30,%rsp
  801a75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a81:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a85:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a89:	0f b6 00             	movzbl (%rax),%eax
  801a8c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a8f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a93:	75 06                	jne    801a9b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a99:	eb 6b                	jmp    801b06 <strstr+0x99>

	len = strlen(str);
  801a9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a9f:	48 89 c7             	mov    %rax,%rdi
  801aa2:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
  801aae:	48 98                	cltq   
  801ab0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ab4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801abc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ac0:	0f b6 00             	movzbl (%rax),%eax
  801ac3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ac6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801aca:	75 07                	jne    801ad3 <strstr+0x66>
				return (char *) 0;
  801acc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad1:	eb 33                	jmp    801b06 <strstr+0x99>
		} while (sc != c);
  801ad3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ad7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ada:	75 d8                	jne    801ab4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801adc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae8:	48 89 ce             	mov    %rcx,%rsi
  801aeb:	48 89 c7             	mov    %rax,%rdi
  801aee:	48 b8 64 15 80 00 00 	movabs $0x801564,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
  801afa:	85 c0                	test   %eax,%eax
  801afc:	75 b6                	jne    801ab4 <strstr+0x47>

	return (char *) (in - 1);
  801afe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b02:	48 83 e8 01          	sub    $0x1,%rax
}
  801b06:	c9                   	leaveq 
  801b07:	c3                   	retq   

0000000000801b08 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b08:	55                   	push   %rbp
  801b09:	48 89 e5             	mov    %rsp,%rbp
  801b0c:	53                   	push   %rbx
  801b0d:	48 83 ec 48          	sub    $0x48,%rsp
  801b11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b14:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b17:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b1b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b1f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b23:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b2e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b32:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b36:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b3a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b3e:	4c 89 c3             	mov    %r8,%rbx
  801b41:	cd 30                	int    $0x30
  801b43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b4b:	74 3e                	je     801b8b <syscall+0x83>
  801b4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b52:	7e 37                	jle    801b8b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b5b:	49 89 d0             	mov    %rdx,%r8
  801b5e:	89 c1                	mov    %eax,%ecx
  801b60:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  801b67:	00 00 00 
  801b6a:	be 23 00 00 00       	mov    $0x23,%esi
  801b6f:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801b76:	00 00 00 
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  801b85:	00 00 00 
  801b88:	41 ff d1             	callq  *%r9

	return ret;
  801b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b8f:	48 83 c4 48          	add    $0x48,%rsp
  801b93:	5b                   	pop    %rbx
  801b94:	5d                   	pop    %rbp
  801b95:	c3                   	retq   

0000000000801b96 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 20          	sub    $0x20,%rsp
  801b9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ba2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ba6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801baa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb5:	00 
  801bb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc2:	48 89 d1             	mov    %rdx,%rcx
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	be 00 00 00 00       	mov    $0x0,%esi
  801bcd:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd2:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801be8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bef:	00 
  801bf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c01:	ba 00 00 00 00       	mov    $0x0,%edx
  801c06:	be 00 00 00 00       	mov    $0x0,%esi
  801c0b:	bf 01 00 00 00       	mov    $0x1,%edi
  801c10:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	callq  *%rax
}
  801c1c:	c9                   	leaveq 
  801c1d:	c3                   	retq   

0000000000801c1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c1e:	55                   	push   %rbp
  801c1f:	48 89 e5             	mov    %rsp,%rbp
  801c22:	48 83 ec 10          	sub    $0x10,%rsp
  801c26:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2c:	48 98                	cltq   
  801c2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c35:	00 
  801c36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c42:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c47:	48 89 c2             	mov    %rax,%rdx
  801c4a:	be 01 00 00 00       	mov    $0x1,%esi
  801c4f:	bf 03 00 00 00       	mov    $0x3,%edi
  801c54:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801c5b:	00 00 00 
  801c5e:	ff d0                	callq  *%rax
}
  801c60:	c9                   	leaveq 
  801c61:	c3                   	retq   

0000000000801c62 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c62:	55                   	push   %rbp
  801c63:	48 89 e5             	mov    %rsp,%rbp
  801c66:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c71:	00 
  801c72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	be 00 00 00 00       	mov    $0x0,%esi
  801c8d:	bf 02 00 00 00       	mov    $0x2,%edi
  801c92:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
}
  801c9e:	c9                   	leaveq 
  801c9f:	c3                   	retq   

0000000000801ca0 <sys_yield>:

void
sys_yield(void)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ca8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caf:	00 
  801cb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc6:	be 00 00 00 00       	mov    $0x0,%esi
  801ccb:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cd0:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
}
  801cdc:	c9                   	leaveq 
  801cdd:	c3                   	retq   

0000000000801cde <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cde:	55                   	push   %rbp
  801cdf:	48 89 e5             	mov    %rsp,%rbp
  801ce2:	48 83 ec 20          	sub    $0x20,%rsp
  801ce6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ced:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf3:	48 63 c8             	movslq %eax,%rcx
  801cf6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	48 98                	cltq   
  801cff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d06:	00 
  801d07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0d:	49 89 c8             	mov    %rcx,%r8
  801d10:	48 89 d1             	mov    %rdx,%rcx
  801d13:	48 89 c2             	mov    %rax,%rdx
  801d16:	be 01 00 00 00       	mov    $0x1,%esi
  801d1b:	bf 04 00 00 00       	mov    $0x4,%edi
  801d20:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801d27:	00 00 00 
  801d2a:	ff d0                	callq  *%rax
}
  801d2c:	c9                   	leaveq 
  801d2d:	c3                   	retq   

0000000000801d2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 83 ec 30          	sub    $0x30,%rsp
  801d36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d40:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d44:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d4b:	48 63 c8             	movslq %eax,%rcx
  801d4e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d55:	48 63 f0             	movslq %eax,%rsi
  801d58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5f:	48 98                	cltq   
  801d61:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d65:	49 89 f9             	mov    %rdi,%r9
  801d68:	49 89 f0             	mov    %rsi,%r8
  801d6b:	48 89 d1             	mov    %rdx,%rcx
  801d6e:	48 89 c2             	mov    %rax,%rdx
  801d71:	be 01 00 00 00       	mov    $0x1,%esi
  801d76:	bf 05 00 00 00       	mov    $0x5,%edi
  801d7b:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801d82:	00 00 00 
  801d85:	ff d0                	callq  *%rax
}
  801d87:	c9                   	leaveq 
  801d88:	c3                   	retq   

0000000000801d89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d89:	55                   	push   %rbp
  801d8a:	48 89 e5             	mov    %rsp,%rbp
  801d8d:	48 83 ec 20          	sub    $0x20,%rsp
  801d91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9f:	48 98                	cltq   
  801da1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da8:	00 
  801da9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db5:	48 89 d1             	mov    %rdx,%rcx
  801db8:	48 89 c2             	mov    %rax,%rdx
  801dbb:	be 01 00 00 00       	mov    $0x1,%esi
  801dc0:	bf 06 00 00 00       	mov    $0x6,%edi
  801dc5:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	callq  *%rax
}
  801dd1:	c9                   	leaveq 
  801dd2:	c3                   	retq   

0000000000801dd3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801dd3:	55                   	push   %rbp
  801dd4:	48 89 e5             	mov    %rsp,%rbp
  801dd7:	48 83 ec 10          	sub    $0x10,%rsp
  801ddb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dde:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801de4:	48 63 d0             	movslq %eax,%rdx
  801de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dea:	48 98                	cltq   
  801dec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df3:	00 
  801df4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e00:	48 89 d1             	mov    %rdx,%rcx
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	be 01 00 00 00       	mov    $0x1,%esi
  801e0b:	bf 08 00 00 00       	mov    $0x8,%edi
  801e10:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
}
  801e1c:	c9                   	leaveq 
  801e1d:	c3                   	retq   

0000000000801e1e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e1e:	55                   	push   %rbp
  801e1f:	48 89 e5             	mov    %rsp,%rbp
  801e22:	48 83 ec 20          	sub    $0x20,%rsp
  801e26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e34:	48 98                	cltq   
  801e36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e3d:	00 
  801e3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4a:	48 89 d1             	mov    %rdx,%rcx
  801e4d:	48 89 c2             	mov    %rax,%rdx
  801e50:	be 01 00 00 00       	mov    $0x1,%esi
  801e55:	bf 09 00 00 00       	mov    $0x9,%edi
  801e5a:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	callq  *%rax
}
  801e66:	c9                   	leaveq 
  801e67:	c3                   	retq   

0000000000801e68 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e68:	55                   	push   %rbp
  801e69:	48 89 e5             	mov    %rsp,%rbp
  801e6c:	48 83 ec 20          	sub    $0x20,%rsp
  801e70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7e:	48 98                	cltq   
  801e80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e87:	00 
  801e88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e94:	48 89 d1             	mov    %rdx,%rcx
  801e97:	48 89 c2             	mov    %rax,%rdx
  801e9a:	be 01 00 00 00       	mov    $0x1,%esi
  801e9f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ea4:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801eab:	00 00 00 
  801eae:	ff d0                	callq  *%rax
}
  801eb0:	c9                   	leaveq 
  801eb1:	c3                   	retq   

0000000000801eb2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801eb2:	55                   	push   %rbp
  801eb3:	48 89 e5             	mov    %rsp,%rbp
  801eb6:	48 83 ec 20          	sub    $0x20,%rsp
  801eba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ebd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ec1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ec5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ec8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ecb:	48 63 f0             	movslq %eax,%rsi
  801ece:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed5:	48 98                	cltq   
  801ed7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801edb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee2:	00 
  801ee3:	49 89 f1             	mov    %rsi,%r9
  801ee6:	49 89 c8             	mov    %rcx,%r8
  801ee9:	48 89 d1             	mov    %rdx,%rcx
  801eec:	48 89 c2             	mov    %rax,%rdx
  801eef:	be 00 00 00 00       	mov    $0x0,%esi
  801ef4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ef9:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801f00:	00 00 00 
  801f03:	ff d0                	callq  *%rax
}
  801f05:	c9                   	leaveq 
  801f06:	c3                   	retq   

0000000000801f07 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
  801f0b:	48 83 ec 10          	sub    $0x10,%rsp
  801f0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1e:	00 
  801f1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f30:	48 89 c2             	mov    %rax,%rdx
  801f33:	be 01 00 00 00       	mov    $0x1,%esi
  801f38:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f3d:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	callq  *%rax
}
  801f49:	c9                   	leaveq 
  801f4a:	c3                   	retq   

0000000000801f4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f4b:	55                   	push   %rbp
  801f4c:	48 89 e5             	mov    %rsp,%rbp
  801f4f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f5a:	00 
  801f5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f71:	be 00 00 00 00       	mov    $0x0,%esi
  801f76:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f7b:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
}
  801f87:	c9                   	leaveq 
  801f88:	c3                   	retq   

0000000000801f89 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f89:	55                   	push   %rbp
  801f8a:	48 89 e5             	mov    %rsp,%rbp
  801f8d:	48 83 ec 30          	sub    $0x30,%rsp
  801f91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f98:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f9b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f9f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801fa3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fa6:	48 63 c8             	movslq %eax,%rcx
  801fa9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fb0:	48 63 f0             	movslq %eax,%rsi
  801fb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fba:	48 98                	cltq   
  801fbc:	48 89 0c 24          	mov    %rcx,(%rsp)
  801fc0:	49 89 f9             	mov    %rdi,%r9
  801fc3:	49 89 f0             	mov    %rsi,%r8
  801fc6:	48 89 d1             	mov    %rdx,%rcx
  801fc9:	48 89 c2             	mov    %rax,%rdx
  801fcc:	be 00 00 00 00       	mov    $0x0,%esi
  801fd1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fd6:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801fe2:	c9                   	leaveq 
  801fe3:	c3                   	retq   

0000000000801fe4 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801fe4:	55                   	push   %rbp
  801fe5:	48 89 e5             	mov    %rsp,%rbp
  801fe8:	48 83 ec 20          	sub    $0x20,%rsp
  801fec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ff0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ff4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ffc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802003:	00 
  802004:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802010:	48 89 d1             	mov    %rdx,%rcx
  802013:	48 89 c2             	mov    %rax,%rdx
  802016:	be 00 00 00 00       	mov    $0x0,%esi
  80201b:	bf 10 00 00 00       	mov    $0x10,%edi
  802020:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  802027:	00 00 00 
  80202a:	ff d0                	callq  *%rax
}
  80202c:	c9                   	leaveq 
  80202d:	c3                   	retq   

000000000080202e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
  802032:	48 83 ec 18          	sub    $0x18,%rsp
  802036:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80203a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80203e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802046:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80204a:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80204d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802051:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802055:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205d:	8b 00                	mov    (%rax),%eax
  80205f:	83 f8 01             	cmp    $0x1,%eax
  802062:	7e 13                	jle    802077 <argstart+0x49>
  802064:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  802069:	74 0c                	je     802077 <argstart+0x49>
  80206b:	48 b8 13 4a 80 00 00 	movabs $0x804a13,%rax
  802072:	00 00 00 
  802075:	eb 05                	jmp    80207c <argstart+0x4e>
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
  80207c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802080:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802088:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80208f:	00 
}
  802090:	c9                   	leaveq 
  802091:	c3                   	retq   

0000000000802092 <argnext>:

int
argnext(struct Argstate *args)
{
  802092:	55                   	push   %rbp
  802093:	48 89 e5             	mov    %rsp,%rbp
  802096:	48 83 ec 20          	sub    $0x20,%rsp
  80209a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80209e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a2:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8020a9:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8020aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020b2:	48 85 c0             	test   %rax,%rax
  8020b5:	75 0a                	jne    8020c1 <argnext+0x2f>
		return -1;
  8020b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020bc:	e9 25 01 00 00       	jmpq   8021e6 <argnext+0x154>

	if (!*args->curarg) {
  8020c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020c9:	0f b6 00             	movzbl (%rax),%eax
  8020cc:	84 c0                	test   %al,%al
  8020ce:	0f 85 d7 00 00 00    	jne    8021ab <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 8b 00             	mov    (%rax),%rax
  8020db:	8b 00                	mov    (%rax),%eax
  8020dd:	83 f8 01             	cmp    $0x1,%eax
  8020e0:	0f 84 ef 00 00 00    	je     8021d5 <argnext+0x143>
		    || args->argv[1][0] != '-'
  8020e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020ee:	48 83 c0 08          	add    $0x8,%rax
  8020f2:	48 8b 00             	mov    (%rax),%rax
  8020f5:	0f b6 00             	movzbl (%rax),%eax
  8020f8:	3c 2d                	cmp    $0x2d,%al
  8020fa:	0f 85 d5 00 00 00    	jne    8021d5 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  802100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802104:	48 8b 40 08          	mov    0x8(%rax),%rax
  802108:	48 83 c0 08          	add    $0x8,%rax
  80210c:	48 8b 00             	mov    (%rax),%rax
  80210f:	48 83 c0 01          	add    $0x1,%rax
  802113:	0f b6 00             	movzbl (%rax),%eax
  802116:	84 c0                	test   %al,%al
  802118:	0f 84 b7 00 00 00    	je     8021d5 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80211e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802122:	48 8b 40 08          	mov    0x8(%rax),%rax
  802126:	48 83 c0 08          	add    $0x8,%rax
  80212a:	48 8b 00             	mov    (%rax),%rax
  80212d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802135:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213d:	48 8b 00             	mov    (%rax),%rax
  802140:	8b 00                	mov    (%rax),%eax
  802142:	83 e8 01             	sub    $0x1,%eax
  802145:	48 98                	cltq   
  802147:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80214e:	00 
  80214f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802153:	48 8b 40 08          	mov    0x8(%rax),%rax
  802157:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80215b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802163:	48 83 c0 08          	add    $0x8,%rax
  802167:	48 89 ce             	mov    %rcx,%rsi
  80216a:	48 89 c7             	mov    %rax,%rdi
  80216d:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
		(*args->argc)--;
  802179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217d:	48 8b 00             	mov    (%rax),%rax
  802180:	8b 10                	mov    (%rax),%edx
  802182:	83 ea 01             	sub    $0x1,%edx
  802185:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80218f:	0f b6 00             	movzbl (%rax),%eax
  802192:	3c 2d                	cmp    $0x2d,%al
  802194:	75 15                	jne    8021ab <argnext+0x119>
  802196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80219e:	48 83 c0 01          	add    $0x1,%rax
  8021a2:	0f b6 00             	movzbl (%rax),%eax
  8021a5:	84 c0                	test   %al,%al
  8021a7:	75 02                	jne    8021ab <argnext+0x119>
			goto endofargs;
  8021a9:	eb 2a                	jmp    8021d5 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8021ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021af:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021b3:	0f b6 00             	movzbl (%rax),%eax
  8021b6:	0f b6 c0             	movzbl %al,%eax
  8021b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8021bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	eb 11                	jmp    8021e6 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8021d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d9:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8021e0:	00 
	return -1;
  8021e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
  8021ec:	48 83 ec 10          	sub    $0x10,%rsp
  8021f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8021f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021fc:	48 85 c0             	test   %rax,%rax
  8021ff:	74 0a                	je     80220b <argvalue+0x23>
  802201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802205:	48 8b 40 18          	mov    0x18(%rax),%rax
  802209:	eb 13                	jmp    80221e <argvalue+0x36>
  80220b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220f:	48 89 c7             	mov    %rax,%rdi
  802212:	48 b8 20 22 80 00 00 	movabs $0x802220,%rax
  802219:	00 00 00 
  80221c:	ff d0                	callq  *%rax
}
  80221e:	c9                   	leaveq 
  80221f:	c3                   	retq   

0000000000802220 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	53                   	push   %rbx
  802225:	48 83 ec 18          	sub    $0x18,%rsp
  802229:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80222d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802231:	48 8b 40 10          	mov    0x10(%rax),%rax
  802235:	48 85 c0             	test   %rax,%rax
  802238:	75 0a                	jne    802244 <argnextvalue+0x24>
		return 0;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
  80223f:	e9 c8 00 00 00       	jmpq   80230c <argnextvalue+0xec>
	if (*args->curarg) {
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	48 8b 40 10          	mov    0x10(%rax),%rax
  80224c:	0f b6 00             	movzbl (%rax),%eax
  80224f:	84 c0                	test   %al,%al
  802251:	74 27                	je     80227a <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802257:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80225b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225f:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	48 bb 13 4a 80 00 00 	movabs $0x804a13,%rbx
  80226e:	00 00 00 
  802271:	48 89 58 10          	mov    %rbx,0x10(%rax)
  802275:	e9 8a 00 00 00       	jmpq   802304 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  80227a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227e:	48 8b 00             	mov    (%rax),%rax
  802281:	8b 00                	mov    (%rax),%eax
  802283:	83 f8 01             	cmp    $0x1,%eax
  802286:	7e 64                	jle    8022ec <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802290:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80229c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a0:	48 8b 00             	mov    (%rax),%rax
  8022a3:	8b 00                	mov    (%rax),%eax
  8022a5:	83 e8 01             	sub    $0x1,%eax
  8022a8:	48 98                	cltq   
  8022aa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022b1:	00 
  8022b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022ba:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8022be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022c6:	48 83 c0 08          	add    $0x8,%rax
  8022ca:	48 89 ce             	mov    %rcx,%rsi
  8022cd:	48 89 c7             	mov    %rax,%rdi
  8022d0:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
		(*args->argc)--;
  8022dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e0:	48 8b 00             	mov    (%rax),%rax
  8022e3:	8b 10                	mov    (%rax),%edx
  8022e5:	83 ea 01             	sub    $0x1,%edx
  8022e8:	89 10                	mov    %edx,(%rax)
  8022ea:	eb 18                	jmp    802304 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  8022ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f0:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8022f7:	00 
		args->curarg = 0;
  8022f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fc:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802303:	00 
	}
	return (char*) args->argvalue;
  802304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802308:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80230c:	48 83 c4 18          	add    $0x18,%rsp
  802310:	5b                   	pop    %rbx
  802311:	5d                   	pop    %rbp
  802312:	c3                   	retq   

0000000000802313 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802313:	55                   	push   %rbp
  802314:	48 89 e5             	mov    %rsp,%rbp
  802317:	48 83 ec 08          	sub    $0x8,%rsp
  80231b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80231f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802323:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80232a:	ff ff ff 
  80232d:	48 01 d0             	add    %rdx,%rax
  802330:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 08          	sub    $0x8,%rsp
  80233e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802346:	48 89 c7             	mov    %rax,%rdi
  802349:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802350:	00 00 00 
  802353:	ff d0                	callq  *%rax
  802355:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80235b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80235f:	c9                   	leaveq 
  802360:	c3                   	retq   

0000000000802361 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802361:	55                   	push   %rbp
  802362:	48 89 e5             	mov    %rsp,%rbp
  802365:	48 83 ec 18          	sub    $0x18,%rsp
  802369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80236d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802374:	eb 6b                	jmp    8023e1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802379:	48 98                	cltq   
  80237b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802381:	48 c1 e0 0c          	shl    $0xc,%rax
  802385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	48 c1 e8 15          	shr    $0x15,%rax
  802391:	48 89 c2             	mov    %rax,%rdx
  802394:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80239b:	01 00 00 
  80239e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a2:	83 e0 01             	and    $0x1,%eax
  8023a5:	48 85 c0             	test   %rax,%rax
  8023a8:	74 21                	je     8023cb <fd_alloc+0x6a>
  8023aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8023b2:	48 89 c2             	mov    %rax,%rdx
  8023b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023bc:	01 00 00 
  8023bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c3:	83 e0 01             	and    $0x1,%eax
  8023c6:	48 85 c0             	test   %rax,%rax
  8023c9:	75 12                	jne    8023dd <fd_alloc+0x7c>
			*fd_store = fd;
  8023cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023db:	eb 1a                	jmp    8023f7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023e5:	7e 8f                	jle    802376 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023f2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023f7:	c9                   	leaveq 
  8023f8:	c3                   	retq   

00000000008023f9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023f9:	55                   	push   %rbp
  8023fa:	48 89 e5             	mov    %rsp,%rbp
  8023fd:	48 83 ec 20          	sub    $0x20,%rsp
  802401:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802408:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80240c:	78 06                	js     802414 <fd_lookup+0x1b>
  80240e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802412:	7e 07                	jle    80241b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802419:	eb 6c                	jmp    802487 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80241b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80241e:	48 98                	cltq   
  802420:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802426:	48 c1 e0 0c          	shl    $0xc,%rax
  80242a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80242e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802432:	48 c1 e8 15          	shr    $0x15,%rax
  802436:	48 89 c2             	mov    %rax,%rdx
  802439:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802440:	01 00 00 
  802443:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802447:	83 e0 01             	and    $0x1,%eax
  80244a:	48 85 c0             	test   %rax,%rax
  80244d:	74 21                	je     802470 <fd_lookup+0x77>
  80244f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802453:	48 c1 e8 0c          	shr    $0xc,%rax
  802457:	48 89 c2             	mov    %rax,%rdx
  80245a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802461:	01 00 00 
  802464:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802468:	83 e0 01             	and    $0x1,%eax
  80246b:	48 85 c0             	test   %rax,%rax
  80246e:	75 07                	jne    802477 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802475:	eb 10                	jmp    802487 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leaveq 
  802488:	c3                   	retq   

0000000000802489 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802489:	55                   	push   %rbp
  80248a:	48 89 e5             	mov    %rsp,%rbp
  80248d:	48 83 ec 30          	sub    $0x30,%rsp
  802491:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802495:	89 f0                	mov    %esi,%eax
  802497:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80249a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b1:	48 89 d6             	mov    %rdx,%rsi
  8024b4:	89 c7                	mov    %eax,%edi
  8024b6:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	callq  *%rax
  8024c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c9:	78 0a                	js     8024d5 <fd_close+0x4c>
	    || fd != fd2)
  8024cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024d3:	74 12                	je     8024e7 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024d5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024d9:	74 05                	je     8024e0 <fd_close+0x57>
  8024db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024de:	eb 05                	jmp    8024e5 <fd_close+0x5c>
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	eb 69                	jmp    802550 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024eb:	8b 00                	mov    (%rax),%eax
  8024ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f1:	48 89 d6             	mov    %rdx,%rsi
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802505:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802509:	78 2a                	js     802535 <fd_close+0xac>
		if (dev->dev_close)
  80250b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802513:	48 85 c0             	test   %rax,%rax
  802516:	74 16                	je     80252e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802520:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802524:	48 89 d7             	mov    %rdx,%rdi
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252c:	eb 07                	jmp    802535 <fd_close+0xac>
		else
			r = 0;
  80252e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802539:	48 89 c6             	mov    %rax,%rsi
  80253c:	bf 00 00 00 00       	mov    $0x0,%edi
  802541:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  802548:	00 00 00 
  80254b:	ff d0                	callq  *%rax
	return r;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 20          	sub    $0x20,%rsp
  80255a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802568:	eb 41                	jmp    8025ab <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80256a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802571:	00 00 00 
  802574:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802577:	48 63 d2             	movslq %edx,%rdx
  80257a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257e:	8b 00                	mov    (%rax),%eax
  802580:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802583:	75 22                	jne    8025a7 <dev_lookup+0x55>
			*dev = devtab[i];
  802585:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80258c:	00 00 00 
  80258f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802592:	48 63 d2             	movslq %edx,%rdx
  802595:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a5:	eb 60                	jmp    802607 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ab:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025b2:	00 00 00 
  8025b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025b8:	48 63 d2             	movslq %edx,%rdx
  8025bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bf:	48 85 c0             	test   %rax,%rax
  8025c2:	75 a6                	jne    80256a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025c4:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8025cb:	00 00 00 
  8025ce:	48 8b 00             	mov    (%rax),%rax
  8025d1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025da:	89 c6                	mov    %eax,%esi
  8025dc:	48 bf 18 4a 80 00 00 	movabs $0x804a18,%rdi
  8025e3:	00 00 00 
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  8025f2:	00 00 00 
  8025f5:	ff d1                	callq  *%rcx
	*dev = 0;
  8025f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025fb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802602:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802607:	c9                   	leaveq 
  802608:	c3                   	retq   

0000000000802609 <close>:

int
close(int fdnum)
{
  802609:	55                   	push   %rbp
  80260a:	48 89 e5             	mov    %rsp,%rbp
  80260d:	48 83 ec 20          	sub    $0x20,%rsp
  802611:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802614:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802618:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80261b:	48 89 d6             	mov    %rdx,%rsi
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
  80262c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802633:	79 05                	jns    80263a <close+0x31>
		return r;
  802635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802638:	eb 18                	jmp    802652 <close+0x49>
	else
		return fd_close(fd, 1);
  80263a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263e:	be 01 00 00 00       	mov    $0x1,%esi
  802643:	48 89 c7             	mov    %rax,%rdi
  802646:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  80264d:	00 00 00 
  802650:	ff d0                	callq  *%rax
}
  802652:	c9                   	leaveq 
  802653:	c3                   	retq   

0000000000802654 <close_all>:

void
close_all(void)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80265c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802663:	eb 15                	jmp    80267a <close_all+0x26>
		close(i);
  802665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802668:	89 c7                	mov    %eax,%edi
  80266a:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802676:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80267a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80267e:	7e e5                	jle    802665 <close_all+0x11>
		close(i);
}
  802680:	c9                   	leaveq 
  802681:	c3                   	retq   

0000000000802682 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802682:	55                   	push   %rbp
  802683:	48 89 e5             	mov    %rsp,%rbp
  802686:	48 83 ec 40          	sub    $0x40,%rsp
  80268a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80268d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802690:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802694:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802697:	48 89 d6             	mov    %rdx,%rsi
  80269a:	89 c7                	mov    %eax,%edi
  80269c:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
  8026a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026af:	79 08                	jns    8026b9 <dup+0x37>
		return r;
  8026b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b4:	e9 70 01 00 00       	jmpq   802829 <dup+0x1a7>
	close(newfdnum);
  8026b9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026bc:	89 c7                	mov    %eax,%edi
  8026be:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026ca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026cd:	48 98                	cltq   
  8026cf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026d5:	48 c1 e0 0c          	shl    $0xc,%rax
  8026d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e1:	48 89 c7             	mov    %rax,%rdi
  8026e4:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
  8026f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80270b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270f:	48 c1 e8 15          	shr    $0x15,%rax
  802713:	48 89 c2             	mov    %rax,%rdx
  802716:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80271d:	01 00 00 
  802720:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802724:	83 e0 01             	and    $0x1,%eax
  802727:	48 85 c0             	test   %rax,%rax
  80272a:	74 73                	je     80279f <dup+0x11d>
  80272c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802730:	48 c1 e8 0c          	shr    $0xc,%rax
  802734:	48 89 c2             	mov    %rax,%rdx
  802737:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80273e:	01 00 00 
  802741:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802745:	83 e0 01             	and    $0x1,%eax
  802748:	48 85 c0             	test   %rax,%rax
  80274b:	74 52                	je     80279f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80274d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802751:	48 c1 e8 0c          	shr    $0xc,%rax
  802755:	48 89 c2             	mov    %rax,%rdx
  802758:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80275f:	01 00 00 
  802762:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802766:	25 07 0e 00 00       	and    $0xe07,%eax
  80276b:	89 c1                	mov    %eax,%ecx
  80276d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802775:	41 89 c8             	mov    %ecx,%r8d
  802778:	48 89 d1             	mov    %rdx,%rcx
  80277b:	ba 00 00 00 00       	mov    $0x0,%edx
  802780:	48 89 c6             	mov    %rax,%rsi
  802783:	bf 00 00 00 00       	mov    $0x0,%edi
  802788:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  80278f:	00 00 00 
  802792:	ff d0                	callq  *%rax
  802794:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279b:	79 02                	jns    80279f <dup+0x11d>
			goto err;
  80279d:	eb 57                	jmp    8027f6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80279f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027a7:	48 89 c2             	mov    %rax,%rdx
  8027aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b1:	01 00 00 
  8027b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8027bd:	89 c1                	mov    %eax,%ecx
  8027bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027c7:	41 89 c8             	mov    %ecx,%r8d
  8027ca:	48 89 d1             	mov    %rdx,%rcx
  8027cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d2:	48 89 c6             	mov    %rax,%rsi
  8027d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027da:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
  8027e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ed:	79 02                	jns    8027f1 <dup+0x16f>
		goto err;
  8027ef:	eb 05                	jmp    8027f6 <dup+0x174>

	return newfdnum;
  8027f1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f4:	eb 33                	jmp    802829 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	48 89 c6             	mov    %rax,%rsi
  8027fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802802:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80280e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802812:	48 89 c6             	mov    %rax,%rsi
  802815:	bf 00 00 00 00       	mov    $0x0,%edi
  80281a:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
	return r;
  802826:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802829:	c9                   	leaveq 
  80282a:	c3                   	retq   

000000000080282b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80282b:	55                   	push   %rbp
  80282c:	48 89 e5             	mov    %rsp,%rbp
  80282f:	48 83 ec 40          	sub    $0x40,%rsp
  802833:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80283a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80283e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802842:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802845:	48 89 d6             	mov    %rdx,%rsi
  802848:	89 c7                	mov    %eax,%edi
  80284a:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
  802856:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285d:	78 24                	js     802883 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80285f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802863:	8b 00                	mov    (%rax),%eax
  802865:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802869:	48 89 d6             	mov    %rdx,%rsi
  80286c:	89 c7                	mov    %eax,%edi
  80286e:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802875:	00 00 00 
  802878:	ff d0                	callq  *%rax
  80287a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802881:	79 05                	jns    802888 <read+0x5d>
		return r;
  802883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802886:	eb 76                	jmp    8028fe <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288c:	8b 40 08             	mov    0x8(%rax),%eax
  80288f:	83 e0 03             	and    $0x3,%eax
  802892:	83 f8 01             	cmp    $0x1,%eax
  802895:	75 3a                	jne    8028d1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802897:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 00             	mov    (%rax),%rax
  8028a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028aa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028ad:	89 c6                	mov    %eax,%esi
  8028af:	48 bf 37 4a 80 00 00 	movabs $0x804a37,%rdi
  8028b6:	00 00 00 
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  8028c5:	00 00 00 
  8028c8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028cf:	eb 2d                	jmp    8028fe <read+0xd3>
	}
	if (!dev->dev_read)
  8028d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028d9:	48 85 c0             	test   %rax,%rax
  8028dc:	75 07                	jne    8028e5 <read+0xba>
		return -E_NOT_SUPP;
  8028de:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e3:	eb 19                	jmp    8028fe <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028f5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028f9:	48 89 cf             	mov    %rcx,%rdi
  8028fc:	ff d0                	callq  *%rax
}
  8028fe:	c9                   	leaveq 
  8028ff:	c3                   	retq   

0000000000802900 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802900:	55                   	push   %rbp
  802901:	48 89 e5             	mov    %rsp,%rbp
  802904:	48 83 ec 30          	sub    $0x30,%rsp
  802908:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80290b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80290f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80291a:	eb 49                	jmp    802965 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80291c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291f:	48 98                	cltq   
  802921:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802925:	48 29 c2             	sub    %rax,%rdx
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	48 63 c8             	movslq %eax,%rcx
  80292e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802932:	48 01 c1             	add    %rax,%rcx
  802935:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802938:	48 89 ce             	mov    %rcx,%rsi
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	48 b8 2b 28 80 00 00 	movabs $0x80282b,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80294c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802950:	79 05                	jns    802957 <readn+0x57>
			return m;
  802952:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802955:	eb 1c                	jmp    802973 <readn+0x73>
		if (m == 0)
  802957:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80295b:	75 02                	jne    80295f <readn+0x5f>
			break;
  80295d:	eb 11                	jmp    802970 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80295f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802962:	01 45 fc             	add    %eax,-0x4(%rbp)
  802965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802968:	48 98                	cltq   
  80296a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80296e:	72 ac                	jb     80291c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802970:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802973:	c9                   	leaveq 
  802974:	c3                   	retq   

0000000000802975 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802975:	55                   	push   %rbp
  802976:	48 89 e5             	mov    %rsp,%rbp
  802979:	48 83 ec 40          	sub    $0x40,%rsp
  80297d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802980:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802984:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802988:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80298c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80298f:	48 89 d6             	mov    %rdx,%rsi
  802992:	89 c7                	mov    %eax,%edi
  802994:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a7:	78 24                	js     8029cd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ad:	8b 00                	mov    (%rax),%eax
  8029af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b3:	48 89 d6             	mov    %rdx,%rsi
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
  8029c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cb:	79 05                	jns    8029d2 <write+0x5d>
		return r;
  8029cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d0:	eb 42                	jmp    802a14 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d6:	8b 40 08             	mov    0x8(%rax),%eax
  8029d9:	83 e0 03             	and    $0x3,%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	75 07                	jne    8029e7 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e5:	eb 2d                	jmp    802a14 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029eb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029ef:	48 85 c0             	test   %rax,%rax
  8029f2:	75 07                	jne    8029fb <write+0x86>
		return -E_NOT_SUPP;
  8029f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029f9:	eb 19                	jmp    802a14 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8029fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ff:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a03:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a0b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a0f:	48 89 cf             	mov    %rcx,%rdi
  802a12:	ff d0                	callq  *%rax
}
  802a14:	c9                   	leaveq 
  802a15:	c3                   	retq   

0000000000802a16 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a16:	55                   	push   %rbp
  802a17:	48 89 e5             	mov    %rsp,%rbp
  802a1a:	48 83 ec 18          	sub    $0x18,%rsp
  802a1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a21:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a2b:	48 89 d6             	mov    %rdx,%rsi
  802a2e:	89 c7                	mov    %eax,%edi
  802a30:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802a37:	00 00 00 
  802a3a:	ff d0                	callq  *%rax
  802a3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a43:	79 05                	jns    802a4a <seek+0x34>
		return r;
  802a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a48:	eb 0f                	jmp    802a59 <seek+0x43>
	fd->fd_offset = offset;
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a51:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a59:	c9                   	leaveq 
  802a5a:	c3                   	retq   

0000000000802a5b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a5b:	55                   	push   %rbp
  802a5c:	48 89 e5             	mov    %rsp,%rbp
  802a5f:	48 83 ec 30          	sub    $0x30,%rsp
  802a63:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a66:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a69:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a6d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a70:	48 89 d6             	mov    %rdx,%rsi
  802a73:	89 c7                	mov    %eax,%edi
  802a75:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a88:	78 24                	js     802aae <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8e:	8b 00                	mov    (%rax),%eax
  802a90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a94:	48 89 d6             	mov    %rdx,%rsi
  802a97:	89 c7                	mov    %eax,%edi
  802a99:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aac:	79 05                	jns    802ab3 <ftruncate+0x58>
		return r;
  802aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab1:	eb 72                	jmp    802b25 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab7:	8b 40 08             	mov    0x8(%rax),%eax
  802aba:	83 e0 03             	and    $0x3,%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	75 3a                	jne    802afb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ac1:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802ac8:	00 00 00 
  802acb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ace:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ad4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ad7:	89 c6                	mov    %eax,%esi
  802ad9:	48 bf 58 4a 80 00 00 	movabs $0x804a58,%rdi
  802ae0:	00 00 00 
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	48 b9 fa 07 80 00 00 	movabs $0x8007fa,%rcx
  802aef:	00 00 00 
  802af2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802af4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802af9:	eb 2a                	jmp    802b25 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aff:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b03:	48 85 c0             	test   %rax,%rax
  802b06:	75 07                	jne    802b0f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b08:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b0d:	eb 16                	jmp    802b25 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b13:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b1b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b1e:	89 ce                	mov    %ecx,%esi
  802b20:	48 89 d7             	mov    %rdx,%rdi
  802b23:	ff d0                	callq  *%rax
}
  802b25:	c9                   	leaveq 
  802b26:	c3                   	retq   

0000000000802b27 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b27:	55                   	push   %rbp
  802b28:	48 89 e5             	mov    %rsp,%rbp
  802b2b:	48 83 ec 30          	sub    $0x30,%rsp
  802b2f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b32:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b36:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b3d:	48 89 d6             	mov    %rdx,%rsi
  802b40:	89 c7                	mov    %eax,%edi
  802b42:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	callq  *%rax
  802b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b55:	78 24                	js     802b7b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5b:	8b 00                	mov    (%rax),%eax
  802b5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b61:	48 89 d6             	mov    %rdx,%rsi
  802b64:	89 c7                	mov    %eax,%edi
  802b66:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax
  802b72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b79:	79 05                	jns    802b80 <fstat+0x59>
		return r;
  802b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7e:	eb 5e                	jmp    802bde <fstat+0xb7>
	if (!dev->dev_stat)
  802b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b84:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b88:	48 85 c0             	test   %rax,%rax
  802b8b:	75 07                	jne    802b94 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b8d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b92:	eb 4a                	jmp    802bde <fstat+0xb7>
	stat->st_name[0] = 0;
  802b94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b98:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b9f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ba6:	00 00 00 
	stat->st_isdir = 0;
  802ba9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bad:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bb4:	00 00 00 
	stat->st_dev = dev;
  802bb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bca:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bd6:	48 89 ce             	mov    %rcx,%rsi
  802bd9:	48 89 d7             	mov    %rdx,%rdi
  802bdc:	ff d0                	callq  *%rax
}
  802bde:	c9                   	leaveq 
  802bdf:	c3                   	retq   

0000000000802be0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802be0:	55                   	push   %rbp
  802be1:	48 89 e5             	mov    %rsp,%rbp
  802be4:	48 83 ec 20          	sub    $0x20,%rsp
  802be8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf4:	be 00 00 00 00       	mov    $0x0,%esi
  802bf9:	48 89 c7             	mov    %rax,%rdi
  802bfc:	48 b8 ce 2c 80 00 00 	movabs $0x802cce,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
  802c08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0f:	79 05                	jns    802c16 <stat+0x36>
		return fd;
  802c11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c14:	eb 2f                	jmp    802c45 <stat+0x65>
	r = fstat(fd, stat);
  802c16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1d:	48 89 d6             	mov    %rdx,%rsi
  802c20:	89 c7                	mov    %eax,%edi
  802c22:	48 b8 27 2b 80 00 00 	movabs $0x802b27,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
	return r;
  802c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c45:	c9                   	leaveq 
  802c46:	c3                   	retq   

0000000000802c47 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c47:	55                   	push   %rbp
  802c48:	48 89 e5             	mov    %rsp,%rbp
  802c4b:	48 83 ec 10          	sub    $0x10,%rsp
  802c4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c56:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c5d:	00 00 00 
  802c60:	8b 00                	mov    (%rax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	75 1d                	jne    802c83 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c66:	bf 01 00 00 00       	mov    $0x1,%edi
  802c6b:	48 b8 2f 43 80 00 00 	movabs $0x80432f,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c7e:	00 00 00 
  802c81:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c83:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c8a:	00 00 00 
  802c8d:	8b 00                	mov    (%rax),%eax
  802c8f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c92:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c97:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c9e:	00 00 00 
  802ca1:	89 c7                	mov    %eax,%edi
  802ca3:	48 b8 62 3f 80 00 00 	movabs $0x803f62,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb8:	48 89 c6             	mov    %rax,%rsi
  802cbb:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc0:	48 b8 64 3e 80 00 00 	movabs $0x803e64,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
}
  802ccc:	c9                   	leaveq 
  802ccd:	c3                   	retq   

0000000000802cce <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cce:	55                   	push   %rbp
  802ccf:	48 89 e5             	mov    %rsp,%rbp
  802cd2:	48 83 ec 30          	sub    $0x30,%rsp
  802cd6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cda:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802cdd:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802ce4:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802cf2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cf7:	75 08                	jne    802d01 <open+0x33>
	{
		return r;
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	e9 f2 00 00 00       	jmpq   802df3 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d05:	48 89 c7             	mov    %rax,%rdi
  802d08:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	callq  *%rax
  802d14:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d17:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d1e:	7e 0a                	jle    802d2a <open+0x5c>
	{
		return -E_BAD_PATH;
  802d20:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d25:	e9 c9 00 00 00       	jmpq   802df3 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d2a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802d31:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802d32:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d36:	48 89 c7             	mov    %rax,%rdi
  802d39:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
  802d45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4c:	78 09                	js     802d57 <open+0x89>
  802d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d52:	48 85 c0             	test   %rax,%rax
  802d55:	75 08                	jne    802d5f <open+0x91>
		{
			return r;
  802d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5a:	e9 94 00 00 00       	jmpq   802df3 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d63:	ba 00 04 00 00       	mov    $0x400,%edx
  802d68:	48 89 c6             	mov    %rax,%rsi
  802d6b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d72:	00 00 00 
  802d75:	48 b8 41 14 80 00 00 	movabs $0x801441,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802d81:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d88:	00 00 00 
  802d8b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802d8e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d98:	48 89 c6             	mov    %rax,%rsi
  802d9b:	bf 01 00 00 00       	mov    $0x1,%edi
  802da0:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax
  802dac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db3:	79 2b                	jns    802de0 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802db5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db9:	be 00 00 00 00       	mov    $0x0,%esi
  802dbe:	48 89 c7             	mov    %rax,%rdi
  802dc1:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802dd0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dd4:	79 05                	jns    802ddb <open+0x10d>
			{
				return d;
  802dd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd9:	eb 18                	jmp    802df3 <open+0x125>
			}
			return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	eb 13                	jmp    802df3 <open+0x125>
		}	
		return fd2num(fd_store);
  802de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de4:	48 89 c7             	mov    %rax,%rdi
  802de7:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 10          	sub    $0x10,%rsp
  802dfd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e05:	8b 50 0c             	mov    0xc(%rax),%edx
  802e08:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e0f:	00 00 00 
  802e12:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e14:	be 00 00 00 00       	mov    $0x0,%esi
  802e19:	bf 06 00 00 00       	mov    $0x6,%edi
  802e1e:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  802e25:	00 00 00 
  802e28:	ff d0                	callq  *%rax
}
  802e2a:	c9                   	leaveq 
  802e2b:	c3                   	retq   

0000000000802e2c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e2c:	55                   	push   %rbp
  802e2d:	48 89 e5             	mov    %rsp,%rbp
  802e30:	48 83 ec 30          	sub    $0x30,%rsp
  802e34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802e47:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e4c:	74 07                	je     802e55 <devfile_read+0x29>
  802e4e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e53:	75 07                	jne    802e5c <devfile_read+0x30>
		return -E_INVAL;
  802e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e5a:	eb 77                	jmp    802ed3 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e60:	8b 50 0c             	mov    0xc(%rax),%edx
  802e63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6a:	00 00 00 
  802e6d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e76:	00 00 00 
  802e79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e7d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802e81:	be 00 00 00 00       	mov    $0x0,%esi
  802e86:	bf 03 00 00 00       	mov    $0x3,%edi
  802e8b:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	callq  *%rax
  802e97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9e:	7f 05                	jg     802ea5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea3:	eb 2e                	jmp    802ed3 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	48 63 d0             	movslq %eax,%rdx
  802eab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802eb6:	00 00 00 
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ecc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ed3:	c9                   	leaveq 
  802ed4:	c3                   	retq   

0000000000802ed5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ed5:	55                   	push   %rbp
  802ed6:	48 89 e5             	mov    %rsp,%rbp
  802ed9:	48 83 ec 30          	sub    $0x30,%rsp
  802edd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ee5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802ee9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802ef0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ef5:	74 07                	je     802efe <devfile_write+0x29>
  802ef7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802efc:	75 08                	jne    802f06 <devfile_write+0x31>
		return r;
  802efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f01:	e9 9a 00 00 00       	jmpq   802fa0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0a:	8b 50 0c             	mov    0xc(%rax),%edx
  802f0d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f14:	00 00 00 
  802f17:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f19:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f20:	00 
  802f21:	76 08                	jbe    802f2b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f23:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f2a:	00 
	}
	fsipcbuf.write.req_n = n;
  802f2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f32:	00 00 00 
  802f35:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f39:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802f3d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f45:	48 89 c6             	mov    %rax,%rsi
  802f48:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f4f:	00 00 00 
  802f52:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f5e:	be 00 00 00 00       	mov    $0x0,%esi
  802f63:	bf 04 00 00 00       	mov    $0x4,%edi
  802f68:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
  802f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7b:	7f 20                	jg     802f9d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f7d:	48 bf 7e 4a 80 00 00 	movabs $0x804a7e,%rdi
  802f84:	00 00 00 
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8c:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  802f93:	00 00 00 
  802f96:	ff d2                	callq  *%rdx
		return r;
  802f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9b:	eb 03                	jmp    802fa0 <devfile_write+0xcb>
	}
	return r;
  802f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802fa0:	c9                   	leaveq 
  802fa1:	c3                   	retq   

0000000000802fa2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fa2:	55                   	push   %rbp
  802fa3:	48 89 e5             	mov    %rsp,%rbp
  802fa6:	48 83 ec 20          	sub    $0x20,%rsp
  802faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb6:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc0:	00 00 00 
  802fc3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fc5:	be 00 00 00 00       	mov    $0x0,%esi
  802fca:	bf 05 00 00 00       	mov    $0x5,%edi
  802fcf:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  802fd6:	00 00 00 
  802fd9:	ff d0                	callq  *%rax
  802fdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe2:	79 05                	jns    802fe9 <devfile_stat+0x47>
		return r;
  802fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe7:	eb 56                	jmp    80303f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fe9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fed:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ff4:	00 00 00 
  802ff7:	48 89 c7             	mov    %rax,%rdi
  802ffa:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  803001:	00 00 00 
  803004:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803006:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300d:	00 00 00 
  803010:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803016:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803020:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803027:	00 00 00 
  80302a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803030:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803034:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303f:	c9                   	leaveq 
  803040:	c3                   	retq   

0000000000803041 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803041:	55                   	push   %rbp
  803042:	48 89 e5             	mov    %rsp,%rbp
  803045:	48 83 ec 10          	sub    $0x10,%rsp
  803049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80304d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803054:	8b 50 0c             	mov    0xc(%rax),%edx
  803057:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305e:	00 00 00 
  803061:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803063:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80306a:	00 00 00 
  80306d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803073:	be 00 00 00 00       	mov    $0x0,%esi
  803078:	bf 02 00 00 00       	mov    $0x2,%edi
  80307d:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
}
  803089:	c9                   	leaveq 
  80308a:	c3                   	retq   

000000000080308b <remove>:

// Delete a file
int
remove(const char *path)
{
  80308b:	55                   	push   %rbp
  80308c:	48 89 e5             	mov    %rsp,%rbp
  80308f:	48 83 ec 10          	sub    $0x10,%rsp
  803093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803097:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309b:	48 89 c7             	mov    %rax,%rdi
  80309e:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030af:	7e 07                	jle    8030b8 <remove+0x2d>
		return -E_BAD_PATH;
  8030b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030b6:	eb 33                	jmp    8030eb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bc:	48 89 c6             	mov    %rax,%rsi
  8030bf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030c6:	00 00 00 
  8030c9:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030d5:	be 00 00 00 00       	mov    $0x0,%esi
  8030da:	bf 07 00 00 00       	mov    $0x7,%edi
  8030df:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030f1:	be 00 00 00 00       	mov    $0x0,%esi
  8030f6:	bf 08 00 00 00       	mov    $0x8,%edi
  8030fb:	48 b8 47 2c 80 00 00 	movabs $0x802c47,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
}
  803107:	5d                   	pop    %rbp
  803108:	c3                   	retq   

0000000000803109 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803114:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80311b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803122:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803129:	be 00 00 00 00       	mov    $0x0,%esi
  80312e:	48 89 c7             	mov    %rax,%rdi
  803131:	48 b8 ce 2c 80 00 00 	movabs $0x802cce,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803144:	79 28                	jns    80316e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803149:	89 c6                	mov    %eax,%esi
  80314b:	48 bf 9a 4a 80 00 00 	movabs $0x804a9a,%rdi
  803152:	00 00 00 
  803155:	b8 00 00 00 00       	mov    $0x0,%eax
  80315a:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  803161:	00 00 00 
  803164:	ff d2                	callq  *%rdx
		return fd_src;
  803166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803169:	e9 74 01 00 00       	jmpq   8032e2 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80316e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803175:	be 01 01 00 00       	mov    $0x101,%esi
  80317a:	48 89 c7             	mov    %rax,%rdi
  80317d:	48 b8 ce 2c 80 00 00 	movabs $0x802cce,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
  803189:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80318c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803190:	79 39                	jns    8031cb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803192:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803195:	89 c6                	mov    %eax,%esi
  803197:	48 bf b0 4a 80 00 00 	movabs $0x804ab0,%rdi
  80319e:	00 00 00 
  8031a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a6:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  8031ad:	00 00 00 
  8031b0:	ff d2                	callq  *%rdx
		close(fd_src);
  8031b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b5:	89 c7                	mov    %eax,%edi
  8031b7:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
		return fd_dest;
  8031c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031c6:	e9 17 01 00 00       	jmpq   8032e2 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031cb:	eb 74                	jmp    803241 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d0:	48 63 d0             	movslq %eax,%rdx
  8031d3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031dd:	48 89 ce             	mov    %rcx,%rsi
  8031e0:	89 c7                	mov    %eax,%edi
  8031e2:	48 b8 75 29 80 00 00 	movabs $0x802975,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	callq  *%rax
  8031ee:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031f5:	79 4a                	jns    803241 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8031f7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031fa:	89 c6                	mov    %eax,%esi
  8031fc:	48 bf ca 4a 80 00 00 	movabs $0x804aca,%rdi
  803203:	00 00 00 
  803206:	b8 00 00 00 00       	mov    $0x0,%eax
  80320b:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  803212:	00 00 00 
  803215:	ff d2                	callq  *%rdx
			close(fd_src);
  803217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321a:	89 c7                	mov    %eax,%edi
  80321c:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
			close(fd_dest);
  803228:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80322b:	89 c7                	mov    %eax,%edi
  80322d:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  803234:	00 00 00 
  803237:	ff d0                	callq  *%rax
			return write_size;
  803239:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80323c:	e9 a1 00 00 00       	jmpq   8032e2 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803241:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324b:	ba 00 02 00 00       	mov    $0x200,%edx
  803250:	48 89 ce             	mov    %rcx,%rsi
  803253:	89 c7                	mov    %eax,%edi
  803255:	48 b8 2b 28 80 00 00 	movabs $0x80282b,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803264:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803268:	0f 8f 5f ff ff ff    	jg     8031cd <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80326e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803272:	79 47                	jns    8032bb <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803277:	89 c6                	mov    %eax,%esi
  803279:	48 bf dd 4a 80 00 00 	movabs $0x804add,%rdi
  803280:	00 00 00 
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
  803288:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  80328f:	00 00 00 
  803292:	ff d2                	callq  *%rdx
		close(fd_src);
  803294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803297:	89 c7                	mov    %eax,%edi
  803299:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
		close(fd_dest);
  8032a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a8:	89 c7                	mov    %eax,%edi
  8032aa:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
		return read_size;
  8032b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032b9:	eb 27                	jmp    8032e2 <copy+0x1d9>
	}
	close(fd_src);
  8032bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032be:	89 c7                	mov    %eax,%edi
  8032c0:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
	close(fd_dest);
  8032cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032cf:	89 c7                	mov    %eax,%edi
  8032d1:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
	return 0;
  8032dd:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8032e2:	c9                   	leaveq 
  8032e3:	c3                   	retq   

00000000008032e4 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8032e4:	55                   	push   %rbp
  8032e5:	48 89 e5             	mov    %rsp,%rbp
  8032e8:	48 83 ec 20          	sub    $0x20,%rsp
  8032ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8032f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	7e 67                	jle    803362 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8032fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ff:	8b 40 04             	mov    0x4(%rax),%eax
  803302:	48 63 d0             	movslq %eax,%rdx
  803305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803309:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80330d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803311:	8b 00                	mov    (%rax),%eax
  803313:	48 89 ce             	mov    %rcx,%rsi
  803316:	89 c7                	mov    %eax,%edi
  803318:	48 b8 75 29 80 00 00 	movabs $0x802975,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
  803324:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803327:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332b:	7e 13                	jle    803340 <writebuf+0x5c>
			b->result += result;
  80332d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803331:	8b 50 08             	mov    0x8(%rax),%edx
  803334:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803337:	01 c2                	add    %eax,%edx
  803339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333d:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803344:	8b 40 04             	mov    0x4(%rax),%eax
  803347:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80334a:	74 16                	je     803362 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80334c:	b8 00 00 00 00       	mov    $0x0,%eax
  803351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803355:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803359:	89 c2                	mov    %eax,%edx
  80335b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335f:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803362:	c9                   	leaveq 
  803363:	c3                   	retq   

0000000000803364 <putch>:

static void
putch(int ch, void *thunk)
{
  803364:	55                   	push   %rbp
  803365:	48 89 e5             	mov    %rsp,%rbp
  803368:	48 83 ec 20          	sub    $0x20,%rsp
  80336c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80336f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803377:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80337b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337f:	8b 40 04             	mov    0x4(%rax),%eax
  803382:	8d 48 01             	lea    0x1(%rax),%ecx
  803385:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803389:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80338c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80338f:	89 d1                	mov    %edx,%ecx
  803391:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803395:	48 98                	cltq   
  803397:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80339b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339f:	8b 40 04             	mov    0x4(%rax),%eax
  8033a2:	3d 00 01 00 00       	cmp    $0x100,%eax
  8033a7:	75 1e                	jne    8033c7 <putch+0x63>
		writebuf(b);
  8033a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
		b->idx = 0;
  8033bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8033c7:	c9                   	leaveq 
  8033c8:	c3                   	retq   

00000000008033c9 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8033c9:	55                   	push   %rbp
  8033ca:	48 89 e5             	mov    %rsp,%rbp
  8033cd:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8033d4:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8033da:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8033e1:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8033e8:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8033ee:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8033f4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8033fb:	00 00 00 
	b.result = 0;
  8033fe:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803405:	00 00 00 
	b.error = 1;
  803408:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80340f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803412:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803419:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803420:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803427:	48 89 c6             	mov    %rax,%rsi
  80342a:	48 bf 64 33 80 00 00 	movabs $0x803364,%rdi
  803431:	00 00 00 
  803434:	48 b8 ad 0b 80 00 00 	movabs $0x800bad,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803440:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	7e 16                	jle    803460 <vfprintf+0x97>
		writebuf(&b);
  80344a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803451:	48 89 c7             	mov    %rax,%rdi
  803454:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803460:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 08                	je     803472 <vfprintf+0xa9>
  80346a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803470:	eb 06                	jmp    803478 <vfprintf+0xaf>
  803472:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803478:	c9                   	leaveq 
  803479:	c3                   	retq   

000000000080347a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80347a:	55                   	push   %rbp
  80347b:	48 89 e5             	mov    %rsp,%rbp
  80347e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803485:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80348b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803492:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803499:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8034a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8034a7:	84 c0                	test   %al,%al
  8034a9:	74 20                	je     8034cb <fprintf+0x51>
  8034ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8034af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8034b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8034b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8034bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8034bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8034c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8034c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8034cb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8034d2:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8034d9:	00 00 00 
  8034dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8034e3:	00 00 00 
  8034e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8034f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8034f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8034ff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803506:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80350d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803513:	48 89 ce             	mov    %rcx,%rsi
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 c9 33 80 00 00 	movabs $0x8033c9,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
  803524:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80352a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803530:	c9                   	leaveq 
  803531:	c3                   	retq   

0000000000803532 <printf>:

int
printf(const char *fmt, ...)
{
  803532:	55                   	push   %rbp
  803533:	48 89 e5             	mov    %rsp,%rbp
  803536:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80353d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803544:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80354b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803552:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803559:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803560:	84 c0                	test   %al,%al
  803562:	74 20                	je     803584 <printf+0x52>
  803564:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803568:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80356c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803570:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803574:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803578:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80357c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803580:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803584:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80358b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803592:	00 00 00 
  803595:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80359c:	00 00 00 
  80359f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035a3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8035aa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8035b1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8035b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035bf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8035c6:	48 89 c6             	mov    %rax,%rsi
  8035c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8035ce:	48 b8 c9 33 80 00 00 	movabs $0x8033c9,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
  8035da:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8035e0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8035e6:	c9                   	leaveq 
  8035e7:	c3                   	retq   

00000000008035e8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035e8:	55                   	push   %rbp
  8035e9:	48 89 e5             	mov    %rsp,%rbp
  8035ec:	53                   	push   %rbx
  8035ed:	48 83 ec 38          	sub    $0x38,%rsp
  8035f1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035f5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035f9:	48 89 c7             	mov    %rax,%rdi
  8035fc:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80360f:	0f 88 bf 01 00 00    	js     8037d4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803619:	ba 07 04 00 00       	mov    $0x407,%edx
  80361e:	48 89 c6             	mov    %rax,%rsi
  803621:	bf 00 00 00 00       	mov    $0x0,%edi
  803626:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
  803632:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803635:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803639:	0f 88 95 01 00 00    	js     8037d4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80363f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803643:	48 89 c7             	mov    %rax,%rdi
  803646:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
  803652:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803655:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803659:	0f 88 5d 01 00 00    	js     8037bc <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80365f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803663:	ba 07 04 00 00       	mov    $0x407,%edx
  803668:	48 89 c6             	mov    %rax,%rsi
  80366b:	bf 00 00 00 00       	mov    $0x0,%edi
  803670:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
  80367c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803683:	0f 88 33 01 00 00    	js     8037bc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368d:	48 89 c7             	mov    %rax,%rdi
  803690:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
  80369c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a4:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a9:	48 89 c6             	mov    %rax,%rsi
  8036ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b1:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
  8036bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c4:	79 05                	jns    8036cb <pipe+0xe3>
		goto err2;
  8036c6:	e9 d9 00 00 00       	jmpq   8037a4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036cf:	48 89 c7             	mov    %rax,%rdi
  8036d2:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
  8036de:	48 89 c2             	mov    %rax,%rdx
  8036e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036eb:	48 89 d1             	mov    %rdx,%rcx
  8036ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f3:	48 89 c6             	mov    %rax,%rsi
  8036f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fb:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
  803707:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80370a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80370e:	79 1b                	jns    80372b <pipe+0x143>
		goto err3;
  803710:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803715:	48 89 c6             	mov    %rax,%rsi
  803718:	bf 00 00 00 00       	mov    $0x0,%edi
  80371d:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	eb 79                	jmp    8037a4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80372b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803736:	00 00 00 
  803739:	8b 12                	mov    (%rdx),%edx
  80373b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80373d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803741:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803748:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803753:	00 00 00 
  803756:	8b 12                	mov    (%rdx),%edx
  803758:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80375a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803769:	48 89 c7             	mov    %rax,%rdi
  80376c:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
  803778:	89 c2                	mov    %eax,%edx
  80377a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80377e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803780:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803784:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803788:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80378c:	48 89 c7             	mov    %rax,%rdi
  80378f:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
  80379b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80379d:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a2:	eb 33                	jmp    8037d7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a8:	48 89 c6             	mov    %rax,%rsi
  8037ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b0:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  8037b7:	00 00 00 
  8037ba:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c0:	48 89 c6             	mov    %rax,%rsi
  8037c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c8:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  8037cf:	00 00 00 
  8037d2:	ff d0                	callq  *%rax
err:
	return r;
  8037d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037d7:	48 83 c4 38          	add    $0x38,%rsp
  8037db:	5b                   	pop    %rbx
  8037dc:	5d                   	pop    %rbp
  8037dd:	c3                   	retq   

00000000008037de <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037de:	55                   	push   %rbp
  8037df:	48 89 e5             	mov    %rsp,%rbp
  8037e2:	53                   	push   %rbx
  8037e3:	48 83 ec 28          	sub    $0x28,%rsp
  8037e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037ef:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8037f6:	00 00 00 
  8037f9:	48 8b 00             	mov    (%rax),%rax
  8037fc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803802:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 a1 43 80 00 00 	movabs $0x8043a1,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
  803818:	89 c3                	mov    %eax,%ebx
  80381a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80381e:	48 89 c7             	mov    %rax,%rdi
  803821:	48 b8 a1 43 80 00 00 	movabs $0x8043a1,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
  80382d:	39 c3                	cmp    %eax,%ebx
  80382f:	0f 94 c0             	sete   %al
  803832:	0f b6 c0             	movzbl %al,%eax
  803835:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803838:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80383f:	00 00 00 
  803842:	48 8b 00             	mov    (%rax),%rax
  803845:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80384b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80384e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803851:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803854:	75 05                	jne    80385b <_pipeisclosed+0x7d>
			return ret;
  803856:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803859:	eb 4f                	jmp    8038aa <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80385b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803861:	74 42                	je     8038a5 <_pipeisclosed+0xc7>
  803863:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803867:	75 3c                	jne    8038a5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803869:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803870:	00 00 00 
  803873:	48 8b 00             	mov    (%rax),%rax
  803876:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80387c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80387f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803882:	89 c6                	mov    %eax,%esi
  803884:	48 bf fd 4a 80 00 00 	movabs $0x804afd,%rdi
  80388b:	00 00 00 
  80388e:	b8 00 00 00 00       	mov    $0x0,%eax
  803893:	49 b8 fa 07 80 00 00 	movabs $0x8007fa,%r8
  80389a:	00 00 00 
  80389d:	41 ff d0             	callq  *%r8
	}
  8038a0:	e9 4a ff ff ff       	jmpq   8037ef <_pipeisclosed+0x11>
  8038a5:	e9 45 ff ff ff       	jmpq   8037ef <_pipeisclosed+0x11>
}
  8038aa:	48 83 c4 28          	add    $0x28,%rsp
  8038ae:	5b                   	pop    %rbx
  8038af:	5d                   	pop    %rbp
  8038b0:	c3                   	retq   

00000000008038b1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038b1:	55                   	push   %rbp
  8038b2:	48 89 e5             	mov    %rsp,%rbp
  8038b5:	48 83 ec 30          	sub    $0x30,%rsp
  8038b9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038c3:	48 89 d6             	mov    %rdx,%rsi
  8038c6:	89 c7                	mov    %eax,%edi
  8038c8:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	callq  *%rax
  8038d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038db:	79 05                	jns    8038e2 <pipeisclosed+0x31>
		return r;
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	eb 31                	jmp    803913 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e6:	48 89 c7             	mov    %rax,%rdi
  8038e9:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803901:	48 89 d6             	mov    %rdx,%rsi
  803904:	48 89 c7             	mov    %rax,%rdi
  803907:	48 b8 de 37 80 00 00 	movabs $0x8037de,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
}
  803913:	c9                   	leaveq 
  803914:	c3                   	retq   

0000000000803915 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803915:	55                   	push   %rbp
  803916:	48 89 e5             	mov    %rsp,%rbp
  803919:	48 83 ec 40          	sub    $0x40,%rsp
  80391d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803921:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803925:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392d:	48 89 c7             	mov    %rax,%rdi
  803930:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
  80393c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803944:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803948:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80394f:	00 
  803950:	e9 92 00 00 00       	jmpq   8039e7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803955:	eb 41                	jmp    803998 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803957:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80395c:	74 09                	je     803967 <devpipe_read+0x52>
				return i;
  80395e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803962:	e9 92 00 00 00       	jmpq   8039f9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80396b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396f:	48 89 d6             	mov    %rdx,%rsi
  803972:	48 89 c7             	mov    %rax,%rdi
  803975:	48 b8 de 37 80 00 00 	movabs $0x8037de,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 07                	je     80398c <devpipe_read+0x77>
				return 0;
  803985:	b8 00 00 00 00       	mov    $0x0,%eax
  80398a:	eb 6d                	jmp    8039f9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80398c:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399c:	8b 10                	mov    (%rax),%edx
  80399e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a2:	8b 40 04             	mov    0x4(%rax),%eax
  8039a5:	39 c2                	cmp    %eax,%edx
  8039a7:	74 ae                	je     803957 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039b1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b9:	8b 00                	mov    (%rax),%eax
  8039bb:	99                   	cltd   
  8039bc:	c1 ea 1b             	shr    $0x1b,%edx
  8039bf:	01 d0                	add    %edx,%eax
  8039c1:	83 e0 1f             	and    $0x1f,%eax
  8039c4:	29 d0                	sub    %edx,%eax
  8039c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039ca:	48 98                	cltq   
  8039cc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039d1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d7:	8b 00                	mov    (%rax),%eax
  8039d9:	8d 50 01             	lea    0x1(%rax),%edx
  8039dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039ef:	0f 82 60 ff ff ff    	jb     803955 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039f9:	c9                   	leaveq 
  8039fa:	c3                   	retq   

00000000008039fb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039fb:	55                   	push   %rbp
  8039fc:	48 89 e5             	mov    %rsp,%rbp
  8039ff:	48 83 ec 40          	sub    $0x40,%rsp
  803a03:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a13:	48 89 c7             	mov    %rax,%rdi
  803a16:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
  803a22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a2e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a35:	00 
  803a36:	e9 8e 00 00 00       	jmpq   803ac9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a3b:	eb 31                	jmp    803a6e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a45:	48 89 d6             	mov    %rdx,%rsi
  803a48:	48 89 c7             	mov    %rax,%rdi
  803a4b:	48 b8 de 37 80 00 00 	movabs $0x8037de,%rax
  803a52:	00 00 00 
  803a55:	ff d0                	callq  *%rax
  803a57:	85 c0                	test   %eax,%eax
  803a59:	74 07                	je     803a62 <devpipe_write+0x67>
				return 0;
  803a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a60:	eb 79                	jmp    803adb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a62:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a72:	8b 40 04             	mov    0x4(%rax),%eax
  803a75:	48 63 d0             	movslq %eax,%rdx
  803a78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7c:	8b 00                	mov    (%rax),%eax
  803a7e:	48 98                	cltq   
  803a80:	48 83 c0 20          	add    $0x20,%rax
  803a84:	48 39 c2             	cmp    %rax,%rdx
  803a87:	73 b4                	jae    803a3d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8d:	8b 40 04             	mov    0x4(%rax),%eax
  803a90:	99                   	cltd   
  803a91:	c1 ea 1b             	shr    $0x1b,%edx
  803a94:	01 d0                	add    %edx,%eax
  803a96:	83 e0 1f             	and    $0x1f,%eax
  803a99:	29 d0                	sub    %edx,%eax
  803a9b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a9f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803aa3:	48 01 ca             	add    %rcx,%rdx
  803aa6:	0f b6 0a             	movzbl (%rdx),%ecx
  803aa9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aad:	48 98                	cltq   
  803aaf:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ab3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab7:	8b 40 04             	mov    0x4(%rax),%eax
  803aba:	8d 50 01             	lea    0x1(%rax),%edx
  803abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ac4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803acd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ad1:	0f 82 64 ff ff ff    	jb     803a3b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803adb:	c9                   	leaveq 
  803adc:	c3                   	retq   

0000000000803add <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803add:	55                   	push   %rbp
  803ade:	48 89 e5             	mov    %rsp,%rbp
  803ae1:	48 83 ec 20          	sub    $0x20,%rsp
  803ae5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ae9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803aed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af1:	48 89 c7             	mov    %rax,%rdi
  803af4:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
  803b00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b08:	48 be 10 4b 80 00 00 	movabs $0x804b10,%rsi
  803b0f:	00 00 00 
  803b12:	48 89 c7             	mov    %rax,%rdi
  803b15:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b25:	8b 50 04             	mov    0x4(%rax),%edx
  803b28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2c:	8b 00                	mov    (%rax),%eax
  803b2e:	29 c2                	sub    %eax,%edx
  803b30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b34:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b3e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b45:	00 00 00 
	stat->st_dev = &devpipe;
  803b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b53:	00 00 00 
  803b56:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b62:	c9                   	leaveq 
  803b63:	c3                   	retq   

0000000000803b64 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b64:	55                   	push   %rbp
  803b65:	48 89 e5             	mov    %rsp,%rbp
  803b68:	48 83 ec 10          	sub    $0x10,%rsp
  803b6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b74:	48 89 c6             	mov    %rax,%rsi
  803b77:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7c:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8c:	48 89 c7             	mov    %rax,%rdi
  803b8f:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
  803b9b:	48 89 c6             	mov    %rax,%rsi
  803b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba3:	48 b8 89 1d 80 00 00 	movabs $0x801d89,%rax
  803baa:	00 00 00 
  803bad:	ff d0                	callq  *%rax
}
  803baf:	c9                   	leaveq 
  803bb0:	c3                   	retq   

0000000000803bb1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bb1:	55                   	push   %rbp
  803bb2:	48 89 e5             	mov    %rsp,%rbp
  803bb5:	48 83 ec 20          	sub    $0x20,%rsp
  803bb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bbf:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bc2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bc6:	be 01 00 00 00       	mov    $0x1,%esi
  803bcb:	48 89 c7             	mov    %rax,%rdi
  803bce:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
}
  803bda:	c9                   	leaveq 
  803bdb:	c3                   	retq   

0000000000803bdc <getchar>:

int
getchar(void)
{
  803bdc:	55                   	push   %rbp
  803bdd:	48 89 e5             	mov    %rsp,%rbp
  803be0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803be4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803be8:	ba 01 00 00 00       	mov    $0x1,%edx
  803bed:	48 89 c6             	mov    %rax,%rsi
  803bf0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf5:	48 b8 2b 28 80 00 00 	movabs $0x80282b,%rax
  803bfc:	00 00 00 
  803bff:	ff d0                	callq  *%rax
  803c01:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c08:	79 05                	jns    803c0f <getchar+0x33>
		return r;
  803c0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0d:	eb 14                	jmp    803c23 <getchar+0x47>
	if (r < 1)
  803c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c13:	7f 07                	jg     803c1c <getchar+0x40>
		return -E_EOF;
  803c15:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c1a:	eb 07                	jmp    803c23 <getchar+0x47>
	return c;
  803c1c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c20:	0f b6 c0             	movzbl %al,%eax
}
  803c23:	c9                   	leaveq 
  803c24:	c3                   	retq   

0000000000803c25 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c25:	55                   	push   %rbp
  803c26:	48 89 e5             	mov    %rsp,%rbp
  803c29:	48 83 ec 20          	sub    $0x20,%rsp
  803c2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c37:	48 89 d6             	mov    %rdx,%rsi
  803c3a:	89 c7                	mov    %eax,%edi
  803c3c:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
  803c48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4f:	79 05                	jns    803c56 <iscons+0x31>
		return r;
  803c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c54:	eb 1a                	jmp    803c70 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5a:	8b 10                	mov    (%rax),%edx
  803c5c:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c63:	00 00 00 
  803c66:	8b 00                	mov    (%rax),%eax
  803c68:	39 c2                	cmp    %eax,%edx
  803c6a:	0f 94 c0             	sete   %al
  803c6d:	0f b6 c0             	movzbl %al,%eax
}
  803c70:	c9                   	leaveq 
  803c71:	c3                   	retq   

0000000000803c72 <opencons>:

int
opencons(void)
{
  803c72:	55                   	push   %rbp
  803c73:	48 89 e5             	mov    %rsp,%rbp
  803c76:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c7a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c7e:	48 89 c7             	mov    %rax,%rdi
  803c81:	48 b8 61 23 80 00 00 	movabs $0x802361,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
  803c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c94:	79 05                	jns    803c9b <opencons+0x29>
		return r;
  803c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c99:	eb 5b                	jmp    803cf6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9f:	ba 07 04 00 00       	mov    $0x407,%edx
  803ca4:	48 89 c6             	mov    %rax,%rsi
  803ca7:	bf 00 00 00 00       	mov    $0x0,%edi
  803cac:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
  803cb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cbf:	79 05                	jns    803cc6 <opencons+0x54>
		return r;
  803cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc4:	eb 30                	jmp    803cf6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cca:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cd1:	00 00 00 
  803cd4:	8b 12                	mov    (%rdx),%edx
  803cd6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce7:	48 89 c7             	mov    %rax,%rdi
  803cea:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  803cf1:	00 00 00 
  803cf4:	ff d0                	callq  *%rax
}
  803cf6:	c9                   	leaveq 
  803cf7:	c3                   	retq   

0000000000803cf8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cf8:	55                   	push   %rbp
  803cf9:	48 89 e5             	mov    %rsp,%rbp
  803cfc:	48 83 ec 30          	sub    $0x30,%rsp
  803d00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d08:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d0c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d11:	75 07                	jne    803d1a <devcons_read+0x22>
		return 0;
  803d13:	b8 00 00 00 00       	mov    $0x0,%eax
  803d18:	eb 4b                	jmp    803d65 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d1a:	eb 0c                	jmp    803d28 <devcons_read+0x30>
		sys_yield();
  803d1c:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d28:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
  803d34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3b:	74 df                	je     803d1c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d41:	79 05                	jns    803d48 <devcons_read+0x50>
		return c;
  803d43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d46:	eb 1d                	jmp    803d65 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d48:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d4c:	75 07                	jne    803d55 <devcons_read+0x5d>
		return 0;
  803d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d53:	eb 10                	jmp    803d65 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d58:	89 c2                	mov    %eax,%edx
  803d5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5e:	88 10                	mov    %dl,(%rax)
	return 1;
  803d60:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d65:	c9                   	leaveq 
  803d66:	c3                   	retq   

0000000000803d67 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d67:	55                   	push   %rbp
  803d68:	48 89 e5             	mov    %rsp,%rbp
  803d6b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d72:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d79:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d80:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d8e:	eb 76                	jmp    803e06 <devcons_write+0x9f>
		m = n - tot;
  803d90:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d97:	89 c2                	mov    %eax,%edx
  803d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d9c:	29 c2                	sub    %eax,%edx
  803d9e:	89 d0                	mov    %edx,%eax
  803da0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803da3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da6:	83 f8 7f             	cmp    $0x7f,%eax
  803da9:	76 07                	jbe    803db2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dab:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803db2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803db5:	48 63 d0             	movslq %eax,%rdx
  803db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbb:	48 63 c8             	movslq %eax,%rcx
  803dbe:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803dc5:	48 01 c1             	add    %rax,%rcx
  803dc8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dcf:	48 89 ce             	mov    %rcx,%rsi
  803dd2:	48 89 c7             	mov    %rax,%rdi
  803dd5:	48 b8 d3 16 80 00 00 	movabs $0x8016d3,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de4:	48 63 d0             	movslq %eax,%rdx
  803de7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dee:	48 89 d6             	mov    %rdx,%rsi
  803df1:	48 89 c7             	mov    %rax,%rdi
  803df4:	48 b8 96 1b 80 00 00 	movabs $0x801b96,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e03:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e09:	48 98                	cltq   
  803e0b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e12:	0f 82 78 ff ff ff    	jb     803d90 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e1b:	c9                   	leaveq 
  803e1c:	c3                   	retq   

0000000000803e1d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e1d:	55                   	push   %rbp
  803e1e:	48 89 e5             	mov    %rsp,%rbp
  803e21:	48 83 ec 08          	sub    $0x8,%rsp
  803e25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e2e:	c9                   	leaveq 
  803e2f:	c3                   	retq   

0000000000803e30 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e30:	55                   	push   %rbp
  803e31:	48 89 e5             	mov    %rsp,%rbp
  803e34:	48 83 ec 10          	sub    $0x10,%rsp
  803e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e44:	48 be 1c 4b 80 00 00 	movabs $0x804b1c,%rsi
  803e4b:	00 00 00 
  803e4e:	48 89 c7             	mov    %rax,%rdi
  803e51:	48 b8 af 13 80 00 00 	movabs $0x8013af,%rax
  803e58:	00 00 00 
  803e5b:	ff d0                	callq  *%rax
	return 0;
  803e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e62:	c9                   	leaveq 
  803e63:	c3                   	retq   

0000000000803e64 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e64:	55                   	push   %rbp
  803e65:	48 89 e5             	mov    %rsp,%rbp
  803e68:	48 83 ec 30          	sub    $0x30,%rsp
  803e6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e74:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e78:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803e7f:	00 00 00 
  803e82:	48 8b 00             	mov    (%rax),%rax
  803e85:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e8b:	85 c0                	test   %eax,%eax
  803e8d:	75 34                	jne    803ec3 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803e8f:	48 b8 62 1c 80 00 00 	movabs $0x801c62,%rax
  803e96:	00 00 00 
  803e99:	ff d0                	callq  *%rax
  803e9b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ea0:	48 98                	cltq   
  803ea2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803ea9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803eb0:	00 00 00 
  803eb3:	48 01 c2             	add    %rax,%rdx
  803eb6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ebd:	00 00 00 
  803ec0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803ec3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ec8:	75 0e                	jne    803ed8 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803eca:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ed1:	00 00 00 
  803ed4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ed8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803edc:	48 89 c7             	mov    %rax,%rdi
  803edf:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  803ee6:	00 00 00 
  803ee9:	ff d0                	callq  *%rax
  803eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef2:	79 19                	jns    803f0d <ipc_recv+0xa9>
		*from_env_store = 0;
  803ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f02:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0b:	eb 53                	jmp    803f60 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803f0d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f12:	74 19                	je     803f2d <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803f14:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f1b:	00 00 00 
  803f1e:	48 8b 00             	mov    (%rax),%rax
  803f21:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f2d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f32:	74 19                	je     803f4d <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803f34:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f3b:	00 00 00 
  803f3e:	48 8b 00             	mov    (%rax),%rax
  803f41:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f4d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803f54:	00 00 00 
  803f57:	48 8b 00             	mov    (%rax),%rax
  803f5a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f60:	c9                   	leaveq 
  803f61:	c3                   	retq   

0000000000803f62 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f62:	55                   	push   %rbp
  803f63:	48 89 e5             	mov    %rsp,%rbp
  803f66:	48 83 ec 30          	sub    $0x30,%rsp
  803f6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f6d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f70:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f74:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f77:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f7c:	75 0e                	jne    803f8c <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f7e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f85:	00 00 00 
  803f88:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803f8c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f8f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f99:	89 c7                	mov    %eax,%edi
  803f9b:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
  803fa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803faa:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fae:	75 0c                	jne    803fbc <ipc_send+0x5a>
			sys_yield();
  803fb0:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  803fb7:	00 00 00 
  803fba:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803fbc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fc0:	74 ca                	je     803f8c <ipc_send+0x2a>
	if(result != 0)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	74 20                	je     803fe8 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcb:	89 c6                	mov    %eax,%esi
  803fcd:	48 bf 28 4b 80 00 00 	movabs $0x804b28,%rdi
  803fd4:	00 00 00 
  803fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fdc:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  803fe3:	00 00 00 
  803fe6:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803fe8:	c9                   	leaveq 
  803fe9:	c3                   	retq   

0000000000803fea <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803fea:	55                   	push   %rbp
  803feb:	48 89 e5             	mov    %rsp,%rbp
  803fee:	53                   	push   %rbx
  803fef:	48 83 ec 58          	sub    $0x58,%rsp
  803ff3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803ff7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ffb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803fff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804006:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80400d:	00 
  80400e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804012:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804016:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80401a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80401e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804022:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804026:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80402a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80402e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804032:	48 c1 e8 27          	shr    $0x27,%rax
  804036:	48 89 c2             	mov    %rax,%rdx
  804039:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804040:	01 00 00 
  804043:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804047:	83 e0 01             	and    $0x1,%eax
  80404a:	48 85 c0             	test   %rax,%rax
  80404d:	0f 85 91 00 00 00    	jne    8040e4 <ipc_host_recv+0xfa>
  804053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804057:	48 c1 e8 1e          	shr    $0x1e,%rax
  80405b:	48 89 c2             	mov    %rax,%rdx
  80405e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804065:	01 00 00 
  804068:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80406c:	83 e0 01             	and    $0x1,%eax
  80406f:	48 85 c0             	test   %rax,%rax
  804072:	74 70                	je     8040e4 <ipc_host_recv+0xfa>
  804074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804078:	48 c1 e8 15          	shr    $0x15,%rax
  80407c:	48 89 c2             	mov    %rax,%rdx
  80407f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804086:	01 00 00 
  804089:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80408d:	83 e0 01             	and    $0x1,%eax
  804090:	48 85 c0             	test   %rax,%rax
  804093:	74 4f                	je     8040e4 <ipc_host_recv+0xfa>
  804095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804099:	48 c1 e8 0c          	shr    $0xc,%rax
  80409d:	48 89 c2             	mov    %rax,%rdx
  8040a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040a7:	01 00 00 
  8040aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ae:	83 e0 01             	and    $0x1,%eax
  8040b1:	48 85 c0             	test   %rax,%rax
  8040b4:	74 2e                	je     8040e4 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8040bf:	48 89 c6             	mov    %rax,%rsi
  8040c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c7:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  8040ce:	00 00 00 
  8040d1:	ff d0                	callq  *%rax
  8040d3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8040d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8040da:	79 08                	jns    8040e4 <ipc_host_recv+0xfa>
	    	return result;
  8040dc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8040df:	e9 84 00 00 00       	jmpq   804168 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8040e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ec:	48 89 c2             	mov    %rax,%rdx
  8040ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040f6:	01 00 00 
  8040f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040fd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804103:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  804107:	b8 03 00 00 00       	mov    $0x3,%eax
  80410c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  804110:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804114:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  804118:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80411c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804120:	4c 89 c3             	mov    %r8,%rbx
  804123:	0f 01 c1             	vmcall 
  804126:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  804129:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80412d:	7e 36                	jle    804165 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  80412f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804132:	41 89 c0             	mov    %eax,%r8d
  804135:	b9 03 00 00 00       	mov    $0x3,%ecx
  80413a:	48 ba 40 4b 80 00 00 	movabs $0x804b40,%rdx
  804141:	00 00 00 
  804144:	be 67 00 00 00       	mov    $0x67,%esi
  804149:	48 bf 6d 4b 80 00 00 	movabs $0x804b6d,%rdi
  804150:	00 00 00 
  804153:	b8 00 00 00 00       	mov    $0x0,%eax
  804158:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  80415f:	00 00 00 
  804162:	41 ff d1             	callq  *%r9
	return result;
  804165:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  804168:	48 83 c4 58          	add    $0x58,%rsp
  80416c:	5b                   	pop    %rbx
  80416d:	5d                   	pop    %rbp
  80416e:	c3                   	retq   

000000000080416f <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80416f:	55                   	push   %rbp
  804170:	48 89 e5             	mov    %rsp,%rbp
  804173:	53                   	push   %rbx
  804174:	48 83 ec 68          	sub    $0x68,%rsp
  804178:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80417b:	89 75 a8             	mov    %esi,-0x58(%rbp)
  80417e:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804182:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804185:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804189:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80418d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804194:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80419b:	00 
  80419c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8041a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8041a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8041ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8041b4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8041b8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8041bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c0:	48 c1 e8 27          	shr    $0x27,%rax
  8041c4:	48 89 c2             	mov    %rax,%rdx
  8041c7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8041ce:	01 00 00 
  8041d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041d5:	83 e0 01             	and    $0x1,%eax
  8041d8:	48 85 c0             	test   %rax,%rax
  8041db:	0f 85 88 00 00 00    	jne    804269 <ipc_host_send+0xfa>
  8041e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041e5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8041e9:	48 89 c2             	mov    %rax,%rdx
  8041ec:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041f3:	01 00 00 
  8041f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041fa:	83 e0 01             	and    $0x1,%eax
  8041fd:	48 85 c0             	test   %rax,%rax
  804200:	74 67                	je     804269 <ipc_host_send+0xfa>
  804202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804206:	48 c1 e8 15          	shr    $0x15,%rax
  80420a:	48 89 c2             	mov    %rax,%rdx
  80420d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804214:	01 00 00 
  804217:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80421b:	83 e0 01             	and    $0x1,%eax
  80421e:	48 85 c0             	test   %rax,%rax
  804221:	74 46                	je     804269 <ipc_host_send+0xfa>
  804223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804227:	48 c1 e8 0c          	shr    $0xc,%rax
  80422b:	48 89 c2             	mov    %rax,%rdx
  80422e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804235:	01 00 00 
  804238:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80423c:	83 e0 01             	and    $0x1,%eax
  80423f:	48 85 c0             	test   %rax,%rax
  804242:	74 25                	je     804269 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804248:	48 c1 e8 0c          	shr    $0xc,%rax
  80424c:	48 89 c2             	mov    %rax,%rdx
  80424f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804256:	01 00 00 
  804259:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80425d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804263:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804267:	eb 0e                	jmp    804277 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  804269:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804270:	00 00 00 
  804273:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427b:	48 89 c6             	mov    %rax,%rsi
  80427e:	48 bf 77 4b 80 00 00 	movabs $0x804b77,%rdi
  804285:	00 00 00 
  804288:	b8 00 00 00 00       	mov    $0x0,%eax
  80428d:	48 ba fa 07 80 00 00 	movabs $0x8007fa,%rdx
  804294:	00 00 00 
  804297:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  804299:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80429c:	48 98                	cltq   
  80429e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  8042a2:	8b 45 a8             	mov    -0x58(%rbp),%eax
  8042a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  8042a9:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8042ac:	48 98                	cltq   
  8042ae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  8042b2:	b8 02 00 00 00       	mov    $0x2,%eax
  8042b7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8042bb:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8042bf:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8042c3:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8042c7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8042cb:	4c 89 c3             	mov    %r8,%rbx
  8042ce:	0f 01 c1             	vmcall 
  8042d1:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  8042d4:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8042d8:	75 0c                	jne    8042e6 <ipc_host_send+0x177>
			sys_yield();
  8042da:	48 b8 a0 1c 80 00 00 	movabs $0x801ca0,%rax
  8042e1:	00 00 00 
  8042e4:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8042e6:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8042ea:	74 c6                	je     8042b2 <ipc_host_send+0x143>
	
	if(result !=0)
  8042ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8042f0:	74 36                	je     804328 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  8042f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042f5:	41 89 c0             	mov    %eax,%r8d
  8042f8:	b9 02 00 00 00       	mov    $0x2,%ecx
  8042fd:	48 ba 40 4b 80 00 00 	movabs $0x804b40,%rdx
  804304:	00 00 00 
  804307:	be 94 00 00 00       	mov    $0x94,%esi
  80430c:	48 bf 6d 4b 80 00 00 	movabs $0x804b6d,%rdi
  804313:	00 00 00 
  804316:	b8 00 00 00 00       	mov    $0x0,%eax
  80431b:	49 b9 c1 05 80 00 00 	movabs $0x8005c1,%r9
  804322:	00 00 00 
  804325:	41 ff d1             	callq  *%r9
}
  804328:	48 83 c4 68          	add    $0x68,%rsp
  80432c:	5b                   	pop    %rbx
  80432d:	5d                   	pop    %rbp
  80432e:	c3                   	retq   

000000000080432f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80432f:	55                   	push   %rbp
  804330:	48 89 e5             	mov    %rsp,%rbp
  804333:	48 83 ec 14          	sub    $0x14,%rsp
  804337:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80433a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804341:	eb 4e                	jmp    804391 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804343:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80434a:	00 00 00 
  80434d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804350:	48 98                	cltq   
  804352:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804359:	48 01 d0             	add    %rdx,%rax
  80435c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804362:	8b 00                	mov    (%rax),%eax
  804364:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804367:	75 24                	jne    80438d <ipc_find_env+0x5e>
			return envs[i].env_id;
  804369:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804370:	00 00 00 
  804373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804376:	48 98                	cltq   
  804378:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80437f:	48 01 d0             	add    %rdx,%rax
  804382:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804388:	8b 40 08             	mov    0x8(%rax),%eax
  80438b:	eb 12                	jmp    80439f <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80438d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804391:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804398:	7e a9                	jle    804343 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80439a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80439f:	c9                   	leaveq 
  8043a0:	c3                   	retq   

00000000008043a1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8043a1:	55                   	push   %rbp
  8043a2:	48 89 e5             	mov    %rsp,%rbp
  8043a5:	48 83 ec 18          	sub    $0x18,%rsp
  8043a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8043ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043b1:	48 c1 e8 15          	shr    $0x15,%rax
  8043b5:	48 89 c2             	mov    %rax,%rdx
  8043b8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043bf:	01 00 00 
  8043c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043c6:	83 e0 01             	and    $0x1,%eax
  8043c9:	48 85 c0             	test   %rax,%rax
  8043cc:	75 07                	jne    8043d5 <pageref+0x34>
		return 0;
  8043ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d3:	eb 53                	jmp    804428 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8043dd:	48 89 c2             	mov    %rax,%rdx
  8043e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043e7:	01 00 00 
  8043ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f6:	83 e0 01             	and    $0x1,%eax
  8043f9:	48 85 c0             	test   %rax,%rax
  8043fc:	75 07                	jne    804405 <pageref+0x64>
		return 0;
  8043fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804403:	eb 23                	jmp    804428 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804409:	48 c1 e8 0c          	shr    $0xc,%rax
  80440d:	48 89 c2             	mov    %rax,%rdx
  804410:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804417:	00 00 00 
  80441a:	48 c1 e2 04          	shl    $0x4,%rdx
  80441e:	48 01 d0             	add    %rdx,%rax
  804421:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804425:	0f b7 c0             	movzwl %ax,%eax
}
  804428:	c9                   	leaveq 
  804429:	c3                   	retq   
