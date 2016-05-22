
obj/user/primespipe:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 a4 2c 80 00 00 	movabs $0x802ca4,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba e0 42 80 00 00 	movabs $0x8042e0,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 21 43 80 00 00 	movabs $0x804321,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 25 43 80 00 00 	movabs $0x804325,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 0e 24 80 00 00 	movabs $0x80240e,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 2e 43 80 00 00 	movabs $0x80432e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 a4 2c 80 00 00 	movabs $0x802ca4,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 37 43 80 00 00 	movabs $0x804337,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba ba 04 80 00 00 	movabs $0x8004ba,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 19 2d 80 00 00 	movabs $0x802d19,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 53 43 80 00 00 	movabs $0x804353,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba ba 04 80 00 00 	movabs $0x8004ba,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 6d 43 80 00 00 	movabs $0x80436d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 88 36 80 00 00 	movabs $0x803688,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 25 43 80 00 00 	movabs $0x804325,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 0e 24 80 00 00 	movabs $0x80240e,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 2e 43 80 00 00 	movabs $0x80432e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 19 2d 80 00 00 	movabs $0x802d19,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 78 43 80 00 00 	movabs $0x804378,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 0f 43 80 00 00 	movabs $0x80430f,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800423:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800434:	48 98                	cltq   
  800436:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80043d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800444:	00 00 00 
  800447:	48 01 c2             	add    %rax,%rdx
  80044a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800451:	00 00 00 
  800454:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045b:	7e 14                	jle    800471 <libmain+0x5d>
		binaryname = argv[0];
  80045d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800461:	48 8b 10             	mov    (%rax),%rdx
  800464:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80046b:	00 00 00 
  80046e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800471:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800478:	48 89 d6             	mov    %rdx,%rsi
  80047b:	89 c7                	mov    %eax,%edi
  80047d:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800484:	00 00 00 
  800487:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800489:	48 b8 97 04 80 00 00 	movabs $0x800497,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80049b:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8004ac:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8004b3:	00 00 00 
  8004b6:	ff d0                	callq  *%rax

}
  8004b8:	5d                   	pop    %rbp
  8004b9:	c3                   	retq   

00000000008004ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	53                   	push   %rbx
  8004bf:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004c6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004cd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004d3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004da:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004e1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004e8:	84 c0                	test   %al,%al
  8004ea:	74 23                	je     80050f <_panic+0x55>
  8004ec:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8004f3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8004f7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004fb:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004ff:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800503:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800507:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80050b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80050f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800516:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80051d:	00 00 00 
  800520:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800527:	00 00 00 
  80052a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800535:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80053c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800543:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80054a:	00 00 00 
  80054d:	48 8b 18             	mov    (%rax),%rbx
  800550:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  800557:	00 00 00 
  80055a:	ff d0                	callq  *%rax
  80055c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800562:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800569:	41 89 c8             	mov    %ecx,%r8d
  80056c:	48 89 d1             	mov    %rdx,%rcx
  80056f:	48 89 da             	mov    %rbx,%rdx
  800572:	89 c6                	mov    %eax,%esi
  800574:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  80057b:	00 00 00 
  80057e:	b8 00 00 00 00       	mov    $0x0,%eax
  800583:	49 b9 f3 06 80 00 00 	movabs $0x8006f3,%r9
  80058a:	00 00 00 
  80058d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800590:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800597:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80059e:	48 89 d6             	mov    %rdx,%rsi
  8005a1:	48 89 c7             	mov    %rax,%rdi
  8005a4:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
	cprintf("\n");
  8005b0:	48 bf c3 43 80 00 00 	movabs $0x8043c3,%rdi
  8005b7:	00 00 00 
  8005ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bf:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8005c6:	00 00 00 
  8005c9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005cb:	cc                   	int3   
  8005cc:	eb fd                	jmp    8005cb <_panic+0x111>

00000000008005ce <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	48 83 ec 10          	sub    $0x10,%rsp
  8005d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e1:	8b 00                	mov    (%rax),%eax
  8005e3:	8d 48 01             	lea    0x1(%rax),%ecx
  8005e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005ea:	89 0a                	mov    %ecx,(%rdx)
  8005ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005ef:	89 d1                	mov    %edx,%ecx
  8005f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f5:	48 98                	cltq   
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8005fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ff:	8b 00                	mov    (%rax),%eax
  800601:	3d ff 00 00 00       	cmp    $0xff,%eax
  800606:	75 2c                	jne    800634 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	48 98                	cltq   
  800610:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800614:	48 83 c2 08          	add    $0x8,%rdx
  800618:	48 89 c6             	mov    %rax,%rsi
  80061b:	48 89 d7             	mov    %rdx,%rdi
  80061e:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
        b->idx = 0;
  80062a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800638:	8b 40 04             	mov    0x4(%rax),%eax
  80063b:	8d 50 01             	lea    0x1(%rax),%edx
  80063e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800642:	89 50 04             	mov    %edx,0x4(%rax)
}
  800645:	c9                   	leaveq 
  800646:	c3                   	retq   

0000000000800647 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800647:	55                   	push   %rbp
  800648:	48 89 e5             	mov    %rsp,%rbp
  80064b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800652:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800659:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800660:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800667:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80066e:	48 8b 0a             	mov    (%rdx),%rcx
  800671:	48 89 08             	mov    %rcx,(%rax)
  800674:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800678:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80067c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800680:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800684:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80068b:	00 00 00 
    b.cnt = 0;
  80068e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800695:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800698:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80069f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006a6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006ad:	48 89 c6             	mov    %rax,%rsi
  8006b0:	48 bf ce 05 80 00 00 	movabs $0x8005ce,%rdi
  8006b7:	00 00 00 
  8006ba:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  8006c1:	00 00 00 
  8006c4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006c6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006cc:	48 98                	cltq   
  8006ce:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006d5:	48 83 c2 08          	add    $0x8,%rdx
  8006d9:	48 89 c6             	mov    %rax,%rsi
  8006dc:	48 89 d7             	mov    %rdx,%rdi
  8006df:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  8006e6:	00 00 00 
  8006e9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006f1:	c9                   	leaveq 
  8006f2:	c3                   	retq   

00000000008006f3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006f3:	55                   	push   %rbp
  8006f4:	48 89 e5             	mov    %rsp,%rbp
  8006f7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006fe:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800705:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80070c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800713:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80071a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800721:	84 c0                	test   %al,%al
  800723:	74 20                	je     800745 <cprintf+0x52>
  800725:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800729:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80072d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800731:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800735:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800739:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80073d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800741:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800745:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80074c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800753:	00 00 00 
  800756:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80075d:	00 00 00 
  800760:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800764:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80076b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800772:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800779:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800780:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800787:	48 8b 0a             	mov    (%rdx),%rcx
  80078a:	48 89 08             	mov    %rcx,(%rax)
  80078d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800791:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800795:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800799:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80079d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007a4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007ab:	48 89 d6             	mov    %rdx,%rsi
  8007ae:	48 89 c7             	mov    %rax,%rdi
  8007b1:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  8007b8:	00 00 00 
  8007bb:	ff d0                	callq  *%rax
  8007bd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007c3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007c9:	c9                   	leaveq 
  8007ca:	c3                   	retq   

00000000008007cb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cb:	55                   	push   %rbp
  8007cc:	48 89 e5             	mov    %rsp,%rbp
  8007cf:	53                   	push   %rbx
  8007d0:	48 83 ec 38          	sub    $0x38,%rsp
  8007d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007e0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007e3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007e7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007eb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007ee:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007f2:	77 3b                	ja     80082f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8007f7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007fb:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8007fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800802:	ba 00 00 00 00       	mov    $0x0,%edx
  800807:	48 f7 f3             	div    %rbx
  80080a:	48 89 c2             	mov    %rax,%rdx
  80080d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800810:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800813:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	41 89 f9             	mov    %edi,%r9d
  80081e:	48 89 c7             	mov    %rax,%rdi
  800821:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800828:	00 00 00 
  80082b:	ff d0                	callq  *%rax
  80082d:	eb 1e                	jmp    80084d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082f:	eb 12                	jmp    800843 <printnum+0x78>
			putch(padc, putdat);
  800831:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800835:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	48 89 ce             	mov    %rcx,%rsi
  80083f:	89 d7                	mov    %edx,%edi
  800841:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800843:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800847:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80084b:	7f e4                	jg     800831 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800850:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800854:	ba 00 00 00 00       	mov    $0x0,%edx
  800859:	48 f7 f1             	div    %rcx
  80085c:	48 89 d0             	mov    %rdx,%rax
  80085f:	48 ba d0 45 80 00 00 	movabs $0x8045d0,%rdx
  800866:	00 00 00 
  800869:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80086d:	0f be d0             	movsbl %al,%edx
  800870:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 89 ce             	mov    %rcx,%rsi
  80087b:	89 d7                	mov    %edx,%edi
  80087d:	ff d0                	callq  *%rax
}
  80087f:	48 83 c4 38          	add    $0x38,%rsp
  800883:	5b                   	pop    %rbx
  800884:	5d                   	pop    %rbp
  800885:	c3                   	retq   

0000000000800886 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800886:	55                   	push   %rbp
  800887:	48 89 e5             	mov    %rsp,%rbp
  80088a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80088e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800892:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800895:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800899:	7e 52                	jle    8008ed <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	8b 00                	mov    (%rax),%eax
  8008a1:	83 f8 30             	cmp    $0x30,%eax
  8008a4:	73 24                	jae    8008ca <getuint+0x44>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	89 c0                	mov    %eax,%eax
  8008b6:	48 01 d0             	add    %rdx,%rax
  8008b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bd:	8b 12                	mov    (%rdx),%edx
  8008bf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	89 0a                	mov    %ecx,(%rdx)
  8008c8:	eb 17                	jmp    8008e1 <getuint+0x5b>
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d2:	48 89 d0             	mov    %rdx,%rax
  8008d5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e1:	48 8b 00             	mov    (%rax),%rax
  8008e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e8:	e9 a3 00 00 00       	jmpq   800990 <getuint+0x10a>
	else if (lflag)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f1:	74 4f                	je     800942 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	83 f8 30             	cmp    $0x30,%eax
  8008fc:	73 24                	jae    800922 <getuint+0x9c>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800915:	8b 12                	mov    (%rdx),%edx
  800917:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	89 0a                	mov    %ecx,(%rdx)
  800920:	eb 17                	jmp    800939 <getuint+0xb3>
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092a:	48 89 d0             	mov    %rdx,%rax
  80092d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800935:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800939:	48 8b 00             	mov    (%rax),%rax
  80093c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800940:	eb 4e                	jmp    800990 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	8b 00                	mov    (%rax),%eax
  800948:	83 f8 30             	cmp    $0x30,%eax
  80094b:	73 24                	jae    800971 <getuint+0xeb>
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	8b 00                	mov    (%rax),%eax
  80095b:	89 c0                	mov    %eax,%eax
  80095d:	48 01 d0             	add    %rdx,%rax
  800960:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800964:	8b 12                	mov    (%rdx),%edx
  800966:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	89 0a                	mov    %ecx,(%rdx)
  80096f:	eb 17                	jmp    800988 <getuint+0x102>
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800979:	48 89 d0             	mov    %rdx,%rax
  80097c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800994:	c9                   	leaveq 
  800995:	c3                   	retq   

0000000000800996 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800996:	55                   	push   %rbp
  800997:	48 89 e5             	mov    %rsp,%rbp
  80099a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80099e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009a5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a9:	7e 52                	jle    8009fd <getint+0x67>
		x=va_arg(*ap, long long);
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	83 f8 30             	cmp    $0x30,%eax
  8009b4:	73 24                	jae    8009da <getint+0x44>
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	8b 00                	mov    (%rax),%eax
  8009c4:	89 c0                	mov    %eax,%eax
  8009c6:	48 01 d0             	add    %rdx,%rax
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	8b 12                	mov    (%rdx),%edx
  8009cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d6:	89 0a                	mov    %ecx,(%rdx)
  8009d8:	eb 17                	jmp    8009f1 <getint+0x5b>
  8009da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009de:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f1:	48 8b 00             	mov    (%rax),%rax
  8009f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f8:	e9 a3 00 00 00       	jmpq   800aa0 <getint+0x10a>
	else if (lflag)
  8009fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a01:	74 4f                	je     800a52 <getint+0xbc>
		x=va_arg(*ap, long);
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	8b 00                	mov    (%rax),%eax
  800a09:	83 f8 30             	cmp    $0x30,%eax
  800a0c:	73 24                	jae    800a32 <getint+0x9c>
  800a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a12:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	8b 00                	mov    (%rax),%eax
  800a1c:	89 c0                	mov    %eax,%eax
  800a1e:	48 01 d0             	add    %rdx,%rax
  800a21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a25:	8b 12                	mov    (%rdx),%edx
  800a27:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2e:	89 0a                	mov    %ecx,(%rdx)
  800a30:	eb 17                	jmp    800a49 <getint+0xb3>
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3a:	48 89 d0             	mov    %rdx,%rax
  800a3d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a45:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a49:	48 8b 00             	mov    (%rax),%rax
  800a4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a50:	eb 4e                	jmp    800aa0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	8b 00                	mov    (%rax),%eax
  800a58:	83 f8 30             	cmp    $0x30,%eax
  800a5b:	73 24                	jae    800a81 <getint+0xeb>
  800a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a61:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	8b 00                	mov    (%rax),%eax
  800a6b:	89 c0                	mov    %eax,%eax
  800a6d:	48 01 d0             	add    %rdx,%rax
  800a70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a74:	8b 12                	mov    (%rdx),%edx
  800a76:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7d:	89 0a                	mov    %ecx,(%rdx)
  800a7f:	eb 17                	jmp    800a98 <getint+0x102>
  800a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a85:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a89:	48 89 d0             	mov    %rdx,%rax
  800a8c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a94:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a98:	8b 00                	mov    (%rax),%eax
  800a9a:	48 98                	cltq   
  800a9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa4:	c9                   	leaveq 
  800aa5:	c3                   	retq   

0000000000800aa6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aa6:	55                   	push   %rbp
  800aa7:	48 89 e5             	mov    %rsp,%rbp
  800aaa:	41 54                	push   %r12
  800aac:	53                   	push   %rbx
  800aad:	48 83 ec 60          	sub    $0x60,%rsp
  800ab1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ab5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ab9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800abd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ac1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ac9:	48 8b 0a             	mov    (%rdx),%rcx
  800acc:	48 89 08             	mov    %rcx,(%rax)
  800acf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ad3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ad7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800adb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800adf:	eb 17                	jmp    800af8 <vprintfmt+0x52>
			if (ch == '\0')
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	0f 84 cc 04 00 00    	je     800fb5 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800ae9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	48 89 d6             	mov    %rdx,%rsi
  800af4:	89 df                	mov    %ebx,%edi
  800af6:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800af8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800afc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b00:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b04:	0f b6 00             	movzbl (%rax),%eax
  800b07:	0f b6 d8             	movzbl %al,%ebx
  800b0a:	83 fb 25             	cmp    $0x25,%ebx
  800b0d:	75 d2                	jne    800ae1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b0f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b13:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b1a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b21:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b28:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b2f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b37:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b3b:	0f b6 00             	movzbl (%rax),%eax
  800b3e:	0f b6 d8             	movzbl %al,%ebx
  800b41:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b44:	83 f8 55             	cmp    $0x55,%eax
  800b47:	0f 87 34 04 00 00    	ja     800f81 <vprintfmt+0x4db>
  800b4d:	89 c0                	mov    %eax,%eax
  800b4f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b56:	00 
  800b57:	48 b8 f8 45 80 00 00 	movabs $0x8045f8,%rax
  800b5e:	00 00 00 
  800b61:	48 01 d0             	add    %rdx,%rax
  800b64:	48 8b 00             	mov    (%rax),%rax
  800b67:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b69:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b6d:	eb c0                	jmp    800b2f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b6f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b73:	eb ba                	jmp    800b2f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b75:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b7c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 02             	shl    $0x2,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d8                	add    %ebx,%eax
  800b8a:	83 e8 30             	sub    $0x30,%eax
  800b8d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b90:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b94:	0f b6 00             	movzbl (%rax),%eax
  800b97:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b9a:	83 fb 2f             	cmp    $0x2f,%ebx
  800b9d:	7e 0c                	jle    800bab <vprintfmt+0x105>
  800b9f:	83 fb 39             	cmp    $0x39,%ebx
  800ba2:	7f 07                	jg     800bab <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ba9:	eb d1                	jmp    800b7c <vprintfmt+0xd6>
			goto process_precision;
  800bab:	eb 58                	jmp    800c05 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb0:	83 f8 30             	cmp    $0x30,%eax
  800bb3:	73 17                	jae    800bcc <vprintfmt+0x126>
  800bb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbc:	89 c0                	mov    %eax,%eax
  800bbe:	48 01 d0             	add    %rdx,%rax
  800bc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc4:	83 c2 08             	add    $0x8,%edx
  800bc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bca:	eb 0f                	jmp    800bdb <vprintfmt+0x135>
  800bcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd0:	48 89 d0             	mov    %rdx,%rax
  800bd3:	48 83 c2 08          	add    $0x8,%rdx
  800bd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bdb:	8b 00                	mov    (%rax),%eax
  800bdd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800be0:	eb 23                	jmp    800c05 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800be2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be6:	79 0c                	jns    800bf4 <vprintfmt+0x14e>
				width = 0;
  800be8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bef:	e9 3b ff ff ff       	jmpq   800b2f <vprintfmt+0x89>
  800bf4:	e9 36 ff ff ff       	jmpq   800b2f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800bf9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c00:	e9 2a ff ff ff       	jmpq   800b2f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c05:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c09:	79 12                	jns    800c1d <vprintfmt+0x177>
				width = precision, precision = -1;
  800c0b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c0e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c11:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c18:	e9 12 ff ff ff       	jmpq   800b2f <vprintfmt+0x89>
  800c1d:	e9 0d ff ff ff       	jmpq   800b2f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c22:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c26:	e9 04 ff ff ff       	jmpq   800b2f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2e:	83 f8 30             	cmp    $0x30,%eax
  800c31:	73 17                	jae    800c4a <vprintfmt+0x1a4>
  800c33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3a:	89 c0                	mov    %eax,%eax
  800c3c:	48 01 d0             	add    %rdx,%rax
  800c3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c42:	83 c2 08             	add    $0x8,%edx
  800c45:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c48:	eb 0f                	jmp    800c59 <vprintfmt+0x1b3>
  800c4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c4e:	48 89 d0             	mov    %rdx,%rax
  800c51:	48 83 c2 08          	add    $0x8,%rdx
  800c55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c59:	8b 10                	mov    (%rax),%edx
  800c5b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c63:	48 89 ce             	mov    %rcx,%rsi
  800c66:	89 d7                	mov    %edx,%edi
  800c68:	ff d0                	callq  *%rax
			break;
  800c6a:	e9 40 03 00 00       	jmpq   800faf <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c72:	83 f8 30             	cmp    $0x30,%eax
  800c75:	73 17                	jae    800c8e <vprintfmt+0x1e8>
  800c77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	89 c0                	mov    %eax,%eax
  800c80:	48 01 d0             	add    %rdx,%rax
  800c83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c86:	83 c2 08             	add    $0x8,%edx
  800c89:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8c:	eb 0f                	jmp    800c9d <vprintfmt+0x1f7>
  800c8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c92:	48 89 d0             	mov    %rdx,%rax
  800c95:	48 83 c2 08          	add    $0x8,%rdx
  800c99:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c9f:	85 db                	test   %ebx,%ebx
  800ca1:	79 02                	jns    800ca5 <vprintfmt+0x1ff>
				err = -err;
  800ca3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ca5:	83 fb 15             	cmp    $0x15,%ebx
  800ca8:	7f 16                	jg     800cc0 <vprintfmt+0x21a>
  800caa:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  800cb1:	00 00 00 
  800cb4:	48 63 d3             	movslq %ebx,%rdx
  800cb7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cbb:	4d 85 e4             	test   %r12,%r12
  800cbe:	75 2e                	jne    800cee <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc8:	89 d9                	mov    %ebx,%ecx
  800cca:	48 ba e1 45 80 00 00 	movabs $0x8045e1,%rdx
  800cd1:	00 00 00 
  800cd4:	48 89 c7             	mov    %rax,%rdi
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	49 b8 be 0f 80 00 00 	movabs $0x800fbe,%r8
  800ce3:	00 00 00 
  800ce6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ce9:	e9 c1 02 00 00       	jmpq   800faf <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf6:	4c 89 e1             	mov    %r12,%rcx
  800cf9:	48 ba ea 45 80 00 00 	movabs $0x8045ea,%rdx
  800d00:	00 00 00 
  800d03:	48 89 c7             	mov    %rax,%rdi
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	49 b8 be 0f 80 00 00 	movabs $0x800fbe,%r8
  800d12:	00 00 00 
  800d15:	41 ff d0             	callq  *%r8
			break;
  800d18:	e9 92 02 00 00       	jmpq   800faf <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d20:	83 f8 30             	cmp    $0x30,%eax
  800d23:	73 17                	jae    800d3c <vprintfmt+0x296>
  800d25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2c:	89 c0                	mov    %eax,%eax
  800d2e:	48 01 d0             	add    %rdx,%rax
  800d31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d34:	83 c2 08             	add    $0x8,%edx
  800d37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d3a:	eb 0f                	jmp    800d4b <vprintfmt+0x2a5>
  800d3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d40:	48 89 d0             	mov    %rdx,%rax
  800d43:	48 83 c2 08          	add    $0x8,%rdx
  800d47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4b:	4c 8b 20             	mov    (%rax),%r12
  800d4e:	4d 85 e4             	test   %r12,%r12
  800d51:	75 0a                	jne    800d5d <vprintfmt+0x2b7>
				p = "(null)";
  800d53:	49 bc ed 45 80 00 00 	movabs $0x8045ed,%r12
  800d5a:	00 00 00 
			if (width > 0 && padc != '-')
  800d5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d61:	7e 3f                	jle    800da2 <vprintfmt+0x2fc>
  800d63:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d67:	74 39                	je     800da2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d69:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d6c:	48 98                	cltq   
  800d6e:	48 89 c6             	mov    %rax,%rsi
  800d71:	4c 89 e7             	mov    %r12,%rdi
  800d74:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  800d7b:	00 00 00 
  800d7e:	ff d0                	callq  *%rax
  800d80:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d83:	eb 17                	jmp    800d9c <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d85:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d89:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d91:	48 89 ce             	mov    %rcx,%rsi
  800d94:	89 d7                	mov    %edx,%edi
  800d96:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d98:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800da0:	7f e3                	jg     800d85 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da2:	eb 37                	jmp    800ddb <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800da4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800da8:	74 1e                	je     800dc8 <vprintfmt+0x322>
  800daa:	83 fb 1f             	cmp    $0x1f,%ebx
  800dad:	7e 05                	jle    800db4 <vprintfmt+0x30e>
  800daf:	83 fb 7e             	cmp    $0x7e,%ebx
  800db2:	7e 14                	jle    800dc8 <vprintfmt+0x322>
					putch('?', putdat);
  800db4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbc:	48 89 d6             	mov    %rdx,%rsi
  800dbf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dc4:	ff d0                	callq  *%rax
  800dc6:	eb 0f                	jmp    800dd7 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800dc8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dcc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd0:	48 89 d6             	mov    %rdx,%rsi
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ddb:	4c 89 e0             	mov    %r12,%rax
  800dde:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800de2:	0f b6 00             	movzbl (%rax),%eax
  800de5:	0f be d8             	movsbl %al,%ebx
  800de8:	85 db                	test   %ebx,%ebx
  800dea:	74 10                	je     800dfc <vprintfmt+0x356>
  800dec:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800df0:	78 b2                	js     800da4 <vprintfmt+0x2fe>
  800df2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800df6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dfa:	79 a8                	jns    800da4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	eb 16                	jmp    800e14 <vprintfmt+0x36e>
				putch(' ', putdat);
  800dfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	bf 20 00 00 00       	mov    $0x20,%edi
  800e0e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e10:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e18:	7f e4                	jg     800dfe <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e1a:	e9 90 01 00 00       	jmpq   800faf <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e23:	be 03 00 00 00       	mov    $0x3,%esi
  800e28:	48 89 c7             	mov    %rax,%rdi
  800e2b:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  800e32:	00 00 00 
  800e35:	ff d0                	callq  *%rax
  800e37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3f:	48 85 c0             	test   %rax,%rax
  800e42:	79 1d                	jns    800e61 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4c:	48 89 d6             	mov    %rdx,%rsi
  800e4f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e54:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5a:	48 f7 d8             	neg    %rax
  800e5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e61:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e68:	e9 d5 00 00 00       	jmpq   800f42 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e71:	be 03 00 00 00       	mov    $0x3,%esi
  800e76:	48 89 c7             	mov    %rax,%rdi
  800e79:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800e80:	00 00 00 
  800e83:	ff d0                	callq  *%rax
  800e85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e89:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e90:	e9 ad 00 00 00       	jmpq   800f42 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800e95:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800e98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e9c:	89 d6                	mov    %edx,%esi
  800e9e:	48 89 c7             	mov    %rax,%rdi
  800ea1:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  800ea8:	00 00 00 
  800eab:	ff d0                	callq  *%rax
  800ead:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800eb1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eb8:	e9 85 00 00 00       	jmpq   800f42 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800ebd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec5:	48 89 d6             	mov    %rdx,%rsi
  800ec8:	bf 30 00 00 00       	mov    $0x30,%edi
  800ecd:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ecf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed7:	48 89 d6             	mov    %rdx,%rsi
  800eda:	bf 78 00 00 00       	mov    $0x78,%edi
  800edf:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ee1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ee4:	83 f8 30             	cmp    $0x30,%eax
  800ee7:	73 17                	jae    800f00 <vprintfmt+0x45a>
  800ee9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800eed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef0:	89 c0                	mov    %eax,%eax
  800ef2:	48 01 d0             	add    %rdx,%rax
  800ef5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ef8:	83 c2 08             	add    $0x8,%edx
  800efb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800efe:	eb 0f                	jmp    800f0f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f04:	48 89 d0             	mov    %rdx,%rax
  800f07:	48 83 c2 08          	add    $0x8,%rdx
  800f0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f0f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f16:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f1d:	eb 23                	jmp    800f42 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f23:	be 03 00 00 00       	mov    $0x3,%esi
  800f28:	48 89 c7             	mov    %rax,%rdi
  800f2b:	48 b8 86 08 80 00 00 	movabs $0x800886,%rax
  800f32:	00 00 00 
  800f35:	ff d0                	callq  *%rax
  800f37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f3b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f42:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f47:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f4a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f51:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f59:	45 89 c1             	mov    %r8d,%r9d
  800f5c:	41 89 f8             	mov    %edi,%r8d
  800f5f:	48 89 c7             	mov    %rax,%rdi
  800f62:	48 b8 cb 07 80 00 00 	movabs $0x8007cb,%rax
  800f69:	00 00 00 
  800f6c:	ff d0                	callq  *%rax
			break;
  800f6e:	eb 3f                	jmp    800faf <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f78:	48 89 d6             	mov    %rdx,%rsi
  800f7b:	89 df                	mov    %ebx,%edi
  800f7d:	ff d0                	callq  *%rax
			break;
  800f7f:	eb 2e                	jmp    800faf <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f89:	48 89 d6             	mov    %rdx,%rsi
  800f8c:	bf 25 00 00 00       	mov    $0x25,%edi
  800f91:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f93:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f98:	eb 05                	jmp    800f9f <vprintfmt+0x4f9>
  800f9a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fa3:	48 83 e8 01          	sub    $0x1,%rax
  800fa7:	0f b6 00             	movzbl (%rax),%eax
  800faa:	3c 25                	cmp    $0x25,%al
  800fac:	75 ec                	jne    800f9a <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800fae:	90                   	nop
		}
	}
  800faf:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fb0:	e9 43 fb ff ff       	jmpq   800af8 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fb5:	48 83 c4 60          	add    $0x60,%rsp
  800fb9:	5b                   	pop    %rbx
  800fba:	41 5c                	pop    %r12
  800fbc:	5d                   	pop    %rbp
  800fbd:	c3                   	retq   

0000000000800fbe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fbe:	55                   	push   %rbp
  800fbf:	48 89 e5             	mov    %rsp,%rbp
  800fc2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fc9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fd0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fd7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fde:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fe5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fec:	84 c0                	test   %al,%al
  800fee:	74 20                	je     801010 <printfmt+0x52>
  800ff0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ff4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ff8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ffc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801000:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801004:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801008:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80100c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801010:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801017:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80101e:	00 00 00 
  801021:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801028:	00 00 00 
  80102b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80102f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801036:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80103d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801044:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80104b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801052:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801059:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801060:	48 89 c7             	mov    %rax,%rdi
  801063:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  80106a:	00 00 00 
  80106d:	ff d0                	callq  *%rax
	va_end(ap);
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 10          	sub    $0x10,%rsp
  801079:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80107c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801084:	8b 40 10             	mov    0x10(%rax),%eax
  801087:	8d 50 01             	lea    0x1(%rax),%edx
  80108a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801095:	48 8b 10             	mov    (%rax),%rdx
  801098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010a0:	48 39 c2             	cmp    %rax,%rdx
  8010a3:	73 17                	jae    8010bc <sprintputch+0x4b>
		*b->buf++ = ch;
  8010a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a9:	48 8b 00             	mov    (%rax),%rax
  8010ac:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010b4:	48 89 0a             	mov    %rcx,(%rdx)
  8010b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ba:	88 10                	mov    %dl,(%rax)
}
  8010bc:	c9                   	leaveq 
  8010bd:	c3                   	retq   

00000000008010be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010be:	55                   	push   %rbp
  8010bf:	48 89 e5             	mov    %rsp,%rbp
  8010c2:	48 83 ec 50          	sub    $0x50,%rsp
  8010c6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010ca:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010cd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010d1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010d5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010d9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010dd:	48 8b 0a             	mov    (%rdx),%rcx
  8010e0:	48 89 08             	mov    %rcx,(%rax)
  8010e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010f7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010fb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010fe:	48 98                	cltq   
  801100:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801104:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801108:	48 01 d0             	add    %rdx,%rax
  80110b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80110f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801116:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80111b:	74 06                	je     801123 <vsnprintf+0x65>
  80111d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801121:	7f 07                	jg     80112a <vsnprintf+0x6c>
		return -E_INVAL;
  801123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801128:	eb 2f                	jmp    801159 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80112a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80112e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801132:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801136:	48 89 c6             	mov    %rax,%rsi
  801139:	48 bf 71 10 80 00 00 	movabs $0x801071,%rdi
  801140:	00 00 00 
  801143:	48 b8 a6 0a 80 00 00 	movabs $0x800aa6,%rax
  80114a:	00 00 00 
  80114d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80114f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801153:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801156:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801159:	c9                   	leaveq 
  80115a:	c3                   	retq   

000000000080115b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80115b:	55                   	push   %rbp
  80115c:	48 89 e5             	mov    %rsp,%rbp
  80115f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801166:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80116d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801173:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80117a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801181:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801188:	84 c0                	test   %al,%al
  80118a:	74 20                	je     8011ac <snprintf+0x51>
  80118c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801190:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801194:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801198:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80119c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011a0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011a4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011a8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011ac:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011b3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ba:	00 00 00 
  8011bd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011c4:	00 00 00 
  8011c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011cb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011d2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011d9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011e0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011e7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011ee:	48 8b 0a             	mov    (%rdx),%rcx
  8011f1:	48 89 08             	mov    %rcx,(%rax)
  8011f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801200:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801204:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80120b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801212:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801218:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80121f:	48 89 c7             	mov    %rax,%rdi
  801222:	48 b8 be 10 80 00 00 	movabs $0x8010be,%rax
  801229:	00 00 00 
  80122c:	ff d0                	callq  *%rax
  80122e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801234:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80123a:	c9                   	leaveq 
  80123b:	c3                   	retq   

000000000080123c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80123c:	55                   	push   %rbp
  80123d:	48 89 e5             	mov    %rsp,%rbp
  801240:	48 83 ec 18          	sub    $0x18,%rsp
  801244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80124f:	eb 09                	jmp    80125a <strlen+0x1e>
		n++;
  801251:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801255:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80125a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	84 c0                	test   %al,%al
  801263:	75 ec                	jne    801251 <strlen+0x15>
		n++;
	return n;
  801265:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 83 ec 20          	sub    $0x20,%rsp
  801272:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801276:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80127a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801281:	eb 0e                	jmp    801291 <strnlen+0x27>
		n++;
  801283:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801287:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801291:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801296:	74 0b                	je     8012a3 <strnlen+0x39>
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	0f b6 00             	movzbl (%rax),%eax
  80129f:	84 c0                	test   %al,%al
  8012a1:	75 e0                	jne    801283 <strnlen+0x19>
		n++;
	return n;
  8012a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012a6:	c9                   	leaveq 
  8012a7:	c3                   	retq   

00000000008012a8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012a8:	55                   	push   %rbp
  8012a9:	48 89 e5             	mov    %rsp,%rbp
  8012ac:	48 83 ec 20          	sub    $0x20,%rsp
  8012b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012c0:	90                   	nop
  8012c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012d5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012d9:	0f b6 12             	movzbl (%rdx),%edx
  8012dc:	88 10                	mov    %dl,(%rax)
  8012de:	0f b6 00             	movzbl (%rax),%eax
  8012e1:	84 c0                	test   %al,%al
  8012e3:	75 dc                	jne    8012c1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 20          	sub    $0x20,%rsp
  8012f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ff:	48 89 c7             	mov    %rax,%rdi
  801302:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  801309:	00 00 00 
  80130c:	ff d0                	callq  *%rax
  80130e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801314:	48 63 d0             	movslq %eax,%rdx
  801317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131b:	48 01 c2             	add    %rax,%rdx
  80131e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801322:	48 89 c6             	mov    %rax,%rsi
  801325:	48 89 d7             	mov    %rdx,%rdi
  801328:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  80132f:	00 00 00 
  801332:	ff d0                	callq  *%rax
	return dst;
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801338:	c9                   	leaveq 
  801339:	c3                   	retq   

000000000080133a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80133a:	55                   	push   %rbp
  80133b:	48 89 e5             	mov    %rsp,%rbp
  80133e:	48 83 ec 28          	sub    $0x28,%rsp
  801342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80134e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801352:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801356:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80135d:	00 
  80135e:	eb 2a                	jmp    80138a <strncpy+0x50>
		*dst++ = *src;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801368:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80136c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801370:	0f b6 12             	movzbl (%rdx),%edx
  801373:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801375:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801379:	0f b6 00             	movzbl (%rax),%eax
  80137c:	84 c0                	test   %al,%al
  80137e:	74 05                	je     801385 <strncpy+0x4b>
			src++;
  801380:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801385:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801392:	72 cc                	jb     801360 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801398:	c9                   	leaveq 
  801399:	c3                   	retq   

000000000080139a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	48 83 ec 28          	sub    $0x28,%rsp
  8013a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013b6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013bb:	74 3d                	je     8013fa <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013bd:	eb 1d                	jmp    8013dc <strlcpy+0x42>
			*dst++ = *src++;
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013cf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013d3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013d7:	0f b6 12             	movzbl (%rdx),%edx
  8013da:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013dc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013e6:	74 0b                	je     8013f3 <strlcpy+0x59>
  8013e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ec:	0f b6 00             	movzbl (%rax),%eax
  8013ef:	84 c0                	test   %al,%al
  8013f1:	75 cc                	jne    8013bf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801402:	48 29 c2             	sub    %rax,%rdx
  801405:	48 89 d0             	mov    %rdx,%rax
}
  801408:	c9                   	leaveq 
  801409:	c3                   	retq   

000000000080140a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80140a:	55                   	push   %rbp
  80140b:	48 89 e5             	mov    %rsp,%rbp
  80140e:	48 83 ec 10          	sub    $0x10,%rsp
  801412:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801416:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80141a:	eb 0a                	jmp    801426 <strcmp+0x1c>
		p++, q++;
  80141c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801421:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	84 c0                	test   %al,%al
  80142f:	74 12                	je     801443 <strcmp+0x39>
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	0f b6 10             	movzbl (%rax),%edx
  801438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	38 c2                	cmp    %al,%dl
  801441:	74 d9                	je     80141c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	0f b6 d0             	movzbl %al,%edx
  80144d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	0f b6 c0             	movzbl %al,%eax
  801457:	29 c2                	sub    %eax,%edx
  801459:	89 d0                	mov    %edx,%eax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 83 ec 18          	sub    $0x18,%rsp
  801465:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801471:	eb 0f                	jmp    801482 <strncmp+0x25>
		n--, p++, q++;
  801473:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801478:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801482:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801487:	74 1d                	je     8014a6 <strncmp+0x49>
  801489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	84 c0                	test   %al,%al
  801492:	74 12                	je     8014a6 <strncmp+0x49>
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	0f b6 10             	movzbl (%rax),%edx
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	38 c2                	cmp    %al,%dl
  8014a4:	74 cd                	je     801473 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ab:	75 07                	jne    8014b4 <strncmp+0x57>
		return 0;
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	eb 18                	jmp    8014cc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	0f b6 d0             	movzbl %al,%edx
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	0f b6 c0             	movzbl %al,%eax
  8014c8:	29 c2                	sub    %eax,%edx
  8014ca:	89 d0                	mov    %edx,%eax
}
  8014cc:	c9                   	leaveq 
  8014cd:	c3                   	retq   

00000000008014ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ce:	55                   	push   %rbp
  8014cf:	48 89 e5             	mov    %rsp,%rbp
  8014d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8014d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014da:	89 f0                	mov    %esi,%eax
  8014dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014df:	eb 17                	jmp    8014f8 <strchr+0x2a>
		if (*s == c)
  8014e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014eb:	75 06                	jne    8014f3 <strchr+0x25>
			return (char *) s;
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	eb 15                	jmp    801508 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	84 c0                	test   %al,%al
  801501:	75 de                	jne    8014e1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   

000000000080150a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80150a:	55                   	push   %rbp
  80150b:	48 89 e5             	mov    %rsp,%rbp
  80150e:	48 83 ec 0c          	sub    $0xc,%rsp
  801512:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801516:	89 f0                	mov    %esi,%eax
  801518:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80151b:	eb 13                	jmp    801530 <strfind+0x26>
		if (*s == c)
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801527:	75 02                	jne    80152b <strfind+0x21>
			break;
  801529:	eb 10                	jmp    80153b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	84 c0                	test   %al,%al
  801539:	75 e2                	jne    80151d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80153b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80153f:	c9                   	leaveq 
  801540:	c3                   	retq   

0000000000801541 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	48 83 ec 18          	sub    $0x18,%rsp
  801549:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801550:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801554:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801559:	75 06                	jne    801561 <memset+0x20>
		return v;
  80155b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155f:	eb 69                	jmp    8015ca <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	83 e0 03             	and    $0x3,%eax
  801568:	48 85 c0             	test   %rax,%rax
  80156b:	75 48                	jne    8015b5 <memset+0x74>
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	83 e0 03             	and    $0x3,%eax
  801574:	48 85 c0             	test   %rax,%rax
  801577:	75 3c                	jne    8015b5 <memset+0x74>
		c &= 0xFF;
  801579:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801580:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801583:	c1 e0 18             	shl    $0x18,%eax
  801586:	89 c2                	mov    %eax,%edx
  801588:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158b:	c1 e0 10             	shl    $0x10,%eax
  80158e:	09 c2                	or     %eax,%edx
  801590:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801593:	c1 e0 08             	shl    $0x8,%eax
  801596:	09 d0                	or     %edx,%eax
  801598:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159f:	48 c1 e8 02          	shr    $0x2,%rax
  8015a3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ad:	48 89 d7             	mov    %rdx,%rdi
  8015b0:	fc                   	cld    
  8015b1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015b3:	eb 11                	jmp    8015c6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015c0:	48 89 d7             	mov    %rdx,%rdi
  8015c3:	fc                   	cld    
  8015c4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ca:	c9                   	leaveq 
  8015cb:	c3                   	retq   

00000000008015cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015cc:	55                   	push   %rbp
  8015cd:	48 89 e5             	mov    %rsp,%rbp
  8015d0:	48 83 ec 28          	sub    $0x28,%rsp
  8015d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015f8:	0f 83 88 00 00 00    	jae    801686 <memmove+0xba>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801606:	48 01 d0             	add    %rdx,%rax
  801609:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80160d:	76 77                	jbe    801686 <memmove+0xba>
		s += n;
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80161f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801623:	83 e0 03             	and    $0x3,%eax
  801626:	48 85 c0             	test   %rax,%rax
  801629:	75 3b                	jne    801666 <memmove+0x9a>
  80162b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162f:	83 e0 03             	and    $0x3,%eax
  801632:	48 85 c0             	test   %rax,%rax
  801635:	75 2f                	jne    801666 <memmove+0x9a>
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	83 e0 03             	and    $0x3,%eax
  80163e:	48 85 c0             	test   %rax,%rax
  801641:	75 23                	jne    801666 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801647:	48 83 e8 04          	sub    $0x4,%rax
  80164b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80164f:	48 83 ea 04          	sub    $0x4,%rdx
  801653:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801657:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80165b:	48 89 c7             	mov    %rax,%rdi
  80165e:	48 89 d6             	mov    %rdx,%rsi
  801661:	fd                   	std    
  801662:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801664:	eb 1d                	jmp    801683 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801672:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	48 89 d7             	mov    %rdx,%rdi
  80167d:	48 89 c1             	mov    %rax,%rcx
  801680:	fd                   	std    
  801681:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801683:	fc                   	cld    
  801684:	eb 57                	jmp    8016dd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168a:	83 e0 03             	and    $0x3,%eax
  80168d:	48 85 c0             	test   %rax,%rax
  801690:	75 36                	jne    8016c8 <memmove+0xfc>
  801692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801696:	83 e0 03             	and    $0x3,%eax
  801699:	48 85 c0             	test   %rax,%rax
  80169c:	75 2a                	jne    8016c8 <memmove+0xfc>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	83 e0 03             	and    $0x3,%eax
  8016a5:	48 85 c0             	test   %rax,%rax
  8016a8:	75 1e                	jne    8016c8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	48 c1 e8 02          	shr    $0x2,%rax
  8016b2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016bd:	48 89 c7             	mov    %rax,%rdi
  8016c0:	48 89 d6             	mov    %rdx,%rsi
  8016c3:	fc                   	cld    
  8016c4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c6:	eb 15                	jmp    8016dd <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016d4:	48 89 c7             	mov    %rax,%rdi
  8016d7:	48 89 d6             	mov    %rdx,%rsi
  8016da:	fc                   	cld    
  8016db:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e1:	c9                   	leaveq 
  8016e2:	c3                   	retq   

00000000008016e3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016e3:	55                   	push   %rbp
  8016e4:	48 89 e5             	mov    %rsp,%rbp
  8016e7:	48 83 ec 18          	sub    $0x18,%rsp
  8016eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016fb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801703:	48 89 ce             	mov    %rcx,%rsi
  801706:	48 89 c7             	mov    %rax,%rdi
  801709:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  801710:	00 00 00 
  801713:	ff d0                	callq  *%rax
}
  801715:	c9                   	leaveq 
  801716:	c3                   	retq   

0000000000801717 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801717:	55                   	push   %rbp
  801718:	48 89 e5             	mov    %rsp,%rbp
  80171b:	48 83 ec 28          	sub    $0x28,%rsp
  80171f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801723:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801727:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80172b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801737:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80173b:	eb 36                	jmp    801773 <memcmp+0x5c>
		if (*s1 != *s2)
  80173d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801741:	0f b6 10             	movzbl (%rax),%edx
  801744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 1a                	je     801769 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80174f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801753:	0f b6 00             	movzbl (%rax),%eax
  801756:	0f b6 d0             	movzbl %al,%edx
  801759:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	0f b6 c0             	movzbl %al,%eax
  801763:	29 c2                	sub    %eax,%edx
  801765:	89 d0                	mov    %edx,%eax
  801767:	eb 20                	jmp    801789 <memcmp+0x72>
		s1++, s2++;
  801769:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80176e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80177b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80177f:	48 85 c0             	test   %rax,%rax
  801782:	75 b9                	jne    80173d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	c9                   	leaveq 
  80178a:	c3                   	retq   

000000000080178b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80178b:	55                   	push   %rbp
  80178c:	48 89 e5             	mov    %rsp,%rbp
  80178f:	48 83 ec 28          	sub    $0x28,%rsp
  801793:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801797:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80179a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a6:	48 01 d0             	add    %rdx,%rax
  8017a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017ad:	eb 15                	jmp    8017c4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b3:	0f b6 10             	movzbl (%rax),%edx
  8017b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017b9:	38 c2                	cmp    %al,%dl
  8017bb:	75 02                	jne    8017bf <memfind+0x34>
			break;
  8017bd:	eb 0f                	jmp    8017ce <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017cc:	72 e1                	jb     8017af <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017d2:	c9                   	leaveq 
  8017d3:	c3                   	retq   

00000000008017d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 83 ec 34          	sub    $0x34,%rsp
  8017dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017e4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017ee:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017f5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f6:	eb 05                	jmp    8017fd <strtol+0x29>
		s++;
  8017f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	0f b6 00             	movzbl (%rax),%eax
  801804:	3c 20                	cmp    $0x20,%al
  801806:	74 f0                	je     8017f8 <strtol+0x24>
  801808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180c:	0f b6 00             	movzbl (%rax),%eax
  80180f:	3c 09                	cmp    $0x9,%al
  801811:	74 e5                	je     8017f8 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	3c 2b                	cmp    $0x2b,%al
  80181c:	75 07                	jne    801825 <strtol+0x51>
		s++;
  80181e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801823:	eb 17                	jmp    80183c <strtol+0x68>
	else if (*s == '-')
  801825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801829:	0f b6 00             	movzbl (%rax),%eax
  80182c:	3c 2d                	cmp    $0x2d,%al
  80182e:	75 0c                	jne    80183c <strtol+0x68>
		s++, neg = 1;
  801830:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801835:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80183c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801840:	74 06                	je     801848 <strtol+0x74>
  801842:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801846:	75 28                	jne    801870 <strtol+0x9c>
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 30                	cmp    $0x30,%al
  801851:	75 1d                	jne    801870 <strtol+0x9c>
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	48 83 c0 01          	add    $0x1,%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	3c 78                	cmp    $0x78,%al
  801860:	75 0e                	jne    801870 <strtol+0x9c>
		s += 2, base = 16;
  801862:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801867:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80186e:	eb 2c                	jmp    80189c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801870:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801874:	75 19                	jne    80188f <strtol+0xbb>
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	3c 30                	cmp    $0x30,%al
  80187f:	75 0e                	jne    80188f <strtol+0xbb>
		s++, base = 8;
  801881:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801886:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80188d:	eb 0d                	jmp    80189c <strtol+0xc8>
	else if (base == 0)
  80188f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801893:	75 07                	jne    80189c <strtol+0xc8>
		base = 10;
  801895:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	0f b6 00             	movzbl (%rax),%eax
  8018a3:	3c 2f                	cmp    $0x2f,%al
  8018a5:	7e 1d                	jle    8018c4 <strtol+0xf0>
  8018a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	3c 39                	cmp    $0x39,%al
  8018b0:	7f 12                	jg     8018c4 <strtol+0xf0>
			dig = *s - '0';
  8018b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b6:	0f b6 00             	movzbl (%rax),%eax
  8018b9:	0f be c0             	movsbl %al,%eax
  8018bc:	83 e8 30             	sub    $0x30,%eax
  8018bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018c2:	eb 4e                	jmp    801912 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	3c 60                	cmp    $0x60,%al
  8018cd:	7e 1d                	jle    8018ec <strtol+0x118>
  8018cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	3c 7a                	cmp    $0x7a,%al
  8018d8:	7f 12                	jg     8018ec <strtol+0x118>
			dig = *s - 'a' + 10;
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	0f be c0             	movsbl %al,%eax
  8018e4:	83 e8 57             	sub    $0x57,%eax
  8018e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ea:	eb 26                	jmp    801912 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	3c 40                	cmp    $0x40,%al
  8018f5:	7e 48                	jle    80193f <strtol+0x16b>
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	3c 5a                	cmp    $0x5a,%al
  801900:	7f 3d                	jg     80193f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	0f be c0             	movsbl %al,%eax
  80190c:	83 e8 37             	sub    $0x37,%eax
  80190f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801912:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801915:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801918:	7c 02                	jl     80191c <strtol+0x148>
			break;
  80191a:	eb 23                	jmp    80193f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80191c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801921:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801924:	48 98                	cltq   
  801926:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80192b:	48 89 c2             	mov    %rax,%rdx
  80192e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801931:	48 98                	cltq   
  801933:	48 01 d0             	add    %rdx,%rax
  801936:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80193a:	e9 5d ff ff ff       	jmpq   80189c <strtol+0xc8>

	if (endptr)
  80193f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801944:	74 0b                	je     801951 <strtol+0x17d>
		*endptr = (char *) s;
  801946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80194a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80194e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801951:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801955:	74 09                	je     801960 <strtol+0x18c>
  801957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195b:	48 f7 d8             	neg    %rax
  80195e:	eb 04                	jmp    801964 <strtol+0x190>
  801960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801964:	c9                   	leaveq 
  801965:	c3                   	retq   

0000000000801966 <strstr>:

char * strstr(const char *in, const char *str)
{
  801966:	55                   	push   %rbp
  801967:	48 89 e5             	mov    %rsp,%rbp
  80196a:	48 83 ec 30          	sub    $0x30,%rsp
  80196e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801972:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801976:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80197a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80197e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801982:	0f b6 00             	movzbl (%rax),%eax
  801985:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801988:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80198c:	75 06                	jne    801994 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80198e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801992:	eb 6b                	jmp    8019ff <strstr+0x99>

	len = strlen(str);
  801994:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801998:	48 89 c7             	mov    %rax,%rdi
  80199b:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
  8019a7:	48 98                	cltq   
  8019a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019b9:	0f b6 00             	movzbl (%rax),%eax
  8019bc:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019bf:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019c3:	75 07                	jne    8019cc <strstr+0x66>
				return (char *) 0;
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ca:	eb 33                	jmp    8019ff <strstr+0x99>
		} while (sc != c);
  8019cc:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019d0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019d3:	75 d8                	jne    8019ad <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e1:	48 89 ce             	mov    %rcx,%rsi
  8019e4:	48 89 c7             	mov    %rax,%rdi
  8019e7:	48 b8 5d 14 80 00 00 	movabs $0x80145d,%rax
  8019ee:	00 00 00 
  8019f1:	ff d0                	callq  *%rax
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	75 b6                	jne    8019ad <strstr+0x47>

	return (char *) (in - 1);
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	48 83 e8 01          	sub    $0x1,%rax
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	53                   	push   %rbx
  801a06:	48 83 ec 48          	sub    $0x48,%rsp
  801a0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a0d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a10:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a14:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a18:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a1c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a23:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a27:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a2b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a2f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a33:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a37:	4c 89 c3             	mov    %r8,%rbx
  801a3a:	cd 30                	int    $0x30
  801a3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a44:	74 3e                	je     801a84 <syscall+0x83>
  801a46:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a4b:	7e 37                	jle    801a84 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a54:	49 89 d0             	mov    %rdx,%r8
  801a57:	89 c1                	mov    %eax,%ecx
  801a59:	48 ba a8 48 80 00 00 	movabs $0x8048a8,%rdx
  801a60:	00 00 00 
  801a63:	be 23 00 00 00       	mov    $0x23,%esi
  801a68:	48 bf c5 48 80 00 00 	movabs $0x8048c5,%rdi
  801a6f:	00 00 00 
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  801a7e:	00 00 00 
  801a81:	41 ff d1             	callq  *%r9

	return ret;
  801a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a88:	48 83 c4 48          	add    $0x48,%rsp
  801a8c:	5b                   	pop    %rbx
  801a8d:	5d                   	pop    %rbp
  801a8e:	c3                   	retq   

0000000000801a8f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a8f:	55                   	push   %rbp
  801a90:	48 89 e5             	mov    %rsp,%rbp
  801a93:	48 83 ec 20          	sub    $0x20,%rsp
  801a97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aae:	00 
  801aaf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abb:	48 89 d1             	mov    %rdx,%rcx
  801abe:	48 89 c2             	mov    %rax,%rdx
  801ac1:	be 00 00 00 00       	mov    $0x0,%esi
  801ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  801acb:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
}
  801ad7:	c9                   	leaveq 
  801ad8:	c3                   	retq   

0000000000801ad9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ae1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae8:	00 
  801ae9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aff:	be 00 00 00 00       	mov    $0x0,%esi
  801b04:	bf 01 00 00 00       	mov    $0x1,%edi
  801b09:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 10          	sub    $0x10,%rsp
  801b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b40:	48 89 c2             	mov    %rax,%rdx
  801b43:	be 01 00 00 00       	mov    $0x1,%esi
  801b48:	bf 03 00 00 00       	mov    $0x3,%edi
  801b4d:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6a:	00 
  801b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	be 00 00 00 00       	mov    $0x0,%esi
  801b86:	bf 02 00 00 00       	mov    $0x2,%edi
  801b8b:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <sys_yield>:

void
sys_yield(void)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ba1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba8:	00 
  801ba9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801baf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	be 00 00 00 00       	mov    $0x0,%esi
  801bc4:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bc9:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
}
  801bd5:	c9                   	leaveq 
  801bd6:	c3                   	retq   

0000000000801bd7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	48 83 ec 20          	sub    $0x20,%rsp
  801bdf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801be6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801be9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bec:	48 63 c8             	movslq %eax,%rcx
  801bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf6:	48 98                	cltq   
  801bf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bff:	00 
  801c00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c06:	49 89 c8             	mov    %rcx,%r8
  801c09:	48 89 d1             	mov    %rdx,%rcx
  801c0c:	48 89 c2             	mov    %rax,%rdx
  801c0f:	be 01 00 00 00       	mov    $0x1,%esi
  801c14:	bf 04 00 00 00       	mov    $0x4,%edi
  801c19:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801c20:	00 00 00 
  801c23:	ff d0                	callq  *%rax
}
  801c25:	c9                   	leaveq 
  801c26:	c3                   	retq   

0000000000801c27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c27:	55                   	push   %rbp
  801c28:	48 89 e5             	mov    %rsp,%rbp
  801c2b:	48 83 ec 30          	sub    $0x30,%rsp
  801c2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c36:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c39:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c3d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c44:	48 63 c8             	movslq %eax,%rcx
  801c47:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c4e:	48 63 f0             	movslq %eax,%rsi
  801c51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	48 98                	cltq   
  801c5a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c5e:	49 89 f9             	mov    %rdi,%r9
  801c61:	49 89 f0             	mov    %rsi,%r8
  801c64:	48 89 d1             	mov    %rdx,%rcx
  801c67:	48 89 c2             	mov    %rax,%rdx
  801c6a:	be 01 00 00 00       	mov    $0x1,%esi
  801c6f:	bf 05 00 00 00       	mov    $0x5,%edi
  801c74:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	48 98                	cltq   
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	48 89 d1             	mov    %rdx,%rcx
  801cb1:	48 89 c2             	mov    %rax,%rdx
  801cb4:	be 01 00 00 00       	mov    $0x1,%esi
  801cb9:	bf 06 00 00 00       	mov    $0x6,%edi
  801cbe:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 10          	sub    $0x10,%rsp
  801cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801cda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cdd:	48 63 d0             	movslq %eax,%rdx
  801ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce3:	48 98                	cltq   
  801ce5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cec:	00 
  801ced:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf9:	48 89 d1             	mov    %rdx,%rcx
  801cfc:	48 89 c2             	mov    %rax,%rdx
  801cff:	be 01 00 00 00       	mov    $0x1,%esi
  801d04:	bf 08 00 00 00       	mov    $0x8,%edi
  801d09:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 20          	sub    $0x20,%rsp
  801d1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2d:	48 98                	cltq   
  801d2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d36:	00 
  801d37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d43:	48 89 d1             	mov    %rdx,%rcx
  801d46:	48 89 c2             	mov    %rax,%rdx
  801d49:	be 01 00 00 00       	mov    $0x1,%esi
  801d4e:	bf 09 00 00 00       	mov    $0x9,%edi
  801d53:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	callq  *%rax
}
  801d5f:	c9                   	leaveq 
  801d60:	c3                   	retq   

0000000000801d61 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d61:	55                   	push   %rbp
  801d62:	48 89 e5             	mov    %rsp,%rbp
  801d65:	48 83 ec 20          	sub    $0x20,%rsp
  801d69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d77:	48 98                	cltq   
  801d79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d80:	00 
  801d81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8d:	48 89 d1             	mov    %rdx,%rcx
  801d90:	48 89 c2             	mov    %rax,%rdx
  801d93:	be 01 00 00 00       	mov    $0x1,%esi
  801d98:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d9d:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 20          	sub    $0x20,%rsp
  801db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dbe:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801dc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc4:	48 63 f0             	movslq %eax,%rsi
  801dc7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dce:	48 98                	cltq   
  801dd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ddb:	00 
  801ddc:	49 89 f1             	mov    %rsi,%r9
  801ddf:	49 89 c8             	mov    %rcx,%r8
  801de2:	48 89 d1             	mov    %rdx,%rcx
  801de5:	48 89 c2             	mov    %rax,%rdx
  801de8:	be 00 00 00 00       	mov    $0x0,%esi
  801ded:	bf 0c 00 00 00       	mov    $0xc,%edi
  801df2:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
}
  801dfe:	c9                   	leaveq 
  801dff:	c3                   	retq   

0000000000801e00 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e00:	55                   	push   %rbp
  801e01:	48 89 e5             	mov    %rsp,%rbp
  801e04:	48 83 ec 10          	sub    $0x10,%rsp
  801e08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e17:	00 
  801e18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e29:	48 89 c2             	mov    %rax,%rdx
  801e2c:	be 01 00 00 00       	mov    $0x1,%esi
  801e31:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e36:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax
}
  801e42:	c9                   	leaveq 
  801e43:	c3                   	retq   

0000000000801e44 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801e44:	55                   	push   %rbp
  801e45:	48 89 e5             	mov    %rsp,%rbp
  801e48:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e53:	00 
  801e54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e60:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e65:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6a:	be 00 00 00 00       	mov    $0x0,%esi
  801e6f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e74:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801e7b:	00 00 00 
  801e7e:	ff d0                	callq  *%rax
}
  801e80:	c9                   	leaveq 
  801e81:	c3                   	retq   

0000000000801e82 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e82:	55                   	push   %rbp
  801e83:	48 89 e5             	mov    %rsp,%rbp
  801e86:	48 83 ec 30          	sub    $0x30,%rsp
  801e8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e91:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e94:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e98:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e9c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e9f:	48 63 c8             	movslq %eax,%rcx
  801ea2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ea6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea9:	48 63 f0             	movslq %eax,%rsi
  801eac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb3:	48 98                	cltq   
  801eb5:	48 89 0c 24          	mov    %rcx,(%rsp)
  801eb9:	49 89 f9             	mov    %rdi,%r9
  801ebc:	49 89 f0             	mov    %rsi,%r8
  801ebf:	48 89 d1             	mov    %rdx,%rcx
  801ec2:	48 89 c2             	mov    %rax,%rdx
  801ec5:	be 00 00 00 00       	mov    $0x0,%esi
  801eca:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ecf:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801edb:	c9                   	leaveq 
  801edc:	c3                   	retq   

0000000000801edd <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801edd:	55                   	push   %rbp
  801ede:	48 89 e5             	mov    %rsp,%rbp
  801ee1:	48 83 ec 20          	sub    $0x20,%rsp
  801ee5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ee9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801eed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801efc:	00 
  801efd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f09:	48 89 d1             	mov    %rdx,%rcx
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	be 00 00 00 00       	mov    $0x0,%esi
  801f14:	bf 10 00 00 00       	mov    $0x10,%edi
  801f19:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
}
  801f25:	c9                   	leaveq 
  801f26:	c3                   	retq   

0000000000801f27 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
  801f2b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801f2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f36:	00 
  801f37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f48:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4d:	be 00 00 00 00       	mov    $0x0,%esi
  801f52:	bf 11 00 00 00       	mov    $0x11,%edi
  801f57:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  801f63:	c9                   	leaveq 
  801f64:	c3                   	retq   

0000000000801f65 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	48 83 ec 10          	sub    $0x10,%rsp
  801f6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801f70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f73:	48 98                	cltq   
  801f75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f7c:	00 
  801f7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f8e:	48 89 c2             	mov    %rax,%rdx
  801f91:	be 00 00 00 00       	mov    $0x0,%esi
  801f96:	bf 12 00 00 00       	mov    $0x12,%edi
  801f9b:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801fa2:	00 00 00 
  801fa5:	ff d0                	callq  *%rax
}
  801fa7:	c9                   	leaveq 
  801fa8:	c3                   	retq   

0000000000801fa9 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801fa9:	55                   	push   %rbp
  801faa:	48 89 e5             	mov    %rsp,%rbp
  801fad:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fb8:	00 
  801fb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fca:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcf:	be 00 00 00 00       	mov    $0x0,%esi
  801fd4:	bf 13 00 00 00       	mov    $0x13,%edi
  801fd9:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
}
  801fe5:	c9                   	leaveq 
  801fe6:	c3                   	retq   

0000000000801fe7 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801fe7:	55                   	push   %rbp
  801fe8:	48 89 e5             	mov    %rsp,%rbp
  801feb:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801fef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff6:	00 
  801ff7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ffd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802003:	b9 00 00 00 00       	mov    $0x0,%ecx
  802008:	ba 00 00 00 00       	mov    $0x0,%edx
  80200d:	be 00 00 00 00       	mov    $0x0,%esi
  802012:	bf 14 00 00 00       	mov    $0x14,%edi
  802017:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
}
  802023:	c9                   	leaveq 
  802024:	c3                   	retq   

0000000000802025 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802025:	55                   	push   %rbp
  802026:	48 89 e5             	mov    %rsp,%rbp
  802029:	48 83 ec 30          	sub    $0x30,%rsp
  80202d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802035:	48 8b 00             	mov    (%rax),%rax
  802038:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80203c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802040:	48 8b 40 08          	mov    0x8(%rax),%rax
  802044:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802047:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80204a:	83 e0 02             	and    $0x2,%eax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	75 4d                	jne    80209e <pgfault+0x79>
  802051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802055:	48 c1 e8 0c          	shr    $0xc,%rax
  802059:	48 89 c2             	mov    %rax,%rdx
  80205c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802063:	01 00 00 
  802066:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206a:	25 00 08 00 00       	and    $0x800,%eax
  80206f:	48 85 c0             	test   %rax,%rax
  802072:	74 2a                	je     80209e <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802074:	48 ba d8 48 80 00 00 	movabs $0x8048d8,%rdx
  80207b:	00 00 00 
  80207e:	be 23 00 00 00       	mov    $0x23,%esi
  802083:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  80208a:	00 00 00 
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802099:	00 00 00 
  80209c:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  80209e:	ba 07 00 00 00       	mov    $0x7,%edx
  8020a3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ad:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	callq  *%rax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	0f 85 cd 00 00 00    	jne    80218e <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8020c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8020d3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8020d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020db:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020e0:	48 89 c6             	mov    %rax,%rsi
  8020e3:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8020e8:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  8020f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020fe:	48 89 c1             	mov    %rax,%rcx
  802101:	ba 00 00 00 00       	mov    $0x0,%edx
  802106:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80210b:	bf 00 00 00 00       	mov    $0x0,%edi
  802110:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802117:	00 00 00 
  80211a:	ff d0                	callq  *%rax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	79 2a                	jns    80214a <pgfault+0x125>
				panic("Page map at temp address failed");
  802120:	48 ba 18 49 80 00 00 	movabs $0x804918,%rdx
  802127:	00 00 00 
  80212a:	be 30 00 00 00       	mov    $0x30,%esi
  80212f:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  802136:	00 00 00 
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802145:	00 00 00 
  802148:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80214a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	85 c0                	test   %eax,%eax
  802162:	79 54                	jns    8021b8 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802164:	48 ba 38 49 80 00 00 	movabs $0x804938,%rdx
  80216b:	00 00 00 
  80216e:	be 32 00 00 00       	mov    $0x32,%esi
  802173:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  80217a:	00 00 00 
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802189:	00 00 00 
  80218c:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  80218e:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  802195:	00 00 00 
  802198:	be 34 00 00 00       	mov    $0x34,%esi
  80219d:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  8021a4:	00 00 00 
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8021b3:	00 00 00 
  8021b6:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 20          	sub    $0x20,%rsp
  8021c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8021c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021cf:	01 00 00 
  8021d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8021de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8021e1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021e4:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8021ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ef:	25 00 04 00 00       	and    $0x400,%eax
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	74 57                	je     80224f <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021f8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021fb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802202:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802206:	41 89 f0             	mov    %esi,%r8d
  802209:	48 89 c6             	mov    %rax,%rsi
  80220c:	bf 00 00 00 00       	mov    $0x0,%edi
  802211:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802218:	00 00 00 
  80221b:	ff d0                	callq  *%rax
  80221d:	85 c0                	test   %eax,%eax
  80221f:	0f 8e 52 01 00 00    	jle    802377 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802225:	48 ba 92 49 80 00 00 	movabs $0x804992,%rdx
  80222c:	00 00 00 
  80222f:	be 4e 00 00 00       	mov    $0x4e,%esi
  802234:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  80223b:	00 00 00 
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80224a:	00 00 00 
  80224d:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  80224f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802252:	83 e0 02             	and    $0x2,%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 10                	jne    802269 <duppage+0xaf>
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225c:	25 00 08 00 00       	and    $0x800,%eax
  802261:	85 c0                	test   %eax,%eax
  802263:	0f 84 bb 00 00 00    	je     802324 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  802269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226c:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802271:	80 cc 08             	or     $0x8,%ah
  802274:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802277:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80227a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80227e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802285:	41 89 f0             	mov    %esi,%r8d
  802288:	48 89 c6             	mov    %rax,%rsi
  80228b:	bf 00 00 00 00       	mov    $0x0,%edi
  802290:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	7e 2a                	jle    8022ca <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8022a0:	48 ba 92 49 80 00 00 	movabs $0x804992,%rdx
  8022a7:	00 00 00 
  8022aa:	be 55 00 00 00       	mov    $0x55,%esi
  8022af:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  8022b6:	00 00 00 
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8022c5:	00 00 00 
  8022c8:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8022ca:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8022cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d5:	41 89 c8             	mov    %ecx,%r8d
  8022d8:	48 89 d1             	mov    %rdx,%rcx
  8022db:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e0:	48 89 c6             	mov    %rax,%rsi
  8022e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e8:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	7e 2a                	jle    802322 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8022f8:	48 ba 92 49 80 00 00 	movabs $0x804992,%rdx
  8022ff:	00 00 00 
  802302:	be 57 00 00 00       	mov    $0x57,%esi
  802307:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  80230e:	00 00 00 
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80231d:	00 00 00 
  802320:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802322:	eb 53                	jmp    802377 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802324:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802327:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80232b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80232e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802332:	41 89 f0             	mov    %esi,%r8d
  802335:	48 89 c6             	mov    %rax,%rsi
  802338:	bf 00 00 00 00       	mov    $0x0,%edi
  80233d:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802344:	00 00 00 
  802347:	ff d0                	callq  *%rax
  802349:	85 c0                	test   %eax,%eax
  80234b:	7e 2a                	jle    802377 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80234d:	48 ba 92 49 80 00 00 	movabs $0x804992,%rdx
  802354:	00 00 00 
  802357:	be 5b 00 00 00       	mov    $0x5b,%esi
  80235c:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  802363:	00 00 00 
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
  80236b:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802372:	00 00 00 
  802375:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237c:	c9                   	leaveq 
  80237d:	c3                   	retq   

000000000080237e <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80237e:	55                   	push   %rbp
  80237f:	48 89 e5             	mov    %rsp,%rbp
  802382:	48 83 ec 18          	sub    $0x18,%rsp
  802386:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80238a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802396:	48 c1 e8 27          	shr    $0x27,%rax
  80239a:	48 89 c2             	mov    %rax,%rdx
  80239d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023a4:	01 00 00 
  8023a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ab:	83 e0 01             	and    $0x1,%eax
  8023ae:	48 85 c0             	test   %rax,%rax
  8023b1:	74 51                	je     802404 <pt_is_mapped+0x86>
  8023b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b7:	48 c1 e0 0c          	shl    $0xc,%rax
  8023bb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023bf:	48 89 c2             	mov    %rax,%rdx
  8023c2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023c9:	01 00 00 
  8023cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d0:	83 e0 01             	and    $0x1,%eax
  8023d3:	48 85 c0             	test   %rax,%rax
  8023d6:	74 2c                	je     802404 <pt_is_mapped+0x86>
  8023d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8023e0:	48 c1 e8 15          	shr    $0x15,%rax
  8023e4:	48 89 c2             	mov    %rax,%rdx
  8023e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023ee:	01 00 00 
  8023f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f5:	83 e0 01             	and    $0x1,%eax
  8023f8:	48 85 c0             	test   %rax,%rax
  8023fb:	74 07                	je     802404 <pt_is_mapped+0x86>
  8023fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802402:	eb 05                	jmp    802409 <pt_is_mapped+0x8b>
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	83 e0 01             	and    $0x1,%eax
}
  80240c:	c9                   	leaveq 
  80240d:	c3                   	retq   

000000000080240e <fork>:

envid_t
fork(void)
{
  80240e:	55                   	push   %rbp
  80240f:	48 89 e5             	mov    %rsp,%rbp
  802412:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802416:	48 bf 25 20 80 00 00 	movabs $0x802025,%rdi
  80241d:	00 00 00 
  802420:	48 b8 04 3f 80 00 00 	movabs $0x803f04,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80242c:	b8 07 00 00 00       	mov    $0x7,%eax
  802431:	cd 30                	int    $0x30
  802433:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802436:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802439:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80243c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802440:	79 30                	jns    802472 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802442:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802445:	89 c1                	mov    %eax,%ecx
  802447:	48 ba b0 49 80 00 00 	movabs $0x8049b0,%rdx
  80244e:	00 00 00 
  802451:	be 86 00 00 00       	mov    $0x86,%esi
  802456:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  80245d:	00 00 00 
  802460:	b8 00 00 00 00       	mov    $0x0,%eax
  802465:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80246c:	00 00 00 
  80246f:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802472:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802476:	75 3e                	jne    8024b6 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802478:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80247f:	00 00 00 
  802482:	ff d0                	callq  *%rax
  802484:	25 ff 03 00 00       	and    $0x3ff,%eax
  802489:	48 98                	cltq   
  80248b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802492:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802499:	00 00 00 
  80249c:	48 01 c2             	add    %rax,%rdx
  80249f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024a6:	00 00 00 
  8024a9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b1:	e9 d1 01 00 00       	jmpq   802687 <fork+0x279>
	}
	uint64_t ad = 0;
  8024b6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024bd:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024be:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8024c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8024c7:	e9 df 00 00 00       	jmpq   8025ab <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8024cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d0:	48 c1 e8 27          	shr    $0x27,%rax
  8024d4:	48 89 c2             	mov    %rax,%rdx
  8024d7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8024de:	01 00 00 
  8024e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e5:	83 e0 01             	and    $0x1,%eax
  8024e8:	48 85 c0             	test   %rax,%rax
  8024eb:	0f 84 9e 00 00 00    	je     80258f <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8024f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f5:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024f9:	48 89 c2             	mov    %rax,%rdx
  8024fc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802503:	01 00 00 
  802506:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250a:	83 e0 01             	and    $0x1,%eax
  80250d:	48 85 c0             	test   %rax,%rax
  802510:	74 73                	je     802585 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802516:	48 c1 e8 15          	shr    $0x15,%rax
  80251a:	48 89 c2             	mov    %rax,%rdx
  80251d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802524:	01 00 00 
  802527:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252b:	83 e0 01             	and    $0x1,%eax
  80252e:	48 85 c0             	test   %rax,%rax
  802531:	74 48                	je     80257b <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802537:	48 c1 e8 0c          	shr    $0xc,%rax
  80253b:	48 89 c2             	mov    %rax,%rdx
  80253e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802545:	01 00 00 
  802548:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802554:	83 e0 01             	and    $0x1,%eax
  802557:	48 85 c0             	test   %rax,%rax
  80255a:	74 47                	je     8025a3 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80255c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802560:	48 c1 e8 0c          	shr    $0xc,%rax
  802564:	89 c2                	mov    %eax,%edx
  802566:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802569:	89 d6                	mov    %edx,%esi
  80256b:	89 c7                	mov    %eax,%edi
  80256d:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	eb 28                	jmp    8025a3 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80257b:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802582:	00 
  802583:	eb 1e                	jmp    8025a3 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802585:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80258c:	40 
  80258d:	eb 14                	jmp    8025a3 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80258f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802593:	48 c1 e8 27          	shr    $0x27,%rax
  802597:	48 83 c0 01          	add    $0x1,%rax
  80259b:	48 c1 e0 27          	shl    $0x27,%rax
  80259f:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8025a3:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8025aa:	00 
  8025ab:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8025b2:	00 
  8025b3:	0f 87 13 ff ff ff    	ja     8024cc <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8025b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025bc:	ba 07 00 00 00       	mov    $0x7,%edx
  8025c1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8025c6:	89 c7                	mov    %eax,%edi
  8025c8:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8025d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025d7:	ba 07 00 00 00       	mov    $0x7,%edx
  8025dc:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8025ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025f2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8025f8:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8025fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802602:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802607:	89 c7                	mov    %eax,%edi
  802609:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802615:	ba 00 10 00 00       	mov    $0x1000,%edx
  80261a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80261f:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802624:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802630:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802635:	bf 00 00 00 00       	mov    $0x0,%edi
  80263a:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802646:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80264d:	00 00 00 
  802650:	48 8b 00             	mov    (%rax),%rax
  802653:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80265a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80265d:	48 89 d6             	mov    %rdx,%rsi
  802660:	89 c7                	mov    %eax,%edi
  802662:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80266e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802671:	be 02 00 00 00       	mov    $0x2,%esi
  802676:	89 c7                	mov    %eax,%edi
  802678:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80267f:	00 00 00 
  802682:	ff d0                	callq  *%rax

	return envid;
  802684:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802687:	c9                   	leaveq 
  802688:	c3                   	retq   

0000000000802689 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802689:	55                   	push   %rbp
  80268a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80268d:	48 ba c8 49 80 00 00 	movabs $0x8049c8,%rdx
  802694:	00 00 00 
  802697:	be bf 00 00 00       	mov    $0xbf,%esi
  80269c:	48 bf 0d 49 80 00 00 	movabs $0x80490d,%rdi
  8026a3:	00 00 00 
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8026b2:	00 00 00 
  8026b5:	ff d1                	callq  *%rcx

00000000008026b7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 08          	sub    $0x8,%rsp
  8026bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026c7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026ce:	ff ff ff 
  8026d1:	48 01 d0             	add    %rdx,%rax
  8026d4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026d8:	c9                   	leaveq 
  8026d9:	c3                   	retq   

00000000008026da <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026da:	55                   	push   %rbp
  8026db:	48 89 e5             	mov    %rsp,%rbp
  8026de:	48 83 ec 08          	sub    $0x8,%rsp
  8026e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ea:	48 89 c7             	mov    %rax,%rdi
  8026ed:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026ff:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802703:	c9                   	leaveq 
  802704:	c3                   	retq   

0000000000802705 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802705:	55                   	push   %rbp
  802706:	48 89 e5             	mov    %rsp,%rbp
  802709:	48 83 ec 18          	sub    $0x18,%rsp
  80270d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802718:	eb 6b                	jmp    802785 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80271a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271d:	48 98                	cltq   
  80271f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802725:	48 c1 e0 0c          	shl    $0xc,%rax
  802729:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80272d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802731:	48 c1 e8 15          	shr    $0x15,%rax
  802735:	48 89 c2             	mov    %rax,%rdx
  802738:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80273f:	01 00 00 
  802742:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802746:	83 e0 01             	and    $0x1,%eax
  802749:	48 85 c0             	test   %rax,%rax
  80274c:	74 21                	je     80276f <fd_alloc+0x6a>
  80274e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802752:	48 c1 e8 0c          	shr    $0xc,%rax
  802756:	48 89 c2             	mov    %rax,%rdx
  802759:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802760:	01 00 00 
  802763:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802767:	83 e0 01             	and    $0x1,%eax
  80276a:	48 85 c0             	test   %rax,%rax
  80276d:	75 12                	jne    802781 <fd_alloc+0x7c>
			*fd_store = fd;
  80276f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802773:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802777:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
  80277f:	eb 1a                	jmp    80279b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802781:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802785:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802789:	7e 8f                	jle    80271a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802796:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80279b:	c9                   	leaveq 
  80279c:	c3                   	retq   

000000000080279d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80279d:	55                   	push   %rbp
  80279e:	48 89 e5             	mov    %rsp,%rbp
  8027a1:	48 83 ec 20          	sub    $0x20,%rsp
  8027a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027b0:	78 06                	js     8027b8 <fd_lookup+0x1b>
  8027b2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027b6:	7e 07                	jle    8027bf <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027bd:	eb 6c                	jmp    80282b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027c2:	48 98                	cltq   
  8027c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8027ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d6:	48 c1 e8 15          	shr    $0x15,%rax
  8027da:	48 89 c2             	mov    %rax,%rdx
  8027dd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027e4:	01 00 00 
  8027e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027eb:	83 e0 01             	and    $0x1,%eax
  8027ee:	48 85 c0             	test   %rax,%rax
  8027f1:	74 21                	je     802814 <fd_lookup+0x77>
  8027f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8027fb:	48 89 c2             	mov    %rax,%rdx
  8027fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802805:	01 00 00 
  802808:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280c:	83 e0 01             	and    $0x1,%eax
  80280f:	48 85 c0             	test   %rax,%rax
  802812:	75 07                	jne    80281b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802814:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802819:	eb 10                	jmp    80282b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80281b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802823:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282b:	c9                   	leaveq 
  80282c:	c3                   	retq   

000000000080282d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80282d:	55                   	push   %rbp
  80282e:	48 89 e5             	mov    %rsp,%rbp
  802831:	48 83 ec 30          	sub    $0x30,%rsp
  802835:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802839:	89 f0                	mov    %esi,%eax
  80283b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80283e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802842:	48 89 c7             	mov    %rax,%rdi
  802845:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802855:	48 89 d6             	mov    %rdx,%rsi
  802858:	89 c7                	mov    %eax,%edi
  80285a:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286d:	78 0a                	js     802879 <fd_close+0x4c>
	    || fd != fd2)
  80286f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802873:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802877:	74 12                	je     80288b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802879:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80287d:	74 05                	je     802884 <fd_close+0x57>
  80287f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802882:	eb 05                	jmp    802889 <fd_close+0x5c>
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
  802889:	eb 69                	jmp    8028f4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80288b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288f:	8b 00                	mov    (%rax),%eax
  802891:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802895:	48 89 d6             	mov    %rdx,%rsi
  802898:	89 c7                	mov    %eax,%edi
  80289a:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ad:	78 2a                	js     8028d9 <fd_close+0xac>
		if (dev->dev_close)
  8028af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028b7:	48 85 c0             	test   %rax,%rax
  8028ba:	74 16                	je     8028d2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c8:	48 89 d7             	mov    %rdx,%rdi
  8028cb:	ff d0                	callq  *%rax
  8028cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d0:	eb 07                	jmp    8028d9 <fd_close+0xac>
		else
			r = 0;
  8028d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028dd:	48 89 c6             	mov    %rax,%rsi
  8028e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e5:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax
	return r;
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028f4:	c9                   	leaveq 
  8028f5:	c3                   	retq   

00000000008028f6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	48 83 ec 20          	sub    $0x20,%rsp
  8028fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802901:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802905:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80290c:	eb 41                	jmp    80294f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80290e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802915:	00 00 00 
  802918:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80291b:	48 63 d2             	movslq %edx,%rdx
  80291e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802922:	8b 00                	mov    (%rax),%eax
  802924:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802927:	75 22                	jne    80294b <dev_lookup+0x55>
			*dev = devtab[i];
  802929:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802930:	00 00 00 
  802933:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802936:	48 63 d2             	movslq %edx,%rdx
  802939:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80293d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802941:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
  802949:	eb 60                	jmp    8029ab <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80294b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80294f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802956:	00 00 00 
  802959:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80295c:	48 63 d2             	movslq %edx,%rdx
  80295f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802963:	48 85 c0             	test   %rax,%rax
  802966:	75 a6                	jne    80290e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802968:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80296f:	00 00 00 
  802972:	48 8b 00             	mov    (%rax),%rax
  802975:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80297b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80297e:	89 c6                	mov    %eax,%esi
  802980:	48 bf e0 49 80 00 00 	movabs $0x8049e0,%rdi
  802987:	00 00 00 
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802996:	00 00 00 
  802999:	ff d1                	callq  *%rcx
	*dev = 0;
  80299b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029ab:	c9                   	leaveq 
  8029ac:	c3                   	retq   

00000000008029ad <close>:

int
close(int fdnum)
{
  8029ad:	55                   	push   %rbp
  8029ae:	48 89 e5             	mov    %rsp,%rbp
  8029b1:	48 83 ec 20          	sub    $0x20,%rsp
  8029b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029bf:	48 89 d6             	mov    %rdx,%rsi
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d7:	79 05                	jns    8029de <close+0x31>
		return r;
  8029d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dc:	eb 18                	jmp    8029f6 <close+0x49>
	else
		return fd_close(fd, 1);
  8029de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e2:	be 01 00 00 00       	mov    $0x1,%esi
  8029e7:	48 89 c7             	mov    %rax,%rdi
  8029ea:	48 b8 2d 28 80 00 00 	movabs $0x80282d,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <close_all>:

void
close_all(void)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a07:	eb 15                	jmp    802a1e <close_all+0x26>
		close(i);
  802a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0c:	89 c7                	mov    %eax,%edi
  802a0e:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a1e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a22:	7e e5                	jle    802a09 <close_all+0x11>
		close(i);
}
  802a24:	c9                   	leaveq 
  802a25:	c3                   	retq   

0000000000802a26 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
  802a2a:	48 83 ec 40          	sub    $0x40,%rsp
  802a2e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a31:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a34:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a38:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a3b:	48 89 d6             	mov    %rdx,%rsi
  802a3e:	89 c7                	mov    %eax,%edi
  802a40:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
  802a4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a53:	79 08                	jns    802a5d <dup+0x37>
		return r;
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	e9 70 01 00 00       	jmpq   802bcd <dup+0x1a7>
	close(newfdnum);
  802a5d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a60:	89 c7                	mov    %eax,%edi
  802a62:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a6e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a71:	48 98                	cltq   
  802a73:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a79:	48 c1 e0 0c          	shl    $0xc,%rax
  802a7d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a85:	48 89 c7             	mov    %rax,%rdi
  802a88:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
  802a94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9c:	48 89 c7             	mov    %rax,%rdi
  802a9f:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab3:	48 c1 e8 15          	shr    $0x15,%rax
  802ab7:	48 89 c2             	mov    %rax,%rdx
  802aba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ac1:	01 00 00 
  802ac4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac8:	83 e0 01             	and    $0x1,%eax
  802acb:	48 85 c0             	test   %rax,%rax
  802ace:	74 73                	je     802b43 <dup+0x11d>
  802ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad4:	48 c1 e8 0c          	shr    $0xc,%rax
  802ad8:	48 89 c2             	mov    %rax,%rdx
  802adb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ae2:	01 00 00 
  802ae5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae9:	83 e0 01             	and    $0x1,%eax
  802aec:	48 85 c0             	test   %rax,%rax
  802aef:	74 52                	je     802b43 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802af1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af5:	48 c1 e8 0c          	shr    $0xc,%rax
  802af9:	48 89 c2             	mov    %rax,%rdx
  802afc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b03:	01 00 00 
  802b06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b0a:	25 07 0e 00 00       	and    $0xe07,%eax
  802b0f:	89 c1                	mov    %eax,%ecx
  802b11:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	41 89 c8             	mov    %ecx,%r8d
  802b1c:	48 89 d1             	mov    %rdx,%rcx
  802b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b24:	48 89 c6             	mov    %rax,%rsi
  802b27:	bf 00 00 00 00       	mov    $0x0,%edi
  802b2c:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3f:	79 02                	jns    802b43 <dup+0x11d>
			goto err;
  802b41:	eb 57                	jmp    802b9a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b47:	48 c1 e8 0c          	shr    $0xc,%rax
  802b4b:	48 89 c2             	mov    %rax,%rdx
  802b4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b55:	01 00 00 
  802b58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b5c:	25 07 0e 00 00       	and    $0xe07,%eax
  802b61:	89 c1                	mov    %eax,%ecx
  802b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b6b:	41 89 c8             	mov    %ecx,%r8d
  802b6e:	48 89 d1             	mov    %rdx,%rcx
  802b71:	ba 00 00 00 00       	mov    $0x0,%edx
  802b76:	48 89 c6             	mov    %rax,%rsi
  802b79:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7e:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
  802b8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b91:	79 02                	jns    802b95 <dup+0x16f>
		goto err;
  802b93:	eb 05                	jmp    802b9a <dup+0x174>

	return newfdnum;
  802b95:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b98:	eb 33                	jmp    802bcd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9e:	48 89 c6             	mov    %rax,%rsi
  802ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba6:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb6:	48 89 c6             	mov    %rax,%rsi
  802bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  802bbe:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
	return r;
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	48 83 ec 40          	sub    $0x40,%rsp
  802bd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bde:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802be2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802be6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802be9:	48 89 d6             	mov    %rdx,%rsi
  802bec:	89 c7                	mov    %eax,%edi
  802bee:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802bf5:	00 00 00 
  802bf8:	ff d0                	callq  *%rax
  802bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c01:	78 24                	js     802c27 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c07:	8b 00                	mov    (%rax),%eax
  802c09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c0d:	48 89 d6             	mov    %rdx,%rsi
  802c10:	89 c7                	mov    %eax,%edi
  802c12:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  802c19:	00 00 00 
  802c1c:	ff d0                	callq  *%rax
  802c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c25:	79 05                	jns    802c2c <read+0x5d>
		return r;
  802c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2a:	eb 76                	jmp    802ca2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	8b 40 08             	mov    0x8(%rax),%eax
  802c33:	83 e0 03             	and    $0x3,%eax
  802c36:	83 f8 01             	cmp    $0x1,%eax
  802c39:	75 3a                	jne    802c75 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c3b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c42:	00 00 00 
  802c45:	48 8b 00             	mov    (%rax),%rax
  802c48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c4e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c51:	89 c6                	mov    %eax,%esi
  802c53:	48 bf ff 49 80 00 00 	movabs $0x8049ff,%rdi
  802c5a:	00 00 00 
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c62:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802c69:	00 00 00 
  802c6c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c73:	eb 2d                	jmp    802ca2 <read+0xd3>
	}
	if (!dev->dev_read)
  802c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c79:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c7d:	48 85 c0             	test   %rax,%rax
  802c80:	75 07                	jne    802c89 <read+0xba>
		return -E_NOT_SUPP;
  802c82:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c87:	eb 19                	jmp    802ca2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c99:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c9d:	48 89 cf             	mov    %rcx,%rdi
  802ca0:	ff d0                	callq  *%rax
}
  802ca2:	c9                   	leaveq 
  802ca3:	c3                   	retq   

0000000000802ca4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ca4:	55                   	push   %rbp
  802ca5:	48 89 e5             	mov    %rsp,%rbp
  802ca8:	48 83 ec 30          	sub    $0x30,%rsp
  802cac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802caf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cbe:	eb 49                	jmp    802d09 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc3:	48 98                	cltq   
  802cc5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cc9:	48 29 c2             	sub    %rax,%rdx
  802ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccf:	48 63 c8             	movslq %eax,%rcx
  802cd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd6:	48 01 c1             	add    %rax,%rcx
  802cd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdc:	48 89 ce             	mov    %rcx,%rsi
  802cdf:	89 c7                	mov    %eax,%edi
  802ce1:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
  802ced:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cf0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cf4:	79 05                	jns    802cfb <readn+0x57>
			return m;
  802cf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf9:	eb 1c                	jmp    802d17 <readn+0x73>
		if (m == 0)
  802cfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cff:	75 02                	jne    802d03 <readn+0x5f>
			break;
  802d01:	eb 11                	jmp    802d14 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d06:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0c:	48 98                	cltq   
  802d0e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d12:	72 ac                	jb     802cc0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d17:	c9                   	leaveq 
  802d18:	c3                   	retq   

0000000000802d19 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 83 ec 40          	sub    $0x40,%rsp
  802d21:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d24:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d28:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d2c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d30:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d33:	48 89 d6             	mov    %rdx,%rsi
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4b:	78 24                	js     802d71 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d51:	8b 00                	mov    (%rax),%eax
  802d53:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d57:	48 89 d6             	mov    %rdx,%rsi
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6f:	79 05                	jns    802d76 <write+0x5d>
		return r;
  802d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d74:	eb 42                	jmp    802db8 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7a:	8b 40 08             	mov    0x8(%rax),%eax
  802d7d:	83 e0 03             	and    $0x3,%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	75 07                	jne    802d8b <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802d84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d89:	eb 2d                	jmp    802db8 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d93:	48 85 c0             	test   %rax,%rax
  802d96:	75 07                	jne    802d9f <write+0x86>
		return -E_NOT_SUPP;
  802d98:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d9d:	eb 19                	jmp    802db8 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802da7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802daf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802db3:	48 89 cf             	mov    %rcx,%rdi
  802db6:	ff d0                	callq  *%rax
}
  802db8:	c9                   	leaveq 
  802db9:	c3                   	retq   

0000000000802dba <seek>:

int
seek(int fdnum, off_t offset)
{
  802dba:	55                   	push   %rbp
  802dbb:	48 89 e5             	mov    %rsp,%rbp
  802dbe:	48 83 ec 18          	sub    $0x18,%rsp
  802dc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dcf:	48 89 d6             	mov    %rdx,%rsi
  802dd2:	89 c7                	mov    %eax,%edi
  802dd4:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de7:	79 05                	jns    802dee <seek+0x34>
		return r;
  802de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dec:	eb 0f                	jmp    802dfd <seek+0x43>
	fd->fd_offset = offset;
  802dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dfd:	c9                   	leaveq 
  802dfe:	c3                   	retq   

0000000000802dff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802dff:	55                   	push   %rbp
  802e00:	48 89 e5             	mov    %rsp,%rbp
  802e03:	48 83 ec 30          	sub    $0x30,%rsp
  802e07:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e0a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e0d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e11:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e14:	48 89 d6             	mov    %rdx,%rsi
  802e17:	89 c7                	mov    %eax,%edi
  802e19:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2c:	78 24                	js     802e52 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	8b 00                	mov    (%rax),%eax
  802e34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e38:	48 89 d6             	mov    %rdx,%rsi
  802e3b:	89 c7                	mov    %eax,%edi
  802e3d:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  802e44:	00 00 00 
  802e47:	ff d0                	callq  *%rax
  802e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e50:	79 05                	jns    802e57 <ftruncate+0x58>
		return r;
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	eb 72                	jmp    802ec9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5b:	8b 40 08             	mov    0x8(%rax),%eax
  802e5e:	83 e0 03             	and    $0x3,%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	75 3a                	jne    802e9f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e65:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e6c:	00 00 00 
  802e6f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e72:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e78:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e7b:	89 c6                	mov    %eax,%esi
  802e7d:	48 bf 20 4a 80 00 00 	movabs $0x804a20,%rdi
  802e84:	00 00 00 
  802e87:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8c:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802e93:	00 00 00 
  802e96:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e9d:	eb 2a                	jmp    802ec9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ea7:	48 85 c0             	test   %rax,%rax
  802eaa:	75 07                	jne    802eb3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802eac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb1:	eb 16                	jmp    802ec9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb7:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ebb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ebf:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ec2:	89 ce                	mov    %ecx,%esi
  802ec4:	48 89 d7             	mov    %rdx,%rdi
  802ec7:	ff d0                	callq  *%rax
}
  802ec9:	c9                   	leaveq 
  802eca:	c3                   	retq   

0000000000802ecb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ecb:	55                   	push   %rbp
  802ecc:	48 89 e5             	mov    %rsp,%rbp
  802ecf:	48 83 ec 30          	sub    $0x30,%rsp
  802ed3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ed6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802eda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ede:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ee1:	48 89 d6             	mov    %rdx,%rsi
  802ee4:	89 c7                	mov    %eax,%edi
  802ee6:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
  802ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef9:	78 24                	js     802f1f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	8b 00                	mov    (%rax),%eax
  802f01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f05:	48 89 d6             	mov    %rdx,%rsi
  802f08:	89 c7                	mov    %eax,%edi
  802f0a:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1d:	79 05                	jns    802f24 <fstat+0x59>
		return r;
  802f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f22:	eb 5e                	jmp    802f82 <fstat+0xb7>
	if (!dev->dev_stat)
  802f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f28:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f2c:	48 85 c0             	test   %rax,%rax
  802f2f:	75 07                	jne    802f38 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f31:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f36:	eb 4a                	jmp    802f82 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f3c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f43:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f4a:	00 00 00 
	stat->st_isdir = 0;
  802f4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f51:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f58:	00 00 00 
	stat->st_dev = dev;
  802f5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f63:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f76:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f7a:	48 89 ce             	mov    %rcx,%rsi
  802f7d:	48 89 d7             	mov    %rdx,%rdi
  802f80:	ff d0                	callq  *%rax
}
  802f82:	c9                   	leaveq 
  802f83:	c3                   	retq   

0000000000802f84 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f84:	55                   	push   %rbp
  802f85:	48 89 e5             	mov    %rsp,%rbp
  802f88:	48 83 ec 20          	sub    $0x20,%rsp
  802f8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	48 89 c7             	mov    %rax,%rdi
  802fa0:	48 b8 72 30 80 00 00 	movabs $0x803072,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
  802fac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802faf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb3:	79 05                	jns    802fba <stat+0x36>
		return fd;
  802fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb8:	eb 2f                	jmp    802fe9 <stat+0x65>
	r = fstat(fd, stat);
  802fba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc1:	48 89 d6             	mov    %rdx,%rsi
  802fc4:	89 c7                	mov    %eax,%edi
  802fc6:	48 b8 cb 2e 80 00 00 	movabs $0x802ecb,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
  802fd2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd8:	89 c7                	mov    %eax,%edi
  802fda:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
	return r;
  802fe6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fe9:	c9                   	leaveq 
  802fea:	c3                   	retq   

0000000000802feb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802feb:	55                   	push   %rbp
  802fec:	48 89 e5             	mov    %rsp,%rbp
  802fef:	48 83 ec 10          	sub    $0x10,%rsp
  802ff3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ff6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ffa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803001:	00 00 00 
  803004:	8b 00                	mov    (%rax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	75 1d                	jne    803027 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80300a:	bf 01 00 00 00       	mov    $0x1,%edi
  80300f:	48 b8 ca 41 80 00 00 	movabs $0x8041ca,%rax
  803016:	00 00 00 
  803019:	ff d0                	callq  *%rax
  80301b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  803022:	00 00 00 
  803025:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803027:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80302e:	00 00 00 
  803031:	8b 00                	mov    (%rax),%eax
  803033:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803036:	b9 07 00 00 00       	mov    $0x7,%ecx
  80303b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803042:	00 00 00 
  803045:	89 c7                	mov    %eax,%edi
  803047:	48 b8 42 41 80 00 00 	movabs $0x804142,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803057:	ba 00 00 00 00       	mov    $0x0,%edx
  80305c:	48 89 c6             	mov    %rax,%rsi
  80305f:	bf 00 00 00 00       	mov    $0x0,%edi
  803064:	48 b8 44 40 80 00 00 	movabs $0x804044,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	callq  *%rax
}
  803070:	c9                   	leaveq 
  803071:	c3                   	retq   

0000000000803072 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803072:	55                   	push   %rbp
  803073:	48 89 e5             	mov    %rsp,%rbp
  803076:	48 83 ec 30          	sub    $0x30,%rsp
  80307a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80307e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803081:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803088:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80308f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803096:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80309b:	75 08                	jne    8030a5 <open+0x33>
	{
		return r;
  80309d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a0:	e9 f2 00 00 00       	jmpq   803197 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8030a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a9:	48 89 c7             	mov    %rax,%rdi
  8030ac:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030bb:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8030c2:	7e 0a                	jle    8030ce <open+0x5c>
	{
		return -E_BAD_PATH;
  8030c4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030c9:	e9 c9 00 00 00       	jmpq   803197 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8030ce:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8030d5:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8030d6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030da:	48 89 c7             	mov    %rax,%rdi
  8030dd:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
  8030e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f0:	78 09                	js     8030fb <open+0x89>
  8030f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f6:	48 85 c0             	test   %rax,%rax
  8030f9:	75 08                	jne    803103 <open+0x91>
		{
			return r;
  8030fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fe:	e9 94 00 00 00       	jmpq   803197 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803107:	ba 00 04 00 00       	mov    $0x400,%edx
  80310c:	48 89 c6             	mov    %rax,%rsi
  80310f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803116:	00 00 00 
  803119:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803125:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312c:	00 00 00 
  80312f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803132:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313c:	48 89 c6             	mov    %rax,%rsi
  80313f:	bf 01 00 00 00       	mov    $0x1,%edi
  803144:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
  803150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803157:	79 2b                	jns    803184 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315d:	be 00 00 00 00       	mov    $0x0,%esi
  803162:	48 89 c7             	mov    %rax,%rdi
  803165:	48 b8 2d 28 80 00 00 	movabs $0x80282d,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
  803171:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803174:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803178:	79 05                	jns    80317f <open+0x10d>
			{
				return d;
  80317a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317d:	eb 18                	jmp    803197 <open+0x125>
			}
			return r;
  80317f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803182:	eb 13                	jmp    803197 <open+0x125>
		}	
		return fd2num(fd_store);
  803184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803188:	48 89 c7             	mov    %rax,%rdi
  80318b:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803197:	c9                   	leaveq 
  803198:	c3                   	retq   

0000000000803199 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803199:	55                   	push   %rbp
  80319a:	48 89 e5             	mov    %rsp,%rbp
  80319d:	48 83 ec 10          	sub    $0x10,%rsp
  8031a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8031ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b3:	00 00 00 
  8031b6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031b8:	be 00 00 00 00       	mov    $0x0,%esi
  8031bd:	bf 06 00 00 00       	mov    $0x6,%edi
  8031c2:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
}
  8031ce:	c9                   	leaveq 
  8031cf:	c3                   	retq   

00000000008031d0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031d0:	55                   	push   %rbp
  8031d1:	48 89 e5             	mov    %rsp,%rbp
  8031d4:	48 83 ec 30          	sub    $0x30,%rsp
  8031d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8031e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8031eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031f0:	74 07                	je     8031f9 <devfile_read+0x29>
  8031f2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031f7:	75 07                	jne    803200 <devfile_read+0x30>
		return -E_INVAL;
  8031f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031fe:	eb 77                	jmp    803277 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803204:	8b 50 0c             	mov    0xc(%rax),%edx
  803207:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320e:	00 00 00 
  803211:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803213:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321a:	00 00 00 
  80321d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803221:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803225:	be 00 00 00 00       	mov    $0x0,%esi
  80322a:	bf 03 00 00 00       	mov    $0x3,%edi
  80322f:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803242:	7f 05                	jg     803249 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803247:	eb 2e                	jmp    803277 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324c:	48 63 d0             	movslq %eax,%rdx
  80324f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803253:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80325a:	00 00 00 
  80325d:	48 89 c7             	mov    %rax,%rdi
  803260:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80326c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803270:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803274:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803277:	c9                   	leaveq 
  803278:	c3                   	retq   

0000000000803279 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	48 83 ec 30          	sub    $0x30,%rsp
  803281:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803285:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803289:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80328d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803294:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803299:	74 07                	je     8032a2 <devfile_write+0x29>
  80329b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032a0:	75 08                	jne    8032aa <devfile_write+0x31>
		return r;
  8032a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a5:	e9 9a 00 00 00       	jmpq   803344 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8032aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ae:	8b 50 0c             	mov    0xc(%rax),%edx
  8032b1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032b8:	00 00 00 
  8032bb:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8032bd:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032c4:	00 
  8032c5:	76 08                	jbe    8032cf <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8032c7:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032ce:	00 
	}
	fsipcbuf.write.req_n = n;
  8032cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032d6:	00 00 00 
  8032d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032dd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8032e1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8032f3:	00 00 00 
  8032f6:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803302:	be 00 00 00 00       	mov    $0x0,%esi
  803307:	bf 04 00 00 00       	mov    $0x4,%edi
  80330c:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331f:	7f 20                	jg     803341 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803321:	48 bf 46 4a 80 00 00 	movabs $0x804a46,%rdi
  803328:	00 00 00 
  80332b:	b8 00 00 00 00       	mov    $0x0,%eax
  803330:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803337:	00 00 00 
  80333a:	ff d2                	callq  *%rdx
		return r;
  80333c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333f:	eb 03                	jmp    803344 <devfile_write+0xcb>
	}
	return r;
  803341:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803344:	c9                   	leaveq 
  803345:	c3                   	retq   

0000000000803346 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803346:	55                   	push   %rbp
  803347:	48 89 e5             	mov    %rsp,%rbp
  80334a:	48 83 ec 20          	sub    $0x20,%rsp
  80334e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335a:	8b 50 0c             	mov    0xc(%rax),%edx
  80335d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803364:	00 00 00 
  803367:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803369:	be 00 00 00 00       	mov    $0x0,%esi
  80336e:	bf 05 00 00 00       	mov    $0x5,%edi
  803373:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  80337a:	00 00 00 
  80337d:	ff d0                	callq  *%rax
  80337f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803386:	79 05                	jns    80338d <devfile_stat+0x47>
		return r;
  803388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338b:	eb 56                	jmp    8033e3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80338d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803391:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803398:	00 00 00 
  80339b:	48 89 c7             	mov    %rax,%rdi
  80339e:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033aa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033b1:	00 00 00 
  8033b4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033be:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033cb:	00 00 00 
  8033ce:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f8:	8b 50 0c             	mov    0xc(%rax),%edx
  8033fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803402:	00 00 00 
  803405:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803407:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80340e:	00 00 00 
  803411:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803414:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803417:	be 00 00 00 00       	mov    $0x0,%esi
  80341c:	bf 02 00 00 00       	mov    $0x2,%edi
  803421:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
}
  80342d:	c9                   	leaveq 
  80342e:	c3                   	retq   

000000000080342f <remove>:

// Delete a file
int
remove(const char *path)
{
  80342f:	55                   	push   %rbp
  803430:	48 89 e5             	mov    %rsp,%rbp
  803433:	48 83 ec 10          	sub    $0x10,%rsp
  803437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80343b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343f:	48 89 c7             	mov    %rax,%rdi
  803442:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  803449:	00 00 00 
  80344c:	ff d0                	callq  *%rax
  80344e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803453:	7e 07                	jle    80345c <remove+0x2d>
		return -E_BAD_PATH;
  803455:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80345a:	eb 33                	jmp    80348f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80345c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803460:	48 89 c6             	mov    %rax,%rsi
  803463:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80346a:	00 00 00 
  80346d:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803479:	be 00 00 00 00       	mov    $0x0,%esi
  80347e:	bf 07 00 00 00       	mov    $0x7,%edi
  803483:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
}
  80348f:	c9                   	leaveq 
  803490:	c3                   	retq   

0000000000803491 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803495:	be 00 00 00 00       	mov    $0x0,%esi
  80349a:	bf 08 00 00 00       	mov    $0x8,%edi
  80349f:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  8034a6:	00 00 00 
  8034a9:	ff d0                	callq  *%rax
}
  8034ab:	5d                   	pop    %rbp
  8034ac:	c3                   	retq   

00000000008034ad <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034ad:	55                   	push   %rbp
  8034ae:	48 89 e5             	mov    %rsp,%rbp
  8034b1:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034b8:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034bf:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034c6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034cd:	be 00 00 00 00       	mov    $0x0,%esi
  8034d2:	48 89 c7             	mov    %rax,%rdi
  8034d5:	48 b8 72 30 80 00 00 	movabs $0x803072,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
  8034e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8034e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e8:	79 28                	jns    803512 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8034ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ed:	89 c6                	mov    %eax,%esi
  8034ef:	48 bf 62 4a 80 00 00 	movabs $0x804a62,%rdi
  8034f6:	00 00 00 
  8034f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fe:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803505:	00 00 00 
  803508:	ff d2                	callq  *%rdx
		return fd_src;
  80350a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350d:	e9 74 01 00 00       	jmpq   803686 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803512:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803519:	be 01 01 00 00       	mov    $0x101,%esi
  80351e:	48 89 c7             	mov    %rax,%rdi
  803521:	48 b8 72 30 80 00 00 	movabs $0x803072,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803530:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803534:	79 39                	jns    80356f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803536:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803539:	89 c6                	mov    %eax,%esi
  80353b:	48 bf 78 4a 80 00 00 	movabs $0x804a78,%rdi
  803542:	00 00 00 
  803545:	b8 00 00 00 00       	mov    $0x0,%eax
  80354a:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803551:	00 00 00 
  803554:	ff d2                	callq  *%rdx
		close(fd_src);
  803556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803559:	89 c7                	mov    %eax,%edi
  80355b:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
		return fd_dest;
  803567:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80356a:	e9 17 01 00 00       	jmpq   803686 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80356f:	eb 74                	jmp    8035e5 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803571:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803574:	48 63 d0             	movslq %eax,%rdx
  803577:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80357e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803581:	48 89 ce             	mov    %rcx,%rsi
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 19 2d 80 00 00 	movabs $0x802d19,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803595:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803599:	79 4a                	jns    8035e5 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80359b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80359e:	89 c6                	mov    %eax,%esi
  8035a0:	48 bf 92 4a 80 00 00 	movabs $0x804a92,%rdi
  8035a7:	00 00 00 
  8035aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8035af:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8035b6:	00 00 00 
  8035b9:	ff d2                	callq  *%rdx
			close(fd_src);
  8035bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035be:	89 c7                	mov    %eax,%edi
  8035c0:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	callq  *%rax
			close(fd_dest);
  8035cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cf:	89 c7                	mov    %eax,%edi
  8035d1:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
			return write_size;
  8035dd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035e0:	e9 a1 00 00 00       	jmpq   803686 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035e5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ef:	ba 00 02 00 00       	mov    $0x200,%edx
  8035f4:	48 89 ce             	mov    %rcx,%rsi
  8035f7:	89 c7                	mov    %eax,%edi
  8035f9:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
  803605:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80360c:	0f 8f 5f ff ff ff    	jg     803571 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803612:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803616:	79 47                	jns    80365f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803618:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80361b:	89 c6                	mov    %eax,%esi
  80361d:	48 bf a5 4a 80 00 00 	movabs $0x804aa5,%rdi
  803624:	00 00 00 
  803627:	b8 00 00 00 00       	mov    $0x0,%eax
  80362c:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803633:	00 00 00 
  803636:	ff d2                	callq  *%rdx
		close(fd_src);
  803638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363b:	89 c7                	mov    %eax,%edi
  80363d:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
		close(fd_dest);
  803649:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80364c:	89 c7                	mov    %eax,%edi
  80364e:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
		return read_size;
  80365a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80365d:	eb 27                	jmp    803686 <copy+0x1d9>
	}
	close(fd_src);
  80365f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803662:	89 c7                	mov    %eax,%edi
  803664:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
	close(fd_dest);
  803670:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803673:	89 c7                	mov    %eax,%edi
  803675:	48 b8 ad 29 80 00 00 	movabs $0x8029ad,%rax
  80367c:	00 00 00 
  80367f:	ff d0                	callq  *%rax
	return 0;
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803686:	c9                   	leaveq 
  803687:	c3                   	retq   

0000000000803688 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803688:	55                   	push   %rbp
  803689:	48 89 e5             	mov    %rsp,%rbp
  80368c:	53                   	push   %rbx
  80368d:	48 83 ec 38          	sub    $0x38,%rsp
  803691:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803695:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803699:	48 89 c7             	mov    %rax,%rdi
  80369c:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036af:	0f 88 bf 01 00 00    	js     803874 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036be:	48 89 c6             	mov    %rax,%rsi
  8036c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c6:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8036cd:	00 00 00 
  8036d0:	ff d0                	callq  *%rax
  8036d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d9:	0f 88 95 01 00 00    	js     803874 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036df:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036e3:	48 89 c7             	mov    %rax,%rdi
  8036e6:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  8036ed:	00 00 00 
  8036f0:	ff d0                	callq  *%rax
  8036f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f9:	0f 88 5d 01 00 00    	js     80385c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803703:	ba 07 04 00 00       	mov    $0x407,%edx
  803708:	48 89 c6             	mov    %rax,%rsi
  80370b:	bf 00 00 00 00       	mov    $0x0,%edi
  803710:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803717:	00 00 00 
  80371a:	ff d0                	callq  *%rax
  80371c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80371f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803723:	0f 88 33 01 00 00    	js     80385c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372d:	48 89 c7             	mov    %rax,%rdi
  803730:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
  80373c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803744:	ba 07 04 00 00       	mov    $0x407,%edx
  803749:	48 89 c6             	mov    %rax,%rsi
  80374c:	bf 00 00 00 00       	mov    $0x0,%edi
  803751:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
  80375d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803760:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803764:	79 05                	jns    80376b <pipe+0xe3>
		goto err2;
  803766:	e9 d9 00 00 00       	jmpq   803844 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376f:	48 89 c7             	mov    %rax,%rdi
  803772:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
  80377e:	48 89 c2             	mov    %rax,%rdx
  803781:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803785:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80378b:	48 89 d1             	mov    %rdx,%rcx
  80378e:	ba 00 00 00 00       	mov    $0x0,%edx
  803793:	48 89 c6             	mov    %rax,%rsi
  803796:	bf 00 00 00 00       	mov    $0x0,%edi
  80379b:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8037a2:	00 00 00 
  8037a5:	ff d0                	callq  *%rax
  8037a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ae:	79 1b                	jns    8037cb <pipe+0x143>
		goto err3;
  8037b0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b5:	48 89 c6             	mov    %rax,%rsi
  8037b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037bd:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
  8037c9:	eb 79                	jmp    803844 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037cf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037d6:	00 00 00 
  8037d9:	8b 12                	mov    (%rdx),%edx
  8037db:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ec:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037f3:	00 00 00 
  8037f6:	8b 12                	mov    (%rdx),%edx
  8037f8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037fe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803805:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
  803818:	89 c2                	mov    %eax,%edx
  80381a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80381e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803820:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803824:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803828:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382c:	48 89 c7             	mov    %rax,%rdi
  80382f:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80383d:	b8 00 00 00 00       	mov    $0x0,%eax
  803842:	eb 33                	jmp    803877 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803844:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803848:	48 89 c6             	mov    %rax,%rsi
  80384b:	bf 00 00 00 00       	mov    $0x0,%edi
  803850:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80385c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803860:	48 89 c6             	mov    %rax,%rsi
  803863:	bf 00 00 00 00       	mov    $0x0,%edi
  803868:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
err:
	return r;
  803874:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803877:	48 83 c4 38          	add    $0x38,%rsp
  80387b:	5b                   	pop    %rbx
  80387c:	5d                   	pop    %rbp
  80387d:	c3                   	retq   

000000000080387e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80387e:	55                   	push   %rbp
  80387f:	48 89 e5             	mov    %rsp,%rbp
  803882:	53                   	push   %rbx
  803883:	48 83 ec 28          	sub    $0x28,%rsp
  803887:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80388b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80388f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803896:	00 00 00 
  803899:	48 8b 00             	mov    (%rax),%rax
  80389c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a9:	48 89 c7             	mov    %rax,%rdi
  8038ac:	48 b8 3c 42 80 00 00 	movabs $0x80423c,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
  8038b8:	89 c3                	mov    %eax,%ebx
  8038ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038be:	48 89 c7             	mov    %rax,%rdi
  8038c1:	48 b8 3c 42 80 00 00 	movabs $0x80423c,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
  8038cd:	39 c3                	cmp    %eax,%ebx
  8038cf:	0f 94 c0             	sete   %al
  8038d2:	0f b6 c0             	movzbl %al,%eax
  8038d5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038d8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038df:	00 00 00 
  8038e2:	48 8b 00             	mov    (%rax),%rax
  8038e5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038eb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038f4:	75 05                	jne    8038fb <_pipeisclosed+0x7d>
			return ret;
  8038f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038f9:	eb 4f                	jmp    80394a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803901:	74 42                	je     803945 <_pipeisclosed+0xc7>
  803903:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803907:	75 3c                	jne    803945 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803909:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803910:	00 00 00 
  803913:	48 8b 00             	mov    (%rax),%rax
  803916:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80391c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80391f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803922:	89 c6                	mov    %eax,%esi
  803924:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  80392b:	00 00 00 
  80392e:	b8 00 00 00 00       	mov    $0x0,%eax
  803933:	49 b8 f3 06 80 00 00 	movabs $0x8006f3,%r8
  80393a:	00 00 00 
  80393d:	41 ff d0             	callq  *%r8
	}
  803940:	e9 4a ff ff ff       	jmpq   80388f <_pipeisclosed+0x11>
  803945:	e9 45 ff ff ff       	jmpq   80388f <_pipeisclosed+0x11>
}
  80394a:	48 83 c4 28          	add    $0x28,%rsp
  80394e:	5b                   	pop    %rbx
  80394f:	5d                   	pop    %rbp
  803950:	c3                   	retq   

0000000000803951 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803951:	55                   	push   %rbp
  803952:	48 89 e5             	mov    %rsp,%rbp
  803955:	48 83 ec 30          	sub    $0x30,%rsp
  803959:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80395c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803960:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803963:	48 89 d6             	mov    %rdx,%rsi
  803966:	89 c7                	mov    %eax,%edi
  803968:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
  803974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397b:	79 05                	jns    803982 <pipeisclosed+0x31>
		return r;
  80397d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803980:	eb 31                	jmp    8039b3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803986:	48 89 c7             	mov    %rax,%rdi
  803989:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803990:	00 00 00 
  803993:	ff d0                	callq  *%rax
  803995:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a1:	48 89 d6             	mov    %rdx,%rsi
  8039a4:	48 89 c7             	mov    %rax,%rdi
  8039a7:	48 b8 7e 38 80 00 00 	movabs $0x80387e,%rax
  8039ae:	00 00 00 
  8039b1:	ff d0                	callq  *%rax
}
  8039b3:	c9                   	leaveq 
  8039b4:	c3                   	retq   

00000000008039b5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039b5:	55                   	push   %rbp
  8039b6:	48 89 e5             	mov    %rsp,%rbp
  8039b9:	48 83 ec 40          	sub    $0x40,%rsp
  8039bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039cd:	48 89 c7             	mov    %rax,%rdi
  8039d0:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  8039d7:	00 00 00 
  8039da:	ff d0                	callq  *%rax
  8039dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039ef:	00 
  8039f0:	e9 92 00 00 00       	jmpq   803a87 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039f5:	eb 41                	jmp    803a38 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039f7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039fc:	74 09                	je     803a07 <devpipe_read+0x52>
				return i;
  8039fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a02:	e9 92 00 00 00       	jmpq   803a99 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0f:	48 89 d6             	mov    %rdx,%rsi
  803a12:	48 89 c7             	mov    %rax,%rdi
  803a15:	48 b8 7e 38 80 00 00 	movabs $0x80387e,%rax
  803a1c:	00 00 00 
  803a1f:	ff d0                	callq  *%rax
  803a21:	85 c0                	test   %eax,%eax
  803a23:	74 07                	je     803a2c <devpipe_read+0x77>
				return 0;
  803a25:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2a:	eb 6d                	jmp    803a99 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a2c:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3c:	8b 10                	mov    (%rax),%edx
  803a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a42:	8b 40 04             	mov    0x4(%rax),%eax
  803a45:	39 c2                	cmp    %eax,%edx
  803a47:	74 ae                	je     8039f7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a51:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a59:	8b 00                	mov    (%rax),%eax
  803a5b:	99                   	cltd   
  803a5c:	c1 ea 1b             	shr    $0x1b,%edx
  803a5f:	01 d0                	add    %edx,%eax
  803a61:	83 e0 1f             	and    $0x1f,%eax
  803a64:	29 d0                	sub    %edx,%eax
  803a66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6a:	48 98                	cltq   
  803a6c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a71:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	8b 00                	mov    (%rax),%eax
  803a79:	8d 50 01             	lea    0x1(%rax),%edx
  803a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a80:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a82:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a8f:	0f 82 60 ff ff ff    	jb     8039f5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a99:	c9                   	leaveq 
  803a9a:	c3                   	retq   

0000000000803a9b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a9b:	55                   	push   %rbp
  803a9c:	48 89 e5             	mov    %rsp,%rbp
  803a9f:	48 83 ec 40          	sub    $0x40,%rsp
  803aa3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aa7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aab:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803aaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ac6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ace:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ad5:	00 
  803ad6:	e9 8e 00 00 00       	jmpq   803b69 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803adb:	eb 31                	jmp    803b0e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803add:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae5:	48 89 d6             	mov    %rdx,%rsi
  803ae8:	48 89 c7             	mov    %rax,%rdi
  803aeb:	48 b8 7e 38 80 00 00 	movabs $0x80387e,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	85 c0                	test   %eax,%eax
  803af9:	74 07                	je     803b02 <devpipe_write+0x67>
				return 0;
  803afb:	b8 00 00 00 00       	mov    $0x0,%eax
  803b00:	eb 79                	jmp    803b7b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b02:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b12:	8b 40 04             	mov    0x4(%rax),%eax
  803b15:	48 63 d0             	movslq %eax,%rdx
  803b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1c:	8b 00                	mov    (%rax),%eax
  803b1e:	48 98                	cltq   
  803b20:	48 83 c0 20          	add    $0x20,%rax
  803b24:	48 39 c2             	cmp    %rax,%rdx
  803b27:	73 b4                	jae    803add <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2d:	8b 40 04             	mov    0x4(%rax),%eax
  803b30:	99                   	cltd   
  803b31:	c1 ea 1b             	shr    $0x1b,%edx
  803b34:	01 d0                	add    %edx,%eax
  803b36:	83 e0 1f             	and    $0x1f,%eax
  803b39:	29 d0                	sub    %edx,%eax
  803b3b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b3f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b43:	48 01 ca             	add    %rcx,%rdx
  803b46:	0f b6 0a             	movzbl (%rdx),%ecx
  803b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b4d:	48 98                	cltq   
  803b4f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b57:	8b 40 04             	mov    0x4(%rax),%eax
  803b5a:	8d 50 01             	lea    0x1(%rax),%edx
  803b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b61:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b64:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b71:	0f 82 64 ff ff ff    	jb     803adb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b7b:	c9                   	leaveq 
  803b7c:	c3                   	retq   

0000000000803b7d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b7d:	55                   	push   %rbp
  803b7e:	48 89 e5             	mov    %rsp,%rbp
  803b81:	48 83 ec 20          	sub    $0x20,%rsp
  803b85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
  803ba0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ba4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba8:	48 be d8 4a 80 00 00 	movabs $0x804ad8,%rsi
  803baf:	00 00 00 
  803bb2:	48 89 c7             	mov    %rax,%rdi
  803bb5:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc5:	8b 50 04             	mov    0x4(%rax),%edx
  803bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bcc:	8b 00                	mov    (%rax),%eax
  803bce:	29 c2                	sub    %eax,%edx
  803bd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bde:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803be5:	00 00 00 
	stat->st_dev = &devpipe;
  803be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bec:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bf3:	00 00 00 
  803bf6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c02:	c9                   	leaveq 
  803c03:	c3                   	retq   

0000000000803c04 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 10          	sub    $0x10,%rsp
  803c0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c14:	48 89 c6             	mov    %rax,%rsi
  803c17:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1c:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2c:	48 89 c7             	mov    %rax,%rdi
  803c2f:	48 b8 da 26 80 00 00 	movabs $0x8026da,%rax
  803c36:	00 00 00 
  803c39:	ff d0                	callq  *%rax
  803c3b:	48 89 c6             	mov    %rax,%rsi
  803c3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c43:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803c4a:	00 00 00 
  803c4d:	ff d0                	callq  *%rax
}
  803c4f:	c9                   	leaveq 
  803c50:	c3                   	retq   

0000000000803c51 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c51:	55                   	push   %rbp
  803c52:	48 89 e5             	mov    %rsp,%rbp
  803c55:	48 83 ec 20          	sub    $0x20,%rsp
  803c59:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c5f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c62:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c66:	be 01 00 00 00       	mov    $0x1,%esi
  803c6b:	48 89 c7             	mov    %rax,%rdi
  803c6e:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
}
  803c7a:	c9                   	leaveq 
  803c7b:	c3                   	retq   

0000000000803c7c <getchar>:

int
getchar(void)
{
  803c7c:	55                   	push   %rbp
  803c7d:	48 89 e5             	mov    %rsp,%rbp
  803c80:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c84:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c88:	ba 01 00 00 00       	mov    $0x1,%edx
  803c8d:	48 89 c6             	mov    %rax,%rsi
  803c90:	bf 00 00 00 00       	mov    $0x0,%edi
  803c95:	48 b8 cf 2b 80 00 00 	movabs $0x802bcf,%rax
  803c9c:	00 00 00 
  803c9f:	ff d0                	callq  *%rax
  803ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca8:	79 05                	jns    803caf <getchar+0x33>
		return r;
  803caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cad:	eb 14                	jmp    803cc3 <getchar+0x47>
	if (r < 1)
  803caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb3:	7f 07                	jg     803cbc <getchar+0x40>
		return -E_EOF;
  803cb5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cba:	eb 07                	jmp    803cc3 <getchar+0x47>
	return c;
  803cbc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cc0:	0f b6 c0             	movzbl %al,%eax
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 20          	sub    $0x20,%rsp
  803ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd7:	48 89 d6             	mov    %rdx,%rsi
  803cda:	89 c7                	mov    %eax,%edi
  803cdc:	48 b8 9d 27 80 00 00 	movabs $0x80279d,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
  803ce8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cef:	79 05                	jns    803cf6 <iscons+0x31>
		return r;
  803cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf4:	eb 1a                	jmp    803d10 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfa:	8b 10                	mov    (%rax),%edx
  803cfc:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d03:	00 00 00 
  803d06:	8b 00                	mov    (%rax),%eax
  803d08:	39 c2                	cmp    %eax,%edx
  803d0a:	0f 94 c0             	sete   %al
  803d0d:	0f b6 c0             	movzbl %al,%eax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <opencons>:

int
opencons(void)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
  803d16:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d1a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d1e:	48 89 c7             	mov    %rax,%rdi
  803d21:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
  803d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d34:	79 05                	jns    803d3b <opencons+0x29>
		return r;
  803d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d39:	eb 5b                	jmp    803d96 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3f:	ba 07 04 00 00       	mov    $0x407,%edx
  803d44:	48 89 c6             	mov    %rax,%rsi
  803d47:	bf 00 00 00 00       	mov    $0x0,%edi
  803d4c:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803d53:	00 00 00 
  803d56:	ff d0                	callq  *%rax
  803d58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5f:	79 05                	jns    803d66 <opencons+0x54>
		return r;
  803d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d64:	eb 30                	jmp    803d96 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6a:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d71:	00 00 00 
  803d74:	8b 12                	mov    (%rdx),%edx
  803d76:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d87:	48 89 c7             	mov    %rax,%rdi
  803d8a:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803d91:	00 00 00 
  803d94:	ff d0                	callq  *%rax
}
  803d96:	c9                   	leaveq 
  803d97:	c3                   	retq   

0000000000803d98 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d98:	55                   	push   %rbp
  803d99:	48 89 e5             	mov    %rsp,%rbp
  803d9c:	48 83 ec 30          	sub    $0x30,%rsp
  803da0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803da4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803dac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803db1:	75 07                	jne    803dba <devcons_read+0x22>
		return 0;
  803db3:	b8 00 00 00 00       	mov    $0x0,%eax
  803db8:	eb 4b                	jmp    803e05 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803dba:	eb 0c                	jmp    803dc8 <devcons_read+0x30>
		sys_yield();
  803dbc:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dc8:	48 b8 d9 1a 80 00 00 	movabs $0x801ad9,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
  803dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ddb:	74 df                	je     803dbc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de1:	79 05                	jns    803de8 <devcons_read+0x50>
		return c;
  803de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de6:	eb 1d                	jmp    803e05 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803de8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803dec:	75 07                	jne    803df5 <devcons_read+0x5d>
		return 0;
  803dee:	b8 00 00 00 00       	mov    $0x0,%eax
  803df3:	eb 10                	jmp    803e05 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df8:	89 c2                	mov    %eax,%edx
  803dfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dfe:	88 10                	mov    %dl,(%rax)
	return 1;
  803e00:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e05:	c9                   	leaveq 
  803e06:	c3                   	retq   

0000000000803e07 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e07:	55                   	push   %rbp
  803e08:	48 89 e5             	mov    %rsp,%rbp
  803e0b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e12:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e19:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e20:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e2e:	eb 76                	jmp    803ea6 <devcons_write+0x9f>
		m = n - tot;
  803e30:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e37:	89 c2                	mov    %eax,%edx
  803e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3c:	29 c2                	sub    %eax,%edx
  803e3e:	89 d0                	mov    %edx,%eax
  803e40:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e46:	83 f8 7f             	cmp    $0x7f,%eax
  803e49:	76 07                	jbe    803e52 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e4b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e55:	48 63 d0             	movslq %eax,%rdx
  803e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5b:	48 63 c8             	movslq %eax,%rcx
  803e5e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e65:	48 01 c1             	add    %rax,%rcx
  803e68:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e6f:	48 89 ce             	mov    %rcx,%rsi
  803e72:	48 89 c7             	mov    %rax,%rdi
  803e75:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e81:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e84:	48 63 d0             	movslq %eax,%rdx
  803e87:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e8e:	48 89 d6             	mov    %rdx,%rsi
  803e91:	48 89 c7             	mov    %rax,%rdi
  803e94:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  803e9b:	00 00 00 
  803e9e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ea0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea3:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea9:	48 98                	cltq   
  803eab:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803eb2:	0f 82 78 ff ff ff    	jb     803e30 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ebb:	c9                   	leaveq 
  803ebc:	c3                   	retq   

0000000000803ebd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ebd:	55                   	push   %rbp
  803ebe:	48 89 e5             	mov    %rsp,%rbp
  803ec1:	48 83 ec 08          	sub    $0x8,%rsp
  803ec5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ec9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ece:	c9                   	leaveq 
  803ecf:	c3                   	retq   

0000000000803ed0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ed0:	55                   	push   %rbp
  803ed1:	48 89 e5             	mov    %rsp,%rbp
  803ed4:	48 83 ec 10          	sub    $0x10,%rsp
  803ed8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803edc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee4:	48 be e4 4a 80 00 00 	movabs $0x804ae4,%rsi
  803eeb:	00 00 00 
  803eee:	48 89 c7             	mov    %rax,%rdi
  803ef1:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803ef8:	00 00 00 
  803efb:	ff d0                	callq  *%rax
	return 0;
  803efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f02:	c9                   	leaveq 
  803f03:	c3                   	retq   

0000000000803f04 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803f04:	55                   	push   %rbp
  803f05:	48 89 e5             	mov    %rsp,%rbp
  803f08:	48 83 ec 10          	sub    $0x10,%rsp
  803f0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803f10:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f17:	00 00 00 
  803f1a:	48 8b 00             	mov    (%rax),%rax
  803f1d:	48 85 c0             	test   %rax,%rax
  803f20:	0f 85 84 00 00 00    	jne    803faa <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803f26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f2d:	00 00 00 
  803f30:	48 8b 00             	mov    (%rax),%rax
  803f33:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f39:	ba 07 00 00 00       	mov    $0x7,%edx
  803f3e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803f43:	89 c7                	mov    %eax,%edi
  803f45:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
  803f51:	85 c0                	test   %eax,%eax
  803f53:	79 2a                	jns    803f7f <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803f55:	48 ba f0 4a 80 00 00 	movabs $0x804af0,%rdx
  803f5c:	00 00 00 
  803f5f:	be 23 00 00 00       	mov    $0x23,%esi
  803f64:	48 bf 17 4b 80 00 00 	movabs $0x804b17,%rdi
  803f6b:	00 00 00 
  803f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f73:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  803f7a:	00 00 00 
  803f7d:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803f7f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f86:	00 00 00 
  803f89:	48 8b 00             	mov    (%rax),%rax
  803f8c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f92:	48 be bd 3f 80 00 00 	movabs $0x803fbd,%rsi
  803f99:	00 00 00 
  803f9c:	89 c7                	mov    %eax,%edi
  803f9e:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  803fa5:	00 00 00 
  803fa8:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803faa:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803fb1:	00 00 00 
  803fb4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fb8:	48 89 10             	mov    %rdx,(%rax)
}
  803fbb:	c9                   	leaveq 
  803fbc:	c3                   	retq   

0000000000803fbd <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803fbd:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803fc0:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803fc7:	00 00 00 
call *%rax
  803fca:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803fcc:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803fd3:	00 
movq 152(%rsp), %rcx  //Load RSP
  803fd4:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803fdb:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803fdc:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803fe0:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803fe3:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803fea:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803feb:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803fef:	4c 8b 3c 24          	mov    (%rsp),%r15
  803ff3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803ff8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803ffd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804002:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804007:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80400c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804011:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804016:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80401b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804020:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804025:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80402a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80402f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804034:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804039:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  80403d:	48 83 c4 08          	add    $0x8,%rsp
popfq
  804041:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  804042:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  804043:	c3                   	retq   

0000000000804044 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804044:	55                   	push   %rbp
  804045:	48 89 e5             	mov    %rsp,%rbp
  804048:	48 83 ec 30          	sub    $0x30,%rsp
  80404c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804050:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804054:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804058:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80405f:	00 00 00 
  804062:	48 8b 00             	mov    (%rax),%rax
  804065:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80406b:	85 c0                	test   %eax,%eax
  80406d:	75 34                	jne    8040a3 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80406f:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
  80407b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804080:	48 98                	cltq   
  804082:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804089:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804090:	00 00 00 
  804093:	48 01 c2             	add    %rax,%rdx
  804096:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80409d:	00 00 00 
  8040a0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8040a3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040a8:	75 0e                	jne    8040b8 <ipc_recv+0x74>
		pg = (void*) UTOP;
  8040aa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040b1:	00 00 00 
  8040b4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8040b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040bc:	48 89 c7             	mov    %rax,%rdi
  8040bf:	48 b8 00 1e 80 00 00 	movabs $0x801e00,%rax
  8040c6:	00 00 00 
  8040c9:	ff d0                	callq  *%rax
  8040cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8040ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d2:	79 19                	jns    8040ed <ipc_recv+0xa9>
		*from_env_store = 0;
  8040d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8040de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040e2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8040e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040eb:	eb 53                	jmp    804140 <ipc_recv+0xfc>
	}
	if(from_env_store)
  8040ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040f2:	74 19                	je     80410d <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  8040f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040fb:	00 00 00 
  8040fe:	48 8b 00             	mov    (%rax),%rax
  804101:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80410d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804112:	74 19                	je     80412d <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804114:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80411b:	00 00 00 
  80411e:	48 8b 00             	mov    (%rax),%rax
  804121:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80412b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80412d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804134:	00 00 00 
  804137:	48 8b 00             	mov    (%rax),%rax
  80413a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804140:	c9                   	leaveq 
  804141:	c3                   	retq   

0000000000804142 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804142:	55                   	push   %rbp
  804143:	48 89 e5             	mov    %rsp,%rbp
  804146:	48 83 ec 30          	sub    $0x30,%rsp
  80414a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80414d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804150:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804154:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804157:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80415c:	75 0e                	jne    80416c <ipc_send+0x2a>
		pg = (void*)UTOP;
  80415e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804165:	00 00 00 
  804168:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80416c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80416f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804172:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804176:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804179:	89 c7                	mov    %eax,%edi
  80417b:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  804182:	00 00 00 
  804185:	ff d0                	callq  *%rax
  804187:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80418a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80418e:	75 0c                	jne    80419c <ipc_send+0x5a>
			sys_yield();
  804190:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  804197:	00 00 00 
  80419a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80419c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8041a0:	74 ca                	je     80416c <ipc_send+0x2a>
	if(result != 0)
  8041a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041a6:	74 20                	je     8041c8 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8041a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ab:	89 c6                	mov    %eax,%esi
  8041ad:	48 bf 25 4b 80 00 00 	movabs $0x804b25,%rdi
  8041b4:	00 00 00 
  8041b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041bc:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8041c3:	00 00 00 
  8041c6:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8041c8:	c9                   	leaveq 
  8041c9:	c3                   	retq   

00000000008041ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041ca:	55                   	push   %rbp
  8041cb:	48 89 e5             	mov    %rsp,%rbp
  8041ce:	48 83 ec 14          	sub    $0x14,%rsp
  8041d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041dc:	eb 4e                	jmp    80422c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8041de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041e5:	00 00 00 
  8041e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041eb:	48 98                	cltq   
  8041ed:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8041f4:	48 01 d0             	add    %rdx,%rax
  8041f7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041fd:	8b 00                	mov    (%rax),%eax
  8041ff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804202:	75 24                	jne    804228 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804204:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80420b:	00 00 00 
  80420e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804211:	48 98                	cltq   
  804213:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80421a:	48 01 d0             	add    %rdx,%rax
  80421d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804223:	8b 40 08             	mov    0x8(%rax),%eax
  804226:	eb 12                	jmp    80423a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804228:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80422c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804233:	7e a9                	jle    8041de <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80423a:	c9                   	leaveq 
  80423b:	c3                   	retq   

000000000080423c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80423c:	55                   	push   %rbp
  80423d:	48 89 e5             	mov    %rsp,%rbp
  804240:	48 83 ec 18          	sub    $0x18,%rsp
  804244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424c:	48 c1 e8 15          	shr    $0x15,%rax
  804250:	48 89 c2             	mov    %rax,%rdx
  804253:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80425a:	01 00 00 
  80425d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804261:	83 e0 01             	and    $0x1,%eax
  804264:	48 85 c0             	test   %rax,%rax
  804267:	75 07                	jne    804270 <pageref+0x34>
		return 0;
  804269:	b8 00 00 00 00       	mov    $0x0,%eax
  80426e:	eb 53                	jmp    8042c3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804274:	48 c1 e8 0c          	shr    $0xc,%rax
  804278:	48 89 c2             	mov    %rax,%rdx
  80427b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804282:	01 00 00 
  804285:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804289:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80428d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804291:	83 e0 01             	and    $0x1,%eax
  804294:	48 85 c0             	test   %rax,%rax
  804297:	75 07                	jne    8042a0 <pageref+0x64>
		return 0;
  804299:	b8 00 00 00 00       	mov    $0x0,%eax
  80429e:	eb 23                	jmp    8042c3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8042a8:	48 89 c2             	mov    %rax,%rdx
  8042ab:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042b2:	00 00 00 
  8042b5:	48 c1 e2 04          	shl    $0x4,%rdx
  8042b9:	48 01 d0             	add    %rdx,%rax
  8042bc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042c0:	0f b7 c0             	movzwl %ax,%eax
}
  8042c3:	c9                   	leaveq 
  8042c4:	c3                   	retq   
