
vmm/guest/obj/user/testkbd:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 40 3f 80 00 00 	movabs $0x803f40,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf 4d 3f 80 00 00 	movabs $0x803f4d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 5c 3f 80 00 00 	movabs $0x803f5c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 4d 3f 80 00 00 	movabs $0x803f4d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba 76 3f 80 00 00 	movabs $0x803f76,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf 4d 3f 80 00 00 	movabs $0x803f4d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf 7e 3f 80 00 00 	movabs $0x803f7e,%rdi
  800153:	00 00 00 
  800156:	48 b8 93 12 80 00 00 	movabs $0x801293,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be 8c 3f 80 00 00 	movabs $0x803f8c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 3f 32 80 00 00 	movabs $0x80323f,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 90 3f 80 00 00 	movabs $0x803f90,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 3f 32 80 00 00 	movabs $0x80323f,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 f0 25 80 00 00 	movabs $0x8025f0,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 8a 1c 80 00 00 	movabs $0x801c8a,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be ad 3f 80 00 00 	movabs $0x803fad,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80047a:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048b:	48 98                	cltq   
  80048d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800494:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80049b:	00 00 00 
  80049e:	48 01 c2             	add    %rax,%rdx
  8004a1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004a8:	00 00 00 
  8004ab:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004b2:	7e 14                	jle    8004c8 <libmain+0x5d>
		binaryname = argv[0];
  8004b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b8:	48 8b 10             	mov    (%rax),%rdx
  8004bb:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004c2:	00 00 00 
  8004c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004cf:	48 89 d6             	mov    %rdx,%rsi
  8004d2:	89 c7                	mov    %eax,%edi
  8004d4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004db:	00 00 00 
  8004de:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8004e0:	48 b8 ee 04 80 00 00 	movabs $0x8004ee,%rax
  8004e7:	00 00 00 
  8004ea:	ff d0                	callq  *%rax
}
  8004ec:	c9                   	leaveq 
  8004ed:	c3                   	retq   

00000000008004ee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004f2:	48 b8 19 24 80 00 00 	movabs $0x802419,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800503:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax

}
  80050f:	5d                   	pop    %rbp
  800510:	c3                   	retq   

0000000000800511 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800511:	55                   	push   %rbp
  800512:	48 89 e5             	mov    %rsp,%rbp
  800515:	53                   	push   %rbx
  800516:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800524:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80052a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800531:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800538:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053f:	84 c0                	test   %al,%al
  800541:	74 23                	je     800566 <_panic+0x55>
  800543:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80054a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80054e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800552:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800556:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80055a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80055e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800562:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800566:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800574:	00 00 00 
  800577:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057e:	00 00 00 
  800581:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800585:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800593:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059a:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005a1:	00 00 00 
  8005a4:	48 8b 18             	mov    (%rax),%rbx
  8005a7:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8005ae:	00 00 00 
  8005b1:	ff d0                	callq  *%rax
  8005b3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c0:	41 89 c8             	mov    %ecx,%r8d
  8005c3:	48 89 d1             	mov    %rdx,%rcx
  8005c6:	48 89 da             	mov    %rbx,%rdx
  8005c9:	89 c6                	mov    %eax,%esi
  8005cb:	48 bf c0 3f 80 00 00 	movabs $0x803fc0,%rdi
  8005d2:	00 00 00 
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	49 b9 4a 07 80 00 00 	movabs $0x80074a,%r9
  8005e1:	00 00 00 
  8005e4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f5:	48 89 d6             	mov    %rdx,%rsi
  8005f8:	48 89 c7             	mov    %rax,%rdi
  8005fb:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  800602:	00 00 00 
  800605:	ff d0                	callq  *%rax
	cprintf("\n");
  800607:	48 bf e3 3f 80 00 00 	movabs $0x803fe3,%rdi
  80060e:	00 00 00 
  800611:	b8 00 00 00 00       	mov    $0x0,%eax
  800616:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  80061d:	00 00 00 
  800620:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800622:	cc                   	int3   
  800623:	eb fd                	jmp    800622 <_panic+0x111>

0000000000800625 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	48 83 ec 10          	sub    $0x10,%rsp
  80062d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800630:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	8d 48 01             	lea    0x1(%rax),%ecx
  80063d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800641:	89 0a                	mov    %ecx,(%rdx)
  800643:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800646:	89 d1                	mov    %edx,%ecx
  800648:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064c:	48 98                	cltq   
  80064e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800656:	8b 00                	mov    (%rax),%eax
  800658:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065d:	75 2c                	jne    80068b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	48 98                	cltq   
  800667:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066b:	48 83 c2 08          	add    $0x8,%rdx
  80066f:	48 89 c6             	mov    %rax,%rsi
  800672:	48 89 d7             	mov    %rdx,%rdi
  800675:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
        b->idx = 0;
  800681:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800685:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80068b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068f:	8b 40 04             	mov    0x4(%rax),%eax
  800692:	8d 50 01             	lea    0x1(%rax),%edx
  800695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800699:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069c:	c9                   	leaveq 
  80069d:	c3                   	retq   

000000000080069e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80069e:	55                   	push   %rbp
  80069f:	48 89 e5             	mov    %rsp,%rbp
  8006a2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006be:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c5:	48 8b 0a             	mov    (%rdx),%rcx
  8006c8:	48 89 08             	mov    %rcx,(%rax)
  8006cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e2:	00 00 00 
    b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ec:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006ef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006fd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800704:	48 89 c6             	mov    %rax,%rsi
  800707:	48 bf 25 06 80 00 00 	movabs $0x800625,%rdi
  80070e:	00 00 00 
  800711:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80071d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800723:	48 98                	cltq   
  800725:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072c:	48 83 c2 08          	add    $0x8,%rdx
  800730:	48 89 c6             	mov    %rax,%rsi
  800733:	48 89 d7             	mov    %rdx,%rdi
  800736:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  80073d:	00 00 00 
  800740:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800742:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800748:	c9                   	leaveq 
  800749:	c3                   	retq   

000000000080074a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800755:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80075c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800763:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80076a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800771:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800778:	84 c0                	test   %al,%al
  80077a:	74 20                	je     80079c <cprintf+0x52>
  80077c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800780:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800784:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800788:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80078c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800790:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800794:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800798:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80079c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007aa:	00 00 00 
  8007ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b4:	00 00 00 
  8007b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007de:	48 8b 0a             	mov    (%rdx),%rcx
  8007e1:	48 89 08             	mov    %rcx,(%rax)
  8007e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800802:	48 89 d6             	mov    %rdx,%rsi
  800805:	48 89 c7             	mov    %rax,%rdi
  800808:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  80080f:	00 00 00 
  800812:	ff d0                	callq  *%rax
  800814:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80081a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800820:	c9                   	leaveq 
  800821:	c3                   	retq   

0000000000800822 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800822:	55                   	push   %rbp
  800823:	48 89 e5             	mov    %rsp,%rbp
  800826:	53                   	push   %rbx
  800827:	48 83 ec 38          	sub    $0x38,%rsp
  80082b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80082f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800833:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800837:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80083a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80083e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800842:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800845:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800849:	77 3b                	ja     800886 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80084e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800852:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	48 f7 f3             	div    %rbx
  800861:	48 89 c2             	mov    %rax,%rdx
  800864:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800867:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80086a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	41 89 f9             	mov    %edi,%r9d
  800875:	48 89 c7             	mov    %rax,%rdi
  800878:	48 b8 22 08 80 00 00 	movabs $0x800822,%rax
  80087f:	00 00 00 
  800882:	ff d0                	callq  *%rax
  800884:	eb 1e                	jmp    8008a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800886:	eb 12                	jmp    80089a <printnum+0x78>
			putch(padc, putdat);
  800888:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80088c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	48 89 ce             	mov    %rcx,%rsi
  800896:	89 d7                	mov    %edx,%edi
  800898:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80089e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008a2:	7f e4                	jg     800888 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b0:	48 f7 f1             	div    %rcx
  8008b3:	48 89 d0             	mov    %rdx,%rax
  8008b6:	48 ba f0 41 80 00 00 	movabs $0x8041f0,%rdx
  8008bd:	00 00 00 
  8008c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008c4:	0f be d0             	movsbl %al,%edx
  8008c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cf:	48 89 ce             	mov    %rcx,%rsi
  8008d2:	89 d7                	mov    %edx,%edi
  8008d4:	ff d0                	callq  *%rax
}
  8008d6:	48 83 c4 38          	add    $0x38,%rsp
  8008da:	5b                   	pop    %rbx
  8008db:	5d                   	pop    %rbp
  8008dc:	c3                   	retq   

00000000008008dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dd:	55                   	push   %rbp
  8008de:	48 89 e5             	mov    %rsp,%rbp
  8008e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f0:	7e 52                	jle    800944 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	8b 00                	mov    (%rax),%eax
  8008f8:	83 f8 30             	cmp    $0x30,%eax
  8008fb:	73 24                	jae    800921 <getuint+0x44>
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800909:	8b 00                	mov    (%rax),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 01 d0             	add    %rdx,%rax
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	8b 12                	mov    (%rdx),%edx
  800916:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091d:	89 0a                	mov    %ecx,(%rdx)
  80091f:	eb 17                	jmp    800938 <getuint+0x5b>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800929:	48 89 d0             	mov    %rdx,%rax
  80092c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800934:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800938:	48 8b 00             	mov    (%rax),%rax
  80093b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093f:	e9 a3 00 00 00       	jmpq   8009e7 <getuint+0x10a>
	else if (lflag)
  800944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800948:	74 4f                	je     800999 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	83 f8 30             	cmp    $0x30,%eax
  800953:	73 24                	jae    800979 <getuint+0x9c>
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	8b 00                	mov    (%rax),%eax
  800963:	89 c0                	mov    %eax,%eax
  800965:	48 01 d0             	add    %rdx,%rax
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	8b 12                	mov    (%rdx),%edx
  80096e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	89 0a                	mov    %ecx,(%rdx)
  800977:	eb 17                	jmp    800990 <getuint+0xb3>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800981:	48 89 d0             	mov    %rdx,%rax
  800984:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800990:	48 8b 00             	mov    (%rax),%rax
  800993:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800997:	eb 4e                	jmp    8009e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	83 f8 30             	cmp    $0x30,%eax
  8009a2:	73 24                	jae    8009c8 <getuint+0xeb>
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	8b 00                	mov    (%rax),%eax
  8009b2:	89 c0                	mov    %eax,%eax
  8009b4:	48 01 d0             	add    %rdx,%rax
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	8b 12                	mov    (%rdx),%edx
  8009bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	89 0a                	mov    %ecx,(%rdx)
  8009c6:	eb 17                	jmp    8009df <getuint+0x102>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d0:	48 89 d0             	mov    %rdx,%rax
  8009d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009df:	8b 00                	mov    (%rax),%eax
  8009e1:	89 c0                	mov    %eax,%eax
  8009e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009eb:	c9                   	leaveq 
  8009ec:	c3                   	retq   

00000000008009ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ed:	55                   	push   %rbp
  8009ee:	48 89 e5             	mov    %rsp,%rbp
  8009f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a00:	7e 52                	jle    800a54 <getint+0x67>
		x=va_arg(*ap, long long);
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 24                	jae    800a31 <getint+0x44>
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a24:	8b 12                	mov    (%rdx),%edx
  800a26:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	89 0a                	mov    %ecx,(%rdx)
  800a2f:	eb 17                	jmp    800a48 <getint+0x5b>
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a39:	48 89 d0             	mov    %rdx,%rax
  800a3c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a44:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a48:	48 8b 00             	mov    (%rax),%rax
  800a4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4f:	e9 a3 00 00 00       	jmpq   800af7 <getint+0x10a>
	else if (lflag)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a58:	74 4f                	je     800aa9 <getint+0xbc>
		x=va_arg(*ap, long);
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 24                	jae    800a89 <getint+0x9c>
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	89 c0                	mov    %eax,%eax
  800a75:	48 01 d0             	add    %rdx,%rax
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	8b 12                	mov    (%rdx),%edx
  800a7e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a85:	89 0a                	mov    %ecx,(%rdx)
  800a87:	eb 17                	jmp    800aa0 <getint+0xb3>
  800a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a91:	48 89 d0             	mov    %rdx,%rax
  800a94:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa0:	48 8b 00             	mov    (%rax),%rax
  800aa3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa7:	eb 4e                	jmp    800af7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	8b 00                	mov    (%rax),%eax
  800aaf:	83 f8 30             	cmp    $0x30,%eax
  800ab2:	73 24                	jae    800ad8 <getint+0xeb>
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac0:	8b 00                	mov    (%rax),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	8b 12                	mov    (%rdx),%edx
  800acd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	89 0a                	mov    %ecx,(%rdx)
  800ad6:	eb 17                	jmp    800aef <getint+0x102>
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae0:	48 89 d0             	mov    %rdx,%rax
  800ae3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aef:	8b 00                	mov    (%rax),%eax
  800af1:	48 98                	cltq   
  800af3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afb:	c9                   	leaveq 
  800afc:	c3                   	retq   

0000000000800afd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afd:	55                   	push   %rbp
  800afe:	48 89 e5             	mov    %rsp,%rbp
  800b01:	41 54                	push   %r12
  800b03:	53                   	push   %rbx
  800b04:	48 83 ec 60          	sub    $0x60,%rsp
  800b08:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b14:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b20:	48 8b 0a             	mov    (%rdx),%rcx
  800b23:	48 89 08             	mov    %rcx,(%rax)
  800b26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b32:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b36:	eb 17                	jmp    800b4f <vprintfmt+0x52>
			if (ch == '\0')
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	0f 84 cc 04 00 00    	je     80100c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800b40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b48:	48 89 d6             	mov    %rdx,%rsi
  800b4b:	89 df                	mov    %ebx,%edi
  800b4d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5b:	0f b6 00             	movzbl (%rax),%eax
  800b5e:	0f b6 d8             	movzbl %al,%ebx
  800b61:	83 fb 25             	cmp    $0x25,%ebx
  800b64:	75 d2                	jne    800b38 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b66:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b6a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b71:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b7f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b8e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b92:	0f b6 00             	movzbl (%rax),%eax
  800b95:	0f b6 d8             	movzbl %al,%ebx
  800b98:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b9b:	83 f8 55             	cmp    $0x55,%eax
  800b9e:	0f 87 34 04 00 00    	ja     800fd8 <vprintfmt+0x4db>
  800ba4:	89 c0                	mov    %eax,%eax
  800ba6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bad:	00 
  800bae:	48 b8 18 42 80 00 00 	movabs $0x804218,%rax
  800bb5:	00 00 00 
  800bb8:	48 01 d0             	add    %rdx,%rax
  800bbb:	48 8b 00             	mov    (%rax),%rax
  800bbe:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bc0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc4:	eb c0                	jmp    800b86 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bca:	eb ba                	jmp    800b86 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd6:	89 d0                	mov    %edx,%eax
  800bd8:	c1 e0 02             	shl    $0x2,%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	01 c0                	add    %eax,%eax
  800bdf:	01 d8                	add    %ebx,%eax
  800be1:	83 e8 30             	sub    $0x30,%eax
  800be4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800beb:	0f b6 00             	movzbl (%rax),%eax
  800bee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf1:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf4:	7e 0c                	jle    800c02 <vprintfmt+0x105>
  800bf6:	83 fb 39             	cmp    $0x39,%ebx
  800bf9:	7f 07                	jg     800c02 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c00:	eb d1                	jmp    800bd3 <vprintfmt+0xd6>
			goto process_precision;
  800c02:	eb 58                	jmp    800c5c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c07:	83 f8 30             	cmp    $0x30,%eax
  800c0a:	73 17                	jae    800c23 <vprintfmt+0x126>
  800c0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c13:	89 c0                	mov    %eax,%eax
  800c15:	48 01 d0             	add    %rdx,%rax
  800c18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1b:	83 c2 08             	add    $0x8,%edx
  800c1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c21:	eb 0f                	jmp    800c32 <vprintfmt+0x135>
  800c23:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c27:	48 89 d0             	mov    %rdx,%rax
  800c2a:	48 83 c2 08          	add    $0x8,%rdx
  800c2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c32:	8b 00                	mov    (%rax),%eax
  800c34:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c37:	eb 23                	jmp    800c5c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3d:	79 0c                	jns    800c4b <vprintfmt+0x14e>
				width = 0;
  800c3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c46:	e9 3b ff ff ff       	jmpq   800b86 <vprintfmt+0x89>
  800c4b:	e9 36 ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c50:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c57:	e9 2a ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c60:	79 12                	jns    800c74 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c62:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c65:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c6f:	e9 12 ff ff ff       	jmpq   800b86 <vprintfmt+0x89>
  800c74:	e9 0d ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c79:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c7d:	e9 04 ff ff ff       	jmpq   800b86 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c85:	83 f8 30             	cmp    $0x30,%eax
  800c88:	73 17                	jae    800ca1 <vprintfmt+0x1a4>
  800c8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	89 c0                	mov    %eax,%eax
  800c93:	48 01 d0             	add    %rdx,%rax
  800c96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c99:	83 c2 08             	add    $0x8,%edx
  800c9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9f:	eb 0f                	jmp    800cb0 <vprintfmt+0x1b3>
  800ca1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca5:	48 89 d0             	mov    %rdx,%rax
  800ca8:	48 83 c2 08          	add    $0x8,%rdx
  800cac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb0:	8b 10                	mov    (%rax),%edx
  800cb2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cba:	48 89 ce             	mov    %rcx,%rsi
  800cbd:	89 d7                	mov    %edx,%edi
  800cbf:	ff d0                	callq  *%rax
			break;
  800cc1:	e9 40 03 00 00       	jmpq   801006 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc9:	83 f8 30             	cmp    $0x30,%eax
  800ccc:	73 17                	jae    800ce5 <vprintfmt+0x1e8>
  800cce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd5:	89 c0                	mov    %eax,%eax
  800cd7:	48 01 d0             	add    %rdx,%rax
  800cda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdd:	83 c2 08             	add    $0x8,%edx
  800ce0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce3:	eb 0f                	jmp    800cf4 <vprintfmt+0x1f7>
  800ce5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce9:	48 89 d0             	mov    %rdx,%rax
  800cec:	48 83 c2 08          	add    $0x8,%rdx
  800cf0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cf6:	85 db                	test   %ebx,%ebx
  800cf8:	79 02                	jns    800cfc <vprintfmt+0x1ff>
				err = -err;
  800cfa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cfc:	83 fb 15             	cmp    $0x15,%ebx
  800cff:	7f 16                	jg     800d17 <vprintfmt+0x21a>
  800d01:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  800d08:	00 00 00 
  800d0b:	48 63 d3             	movslq %ebx,%rdx
  800d0e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d12:	4d 85 e4             	test   %r12,%r12
  800d15:	75 2e                	jne    800d45 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d17:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1f:	89 d9                	mov    %ebx,%ecx
  800d21:	48 ba 01 42 80 00 00 	movabs $0x804201,%rdx
  800d28:	00 00 00 
  800d2b:	48 89 c7             	mov    %rax,%rdi
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	49 b8 15 10 80 00 00 	movabs $0x801015,%r8
  800d3a:	00 00 00 
  800d3d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d40:	e9 c1 02 00 00       	jmpq   801006 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d45:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4d:	4c 89 e1             	mov    %r12,%rcx
  800d50:	48 ba 0a 42 80 00 00 	movabs $0x80420a,%rdx
  800d57:	00 00 00 
  800d5a:	48 89 c7             	mov    %rax,%rdi
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	49 b8 15 10 80 00 00 	movabs $0x801015,%r8
  800d69:	00 00 00 
  800d6c:	41 ff d0             	callq  *%r8
			break;
  800d6f:	e9 92 02 00 00       	jmpq   801006 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d77:	83 f8 30             	cmp    $0x30,%eax
  800d7a:	73 17                	jae    800d93 <vprintfmt+0x296>
  800d7c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d83:	89 c0                	mov    %eax,%eax
  800d85:	48 01 d0             	add    %rdx,%rax
  800d88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8b:	83 c2 08             	add    $0x8,%edx
  800d8e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d91:	eb 0f                	jmp    800da2 <vprintfmt+0x2a5>
  800d93:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d97:	48 89 d0             	mov    %rdx,%rax
  800d9a:	48 83 c2 08          	add    $0x8,%rdx
  800d9e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da2:	4c 8b 20             	mov    (%rax),%r12
  800da5:	4d 85 e4             	test   %r12,%r12
  800da8:	75 0a                	jne    800db4 <vprintfmt+0x2b7>
				p = "(null)";
  800daa:	49 bc 0d 42 80 00 00 	movabs $0x80420d,%r12
  800db1:	00 00 00 
			if (width > 0 && padc != '-')
  800db4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db8:	7e 3f                	jle    800df9 <vprintfmt+0x2fc>
  800dba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dbe:	74 39                	je     800df9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dc3:	48 98                	cltq   
  800dc5:	48 89 c6             	mov    %rax,%rsi
  800dc8:	4c 89 e7             	mov    %r12,%rdi
  800dcb:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  800dd2:	00 00 00 
  800dd5:	ff d0                	callq  *%rax
  800dd7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dda:	eb 17                	jmp    800df3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ddc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800de0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800de4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de8:	48 89 ce             	mov    %rcx,%rsi
  800deb:	89 d7                	mov    %edx,%edi
  800ded:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800def:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df7:	7f e3                	jg     800ddc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df9:	eb 37                	jmp    800e32 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800dfb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dff:	74 1e                	je     800e1f <vprintfmt+0x322>
  800e01:	83 fb 1f             	cmp    $0x1f,%ebx
  800e04:	7e 05                	jle    800e0b <vprintfmt+0x30e>
  800e06:	83 fb 7e             	cmp    $0x7e,%ebx
  800e09:	7e 14                	jle    800e1f <vprintfmt+0x322>
					putch('?', putdat);
  800e0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e13:	48 89 d6             	mov    %rdx,%rsi
  800e16:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e1b:	ff d0                	callq  *%rax
  800e1d:	eb 0f                	jmp    800e2e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e27:	48 89 d6             	mov    %rdx,%rsi
  800e2a:	89 df                	mov    %ebx,%edi
  800e2c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e32:	4c 89 e0             	mov    %r12,%rax
  800e35:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e39:	0f b6 00             	movzbl (%rax),%eax
  800e3c:	0f be d8             	movsbl %al,%ebx
  800e3f:	85 db                	test   %ebx,%ebx
  800e41:	74 10                	je     800e53 <vprintfmt+0x356>
  800e43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e47:	78 b2                	js     800dfb <vprintfmt+0x2fe>
  800e49:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e51:	79 a8                	jns    800dfb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e53:	eb 16                	jmp    800e6b <vprintfmt+0x36e>
				putch(' ', putdat);
  800e55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	48 89 d6             	mov    %rdx,%rsi
  800e60:	bf 20 00 00 00       	mov    $0x20,%edi
  800e65:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e6f:	7f e4                	jg     800e55 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e71:	e9 90 01 00 00       	jmpq   801006 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7a:	be 03 00 00 00       	mov    $0x3,%esi
  800e7f:	48 89 c7             	mov    %rax,%rdi
  800e82:	48 b8 ed 09 80 00 00 	movabs $0x8009ed,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	callq  *%rax
  800e8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e96:	48 85 c0             	test   %rax,%rax
  800e99:	79 1d                	jns    800eb8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea3:	48 89 d6             	mov    %rdx,%rsi
  800ea6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eab:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb1:	48 f7 d8             	neg    %rax
  800eb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eb8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ebf:	e9 d5 00 00 00       	jmpq   800f99 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ec4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec8:	be 03 00 00 00       	mov    $0x3,%esi
  800ecd:	48 89 c7             	mov    %rax,%rdi
  800ed0:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800ed7:	00 00 00 
  800eda:	ff d0                	callq  *%rax
  800edc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ee0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee7:	e9 ad 00 00 00       	jmpq   800f99 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800eec:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800eef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef3:	89 d6                	mov    %edx,%esi
  800ef5:	48 89 c7             	mov    %rax,%rdi
  800ef8:	48 b8 ed 09 80 00 00 	movabs $0x8009ed,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
  800f04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f08:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f0f:	e9 85 00 00 00       	jmpq   800f99 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800f14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1c:	48 89 d6             	mov    %rdx,%rsi
  800f1f:	bf 30 00 00 00       	mov    $0x30,%edi
  800f24:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2e:	48 89 d6             	mov    %rdx,%rsi
  800f31:	bf 78 00 00 00       	mov    $0x78,%edi
  800f36:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f3b:	83 f8 30             	cmp    $0x30,%eax
  800f3e:	73 17                	jae    800f57 <vprintfmt+0x45a>
  800f40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f47:	89 c0                	mov    %eax,%eax
  800f49:	48 01 d0             	add    %rdx,%rax
  800f4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f4f:	83 c2 08             	add    $0x8,%edx
  800f52:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f55:	eb 0f                	jmp    800f66 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f57:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f5b:	48 89 d0             	mov    %rdx,%rax
  800f5e:	48 83 c2 08          	add    $0x8,%rdx
  800f62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f66:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f6d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f74:	eb 23                	jmp    800f99 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f7a:	be 03 00 00 00       	mov    $0x3,%esi
  800f7f:	48 89 c7             	mov    %rax,%rdi
  800f82:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800f89:	00 00 00 
  800f8c:	ff d0                	callq  *%rax
  800f8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f92:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f99:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f9e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fa4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb0:	45 89 c1             	mov    %r8d,%r9d
  800fb3:	41 89 f8             	mov    %edi,%r8d
  800fb6:	48 89 c7             	mov    %rax,%rdi
  800fb9:	48 b8 22 08 80 00 00 	movabs $0x800822,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	callq  *%rax
			break;
  800fc5:	eb 3f                	jmp    801006 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fcb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fcf:	48 89 d6             	mov    %rdx,%rsi
  800fd2:	89 df                	mov    %ebx,%edi
  800fd4:	ff d0                	callq  *%rax
			break;
  800fd6:	eb 2e                	jmp    801006 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe0:	48 89 d6             	mov    %rdx,%rsi
  800fe3:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fef:	eb 05                	jmp    800ff6 <vprintfmt+0x4f9>
  800ff1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ffa:	48 83 e8 01          	sub    $0x1,%rax
  800ffe:	0f b6 00             	movzbl (%rax),%eax
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 ec                	jne    800ff1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801007:	e9 43 fb ff ff       	jmpq   800b4f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80100c:	48 83 c4 60          	add    $0x60,%rsp
  801010:	5b                   	pop    %rbx
  801011:	41 5c                	pop    %r12
  801013:	5d                   	pop    %rbp
  801014:	c3                   	retq   

0000000000801015 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801020:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801027:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80102e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801035:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80103c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801043:	84 c0                	test   %al,%al
  801045:	74 20                	je     801067 <printfmt+0x52>
  801047:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80104b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80104f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801053:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801057:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80105b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80105f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801063:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801067:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80106e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801075:	00 00 00 
  801078:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80107f:	00 00 00 
  801082:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801086:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80108d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801094:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80109b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010a2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b7:	48 89 c7             	mov    %rax,%rdi
  8010ba:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010c6:	c9                   	leaveq 
  8010c7:	c3                   	retq   

00000000008010c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 10          	sub    $0x10,%rsp
  8010d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010db:	8b 40 10             	mov    0x10(%rax),%eax
  8010de:	8d 50 01             	lea    0x1(%rax),%edx
  8010e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ec:	48 8b 10             	mov    (%rax),%rdx
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f7:	48 39 c2             	cmp    %rax,%rdx
  8010fa:	73 17                	jae    801113 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801100:	48 8b 00             	mov    (%rax),%rax
  801103:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801107:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80110b:	48 89 0a             	mov    %rcx,(%rdx)
  80110e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801111:	88 10                	mov    %dl,(%rax)
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 50          	sub    $0x50,%rsp
  80111d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801121:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801124:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801128:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80112c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801130:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801134:	48 8b 0a             	mov    (%rdx),%rcx
  801137:	48 89 08             	mov    %rcx,(%rax)
  80113a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80113e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801142:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801146:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80114e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801152:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801155:	48 98                	cltq   
  801157:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80115b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80115f:	48 01 d0             	add    %rdx,%rax
  801162:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801166:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80116d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801172:	74 06                	je     80117a <vsnprintf+0x65>
  801174:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801178:	7f 07                	jg     801181 <vsnprintf+0x6c>
		return -E_INVAL;
  80117a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117f:	eb 2f                	jmp    8011b0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801181:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801185:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801189:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80118d:	48 89 c6             	mov    %rax,%rsi
  801190:	48 bf c8 10 80 00 00 	movabs $0x8010c8,%rdi
  801197:	00 00 00 
  80119a:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  8011a1:	00 00 00 
  8011a4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011aa:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ad:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011bd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011c4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011ca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011d8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011df:	84 c0                	test   %al,%al
  8011e1:	74 20                	je     801203 <snprintf+0x51>
  8011e3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011e7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011eb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011ef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011f3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011f7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011fb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011ff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801203:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80120a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801211:	00 00 00 
  801214:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80121b:	00 00 00 
  80121e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801222:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801229:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801230:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801237:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80123e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801245:	48 8b 0a             	mov    (%rdx),%rcx
  801248:	48 89 08             	mov    %rcx,(%rax)
  80124b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80124f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801253:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801257:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80125b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801262:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801269:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80126f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
  801285:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80128b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801291:	c9                   	leaveq 
  801292:	c3                   	retq   

0000000000801293 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801293:	55                   	push   %rbp
  801294:	48 89 e5             	mov    %rsp,%rbp
  801297:	48 83 ec 20          	sub    $0x20,%rsp
  80129b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80129f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a4:	74 27                	je     8012cd <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012aa:	48 89 c2             	mov    %rax,%rdx
  8012ad:	48 be c8 44 80 00 00 	movabs $0x8044c8,%rsi
  8012b4:	00 00 00 
  8012b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	48 b9 3f 32 80 00 00 	movabs $0x80323f,%rcx
  8012c8:	00 00 00 
  8012cb:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8012d9:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8012e0:	00 00 00 
  8012e3:	ff d0                	callq  *%rax
  8012e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012e8:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8012ef:	00 00 00 
  8012f2:	ff d0                	callq  *%rax
  8012f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8012f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8012fb:	79 30                	jns    80132d <readline+0x9a>
			if (c != -E_EOF)
  8012fd:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801301:	74 20                	je     801323 <readline+0x90>
				cprintf("read error: %e\n", c);
  801303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801306:	89 c6                	mov    %eax,%esi
  801308:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  80130f:	00 00 00 
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
  801317:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  80131e:	00 00 00 
  801321:	ff d2                	callq  *%rdx
			return NULL;
  801323:	b8 00 00 00 00       	mov    $0x0,%eax
  801328:	e9 be 00 00 00       	jmpq   8013eb <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80132d:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801331:	74 06                	je     801339 <readline+0xa6>
  801333:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801337:	75 26                	jne    80135f <readline+0xcc>
  801339:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80133d:	7e 20                	jle    80135f <readline+0xcc>
			if (echoing)
  80133f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801343:	74 11                	je     801356 <readline+0xc3>
				cputchar('\b');
  801345:	bf 08 00 00 00       	mov    $0x8,%edi
  80134a:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801351:	00 00 00 
  801354:	ff d0                	callq  *%rax
			i--;
  801356:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80135a:	e9 87 00 00 00       	jmpq   8013e6 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80135f:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801363:	7e 3f                	jle    8013a4 <readline+0x111>
  801365:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80136c:	7f 36                	jg     8013a4 <readline+0x111>
			if (echoing)
  80136e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801372:	74 11                	je     801385 <readline+0xf2>
				cputchar(c);
  801374:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801377:	89 c7                	mov    %eax,%edi
  801379:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801380:	00 00 00 
  801383:	ff d0                	callq  *%rax
			buf[i++] = c;
  801385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801388:	8d 50 01             	lea    0x1(%rax),%edx
  80138b:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80138e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801391:	89 d1                	mov    %edx,%ecx
  801393:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80139a:	00 00 00 
  80139d:	48 98                	cltq   
  80139f:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013a2:	eb 42                	jmp    8013e6 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013a4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013a8:	74 06                	je     8013b0 <readline+0x11d>
  8013aa:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013ae:	75 36                	jne    8013e6 <readline+0x153>
			if (echoing)
  8013b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013b4:	74 11                	je     8013c7 <readline+0x134>
				cputchar('\n');
  8013b6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013bb:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013c2:	00 00 00 
  8013c5:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013c7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013ce:	00 00 00 
  8013d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d4:	48 98                	cltq   
  8013d6:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013e1:	00 00 00 
  8013e4:	eb 05                	jmp    8013eb <readline+0x158>
		}
	}
  8013e6:	e9 fd fe ff ff       	jmpq   8012e8 <readline+0x55>
}
  8013eb:	c9                   	leaveq 
  8013ec:	c3                   	retq   

00000000008013ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013ed:	55                   	push   %rbp
  8013ee:	48 89 e5             	mov    %rsp,%rbp
  8013f1:	48 83 ec 18          	sub    $0x18,%rsp
  8013f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801400:	eb 09                	jmp    80140b <strlen+0x1e>
		n++;
  801402:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801406:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	84 c0                	test   %al,%al
  801414:	75 ec                	jne    801402 <strlen+0x15>
		n++;
	return n;
  801416:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801419:	c9                   	leaveq 
  80141a:	c3                   	retq   

000000000080141b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80141b:	55                   	push   %rbp
  80141c:	48 89 e5             	mov    %rsp,%rbp
  80141f:	48 83 ec 20          	sub    $0x20,%rsp
  801423:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801427:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80142b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801432:	eb 0e                	jmp    801442 <strnlen+0x27>
		n++;
  801434:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801438:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80143d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801442:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801447:	74 0b                	je     801454 <strnlen+0x39>
  801449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	84 c0                	test   %al,%al
  801452:	75 e0                	jne    801434 <strnlen+0x19>
		n++;
	return n;
  801454:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801457:	c9                   	leaveq 
  801458:	c3                   	retq   

0000000000801459 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801459:	55                   	push   %rbp
  80145a:	48 89 e5             	mov    %rsp,%rbp
  80145d:	48 83 ec 20          	sub    $0x20,%rsp
  801461:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801465:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801471:	90                   	nop
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80147a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80147e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801482:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801486:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80148a:	0f b6 12             	movzbl (%rdx),%edx
  80148d:	88 10                	mov    %dl,(%rax)
  80148f:	0f b6 00             	movzbl (%rax),%eax
  801492:	84 c0                	test   %al,%al
  801494:	75 dc                	jne    801472 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149a:	c9                   	leaveq 
  80149b:	c3                   	retq   

000000000080149c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80149c:	55                   	push   %rbp
  80149d:	48 89 e5             	mov    %rsp,%rbp
  8014a0:	48 83 ec 20          	sub    $0x20,%rsp
  8014a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 89 c7             	mov    %rax,%rdi
  8014b3:	48 b8 ed 13 80 00 00 	movabs $0x8013ed,%rax
  8014ba:	00 00 00 
  8014bd:	ff d0                	callq  *%rax
  8014bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c5:	48 63 d0             	movslq %eax,%rdx
  8014c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cc:	48 01 c2             	add    %rax,%rdx
  8014cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d3:	48 89 c6             	mov    %rax,%rsi
  8014d6:	48 89 d7             	mov    %rdx,%rdi
  8014d9:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  8014e0:	00 00 00 
  8014e3:	ff d0                	callq  *%rax
	return dst;
  8014e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 28          	sub    $0x28,%rsp
  8014f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801503:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801507:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80150e:	00 
  80150f:	eb 2a                	jmp    80153b <strncpy+0x50>
		*dst++ = *src;
  801511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801515:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801519:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80151d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801521:	0f b6 12             	movzbl (%rdx),%edx
  801524:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152a:	0f b6 00             	movzbl (%rax),%eax
  80152d:	84 c0                	test   %al,%al
  80152f:	74 05                	je     801536 <strncpy+0x4b>
			src++;
  801531:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801536:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801543:	72 cc                	jb     801511 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	48 83 ec 28          	sub    $0x28,%rsp
  801553:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801557:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801567:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80156c:	74 3d                	je     8015ab <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80156e:	eb 1d                	jmp    80158d <strlcpy+0x42>
			*dst++ = *src++;
  801570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801574:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801578:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80157c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801580:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801584:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801588:	0f b6 12             	movzbl (%rdx),%edx
  80158b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80158d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801592:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801597:	74 0b                	je     8015a4 <strlcpy+0x59>
  801599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	75 cc                	jne    801570 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	48 29 c2             	sub    %rax,%rdx
  8015b6:	48 89 d0             	mov    %rdx,%rax
}
  8015b9:	c9                   	leaveq 
  8015ba:	c3                   	retq   

00000000008015bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015bb:	55                   	push   %rbp
  8015bc:	48 89 e5             	mov    %rsp,%rbp
  8015bf:	48 83 ec 10          	sub    $0x10,%rsp
  8015c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015cb:	eb 0a                	jmp    8015d7 <strcmp+0x1c>
		p++, q++;
  8015cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015d2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015db:	0f b6 00             	movzbl (%rax),%eax
  8015de:	84 c0                	test   %al,%al
  8015e0:	74 12                	je     8015f4 <strcmp+0x39>
  8015e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e6:	0f b6 10             	movzbl (%rax),%edx
  8015e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	38 c2                	cmp    %al,%dl
  8015f2:	74 d9                	je     8015cd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	0f b6 d0             	movzbl %al,%edx
  8015fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	0f b6 c0             	movzbl %al,%eax
  801608:	29 c2                	sub    %eax,%edx
  80160a:	89 d0                	mov    %edx,%eax
}
  80160c:	c9                   	leaveq 
  80160d:	c3                   	retq   

000000000080160e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	48 83 ec 18          	sub    $0x18,%rsp
  801616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80161e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801622:	eb 0f                	jmp    801633 <strncmp+0x25>
		n--, p++, q++;
  801624:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801629:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801633:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801638:	74 1d                	je     801657 <strncmp+0x49>
  80163a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	84 c0                	test   %al,%al
  801643:	74 12                	je     801657 <strncmp+0x49>
  801645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801649:	0f b6 10             	movzbl (%rax),%edx
  80164c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	38 c2                	cmp    %al,%dl
  801655:	74 cd                	je     801624 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801657:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80165c:	75 07                	jne    801665 <strncmp+0x57>
		return 0;
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	eb 18                	jmp    80167d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	0f b6 d0             	movzbl %al,%edx
  80166f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801673:	0f b6 00             	movzbl (%rax),%eax
  801676:	0f b6 c0             	movzbl %al,%eax
  801679:	29 c2                	sub    %eax,%edx
  80167b:	89 d0                	mov    %edx,%eax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	48 83 ec 0c          	sub    $0xc,%rsp
  801687:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168b:	89 f0                	mov    %esi,%eax
  80168d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801690:	eb 17                	jmp    8016a9 <strchr+0x2a>
		if (*s == c)
  801692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80169c:	75 06                	jne    8016a4 <strchr+0x25>
			return (char *) s;
  80169e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a2:	eb 15                	jmp    8016b9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	84 c0                	test   %al,%al
  8016b2:	75 de                	jne    801692 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b9:	c9                   	leaveq 
  8016ba:	c3                   	retq   

00000000008016bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	48 83 ec 0c          	sub    $0xc,%rsp
  8016c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c7:	89 f0                	mov    %esi,%eax
  8016c9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016cc:	eb 13                	jmp    8016e1 <strfind+0x26>
		if (*s == c)
  8016ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016d8:	75 02                	jne    8016dc <strfind+0x21>
			break;
  8016da:	eb 10                	jmp    8016ec <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	84 c0                	test   %al,%al
  8016ea:	75 e2                	jne    8016ce <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f0:	c9                   	leaveq 
  8016f1:	c3                   	retq   

00000000008016f2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016f2:	55                   	push   %rbp
  8016f3:	48 89 e5             	mov    %rsp,%rbp
  8016f6:	48 83 ec 18          	sub    $0x18,%rsp
  8016fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016fe:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801701:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801705:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80170a:	75 06                	jne    801712 <memset+0x20>
		return v;
  80170c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801710:	eb 69                	jmp    80177b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801716:	83 e0 03             	and    $0x3,%eax
  801719:	48 85 c0             	test   %rax,%rax
  80171c:	75 48                	jne    801766 <memset+0x74>
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	83 e0 03             	and    $0x3,%eax
  801725:	48 85 c0             	test   %rax,%rax
  801728:	75 3c                	jne    801766 <memset+0x74>
		c &= 0xFF;
  80172a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801731:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801734:	c1 e0 18             	shl    $0x18,%eax
  801737:	89 c2                	mov    %eax,%edx
  801739:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80173c:	c1 e0 10             	shl    $0x10,%eax
  80173f:	09 c2                	or     %eax,%edx
  801741:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801744:	c1 e0 08             	shl    $0x8,%eax
  801747:	09 d0                	or     %edx,%eax
  801749:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80174c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801750:	48 c1 e8 02          	shr    $0x2,%rax
  801754:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801757:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80175b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80175e:	48 89 d7             	mov    %rdx,%rdi
  801761:	fc                   	cld    
  801762:	f3 ab                	rep stos %eax,%es:(%rdi)
  801764:	eb 11                	jmp    801777 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801766:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80176a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80176d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801771:	48 89 d7             	mov    %rdx,%rdi
  801774:	fc                   	cld    
  801775:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80177b:	c9                   	leaveq 
  80177c:	c3                   	retq   

000000000080177d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80177d:	55                   	push   %rbp
  80177e:	48 89 e5             	mov    %rsp,%rbp
  801781:	48 83 ec 28          	sub    $0x28,%rsp
  801785:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801789:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80178d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801795:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017a9:	0f 83 88 00 00 00    	jae    801837 <memmove+0xba>
  8017af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b7:	48 01 d0             	add    %rdx,%rax
  8017ba:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017be:	76 77                	jbe    801837 <memmove+0xba>
		s += n;
  8017c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d4:	83 e0 03             	and    $0x3,%eax
  8017d7:	48 85 c0             	test   %rax,%rax
  8017da:	75 3b                	jne    801817 <memmove+0x9a>
  8017dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e0:	83 e0 03             	and    $0x3,%eax
  8017e3:	48 85 c0             	test   %rax,%rax
  8017e6:	75 2f                	jne    801817 <memmove+0x9a>
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	83 e0 03             	and    $0x3,%eax
  8017ef:	48 85 c0             	test   %rax,%rax
  8017f2:	75 23                	jne    801817 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f8:	48 83 e8 04          	sub    $0x4,%rax
  8017fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801800:	48 83 ea 04          	sub    $0x4,%rdx
  801804:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801808:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80180c:	48 89 c7             	mov    %rax,%rdi
  80180f:	48 89 d6             	mov    %rdx,%rsi
  801812:	fd                   	std    
  801813:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801815:	eb 1d                	jmp    801834 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801817:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80181f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801823:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	48 89 d7             	mov    %rdx,%rdi
  80182e:	48 89 c1             	mov    %rax,%rcx
  801831:	fd                   	std    
  801832:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801834:	fc                   	cld    
  801835:	eb 57                	jmp    80188e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183b:	83 e0 03             	and    $0x3,%eax
  80183e:	48 85 c0             	test   %rax,%rax
  801841:	75 36                	jne    801879 <memmove+0xfc>
  801843:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801847:	83 e0 03             	and    $0x3,%eax
  80184a:	48 85 c0             	test   %rax,%rax
  80184d:	75 2a                	jne    801879 <memmove+0xfc>
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	83 e0 03             	and    $0x3,%eax
  801856:	48 85 c0             	test   %rax,%rax
  801859:	75 1e                	jne    801879 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	48 c1 e8 02          	shr    $0x2,%rax
  801863:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80186e:	48 89 c7             	mov    %rax,%rdi
  801871:	48 89 d6             	mov    %rdx,%rsi
  801874:	fc                   	cld    
  801875:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801877:	eb 15                	jmp    80188e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801881:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801885:	48 89 c7             	mov    %rax,%rdi
  801888:	48 89 d6             	mov    %rdx,%rsi
  80188b:	fc                   	cld    
  80188c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80188e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801892:	c9                   	leaveq 
  801893:	c3                   	retq   

0000000000801894 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801894:	55                   	push   %rbp
  801895:	48 89 e5             	mov    %rsp,%rbp
  801898:	48 83 ec 18          	sub    $0x18,%rsp
  80189c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ac:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b4:	48 89 ce             	mov    %rcx,%rsi
  8018b7:	48 89 c7             	mov    %rax,%rdi
  8018ba:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
}
  8018c6:	c9                   	leaveq 
  8018c7:	c3                   	retq   

00000000008018c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018c8:	55                   	push   %rbp
  8018c9:	48 89 e5             	mov    %rsp,%rbp
  8018cc:	48 83 ec 28          	sub    $0x28,%rsp
  8018d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018ec:	eb 36                	jmp    801924 <memcmp+0x5c>
		if (*s1 != *s2)
  8018ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f2:	0f b6 10             	movzbl (%rax),%edx
  8018f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f9:	0f b6 00             	movzbl (%rax),%eax
  8018fc:	38 c2                	cmp    %al,%dl
  8018fe:	74 1a                	je     80191a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	0f b6 d0             	movzbl %al,%edx
  80190a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190e:	0f b6 00             	movzbl (%rax),%eax
  801911:	0f b6 c0             	movzbl %al,%eax
  801914:	29 c2                	sub    %eax,%edx
  801916:	89 d0                	mov    %edx,%eax
  801918:	eb 20                	jmp    80193a <memcmp+0x72>
		s1++, s2++;
  80191a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80191f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801928:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80192c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801930:	48 85 c0             	test   %rax,%rax
  801933:	75 b9                	jne    8018ee <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193a:	c9                   	leaveq 
  80193b:	c3                   	retq   

000000000080193c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80193c:	55                   	push   %rbp
  80193d:	48 89 e5             	mov    %rsp,%rbp
  801940:	48 83 ec 28          	sub    $0x28,%rsp
  801944:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801948:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80194b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80194f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801957:	48 01 d0             	add    %rdx,%rax
  80195a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80195e:	eb 15                	jmp    801975 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801964:	0f b6 10             	movzbl (%rax),%edx
  801967:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80196a:	38 c2                	cmp    %al,%dl
  80196c:	75 02                	jne    801970 <memfind+0x34>
			break;
  80196e:	eb 0f                	jmp    80197f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801970:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801979:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80197d:	72 e1                	jb     801960 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80197f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 34          	sub    $0x34,%rsp
  80198d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801991:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801995:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801998:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80199f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019a6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a7:	eb 05                	jmp    8019ae <strtol+0x29>
		s++;
  8019a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	3c 20                	cmp    $0x20,%al
  8019b7:	74 f0                	je     8019a9 <strtol+0x24>
  8019b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bd:	0f b6 00             	movzbl (%rax),%eax
  8019c0:	3c 09                	cmp    $0x9,%al
  8019c2:	74 e5                	je     8019a9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c8:	0f b6 00             	movzbl (%rax),%eax
  8019cb:	3c 2b                	cmp    $0x2b,%al
  8019cd:	75 07                	jne    8019d6 <strtol+0x51>
		s++;
  8019cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019d4:	eb 17                	jmp    8019ed <strtol+0x68>
	else if (*s == '-')
  8019d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019da:	0f b6 00             	movzbl (%rax),%eax
  8019dd:	3c 2d                	cmp    $0x2d,%al
  8019df:	75 0c                	jne    8019ed <strtol+0x68>
		s++, neg = 1;
  8019e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019f1:	74 06                	je     8019f9 <strtol+0x74>
  8019f3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019f7:	75 28                	jne    801a21 <strtol+0x9c>
  8019f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fd:	0f b6 00             	movzbl (%rax),%eax
  801a00:	3c 30                	cmp    $0x30,%al
  801a02:	75 1d                	jne    801a21 <strtol+0x9c>
  801a04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a08:	48 83 c0 01          	add    $0x1,%rax
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	3c 78                	cmp    $0x78,%al
  801a11:	75 0e                	jne    801a21 <strtol+0x9c>
		s += 2, base = 16;
  801a13:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a18:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a1f:	eb 2c                	jmp    801a4d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a21:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a25:	75 19                	jne    801a40 <strtol+0xbb>
  801a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2b:	0f b6 00             	movzbl (%rax),%eax
  801a2e:	3c 30                	cmp    $0x30,%al
  801a30:	75 0e                	jne    801a40 <strtol+0xbb>
		s++, base = 8;
  801a32:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a37:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a3e:	eb 0d                	jmp    801a4d <strtol+0xc8>
	else if (base == 0)
  801a40:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a44:	75 07                	jne    801a4d <strtol+0xc8>
		base = 10;
  801a46:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a51:	0f b6 00             	movzbl (%rax),%eax
  801a54:	3c 2f                	cmp    $0x2f,%al
  801a56:	7e 1d                	jle    801a75 <strtol+0xf0>
  801a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5c:	0f b6 00             	movzbl (%rax),%eax
  801a5f:	3c 39                	cmp    $0x39,%al
  801a61:	7f 12                	jg     801a75 <strtol+0xf0>
			dig = *s - '0';
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	0f b6 00             	movzbl (%rax),%eax
  801a6a:	0f be c0             	movsbl %al,%eax
  801a6d:	83 e8 30             	sub    $0x30,%eax
  801a70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a73:	eb 4e                	jmp    801ac3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a79:	0f b6 00             	movzbl (%rax),%eax
  801a7c:	3c 60                	cmp    $0x60,%al
  801a7e:	7e 1d                	jle    801a9d <strtol+0x118>
  801a80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a84:	0f b6 00             	movzbl (%rax),%eax
  801a87:	3c 7a                	cmp    $0x7a,%al
  801a89:	7f 12                	jg     801a9d <strtol+0x118>
			dig = *s - 'a' + 10;
  801a8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8f:	0f b6 00             	movzbl (%rax),%eax
  801a92:	0f be c0             	movsbl %al,%eax
  801a95:	83 e8 57             	sub    $0x57,%eax
  801a98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a9b:	eb 26                	jmp    801ac3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	0f b6 00             	movzbl (%rax),%eax
  801aa4:	3c 40                	cmp    $0x40,%al
  801aa6:	7e 48                	jle    801af0 <strtol+0x16b>
  801aa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aac:	0f b6 00             	movzbl (%rax),%eax
  801aaf:	3c 5a                	cmp    $0x5a,%al
  801ab1:	7f 3d                	jg     801af0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	0f be c0             	movsbl %al,%eax
  801abd:	83 e8 37             	sub    $0x37,%eax
  801ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801ac3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ac9:	7c 02                	jl     801acd <strtol+0x148>
			break;
  801acb:	eb 23                	jmp    801af0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801acd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ad2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801adc:	48 89 c2             	mov    %rax,%rdx
  801adf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ae2:	48 98                	cltq   
  801ae4:	48 01 d0             	add    %rdx,%rax
  801ae7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801aeb:	e9 5d ff ff ff       	jmpq   801a4d <strtol+0xc8>

	if (endptr)
  801af0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801af5:	74 0b                	je     801b02 <strtol+0x17d>
		*endptr = (char *) s;
  801af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801afb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aff:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b06:	74 09                	je     801b11 <strtol+0x18c>
  801b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0c:	48 f7 d8             	neg    %rax
  801b0f:	eb 04                	jmp    801b15 <strtol+0x190>
  801b11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 30          	sub    $0x30,%rsp
  801b1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b2f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b33:	0f b6 00             	movzbl (%rax),%eax
  801b36:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b39:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b3d:	75 06                	jne    801b45 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b43:	eb 6b                	jmp    801bb0 <strstr+0x99>

	len = strlen(str);
  801b45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b49:	48 89 c7             	mov    %rax,%rdi
  801b4c:	48 b8 ed 13 80 00 00 	movabs $0x8013ed,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
  801b58:	48 98                	cltq   
  801b5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b6a:	0f b6 00             	movzbl (%rax),%eax
  801b6d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b70:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b74:	75 07                	jne    801b7d <strstr+0x66>
				return (char *) 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	eb 33                	jmp    801bb0 <strstr+0x99>
		} while (sc != c);
  801b7d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b81:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b84:	75 d8                	jne    801b5e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b92:	48 89 ce             	mov    %rcx,%rsi
  801b95:	48 89 c7             	mov    %rax,%rdi
  801b98:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	75 b6                	jne    801b5e <strstr+0x47>

	return (char *) (in - 1);
  801ba8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bac:	48 83 e8 01          	sub    $0x1,%rax
}
  801bb0:	c9                   	leaveq 
  801bb1:	c3                   	retq   

0000000000801bb2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bb2:	55                   	push   %rbp
  801bb3:	48 89 e5             	mov    %rsp,%rbp
  801bb6:	53                   	push   %rbx
  801bb7:	48 83 ec 48          	sub    $0x48,%rsp
  801bbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bbe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bc1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bc5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bc9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bcd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bd4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bd8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bdc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801be0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801be4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801be8:	4c 89 c3             	mov    %r8,%rbx
  801beb:	cd 30                	int    $0x30
  801bed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bf1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bf5:	74 3e                	je     801c35 <syscall+0x83>
  801bf7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bfc:	7e 37                	jle    801c35 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c02:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c05:	49 89 d0             	mov    %rdx,%r8
  801c08:	89 c1                	mov    %eax,%ecx
  801c0a:	48 ba db 44 80 00 00 	movabs $0x8044db,%rdx
  801c11:	00 00 00 
  801c14:	be 23 00 00 00       	mov    $0x23,%esi
  801c19:	48 bf f8 44 80 00 00 	movabs $0x8044f8,%rdi
  801c20:	00 00 00 
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
  801c28:	49 b9 11 05 80 00 00 	movabs $0x800511,%r9
  801c2f:	00 00 00 
  801c32:	41 ff d1             	callq  *%r9

	return ret;
  801c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c39:	48 83 c4 48          	add    $0x48,%rsp
  801c3d:	5b                   	pop    %rbx
  801c3e:	5d                   	pop    %rbp
  801c3f:	c3                   	retq   

0000000000801c40 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 20          	sub    $0x20,%rsp
  801c48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5f:	00 
  801c60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6c:	48 89 d1             	mov    %rdx,%rcx
  801c6f:	48 89 c2             	mov    %rax,%rdx
  801c72:	be 00 00 00 00       	mov    $0x0,%esi
  801c77:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7c:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	callq  *%rax
}
  801c88:	c9                   	leaveq 
  801c89:	c3                   	retq   

0000000000801c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  801c8a:	55                   	push   %rbp
  801c8b:	48 89 e5             	mov    %rsp,%rbp
  801c8e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c99:	00 
  801c9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	be 00 00 00 00       	mov    $0x0,%esi
  801cb5:	bf 01 00 00 00       	mov    $0x1,%edi
  801cba:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801cc1:	00 00 00 
  801cc4:	ff d0                	callq  *%rax
}
  801cc6:	c9                   	leaveq 
  801cc7:	c3                   	retq   

0000000000801cc8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cc8:	55                   	push   %rbp
  801cc9:	48 89 e5             	mov    %rsp,%rbp
  801ccc:	48 83 ec 10          	sub    $0x10,%rsp
  801cd0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd6:	48 98                	cltq   
  801cd8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdf:	00 
  801ce0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf1:	48 89 c2             	mov    %rax,%rdx
  801cf4:	be 01 00 00 00       	mov    $0x1,%esi
  801cf9:	bf 03 00 00 00       	mov    $0x3,%edi
  801cfe:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801d05:	00 00 00 
  801d08:	ff d0                	callq  *%rax
}
  801d0a:	c9                   	leaveq 
  801d0b:	c3                   	retq   

0000000000801d0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d0c:	55                   	push   %rbp
  801d0d:	48 89 e5             	mov    %rsp,%rbp
  801d10:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1b:	00 
  801d1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d32:	be 00 00 00 00       	mov    $0x0,%esi
  801d37:	bf 02 00 00 00       	mov    $0x2,%edi
  801d3c:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax
}
  801d48:	c9                   	leaveq 
  801d49:	c3                   	retq   

0000000000801d4a <sys_yield>:

void
sys_yield(void)
{
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d59:	00 
  801d5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d70:	be 00 00 00 00       	mov    $0x0,%esi
  801d75:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d7a:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 20          	sub    $0x20,%rsp
  801d90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d97:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9d:	48 63 c8             	movslq %eax,%rcx
  801da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	48 98                	cltq   
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	49 89 c8             	mov    %rcx,%r8
  801dba:	48 89 d1             	mov    %rdx,%rcx
  801dbd:	48 89 c2             	mov    %rax,%rdx
  801dc0:	be 01 00 00 00       	mov    $0x1,%esi
  801dc5:	bf 04 00 00 00       	mov    $0x4,%edi
  801dca:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801dd1:	00 00 00 
  801dd4:	ff d0                	callq  *%rax
}
  801dd6:	c9                   	leaveq 
  801dd7:	c3                   	retq   

0000000000801dd8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dd8:	55                   	push   %rbp
  801dd9:	48 89 e5             	mov    %rsp,%rbp
  801ddc:	48 83 ec 30          	sub    $0x30,%rsp
  801de0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801de7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dee:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801df2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801df5:	48 63 c8             	movslq %eax,%rcx
  801df8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dff:	48 63 f0             	movslq %eax,%rsi
  801e02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e09:	48 98                	cltq   
  801e0b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e0f:	49 89 f9             	mov    %rdi,%r9
  801e12:	49 89 f0             	mov    %rsi,%r8
  801e15:	48 89 d1             	mov    %rdx,%rcx
  801e18:	48 89 c2             	mov    %rax,%rdx
  801e1b:	be 01 00 00 00       	mov    $0x1,%esi
  801e20:	bf 05 00 00 00       	mov    $0x5,%edi
  801e25:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 20          	sub    $0x20,%rsp
  801e3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e49:	48 98                	cltq   
  801e4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e52:	00 
  801e53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5f:	48 89 d1             	mov    %rdx,%rcx
  801e62:	48 89 c2             	mov    %rax,%rdx
  801e65:	be 01 00 00 00       	mov    $0x1,%esi
  801e6a:	bf 06 00 00 00       	mov    $0x6,%edi
  801e6f:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
}
  801e7b:	c9                   	leaveq 
  801e7c:	c3                   	retq   

0000000000801e7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e7d:	55                   	push   %rbp
  801e7e:	48 89 e5             	mov    %rsp,%rbp
  801e81:	48 83 ec 10          	sub    $0x10,%rsp
  801e85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e88:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e8e:	48 63 d0             	movslq %eax,%rdx
  801e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e94:	48 98                	cltq   
  801e96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e9d:	00 
  801e9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eaa:	48 89 d1             	mov    %rdx,%rcx
  801ead:	48 89 c2             	mov    %rax,%rdx
  801eb0:	be 01 00 00 00       	mov    $0x1,%esi
  801eb5:	bf 08 00 00 00       	mov    $0x8,%edi
  801eba:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 20          	sub    $0x20,%rsp
  801ed0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ed3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ed7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ede:	48 98                	cltq   
  801ee0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee7:	00 
  801ee8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef4:	48 89 d1             	mov    %rdx,%rcx
  801ef7:	48 89 c2             	mov    %rax,%rdx
  801efa:	be 01 00 00 00       	mov    $0x1,%esi
  801eff:	bf 09 00 00 00       	mov    $0x9,%edi
  801f04:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
}
  801f10:	c9                   	leaveq 
  801f11:	c3                   	retq   

0000000000801f12 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f12:	55                   	push   %rbp
  801f13:	48 89 e5             	mov    %rsp,%rbp
  801f16:	48 83 ec 20          	sub    $0x20,%rsp
  801f1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f28:	48 98                	cltq   
  801f2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f31:	00 
  801f32:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f3e:	48 89 d1             	mov    %rdx,%rcx
  801f41:	48 89 c2             	mov    %rax,%rdx
  801f44:	be 01 00 00 00       	mov    $0x1,%esi
  801f49:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f4e:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801f55:	00 00 00 
  801f58:	ff d0                	callq  *%rax
}
  801f5a:	c9                   	leaveq 
  801f5b:	c3                   	retq   

0000000000801f5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f5c:	55                   	push   %rbp
  801f5d:	48 89 e5             	mov    %rsp,%rbp
  801f60:	48 83 ec 20          	sub    $0x20,%rsp
  801f64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f6b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f6f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f75:	48 63 f0             	movslq %eax,%rsi
  801f78:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7f:	48 98                	cltq   
  801f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f8c:	00 
  801f8d:	49 89 f1             	mov    %rsi,%r9
  801f90:	49 89 c8             	mov    %rcx,%r8
  801f93:	48 89 d1             	mov    %rdx,%rcx
  801f96:	48 89 c2             	mov    %rax,%rdx
  801f99:	be 00 00 00 00       	mov    $0x0,%esi
  801f9e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fa3:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
}
  801faf:	c9                   	leaveq 
  801fb0:	c3                   	retq   

0000000000801fb1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fb1:	55                   	push   %rbp
  801fb2:	48 89 e5             	mov    %rsp,%rbp
  801fb5:	48 83 ec 10          	sub    $0x10,%rsp
  801fb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fc8:	00 
  801fc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fda:	48 89 c2             	mov    %rax,%rdx
  801fdd:	be 01 00 00 00       	mov    $0x1,%esi
  801fe2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fe7:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801fee:	00 00 00 
  801ff1:	ff d0                	callq  *%rax
}
  801ff3:	c9                   	leaveq 
  801ff4:	c3                   	retq   

0000000000801ff5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ff5:	55                   	push   %rbp
  801ff6:	48 89 e5             	mov    %rsp,%rbp
  801ff9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ffd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802004:	00 
  802005:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80200b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802011:	b9 00 00 00 00       	mov    $0x0,%ecx
  802016:	ba 00 00 00 00       	mov    $0x0,%edx
  80201b:	be 00 00 00 00       	mov    $0x0,%esi
  802020:	bf 0e 00 00 00       	mov    $0xe,%edi
  802025:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	callq  *%rax
}
  802031:	c9                   	leaveq 
  802032:	c3                   	retq   

0000000000802033 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802033:	55                   	push   %rbp
  802034:	48 89 e5             	mov    %rsp,%rbp
  802037:	48 83 ec 30          	sub    $0x30,%rsp
  80203b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80203e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802042:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802045:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802049:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80204d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802050:	48 63 c8             	movslq %eax,%rcx
  802053:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802057:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80205a:	48 63 f0             	movslq %eax,%rsi
  80205d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802064:	48 98                	cltq   
  802066:	48 89 0c 24          	mov    %rcx,(%rsp)
  80206a:	49 89 f9             	mov    %rdi,%r9
  80206d:	49 89 f0             	mov    %rsi,%r8
  802070:	48 89 d1             	mov    %rdx,%rcx
  802073:	48 89 c2             	mov    %rax,%rdx
  802076:	be 00 00 00 00       	mov    $0x0,%esi
  80207b:	bf 0f 00 00 00       	mov    $0xf,%edi
  802080:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80208c:	c9                   	leaveq 
  80208d:	c3                   	retq   

000000000080208e <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	48 83 ec 20          	sub    $0x20,%rsp
  802096:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80209a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80209e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020ad:	00 
  8020ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ba:	48 89 d1             	mov    %rdx,%rcx
  8020bd:	48 89 c2             	mov    %rax,%rdx
  8020c0:	be 00 00 00 00       	mov    $0x0,%esi
  8020c5:	bf 10 00 00 00       	mov    $0x10,%edi
  8020ca:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
}
  8020d6:	c9                   	leaveq 
  8020d7:	c3                   	retq   

00000000008020d8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
  8020dc:	48 83 ec 08          	sub    $0x8,%rsp
  8020e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020e8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020ef:	ff ff ff 
  8020f2:	48 01 d0             	add    %rdx,%rax
  8020f5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020f9:	c9                   	leaveq 
  8020fa:	c3                   	retq   

00000000008020fb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 08          	sub    $0x8,%rsp
  802103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210b:	48 89 c7             	mov    %rax,%rdi
  80210e:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
  80211a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802120:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802124:	c9                   	leaveq 
  802125:	c3                   	retq   

0000000000802126 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 18          	sub    $0x18,%rsp
  80212e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802139:	eb 6b                	jmp    8021a6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80213b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213e:	48 98                	cltq   
  802140:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802146:	48 c1 e0 0c          	shl    $0xc,%rax
  80214a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80214e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802152:	48 c1 e8 15          	shr    $0x15,%rax
  802156:	48 89 c2             	mov    %rax,%rdx
  802159:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802160:	01 00 00 
  802163:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802167:	83 e0 01             	and    $0x1,%eax
  80216a:	48 85 c0             	test   %rax,%rax
  80216d:	74 21                	je     802190 <fd_alloc+0x6a>
  80216f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802173:	48 c1 e8 0c          	shr    $0xc,%rax
  802177:	48 89 c2             	mov    %rax,%rdx
  80217a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802181:	01 00 00 
  802184:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802188:	83 e0 01             	and    $0x1,%eax
  80218b:	48 85 c0             	test   %rax,%rax
  80218e:	75 12                	jne    8021a2 <fd_alloc+0x7c>
			*fd_store = fd;
  802190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802194:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802198:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	eb 1a                	jmp    8021bc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021a6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021aa:	7e 8f                	jle    80213b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021b7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 20          	sub    $0x20,%rsp
  8021c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021d1:	78 06                	js     8021d9 <fd_lookup+0x1b>
  8021d3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021d7:	7e 07                	jle    8021e0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021de:	eb 6c                	jmp    80224c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021e3:	48 98                	cltq   
  8021e5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021eb:	48 c1 e0 0c          	shl    $0xc,%rax
  8021ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f7:	48 c1 e8 15          	shr    $0x15,%rax
  8021fb:	48 89 c2             	mov    %rax,%rdx
  8021fe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802205:	01 00 00 
  802208:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220c:	83 e0 01             	and    $0x1,%eax
  80220f:	48 85 c0             	test   %rax,%rax
  802212:	74 21                	je     802235 <fd_lookup+0x77>
  802214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802218:	48 c1 e8 0c          	shr    $0xc,%rax
  80221c:	48 89 c2             	mov    %rax,%rdx
  80221f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802226:	01 00 00 
  802229:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222d:	83 e0 01             	and    $0x1,%eax
  802230:	48 85 c0             	test   %rax,%rax
  802233:	75 07                	jne    80223c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802235:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223a:	eb 10                	jmp    80224c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80223c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802240:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802244:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224c:	c9                   	leaveq 
  80224d:	c3                   	retq   

000000000080224e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80224e:	55                   	push   %rbp
  80224f:	48 89 e5             	mov    %rsp,%rbp
  802252:	48 83 ec 30          	sub    $0x30,%rsp
  802256:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80225a:	89 f0                	mov    %esi,%eax
  80225c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80225f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802263:	48 89 c7             	mov    %rax,%rdi
  802266:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  80226d:	00 00 00 
  802270:	ff d0                	callq  *%rax
  802272:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802276:	48 89 d6             	mov    %rdx,%rsi
  802279:	89 c7                	mov    %eax,%edi
  80227b:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  802282:	00 00 00 
  802285:	ff d0                	callq  *%rax
  802287:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80228a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228e:	78 0a                	js     80229a <fd_close+0x4c>
	    || fd != fd2)
  802290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802294:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802298:	74 12                	je     8022ac <fd_close+0x5e>
		return (must_exist ? r : 0);
  80229a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80229e:	74 05                	je     8022a5 <fd_close+0x57>
  8022a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a3:	eb 05                	jmp    8022aa <fd_close+0x5c>
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022aa:	eb 69                	jmp    802315 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b0:	8b 00                	mov    (%rax),%eax
  8022b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b6:	48 89 d6             	mov    %rdx,%rsi
  8022b9:	89 c7                	mov    %eax,%edi
  8022bb:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	callq  *%rax
  8022c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ce:	78 2a                	js     8022fa <fd_close+0xac>
		if (dev->dev_close)
  8022d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d8:	48 85 c0             	test   %rax,%rax
  8022db:	74 16                	je     8022f3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022e9:	48 89 d7             	mov    %rdx,%rdi
  8022ec:	ff d0                	callq  *%rax
  8022ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f1:	eb 07                	jmp    8022fa <fd_close+0xac>
		else
			r = 0;
  8022f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022fe:	48 89 c6             	mov    %rax,%rsi
  802301:	bf 00 00 00 00       	mov    $0x0,%edi
  802306:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
	return r;
  802312:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 20          	sub    $0x20,%rsp
  80231f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80232d:	eb 41                	jmp    802370 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80232f:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802336:	00 00 00 
  802339:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80233c:	48 63 d2             	movslq %edx,%rdx
  80233f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802343:	8b 00                	mov    (%rax),%eax
  802345:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802348:	75 22                	jne    80236c <dev_lookup+0x55>
			*dev = devtab[i];
  80234a:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802351:	00 00 00 
  802354:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802357:	48 63 d2             	movslq %edx,%rdx
  80235a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80235e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802362:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	eb 60                	jmp    8023cc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80236c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802370:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802377:	00 00 00 
  80237a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80237d:	48 63 d2             	movslq %edx,%rdx
  802380:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802384:	48 85 c0             	test   %rax,%rax
  802387:	75 a6                	jne    80232f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802389:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802390:	00 00 00 
  802393:	48 8b 00             	mov    (%rax),%rax
  802396:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80239c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	48 bf 08 45 80 00 00 	movabs $0x804508,%rdi
  8023a8:	00 00 00 
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b0:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  8023b7:	00 00 00 
  8023ba:	ff d1                	callq  *%rcx
	*dev = 0;
  8023bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <close>:

int
close(int fdnum)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 20          	sub    $0x20,%rsp
  8023d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	79 05                	jns    8023ff <close+0x31>
		return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	eb 18                	jmp    802417 <close+0x49>
	else
		return fd_close(fd, 1);
  8023ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802403:	be 01 00 00 00       	mov    $0x1,%esi
  802408:	48 89 c7             	mov    %rax,%rdi
  80240b:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  802412:	00 00 00 
  802415:	ff d0                	callq  *%rax
}
  802417:	c9                   	leaveq 
  802418:	c3                   	retq   

0000000000802419 <close_all>:

void
close_all(void)
{
  802419:	55                   	push   %rbp
  80241a:	48 89 e5             	mov    %rsp,%rbp
  80241d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802428:	eb 15                	jmp    80243f <close_all+0x26>
		close(i);
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	89 c7                	mov    %eax,%edi
  80242f:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80243b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80243f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802443:	7e e5                	jle    80242a <close_all+0x11>
		close(i);
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 40          	sub    $0x40,%rsp
  80244f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802452:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802455:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802459:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80245c:	48 89 d6             	mov    %rdx,%rsi
  80245f:	89 c7                	mov    %eax,%edi
  802461:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  802468:	00 00 00 
  80246b:	ff d0                	callq  *%rax
  80246d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802474:	79 08                	jns    80247e <dup+0x37>
		return r;
  802476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802479:	e9 70 01 00 00       	jmpq   8025ee <dup+0x1a7>
	close(newfdnum);
  80247e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802481:	89 c7                	mov    %eax,%edi
  802483:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80248f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802492:	48 98                	cltq   
  802494:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80249a:	48 c1 e0 0c          	shl    $0xc,%rax
  80249e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a6:	48 89 c7             	mov    %rax,%rdi
  8024a9:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	callq  *%rax
  8024b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bd:	48 89 c7             	mov    %rax,%rdi
  8024c0:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
  8024cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d4:	48 c1 e8 15          	shr    $0x15,%rax
  8024d8:	48 89 c2             	mov    %rax,%rdx
  8024db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e2:	01 00 00 
  8024e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e9:	83 e0 01             	and    $0x1,%eax
  8024ec:	48 85 c0             	test   %rax,%rax
  8024ef:	74 73                	je     802564 <dup+0x11d>
  8024f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8024f9:	48 89 c2             	mov    %rax,%rdx
  8024fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802503:	01 00 00 
  802506:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250a:	83 e0 01             	and    $0x1,%eax
  80250d:	48 85 c0             	test   %rax,%rax
  802510:	74 52                	je     802564 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802516:	48 c1 e8 0c          	shr    $0xc,%rax
  80251a:	48 89 c2             	mov    %rax,%rdx
  80251d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802524:	01 00 00 
  802527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252b:	25 07 0e 00 00       	and    $0xe07,%eax
  802530:	89 c1                	mov    %eax,%ecx
  802532:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253a:	41 89 c8             	mov    %ecx,%r8d
  80253d:	48 89 d1             	mov    %rdx,%rcx
  802540:	ba 00 00 00 00       	mov    $0x0,%edx
  802545:	48 89 c6             	mov    %rax,%rsi
  802548:	bf 00 00 00 00       	mov    $0x0,%edi
  80254d:	48 b8 d8 1d 80 00 00 	movabs $0x801dd8,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	79 02                	jns    802564 <dup+0x11d>
			goto err;
  802562:	eb 57                	jmp    8025bb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802568:	48 c1 e8 0c          	shr    $0xc,%rax
  80256c:	48 89 c2             	mov    %rax,%rdx
  80256f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802576:	01 00 00 
  802579:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257d:	25 07 0e 00 00       	and    $0xe07,%eax
  802582:	89 c1                	mov    %eax,%ecx
  802584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802588:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258c:	41 89 c8             	mov    %ecx,%r8d
  80258f:	48 89 d1             	mov    %rdx,%rcx
  802592:	ba 00 00 00 00       	mov    $0x0,%edx
  802597:	48 89 c6             	mov    %rax,%rsi
  80259a:	bf 00 00 00 00       	mov    $0x0,%edi
  80259f:	48 b8 d8 1d 80 00 00 	movabs $0x801dd8,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax
  8025ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b2:	79 02                	jns    8025b6 <dup+0x16f>
		goto err;
  8025b4:	eb 05                	jmp    8025bb <dup+0x174>

	return newfdnum;
  8025b6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025b9:	eb 33                	jmp    8025ee <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	48 89 c6             	mov    %rax,%rsi
  8025c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c7:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d7:	48 89 c6             	mov    %rax,%rsi
  8025da:	bf 00 00 00 00       	mov    $0x0,%edi
  8025df:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax
	return r;
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025ee:	c9                   	leaveq 
  8025ef:	c3                   	retq   

00000000008025f0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025f0:	55                   	push   %rbp
  8025f1:	48 89 e5             	mov    %rsp,%rbp
  8025f4:	48 83 ec 40          	sub    $0x40,%rsp
  8025f8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025ff:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802603:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802607:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260a:	48 89 d6             	mov    %rdx,%rsi
  80260d:	89 c7                	mov    %eax,%edi
  80260f:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
  80261b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802622:	78 24                	js     802648 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802628:	8b 00                	mov    (%rax),%eax
  80262a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262e:	48 89 d6             	mov    %rdx,%rsi
  802631:	89 c7                	mov    %eax,%edi
  802633:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
  80263f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802646:	79 05                	jns    80264d <read+0x5d>
		return r;
  802648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264b:	eb 76                	jmp    8026c3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80264d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802651:	8b 40 08             	mov    0x8(%rax),%eax
  802654:	83 e0 03             	and    $0x3,%eax
  802657:	83 f8 01             	cmp    $0x1,%eax
  80265a:	75 3a                	jne    802696 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80265c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802663:	00 00 00 
  802666:	48 8b 00             	mov    (%rax),%rax
  802669:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802672:	89 c6                	mov    %eax,%esi
  802674:	48 bf 27 45 80 00 00 	movabs $0x804527,%rdi
  80267b:	00 00 00 
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  80268a:	00 00 00 
  80268d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80268f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802694:	eb 2d                	jmp    8026c3 <read+0xd3>
	}
	if (!dev->dev_read)
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 07                	jne    8026aa <read+0xba>
		return -E_NOT_SUPP;
  8026a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a8:	eb 19                	jmp    8026c3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ae:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026be:	48 89 cf             	mov    %rcx,%rdi
  8026c1:	ff d0                	callq  *%rax
}
  8026c3:	c9                   	leaveq 
  8026c4:	c3                   	retq   

00000000008026c5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026c5:	55                   	push   %rbp
  8026c6:	48 89 e5             	mov    %rsp,%rbp
  8026c9:	48 83 ec 30          	sub    $0x30,%rsp
  8026cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026df:	eb 49                	jmp    80272a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e4:	48 98                	cltq   
  8026e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ea:	48 29 c2             	sub    %rax,%rdx
  8026ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f0:	48 63 c8             	movslq %eax,%rcx
  8026f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f7:	48 01 c1             	add    %rax,%rcx
  8026fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026fd:	48 89 ce             	mov    %rcx,%rsi
  802700:	89 c7                	mov    %eax,%edi
  802702:	48 b8 f0 25 80 00 00 	movabs $0x8025f0,%rax
  802709:	00 00 00 
  80270c:	ff d0                	callq  *%rax
  80270e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802711:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802715:	79 05                	jns    80271c <readn+0x57>
			return m;
  802717:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80271a:	eb 1c                	jmp    802738 <readn+0x73>
		if (m == 0)
  80271c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802720:	75 02                	jne    802724 <readn+0x5f>
			break;
  802722:	eb 11                	jmp    802735 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802724:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802727:	01 45 fc             	add    %eax,-0x4(%rbp)
  80272a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272d:	48 98                	cltq   
  80272f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802733:	72 ac                	jb     8026e1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802735:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802738:	c9                   	leaveq 
  802739:	c3                   	retq   

000000000080273a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80273a:	55                   	push   %rbp
  80273b:	48 89 e5             	mov    %rsp,%rbp
  80273e:	48 83 ec 40          	sub    $0x40,%rsp
  802742:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802745:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802749:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80274d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802751:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802754:	48 89 d6             	mov    %rdx,%rsi
  802757:	89 c7                	mov    %eax,%edi
  802759:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  802760:	00 00 00 
  802763:	ff d0                	callq  *%rax
  802765:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802768:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276c:	78 24                	js     802792 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80276e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802772:	8b 00                	mov    (%rax),%eax
  802774:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802778:	48 89 d6             	mov    %rdx,%rsi
  80277b:	89 c7                	mov    %eax,%edi
  80277d:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802790:	79 05                	jns    802797 <write+0x5d>
		return r;
  802792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802795:	eb 42                	jmp    8027d9 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	8b 40 08             	mov    0x8(%rax),%eax
  80279e:	83 e0 03             	and    $0x3,%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	75 07                	jne    8027ac <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027aa:	eb 2d                	jmp    8027d9 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027b4:	48 85 c0             	test   %rax,%rax
  8027b7:	75 07                	jne    8027c0 <write+0x86>
		return -E_NOT_SUPP;
  8027b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027be:	eb 19                	jmp    8027d9 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8027c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027d0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027d4:	48 89 cf             	mov    %rcx,%rdi
  8027d7:	ff d0                	callq  *%rax
}
  8027d9:	c9                   	leaveq 
  8027da:	c3                   	retq   

00000000008027db <seek>:

int
seek(int fdnum, off_t offset)
{
  8027db:	55                   	push   %rbp
  8027dc:	48 89 e5             	mov    %rsp,%rbp
  8027df:	48 83 ec 18          	sub    $0x18,%rsp
  8027e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027e6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f0:	48 89 d6             	mov    %rdx,%rsi
  8027f3:	89 c7                	mov    %eax,%edi
  8027f5:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
  802801:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802804:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802808:	79 05                	jns    80280f <seek+0x34>
		return r;
  80280a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280d:	eb 0f                	jmp    80281e <seek+0x43>
	fd->fd_offset = offset;
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802816:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 30          	sub    $0x30,%rsp
  802828:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80282b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802832:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802835:	48 89 d6             	mov    %rdx,%rsi
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284d:	78 24                	js     802873 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80284f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802853:	8b 00                	mov    (%rax),%eax
  802855:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802859:	48 89 d6             	mov    %rdx,%rsi
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
  80286a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802871:	79 05                	jns    802878 <ftruncate+0x58>
		return r;
  802873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802876:	eb 72                	jmp    8028ea <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	8b 40 08             	mov    0x8(%rax),%eax
  80287f:	83 e0 03             	and    $0x3,%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	75 3a                	jne    8028c0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802886:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80288d:	00 00 00 
  802890:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802893:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802899:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80289c:	89 c6                	mov    %eax,%esi
  80289e:	48 bf 48 45 80 00 00 	movabs $0x804548,%rdi
  8028a5:	00 00 00 
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  8028b4:	00 00 00 
  8028b7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028be:	eb 2a                	jmp    8028ea <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028c8:	48 85 c0             	test   %rax,%rax
  8028cb:	75 07                	jne    8028d4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d2:	eb 16                	jmp    8028ea <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8028e3:	89 ce                	mov    %ecx,%esi
  8028e5:	48 89 d7             	mov    %rdx,%rdi
  8028e8:	ff d0                	callq  *%rax
}
  8028ea:	c9                   	leaveq 
  8028eb:	c3                   	retq   

00000000008028ec <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8028ec:	55                   	push   %rbp
  8028ed:	48 89 e5             	mov    %rsp,%rbp
  8028f0:	48 83 ec 30          	sub    $0x30,%rsp
  8028f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802902:	48 89 d6             	mov    %rdx,%rsi
  802905:	89 c7                	mov    %eax,%edi
  802907:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax
  802913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291a:	78 24                	js     802940 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80291c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802920:	8b 00                	mov    (%rax),%eax
  802922:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802926:	48 89 d6             	mov    %rdx,%rsi
  802929:	89 c7                	mov    %eax,%edi
  80292b:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  802932:	00 00 00 
  802935:	ff d0                	callq  *%rax
  802937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293e:	79 05                	jns    802945 <fstat+0x59>
		return r;
  802940:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802943:	eb 5e                	jmp    8029a3 <fstat+0xb7>
	if (!dev->dev_stat)
  802945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802949:	48 8b 40 28          	mov    0x28(%rax),%rax
  80294d:	48 85 c0             	test   %rax,%rax
  802950:	75 07                	jne    802959 <fstat+0x6d>
		return -E_NOT_SUPP;
  802952:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802957:	eb 4a                	jmp    8029a3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802959:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80295d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802960:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802964:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80296b:	00 00 00 
	stat->st_isdir = 0;
  80296e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802972:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802979:	00 00 00 
	stat->st_dev = dev;
  80297c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802980:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802984:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802997:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80299b:	48 89 ce             	mov    %rcx,%rsi
  80299e:	48 89 d7             	mov    %rdx,%rdi
  8029a1:	ff d0                	callq  *%rax
}
  8029a3:	c9                   	leaveq 
  8029a4:	c3                   	retq   

00000000008029a5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029a5:	55                   	push   %rbp
  8029a6:	48 89 e5             	mov    %rsp,%rbp
  8029a9:	48 83 ec 20          	sub    $0x20,%rsp
  8029ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b9:	be 00 00 00 00       	mov    $0x0,%esi
  8029be:	48 89 c7             	mov    %rax,%rdi
  8029c1:	48 b8 93 2a 80 00 00 	movabs $0x802a93,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d4:	79 05                	jns    8029db <stat+0x36>
		return fd;
  8029d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d9:	eb 2f                	jmp    802a0a <stat+0x65>
	r = fstat(fd, stat);
  8029db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e2:	48 89 d6             	mov    %rdx,%rsi
  8029e5:	89 c7                	mov    %eax,%edi
  8029e7:	48 b8 ec 28 80 00 00 	movabs $0x8028ec,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f9:	89 c7                	mov    %eax,%edi
  8029fb:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
	return r;
  802a07:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a0a:	c9                   	leaveq 
  802a0b:	c3                   	retq   

0000000000802a0c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a0c:	55                   	push   %rbp
  802a0d:	48 89 e5             	mov    %rsp,%rbp
  802a10:	48 83 ec 10          	sub    $0x10,%rsp
  802a14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a1b:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a22:	00 00 00 
  802a25:	8b 00                	mov    (%rax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	75 1d                	jne    802a48 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a2b:	bf 01 00 00 00       	mov    $0x1,%edi
  802a30:	48 b8 41 3e 80 00 00 	movabs $0x803e41,%rax
  802a37:	00 00 00 
  802a3a:	ff d0                	callq  *%rax
  802a3c:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  802a43:	00 00 00 
  802a46:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a48:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a4f:	00 00 00 
  802a52:	8b 00                	mov    (%rax),%eax
  802a54:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a57:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a5c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a63:	00 00 00 
  802a66:	89 c7                	mov    %eax,%edi
  802a68:	48 b8 74 3a 80 00 00 	movabs $0x803a74,%rax
  802a6f:	00 00 00 
  802a72:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a78:	ba 00 00 00 00       	mov    $0x0,%edx
  802a7d:	48 89 c6             	mov    %rax,%rsi
  802a80:	bf 00 00 00 00       	mov    $0x0,%edi
  802a85:	48 b8 76 39 80 00 00 	movabs $0x803976,%rax
  802a8c:	00 00 00 
  802a8f:	ff d0                	callq  *%rax
}
  802a91:	c9                   	leaveq 
  802a92:	c3                   	retq   

0000000000802a93 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a93:	55                   	push   %rbp
  802a94:	48 89 e5             	mov    %rsp,%rbp
  802a97:	48 83 ec 30          	sub    $0x30,%rsp
  802a9b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a9f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802aa2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802aa9:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802ab7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802abc:	75 08                	jne    802ac6 <open+0x33>
	{
		return r;
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	e9 f2 00 00 00       	jmpq   802bb8 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aca:	48 89 c7             	mov    %rax,%rdi
  802acd:	48 b8 ed 13 80 00 00 	movabs $0x8013ed,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
  802ad9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802adc:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ae3:	7e 0a                	jle    802aef <open+0x5c>
	{
		return -E_BAD_PATH;
  802ae5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802aea:	e9 c9 00 00 00       	jmpq   802bb8 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802aef:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802af6:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802af7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802afb:	48 89 c7             	mov    %rax,%rdi
  802afe:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
  802b0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b11:	78 09                	js     802b1c <open+0x89>
  802b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b17:	48 85 c0             	test   %rax,%rax
  802b1a:	75 08                	jne    802b24 <open+0x91>
		{
			return r;
  802b1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1f:	e9 94 00 00 00       	jmpq   802bb8 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b28:	ba 00 04 00 00       	mov    $0x400,%edx
  802b2d:	48 89 c6             	mov    %rax,%rsi
  802b30:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b37:	00 00 00 
  802b3a:	48 b8 eb 14 80 00 00 	movabs $0x8014eb,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802b46:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4d:	00 00 00 
  802b50:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802b53:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5d:	48 89 c6             	mov    %rax,%rsi
  802b60:	bf 01 00 00 00       	mov    $0x1,%edi
  802b65:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	79 2b                	jns    802ba5 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7e:	be 00 00 00 00       	mov    $0x0,%esi
  802b83:	48 89 c7             	mov    %rax,%rdi
  802b86:	48 b8 4e 22 80 00 00 	movabs $0x80224e,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
  802b92:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802b95:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b99:	79 05                	jns    802ba0 <open+0x10d>
			{
				return d;
  802b9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b9e:	eb 18                	jmp    802bb8 <open+0x125>
			}
			return r;
  802ba0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba3:	eb 13                	jmp    802bb8 <open+0x125>
		}	
		return fd2num(fd_store);
  802ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba9:	48 89 c7             	mov    %rax,%rdi
  802bac:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802bb8:	c9                   	leaveq 
  802bb9:	c3                   	retq   

0000000000802bba <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bba:	55                   	push   %rbp
  802bbb:	48 89 e5             	mov    %rsp,%rbp
  802bbe:	48 83 ec 10          	sub    $0x10,%rsp
  802bc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bca:	8b 50 0c             	mov    0xc(%rax),%edx
  802bcd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd4:	00 00 00 
  802bd7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bd9:	be 00 00 00 00       	mov    $0x0,%esi
  802bde:	bf 06 00 00 00       	mov    $0x6,%edi
  802be3:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
}
  802bef:	c9                   	leaveq 
  802bf0:	c3                   	retq   

0000000000802bf1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802bf1:	55                   	push   %rbp
  802bf2:	48 89 e5             	mov    %rsp,%rbp
  802bf5:	48 83 ec 30          	sub    $0x30,%rsp
  802bf9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c11:	74 07                	je     802c1a <devfile_read+0x29>
  802c13:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c18:	75 07                	jne    802c21 <devfile_read+0x30>
		return -E_INVAL;
  802c1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1f:	eb 77                	jmp    802c98 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	8b 50 0c             	mov    0xc(%rax),%edx
  802c28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c2f:	00 00 00 
  802c32:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c34:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c3b:	00 00 00 
  802c3e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c42:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802c46:	be 00 00 00 00       	mov    $0x0,%esi
  802c4b:	bf 03 00 00 00       	mov    $0x3,%edi
  802c50:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802c57:	00 00 00 
  802c5a:	ff d0                	callq  *%rax
  802c5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c63:	7f 05                	jg     802c6a <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c68:	eb 2e                	jmp    802c98 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	48 63 d0             	movslq %eax,%rdx
  802c70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c74:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c7b:	00 00 00 
  802c7e:	48 89 c7             	mov    %rax,%rdi
  802c81:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802c8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802c98:	c9                   	leaveq 
  802c99:	c3                   	retq   

0000000000802c9a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c9a:	55                   	push   %rbp
  802c9b:	48 89 e5             	mov    %rsp,%rbp
  802c9e:	48 83 ec 30          	sub    $0x30,%rsp
  802ca2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802caa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802cae:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802cb5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cba:	74 07                	je     802cc3 <devfile_write+0x29>
  802cbc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cc1:	75 08                	jne    802ccb <devfile_write+0x31>
		return r;
  802cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc6:	e9 9a 00 00 00       	jmpq   802d65 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccf:	8b 50 0c             	mov    0xc(%rax),%edx
  802cd2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd9:	00 00 00 
  802cdc:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802cde:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ce5:	00 
  802ce6:	76 08                	jbe    802cf0 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802ce8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802cef:	00 
	}
	fsipcbuf.write.req_n = n;
  802cf0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cf7:	00 00 00 
  802cfa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cfe:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d02:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d0a:	48 89 c6             	mov    %rax,%rsi
  802d0d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d14:	00 00 00 
  802d17:	48 b8 7d 17 80 00 00 	movabs $0x80177d,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802d23:	be 00 00 00 00       	mov    $0x0,%esi
  802d28:	bf 04 00 00 00       	mov    $0x4,%edi
  802d2d:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
  802d39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d40:	7f 20                	jg     802d62 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802d42:	48 bf 6e 45 80 00 00 	movabs $0x80456e,%rdi
  802d49:	00 00 00 
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d51:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802d58:	00 00 00 
  802d5b:	ff d2                	callq  *%rdx
		return r;
  802d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d60:	eb 03                	jmp    802d65 <devfile_write+0xcb>
	}
	return r;
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d65:	c9                   	leaveq 
  802d66:	c3                   	retq   

0000000000802d67 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d67:	55                   	push   %rbp
  802d68:	48 89 e5             	mov    %rsp,%rbp
  802d6b:	48 83 ec 20          	sub    $0x20,%rsp
  802d6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d85:	00 00 00 
  802d88:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d8a:	be 00 00 00 00       	mov    $0x0,%esi
  802d8f:	bf 05 00 00 00       	mov    $0x5,%edi
  802d94:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax
  802da0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da7:	79 05                	jns    802dae <devfile_stat+0x47>
		return r;
  802da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dac:	eb 56                	jmp    802e04 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802db2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802db9:	00 00 00 
  802dbc:	48 89 c7             	mov    %rax,%rdi
  802dbf:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802dcb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd2:	00 00 00 
  802dd5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ddb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ddf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802de5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dec:	00 00 00 
  802def:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802df5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   

0000000000802e06 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e06:	55                   	push   %rbp
  802e07:	48 89 e5             	mov    %rsp,%rbp
  802e0a:	48 83 ec 10          	sub    $0x10,%rsp
  802e0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e12:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e19:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e23:	00 00 00 
  802e26:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e2f:	00 00 00 
  802e32:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e38:	be 00 00 00 00       	mov    $0x0,%esi
  802e3d:	bf 02 00 00 00       	mov    $0x2,%edi
  802e42:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
}
  802e4e:	c9                   	leaveq 
  802e4f:	c3                   	retq   

0000000000802e50 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e50:	55                   	push   %rbp
  802e51:	48 89 e5             	mov    %rsp,%rbp
  802e54:	48 83 ec 10          	sub    $0x10,%rsp
  802e58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e60:	48 89 c7             	mov    %rax,%rdi
  802e63:	48 b8 ed 13 80 00 00 	movabs $0x8013ed,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e74:	7e 07                	jle    802e7d <remove+0x2d>
		return -E_BAD_PATH;
  802e76:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e7b:	eb 33                	jmp    802eb0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e81:	48 89 c6             	mov    %rax,%rsi
  802e84:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e8b:	00 00 00 
  802e8e:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e9a:	be 00 00 00 00       	mov    $0x0,%esi
  802e9f:	bf 07 00 00 00       	mov    $0x7,%edi
  802ea4:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
}
  802eb0:	c9                   	leaveq 
  802eb1:	c3                   	retq   

0000000000802eb2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802eb2:	55                   	push   %rbp
  802eb3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802eb6:	be 00 00 00 00       	mov    $0x0,%esi
  802ebb:	bf 08 00 00 00       	mov    $0x8,%edi
  802ec0:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
}
  802ecc:	5d                   	pop    %rbp
  802ecd:	c3                   	retq   

0000000000802ece <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ece:	55                   	push   %rbp
  802ecf:	48 89 e5             	mov    %rsp,%rbp
  802ed2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ed9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ee0:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ee7:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802eee:	be 00 00 00 00       	mov    $0x0,%esi
  802ef3:	48 89 c7             	mov    %rax,%rdi
  802ef6:	48 b8 93 2a 80 00 00 	movabs $0x802a93,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
  802f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f09:	79 28                	jns    802f33 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0e:	89 c6                	mov    %eax,%esi
  802f10:	48 bf 8a 45 80 00 00 	movabs $0x80458a,%rdi
  802f17:	00 00 00 
  802f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1f:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802f26:	00 00 00 
  802f29:	ff d2                	callq  *%rdx
		return fd_src;
  802f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2e:	e9 74 01 00 00       	jmpq   8030a7 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f33:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f3a:	be 01 01 00 00       	mov    $0x101,%esi
  802f3f:	48 89 c7             	mov    %rax,%rdi
  802f42:	48 b8 93 2a 80 00 00 	movabs $0x802a93,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
  802f4e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f51:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f55:	79 39                	jns    802f90 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f5a:	89 c6                	mov    %eax,%esi
  802f5c:	48 bf a0 45 80 00 00 	movabs $0x8045a0,%rdi
  802f63:	00 00 00 
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6b:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802f72:	00 00 00 
  802f75:	ff d2                	callq  *%rdx
		close(fd_src);
  802f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7a:	89 c7                	mov    %eax,%edi
  802f7c:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
		return fd_dest;
  802f88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f8b:	e9 17 01 00 00       	jmpq   8030a7 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f90:	eb 74                	jmp    803006 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802f92:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f95:	48 63 d0             	movslq %eax,%rdx
  802f98:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa2:	48 89 ce             	mov    %rcx,%rsi
  802fa5:	89 c7                	mov    %eax,%edi
  802fa7:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
  802fb3:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fba:	79 4a                	jns    803006 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802fbc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fbf:	89 c6                	mov    %eax,%esi
  802fc1:	48 bf ba 45 80 00 00 	movabs $0x8045ba,%rdi
  802fc8:	00 00 00 
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd0:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802fd7:	00 00 00 
  802fda:	ff d2                	callq  *%rdx
			close(fd_src);
  802fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdf:	89 c7                	mov    %eax,%edi
  802fe1:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
			close(fd_dest);
  802fed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ff0:	89 c7                	mov    %eax,%edi
  802ff2:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
			return write_size;
  802ffe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803001:	e9 a1 00 00 00       	jmpq   8030a7 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803006:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80300d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803010:	ba 00 02 00 00       	mov    $0x200,%edx
  803015:	48 89 ce             	mov    %rcx,%rsi
  803018:	89 c7                	mov    %eax,%edi
  80301a:	48 b8 f0 25 80 00 00 	movabs $0x8025f0,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
  803026:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80302d:	0f 8f 5f ff ff ff    	jg     802f92 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803033:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803037:	79 47                	jns    803080 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803039:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80303c:	89 c6                	mov    %eax,%esi
  80303e:	48 bf cd 45 80 00 00 	movabs $0x8045cd,%rdi
  803045:	00 00 00 
  803048:	b8 00 00 00 00       	mov    $0x0,%eax
  80304d:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  803054:	00 00 00 
  803057:	ff d2                	callq  *%rdx
		close(fd_src);
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305c:	89 c7                	mov    %eax,%edi
  80305e:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
		close(fd_dest);
  80306a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80306d:	89 c7                	mov    %eax,%edi
  80306f:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
		return read_size;
  80307b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80307e:	eb 27                	jmp    8030a7 <copy+0x1d9>
	}
	close(fd_src);
  803080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803083:	89 c7                	mov    %eax,%edi
  803085:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	callq  *%rax
	close(fd_dest);
  803091:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803094:	89 c7                	mov    %eax,%edi
  803096:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
	return 0;
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030a7:	c9                   	leaveq 
  8030a8:	c3                   	retq   

00000000008030a9 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8030a9:	55                   	push   %rbp
  8030aa:	48 89 e5             	mov    %rsp,%rbp
  8030ad:	48 83 ec 20          	sub    $0x20,%rsp
  8030b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8030b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b9:	8b 40 0c             	mov    0xc(%rax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	7e 67                	jle    803127 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8030c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c4:	8b 40 04             	mov    0x4(%rax),%eax
  8030c7:	48 63 d0             	movslq %eax,%rdx
  8030ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ce:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8030d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d6:	8b 00                	mov    (%rax),%eax
  8030d8:	48 89 ce             	mov    %rcx,%rsi
  8030db:	89 c7                	mov    %eax,%edi
  8030dd:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
  8030e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8030ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f0:	7e 13                	jle    803105 <writebuf+0x5c>
			b->result += result;
  8030f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f6:	8b 50 08             	mov    0x8(%rax),%edx
  8030f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fc:	01 c2                	add    %eax,%edx
  8030fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803102:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803109:	8b 40 04             	mov    0x4(%rax),%eax
  80310c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80310f:	74 16                	je     803127 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803111:	b8 00 00 00 00       	mov    $0x0,%eax
  803116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311a:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80311e:	89 c2                	mov    %eax,%edx
  803120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803124:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803127:	c9                   	leaveq 
  803128:	c3                   	retq   

0000000000803129 <putch>:

static void
putch(int ch, void *thunk)
{
  803129:	55                   	push   %rbp
  80312a:	48 89 e5             	mov    %rsp,%rbp
  80312d:	48 83 ec 20          	sub    $0x20,%rsp
  803131:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80313c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803144:	8b 40 04             	mov    0x4(%rax),%eax
  803147:	8d 48 01             	lea    0x1(%rax),%ecx
  80314a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80314e:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803151:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803154:	89 d1                	mov    %edx,%ecx
  803156:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80315a:	48 98                	cltq   
  80315c:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803164:	8b 40 04             	mov    0x4(%rax),%eax
  803167:	3d 00 01 00 00       	cmp    $0x100,%eax
  80316c:	75 1e                	jne    80318c <putch+0x63>
		writebuf(b);
  80316e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803172:	48 89 c7             	mov    %rax,%rdi
  803175:	48 b8 a9 30 80 00 00 	movabs $0x8030a9,%rax
  80317c:	00 00 00 
  80317f:	ff d0                	callq  *%rax
		b->idx = 0;
  803181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80318c:	c9                   	leaveq 
  80318d:	c3                   	retq   

000000000080318e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80318e:	55                   	push   %rbp
  80318f:	48 89 e5             	mov    %rsp,%rbp
  803192:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803199:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80319f:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8031a6:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8031ad:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8031b3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8031b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8031c0:	00 00 00 
	b.result = 0;
  8031c3:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8031ca:	00 00 00 
	b.error = 1;
  8031cd:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8031d4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8031d7:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8031de:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8031e5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031ec:	48 89 c6             	mov    %rax,%rsi
  8031ef:	48 bf 29 31 80 00 00 	movabs $0x803129,%rdi
  8031f6:	00 00 00 
  8031f9:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  803200:	00 00 00 
  803203:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803205:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	7e 16                	jle    803225 <vfprintf+0x97>
		writebuf(&b);
  80320f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803216:	48 89 c7             	mov    %rax,%rdi
  803219:	48 b8 a9 30 80 00 00 	movabs $0x8030a9,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803225:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	74 08                	je     803237 <vfprintf+0xa9>
  80322f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803235:	eb 06                	jmp    80323d <vfprintf+0xaf>
  803237:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80323d:	c9                   	leaveq 
  80323e:	c3                   	retq   

000000000080323f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80323f:	55                   	push   %rbp
  803240:	48 89 e5             	mov    %rsp,%rbp
  803243:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80324a:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803250:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803257:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80325e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803265:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80326c:	84 c0                	test   %al,%al
  80326e:	74 20                	je     803290 <fprintf+0x51>
  803270:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803274:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803278:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80327c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803280:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803284:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803288:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80328c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803290:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803297:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80329e:	00 00 00 
  8032a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032a8:	00 00 00 
  8032ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8032b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8032c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8032cb:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8032d2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032d8:	48 89 ce             	mov    %rcx,%rsi
  8032db:	89 c7                	mov    %eax,%edi
  8032dd:	48 b8 8e 31 80 00 00 	movabs $0x80318e,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8032ef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8032f5:	c9                   	leaveq 
  8032f6:	c3                   	retq   

00000000008032f7 <printf>:

int
printf(const char *fmt, ...)
{
  8032f7:	55                   	push   %rbp
  8032f8:	48 89 e5             	mov    %rsp,%rbp
  8032fb:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803302:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803309:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803310:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803317:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80331e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803325:	84 c0                	test   %al,%al
  803327:	74 20                	je     803349 <printf+0x52>
  803329:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80332d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803331:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803335:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803339:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80333d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803341:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803345:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803349:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803350:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803357:	00 00 00 
  80335a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803361:	00 00 00 
  803364:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803368:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80336f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803376:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80337d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803384:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80338b:	48 89 c6             	mov    %rax,%rsi
  80338e:	bf 01 00 00 00       	mov    $0x1,%edi
  803393:	48 b8 8e 31 80 00 00 	movabs $0x80318e,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
  80339f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033ab:	c9                   	leaveq 
  8033ac:	c3                   	retq   

00000000008033ad <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033ad:	55                   	push   %rbp
  8033ae:	48 89 e5             	mov    %rsp,%rbp
  8033b1:	53                   	push   %rbx
  8033b2:	48 83 ec 38          	sub    $0x38,%rsp
  8033b6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033ba:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033be:	48 89 c7             	mov    %rax,%rdi
  8033c1:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  8033c8:	00 00 00 
  8033cb:	ff d0                	callq  *%rax
  8033cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d4:	0f 88 bf 01 00 00    	js     803599 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033de:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e3:	48 89 c6             	mov    %rax,%rsi
  8033e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033eb:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fe:	0f 88 95 01 00 00    	js     803599 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803404:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803408:	48 89 c7             	mov    %rax,%rdi
  80340b:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
  803417:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80341a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80341e:	0f 88 5d 01 00 00    	js     803581 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803424:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803428:	ba 07 04 00 00       	mov    $0x407,%edx
  80342d:	48 89 c6             	mov    %rax,%rsi
  803430:	bf 00 00 00 00       	mov    $0x0,%edi
  803435:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
  803441:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803444:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803448:	0f 88 33 01 00 00    	js     803581 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80344e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803452:	48 89 c7             	mov    %rax,%rdi
  803455:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  80345c:	00 00 00 
  80345f:	ff d0                	callq  *%rax
  803461:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803465:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803469:	ba 07 04 00 00       	mov    $0x407,%edx
  80346e:	48 89 c6             	mov    %rax,%rsi
  803471:	bf 00 00 00 00       	mov    $0x0,%edi
  803476:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
  803482:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803485:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803489:	79 05                	jns    803490 <pipe+0xe3>
		goto err2;
  80348b:	e9 d9 00 00 00       	jmpq   803569 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803490:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803494:	48 89 c7             	mov    %rax,%rdi
  803497:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
  8034a3:	48 89 c2             	mov    %rax,%rdx
  8034a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034aa:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034b0:	48 89 d1             	mov    %rdx,%rcx
  8034b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b8:	48 89 c6             	mov    %rax,%rsi
  8034bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c0:	48 b8 d8 1d 80 00 00 	movabs $0x801dd8,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d3:	79 1b                	jns    8034f0 <pipe+0x143>
		goto err3;
  8034d5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8034d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034da:	48 89 c6             	mov    %rax,%rsi
  8034dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e2:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	eb 79                	jmp    803569 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8034f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f4:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  8034fb:	00 00 00 
  8034fe:	8b 12                	mov    (%rdx),%edx
  803500:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803506:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80350d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803511:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803518:	00 00 00 
  80351b:	8b 12                	mov    (%rdx),%edx
  80351d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80352a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80352e:	48 89 c7             	mov    %rax,%rdi
  803531:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
  80353d:	89 c2                	mov    %eax,%edx
  80353f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803543:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803545:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803549:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80354d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803551:	48 89 c7             	mov    %rax,%rdi
  803554:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	89 03                	mov    %eax,(%rbx)
	return 0;
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
  803567:	eb 33                	jmp    80359c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803569:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80356d:	48 89 c6             	mov    %rax,%rsi
  803570:	bf 00 00 00 00       	mov    $0x0,%edi
  803575:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803585:	48 89 c6             	mov    %rax,%rsi
  803588:	bf 00 00 00 00       	mov    $0x0,%edi
  80358d:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
err:
	return r;
  803599:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80359c:	48 83 c4 38          	add    $0x38,%rsp
  8035a0:	5b                   	pop    %rbx
  8035a1:	5d                   	pop    %rbp
  8035a2:	c3                   	retq   

00000000008035a3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035a3:	55                   	push   %rbp
  8035a4:	48 89 e5             	mov    %rsp,%rbp
  8035a7:	53                   	push   %rbx
  8035a8:	48 83 ec 28          	sub    $0x28,%rsp
  8035ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035b4:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8035bb:	00 00 00 
  8035be:	48 8b 00             	mov    (%rax),%rax
  8035c1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ce:	48 89 c7             	mov    %rax,%rdi
  8035d1:	48 b8 b3 3e 80 00 00 	movabs $0x803eb3,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	89 c3                	mov    %eax,%ebx
  8035df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 b3 3e 80 00 00 	movabs $0x803eb3,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	39 c3                	cmp    %eax,%ebx
  8035f4:	0f 94 c0             	sete   %al
  8035f7:	0f b6 c0             	movzbl %al,%eax
  8035fa:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8035fd:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803604:	00 00 00 
  803607:	48 8b 00             	mov    (%rax),%rax
  80360a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803610:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803613:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803616:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803619:	75 05                	jne    803620 <_pipeisclosed+0x7d>
			return ret;
  80361b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80361e:	eb 4f                	jmp    80366f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803620:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803623:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803626:	74 42                	je     80366a <_pipeisclosed+0xc7>
  803628:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80362c:	75 3c                	jne    80366a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80362e:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803635:	00 00 00 
  803638:	48 8b 00             	mov    (%rax),%rax
  80363b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803641:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803644:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803647:	89 c6                	mov    %eax,%esi
  803649:	48 bf ed 45 80 00 00 	movabs $0x8045ed,%rdi
  803650:	00 00 00 
  803653:	b8 00 00 00 00       	mov    $0x0,%eax
  803658:	49 b8 4a 07 80 00 00 	movabs $0x80074a,%r8
  80365f:	00 00 00 
  803662:	41 ff d0             	callq  *%r8
	}
  803665:	e9 4a ff ff ff       	jmpq   8035b4 <_pipeisclosed+0x11>
  80366a:	e9 45 ff ff ff       	jmpq   8035b4 <_pipeisclosed+0x11>
}
  80366f:	48 83 c4 28          	add    $0x28,%rsp
  803673:	5b                   	pop    %rbx
  803674:	5d                   	pop    %rbp
  803675:	c3                   	retq   

0000000000803676 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803676:	55                   	push   %rbp
  803677:	48 89 e5             	mov    %rsp,%rbp
  80367a:	48 83 ec 30          	sub    $0x30,%rsp
  80367e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803681:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803685:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803688:	48 89 d6             	mov    %rdx,%rsi
  80368b:	89 c7                	mov    %eax,%edi
  80368d:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  803694:	00 00 00 
  803697:	ff d0                	callq  *%rax
  803699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a0:	79 05                	jns    8036a7 <pipeisclosed+0x31>
		return r;
  8036a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a5:	eb 31                	jmp    8036d8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ab:	48 89 c7             	mov    %rax,%rdi
  8036ae:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
  8036ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036c6:	48 89 d6             	mov    %rdx,%rsi
  8036c9:	48 89 c7             	mov    %rax,%rdi
  8036cc:	48 b8 a3 35 80 00 00 	movabs $0x8035a3,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 40          	sub    $0x40,%rsp
  8036e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f2:	48 89 c7             	mov    %rax,%rdi
  8036f5:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8036fc:	00 00 00 
  8036ff:	ff d0                	callq  *%rax
  803701:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803705:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803709:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80370d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803714:	00 
  803715:	e9 92 00 00 00       	jmpq   8037ac <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80371a:	eb 41                	jmp    80375d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80371c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803721:	74 09                	je     80372c <devpipe_read+0x52>
				return i;
  803723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803727:	e9 92 00 00 00       	jmpq   8037be <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80372c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803734:	48 89 d6             	mov    %rdx,%rsi
  803737:	48 89 c7             	mov    %rax,%rdi
  80373a:	48 b8 a3 35 80 00 00 	movabs $0x8035a3,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	85 c0                	test   %eax,%eax
  803748:	74 07                	je     803751 <devpipe_read+0x77>
				return 0;
  80374a:	b8 00 00 00 00       	mov    $0x0,%eax
  80374f:	eb 6d                	jmp    8037be <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803751:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80375d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803761:	8b 10                	mov    (%rax),%edx
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	8b 40 04             	mov    0x4(%rax),%eax
  80376a:	39 c2                	cmp    %eax,%edx
  80376c:	74 ae                	je     80371c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80376e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803776:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80377a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80377e:	8b 00                	mov    (%rax),%eax
  803780:	99                   	cltd   
  803781:	c1 ea 1b             	shr    $0x1b,%edx
  803784:	01 d0                	add    %edx,%eax
  803786:	83 e0 1f             	and    $0x1f,%eax
  803789:	29 d0                	sub    %edx,%eax
  80378b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80378f:	48 98                	cltq   
  803791:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803796:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379c:	8b 00                	mov    (%rax),%eax
  80379e:	8d 50 01             	lea    0x1(%rax),%edx
  8037a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037b4:	0f 82 60 ff ff ff    	jb     80371a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037be:	c9                   	leaveq 
  8037bf:	c3                   	retq   

00000000008037c0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 40          	sub    $0x40,%rsp
  8037c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8037d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d8:	48 89 c7             	mov    %rax,%rdi
  8037db:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
  8037e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037f3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037fa:	00 
  8037fb:	e9 8e 00 00 00       	jmpq   80388e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803800:	eb 31                	jmp    803833 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803802:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380a:	48 89 d6             	mov    %rdx,%rsi
  80380d:	48 89 c7             	mov    %rax,%rdi
  803810:	48 b8 a3 35 80 00 00 	movabs $0x8035a3,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
  80381c:	85 c0                	test   %eax,%eax
  80381e:	74 07                	je     803827 <devpipe_write+0x67>
				return 0;
  803820:	b8 00 00 00 00       	mov    $0x0,%eax
  803825:	eb 79                	jmp    8038a0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803827:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803837:	8b 40 04             	mov    0x4(%rax),%eax
  80383a:	48 63 d0             	movslq %eax,%rdx
  80383d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803841:	8b 00                	mov    (%rax),%eax
  803843:	48 98                	cltq   
  803845:	48 83 c0 20          	add    $0x20,%rax
  803849:	48 39 c2             	cmp    %rax,%rdx
  80384c:	73 b4                	jae    803802 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80384e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803852:	8b 40 04             	mov    0x4(%rax),%eax
  803855:	99                   	cltd   
  803856:	c1 ea 1b             	shr    $0x1b,%edx
  803859:	01 d0                	add    %edx,%eax
  80385b:	83 e0 1f             	and    $0x1f,%eax
  80385e:	29 d0                	sub    %edx,%eax
  803860:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803864:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803868:	48 01 ca             	add    %rcx,%rdx
  80386b:	0f b6 0a             	movzbl (%rdx),%ecx
  80386e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803872:	48 98                	cltq   
  803874:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387c:	8b 40 04             	mov    0x4(%rax),%eax
  80387f:	8d 50 01             	lea    0x1(%rax),%edx
  803882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803886:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803889:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80388e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803892:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803896:	0f 82 64 ff ff ff    	jb     803800 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038a0:	c9                   	leaveq 
  8038a1:	c3                   	retq   

00000000008038a2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038a2:	55                   	push   %rbp
  8038a3:	48 89 e5             	mov    %rsp,%rbp
  8038a6:	48 83 ec 20          	sub    $0x20,%rsp
  8038aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b6:	48 89 c7             	mov    %rax,%rdi
  8038b9:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
  8038c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038cd:	48 be 00 46 80 00 00 	movabs $0x804600,%rsi
  8038d4:	00 00 00 
  8038d7:	48 89 c7             	mov    %rax,%rdi
  8038da:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8038e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ea:	8b 50 04             	mov    0x4(%rax),%edx
  8038ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f1:	8b 00                	mov    (%rax),%eax
  8038f3:	29 c2                	sub    %eax,%edx
  8038f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8038ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803903:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80390a:	00 00 00 
	stat->st_dev = &devpipe;
  80390d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803911:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  803918:	00 00 00 
  80391b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803927:	c9                   	leaveq 
  803928:	c3                   	retq   

0000000000803929 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803929:	55                   	push   %rbp
  80392a:	48 89 e5             	mov    %rsp,%rbp
  80392d:	48 83 ec 10          	sub    $0x10,%rsp
  803931:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803935:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803939:	48 89 c6             	mov    %rax,%rsi
  80393c:	bf 00 00 00 00       	mov    $0x0,%edi
  803941:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80394d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803951:	48 89 c7             	mov    %rax,%rdi
  803954:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
  803960:	48 89 c6             	mov    %rax,%rsi
  803963:	bf 00 00 00 00       	mov    $0x0,%edi
  803968:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
}
  803974:	c9                   	leaveq 
  803975:	c3                   	retq   

0000000000803976 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803976:	55                   	push   %rbp
  803977:	48 89 e5             	mov    %rsp,%rbp
  80397a:	48 83 ec 30          	sub    $0x30,%rsp
  80397e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803982:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803986:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80398a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803991:	00 00 00 
  803994:	48 8b 00             	mov    (%rax),%rax
  803997:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80399d:	85 c0                	test   %eax,%eax
  80399f:	75 34                	jne    8039d5 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8039a1:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8039a8:	00 00 00 
  8039ab:	ff d0                	callq  *%rax
  8039ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8039b2:	48 98                	cltq   
  8039b4:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8039bb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8039c2:	00 00 00 
  8039c5:	48 01 c2             	add    %rax,%rdx
  8039c8:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8039cf:	00 00 00 
  8039d2:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8039d5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039da:	75 0e                	jne    8039ea <ipc_recv+0x74>
		pg = (void*) UTOP;
  8039dc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8039e3:	00 00 00 
  8039e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8039ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ee:	48 89 c7             	mov    %rax,%rdi
  8039f1:	48 b8 b1 1f 80 00 00 	movabs $0x801fb1,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a04:	79 19                	jns    803a1f <ipc_recv+0xa9>
		*from_env_store = 0;
  803a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a0a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a14:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a1d:	eb 53                	jmp    803a72 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803a1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a24:	74 19                	je     803a3f <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803a26:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a2d:	00 00 00 
  803a30:	48 8b 00             	mov    (%rax),%rax
  803a33:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3d:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803a3f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a44:	74 19                	je     803a5f <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803a46:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a4d:	00 00 00 
  803a50:	48 8b 00             	mov    (%rax),%rax
  803a53:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803a5f:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a66:	00 00 00 
  803a69:	48 8b 00             	mov    (%rax),%rax
  803a6c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803a72:	c9                   	leaveq 
  803a73:	c3                   	retq   

0000000000803a74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a74:	55                   	push   %rbp
  803a75:	48 89 e5             	mov    %rsp,%rbp
  803a78:	48 83 ec 30          	sub    $0x30,%rsp
  803a7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a7f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a82:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a86:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803a89:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a8e:	75 0e                	jne    803a9e <ipc_send+0x2a>
		pg = (void*)UTOP;
  803a90:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a97:	00 00 00 
  803a9a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803a9e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803aa1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803aa4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803aa8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aab:	89 c7                	mov    %eax,%edi
  803aad:	48 b8 5c 1f 80 00 00 	movabs $0x801f5c,%rax
  803ab4:	00 00 00 
  803ab7:	ff d0                	callq  *%rax
  803ab9:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803abc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ac0:	75 0c                	jne    803ace <ipc_send+0x5a>
			sys_yield();
  803ac2:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803ace:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ad2:	74 ca                	je     803a9e <ipc_send+0x2a>
	if(result != 0)
  803ad4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad8:	74 20                	je     803afa <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	89 c6                	mov    %eax,%esi
  803adf:	48 bf 08 46 80 00 00 	movabs $0x804608,%rdi
  803ae6:	00 00 00 
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aee:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  803af5:	00 00 00 
  803af8:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803afa:	c9                   	leaveq 
  803afb:	c3                   	retq   

0000000000803afc <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	53                   	push   %rbx
  803b01:	48 83 ec 58          	sub    $0x58,%rsp
  803b05:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803b09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803b11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803b18:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803b1f:	00 
  803b20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b24:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803b30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803b38:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b3c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b44:	48 c1 e8 27          	shr    $0x27,%rax
  803b48:	48 89 c2             	mov    %rax,%rdx
  803b4b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803b52:	01 00 00 
  803b55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b59:	83 e0 01             	and    $0x1,%eax
  803b5c:	48 85 c0             	test   %rax,%rax
  803b5f:	0f 85 91 00 00 00    	jne    803bf6 <ipc_host_recv+0xfa>
  803b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b69:	48 c1 e8 1e          	shr    $0x1e,%rax
  803b6d:	48 89 c2             	mov    %rax,%rdx
  803b70:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803b77:	01 00 00 
  803b7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b7e:	83 e0 01             	and    $0x1,%eax
  803b81:	48 85 c0             	test   %rax,%rax
  803b84:	74 70                	je     803bf6 <ipc_host_recv+0xfa>
  803b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8a:	48 c1 e8 15          	shr    $0x15,%rax
  803b8e:	48 89 c2             	mov    %rax,%rdx
  803b91:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b98:	01 00 00 
  803b9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b9f:	83 e0 01             	and    $0x1,%eax
  803ba2:	48 85 c0             	test   %rax,%rax
  803ba5:	74 4f                	je     803bf6 <ipc_host_recv+0xfa>
  803ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bab:	48 c1 e8 0c          	shr    $0xc,%rax
  803baf:	48 89 c2             	mov    %rax,%rdx
  803bb2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bb9:	01 00 00 
  803bbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bc0:	83 e0 01             	and    $0x1,%eax
  803bc3:	48 85 c0             	test   %rax,%rax
  803bc6:	74 2e                	je     803bf6 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcc:	ba 07 04 00 00       	mov    $0x407,%edx
  803bd1:	48 89 c6             	mov    %rax,%rsi
  803bd4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd9:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803bec:	79 08                	jns    803bf6 <ipc_host_recv+0xfa>
	    	return result;
  803bee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803bf1:	e9 84 00 00 00       	jmpq   803c7a <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803bf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bfa:	48 c1 e8 0c          	shr    $0xc,%rax
  803bfe:	48 89 c2             	mov    %rax,%rdx
  803c01:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c08:	01 00 00 
  803c0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803c15:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  803c19:	b8 03 00 00 00       	mov    $0x3,%eax
  803c1e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803c22:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803c26:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  803c2a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803c2e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803c32:	4c 89 c3             	mov    %r8,%rbx
  803c35:	0f 01 c1             	vmcall 
  803c38:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  803c3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803c3f:	7e 36                	jle    803c77 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  803c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c44:	41 89 c0             	mov    %eax,%r8d
  803c47:	b9 03 00 00 00       	mov    $0x3,%ecx
  803c4c:	48 ba 20 46 80 00 00 	movabs $0x804620,%rdx
  803c53:	00 00 00 
  803c56:	be 67 00 00 00       	mov    $0x67,%esi
  803c5b:	48 bf 4d 46 80 00 00 	movabs $0x80464d,%rdi
  803c62:	00 00 00 
  803c65:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6a:	49 b9 11 05 80 00 00 	movabs $0x800511,%r9
  803c71:	00 00 00 
  803c74:	41 ff d1             	callq  *%r9
	return result;
  803c77:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  803c7a:	48 83 c4 58          	add    $0x58,%rsp
  803c7e:	5b                   	pop    %rbx
  803c7f:	5d                   	pop    %rbp
  803c80:	c3                   	retq   

0000000000803c81 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c81:	55                   	push   %rbp
  803c82:	48 89 e5             	mov    %rsp,%rbp
  803c85:	53                   	push   %rbx
  803c86:	48 83 ec 68          	sub    $0x68,%rsp
  803c8a:	89 7d ac             	mov    %edi,-0x54(%rbp)
  803c8d:	89 75 a8             	mov    %esi,-0x58(%rbp)
  803c90:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  803c94:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  803c97:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803c9b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803c9f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803ca6:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803cad:	00 
  803cae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803cb6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803cbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cc2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803cc6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803cca:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803cce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd2:	48 c1 e8 27          	shr    $0x27,%rax
  803cd6:	48 89 c2             	mov    %rax,%rdx
  803cd9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803ce0:	01 00 00 
  803ce3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ce7:	83 e0 01             	and    $0x1,%eax
  803cea:	48 85 c0             	test   %rax,%rax
  803ced:	0f 85 88 00 00 00    	jne    803d7b <ipc_host_send+0xfa>
  803cf3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf7:	48 c1 e8 1e          	shr    $0x1e,%rax
  803cfb:	48 89 c2             	mov    %rax,%rdx
  803cfe:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803d05:	01 00 00 
  803d08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d0c:	83 e0 01             	and    $0x1,%eax
  803d0f:	48 85 c0             	test   %rax,%rax
  803d12:	74 67                	je     803d7b <ipc_host_send+0xfa>
  803d14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d18:	48 c1 e8 15          	shr    $0x15,%rax
  803d1c:	48 89 c2             	mov    %rax,%rdx
  803d1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d26:	01 00 00 
  803d29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d2d:	83 e0 01             	and    $0x1,%eax
  803d30:	48 85 c0             	test   %rax,%rax
  803d33:	74 46                	je     803d7b <ipc_host_send+0xfa>
  803d35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d39:	48 c1 e8 0c          	shr    $0xc,%rax
  803d3d:	48 89 c2             	mov    %rax,%rdx
  803d40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d47:	01 00 00 
  803d4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d4e:	83 e0 01             	and    $0x1,%eax
  803d51:	48 85 c0             	test   %rax,%rax
  803d54:	74 25                	je     803d7b <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803d56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d5e:	48 89 c2             	mov    %rax,%rdx
  803d61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d68:	01 00 00 
  803d6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d6f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803d75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803d79:	eb 0e                	jmp    803d89 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  803d7b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d82:	00 00 00 
  803d85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  803d89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d8d:	48 89 c6             	mov    %rax,%rsi
  803d90:	48 bf 57 46 80 00 00 	movabs $0x804657,%rdi
  803d97:	00 00 00 
  803d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9f:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  803da6:	00 00 00 
  803da9:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  803dab:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803dae:	48 98                	cltq   
  803db0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  803db4:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803db7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  803dbb:	8b 45 9c             	mov    -0x64(%rbp),%eax
  803dbe:	48 98                	cltq   
  803dc0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803dc4:	b8 02 00 00 00       	mov    $0x2,%eax
  803dc9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803dcd:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803dd1:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803dd5:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803dd9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803ddd:	4c 89 c3             	mov    %r8,%rbx
  803de0:	0f 01 c1             	vmcall 
  803de3:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803de6:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803dea:	75 0c                	jne    803df8 <ipc_host_send+0x177>
			sys_yield();
  803dec:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  803df3:	00 00 00 
  803df6:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803df8:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803dfc:	74 c6                	je     803dc4 <ipc_host_send+0x143>
	
	if(result !=0)
  803dfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e02:	74 36                	je     803e3a <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803e04:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e07:	41 89 c0             	mov    %eax,%r8d
  803e0a:	b9 02 00 00 00       	mov    $0x2,%ecx
  803e0f:	48 ba 20 46 80 00 00 	movabs $0x804620,%rdx
  803e16:	00 00 00 
  803e19:	be 94 00 00 00       	mov    $0x94,%esi
  803e1e:	48 bf 4d 46 80 00 00 	movabs $0x80464d,%rdi
  803e25:	00 00 00 
  803e28:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2d:	49 b9 11 05 80 00 00 	movabs $0x800511,%r9
  803e34:	00 00 00 
  803e37:	41 ff d1             	callq  *%r9
}
  803e3a:	48 83 c4 68          	add    $0x68,%rsp
  803e3e:	5b                   	pop    %rbx
  803e3f:	5d                   	pop    %rbp
  803e40:	c3                   	retq   

0000000000803e41 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e41:	55                   	push   %rbp
  803e42:	48 89 e5             	mov    %rsp,%rbp
  803e45:	48 83 ec 14          	sub    $0x14,%rsp
  803e49:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e53:	eb 4e                	jmp    803ea3 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803e55:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e5c:	00 00 00 
  803e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e62:	48 98                	cltq   
  803e64:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803e6b:	48 01 d0             	add    %rdx,%rax
  803e6e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e74:	8b 00                	mov    (%rax),%eax
  803e76:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e79:	75 24                	jne    803e9f <ipc_find_env+0x5e>
			return envs[i].env_id;
  803e7b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e82:	00 00 00 
  803e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e88:	48 98                	cltq   
  803e8a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803e91:	48 01 d0             	add    %rdx,%rax
  803e94:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e9a:	8b 40 08             	mov    0x8(%rax),%eax
  803e9d:	eb 12                	jmp    803eb1 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803e9f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ea3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803eaa:	7e a9                	jle    803e55 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eb1:	c9                   	leaveq 
  803eb2:	c3                   	retq   

0000000000803eb3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803eb3:	55                   	push   %rbp
  803eb4:	48 89 e5             	mov    %rsp,%rbp
  803eb7:	48 83 ec 18          	sub    $0x18,%rsp
  803ebb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec3:	48 c1 e8 15          	shr    $0x15,%rax
  803ec7:	48 89 c2             	mov    %rax,%rdx
  803eca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ed1:	01 00 00 
  803ed4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ed8:	83 e0 01             	and    $0x1,%eax
  803edb:	48 85 c0             	test   %rax,%rax
  803ede:	75 07                	jne    803ee7 <pageref+0x34>
		return 0;
  803ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee5:	eb 53                	jmp    803f3a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eeb:	48 c1 e8 0c          	shr    $0xc,%rax
  803eef:	48 89 c2             	mov    %rax,%rdx
  803ef2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ef9:	01 00 00 
  803efc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f08:	83 e0 01             	and    $0x1,%eax
  803f0b:	48 85 c0             	test   %rax,%rax
  803f0e:	75 07                	jne    803f17 <pageref+0x64>
		return 0;
  803f10:	b8 00 00 00 00       	mov    $0x0,%eax
  803f15:	eb 23                	jmp    803f3a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f1f:	48 89 c2             	mov    %rax,%rdx
  803f22:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f29:	00 00 00 
  803f2c:	48 c1 e2 04          	shl    $0x4,%rdx
  803f30:	48 01 d0             	add    %rdx,%rax
  803f33:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f37:	0f b7 c0             	movzwl %ax,%eax
}
  803f3a:	c9                   	leaveq 
  803f3b:	c3                   	retq   
