
vmm/guest/obj/user/primespipe:     file format elf64-x86-64


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
  80005f:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
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
  80008b:	48 ba 20 45 80 00 00 	movabs $0x804520,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 61 45 80 00 00 	movabs $0x804561,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 8a 35 80 00 00 	movabs $0x80358a,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 65 45 80 00 00 	movabs $0x804565,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 6e 45 80 00 00 	movabs $0x80456e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
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
  800173:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
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
  8001a0:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
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
  8001c3:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
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
  8001fb:	48 ba 77 45 80 00 00 	movabs $0x804577,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
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
  800246:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
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
  800278:	48 ba 93 45 80 00 00 	movabs $0x804593,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
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
  8002c2:	48 bb ad 45 80 00 00 	movabs $0x8045ad,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 8a 35 80 00 00 	movabs $0x80358a,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 65 45 80 00 00 	movabs $0x804565,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 6e 45 80 00 00 	movabs $0x80456e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
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
  80036c:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
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
  80038e:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
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
  8003b2:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
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
  8003de:	48 ba b8 45 80 00 00 	movabs $0x8045b8,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
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
  80049b:	48 b8 fa 28 80 00 00 	movabs $0x8028fa,%rax
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
  800574:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
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
  8005b0:	48 bf 03 46 80 00 00 	movabs $0x804603,%rdi
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
  80085f:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
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
  800b57:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
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
  800caa:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  800cb1:	00 00 00 
  800cb4:	48 63 d3             	movslq %ebx,%rdx
  800cb7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cbb:	4d 85 e4             	test   %r12,%r12
  800cbe:	75 2e                	jne    800cee <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc8:	89 d9                	mov    %ebx,%ecx
  800cca:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
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
  800cf9:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
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
  800d53:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
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
  801a59:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  801a60:	00 00 00 
  801a63:	be 23 00 00 00       	mov    $0x23,%esi
  801a68:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
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

0000000000801f27 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
  801f2b:	48 83 ec 30          	sub    $0x30,%rsp
  801f2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f37:	48 8b 00             	mov    (%rax),%rax
  801f3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f42:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f46:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801f49:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f4c:	83 e0 02             	and    $0x2,%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	75 4d                	jne    801fa0 <pgfault+0x79>
  801f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f57:	48 c1 e8 0c          	shr    $0xc,%rax
  801f5b:	48 89 c2             	mov    %rax,%rdx
  801f5e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f65:	01 00 00 
  801f68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6c:	25 00 08 00 00       	and    $0x800,%eax
  801f71:	48 85 c0             	test   %rax,%rax
  801f74:	74 2a                	je     801fa0 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801f76:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  801f7d:	00 00 00 
  801f80:	be 23 00 00 00       	mov    $0x23,%esi
  801f85:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  801f8c:	00 00 00 
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  801f9b:	00 00 00 
  801f9e:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801fa0:	ba 07 00 00 00       	mov    $0x7,%edx
  801fa5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801faa:	bf 00 00 00 00       	mov    $0x0,%edi
  801faf:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	0f 85 cd 00 00 00    	jne    802090 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801fc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fd5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801fd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdd:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fe2:	48 89 c6             	mov    %rax,%rsi
  801fe5:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fea:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ffa:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802000:	48 89 c1             	mov    %rax,%rcx
  802003:	ba 00 00 00 00       	mov    $0x0,%edx
  802008:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80200d:	bf 00 00 00 00       	mov    $0x0,%edi
  802012:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802019:	00 00 00 
  80201c:	ff d0                	callq  *%rax
  80201e:	85 c0                	test   %eax,%eax
  802020:	79 2a                	jns    80204c <pgfault+0x125>
				panic("Page map at temp address failed");
  802022:	48 ba 58 4b 80 00 00 	movabs $0x804b58,%rdx
  802029:	00 00 00 
  80202c:	be 30 00 00 00       	mov    $0x30,%esi
  802031:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802038:	00 00 00 
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802047:	00 00 00 
  80204a:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  80204c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802051:	bf 00 00 00 00       	mov    $0x0,%edi
  802056:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
  802062:	85 c0                	test   %eax,%eax
  802064:	79 54                	jns    8020ba <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802066:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  80206d:	00 00 00 
  802070:	be 32 00 00 00       	mov    $0x32,%esi
  802075:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  80207c:	00 00 00 
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80208b:	00 00 00 
  80208e:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802090:	48 ba a0 4b 80 00 00 	movabs $0x804ba0,%rdx
  802097:	00 00 00 
  80209a:	be 34 00 00 00       	mov    $0x34,%esi
  80209f:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8020a6:	00 00 00 
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8020b5:	00 00 00 
  8020b8:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8020ba:	c9                   	leaveq 
  8020bb:	c3                   	retq   

00000000008020bc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020bc:	55                   	push   %rbp
  8020bd:	48 89 e5             	mov    %rsp,%rbp
  8020c0:	48 83 ec 20          	sub    $0x20,%rsp
  8020c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8020ca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d1:	01 00 00 
  8020d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020db:	25 07 0e 00 00       	and    $0xe07,%eax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8020e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020e6:	48 c1 e0 0c          	shl    $0xc,%rax
  8020ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8020ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f1:	25 00 04 00 00       	and    $0x400,%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 57                	je     802151 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020fa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020fd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802101:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802104:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802108:	41 89 f0             	mov    %esi,%r8d
  80210b:	48 89 c6             	mov    %rax,%rsi
  80210e:	bf 00 00 00 00       	mov    $0x0,%edi
  802113:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax
  80211f:	85 c0                	test   %eax,%eax
  802121:	0f 8e 52 01 00 00    	jle    802279 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802127:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  80212e:	00 00 00 
  802131:	be 4e 00 00 00       	mov    $0x4e,%esi
  802136:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  80213d:	00 00 00 
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80214c:	00 00 00 
  80214f:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802154:	83 e0 02             	and    $0x2,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	75 10                	jne    80216b <duppage+0xaf>
  80215b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215e:	25 00 08 00 00       	and    $0x800,%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	0f 84 bb 00 00 00    	je     802226 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80216b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216e:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802173:	80 cc 08             	or     $0x8,%ah
  802176:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802179:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80217c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802180:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802187:	41 89 f0             	mov    %esi,%r8d
  80218a:	48 89 c6             	mov    %rax,%rsi
  80218d:	bf 00 00 00 00       	mov    $0x0,%edi
  802192:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	7e 2a                	jle    8021cc <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8021a2:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  8021a9:	00 00 00 
  8021ac:	be 55 00 00 00       	mov    $0x55,%esi
  8021b1:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8021b8:	00 00 00 
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c0:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8021c7:	00 00 00 
  8021ca:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8021cc:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8021cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d7:	41 89 c8             	mov    %ecx,%r8d
  8021da:	48 89 d1             	mov    %rdx,%rcx
  8021dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e2:	48 89 c6             	mov    %rax,%rsi
  8021e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ea:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	7e 2a                	jle    802224 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8021fa:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  802201:	00 00 00 
  802204:	be 57 00 00 00       	mov    $0x57,%esi
  802209:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802210:	00 00 00 
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  80221f:	00 00 00 
  802222:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802224:	eb 53                	jmp    802279 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802226:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802229:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80222d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802234:	41 89 f0             	mov    %esi,%r8d
  802237:	48 89 c6             	mov    %rax,%rsi
  80223a:	bf 00 00 00 00       	mov    $0x0,%edi
  80223f:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	7e 2a                	jle    802279 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80224f:	48 ba d2 4b 80 00 00 	movabs $0x804bd2,%rdx
  802256:	00 00 00 
  802259:	be 5b 00 00 00       	mov    $0x5b,%esi
  80225e:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  802265:	00 00 00 
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
  80226d:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802274:	00 00 00 
  802277:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227e:	c9                   	leaveq 
  80227f:	c3                   	retq   

0000000000802280 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802280:	55                   	push   %rbp
  802281:	48 89 e5             	mov    %rsp,%rbp
  802284:	48 83 ec 18          	sub    $0x18,%rsp
  802288:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80228c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802290:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802298:	48 c1 e8 27          	shr    $0x27,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022a6:	01 00 00 
  8022a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ad:	83 e0 01             	and    $0x1,%eax
  8022b0:	48 85 c0             	test   %rax,%rax
  8022b3:	74 51                	je     802306 <pt_is_mapped+0x86>
  8022b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8022bd:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022c1:	48 89 c2             	mov    %rax,%rdx
  8022c4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022cb:	01 00 00 
  8022ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d2:	83 e0 01             	and    $0x1,%eax
  8022d5:	48 85 c0             	test   %rax,%rax
  8022d8:	74 2c                	je     802306 <pt_is_mapped+0x86>
  8022da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022de:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e2:	48 c1 e8 15          	shr    $0x15,%rax
  8022e6:	48 89 c2             	mov    %rax,%rdx
  8022e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f0:	01 00 00 
  8022f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f7:	83 e0 01             	and    $0x1,%eax
  8022fa:	48 85 c0             	test   %rax,%rax
  8022fd:	74 07                	je     802306 <pt_is_mapped+0x86>
  8022ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802304:	eb 05                	jmp    80230b <pt_is_mapped+0x8b>
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	83 e0 01             	and    $0x1,%eax
}
  80230e:	c9                   	leaveq 
  80230f:	c3                   	retq   

0000000000802310 <fork>:

envid_t
fork(void)
{
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802318:	48 bf 27 1f 80 00 00 	movabs $0x801f27,%rdi
  80231f:	00 00 00 
  802322:	48 b8 06 3e 80 00 00 	movabs $0x803e06,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80232e:	b8 07 00 00 00       	mov    $0x7,%eax
  802333:	cd 30                	int    $0x30
  802335:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802338:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80233b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802342:	79 30                	jns    802374 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802347:	89 c1                	mov    %eax,%ecx
  802349:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
  802350:	00 00 00 
  802353:	be 86 00 00 00       	mov    $0x86,%esi
  802358:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  80236e:	00 00 00 
  802371:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802378:	75 3e                	jne    8023b8 <fork+0xa8>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80237a:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
  802386:	25 ff 03 00 00       	and    $0x3ff,%eax
  80238b:	48 98                	cltq   
  80238d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802394:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80239b:	00 00 00 
  80239e:	48 01 c2             	add    %rax,%rdx
  8023a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023a8:	00 00 00 
  8023ab:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	e9 d1 01 00 00       	jmpq   802589 <fork+0x279>
	}
	uint64_t ad = 0;
  8023b8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023bf:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8023c0:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c9:	e9 df 00 00 00       	jmpq   8024ad <fork+0x19d>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 c1 e8 27          	shr    $0x27,%rax
  8023d6:	48 89 c2             	mov    %rax,%rdx
  8023d9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023e0:	01 00 00 
  8023e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e7:	83 e0 01             	and    $0x1,%eax
  8023ea:	48 85 c0             	test   %rax,%rax
  8023ed:	0f 84 9e 00 00 00    	je     802491 <fork+0x181>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8023f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023fb:	48 89 c2             	mov    %rax,%rdx
  8023fe:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802405:	01 00 00 
  802408:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240c:	83 e0 01             	and    $0x1,%eax
  80240f:	48 85 c0             	test   %rax,%rax
  802412:	74 73                	je     802487 <fork+0x177>
				if( uvpd[VPD(addr)] & PTE_P){
  802414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802418:	48 c1 e8 15          	shr    $0x15,%rax
  80241c:	48 89 c2             	mov    %rax,%rdx
  80241f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802426:	01 00 00 
  802429:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242d:	83 e0 01             	and    $0x1,%eax
  802430:	48 85 c0             	test   %rax,%rax
  802433:	74 48                	je     80247d <fork+0x16d>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802439:	48 c1 e8 0c          	shr    $0xc,%rax
  80243d:	48 89 c2             	mov    %rax,%rdx
  802440:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802447:	01 00 00 
  80244a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802456:	83 e0 01             	and    $0x1,%eax
  802459:	48 85 c0             	test   %rax,%rax
  80245c:	74 47                	je     8024a5 <fork+0x195>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80245e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802462:	48 c1 e8 0c          	shr    $0xc,%rax
  802466:	89 c2                	mov    %eax,%edx
  802468:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80246b:	89 d6                	mov    %edx,%esi
  80246d:	89 c7                	mov    %eax,%edi
  80246f:	48 b8 bc 20 80 00 00 	movabs $0x8020bc,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
  80247b:	eb 28                	jmp    8024a5 <fork+0x195>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80247d:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802484:	00 
  802485:	eb 1e                	jmp    8024a5 <fork+0x195>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802487:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80248e:	40 
  80248f:	eb 14                	jmp    8024a5 <fork+0x195>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802495:	48 c1 e8 27          	shr    $0x27,%rax
  802499:	48 83 c0 01          	add    $0x1,%rax
  80249d:	48 c1 e0 27          	shl    $0x27,%rax
  8024a1:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8024a5:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8024ac:	00 
  8024ad:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8024b4:	00 
  8024b5:	0f 87 13 ff ff ff    	ja     8023ce <fork+0xbe>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024be:	ba 07 00 00 00       	mov    $0x7,%edx
  8024c3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024c8:	89 c7                	mov    %eax,%edi
  8024ca:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8024d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d9:	ba 07 00 00 00       	mov    $0x7,%edx
  8024de:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024e3:	89 c7                	mov    %eax,%edi
  8024e5:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024f4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024fa:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8024ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802504:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802509:	89 c7                	mov    %eax,%edi
  80250b:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802517:	ba 00 10 00 00       	mov    $0x1000,%edx
  80251c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802521:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802526:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  80252d:	00 00 00 
  802530:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802532:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802537:	bf 00 00 00 00       	mov    $0x0,%edi
  80253c:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802543:	00 00 00 
  802546:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802548:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254f:	00 00 00 
  802552:	48 8b 00             	mov    (%rax),%rax
  802555:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80255c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80255f:	48 89 d6             	mov    %rdx,%rsi
  802562:	89 c7                	mov    %eax,%edi
  802564:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  80256b:	00 00 00 
  80256e:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802570:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802573:	be 02 00 00 00       	mov    $0x2,%esi
  802578:	89 c7                	mov    %eax,%edi
  80257a:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  802581:	00 00 00 
  802584:	ff d0                	callq  *%rax

	return envid;
  802586:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802589:	c9                   	leaveq 
  80258a:	c3                   	retq   

000000000080258b <sfork>:

	
// Challenge!
int
sfork(void)
{
  80258b:	55                   	push   %rbp
  80258c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80258f:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  802596:	00 00 00 
  802599:	be bf 00 00 00       	mov    $0xbf,%esi
  80259e:	48 bf 4d 4b 80 00 00 	movabs $0x804b4d,%rdi
  8025a5:	00 00 00 
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8025b4:	00 00 00 
  8025b7:	ff d1                	callq  *%rcx

00000000008025b9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025b9:	55                   	push   %rbp
  8025ba:	48 89 e5             	mov    %rsp,%rbp
  8025bd:	48 83 ec 08          	sub    $0x8,%rsp
  8025c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025c9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025d0:	ff ff ff 
  8025d3:	48 01 d0             	add    %rdx,%rax
  8025d6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 08          	sub    $0x8,%rsp
  8025e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ec:	48 89 c7             	mov    %rax,%rdi
  8025ef:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8025f6:	00 00 00 
  8025f9:	ff d0                	callq  *%rax
  8025fb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802601:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802605:	c9                   	leaveq 
  802606:	c3                   	retq   

0000000000802607 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802607:	55                   	push   %rbp
  802608:	48 89 e5             	mov    %rsp,%rbp
  80260b:	48 83 ec 18          	sub    $0x18,%rsp
  80260f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802613:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80261a:	eb 6b                	jmp    802687 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80261c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261f:	48 98                	cltq   
  802621:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802627:	48 c1 e0 0c          	shl    $0xc,%rax
  80262b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80262f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802633:	48 c1 e8 15          	shr    $0x15,%rax
  802637:	48 89 c2             	mov    %rax,%rdx
  80263a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802641:	01 00 00 
  802644:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802648:	83 e0 01             	and    $0x1,%eax
  80264b:	48 85 c0             	test   %rax,%rax
  80264e:	74 21                	je     802671 <fd_alloc+0x6a>
  802650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802654:	48 c1 e8 0c          	shr    $0xc,%rax
  802658:	48 89 c2             	mov    %rax,%rdx
  80265b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802662:	01 00 00 
  802665:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802669:	83 e0 01             	and    $0x1,%eax
  80266c:	48 85 c0             	test   %rax,%rax
  80266f:	75 12                	jne    802683 <fd_alloc+0x7c>
			*fd_store = fd;
  802671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802675:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802679:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	eb 1a                	jmp    80269d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802683:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802687:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80268b:	7e 8f                	jle    80261c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80268d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802691:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802698:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 20          	sub    $0x20,%rsp
  8026a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026b2:	78 06                	js     8026ba <fd_lookup+0x1b>
  8026b4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026b8:	7e 07                	jle    8026c1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026bf:	eb 6c                	jmp    80272d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026c4:	48 98                	cltq   
  8026c6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026cc:	48 c1 e0 0c          	shl    $0xc,%rax
  8026d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d8:	48 c1 e8 15          	shr    $0x15,%rax
  8026dc:	48 89 c2             	mov    %rax,%rdx
  8026df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026e6:	01 00 00 
  8026e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ed:	83 e0 01             	and    $0x1,%eax
  8026f0:	48 85 c0             	test   %rax,%rax
  8026f3:	74 21                	je     802716 <fd_lookup+0x77>
  8026f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8026fd:	48 89 c2             	mov    %rax,%rdx
  802700:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802707:	01 00 00 
  80270a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270e:	83 e0 01             	and    $0x1,%eax
  802711:	48 85 c0             	test   %rax,%rax
  802714:	75 07                	jne    80271d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802716:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80271b:	eb 10                	jmp    80272d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80271d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802721:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802725:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272d:	c9                   	leaveq 
  80272e:	c3                   	retq   

000000000080272f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80272f:	55                   	push   %rbp
  802730:	48 89 e5             	mov    %rsp,%rbp
  802733:	48 83 ec 30          	sub    $0x30,%rsp
  802737:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80273b:	89 f0                	mov    %esi,%eax
  80273d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802744:	48 89 c7             	mov    %rax,%rdi
  802747:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
  802753:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802757:	48 89 d6             	mov    %rdx,%rsi
  80275a:	89 c7                	mov    %eax,%edi
  80275c:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802763:	00 00 00 
  802766:	ff d0                	callq  *%rax
  802768:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276f:	78 0a                	js     80277b <fd_close+0x4c>
	    || fd != fd2)
  802771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802775:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802779:	74 12                	je     80278d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80277b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80277f:	74 05                	je     802786 <fd_close+0x57>
  802781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802784:	eb 05                	jmp    80278b <fd_close+0x5c>
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	eb 69                	jmp    8027f6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80278d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802791:	8b 00                	mov    (%rax),%eax
  802793:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802797:	48 89 d6             	mov    %rdx,%rsi
  80279a:	89 c7                	mov    %eax,%edi
  80279c:	48 b8 f8 27 80 00 00 	movabs $0x8027f8,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027af:	78 2a                	js     8027db <fd_close+0xac>
		if (dev->dev_close)
  8027b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027b9:	48 85 c0             	test   %rax,%rax
  8027bc:	74 16                	je     8027d4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ca:	48 89 d7             	mov    %rdx,%rdi
  8027cd:	ff d0                	callq  *%rax
  8027cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d2:	eb 07                	jmp    8027db <fd_close+0xac>
		else
			r = 0;
  8027d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027df:	48 89 c6             	mov    %rax,%rsi
  8027e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e7:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax
	return r;
  8027f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027f6:	c9                   	leaveq 
  8027f7:	c3                   	retq   

00000000008027f8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027f8:	55                   	push   %rbp
  8027f9:	48 89 e5             	mov    %rsp,%rbp
  8027fc:	48 83 ec 20          	sub    $0x20,%rsp
  802800:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802803:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80280e:	eb 41                	jmp    802851 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802810:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802817:	00 00 00 
  80281a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80281d:	48 63 d2             	movslq %edx,%rdx
  802820:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802824:	8b 00                	mov    (%rax),%eax
  802826:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802829:	75 22                	jne    80284d <dev_lookup+0x55>
			*dev = devtab[i];
  80282b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802832:	00 00 00 
  802835:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802838:	48 63 d2             	movslq %edx,%rdx
  80283b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80283f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802843:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
  80284b:	eb 60                	jmp    8028ad <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80284d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802851:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802858:	00 00 00 
  80285b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80285e:	48 63 d2             	movslq %edx,%rdx
  802861:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802865:	48 85 c0             	test   %rax,%rax
  802868:	75 a6                	jne    802810 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80286a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802871:	00 00 00 
  802874:	48 8b 00             	mov    (%rax),%rax
  802877:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80287d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802880:	89 c6                	mov    %eax,%esi
  802882:	48 bf 20 4c 80 00 00 	movabs $0x804c20,%rdi
  802889:	00 00 00 
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802898:	00 00 00 
  80289b:	ff d1                	callq  *%rcx
	*dev = 0;
  80289d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028ad:	c9                   	leaveq 
  8028ae:	c3                   	retq   

00000000008028af <close>:

int
close(int fdnum)
{
  8028af:	55                   	push   %rbp
  8028b0:	48 89 e5             	mov    %rsp,%rbp
  8028b3:	48 83 ec 20          	sub    $0x20,%rsp
  8028b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028c1:	48 89 d6             	mov    %rdx,%rsi
  8028c4:	89 c7                	mov    %eax,%edi
  8028c6:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  8028cd:	00 00 00 
  8028d0:	ff d0                	callq  *%rax
  8028d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d9:	79 05                	jns    8028e0 <close+0x31>
		return r;
  8028db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028de:	eb 18                	jmp    8028f8 <close+0x49>
	else
		return fd_close(fd, 1);
  8028e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e4:	be 01 00 00 00       	mov    $0x1,%esi
  8028e9:	48 89 c7             	mov    %rax,%rdi
  8028ec:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
}
  8028f8:	c9                   	leaveq 
  8028f9:	c3                   	retq   

00000000008028fa <close_all>:

void
close_all(void)
{
  8028fa:	55                   	push   %rbp
  8028fb:	48 89 e5             	mov    %rsp,%rbp
  8028fe:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802902:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802909:	eb 15                	jmp    802920 <close_all+0x26>
		close(i);
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	89 c7                	mov    %eax,%edi
  802910:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  802917:	00 00 00 
  80291a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80291c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802920:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802924:	7e e5                	jle    80290b <close_all+0x11>
		close(i);
}
  802926:	c9                   	leaveq 
  802927:	c3                   	retq   

0000000000802928 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 83 ec 40          	sub    $0x40,%rsp
  802930:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802933:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802936:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80293a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80293d:	48 89 d6             	mov    %rdx,%rsi
  802940:	89 c7                	mov    %eax,%edi
  802942:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
  80294e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802951:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802955:	79 08                	jns    80295f <dup+0x37>
		return r;
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295a:	e9 70 01 00 00       	jmpq   802acf <dup+0x1a7>
	close(newfdnum);
  80295f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802962:	89 c7                	mov    %eax,%edi
  802964:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  80296b:	00 00 00 
  80296e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802970:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802973:	48 98                	cltq   
  802975:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80297b:	48 c1 e0 0c          	shl    $0xc,%rax
  80297f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802983:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802987:	48 89 c7             	mov    %rax,%rdi
  80298a:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax
  802996:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80299a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299e:	48 89 c7             	mov    %rax,%rdi
  8029a1:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b5:	48 c1 e8 15          	shr    $0x15,%rax
  8029b9:	48 89 c2             	mov    %rax,%rdx
  8029bc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029c3:	01 00 00 
  8029c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ca:	83 e0 01             	and    $0x1,%eax
  8029cd:	48 85 c0             	test   %rax,%rax
  8029d0:	74 73                	je     802a45 <dup+0x11d>
  8029d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8029da:	48 89 c2             	mov    %rax,%rdx
  8029dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e4:	01 00 00 
  8029e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029eb:	83 e0 01             	and    $0x1,%eax
  8029ee:	48 85 c0             	test   %rax,%rax
  8029f1:	74 52                	je     802a45 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8029fb:	48 89 c2             	mov    %rax,%rdx
  8029fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a05:	01 00 00 
  802a08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a0c:	25 07 0e 00 00       	and    $0xe07,%eax
  802a11:	89 c1                	mov    %eax,%ecx
  802a13:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1b:	41 89 c8             	mov    %ecx,%r8d
  802a1e:	48 89 d1             	mov    %rdx,%rcx
  802a21:	ba 00 00 00 00       	mov    $0x0,%edx
  802a26:	48 89 c6             	mov    %rax,%rsi
  802a29:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2e:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
  802a3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a41:	79 02                	jns    802a45 <dup+0x11d>
			goto err;
  802a43:	eb 57                	jmp    802a9c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a49:	48 c1 e8 0c          	shr    $0xc,%rax
  802a4d:	48 89 c2             	mov    %rax,%rdx
  802a50:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a57:	01 00 00 
  802a5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5e:	25 07 0e 00 00       	and    $0xe07,%eax
  802a63:	89 c1                	mov    %eax,%ecx
  802a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a6d:	41 89 c8             	mov    %ecx,%r8d
  802a70:	48 89 d1             	mov    %rdx,%rcx
  802a73:	ba 00 00 00 00       	mov    $0x0,%edx
  802a78:	48 89 c6             	mov    %rax,%rsi
  802a7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a80:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
  802a8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a93:	79 02                	jns    802a97 <dup+0x16f>
		goto err;
  802a95:	eb 05                	jmp    802a9c <dup+0x174>

	return newfdnum;
  802a97:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a9a:	eb 33                	jmp    802acf <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa0:	48 89 c6             	mov    %rax,%rsi
  802aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa8:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ab4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab8:	48 89 c6             	mov    %rax,%rsi
  802abb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac0:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
	return r;
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802acf:	c9                   	leaveq 
  802ad0:	c3                   	retq   

0000000000802ad1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	48 83 ec 40          	sub    $0x40,%rsp
  802ad9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802adc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ae0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ae4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aeb:	48 89 d6             	mov    %rdx,%rsi
  802aee:	89 c7                	mov    %eax,%edi
  802af0:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802af7:	00 00 00 
  802afa:	ff d0                	callq  *%rax
  802afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b03:	78 24                	js     802b29 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b09:	8b 00                	mov    (%rax),%eax
  802b0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0f:	48 89 d6             	mov    %rdx,%rsi
  802b12:	89 c7                	mov    %eax,%edi
  802b14:	48 b8 f8 27 80 00 00 	movabs $0x8027f8,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
  802b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b27:	79 05                	jns    802b2e <read+0x5d>
		return r;
  802b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2c:	eb 76                	jmp    802ba4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b32:	8b 40 08             	mov    0x8(%rax),%eax
  802b35:	83 e0 03             	and    $0x3,%eax
  802b38:	83 f8 01             	cmp    $0x1,%eax
  802b3b:	75 3a                	jne    802b77 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b3d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b44:	00 00 00 
  802b47:	48 8b 00             	mov    (%rax),%rax
  802b4a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b50:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b53:	89 c6                	mov    %eax,%esi
  802b55:	48 bf 3f 4c 80 00 00 	movabs $0x804c3f,%rdi
  802b5c:	00 00 00 
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b64:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802b6b:	00 00 00 
  802b6e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b75:	eb 2d                	jmp    802ba4 <read+0xd3>
	}
	if (!dev->dev_read)
  802b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b7f:	48 85 c0             	test   %rax,%rax
  802b82:	75 07                	jne    802b8b <read+0xba>
		return -E_NOT_SUPP;
  802b84:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b89:	eb 19                	jmp    802ba4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b93:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b9b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b9f:	48 89 cf             	mov    %rcx,%rdi
  802ba2:	ff d0                	callq  *%rax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 30          	sub    $0x30,%rsp
  802bae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bc0:	eb 49                	jmp    802c0b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc5:	48 98                	cltq   
  802bc7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bcb:	48 29 c2             	sub    %rax,%rdx
  802bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd1:	48 63 c8             	movslq %eax,%rcx
  802bd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd8:	48 01 c1             	add    %rax,%rcx
  802bdb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bde:	48 89 ce             	mov    %rcx,%rsi
  802be1:	89 c7                	mov    %eax,%edi
  802be3:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
  802bef:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bf2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bf6:	79 05                	jns    802bfd <readn+0x57>
			return m;
  802bf8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfb:	eb 1c                	jmp    802c19 <readn+0x73>
		if (m == 0)
  802bfd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c01:	75 02                	jne    802c05 <readn+0x5f>
			break;
  802c03:	eb 11                	jmp    802c16 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c08:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0e:	48 98                	cltq   
  802c10:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c14:	72 ac                	jb     802bc2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c19:	c9                   	leaveq 
  802c1a:	c3                   	retq   

0000000000802c1b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	48 83 ec 40          	sub    $0x40,%rsp
  802c23:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c26:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c2a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c2e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c32:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c35:	48 89 d6             	mov    %rdx,%rsi
  802c38:	89 c7                	mov    %eax,%edi
  802c3a:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802c41:	00 00 00 
  802c44:	ff d0                	callq  *%rax
  802c46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4d:	78 24                	js     802c73 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c53:	8b 00                	mov    (%rax),%eax
  802c55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c59:	48 89 d6             	mov    %rdx,%rsi
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 f8 27 80 00 00 	movabs $0x8027f8,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c71:	79 05                	jns    802c78 <write+0x5d>
		return r;
  802c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c76:	eb 42                	jmp    802cba <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7c:	8b 40 08             	mov    0x8(%rax),%eax
  802c7f:	83 e0 03             	and    $0x3,%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	75 07                	jne    802c8d <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802c86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c8b:	eb 2d                	jmp    802cba <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c91:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c95:	48 85 c0             	test   %rax,%rax
  802c98:	75 07                	jne    802ca1 <write+0x86>
		return -E_NOT_SUPP;
  802c9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c9f:	eb 19                	jmp    802cba <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  802ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca5:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ca9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cb1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cb5:	48 89 cf             	mov    %rcx,%rdi
  802cb8:	ff d0                	callq  *%rax
}
  802cba:	c9                   	leaveq 
  802cbb:	c3                   	retq   

0000000000802cbc <seek>:

int
seek(int fdnum, off_t offset)
{
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 83 ec 18          	sub    $0x18,%rsp
  802cc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cc7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd1:	48 89 d6             	mov    %rdx,%rsi
  802cd4:	89 c7                	mov    %eax,%edi
  802cd6:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
  802ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce9:	79 05                	jns    802cf0 <seek+0x34>
		return r;
  802ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cee:	eb 0f                	jmp    802cff <seek+0x43>
	fd->fd_offset = offset;
  802cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cf7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cff:	c9                   	leaveq 
  802d00:	c3                   	retq   

0000000000802d01 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d01:	55                   	push   %rbp
  802d02:	48 89 e5             	mov    %rsp,%rbp
  802d05:	48 83 ec 30          	sub    $0x30,%rsp
  802d09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d0c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d16:	48 89 d6             	mov    %rdx,%rsi
  802d19:	89 c7                	mov    %eax,%edi
  802d1b:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802d22:	00 00 00 
  802d25:	ff d0                	callq  *%rax
  802d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2e:	78 24                	js     802d54 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d34:	8b 00                	mov    (%rax),%eax
  802d36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d3a:	48 89 d6             	mov    %rdx,%rsi
  802d3d:	89 c7                	mov    %eax,%edi
  802d3f:	48 b8 f8 27 80 00 00 	movabs $0x8027f8,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	callq  *%rax
  802d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d52:	79 05                	jns    802d59 <ftruncate+0x58>
		return r;
  802d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d57:	eb 72                	jmp    802dcb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5d:	8b 40 08             	mov    0x8(%rax),%eax
  802d60:	83 e0 03             	and    $0x3,%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	75 3a                	jne    802da1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d6e:	00 00 00 
  802d71:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d7d:	89 c6                	mov    %eax,%esi
  802d7f:	48 bf 60 4c 80 00 00 	movabs $0x804c60,%rdi
  802d86:	00 00 00 
  802d89:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8e:	48 b9 f3 06 80 00 00 	movabs $0x8006f3,%rcx
  802d95:	00 00 00 
  802d98:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d9f:	eb 2a                	jmp    802dcb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802da9:	48 85 c0             	test   %rax,%rax
  802dac:	75 07                	jne    802db5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802db3:	eb 16                	jmp    802dcb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dc1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dc4:	89 ce                	mov    %ecx,%esi
  802dc6:	48 89 d7             	mov    %rdx,%rdi
  802dc9:	ff d0                	callq  *%rax
}
  802dcb:	c9                   	leaveq 
  802dcc:	c3                   	retq   

0000000000802dcd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dcd:	55                   	push   %rbp
  802dce:	48 89 e5             	mov    %rsp,%rbp
  802dd1:	48 83 ec 30          	sub    $0x30,%rsp
  802dd5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dd8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ddc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802de0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802de3:	48 89 d6             	mov    %rdx,%rsi
  802de6:	89 c7                	mov    %eax,%edi
  802de8:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax
  802df4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dfb:	78 24                	js     802e21 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e01:	8b 00                	mov    (%rax),%eax
  802e03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e07:	48 89 d6             	mov    %rdx,%rsi
  802e0a:	89 c7                	mov    %eax,%edi
  802e0c:	48 b8 f8 27 80 00 00 	movabs $0x8027f8,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1f:	79 05                	jns    802e26 <fstat+0x59>
		return r;
  802e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e24:	eb 5e                	jmp    802e84 <fstat+0xb7>
	if (!dev->dev_stat)
  802e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e2e:	48 85 c0             	test   %rax,%rax
  802e31:	75 07                	jne    802e3a <fstat+0x6d>
		return -E_NOT_SUPP;
  802e33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e38:	eb 4a                	jmp    802e84 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e3e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e45:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e4c:	00 00 00 
	stat->st_isdir = 0;
  802e4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e5a:	00 00 00 
	stat->st_dev = dev;
  802e5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e65:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e70:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e78:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e7c:	48 89 ce             	mov    %rcx,%rsi
  802e7f:	48 89 d7             	mov    %rdx,%rdi
  802e82:	ff d0                	callq  *%rax
}
  802e84:	c9                   	leaveq 
  802e85:	c3                   	retq   

0000000000802e86 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e86:	55                   	push   %rbp
  802e87:	48 89 e5             	mov    %rsp,%rbp
  802e8a:	48 83 ec 20          	sub    $0x20,%rsp
  802e8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9a:	be 00 00 00 00       	mov    $0x0,%esi
  802e9f:	48 89 c7             	mov    %rax,%rdi
  802ea2:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
  802eae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb5:	79 05                	jns    802ebc <stat+0x36>
		return fd;
  802eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eba:	eb 2f                	jmp    802eeb <stat+0x65>
	r = fstat(fd, stat);
  802ebc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec3:	48 89 d6             	mov    %rdx,%rsi
  802ec6:	89 c7                	mov    %eax,%edi
  802ec8:	48 b8 cd 2d 80 00 00 	movabs $0x802dcd,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
  802ed4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
	return r;
  802ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802eeb:	c9                   	leaveq 
  802eec:	c3                   	retq   

0000000000802eed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802eed:	55                   	push   %rbp
  802eee:	48 89 e5             	mov    %rsp,%rbp
  802ef1:	48 83 ec 10          	sub    $0x10,%rsp
  802ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802efc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f03:	00 00 00 
  802f06:	8b 00                	mov    (%rax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	75 1d                	jne    802f29 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f0c:	bf 01 00 00 00       	mov    $0x1,%edi
  802f11:	48 b8 11 44 80 00 00 	movabs $0x804411,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f24:	00 00 00 
  802f27:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f29:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f30:	00 00 00 
  802f33:	8b 00                	mov    (%rax),%eax
  802f35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f38:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f3d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f44:	00 00 00 
  802f47:	89 c7                	mov    %eax,%edi
  802f49:	48 b8 44 40 80 00 00 	movabs $0x804044,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f59:	ba 00 00 00 00       	mov    $0x0,%edx
  802f5e:	48 89 c6             	mov    %rax,%rsi
  802f61:	bf 00 00 00 00       	mov    $0x0,%edi
  802f66:	48 b8 46 3f 80 00 00 	movabs $0x803f46,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
}
  802f72:	c9                   	leaveq 
  802f73:	c3                   	retq   

0000000000802f74 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f74:	55                   	push   %rbp
  802f75:	48 89 e5             	mov    %rsp,%rbp
  802f78:	48 83 ec 30          	sub    $0x30,%rsp
  802f7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f80:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802f83:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802f8a:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802f91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802f98:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f9d:	75 08                	jne    802fa7 <open+0x33>
	{
		return r;
  802f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa2:	e9 f2 00 00 00       	jmpq   803099 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fab:	48 89 c7             	mov    %rax,%rdi
  802fae:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
  802fba:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fbd:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802fc4:	7e 0a                	jle    802fd0 <open+0x5c>
	{
		return -E_BAD_PATH;
  802fc6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fcb:	e9 c9 00 00 00       	jmpq   803099 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802fd0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802fd7:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802fd8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802fdc:	48 89 c7             	mov    %rax,%rdi
  802fdf:	48 b8 07 26 80 00 00 	movabs $0x802607,%rax
  802fe6:	00 00 00 
  802fe9:	ff d0                	callq  *%rax
  802feb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff2:	78 09                	js     802ffd <open+0x89>
  802ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff8:	48 85 c0             	test   %rax,%rax
  802ffb:	75 08                	jne    803005 <open+0x91>
		{
			return r;
  802ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803000:	e9 94 00 00 00       	jmpq   803099 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803005:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803009:	ba 00 04 00 00       	mov    $0x400,%edx
  80300e:	48 89 c6             	mov    %rax,%rsi
  803011:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803018:	00 00 00 
  80301b:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803027:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302e:	00 00 00 
  803031:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803034:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80303a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303e:	48 89 c6             	mov    %rax,%rsi
  803041:	bf 01 00 00 00       	mov    $0x1,%edi
  803046:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803059:	79 2b                	jns    803086 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80305b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305f:	be 00 00 00 00       	mov    $0x0,%esi
  803064:	48 89 c7             	mov    %rax,%rdi
  803067:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
  803073:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803076:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80307a:	79 05                	jns    803081 <open+0x10d>
			{
				return d;
  80307c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80307f:	eb 18                	jmp    803099 <open+0x125>
			}
			return r;
  803081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803084:	eb 13                	jmp    803099 <open+0x125>
		}	
		return fd2num(fd_store);
  803086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308a:	48 89 c7             	mov    %rax,%rdi
  80308d:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803099:	c9                   	leaveq 
  80309a:	c3                   	retq   

000000000080309b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80309b:	55                   	push   %rbp
  80309c:	48 89 e5             	mov    %rsp,%rbp
  80309f:	48 83 ec 10          	sub    $0x10,%rsp
  8030a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ab:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b5:	00 00 00 
  8030b8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030ba:	be 00 00 00 00       	mov    $0x0,%esi
  8030bf:	bf 06 00 00 00       	mov    $0x6,%edi
  8030c4:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  8030cb:	00 00 00 
  8030ce:	ff d0                	callq  *%rax
}
  8030d0:	c9                   	leaveq 
  8030d1:	c3                   	retq   

00000000008030d2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030d2:	55                   	push   %rbp
  8030d3:	48 89 e5             	mov    %rsp,%rbp
  8030d6:	48 83 ec 30          	sub    $0x30,%rsp
  8030da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8030e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8030ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8030f2:	74 07                	je     8030fb <devfile_read+0x29>
  8030f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8030f9:	75 07                	jne    803102 <devfile_read+0x30>
		return -E_INVAL;
  8030fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803100:	eb 77                	jmp    803179 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803106:	8b 50 0c             	mov    0xc(%rax),%edx
  803109:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803110:	00 00 00 
  803113:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803115:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80311c:	00 00 00 
  80311f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803123:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803127:	be 00 00 00 00       	mov    $0x0,%esi
  80312c:	bf 03 00 00 00       	mov    $0x3,%edi
  803131:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803144:	7f 05                	jg     80314b <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803149:	eb 2e                	jmp    803179 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80314b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314e:	48 63 d0             	movslq %eax,%rdx
  803151:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803155:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80315c:	00 00 00 
  80315f:	48 89 c7             	mov    %rax,%rdi
  803162:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80316e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803172:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803176:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803179:	c9                   	leaveq 
  80317a:	c3                   	retq   

000000000080317b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80317b:	55                   	push   %rbp
  80317c:	48 89 e5             	mov    %rsp,%rbp
  80317f:	48 83 ec 30          	sub    $0x30,%rsp
  803183:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803187:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80318b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80318f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803196:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80319b:	74 07                	je     8031a4 <devfile_write+0x29>
  80319d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031a2:	75 08                	jne    8031ac <devfile_write+0x31>
		return r;
  8031a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a7:	e9 9a 00 00 00       	jmpq   803246 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b0:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ba:	00 00 00 
  8031bd:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8031bf:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031c6:	00 
  8031c7:	76 08                	jbe    8031d1 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8031c9:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031d0:	00 
	}
	fsipcbuf.write.req_n = n;
  8031d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d8:	00 00 00 
  8031db:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031df:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8031e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031eb:	48 89 c6             	mov    %rax,%rsi
  8031ee:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8031f5:	00 00 00 
  8031f8:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803204:	be 00 00 00 00       	mov    $0x0,%esi
  803209:	bf 04 00 00 00       	mov    $0x4,%edi
  80320e:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
  80321a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803221:	7f 20                	jg     803243 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803223:	48 bf 86 4c 80 00 00 	movabs $0x804c86,%rdi
  80322a:	00 00 00 
  80322d:	b8 00 00 00 00       	mov    $0x0,%eax
  803232:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803239:	00 00 00 
  80323c:	ff d2                	callq  *%rdx
		return r;
  80323e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803241:	eb 03                	jmp    803246 <devfile_write+0xcb>
	}
	return r;
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
  80324c:	48 83 ec 20          	sub    $0x20,%rsp
  803250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325c:	8b 50 0c             	mov    0xc(%rax),%edx
  80325f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803266:	00 00 00 
  803269:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80326b:	be 00 00 00 00       	mov    $0x0,%esi
  803270:	bf 05 00 00 00       	mov    $0x5,%edi
  803275:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803288:	79 05                	jns    80328f <devfile_stat+0x47>
		return r;
  80328a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328d:	eb 56                	jmp    8032e5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80328f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803293:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80329a:	00 00 00 
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032b3:	00 00 00 
  8032b6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032cd:	00 00 00 
  8032d0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032da:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8032e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032e5:	c9                   	leaveq 
  8032e6:	c3                   	retq   

00000000008032e7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8032e7:	55                   	push   %rbp
  8032e8:	48 89 e5             	mov    %rsp,%rbp
  8032eb:	48 83 ec 10          	sub    $0x10,%rsp
  8032ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032f3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8032f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032fa:	8b 50 0c             	mov    0xc(%rax),%edx
  8032fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803304:	00 00 00 
  803307:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803309:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803310:	00 00 00 
  803313:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803316:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803319:	be 00 00 00 00       	mov    $0x0,%esi
  80331e:	bf 02 00 00 00       	mov    $0x2,%edi
  803323:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
}
  80332f:	c9                   	leaveq 
  803330:	c3                   	retq   

0000000000803331 <remove>:

// Delete a file
int
remove(const char *path)
{
  803331:	55                   	push   %rbp
  803332:	48 89 e5             	mov    %rsp,%rbp
  803335:	48 83 ec 10          	sub    $0x10,%rsp
  803339:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80333d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803341:	48 89 c7             	mov    %rax,%rdi
  803344:	48 b8 3c 12 80 00 00 	movabs $0x80123c,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
  803350:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803355:	7e 07                	jle    80335e <remove+0x2d>
		return -E_BAD_PATH;
  803357:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80335c:	eb 33                	jmp    803391 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80335e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803362:	48 89 c6             	mov    %rax,%rsi
  803365:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80336c:	00 00 00 
  80336f:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80337b:	be 00 00 00 00       	mov    $0x0,%esi
  803380:	bf 07 00 00 00       	mov    $0x7,%edi
  803385:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
}
  803391:	c9                   	leaveq 
  803392:	c3                   	retq   

0000000000803393 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803397:	be 00 00 00 00       	mov    $0x0,%esi
  80339c:	bf 08 00 00 00       	mov    $0x8,%edi
  8033a1:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
}
  8033ad:	5d                   	pop    %rbp
  8033ae:	c3                   	retq   

00000000008033af <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8033af:	55                   	push   %rbp
  8033b0:	48 89 e5             	mov    %rsp,%rbp
  8033b3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8033ba:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8033c1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8033c8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8033cf:	be 00 00 00 00       	mov    $0x0,%esi
  8033d4:	48 89 c7             	mov    %rax,%rdi
  8033d7:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
  8033e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8033e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ea:	79 28                	jns    803414 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8033ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ef:	89 c6                	mov    %eax,%esi
  8033f1:	48 bf a2 4c 80 00 00 	movabs $0x804ca2,%rdi
  8033f8:	00 00 00 
  8033fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803400:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803407:	00 00 00 
  80340a:	ff d2                	callq  *%rdx
		return fd_src;
  80340c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340f:	e9 74 01 00 00       	jmpq   803588 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803414:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80341b:	be 01 01 00 00       	mov    $0x101,%esi
  803420:	48 89 c7             	mov    %rax,%rdi
  803423:	48 b8 74 2f 80 00 00 	movabs $0x802f74,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
  80342f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803432:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803436:	79 39                	jns    803471 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803438:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80343b:	89 c6                	mov    %eax,%esi
  80343d:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  803444:	00 00 00 
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
  80344c:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803453:	00 00 00 
  803456:	ff d2                	callq  *%rdx
		close(fd_src);
  803458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345b:	89 c7                	mov    %eax,%edi
  80345d:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
		return fd_dest;
  803469:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80346c:	e9 17 01 00 00       	jmpq   803588 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803471:	eb 74                	jmp    8034e7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803473:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803476:	48 63 d0             	movslq %eax,%rdx
  803479:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803480:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803483:	48 89 ce             	mov    %rcx,%rsi
  803486:	89 c7                	mov    %eax,%edi
  803488:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803497:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80349b:	79 4a                	jns    8034e7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80349d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034a0:	89 c6                	mov    %eax,%esi
  8034a2:	48 bf d2 4c 80 00 00 	movabs $0x804cd2,%rdi
  8034a9:	00 00 00 
  8034ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b1:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8034b8:	00 00 00 
  8034bb:	ff d2                	callq  *%rdx
			close(fd_src);
  8034bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c0:	89 c7                	mov    %eax,%edi
  8034c2:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  8034c9:	00 00 00 
  8034cc:	ff d0                	callq  *%rax
			close(fd_dest);
  8034ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034d1:	89 c7                	mov    %eax,%edi
  8034d3:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
			return write_size;
  8034df:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034e2:	e9 a1 00 00 00       	jmpq   803588 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8034e7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f1:	ba 00 02 00 00       	mov    $0x200,%edx
  8034f6:	48 89 ce             	mov    %rcx,%rsi
  8034f9:	89 c7                	mov    %eax,%edi
  8034fb:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
  803507:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80350a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80350e:	0f 8f 5f ff ff ff    	jg     803473 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803514:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803518:	79 47                	jns    803561 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80351a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80351d:	89 c6                	mov    %eax,%esi
  80351f:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  803526:	00 00 00 
  803529:	b8 00 00 00 00       	mov    $0x0,%eax
  80352e:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  803535:	00 00 00 
  803538:	ff d2                	callq  *%rdx
		close(fd_src);
  80353a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
		close(fd_dest);
  80354b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80354e:	89 c7                	mov    %eax,%edi
  803550:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
		return read_size;
  80355c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80355f:	eb 27                	jmp    803588 <copy+0x1d9>
	}
	close(fd_src);
  803561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803564:	89 c7                	mov    %eax,%edi
  803566:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  80356d:	00 00 00 
  803570:	ff d0                	callq  *%rax
	close(fd_dest);
  803572:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803575:	89 c7                	mov    %eax,%edi
  803577:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  80357e:	00 00 00 
  803581:	ff d0                	callq  *%rax
	return 0;
  803583:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803588:	c9                   	leaveq 
  803589:	c3                   	retq   

000000000080358a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80358a:	55                   	push   %rbp
  80358b:	48 89 e5             	mov    %rsp,%rbp
  80358e:	53                   	push   %rbx
  80358f:	48 83 ec 38          	sub    $0x38,%rsp
  803593:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803597:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80359b:	48 89 c7             	mov    %rax,%rdi
  80359e:	48 b8 07 26 80 00 00 	movabs $0x802607,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
  8035aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b1:	0f 88 bf 01 00 00    	js     803776 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c0:	48 89 c6             	mov    %rax,%rsi
  8035c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c8:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035db:	0f 88 95 01 00 00    	js     803776 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035e5:	48 89 c7             	mov    %rax,%rdi
  8035e8:	48 b8 07 26 80 00 00 	movabs $0x802607,%rax
  8035ef:	00 00 00 
  8035f2:	ff d0                	callq  *%rax
  8035f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035fb:	0f 88 5d 01 00 00    	js     80375e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803605:	ba 07 04 00 00       	mov    $0x407,%edx
  80360a:	48 89 c6             	mov    %rax,%rsi
  80360d:	bf 00 00 00 00       	mov    $0x0,%edi
  803612:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
  80361e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803621:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803625:	0f 88 33 01 00 00    	js     80375e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80362b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362f:	48 89 c7             	mov    %rax,%rdi
  803632:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
  80363e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803642:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803646:	ba 07 04 00 00       	mov    $0x407,%edx
  80364b:	48 89 c6             	mov    %rax,%rsi
  80364e:	bf 00 00 00 00       	mov    $0x0,%edi
  803653:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  80365a:	00 00 00 
  80365d:	ff d0                	callq  *%rax
  80365f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803662:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803666:	79 05                	jns    80366d <pipe+0xe3>
		goto err2;
  803668:	e9 d9 00 00 00       	jmpq   803746 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80366d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803671:	48 89 c7             	mov    %rax,%rdi
  803674:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	48 89 c2             	mov    %rax,%rdx
  803683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803687:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80368d:	48 89 d1             	mov    %rdx,%rcx
  803690:	ba 00 00 00 00       	mov    $0x0,%edx
  803695:	48 89 c6             	mov    %rax,%rsi
  803698:	bf 00 00 00 00       	mov    $0x0,%edi
  80369d:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8036a4:	00 00 00 
  8036a7:	ff d0                	callq  *%rax
  8036a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b0:	79 1b                	jns    8036cd <pipe+0x143>
		goto err3;
  8036b2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b7:	48 89 c6             	mov    %rax,%rsi
  8036ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bf:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	eb 79                	jmp    803746 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036d8:	00 00 00 
  8036db:	8b 12                	mov    (%rdx),%edx
  8036dd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ee:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036f5:	00 00 00 
  8036f8:	8b 12                	mov    (%rdx),%edx
  8036fa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803700:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80370b:	48 89 c7             	mov    %rax,%rdi
  80370e:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803715:	00 00 00 
  803718:	ff d0                	callq  *%rax
  80371a:	89 c2                	mov    %eax,%edx
  80371c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803720:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803722:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803726:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80372a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372e:	48 89 c7             	mov    %rax,%rdi
  803731:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
  80373d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80373f:	b8 00 00 00 00       	mov    $0x0,%eax
  803744:	eb 33                	jmp    803779 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803746:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374a:	48 89 c6             	mov    %rax,%rsi
  80374d:	bf 00 00 00 00       	mov    $0x0,%edi
  803752:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80375e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803762:	48 89 c6             	mov    %rax,%rsi
  803765:	bf 00 00 00 00       	mov    $0x0,%edi
  80376a:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
err:
	return r;
  803776:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803779:	48 83 c4 38          	add    $0x38,%rsp
  80377d:	5b                   	pop    %rbx
  80377e:	5d                   	pop    %rbp
  80377f:	c3                   	retq   

0000000000803780 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803780:	55                   	push   %rbp
  803781:	48 89 e5             	mov    %rsp,%rbp
  803784:	53                   	push   %rbx
  803785:	48 83 ec 28          	sub    $0x28,%rsp
  803789:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80378d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803791:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803798:	00 00 00 
  80379b:	48 8b 00             	mov    (%rax),%rax
  80379e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 83 44 80 00 00 	movabs $0x804483,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
  8037ba:	89 c3                	mov    %eax,%ebx
  8037bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c0:	48 89 c7             	mov    %rax,%rdi
  8037c3:	48 b8 83 44 80 00 00 	movabs $0x804483,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
  8037cf:	39 c3                	cmp    %eax,%ebx
  8037d1:	0f 94 c0             	sete   %al
  8037d4:	0f b6 c0             	movzbl %al,%eax
  8037d7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037e1:	00 00 00 
  8037e4:	48 8b 00             	mov    (%rax),%rax
  8037e7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037ed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037f6:	75 05                	jne    8037fd <_pipeisclosed+0x7d>
			return ret;
  8037f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037fb:	eb 4f                	jmp    80384c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8037fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803800:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803803:	74 42                	je     803847 <_pipeisclosed+0xc7>
  803805:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803809:	75 3c                	jne    803847 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80380b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803812:	00 00 00 
  803815:	48 8b 00             	mov    (%rax),%rax
  803818:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80381e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803821:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803824:	89 c6                	mov    %eax,%esi
  803826:	48 bf 05 4d 80 00 00 	movabs $0x804d05,%rdi
  80382d:	00 00 00 
  803830:	b8 00 00 00 00       	mov    $0x0,%eax
  803835:	49 b8 f3 06 80 00 00 	movabs $0x8006f3,%r8
  80383c:	00 00 00 
  80383f:	41 ff d0             	callq  *%r8
	}
  803842:	e9 4a ff ff ff       	jmpq   803791 <_pipeisclosed+0x11>
  803847:	e9 45 ff ff ff       	jmpq   803791 <_pipeisclosed+0x11>
}
  80384c:	48 83 c4 28          	add    $0x28,%rsp
  803850:	5b                   	pop    %rbx
  803851:	5d                   	pop    %rbp
  803852:	c3                   	retq   

0000000000803853 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803853:	55                   	push   %rbp
  803854:	48 89 e5             	mov    %rsp,%rbp
  803857:	48 83 ec 30          	sub    $0x30,%rsp
  80385b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80385e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803862:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803865:	48 89 d6             	mov    %rdx,%rsi
  803868:	89 c7                	mov    %eax,%edi
  80386a:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
  803876:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387d:	79 05                	jns    803884 <pipeisclosed+0x31>
		return r;
  80387f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803882:	eb 31                	jmp    8038b5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803888:	48 89 c7             	mov    %rax,%rdi
  80388b:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
  803897:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80389b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a3:	48 89 d6             	mov    %rdx,%rsi
  8038a6:	48 89 c7             	mov    %rax,%rdi
  8038a9:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  8038b0:	00 00 00 
  8038b3:	ff d0                	callq  *%rax
}
  8038b5:	c9                   	leaveq 
  8038b6:	c3                   	retq   

00000000008038b7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038b7:	55                   	push   %rbp
  8038b8:	48 89 e5             	mov    %rsp,%rbp
  8038bb:	48 83 ec 40          	sub    $0x40,%rsp
  8038bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cf:	48 89 c7             	mov    %rax,%rdi
  8038d2:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8038d9:	00 00 00 
  8038dc:	ff d0                	callq  *%rax
  8038de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038f1:	00 
  8038f2:	e9 92 00 00 00       	jmpq   803989 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8038f7:	eb 41                	jmp    80393a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038f9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038fe:	74 09                	je     803909 <devpipe_read+0x52>
				return i;
  803900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803904:	e9 92 00 00 00       	jmpq   80399b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803909:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803911:	48 89 d6             	mov    %rdx,%rsi
  803914:	48 89 c7             	mov    %rax,%rdi
  803917:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	85 c0                	test   %eax,%eax
  803925:	74 07                	je     80392e <devpipe_read+0x77>
				return 0;
  803927:	b8 00 00 00 00       	mov    $0x0,%eax
  80392c:	eb 6d                	jmp    80399b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80392e:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80393a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393e:	8b 10                	mov    (%rax),%edx
  803940:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803944:	8b 40 04             	mov    0x4(%rax),%eax
  803947:	39 c2                	cmp    %eax,%edx
  803949:	74 ae                	je     8038f9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80394b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803953:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395b:	8b 00                	mov    (%rax),%eax
  80395d:	99                   	cltd   
  80395e:	c1 ea 1b             	shr    $0x1b,%edx
  803961:	01 d0                	add    %edx,%eax
  803963:	83 e0 1f             	and    $0x1f,%eax
  803966:	29 d0                	sub    %edx,%eax
  803968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80396c:	48 98                	cltq   
  80396e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803973:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803979:	8b 00                	mov    (%rax),%eax
  80397b:	8d 50 01             	lea    0x1(%rax),%edx
  80397e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803982:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803984:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803991:	0f 82 60 ff ff ff    	jb     8038f7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80399b:	c9                   	leaveq 
  80399c:	c3                   	retq   

000000000080399d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80399d:	55                   	push   %rbp
  80399e:	48 89 e5             	mov    %rsp,%rbp
  8039a1:	48 83 ec 40          	sub    $0x40,%rsp
  8039a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039d0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039d7:	00 
  8039d8:	e9 8e 00 00 00       	jmpq   803a6b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039dd:	eb 31                	jmp    803a10 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e7:	48 89 d6             	mov    %rdx,%rsi
  8039ea:	48 89 c7             	mov    %rax,%rdi
  8039ed:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
  8039f9:	85 c0                	test   %eax,%eax
  8039fb:	74 07                	je     803a04 <devpipe_write+0x67>
				return 0;
  8039fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803a02:	eb 79                	jmp    803a7d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a04:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803a0b:	00 00 00 
  803a0e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a14:	8b 40 04             	mov    0x4(%rax),%eax
  803a17:	48 63 d0             	movslq %eax,%rdx
  803a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1e:	8b 00                	mov    (%rax),%eax
  803a20:	48 98                	cltq   
  803a22:	48 83 c0 20          	add    $0x20,%rax
  803a26:	48 39 c2             	cmp    %rax,%rdx
  803a29:	73 b4                	jae    8039df <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2f:	8b 40 04             	mov    0x4(%rax),%eax
  803a32:	99                   	cltd   
  803a33:	c1 ea 1b             	shr    $0x1b,%edx
  803a36:	01 d0                	add    %edx,%eax
  803a38:	83 e0 1f             	and    $0x1f,%eax
  803a3b:	29 d0                	sub    %edx,%eax
  803a3d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a41:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a45:	48 01 ca             	add    %rcx,%rdx
  803a48:	0f b6 0a             	movzbl (%rdx),%ecx
  803a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a4f:	48 98                	cltq   
  803a51:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a59:	8b 40 04             	mov    0x4(%rax),%eax
  803a5c:	8d 50 01             	lea    0x1(%rax),%edx
  803a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a63:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a66:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a73:	0f 82 64 ff ff ff    	jb     8039dd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a7d:	c9                   	leaveq 
  803a7e:	c3                   	retq   

0000000000803a7f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a7f:	55                   	push   %rbp
  803a80:	48 89 e5             	mov    %rsp,%rbp
  803a83:	48 83 ec 20          	sub    $0x20,%rsp
  803a87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a93:	48 89 c7             	mov    %rax,%rdi
  803a96:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
  803aa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aaa:	48 be 18 4d 80 00 00 	movabs $0x804d18,%rsi
  803ab1:	00 00 00 
  803ab4:	48 89 c7             	mov    %rax,%rdi
  803ab7:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ac3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac7:	8b 50 04             	mov    0x4(%rax),%edx
  803aca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ace:	8b 00                	mov    (%rax),%eax
  803ad0:	29 c2                	sub    %eax,%edx
  803ad2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803adc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ae7:	00 00 00 
	stat->st_dev = &devpipe;
  803aea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aee:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803af5:	00 00 00 
  803af8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803aff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b04:	c9                   	leaveq 
  803b05:	c3                   	retq   

0000000000803b06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b06:	55                   	push   %rbp
  803b07:	48 89 e5             	mov    %rsp,%rbp
  803b0a:	48 83 ec 10          	sub    $0x10,%rsp
  803b0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b16:	48 89 c6             	mov    %rax,%rsi
  803b19:	bf 00 00 00 00       	mov    $0x0,%edi
  803b1e:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2e:	48 89 c7             	mov    %rax,%rdi
  803b31:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803b38:	00 00 00 
  803b3b:	ff d0                	callq  *%rax
  803b3d:	48 89 c6             	mov    %rax,%rsi
  803b40:	bf 00 00 00 00       	mov    $0x0,%edi
  803b45:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803b4c:	00 00 00 
  803b4f:	ff d0                	callq  *%rax
}
  803b51:	c9                   	leaveq 
  803b52:	c3                   	retq   

0000000000803b53 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b53:	55                   	push   %rbp
  803b54:	48 89 e5             	mov    %rsp,%rbp
  803b57:	48 83 ec 20          	sub    $0x20,%rsp
  803b5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b61:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b64:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b68:	be 01 00 00 00       	mov    $0x1,%esi
  803b6d:	48 89 c7             	mov    %rax,%rdi
  803b70:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
}
  803b7c:	c9                   	leaveq 
  803b7d:	c3                   	retq   

0000000000803b7e <getchar>:

int
getchar(void)
{
  803b7e:	55                   	push   %rbp
  803b7f:	48 89 e5             	mov    %rsp,%rbp
  803b82:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b86:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b8a:	ba 01 00 00 00       	mov    $0x1,%edx
  803b8f:	48 89 c6             	mov    %rax,%rsi
  803b92:	bf 00 00 00 00       	mov    $0x0,%edi
  803b97:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  803b9e:	00 00 00 
  803ba1:	ff d0                	callq  *%rax
  803ba3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803baa:	79 05                	jns    803bb1 <getchar+0x33>
		return r;
  803bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803baf:	eb 14                	jmp    803bc5 <getchar+0x47>
	if (r < 1)
  803bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb5:	7f 07                	jg     803bbe <getchar+0x40>
		return -E_EOF;
  803bb7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bbc:	eb 07                	jmp    803bc5 <getchar+0x47>
	return c;
  803bbe:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bc2:	0f b6 c0             	movzbl %al,%eax
}
  803bc5:	c9                   	leaveq 
  803bc6:	c3                   	retq   

0000000000803bc7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bc7:	55                   	push   %rbp
  803bc8:	48 89 e5             	mov    %rsp,%rbp
  803bcb:	48 83 ec 20          	sub    $0x20,%rsp
  803bcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bd2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd9:	48 89 d6             	mov    %rdx,%rsi
  803bdc:	89 c7                	mov    %eax,%edi
  803bde:	48 b8 9f 26 80 00 00 	movabs $0x80269f,%rax
  803be5:	00 00 00 
  803be8:	ff d0                	callq  *%rax
  803bea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf1:	79 05                	jns    803bf8 <iscons+0x31>
		return r;
  803bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf6:	eb 1a                	jmp    803c12 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfc:	8b 10                	mov    (%rax),%edx
  803bfe:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c05:	00 00 00 
  803c08:	8b 00                	mov    (%rax),%eax
  803c0a:	39 c2                	cmp    %eax,%edx
  803c0c:	0f 94 c0             	sete   %al
  803c0f:	0f b6 c0             	movzbl %al,%eax
}
  803c12:	c9                   	leaveq 
  803c13:	c3                   	retq   

0000000000803c14 <opencons>:

int
opencons(void)
{
  803c14:	55                   	push   %rbp
  803c15:	48 89 e5             	mov    %rsp,%rbp
  803c18:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c1c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c20:	48 89 c7             	mov    %rax,%rdi
  803c23:	48 b8 07 26 80 00 00 	movabs $0x802607,%rax
  803c2a:	00 00 00 
  803c2d:	ff d0                	callq  *%rax
  803c2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c36:	79 05                	jns    803c3d <opencons+0x29>
		return r;
  803c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3b:	eb 5b                	jmp    803c98 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c41:	ba 07 04 00 00       	mov    $0x407,%edx
  803c46:	48 89 c6             	mov    %rax,%rsi
  803c49:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4e:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
  803c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c61:	79 05                	jns    803c68 <opencons+0x54>
		return r;
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	eb 30                	jmp    803c98 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6c:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c73:	00 00 00 
  803c76:	8b 12                	mov    (%rdx),%edx
  803c78:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c89:	48 89 c7             	mov    %rax,%rdi
  803c8c:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  803c93:	00 00 00 
  803c96:	ff d0                	callq  *%rax
}
  803c98:	c9                   	leaveq 
  803c99:	c3                   	retq   

0000000000803c9a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c9a:	55                   	push   %rbp
  803c9b:	48 89 e5             	mov    %rsp,%rbp
  803c9e:	48 83 ec 30          	sub    $0x30,%rsp
  803ca2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803caa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cb3:	75 07                	jne    803cbc <devcons_read+0x22>
		return 0;
  803cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cba:	eb 4b                	jmp    803d07 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cbc:	eb 0c                	jmp    803cca <devcons_read+0x30>
		sys_yield();
  803cbe:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  803cc5:	00 00 00 
  803cc8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cca:	48 b8 d9 1a 80 00 00 	movabs $0x801ad9,%rax
  803cd1:	00 00 00 
  803cd4:	ff d0                	callq  *%rax
  803cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cdd:	74 df                	je     803cbe <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce3:	79 05                	jns    803cea <devcons_read+0x50>
		return c;
  803ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce8:	eb 1d                	jmp    803d07 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803cea:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803cee:	75 07                	jne    803cf7 <devcons_read+0x5d>
		return 0;
  803cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf5:	eb 10                	jmp    803d07 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfa:	89 c2                	mov    %eax,%edx
  803cfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d00:	88 10                	mov    %dl,(%rax)
	return 1;
  803d02:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d07:	c9                   	leaveq 
  803d08:	c3                   	retq   

0000000000803d09 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d09:	55                   	push   %rbp
  803d0a:	48 89 e5             	mov    %rsp,%rbp
  803d0d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d14:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d1b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d22:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d30:	eb 76                	jmp    803da8 <devcons_write+0x9f>
		m = n - tot;
  803d32:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d39:	89 c2                	mov    %eax,%edx
  803d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3e:	29 c2                	sub    %eax,%edx
  803d40:	89 d0                	mov    %edx,%eax
  803d42:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d48:	83 f8 7f             	cmp    $0x7f,%eax
  803d4b:	76 07                	jbe    803d54 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d4d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d57:	48 63 d0             	movslq %eax,%rdx
  803d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5d:	48 63 c8             	movslq %eax,%rcx
  803d60:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d67:	48 01 c1             	add    %rax,%rcx
  803d6a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d71:	48 89 ce             	mov    %rcx,%rsi
  803d74:	48 89 c7             	mov    %rax,%rdi
  803d77:	48 b8 cc 15 80 00 00 	movabs $0x8015cc,%rax
  803d7e:	00 00 00 
  803d81:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d86:	48 63 d0             	movslq %eax,%rdx
  803d89:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d90:	48 89 d6             	mov    %rdx,%rsi
  803d93:	48 89 c7             	mov    %rax,%rdi
  803d96:	48 b8 8f 1a 80 00 00 	movabs $0x801a8f,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803da2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da5:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dab:	48 98                	cltq   
  803dad:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803db4:	0f 82 78 ff ff ff    	jb     803d32 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dbd:	c9                   	leaveq 
  803dbe:	c3                   	retq   

0000000000803dbf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803dbf:	55                   	push   %rbp
  803dc0:	48 89 e5             	mov    %rsp,%rbp
  803dc3:	48 83 ec 08          	sub    $0x8,%rsp
  803dc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dd0:	c9                   	leaveq 
  803dd1:	c3                   	retq   

0000000000803dd2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803dd2:	55                   	push   %rbp
  803dd3:	48 89 e5             	mov    %rsp,%rbp
  803dd6:	48 83 ec 10          	sub    $0x10,%rsp
  803dda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de6:	48 be 24 4d 80 00 00 	movabs $0x804d24,%rsi
  803ded:	00 00 00 
  803df0:	48 89 c7             	mov    %rax,%rdi
  803df3:	48 b8 a8 12 80 00 00 	movabs $0x8012a8,%rax
  803dfa:	00 00 00 
  803dfd:	ff d0                	callq  *%rax
	return 0;
  803dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e04:	c9                   	leaveq 
  803e05:	c3                   	retq   

0000000000803e06 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803e06:	55                   	push   %rbp
  803e07:	48 89 e5             	mov    %rsp,%rbp
  803e0a:	48 83 ec 10          	sub    $0x10,%rsp
  803e0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803e12:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803e19:	00 00 00 
  803e1c:	48 8b 00             	mov    (%rax),%rax
  803e1f:	48 85 c0             	test   %rax,%rax
  803e22:	0f 85 84 00 00 00    	jne    803eac <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803e28:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e2f:	00 00 00 
  803e32:	48 8b 00             	mov    (%rax),%rax
  803e35:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e3b:	ba 07 00 00 00       	mov    $0x7,%edx
  803e40:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803e45:	89 c7                	mov    %eax,%edi
  803e47:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803e4e:	00 00 00 
  803e51:	ff d0                	callq  *%rax
  803e53:	85 c0                	test   %eax,%eax
  803e55:	79 2a                	jns    803e81 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803e57:	48 ba 30 4d 80 00 00 	movabs $0x804d30,%rdx
  803e5e:	00 00 00 
  803e61:	be 23 00 00 00       	mov    $0x23,%esi
  803e66:	48 bf 57 4d 80 00 00 	movabs $0x804d57,%rdi
  803e6d:	00 00 00 
  803e70:	b8 00 00 00 00       	mov    $0x0,%eax
  803e75:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  803e7c:	00 00 00 
  803e7f:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803e81:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e88:	00 00 00 
  803e8b:	48 8b 00             	mov    (%rax),%rax
  803e8e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e94:	48 be bf 3e 80 00 00 	movabs $0x803ebf,%rsi
  803e9b:	00 00 00 
  803e9e:	89 c7                	mov    %eax,%edi
  803ea0:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803eac:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803eb3:	00 00 00 
  803eb6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803eba:	48 89 10             	mov    %rdx,(%rax)
}
  803ebd:	c9                   	leaveq 
  803ebe:	c3                   	retq   

0000000000803ebf <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803ebf:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803ec2:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803ec9:	00 00 00 
call *%rax
  803ecc:	ff d0                	callq  *%rax
//



// LAB 4: Your code here.
movq 136(%rsp), %rbx  //Load RIP 
  803ece:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803ed5:	00 
movq 152(%rsp), %rcx  //Load RSP
  803ed6:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803edd:	00 
//Move pointer on the stack and save the RIP on trap time stack 
subq $8, %rcx          
  803ede:	48 83 e9 08          	sub    $0x8,%rcx
movq %rbx, (%rcx) 
  803ee2:	48 89 19             	mov    %rbx,(%rcx)
//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
movq %rcx, 152(%rsp)
  803ee5:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803eec:	00 

// Restore the trap-time registers.  After you do this, you
// can no longer modify any general-purpose registers.
// LAB 4: Your code here.
addq $16,%rsp
  803eed:	48 83 c4 10          	add    $0x10,%rsp
POPA_ 
  803ef1:	4c 8b 3c 24          	mov    (%rsp),%r15
  803ef5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803efa:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803eff:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803f04:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803f09:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803f0e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803f13:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803f18:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803f1d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803f22:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803f27:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803f2c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803f31:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803f36:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803f3b:	48 83 c4 78          	add    $0x78,%rsp
// Restore eflags from the stack.  After you do this, you can
// no longer use arithmetic operations or anything else that
// modifies eflags.
// LAB 4: Your code here.
addq $8, %rsp
  803f3f:	48 83 c4 08          	add    $0x8,%rsp
popfq
  803f43:	9d                   	popfq  

// Switch back to the adjusted trap-time stack.
// LAB 4: Your code here.
popq %rsp
  803f44:	5c                   	pop    %rsp

// Return to re-execute the instruction that faulted.
// LAB 4: Your code here.
ret
  803f45:	c3                   	retq   

0000000000803f46 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f46:	55                   	push   %rbp
  803f47:	48 89 e5             	mov    %rsp,%rbp
  803f4a:	48 83 ec 30          	sub    $0x30,%rsp
  803f4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f5a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f61:	00 00 00 
  803f64:	48 8b 00             	mov    (%rax),%rax
  803f67:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f6d:	85 c0                	test   %eax,%eax
  803f6f:	75 34                	jne    803fa5 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f71:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  803f78:	00 00 00 
  803f7b:	ff d0                	callq  *%rax
  803f7d:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f82:	48 98                	cltq   
  803f84:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803f8b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f92:	00 00 00 
  803f95:	48 01 c2             	add    %rax,%rdx
  803f98:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f9f:	00 00 00 
  803fa2:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803fa5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803faa:	75 0e                	jne    803fba <ipc_recv+0x74>
		pg = (void*) UTOP;
  803fac:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fb3:	00 00 00 
  803fb6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbe:	48 89 c7             	mov    %rax,%rdi
  803fc1:	48 b8 00 1e 80 00 00 	movabs $0x801e00,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
  803fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd4:	79 19                	jns    803fef <ipc_recv+0xa9>
		*from_env_store = 0;
  803fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fda:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803fe0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fed:	eb 53                	jmp    804042 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803fef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ff4:	74 19                	je     80400f <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803ff6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ffd:	00 00 00 
  804000:	48 8b 00             	mov    (%rax),%rax
  804003:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400d:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80400f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804014:	74 19                	je     80402f <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  804016:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80401d:	00 00 00 
  804020:	48 8b 00             	mov    (%rax),%rax
  804023:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804029:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80402f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804036:	00 00 00 
  804039:	48 8b 00             	mov    (%rax),%rax
  80403c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804042:	c9                   	leaveq 
  804043:	c3                   	retq   

0000000000804044 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804044:	55                   	push   %rbp
  804045:	48 89 e5             	mov    %rsp,%rbp
  804048:	48 83 ec 30          	sub    $0x30,%rsp
  80404c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80404f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804052:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804056:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804059:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80405e:	75 0e                	jne    80406e <ipc_send+0x2a>
		pg = (void*)UTOP;
  804060:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804067:	00 00 00 
  80406a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80406e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804071:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804074:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804078:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80407b:	89 c7                	mov    %eax,%edi
  80407d:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  804084:	00 00 00 
  804087:	ff d0                	callq  *%rax
  804089:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80408c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804090:	75 0c                	jne    80409e <ipc_send+0x5a>
			sys_yield();
  804092:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80409e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040a2:	74 ca                	je     80406e <ipc_send+0x2a>
	if(result != 0)
  8040a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a8:	74 20                	je     8040ca <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8040aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ad:	89 c6                	mov    %eax,%esi
  8040af:	48 bf 68 4d 80 00 00 	movabs $0x804d68,%rdi
  8040b6:	00 00 00 
  8040b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8040be:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  8040c5:	00 00 00 
  8040c8:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  8040ca:	c9                   	leaveq 
  8040cb:	c3                   	retq   

00000000008040cc <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8040cc:	55                   	push   %rbp
  8040cd:	48 89 e5             	mov    %rsp,%rbp
  8040d0:	53                   	push   %rbx
  8040d1:	48 83 ec 58          	sub    $0x58,%rsp
  8040d5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  8040d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8040dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  8040e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  8040e8:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8040ef:	00 
  8040f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8040f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804100:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804104:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804108:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80410c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  804110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804114:	48 c1 e8 27          	shr    $0x27,%rax
  804118:	48 89 c2             	mov    %rax,%rdx
  80411b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804122:	01 00 00 
  804125:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804129:	83 e0 01             	and    $0x1,%eax
  80412c:	48 85 c0             	test   %rax,%rax
  80412f:	0f 85 91 00 00 00    	jne    8041c6 <ipc_host_recv+0xfa>
  804135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804139:	48 c1 e8 1e          	shr    $0x1e,%rax
  80413d:	48 89 c2             	mov    %rax,%rdx
  804140:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  804147:	01 00 00 
  80414a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80414e:	83 e0 01             	and    $0x1,%eax
  804151:	48 85 c0             	test   %rax,%rax
  804154:	74 70                	je     8041c6 <ipc_host_recv+0xfa>
  804156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80415a:	48 c1 e8 15          	shr    $0x15,%rax
  80415e:	48 89 c2             	mov    %rax,%rdx
  804161:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804168:	01 00 00 
  80416b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80416f:	83 e0 01             	and    $0x1,%eax
  804172:	48 85 c0             	test   %rax,%rax
  804175:	74 4f                	je     8041c6 <ipc_host_recv+0xfa>
  804177:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80417b:	48 c1 e8 0c          	shr    $0xc,%rax
  80417f:	48 89 c2             	mov    %rax,%rdx
  804182:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804189:	01 00 00 
  80418c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804190:	83 e0 01             	and    $0x1,%eax
  804193:	48 85 c0             	test   %rax,%rax
  804196:	74 2e                	je     8041c6 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419c:	ba 07 04 00 00       	mov    $0x407,%edx
  8041a1:	48 89 c6             	mov    %rax,%rsi
  8041a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8041a9:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  8041b0:	00 00 00 
  8041b3:	ff d0                	callq  *%rax
  8041b5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8041b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8041bc:	79 08                	jns    8041c6 <ipc_host_recv+0xfa>
	    	return result;
  8041be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8041c1:	e9 84 00 00 00       	jmpq   80424a <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8041c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8041ce:	48 89 c2             	mov    %rax,%rdx
  8041d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041d8:	01 00 00 
  8041db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041df:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041e5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  8041e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8041ee:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041f2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8041f6:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  8041fa:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8041fe:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804202:	4c 89 c3             	mov    %r8,%rbx
  804205:	0f 01 c1             	vmcall 
  804208:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  80420b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80420f:	7e 36                	jle    804247 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  804211:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804214:	41 89 c0             	mov    %eax,%r8d
  804217:	b9 03 00 00 00       	mov    $0x3,%ecx
  80421c:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  804223:	00 00 00 
  804226:	be 67 00 00 00       	mov    $0x67,%esi
  80422b:	48 bf ad 4d 80 00 00 	movabs $0x804dad,%rdi
  804232:	00 00 00 
  804235:	b8 00 00 00 00       	mov    $0x0,%eax
  80423a:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  804241:	00 00 00 
  804244:	41 ff d1             	callq  *%r9
	return result;
  804247:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  80424a:	48 83 c4 58          	add    $0x58,%rsp
  80424e:	5b                   	pop    %rbx
  80424f:	5d                   	pop    %rbp
  804250:	c3                   	retq   

0000000000804251 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804251:	55                   	push   %rbp
  804252:	48 89 e5             	mov    %rsp,%rbp
  804255:	53                   	push   %rbx
  804256:	48 83 ec 68          	sub    $0x68,%rsp
  80425a:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80425d:	89 75 a8             	mov    %esi,-0x58(%rbp)
  804260:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  804264:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  804267:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80426b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  80426f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  804276:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80427d:	00 
  80427e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804282:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  804286:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80428a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80428e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804292:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804296:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80429a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80429e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a2:	48 c1 e8 27          	shr    $0x27,%rax
  8042a6:	48 89 c2             	mov    %rax,%rdx
  8042a9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8042b0:	01 00 00 
  8042b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042b7:	83 e0 01             	and    $0x1,%eax
  8042ba:	48 85 c0             	test   %rax,%rax
  8042bd:	0f 85 88 00 00 00    	jne    80434b <ipc_host_send+0xfa>
  8042c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042c7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8042cb:	48 89 c2             	mov    %rax,%rdx
  8042ce:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8042d5:	01 00 00 
  8042d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042dc:	83 e0 01             	and    $0x1,%eax
  8042df:	48 85 c0             	test   %rax,%rax
  8042e2:	74 67                	je     80434b <ipc_host_send+0xfa>
  8042e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042e8:	48 c1 e8 15          	shr    $0x15,%rax
  8042ec:	48 89 c2             	mov    %rax,%rdx
  8042ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042f6:	01 00 00 
  8042f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042fd:	83 e0 01             	and    $0x1,%eax
  804300:	48 85 c0             	test   %rax,%rax
  804303:	74 46                	je     80434b <ipc_host_send+0xfa>
  804305:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804309:	48 c1 e8 0c          	shr    $0xc,%rax
  80430d:	48 89 c2             	mov    %rax,%rdx
  804310:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804317:	01 00 00 
  80431a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80431e:	83 e0 01             	and    $0x1,%eax
  804321:	48 85 c0             	test   %rax,%rax
  804324:	74 25                	je     80434b <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  804326:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80432a:	48 c1 e8 0c          	shr    $0xc,%rax
  80432e:	48 89 c2             	mov    %rax,%rdx
  804331:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804338:	01 00 00 
  80433b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80433f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804345:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  804349:	eb 0e                	jmp    804359 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  80434b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804352:	00 00 00 
  804355:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  804359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80435d:	48 89 c6             	mov    %rax,%rsi
  804360:	48 bf b7 4d 80 00 00 	movabs $0x804db7,%rdi
  804367:	00 00 00 
  80436a:	b8 00 00 00 00       	mov    $0x0,%eax
  80436f:	48 ba f3 06 80 00 00 	movabs $0x8006f3,%rdx
  804376:	00 00 00 
  804379:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80437b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80437e:	48 98                	cltq   
  804380:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  804384:	8b 45 a8             	mov    -0x58(%rbp),%eax
  804387:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80438b:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80438e:	48 98                	cltq   
  804390:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  804394:	b8 02 00 00 00       	mov    $0x2,%eax
  804399:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80439d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8043a1:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  8043a5:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8043a9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8043ad:	4c 89 c3             	mov    %r8,%rbx
  8043b0:	0f 01 c1             	vmcall 
  8043b3:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  8043b6:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8043ba:	75 0c                	jne    8043c8 <ipc_host_send+0x177>
			sys_yield();
  8043bc:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  8043c3:	00 00 00 
  8043c6:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  8043c8:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  8043cc:	74 c6                	je     804394 <ipc_host_send+0x143>
	
	if(result !=0)
  8043ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8043d2:	74 36                	je     80440a <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  8043d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043d7:	41 89 c0             	mov    %eax,%r8d
  8043da:	b9 02 00 00 00       	mov    $0x2,%ecx
  8043df:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  8043e6:	00 00 00 
  8043e9:	be 94 00 00 00       	mov    $0x94,%esi
  8043ee:	48 bf ad 4d 80 00 00 	movabs $0x804dad,%rdi
  8043f5:	00 00 00 
  8043f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fd:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  804404:	00 00 00 
  804407:	41 ff d1             	callq  *%r9
}
  80440a:	48 83 c4 68          	add    $0x68,%rsp
  80440e:	5b                   	pop    %rbx
  80440f:	5d                   	pop    %rbp
  804410:	c3                   	retq   

0000000000804411 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804411:	55                   	push   %rbp
  804412:	48 89 e5             	mov    %rsp,%rbp
  804415:	48 83 ec 14          	sub    $0x14,%rsp
  804419:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80441c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804423:	eb 4e                	jmp    804473 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804425:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80442c:	00 00 00 
  80442f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804432:	48 98                	cltq   
  804434:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80443b:	48 01 d0             	add    %rdx,%rax
  80443e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804444:	8b 00                	mov    (%rax),%eax
  804446:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804449:	75 24                	jne    80446f <ipc_find_env+0x5e>
			return envs[i].env_id;
  80444b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804452:	00 00 00 
  804455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804458:	48 98                	cltq   
  80445a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804461:	48 01 d0             	add    %rdx,%rax
  804464:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80446a:	8b 40 08             	mov    0x8(%rax),%eax
  80446d:	eb 12                	jmp    804481 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80446f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804473:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80447a:	7e a9                	jle    804425 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80447c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804481:	c9                   	leaveq 
  804482:	c3                   	retq   

0000000000804483 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804483:	55                   	push   %rbp
  804484:	48 89 e5             	mov    %rsp,%rbp
  804487:	48 83 ec 18          	sub    $0x18,%rsp
  80448b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80448f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804493:	48 c1 e8 15          	shr    $0x15,%rax
  804497:	48 89 c2             	mov    %rax,%rdx
  80449a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044a1:	01 00 00 
  8044a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044a8:	83 e0 01             	and    $0x1,%eax
  8044ab:	48 85 c0             	test   %rax,%rax
  8044ae:	75 07                	jne    8044b7 <pageref+0x34>
		return 0;
  8044b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b5:	eb 53                	jmp    80450a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8044bf:	48 89 c2             	mov    %rax,%rdx
  8044c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044c9:	01 00 00 
  8044cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d8:	83 e0 01             	and    $0x1,%eax
  8044db:	48 85 c0             	test   %rax,%rax
  8044de:	75 07                	jne    8044e7 <pageref+0x64>
		return 0;
  8044e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e5:	eb 23                	jmp    80450a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044eb:	48 c1 e8 0c          	shr    $0xc,%rax
  8044ef:	48 89 c2             	mov    %rax,%rdx
  8044f2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044f9:	00 00 00 
  8044fc:	48 c1 e2 04          	shl    $0x4,%rdx
  804500:	48 01 d0             	add    %rdx,%rax
  804503:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804507:	0f b7 c0             	movzwl %ax,%eax
}
  80450a:	c9                   	leaveq 
  80450b:	c3                   	retq   
