
obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 86 43 80 00 00 	movabs $0x804386,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 91 43 80 00 00 	movabs $0x804391,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba c0 43 80 00 00 	movabs $0x8043c0,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf e1 43 80 00 00 	movabs $0x8043e1,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba ea 43 80 00 00 	movabs $0x8043ea,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 35 44 80 00 00 	movabs $0x804435,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba 49 44 80 00 00 	movabs $0x804449,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf 7e 44 80 00 00 	movabs $0x80447e,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 91 44 80 00 00 	movabs $0x804491,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba 9f 44 80 00 00 	movabs $0x80449f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf bd 44 80 00 00 	movabs $0x8044bd,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba d0 44 80 00 00 	movabs $0x8044d0,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf df 44 80 00 00 	movabs $0x8044df,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba f8 44 80 00 00 	movabs $0x8044f8,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf 2f 45 80 00 00 	movabs $0x80452f,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba 4f 45 80 00 00 	movabs $0x80454f,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf 68 45 80 00 00 	movabs $0x804568,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba a8 45 80 00 00 	movabs $0x8045a8,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf b7 45 80 00 00 	movabs $0x8045b7,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba d0 45 80 00 00 	movabs $0x8045d0,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba f0 45 80 00 00 	movabs $0x8045f0,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf 86 43 80 00 00 	movabs $0x804386,%rdi
  800833:	00 00 00 
  800836:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba 7c 46 80 00 00 	movabs $0x80467c,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba 90 46 80 00 00 	movabs $0x804690,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf e1 43 80 00 00 	movabs $0x8043e1,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba ab 46 80 00 00 	movabs $0x8046ab,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf e7 46 80 00 00 	movabs $0x8046e7,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  800997:	00 00 00 
  80099a:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba fa 46 80 00 00 	movabs $0x8046fa,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 a7 1d 80 00 00 	movabs $0x801da7,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 e5 30 80 00 00 	movabs $0x8030e5,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba 09 47 80 00 00 	movabs $0x804709,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba 1b 47 80 00 00 	movabs $0x80471b,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 70 30 80 00 00 	movabs $0x803070,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba 29 47 80 00 00 	movabs $0x804729,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 20 0d 80 00 00 	movabs $0x800d20,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf ab 43 80 00 00 	movabs $0x8043ab,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf 97 47 80 00 00 	movabs $0x804797,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800c89:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9a:	48 98                	cltq   
  800c9c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800ca3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800caa:	00 00 00 
  800cad:	48 01 c2             	add    %rax,%rdx
  800cb0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cb7:	00 00 00 
  800cba:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc1:	7e 14                	jle    800cd7 <libmain+0x5d>
		binaryname = argv[0];
  800cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc7:	48 8b 10             	mov    (%rax),%rdx
  800cca:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cd1:	00 00 00 
  800cd4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cde:	48 89 d6             	mov    %rdx,%rsi
  800ce1:	89 c7                	mov    %eax,%edi
  800ce3:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cea:	00 00 00 
  800ced:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800cef:	48 b8 fd 0c 80 00 00 	movabs $0x800cfd,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
}
  800cfb:	c9                   	leaveq 
  800cfc:	c3                   	retq   

0000000000800cfd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800cfd:	55                   	push   %rbp
  800cfe:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d01:	48 b8 c4 2d 80 00 00 	movabs $0x802dc4,%rax
  800d08:	00 00 00 
  800d0b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d12:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	callq  *%rax

}
  800d1e:	5d                   	pop    %rbp
  800d1f:	c3                   	retq   

0000000000800d20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d20:	55                   	push   %rbp
  800d21:	48 89 e5             	mov    %rsp,%rbp
  800d24:	53                   	push   %rbx
  800d25:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d2c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d33:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 23                	je     800d75 <_panic+0x55>
  800d52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d75:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d7c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d83:	00 00 00 
  800d86:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d8d:	00 00 00 
  800d90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d94:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800da2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800da9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800db0:	00 00 00 
  800db3:	48 8b 18             	mov    (%rax),%rbx
  800db6:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
  800dc2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dc8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dcf:	41 89 c8             	mov    %ecx,%r8d
  800dd2:	48 89 d1             	mov    %rdx,%rcx
  800dd5:	48 89 da             	mov    %rbx,%rdx
  800dd8:	89 c6                	mov    %eax,%esi
  800dda:	48 bf b8 47 80 00 00 	movabs $0x8047b8,%rdi
  800de1:	00 00 00 
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	49 b9 59 0f 80 00 00 	movabs $0x800f59,%r9
  800df0:	00 00 00 
  800df3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800df6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800dfd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e04:	48 89 d6             	mov    %rdx,%rsi
  800e07:	48 89 c7             	mov    %rax,%rdi
  800e0a:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	callq  *%rax
	cprintf("\n");
  800e16:	48 bf db 47 80 00 00 	movabs $0x8047db,%rdi
  800e1d:	00 00 00 
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800e2c:	00 00 00 
  800e2f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e31:	cc                   	int3   
  800e32:	eb fd                	jmp    800e31 <_panic+0x111>

0000000000800e34 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 10          	sub    $0x10,%rsp
  800e3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e47:	8b 00                	mov    (%rax),%eax
  800e49:	8d 48 01             	lea    0x1(%rax),%ecx
  800e4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e50:	89 0a                	mov    %ecx,(%rdx)
  800e52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5b:	48 98                	cltq   
  800e5d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	8b 00                	mov    (%rax),%eax
  800e67:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e6c:	75 2c                	jne    800e9a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	8b 00                	mov    (%rax),%eax
  800e74:	48 98                	cltq   
  800e76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e7a:	48 83 c2 08          	add    $0x8,%rdx
  800e7e:	48 89 c6             	mov    %rax,%rsi
  800e81:	48 89 d7             	mov    %rdx,%rdi
  800e84:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
        b->idx = 0;
  800e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	8b 40 04             	mov    0x4(%rax),%eax
  800ea1:	8d 50 01             	lea    0x1(%rax),%edx
  800ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea8:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eab:	c9                   	leaveq 
  800eac:	c3                   	retq   

0000000000800ead <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ead:	55                   	push   %rbp
  800eae:	48 89 e5             	mov    %rsp,%rbp
  800eb1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800eb8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ebf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ec6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ecd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ed4:	48 8b 0a             	mov    (%rdx),%rcx
  800ed7:	48 89 08             	mov    %rcx,(%rax)
  800eda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ede:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800eea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ef1:	00 00 00 
    b.cnt = 0;
  800ef4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800efb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800efe:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f05:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f0c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f13:	48 89 c6             	mov    %rax,%rsi
  800f16:	48 bf 34 0e 80 00 00 	movabs $0x800e34,%rdi
  800f1d:	00 00 00 
  800f20:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f2c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f32:	48 98                	cltq   
  800f34:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f3b:	48 83 c2 08          	add    $0x8,%rdx
  800f3f:	48 89 c6             	mov    %rax,%rsi
  800f42:	48 89 d7             	mov    %rdx,%rdi
  800f45:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f51:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f57:	c9                   	leaveq 
  800f58:	c3                   	retq   

0000000000800f59 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
  800f5d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f64:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f6b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f87:	84 c0                	test   %al,%al
  800f89:	74 20                	je     800fab <cprintf+0x52>
  800f8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800fb2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fb9:	00 00 00 
  800fbc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc3:	00 00 00 
  800fc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fdf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fed:	48 8b 0a             	mov    (%rdx),%rcx
  800ff0:	48 89 08             	mov    %rcx,(%rax)
  800ff3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801003:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80100a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801011:	48 89 d6             	mov    %rdx,%rsi
  801014:	48 89 c7             	mov    %rax,%rdi
  801017:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  80101e:	00 00 00 
  801021:	ff d0                	callq  *%rax
  801023:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801029:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	53                   	push   %rbx
  801036:	48 83 ec 38          	sub    $0x38,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801042:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801046:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801049:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80104d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801051:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801054:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801058:	77 3b                	ja     801095 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80105a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80105d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801061:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	48 f7 f3             	div    %rbx
  801070:	48 89 c2             	mov    %rax,%rdx
  801073:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801076:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801079:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80107d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801081:	41 89 f9             	mov    %edi,%r9d
  801084:	48 89 c7             	mov    %rax,%rdi
  801087:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  80108e:	00 00 00 
  801091:	ff d0                	callq  *%rax
  801093:	eb 1e                	jmp    8010b3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801095:	eb 12                	jmp    8010a9 <printnum+0x78>
			putch(padc, putdat);
  801097:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80109b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 89 ce             	mov    %rcx,%rsi
  8010a5:	89 d7                	mov    %edx,%edi
  8010a7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010b1:	7f e4                	jg     801097 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bf:	48 f7 f1             	div    %rcx
  8010c2:	48 89 d0             	mov    %rdx,%rax
  8010c5:	48 ba d0 49 80 00 00 	movabs $0x8049d0,%rdx
  8010cc:	00 00 00 
  8010cf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010d3:	0f be d0             	movsbl %al,%edx
  8010d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 89 ce             	mov    %rcx,%rsi
  8010e1:	89 d7                	mov    %edx,%edi
  8010e3:	ff d0                	callq  *%rax
}
  8010e5:	48 83 c4 38          	add    $0x38,%rsp
  8010e9:	5b                   	pop    %rbx
  8010ea:	5d                   	pop    %rbp
  8010eb:	c3                   	retq   

00000000008010ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010ec:	55                   	push   %rbp
  8010ed:	48 89 e5             	mov    %rsp,%rbp
  8010f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8010f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010ff:	7e 52                	jle    801153 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	8b 00                	mov    (%rax),%eax
  801107:	83 f8 30             	cmp    $0x30,%eax
  80110a:	73 24                	jae    801130 <getuint+0x44>
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	8b 00                	mov    (%rax),%eax
  80111a:	89 c0                	mov    %eax,%eax
  80111c:	48 01 d0             	add    %rdx,%rax
  80111f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801123:	8b 12                	mov    (%rdx),%edx
  801125:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801128:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80112c:	89 0a                	mov    %ecx,(%rdx)
  80112e:	eb 17                	jmp    801147 <getuint+0x5b>
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801138:	48 89 d0             	mov    %rdx,%rax
  80113b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80113f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801143:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801147:	48 8b 00             	mov    (%rax),%rax
  80114a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80114e:	e9 a3 00 00 00       	jmpq   8011f6 <getuint+0x10a>
	else if (lflag)
  801153:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801157:	74 4f                	je     8011a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	8b 00                	mov    (%rax),%eax
  80115f:	83 f8 30             	cmp    $0x30,%eax
  801162:	73 24                	jae    801188 <getuint+0x9c>
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	8b 00                	mov    (%rax),%eax
  801172:	89 c0                	mov    %eax,%eax
  801174:	48 01 d0             	add    %rdx,%rax
  801177:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117b:	8b 12                	mov    (%rdx),%edx
  80117d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801180:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801184:	89 0a                	mov    %ecx,(%rdx)
  801186:	eb 17                	jmp    80119f <getuint+0xb3>
  801188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801190:	48 89 d0             	mov    %rdx,%rax
  801193:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80119f:	48 8b 00             	mov    (%rax),%rax
  8011a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011a6:	eb 4e                	jmp    8011f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	8b 00                	mov    (%rax),%eax
  8011ae:	83 f8 30             	cmp    $0x30,%eax
  8011b1:	73 24                	jae    8011d7 <getuint+0xeb>
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	8b 00                	mov    (%rax),%eax
  8011c1:	89 c0                	mov    %eax,%eax
  8011c3:	48 01 d0             	add    %rdx,%rax
  8011c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ca:	8b 12                	mov    (%rdx),%edx
  8011cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d3:	89 0a                	mov    %ecx,(%rdx)
  8011d5:	eb 17                	jmp    8011ee <getuint+0x102>
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011df:	48 89 d0             	mov    %rdx,%rax
  8011e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ee:	8b 00                	mov    (%rax),%eax
  8011f0:	89 c0                	mov    %eax,%eax
  8011f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 1c          	sub    $0x1c,%rsp
  801204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801208:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80120b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80120f:	7e 52                	jle    801263 <getint+0x67>
		x=va_arg(*ap, long long);
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	8b 00                	mov    (%rax),%eax
  801217:	83 f8 30             	cmp    $0x30,%eax
  80121a:	73 24                	jae    801240 <getint+0x44>
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	8b 00                	mov    (%rax),%eax
  80122a:	89 c0                	mov    %eax,%eax
  80122c:	48 01 d0             	add    %rdx,%rax
  80122f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801233:	8b 12                	mov    (%rdx),%edx
  801235:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801238:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123c:	89 0a                	mov    %ecx,(%rdx)
  80123e:	eb 17                	jmp    801257 <getint+0x5b>
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801244:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801248:	48 89 d0             	mov    %rdx,%rax
  80124b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80124f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801253:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801257:	48 8b 00             	mov    (%rax),%rax
  80125a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80125e:	e9 a3 00 00 00       	jmpq   801306 <getint+0x10a>
	else if (lflag)
  801263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801267:	74 4f                	je     8012b8 <getint+0xbc>
		x=va_arg(*ap, long);
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126d:	8b 00                	mov    (%rax),%eax
  80126f:	83 f8 30             	cmp    $0x30,%eax
  801272:	73 24                	jae    801298 <getint+0x9c>
  801274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801278:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	8b 00                	mov    (%rax),%eax
  801282:	89 c0                	mov    %eax,%eax
  801284:	48 01 d0             	add    %rdx,%rax
  801287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128b:	8b 12                	mov    (%rdx),%edx
  80128d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801290:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801294:	89 0a                	mov    %ecx,(%rdx)
  801296:	eb 17                	jmp    8012af <getint+0xb3>
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012a0:	48 89 d0             	mov    %rdx,%rax
  8012a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012af:	48 8b 00             	mov    (%rax),%rax
  8012b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012b6:	eb 4e                	jmp    801306 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	8b 00                	mov    (%rax),%eax
  8012be:	83 f8 30             	cmp    $0x30,%eax
  8012c1:	73 24                	jae    8012e7 <getint+0xeb>
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	8b 00                	mov    (%rax),%eax
  8012d1:	89 c0                	mov    %eax,%eax
  8012d3:	48 01 d0             	add    %rdx,%rax
  8012d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012da:	8b 12                	mov    (%rdx),%edx
  8012dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e3:	89 0a                	mov    %ecx,(%rdx)
  8012e5:	eb 17                	jmp    8012fe <getint+0x102>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ef:	48 89 d0             	mov    %rdx,%rax
  8012f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012fe:	8b 00                	mov    (%rax),%eax
  801300:	48 98                	cltq   
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	41 54                	push   %r12
  801312:	53                   	push   %rbx
  801313:	48 83 ec 60          	sub    $0x60,%rsp
  801317:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80131b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80131f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801323:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801327:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80132b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80132f:	48 8b 0a             	mov    (%rdx),%rcx
  801332:	48 89 08             	mov    %rcx,(%rax)
  801335:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801339:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80133d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801341:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801345:	eb 17                	jmp    80135e <vprintfmt+0x52>
			if (ch == '\0')
  801347:	85 db                	test   %ebx,%ebx
  801349:	0f 84 cc 04 00 00    	je     80181b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80134f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801353:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801357:	48 89 d6             	mov    %rdx,%rsi
  80135a:	89 df                	mov    %ebx,%edi
  80135c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80135e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801362:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801366:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	0f b6 d8             	movzbl %al,%ebx
  801370:	83 fb 25             	cmp    $0x25,%ebx
  801373:	75 d2                	jne    801347 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801375:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801379:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801380:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801387:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80138e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801395:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801399:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80139d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 d8             	movzbl %al,%ebx
  8013a7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013aa:	83 f8 55             	cmp    $0x55,%eax
  8013ad:	0f 87 34 04 00 00    	ja     8017e7 <vprintfmt+0x4db>
  8013b3:	89 c0                	mov    %eax,%eax
  8013b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013bc:	00 
  8013bd:	48 b8 f8 49 80 00 00 	movabs $0x8049f8,%rax
  8013c4:	00 00 00 
  8013c7:	48 01 d0             	add    %rdx,%rax
  8013ca:	48 8b 00             	mov    (%rax),%rax
  8013cd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8013cf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013d3:	eb c0                	jmp    801395 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013d5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013d9:	eb ba                	jmp    801395 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013e2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	c1 e0 02             	shl    $0x2,%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	01 c0                	add    %eax,%eax
  8013ee:	01 d8                	add    %ebx,%eax
  8013f0:	83 e8 30             	sub    $0x30,%eax
  8013f3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8013f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801400:	83 fb 2f             	cmp    $0x2f,%ebx
  801403:	7e 0c                	jle    801411 <vprintfmt+0x105>
  801405:	83 fb 39             	cmp    $0x39,%ebx
  801408:	7f 07                	jg     801411 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80140a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80140f:	eb d1                	jmp    8013e2 <vprintfmt+0xd6>
			goto process_precision;
  801411:	eb 58                	jmp    80146b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801413:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801416:	83 f8 30             	cmp    $0x30,%eax
  801419:	73 17                	jae    801432 <vprintfmt+0x126>
  80141b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80141f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801422:	89 c0                	mov    %eax,%eax
  801424:	48 01 d0             	add    %rdx,%rax
  801427:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80142a:	83 c2 08             	add    $0x8,%edx
  80142d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801430:	eb 0f                	jmp    801441 <vprintfmt+0x135>
  801432:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801436:	48 89 d0             	mov    %rdx,%rax
  801439:	48 83 c2 08          	add    $0x8,%rdx
  80143d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801441:	8b 00                	mov    (%rax),%eax
  801443:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801446:	eb 23                	jmp    80146b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801448:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80144c:	79 0c                	jns    80145a <vprintfmt+0x14e>
				width = 0;
  80144e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801455:	e9 3b ff ff ff       	jmpq   801395 <vprintfmt+0x89>
  80145a:	e9 36 ff ff ff       	jmpq   801395 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80145f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801466:	e9 2a ff ff ff       	jmpq   801395 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80146b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80146f:	79 12                	jns    801483 <vprintfmt+0x177>
				width = precision, precision = -1;
  801471:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801474:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801477:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80147e:	e9 12 ff ff ff       	jmpq   801395 <vprintfmt+0x89>
  801483:	e9 0d ff ff ff       	jmpq   801395 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801488:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80148c:	e9 04 ff ff ff       	jmpq   801395 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801491:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801494:	83 f8 30             	cmp    $0x30,%eax
  801497:	73 17                	jae    8014b0 <vprintfmt+0x1a4>
  801499:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80149d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a0:	89 c0                	mov    %eax,%eax
  8014a2:	48 01 d0             	add    %rdx,%rax
  8014a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014a8:	83 c2 08             	add    $0x8,%edx
  8014ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014ae:	eb 0f                	jmp    8014bf <vprintfmt+0x1b3>
  8014b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014b4:	48 89 d0             	mov    %rdx,%rax
  8014b7:	48 83 c2 08          	add    $0x8,%rdx
  8014bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014bf:	8b 10                	mov    (%rax),%edx
  8014c1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c9:	48 89 ce             	mov    %rcx,%rsi
  8014cc:	89 d7                	mov    %edx,%edi
  8014ce:	ff d0                	callq  *%rax
			break;
  8014d0:	e9 40 03 00 00       	jmpq   801815 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8014d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014d8:	83 f8 30             	cmp    $0x30,%eax
  8014db:	73 17                	jae    8014f4 <vprintfmt+0x1e8>
  8014dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e4:	89 c0                	mov    %eax,%eax
  8014e6:	48 01 d0             	add    %rdx,%rax
  8014e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014ec:	83 c2 08             	add    $0x8,%edx
  8014ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014f2:	eb 0f                	jmp    801503 <vprintfmt+0x1f7>
  8014f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014f8:	48 89 d0             	mov    %rdx,%rax
  8014fb:	48 83 c2 08          	add    $0x8,%rdx
  8014ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801503:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801505:	85 db                	test   %ebx,%ebx
  801507:	79 02                	jns    80150b <vprintfmt+0x1ff>
				err = -err;
  801509:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80150b:	83 fb 15             	cmp    $0x15,%ebx
  80150e:	7f 16                	jg     801526 <vprintfmt+0x21a>
  801510:	48 b8 20 49 80 00 00 	movabs $0x804920,%rax
  801517:	00 00 00 
  80151a:	48 63 d3             	movslq %ebx,%rdx
  80151d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801521:	4d 85 e4             	test   %r12,%r12
  801524:	75 2e                	jne    801554 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801526:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80152a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80152e:	89 d9                	mov    %ebx,%ecx
  801530:	48 ba e1 49 80 00 00 	movabs $0x8049e1,%rdx
  801537:	00 00 00 
  80153a:	48 89 c7             	mov    %rax,%rdi
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	49 b8 24 18 80 00 00 	movabs $0x801824,%r8
  801549:	00 00 00 
  80154c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80154f:	e9 c1 02 00 00       	jmpq   801815 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801554:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801558:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80155c:	4c 89 e1             	mov    %r12,%rcx
  80155f:	48 ba ea 49 80 00 00 	movabs $0x8049ea,%rdx
  801566:	00 00 00 
  801569:	48 89 c7             	mov    %rax,%rdi
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	49 b8 24 18 80 00 00 	movabs $0x801824,%r8
  801578:	00 00 00 
  80157b:	41 ff d0             	callq  *%r8
			break;
  80157e:	e9 92 02 00 00       	jmpq   801815 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801583:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801586:	83 f8 30             	cmp    $0x30,%eax
  801589:	73 17                	jae    8015a2 <vprintfmt+0x296>
  80158b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80158f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801592:	89 c0                	mov    %eax,%eax
  801594:	48 01 d0             	add    %rdx,%rax
  801597:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80159a:	83 c2 08             	add    $0x8,%edx
  80159d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015a0:	eb 0f                	jmp    8015b1 <vprintfmt+0x2a5>
  8015a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015a6:	48 89 d0             	mov    %rdx,%rax
  8015a9:	48 83 c2 08          	add    $0x8,%rdx
  8015ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015b1:	4c 8b 20             	mov    (%rax),%r12
  8015b4:	4d 85 e4             	test   %r12,%r12
  8015b7:	75 0a                	jne    8015c3 <vprintfmt+0x2b7>
				p = "(null)";
  8015b9:	49 bc ed 49 80 00 00 	movabs $0x8049ed,%r12
  8015c0:	00 00 00 
			if (width > 0 && padc != '-')
  8015c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015c7:	7e 3f                	jle    801608 <vprintfmt+0x2fc>
  8015c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015cd:	74 39                	je     801608 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015d2:	48 98                	cltq   
  8015d4:	48 89 c6             	mov    %rax,%rsi
  8015d7:	4c 89 e7             	mov    %r12,%rdi
  8015da:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
  8015e6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015e9:	eb 17                	jmp    801602 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8015eb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015ef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8015f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015f7:	48 89 ce             	mov    %rcx,%rsi
  8015fa:	89 d7                	mov    %edx,%edi
  8015fc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801602:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801606:	7f e3                	jg     8015eb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801608:	eb 37                	jmp    801641 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80160a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80160e:	74 1e                	je     80162e <vprintfmt+0x322>
  801610:	83 fb 1f             	cmp    $0x1f,%ebx
  801613:	7e 05                	jle    80161a <vprintfmt+0x30e>
  801615:	83 fb 7e             	cmp    $0x7e,%ebx
  801618:	7e 14                	jle    80162e <vprintfmt+0x322>
					putch('?', putdat);
  80161a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80161e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801622:	48 89 d6             	mov    %rdx,%rsi
  801625:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80162a:	ff d0                	callq  *%rax
  80162c:	eb 0f                	jmp    80163d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80162e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801632:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801636:	48 89 d6             	mov    %rdx,%rsi
  801639:	89 df                	mov    %ebx,%edi
  80163b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80163d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801641:	4c 89 e0             	mov    %r12,%rax
  801644:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	0f be d8             	movsbl %al,%ebx
  80164e:	85 db                	test   %ebx,%ebx
  801650:	74 10                	je     801662 <vprintfmt+0x356>
  801652:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801656:	78 b2                	js     80160a <vprintfmt+0x2fe>
  801658:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80165c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801660:	79 a8                	jns    80160a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801662:	eb 16                	jmp    80167a <vprintfmt+0x36e>
				putch(' ', putdat);
  801664:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801668:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80166c:	48 89 d6             	mov    %rdx,%rsi
  80166f:	bf 20 00 00 00       	mov    $0x20,%edi
  801674:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801676:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80167a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80167e:	7f e4                	jg     801664 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801680:	e9 90 01 00 00       	jmpq   801815 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801685:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801689:	be 03 00 00 00       	mov    $0x3,%esi
  80168e:	48 89 c7             	mov    %rax,%rdi
  801691:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  801698:	00 00 00 
  80169b:	ff d0                	callq  *%rax
  80169d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a5:	48 85 c0             	test   %rax,%rax
  8016a8:	79 1d                	jns    8016c7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8016aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016b2:	48 89 d6             	mov    %rdx,%rsi
  8016b5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016ba:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c0:	48 f7 d8             	neg    %rax
  8016c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016c7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016ce:	e9 d5 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016d3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016d7:	be 03 00 00 00       	mov    $0x3,%esi
  8016dc:	48 89 c7             	mov    %rax,%rdi
  8016df:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
  8016eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016ef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016f6:	e9 ad 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8016fb:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8016fe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801702:	89 d6                	mov    %edx,%esi
  801704:	48 89 c7             	mov    %rax,%rdi
  801707:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  80170e:	00 00 00 
  801711:	ff d0                	callq  *%rax
  801713:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801717:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80171e:	e9 85 00 00 00       	jmpq   8017a8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801723:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801727:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80172b:	48 89 d6             	mov    %rdx,%rsi
  80172e:	bf 30 00 00 00       	mov    $0x30,%edi
  801733:	ff d0                	callq  *%rax
			putch('x', putdat);
  801735:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801739:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80173d:	48 89 d6             	mov    %rdx,%rsi
  801740:	bf 78 00 00 00       	mov    $0x78,%edi
  801745:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801747:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80174a:	83 f8 30             	cmp    $0x30,%eax
  80174d:	73 17                	jae    801766 <vprintfmt+0x45a>
  80174f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801753:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801756:	89 c0                	mov    %eax,%eax
  801758:	48 01 d0             	add    %rdx,%rax
  80175b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80175e:	83 c2 08             	add    $0x8,%edx
  801761:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801764:	eb 0f                	jmp    801775 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801766:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80176a:	48 89 d0             	mov    %rdx,%rax
  80176d:	48 83 c2 08          	add    $0x8,%rdx
  801771:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801775:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801778:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80177c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801783:	eb 23                	jmp    8017a8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801785:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801789:	be 03 00 00 00       	mov    $0x3,%esi
  80178e:	48 89 c7             	mov    %rax,%rdi
  801791:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  801798:	00 00 00 
  80179b:	ff d0                	callq  *%rax
  80179d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017a1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017a8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017ad:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017b0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017bf:	45 89 c1             	mov    %r8d,%r9d
  8017c2:	41 89 f8             	mov    %edi,%r8d
  8017c5:	48 89 c7             	mov    %rax,%rdi
  8017c8:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  8017cf:	00 00 00 
  8017d2:	ff d0                	callq  *%rax
			break;
  8017d4:	eb 3f                	jmp    801815 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017de:	48 89 d6             	mov    %rdx,%rsi
  8017e1:	89 df                	mov    %ebx,%edi
  8017e3:	ff d0                	callq  *%rax
			break;
  8017e5:	eb 2e                	jmp    801815 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ef:	48 89 d6             	mov    %rdx,%rsi
  8017f2:	bf 25 00 00 00       	mov    $0x25,%edi
  8017f7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017f9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017fe:	eb 05                	jmp    801805 <vprintfmt+0x4f9>
  801800:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801805:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801809:	48 83 e8 01          	sub    $0x1,%rax
  80180d:	0f b6 00             	movzbl (%rax),%eax
  801810:	3c 25                	cmp    $0x25,%al
  801812:	75 ec                	jne    801800 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801814:	90                   	nop
		}
	}
  801815:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801816:	e9 43 fb ff ff       	jmpq   80135e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80181b:	48 83 c4 60          	add    $0x60,%rsp
  80181f:	5b                   	pop    %rbx
  801820:	41 5c                	pop    %r12
  801822:	5d                   	pop    %rbp
  801823:	c3                   	retq   

0000000000801824 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80182f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801836:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80183d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801844:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80184b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801852:	84 c0                	test   %al,%al
  801854:	74 20                	je     801876 <printfmt+0x52>
  801856:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80185a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80185e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801862:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801866:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80186a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80186e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801872:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801876:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80187d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801884:	00 00 00 
  801887:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80188e:	00 00 00 
  801891:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801895:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80189c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018a3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018aa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018b8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018bf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 10          	sub    $0x10,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ea:	8b 40 10             	mov    0x10(%rax),%eax
  8018ed:	8d 50 01             	lea    0x1(%rax),%edx
  8018f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fb:	48 8b 10             	mov    (%rax),%rdx
  8018fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801902:	48 8b 40 08          	mov    0x8(%rax),%rax
  801906:	48 39 c2             	cmp    %rax,%rdx
  801909:	73 17                	jae    801922 <sprintputch+0x4b>
		*b->buf++ = ch;
  80190b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190f:	48 8b 00             	mov    (%rax),%rax
  801912:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191a:	48 89 0a             	mov    %rcx,(%rdx)
  80191d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801920:	88 10                	mov    %dl,(%rax)
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 50          	sub    $0x50,%rsp
  80192c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801930:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801933:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801937:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80193b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80193f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801943:	48 8b 0a             	mov    (%rdx),%rcx
  801946:	48 89 08             	mov    %rcx,(%rax)
  801949:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80194d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801951:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801955:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801959:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80195d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801961:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801964:	48 98                	cltq   
  801966:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80196a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80196e:	48 01 d0             	add    %rdx,%rax
  801971:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80197c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801981:	74 06                	je     801989 <vsnprintf+0x65>
  801983:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801987:	7f 07                	jg     801990 <vsnprintf+0x6c>
		return -E_INVAL;
  801989:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198e:	eb 2f                	jmp    8019bf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801990:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801994:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801998:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80199c:	48 89 c6             	mov    %rax,%rsi
  80199f:	48 bf d7 18 80 00 00 	movabs $0x8018d7,%rdi
  8019a6:	00 00 00 
  8019a9:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019bf:	c9                   	leaveq 
  8019c0:	c3                   	retq   

00000000008019c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019c1:	55                   	push   %rbp
  8019c2:	48 89 e5             	mov    %rsp,%rbp
  8019c5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019d3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019d9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019e0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019e7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019ee:	84 c0                	test   %al,%al
  8019f0:	74 20                	je     801a12 <snprintf+0x51>
  8019f2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019f6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8019fa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019fe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a12:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a19:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a20:	00 00 00 
  801a23:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a2a:	00 00 00 
  801a2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a31:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a46:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a4d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a54:	48 8b 0a             	mov    (%rdx),%rcx
  801a57:	48 89 08             	mov    %rcx,(%rax)
  801a5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a6a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a71:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a78:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a7e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
  801a94:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a9a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 18          	sub    $0x18,%rsp
  801aaa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801aae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ab5:	eb 09                	jmp    801ac0 <strlen+0x1e>
		n++;
  801ab7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801abb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac4:	0f b6 00             	movzbl (%rax),%eax
  801ac7:	84 c0                	test   %al,%al
  801ac9:	75 ec                	jne    801ab7 <strlen+0x15>
		n++;
	return n;
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801adc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ae7:	eb 0e                	jmp    801af7 <strnlen+0x27>
		n++;
  801ae9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aed:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801af2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801af7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801afc:	74 0b                	je     801b09 <strnlen+0x39>
  801afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b02:	0f b6 00             	movzbl (%rax),%eax
  801b05:	84 c0                	test   %al,%al
  801b07:	75 e0                	jne    801ae9 <strnlen+0x19>
		n++;
	return n;
  801b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 20          	sub    $0x20,%rsp
  801b16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b26:	90                   	nop
  801b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b37:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b3b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b3f:	0f b6 12             	movzbl (%rdx),%edx
  801b42:	88 10                	mov    %dl,(%rax)
  801b44:	0f b6 00             	movzbl (%rax),%eax
  801b47:	84 c0                	test   %al,%al
  801b49:	75 dc                	jne    801b27 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b4f:	c9                   	leaveq 
  801b50:	c3                   	retq   

0000000000801b51 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b51:	55                   	push   %rbp
  801b52:	48 89 e5             	mov    %rsp,%rbp
  801b55:	48 83 ec 20          	sub    $0x20,%rsp
  801b59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b65:	48 89 c7             	mov    %rax,%rdi
  801b68:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
  801b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7a:	48 63 d0             	movslq %eax,%rdx
  801b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b81:	48 01 c2             	add    %rax,%rdx
  801b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b88:	48 89 c6             	mov    %rax,%rsi
  801b8b:	48 89 d7             	mov    %rdx,%rdi
  801b8e:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
	return dst;
  801b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b9e:	c9                   	leaveq 
  801b9f:	c3                   	retq   

0000000000801ba0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ba0:	55                   	push   %rbp
  801ba1:	48 89 e5             	mov    %rsp,%rbp
  801ba4:	48 83 ec 28          	sub    $0x28,%rsp
  801ba8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bbc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801bc3:	00 
  801bc4:	eb 2a                	jmp    801bf0 <strncpy+0x50>
		*dst++ = *src;
  801bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bd6:	0f b6 12             	movzbl (%rdx),%edx
  801bd9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bdf:	0f b6 00             	movzbl (%rax),%eax
  801be2:	84 c0                	test   %al,%al
  801be4:	74 05                	je     801beb <strncpy+0x4b>
			src++;
  801be6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801beb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801bf8:	72 cc                	jb     801bc6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801bfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 28          	sub    $0x28,%rsp
  801c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c1c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c21:	74 3d                	je     801c60 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c23:	eb 1d                	jmp    801c42 <strlcpy+0x42>
			*dst++ = *src++;
  801c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c29:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c35:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c39:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c3d:	0f b6 12             	movzbl (%rdx),%edx
  801c40:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c42:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c47:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c4c:	74 0b                	je     801c59 <strlcpy+0x59>
  801c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c52:	0f b6 00             	movzbl (%rax),%eax
  801c55:	84 c0                	test   %al,%al
  801c57:	75 cc                	jne    801c25 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c68:	48 29 c2             	sub    %rax,%rdx
  801c6b:	48 89 d0             	mov    %rdx,%rax
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 10          	sub    $0x10,%rsp
  801c78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c80:	eb 0a                	jmp    801c8c <strcmp+0x1c>
		p++, q++;
  801c82:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c87:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c90:	0f b6 00             	movzbl (%rax),%eax
  801c93:	84 c0                	test   %al,%al
  801c95:	74 12                	je     801ca9 <strcmp+0x39>
  801c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9b:	0f b6 10             	movzbl (%rax),%edx
  801c9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca2:	0f b6 00             	movzbl (%rax),%eax
  801ca5:	38 c2                	cmp    %al,%dl
  801ca7:	74 d9                	je     801c82 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ca9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cad:	0f b6 00             	movzbl (%rax),%eax
  801cb0:	0f b6 d0             	movzbl %al,%edx
  801cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb7:	0f b6 00             	movzbl (%rax),%eax
  801cba:	0f b6 c0             	movzbl %al,%eax
  801cbd:	29 c2                	sub    %eax,%edx
  801cbf:	89 d0                	mov    %edx,%eax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 18          	sub    $0x18,%rsp
  801ccb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801cd7:	eb 0f                	jmp    801ce8 <strncmp+0x25>
		n--, p++, q++;
  801cd9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801cde:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ce3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ce8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ced:	74 1d                	je     801d0c <strncmp+0x49>
  801cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf3:	0f b6 00             	movzbl (%rax),%eax
  801cf6:	84 c0                	test   %al,%al
  801cf8:	74 12                	je     801d0c <strncmp+0x49>
  801cfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfe:	0f b6 10             	movzbl (%rax),%edx
  801d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d05:	0f b6 00             	movzbl (%rax),%eax
  801d08:	38 c2                	cmp    %al,%dl
  801d0a:	74 cd                	je     801cd9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d11:	75 07                	jne    801d1a <strncmp+0x57>
		return 0;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	eb 18                	jmp    801d32 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	0f b6 d0             	movzbl %al,%edx
  801d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d28:	0f b6 00             	movzbl (%rax),%eax
  801d2b:	0f b6 c0             	movzbl %al,%eax
  801d2e:	29 c2                	sub    %eax,%edx
  801d30:	89 d0                	mov    %edx,%eax
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 0c          	sub    $0xc,%rsp
  801d3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d40:	89 f0                	mov    %esi,%eax
  801d42:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d45:	eb 17                	jmp    801d5e <strchr+0x2a>
		if (*s == c)
  801d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4b:	0f b6 00             	movzbl (%rax),%eax
  801d4e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d51:	75 06                	jne    801d59 <strchr+0x25>
			return (char *) s;
  801d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d57:	eb 15                	jmp    801d6e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d59:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d62:	0f b6 00             	movzbl (%rax),%eax
  801d65:	84 c0                	test   %al,%al
  801d67:	75 de                	jne    801d47 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 0c          	sub    $0xc,%rsp
  801d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d81:	eb 13                	jmp    801d96 <strfind+0x26>
		if (*s == c)
  801d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d87:	0f b6 00             	movzbl (%rax),%eax
  801d8a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d8d:	75 02                	jne    801d91 <strfind+0x21>
			break;
  801d8f:	eb 10                	jmp    801da1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9a:	0f b6 00             	movzbl (%rax),%eax
  801d9d:	84 c0                	test   %al,%al
  801d9f:	75 e2                	jne    801d83 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801da5:	c9                   	leaveq 
  801da6:	c3                   	retq   

0000000000801da7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801da7:	55                   	push   %rbp
  801da8:	48 89 e5             	mov    %rsp,%rbp
  801dab:	48 83 ec 18          	sub    $0x18,%rsp
  801daf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801db3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801db6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dbf:	75 06                	jne    801dc7 <memset+0x20>
		return v;
  801dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc5:	eb 69                	jmp    801e30 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcb:	83 e0 03             	and    $0x3,%eax
  801dce:	48 85 c0             	test   %rax,%rax
  801dd1:	75 48                	jne    801e1b <memset+0x74>
  801dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd7:	83 e0 03             	and    $0x3,%eax
  801dda:	48 85 c0             	test   %rax,%rax
  801ddd:	75 3c                	jne    801e1b <memset+0x74>
		c &= 0xFF;
  801ddf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801de6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de9:	c1 e0 18             	shl    $0x18,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df1:	c1 e0 10             	shl    $0x10,%eax
  801df4:	09 c2                	or     %eax,%edx
  801df6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df9:	c1 e0 08             	shl    $0x8,%eax
  801dfc:	09 d0                	or     %edx,%eax
  801dfe:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e05:	48 c1 e8 02          	shr    $0x2,%rax
  801e09:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e10:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e13:	48 89 d7             	mov    %rdx,%rdi
  801e16:	fc                   	cld    
  801e17:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e19:	eb 11                	jmp    801e2c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e22:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e26:	48 89 d7             	mov    %rdx,%rdi
  801e29:	fc                   	cld    
  801e2a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801e2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 28          	sub    $0x28,%rsp
  801e3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e42:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e5e:	0f 83 88 00 00 00    	jae    801eec <memmove+0xba>
  801e64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e6c:	48 01 d0             	add    %rdx,%rax
  801e6f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e73:	76 77                	jbe    801eec <memmove+0xba>
		s += n;
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e89:	83 e0 03             	and    $0x3,%eax
  801e8c:	48 85 c0             	test   %rax,%rax
  801e8f:	75 3b                	jne    801ecc <memmove+0x9a>
  801e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e95:	83 e0 03             	and    $0x3,%eax
  801e98:	48 85 c0             	test   %rax,%rax
  801e9b:	75 2f                	jne    801ecc <memmove+0x9a>
  801e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea1:	83 e0 03             	and    $0x3,%eax
  801ea4:	48 85 c0             	test   %rax,%rax
  801ea7:	75 23                	jne    801ecc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ead:	48 83 e8 04          	sub    $0x4,%rax
  801eb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb5:	48 83 ea 04          	sub    $0x4,%rdx
  801eb9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ebd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ec1:	48 89 c7             	mov    %rax,%rdi
  801ec4:	48 89 d6             	mov    %rdx,%rsi
  801ec7:	fd                   	std    
  801ec8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801eca:	eb 1d                	jmp    801ee9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	48 89 d7             	mov    %rdx,%rdi
  801ee3:	48 89 c1             	mov    %rax,%rcx
  801ee6:	fd                   	std    
  801ee7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ee9:	fc                   	cld    
  801eea:	eb 57                	jmp    801f43 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801eec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef0:	83 e0 03             	and    $0x3,%eax
  801ef3:	48 85 c0             	test   %rax,%rax
  801ef6:	75 36                	jne    801f2e <memmove+0xfc>
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	83 e0 03             	and    $0x3,%eax
  801eff:	48 85 c0             	test   %rax,%rax
  801f02:	75 2a                	jne    801f2e <memmove+0xfc>
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	83 e0 03             	and    $0x3,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	75 1e                	jne    801f2e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f14:	48 c1 e8 02          	shr    $0x2,%rax
  801f18:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f23:	48 89 c7             	mov    %rax,%rdi
  801f26:	48 89 d6             	mov    %rdx,%rsi
  801f29:	fc                   	cld    
  801f2a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f2c:	eb 15                	jmp    801f43 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f36:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f3a:	48 89 c7             	mov    %rax,%rdi
  801f3d:	48 89 d6             	mov    %rdx,%rsi
  801f40:	fc                   	cld    
  801f41:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	48 83 ec 18          	sub    $0x18,%rsp
  801f51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f59:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f61:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f69:	48 89 ce             	mov    %rcx,%rsi
  801f6c:	48 89 c7             	mov    %rax,%rdi
  801f6f:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
  801f81:	48 83 ec 28          	sub    $0x28,%rsp
  801f85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f8d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f95:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fa1:	eb 36                	jmp    801fd9 <memcmp+0x5c>
		if (*s1 != *s2)
  801fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa7:	0f b6 10             	movzbl (%rax),%edx
  801faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fae:	0f b6 00             	movzbl (%rax),%eax
  801fb1:	38 c2                	cmp    %al,%dl
  801fb3:	74 1a                	je     801fcf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb9:	0f b6 00             	movzbl (%rax),%eax
  801fbc:	0f b6 d0             	movzbl %al,%edx
  801fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc3:	0f b6 00             	movzbl (%rax),%eax
  801fc6:	0f b6 c0             	movzbl %al,%eax
  801fc9:	29 c2                	sub    %eax,%edx
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	eb 20                	jmp    801fef <memcmp+0x72>
		s1++, s2++;
  801fcf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801fd4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801fe1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe5:	48 85 c0             	test   %rax,%rax
  801fe8:	75 b9                	jne    801fa3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 28          	sub    $0x28,%rsp
  801ff9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ffd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802008:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80200c:	48 01 d0             	add    %rdx,%rax
  80200f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802013:	eb 15                	jmp    80202a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	0f b6 10             	movzbl (%rax),%edx
  80201c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80201f:	38 c2                	cmp    %al,%dl
  802021:	75 02                	jne    802025 <memfind+0x34>
			break;
  802023:	eb 0f                	jmp    802034 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802025:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80202a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80202e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802032:	72 e1                	jb     802015 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802038:	c9                   	leaveq 
  802039:	c3                   	retq   

000000000080203a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80203a:	55                   	push   %rbp
  80203b:	48 89 e5             	mov    %rsp,%rbp
  80203e:	48 83 ec 34          	sub    $0x34,%rsp
  802042:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802046:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80204a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80204d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802054:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80205b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80205c:	eb 05                	jmp    802063 <strtol+0x29>
		s++;
  80205e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802063:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802067:	0f b6 00             	movzbl (%rax),%eax
  80206a:	3c 20                	cmp    $0x20,%al
  80206c:	74 f0                	je     80205e <strtol+0x24>
  80206e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802072:	0f b6 00             	movzbl (%rax),%eax
  802075:	3c 09                	cmp    $0x9,%al
  802077:	74 e5                	je     80205e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207d:	0f b6 00             	movzbl (%rax),%eax
  802080:	3c 2b                	cmp    $0x2b,%al
  802082:	75 07                	jne    80208b <strtol+0x51>
		s++;
  802084:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802089:	eb 17                	jmp    8020a2 <strtol+0x68>
	else if (*s == '-')
  80208b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208f:	0f b6 00             	movzbl (%rax),%eax
  802092:	3c 2d                	cmp    $0x2d,%al
  802094:	75 0c                	jne    8020a2 <strtol+0x68>
		s++, neg = 1;
  802096:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80209b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020a6:	74 06                	je     8020ae <strtol+0x74>
  8020a8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020ac:	75 28                	jne    8020d6 <strtol+0x9c>
  8020ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b2:	0f b6 00             	movzbl (%rax),%eax
  8020b5:	3c 30                	cmp    $0x30,%al
  8020b7:	75 1d                	jne    8020d6 <strtol+0x9c>
  8020b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bd:	48 83 c0 01          	add    $0x1,%rax
  8020c1:	0f b6 00             	movzbl (%rax),%eax
  8020c4:	3c 78                	cmp    $0x78,%al
  8020c6:	75 0e                	jne    8020d6 <strtol+0x9c>
		s += 2, base = 16;
  8020c8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020cd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020d4:	eb 2c                	jmp    802102 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020da:	75 19                	jne    8020f5 <strtol+0xbb>
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	0f b6 00             	movzbl (%rax),%eax
  8020e3:	3c 30                	cmp    $0x30,%al
  8020e5:	75 0e                	jne    8020f5 <strtol+0xbb>
		s++, base = 8;
  8020e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020ec:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020f3:	eb 0d                	jmp    802102 <strtol+0xc8>
	else if (base == 0)
  8020f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020f9:	75 07                	jne    802102 <strtol+0xc8>
		base = 10;
  8020fb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802102:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802106:	0f b6 00             	movzbl (%rax),%eax
  802109:	3c 2f                	cmp    $0x2f,%al
  80210b:	7e 1d                	jle    80212a <strtol+0xf0>
  80210d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802111:	0f b6 00             	movzbl (%rax),%eax
  802114:	3c 39                	cmp    $0x39,%al
  802116:	7f 12                	jg     80212a <strtol+0xf0>
			dig = *s - '0';
  802118:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211c:	0f b6 00             	movzbl (%rax),%eax
  80211f:	0f be c0             	movsbl %al,%eax
  802122:	83 e8 30             	sub    $0x30,%eax
  802125:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802128:	eb 4e                	jmp    802178 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80212a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212e:	0f b6 00             	movzbl (%rax),%eax
  802131:	3c 60                	cmp    $0x60,%al
  802133:	7e 1d                	jle    802152 <strtol+0x118>
  802135:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802139:	0f b6 00             	movzbl (%rax),%eax
  80213c:	3c 7a                	cmp    $0x7a,%al
  80213e:	7f 12                	jg     802152 <strtol+0x118>
			dig = *s - 'a' + 10;
  802140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802144:	0f b6 00             	movzbl (%rax),%eax
  802147:	0f be c0             	movsbl %al,%eax
  80214a:	83 e8 57             	sub    $0x57,%eax
  80214d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802150:	eb 26                	jmp    802178 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802152:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802156:	0f b6 00             	movzbl (%rax),%eax
  802159:	3c 40                	cmp    $0x40,%al
  80215b:	7e 48                	jle    8021a5 <strtol+0x16b>
  80215d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802161:	0f b6 00             	movzbl (%rax),%eax
  802164:	3c 5a                	cmp    $0x5a,%al
  802166:	7f 3d                	jg     8021a5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216c:	0f b6 00             	movzbl (%rax),%eax
  80216f:	0f be c0             	movsbl %al,%eax
  802172:	83 e8 37             	sub    $0x37,%eax
  802175:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802178:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80217e:	7c 02                	jl     802182 <strtol+0x148>
			break;
  802180:	eb 23                	jmp    8021a5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  802182:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802187:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80218a:	48 98                	cltq   
  80218c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802191:	48 89 c2             	mov    %rax,%rdx
  802194:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802197:	48 98                	cltq   
  802199:	48 01 d0             	add    %rdx,%rax
  80219c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021a0:	e9 5d ff ff ff       	jmpq   802102 <strtol+0xc8>

	if (endptr)
  8021a5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021aa:	74 0b                	je     8021b7 <strtol+0x17d>
		*endptr = (char *) s;
  8021ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021b4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bb:	74 09                	je     8021c6 <strtol+0x18c>
  8021bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c1:	48 f7 d8             	neg    %rax
  8021c4:	eb 04                	jmp    8021ca <strtol+0x190>
  8021c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021ca:	c9                   	leaveq 
  8021cb:	c3                   	retq   

00000000008021cc <strstr>:

char * strstr(const char *in, const char *str)
{
  8021cc:	55                   	push   %rbp
  8021cd:	48 89 e5             	mov    %rsp,%rbp
  8021d0:	48 83 ec 30          	sub    $0x30,%rsp
  8021d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8021dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021e4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021e8:	0f b6 00             	movzbl (%rax),%eax
  8021eb:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8021ee:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021f2:	75 06                	jne    8021fa <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8021f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f8:	eb 6b                	jmp    802265 <strstr+0x99>

	len = strlen(str);
  8021fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021fe:	48 89 c7             	mov    %rax,%rdi
  802201:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  802208:	00 00 00 
  80220b:	ff d0                	callq  *%rax
  80220d:	48 98                	cltq   
  80220f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802217:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80221b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80221f:	0f b6 00             	movzbl (%rax),%eax
  802222:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802225:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802229:	75 07                	jne    802232 <strstr+0x66>
				return (char *) 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	eb 33                	jmp    802265 <strstr+0x99>
		} while (sc != c);
  802232:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802236:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802239:	75 d8                	jne    802213 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80223b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802247:	48 89 ce             	mov    %rcx,%rsi
  80224a:	48 89 c7             	mov    %rax,%rdi
  80224d:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 b6                	jne    802213 <strstr+0x47>

	return (char *) (in - 1);
  80225d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802261:	48 83 e8 01          	sub    $0x1,%rax
}
  802265:	c9                   	leaveq 
  802266:	c3                   	retq   

0000000000802267 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802267:	55                   	push   %rbp
  802268:	48 89 e5             	mov    %rsp,%rbp
  80226b:	53                   	push   %rbx
  80226c:	48 83 ec 48          	sub    $0x48,%rsp
  802270:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802273:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802276:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80227a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80227e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802282:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802286:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802289:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80228d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802291:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802295:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802299:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80229d:	4c 89 c3             	mov    %r8,%rbx
  8022a0:	cd 30                	int    $0x30
  8022a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8022a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022aa:	74 3e                	je     8022ea <syscall+0x83>
  8022ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022b1:	7e 37                	jle    8022ea <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ba:	49 89 d0             	mov    %rdx,%r8
  8022bd:	89 c1                	mov    %eax,%ecx
  8022bf:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  8022c6:	00 00 00 
  8022c9:	be 23 00 00 00       	mov    $0x23,%esi
  8022ce:	48 bf c5 4c 80 00 00 	movabs $0x804cc5,%rdi
  8022d5:	00 00 00 
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dd:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  8022e4:	00 00 00 
  8022e7:	41 ff d1             	callq  *%r9

	return ret;
  8022ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022ee:	48 83 c4 48          	add    $0x48,%rsp
  8022f2:	5b                   	pop    %rbx
  8022f3:	5d                   	pop    %rbp
  8022f4:	c3                   	retq   

00000000008022f5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022f5:	55                   	push   %rbp
  8022f6:	48 89 e5             	mov    %rsp,%rbp
  8022f9:	48 83 ec 20          	sub    $0x20,%rsp
  8022fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802301:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802309:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802314:	00 
  802315:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80231b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802321:	48 89 d1             	mov    %rdx,%rcx
  802324:	48 89 c2             	mov    %rax,%rdx
  802327:	be 00 00 00 00       	mov    $0x0,%esi
  80232c:	bf 00 00 00 00       	mov    $0x0,%edi
  802331:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802338:	00 00 00 
  80233b:	ff d0                	callq  *%rax
}
  80233d:	c9                   	leaveq 
  80233e:	c3                   	retq   

000000000080233f <sys_cgetc>:

int
sys_cgetc(void)
{
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802347:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80234e:	00 
  80234f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802355:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80235b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802360:	ba 00 00 00 00       	mov    $0x0,%edx
  802365:	be 00 00 00 00       	mov    $0x0,%esi
  80236a:	bf 01 00 00 00       	mov    $0x1,%edi
  80236f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
}
  80237b:	c9                   	leaveq 
  80237c:	c3                   	retq   

000000000080237d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80237d:	55                   	push   %rbp
  80237e:	48 89 e5             	mov    %rsp,%rbp
  802381:	48 83 ec 10          	sub    $0x10,%rsp
  802385:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238b:	48 98                	cltq   
  80238d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802394:	00 
  802395:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80239b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023a6:	48 89 c2             	mov    %rax,%rdx
  8023a9:	be 01 00 00 00       	mov    $0x1,%esi
  8023ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8023b3:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
}
  8023bf:	c9                   	leaveq 
  8023c0:	c3                   	retq   

00000000008023c1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023c1:	55                   	push   %rbp
  8023c2:	48 89 e5             	mov    %rsp,%rbp
  8023c5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023d0:	00 
  8023d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e7:	be 00 00 00 00       	mov    $0x0,%esi
  8023ec:	bf 02 00 00 00       	mov    $0x2,%edi
  8023f1:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <sys_yield>:

void
sys_yield(void)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802407:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80240e:	00 
  80240f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802415:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80241b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802420:	ba 00 00 00 00       	mov    $0x0,%edx
  802425:	be 00 00 00 00       	mov    $0x0,%esi
  80242a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80242f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
}
  80243b:	c9                   	leaveq 
  80243c:	c3                   	retq   

000000000080243d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80243d:	55                   	push   %rbp
  80243e:	48 89 e5             	mov    %rsp,%rbp
  802441:	48 83 ec 20          	sub    $0x20,%rsp
  802445:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802448:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80244c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80244f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802452:	48 63 c8             	movslq %eax,%rcx
  802455:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245c:	48 98                	cltq   
  80245e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802465:	00 
  802466:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80246c:	49 89 c8             	mov    %rcx,%r8
  80246f:	48 89 d1             	mov    %rdx,%rcx
  802472:	48 89 c2             	mov    %rax,%rdx
  802475:	be 01 00 00 00       	mov    $0x1,%esi
  80247a:	bf 04 00 00 00       	mov    $0x4,%edi
  80247f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802486:	00 00 00 
  802489:	ff d0                	callq  *%rax
}
  80248b:	c9                   	leaveq 
  80248c:	c3                   	retq   

000000000080248d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80248d:	55                   	push   %rbp
  80248e:	48 89 e5             	mov    %rsp,%rbp
  802491:	48 83 ec 30          	sub    $0x30,%rsp
  802495:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80249c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80249f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024a3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024aa:	48 63 c8             	movslq %eax,%rcx
  8024ad:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b4:	48 63 f0             	movslq %eax,%rsi
  8024b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024be:	48 98                	cltq   
  8024c0:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024c4:	49 89 f9             	mov    %rdi,%r9
  8024c7:	49 89 f0             	mov    %rsi,%r8
  8024ca:	48 89 d1             	mov    %rdx,%rcx
  8024cd:	48 89 c2             	mov    %rax,%rdx
  8024d0:	be 01 00 00 00       	mov    $0x1,%esi
  8024d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8024da:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8024e1:	00 00 00 
  8024e4:	ff d0                	callq  *%rax
}
  8024e6:	c9                   	leaveq 
  8024e7:	c3                   	retq   

00000000008024e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024e8:	55                   	push   %rbp
  8024e9:	48 89 e5             	mov    %rsp,%rbp
  8024ec:	48 83 ec 20          	sub    $0x20,%rsp
  8024f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fe:	48 98                	cltq   
  802500:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802507:	00 
  802508:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80250e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802514:	48 89 d1             	mov    %rdx,%rcx
  802517:	48 89 c2             	mov    %rax,%rdx
  80251a:	be 01 00 00 00       	mov    $0x1,%esi
  80251f:	bf 06 00 00 00       	mov    $0x6,%edi
  802524:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	callq  *%rax
}
  802530:	c9                   	leaveq 
  802531:	c3                   	retq   

0000000000802532 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802532:	55                   	push   %rbp
  802533:	48 89 e5             	mov    %rsp,%rbp
  802536:	48 83 ec 10          	sub    $0x10,%rsp
  80253a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80253d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802540:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802543:	48 63 d0             	movslq %eax,%rdx
  802546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802549:	48 98                	cltq   
  80254b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802552:	00 
  802553:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802559:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80255f:	48 89 d1             	mov    %rdx,%rcx
  802562:	48 89 c2             	mov    %rax,%rdx
  802565:	be 01 00 00 00       	mov    $0x1,%esi
  80256a:	bf 08 00 00 00       	mov    $0x8,%edi
  80256f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
}
  80257b:	c9                   	leaveq 
  80257c:	c3                   	retq   

000000000080257d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80257d:	55                   	push   %rbp
  80257e:	48 89 e5             	mov    %rsp,%rbp
  802581:	48 83 ec 20          	sub    $0x20,%rsp
  802585:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802588:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80258c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802593:	48 98                	cltq   
  802595:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80259c:	00 
  80259d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025a9:	48 89 d1             	mov    %rdx,%rcx
  8025ac:	48 89 c2             	mov    %rax,%rdx
  8025af:	be 01 00 00 00       	mov    $0x1,%esi
  8025b4:	bf 09 00 00 00       	mov    $0x9,%edi
  8025b9:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
}
  8025c5:	c9                   	leaveq 
  8025c6:	c3                   	retq   

00000000008025c7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025c7:	55                   	push   %rbp
  8025c8:	48 89 e5             	mov    %rsp,%rbp
  8025cb:	48 83 ec 20          	sub    $0x20,%rsp
  8025cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dd:	48 98                	cltq   
  8025df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025e6:	00 
  8025e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025f3:	48 89 d1             	mov    %rdx,%rcx
  8025f6:	48 89 c2             	mov    %rax,%rdx
  8025f9:	be 01 00 00 00       	mov    $0x1,%esi
  8025fe:	bf 0a 00 00 00       	mov    $0xa,%edi
  802603:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80260a:	00 00 00 
  80260d:	ff d0                	callq  *%rax
}
  80260f:	c9                   	leaveq 
  802610:	c3                   	retq   

0000000000802611 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 20          	sub    $0x20,%rsp
  802619:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80261c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802620:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802624:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80262a:	48 63 f0             	movslq %eax,%rsi
  80262d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	48 98                	cltq   
  802636:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80263a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802641:	00 
  802642:	49 89 f1             	mov    %rsi,%r9
  802645:	49 89 c8             	mov    %rcx,%r8
  802648:	48 89 d1             	mov    %rdx,%rcx
  80264b:	48 89 c2             	mov    %rax,%rdx
  80264e:	be 00 00 00 00       	mov    $0x0,%esi
  802653:	bf 0c 00 00 00       	mov    $0xc,%edi
  802658:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
}
  802664:	c9                   	leaveq 
  802665:	c3                   	retq   

0000000000802666 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802666:	55                   	push   %rbp
  802667:	48 89 e5             	mov    %rsp,%rbp
  80266a:	48 83 ec 10          	sub    $0x10,%rsp
  80266e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802676:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80267d:	00 
  80267e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802684:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80268a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80268f:	48 89 c2             	mov    %rax,%rdx
  802692:	be 01 00 00 00       	mov    $0x1,%esi
  802697:	bf 0d 00 00 00       	mov    $0xd,%edi
  80269c:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8026b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026b9:	00 
  8026ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	be 00 00 00 00       	mov    $0x0,%esi
  8026d5:	bf 0e 00 00 00       	mov    $0xe,%edi
  8026da:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 30          	sub    $0x30,%rsp
  8026f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8026fa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8026fe:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802702:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802705:	48 63 c8             	movslq %eax,%rcx
  802708:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80270c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80270f:	48 63 f0             	movslq %eax,%rsi
  802712:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802719:	48 98                	cltq   
  80271b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80271f:	49 89 f9             	mov    %rdi,%r9
  802722:	49 89 f0             	mov    %rsi,%r8
  802725:	48 89 d1             	mov    %rdx,%rcx
  802728:	48 89 c2             	mov    %rax,%rdx
  80272b:	be 00 00 00 00       	mov    $0x0,%esi
  802730:	bf 0f 00 00 00       	mov    $0xf,%edi
  802735:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802741:	c9                   	leaveq 
  802742:	c3                   	retq   

0000000000802743 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
  802747:	48 83 ec 20          	sub    $0x20,%rsp
  80274b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80274f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802753:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802762:	00 
  802763:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802769:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80276f:	48 89 d1             	mov    %rdx,%rcx
  802772:	48 89 c2             	mov    %rax,%rdx
  802775:	be 00 00 00 00       	mov    $0x0,%esi
  80277a:	bf 10 00 00 00       	mov    $0x10,%edi
  80277f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
}
  80278b:	c9                   	leaveq 
  80278c:	c3                   	retq   

000000000080278d <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  80278d:	55                   	push   %rbp
  80278e:	48 89 e5             	mov    %rsp,%rbp
  802791:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802795:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80279c:	00 
  80279d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8027ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b3:	be 00 00 00 00       	mov    $0x0,%esi
  8027b8:	bf 11 00 00 00       	mov    $0x11,%edi
  8027bd:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 10          	sub    $0x10,%rsp
  8027d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d9:	48 98                	cltq   
  8027db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8027e2:	00 
  8027e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8027f4:	48 89 c2             	mov    %rax,%rdx
  8027f7:	be 00 00 00 00       	mov    $0x0,%esi
  8027fc:	bf 12 00 00 00       	mov    $0x12,%edi
  802801:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802808:	00 00 00 
  80280b:	ff d0                	callq  *%rax
}
  80280d:	c9                   	leaveq 
  80280e:	c3                   	retq   

000000000080280f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  80280f:	55                   	push   %rbp
  802810:	48 89 e5             	mov    %rsp,%rbp
  802813:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802817:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80281e:	00 
  80281f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802825:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80282b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802830:	ba 00 00 00 00       	mov    $0x0,%edx
  802835:	be 00 00 00 00       	mov    $0x0,%esi
  80283a:	bf 13 00 00 00       	mov    $0x13,%edi
  80283f:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
}
  80284b:	c9                   	leaveq 
  80284c:	c3                   	retq   

000000000080284d <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  80284d:	55                   	push   %rbp
  80284e:	48 89 e5             	mov    %rsp,%rbp
  802851:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802855:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80285c:	00 
  80285d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802863:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80286e:	ba 00 00 00 00       	mov    $0x0,%edx
  802873:	be 00 00 00 00       	mov    $0x0,%esi
  802878:	bf 14 00 00 00       	mov    $0x14,%edi
  80287d:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  802884:	00 00 00 
  802887:	ff d0                	callq  *%rax
}
  802889:	c9                   	leaveq 
  80288a:	c3                   	retq   

000000000080288b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80288b:	55                   	push   %rbp
  80288c:	48 89 e5             	mov    %rsp,%rbp
  80288f:	48 83 ec 30          	sub    $0x30,%rsp
  802893:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802897:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80289b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80289f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a6:	00 00 00 
  8028a9:	48 8b 00             	mov    (%rax),%rax
  8028ac:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	75 34                	jne    8028ea <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8028b6:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
  8028c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8028c7:	48 98                	cltq   
  8028c9:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8028d0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028d7:	00 00 00 
  8028da:	48 01 c2             	add    %rax,%rdx
  8028dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028e4:	00 00 00 
  8028e7:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8028ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028ef:	75 0e                	jne    8028ff <ipc_recv+0x74>
		pg = (void*) UTOP;
  8028f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028f8:	00 00 00 
  8028fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8028ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802903:	48 89 c7             	mov    %rax,%rdi
  802906:	48 b8 66 26 80 00 00 	movabs $0x802666,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
  802912:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802919:	79 19                	jns    802934 <ipc_recv+0xa9>
		*from_env_store = 0;
  80291b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802929:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80292f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802932:	eb 53                	jmp    802987 <ipc_recv+0xfc>
	}
	if(from_env_store)
  802934:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802939:	74 19                	je     802954 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  80293b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802942:	00 00 00 
  802945:	48 8b 00             	mov    (%rax),%rax
  802948:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80294e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802952:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802954:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802959:	74 19                	je     802974 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  80295b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802962:	00 00 00 
  802965:	48 8b 00             	mov    (%rax),%rax
  802968:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80296e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802972:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802974:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80297b:	00 00 00 
  80297e:	48 8b 00             	mov    (%rax),%rax
  802981:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802987:	c9                   	leaveq 
  802988:	c3                   	retq   

0000000000802989 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802989:	55                   	push   %rbp
  80298a:	48 89 e5             	mov    %rsp,%rbp
  80298d:	48 83 ec 30          	sub    $0x30,%rsp
  802991:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802994:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802997:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80299b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80299e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029a3:	75 0e                	jne    8029b3 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8029a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8029ac:	00 00 00 
  8029af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8029b3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8029b6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8029b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c0:	89 c7                	mov    %eax,%edi
  8029c2:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
  8029ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8029d1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8029d5:	75 0c                	jne    8029e3 <ipc_send+0x5a>
			sys_yield();
  8029d7:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8029e3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8029e7:	74 ca                	je     8029b3 <ipc_send+0x2a>
	if(result != 0)
  8029e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ed:	74 20                	je     802a0f <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8029ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f2:	89 c6                	mov    %eax,%esi
  8029f4:	48 bf d3 4c 80 00 00 	movabs $0x804cd3,%rdi
  8029fb:	00 00 00 
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802a03:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  802a0a:	00 00 00 
  802a0d:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  802a0f:	c9                   	leaveq 
  802a10:	c3                   	retq   

0000000000802a11 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a11:	55                   	push   %rbp
  802a12:	48 89 e5             	mov    %rsp,%rbp
  802a15:	48 83 ec 14          	sub    $0x14,%rsp
  802a19:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a23:	eb 4e                	jmp    802a73 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802a25:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a2c:	00 00 00 
  802a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a32:	48 98                	cltq   
  802a34:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a3b:	48 01 d0             	add    %rdx,%rax
  802a3e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a44:	8b 00                	mov    (%rax),%eax
  802a46:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a49:	75 24                	jne    802a6f <ipc_find_env+0x5e>
			return envs[i].env_id;
  802a4b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a52:	00 00 00 
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	48 98                	cltq   
  802a5a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a61:	48 01 d0             	add    %rdx,%rax
  802a64:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a6a:	8b 40 08             	mov    0x8(%rax),%eax
  802a6d:	eb 12                	jmp    802a81 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a73:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a7a:	7e a9                	jle    802a25 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a81:	c9                   	leaveq 
  802a82:	c3                   	retq   

0000000000802a83 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a83:	55                   	push   %rbp
  802a84:	48 89 e5             	mov    %rsp,%rbp
  802a87:	48 83 ec 08          	sub    $0x8,%rsp
  802a8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a8f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a93:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a9a:	ff ff ff 
  802a9d:	48 01 d0             	add    %rdx,%rax
  802aa0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802aa4:	c9                   	leaveq 
  802aa5:	c3                   	retq   

0000000000802aa6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802aa6:	55                   	push   %rbp
  802aa7:	48 89 e5             	mov    %rsp,%rbp
  802aaa:	48 83 ec 08          	sub    $0x8,%rsp
  802aae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802ab2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab6:	48 89 c7             	mov    %rax,%rdi
  802ab9:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
  802ac5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802acb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802acf:	c9                   	leaveq 
  802ad0:	c3                   	retq   

0000000000802ad1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	48 83 ec 18          	sub    $0x18,%rsp
  802ad9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802add:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae4:	eb 6b                	jmp    802b51 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae9:	48 98                	cltq   
  802aeb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802af1:	48 c1 e0 0c          	shl    $0xc,%rax
  802af5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afd:	48 c1 e8 15          	shr    $0x15,%rax
  802b01:	48 89 c2             	mov    %rax,%rdx
  802b04:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b0b:	01 00 00 
  802b0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b12:	83 e0 01             	and    $0x1,%eax
  802b15:	48 85 c0             	test   %rax,%rax
  802b18:	74 21                	je     802b3b <fd_alloc+0x6a>
  802b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1e:	48 c1 e8 0c          	shr    $0xc,%rax
  802b22:	48 89 c2             	mov    %rax,%rdx
  802b25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b2c:	01 00 00 
  802b2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b33:	83 e0 01             	and    $0x1,%eax
  802b36:	48 85 c0             	test   %rax,%rax
  802b39:	75 12                	jne    802b4d <fd_alloc+0x7c>
			*fd_store = fd;
  802b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b43:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	eb 1a                	jmp    802b67 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b51:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b55:	7e 8f                	jle    802ae6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b62:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b67:	c9                   	leaveq 
  802b68:	c3                   	retq   

0000000000802b69 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b69:	55                   	push   %rbp
  802b6a:	48 89 e5             	mov    %rsp,%rbp
  802b6d:	48 83 ec 20          	sub    $0x20,%rsp
  802b71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b7c:	78 06                	js     802b84 <fd_lookup+0x1b>
  802b7e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b82:	7e 07                	jle    802b8b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b89:	eb 6c                	jmp    802bf7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8e:	48 98                	cltq   
  802b90:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b96:	48 c1 e0 0c          	shl    $0xc,%rax
  802b9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba2:	48 c1 e8 15          	shr    $0x15,%rax
  802ba6:	48 89 c2             	mov    %rax,%rdx
  802ba9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bb0:	01 00 00 
  802bb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bb7:	83 e0 01             	and    $0x1,%eax
  802bba:	48 85 c0             	test   %rax,%rax
  802bbd:	74 21                	je     802be0 <fd_lookup+0x77>
  802bbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc3:	48 c1 e8 0c          	shr    $0xc,%rax
  802bc7:	48 89 c2             	mov    %rax,%rdx
  802bca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bd1:	01 00 00 
  802bd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bd8:	83 e0 01             	and    $0x1,%eax
  802bdb:	48 85 c0             	test   %rax,%rax
  802bde:	75 07                	jne    802be7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802be0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802be5:	eb 10                	jmp    802bf7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802be7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802beb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bef:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf7:	c9                   	leaveq 
  802bf8:	c3                   	retq   

0000000000802bf9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802bf9:	55                   	push   %rbp
  802bfa:	48 89 e5             	mov    %rsp,%rbp
  802bfd:	48 83 ec 30          	sub    $0x30,%rsp
  802c01:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c05:	89 f0                	mov    %esi,%eax
  802c07:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0e:	48 89 c7             	mov    %rax,%rdi
  802c11:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c21:	48 89 d6             	mov    %rdx,%rsi
  802c24:	89 c7                	mov    %eax,%edi
  802c26:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  802c2d:	00 00 00 
  802c30:	ff d0                	callq  *%rax
  802c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c39:	78 0a                	js     802c45 <fd_close+0x4c>
	    || fd != fd2)
  802c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c43:	74 12                	je     802c57 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c45:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c49:	74 05                	je     802c50 <fd_close+0x57>
  802c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4e:	eb 05                	jmp    802c55 <fd_close+0x5c>
  802c50:	b8 00 00 00 00       	mov    $0x0,%eax
  802c55:	eb 69                	jmp    802cc0 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5b:	8b 00                	mov    (%rax),%eax
  802c5d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c61:	48 89 d6             	mov    %rdx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c79:	78 2a                	js     802ca5 <fd_close+0xac>
		if (dev->dev_close)
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c83:	48 85 c0             	test   %rax,%rax
  802c86:	74 16                	je     802c9e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c90:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c94:	48 89 d7             	mov    %rdx,%rdi
  802c97:	ff d0                	callq  *%rax
  802c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9c:	eb 07                	jmp    802ca5 <fd_close+0xac>
		else
			r = 0;
  802c9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ca5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca9:	48 89 c6             	mov    %rax,%rsi
  802cac:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb1:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
	return r;
  802cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cc0:	c9                   	leaveq 
  802cc1:	c3                   	retq   

0000000000802cc2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802cc2:	55                   	push   %rbp
  802cc3:	48 89 e5             	mov    %rsp,%rbp
  802cc6:	48 83 ec 20          	sub    $0x20,%rsp
  802cca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ccd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cd8:	eb 41                	jmp    802d1b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802cda:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ce1:	00 00 00 
  802ce4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ce7:	48 63 d2             	movslq %edx,%rdx
  802cea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cee:	8b 00                	mov    (%rax),%eax
  802cf0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cf3:	75 22                	jne    802d17 <dev_lookup+0x55>
			*dev = devtab[i];
  802cf5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cfc:	00 00 00 
  802cff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d02:	48 63 d2             	movslq %edx,%rdx
  802d05:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d0d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	eb 60                	jmp    802d77 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d17:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d1b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802d22:	00 00 00 
  802d25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d28:	48 63 d2             	movslq %edx,%rdx
  802d2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d2f:	48 85 c0             	test   %rax,%rax
  802d32:	75 a6                	jne    802cda <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d3b:	00 00 00 
  802d3e:	48 8b 00             	mov    (%rax),%rax
  802d41:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d47:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d4a:	89 c6                	mov    %eax,%esi
  802d4c:	48 bf f0 4c 80 00 00 	movabs $0x804cf0,%rdi
  802d53:	00 00 00 
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  802d62:	00 00 00 
  802d65:	ff d1                	callq  *%rcx
	*dev = 0;
  802d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d77:	c9                   	leaveq 
  802d78:	c3                   	retq   

0000000000802d79 <close>:

int
close(int fdnum)
{
  802d79:	55                   	push   %rbp
  802d7a:	48 89 e5             	mov    %rsp,%rbp
  802d7d:	48 83 ec 20          	sub    $0x20,%rsp
  802d81:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8b:	48 89 d6             	mov    %rdx,%rsi
  802d8e:	89 c7                	mov    %eax,%edi
  802d90:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da3:	79 05                	jns    802daa <close+0x31>
		return r;
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	eb 18                	jmp    802dc2 <close+0x49>
	else
		return fd_close(fd, 1);
  802daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dae:	be 01 00 00 00       	mov    $0x1,%esi
  802db3:	48 89 c7             	mov    %rax,%rdi
  802db6:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
}
  802dc2:	c9                   	leaveq 
  802dc3:	c3                   	retq   

0000000000802dc4 <close_all>:

void
close_all(void)
{
  802dc4:	55                   	push   %rbp
  802dc5:	48 89 e5             	mov    %rsp,%rbp
  802dc8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802dcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dd3:	eb 15                	jmp    802dea <close_all+0x26>
		close(i);
  802dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd8:	89 c7                	mov    %eax,%edi
  802dda:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  802de1:	00 00 00 
  802de4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802de6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802dea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802dee:	7e e5                	jle    802dd5 <close_all+0x11>
		close(i);
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 40          	sub    $0x40,%rsp
  802dfa:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802dfd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e00:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e04:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e07:	48 89 d6             	mov    %rdx,%rsi
  802e0a:	89 c7                	mov    %eax,%edi
  802e0c:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1f:	79 08                	jns    802e29 <dup+0x37>
		return r;
  802e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e24:	e9 70 01 00 00       	jmpq   802f99 <dup+0x1a7>
	close(newfdnum);
  802e29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e2c:	89 c7                	mov    %eax,%edi
  802e2e:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  802e35:	00 00 00 
  802e38:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e3a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e3d:	48 98                	cltq   
  802e3f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e45:	48 c1 e0 0c          	shl    $0xc,%rax
  802e49:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e51:	48 89 c7             	mov    %rax,%rdi
  802e54:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e68:	48 89 c7             	mov    %rax,%rdi
  802e6b:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  802e72:	00 00 00 
  802e75:	ff d0                	callq  *%rax
  802e77:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7f:	48 c1 e8 15          	shr    $0x15,%rax
  802e83:	48 89 c2             	mov    %rax,%rdx
  802e86:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e8d:	01 00 00 
  802e90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e94:	83 e0 01             	and    $0x1,%eax
  802e97:	48 85 c0             	test   %rax,%rax
  802e9a:	74 73                	je     802f0f <dup+0x11d>
  802e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ea4:	48 89 c2             	mov    %rax,%rdx
  802ea7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eae:	01 00 00 
  802eb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eb5:	83 e0 01             	and    $0x1,%eax
  802eb8:	48 85 c0             	test   %rax,%rax
  802ebb:	74 52                	je     802f0f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec1:	48 c1 e8 0c          	shr    $0xc,%rax
  802ec5:	48 89 c2             	mov    %rax,%rdx
  802ec8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ecf:	01 00 00 
  802ed2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed6:	25 07 0e 00 00       	and    $0xe07,%eax
  802edb:	89 c1                	mov    %eax,%ecx
  802edd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee5:	41 89 c8             	mov    %ecx,%r8d
  802ee8:	48 89 d1             	mov    %rdx,%rcx
  802eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef0:	48 89 c6             	mov    %rax,%rsi
  802ef3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef8:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
  802f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0b:	79 02                	jns    802f0f <dup+0x11d>
			goto err;
  802f0d:	eb 57                	jmp    802f66 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f13:	48 c1 e8 0c          	shr    $0xc,%rax
  802f17:	48 89 c2             	mov    %rax,%rdx
  802f1a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f21:	01 00 00 
  802f24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f28:	25 07 0e 00 00       	and    $0xe07,%eax
  802f2d:	89 c1                	mov    %eax,%ecx
  802f2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f37:	41 89 c8             	mov    %ecx,%r8d
  802f3a:	48 89 d1             	mov    %rdx,%rcx
  802f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f42:	48 89 c6             	mov    %rax,%rsi
  802f45:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4a:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	79 02                	jns    802f61 <dup+0x16f>
		goto err;
  802f5f:	eb 05                	jmp    802f66 <dup+0x174>

	return newfdnum;
  802f61:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f64:	eb 33                	jmp    802f99 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6a:	48 89 c6             	mov    %rax,%rsi
  802f6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f72:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f82:	48 89 c6             	mov    %rax,%rsi
  802f85:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8a:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
	return r;
  802f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f99:	c9                   	leaveq 
  802f9a:	c3                   	retq   

0000000000802f9b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f9b:	55                   	push   %rbp
  802f9c:	48 89 e5             	mov    %rsp,%rbp
  802f9f:	48 83 ec 40          	sub    $0x40,%rsp
  802fa3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fa6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802faa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fb2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fb5:	48 89 d6             	mov    %rdx,%rsi
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcd:	78 24                	js     802ff3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd3:	8b 00                	mov    (%rax),%eax
  802fd5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fd9:	48 89 d6             	mov    %rdx,%rsi
  802fdc:	89 c7                	mov    %eax,%edi
  802fde:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff1:	79 05                	jns    802ff8 <read+0x5d>
		return r;
  802ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff6:	eb 76                	jmp    80306e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffc:	8b 40 08             	mov    0x8(%rax),%eax
  802fff:	83 e0 03             	and    $0x3,%eax
  803002:	83 f8 01             	cmp    $0x1,%eax
  803005:	75 3a                	jne    803041 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803007:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80300e:	00 00 00 
  803011:	48 8b 00             	mov    (%rax),%rax
  803014:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80301a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80301d:	89 c6                	mov    %eax,%esi
  80301f:	48 bf 0f 4d 80 00 00 	movabs $0x804d0f,%rdi
  803026:	00 00 00 
  803029:	b8 00 00 00 00       	mov    $0x0,%eax
  80302e:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  803035:	00 00 00 
  803038:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80303a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80303f:	eb 2d                	jmp    80306e <read+0xd3>
	}
	if (!dev->dev_read)
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	48 8b 40 10          	mov    0x10(%rax),%rax
  803049:	48 85 c0             	test   %rax,%rax
  80304c:	75 07                	jne    803055 <read+0xba>
		return -E_NOT_SUPP;
  80304e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803053:	eb 19                	jmp    80306e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803059:	48 8b 40 10          	mov    0x10(%rax),%rax
  80305d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803061:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803065:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803069:	48 89 cf             	mov    %rcx,%rdi
  80306c:	ff d0                	callq  *%rax
}
  80306e:	c9                   	leaveq 
  80306f:	c3                   	retq   

0000000000803070 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803070:	55                   	push   %rbp
  803071:	48 89 e5             	mov    %rsp,%rbp
  803074:	48 83 ec 30          	sub    $0x30,%rsp
  803078:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80307f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80308a:	eb 49                	jmp    8030d5 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	48 98                	cltq   
  803091:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803095:	48 29 c2             	sub    %rax,%rdx
  803098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309b:	48 63 c8             	movslq %eax,%rcx
  80309e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a2:	48 01 c1             	add    %rax,%rcx
  8030a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a8:	48 89 ce             	mov    %rcx,%rsi
  8030ab:	89 c7                	mov    %eax,%edi
  8030ad:	48 b8 9b 2f 80 00 00 	movabs $0x802f9b,%rax
  8030b4:	00 00 00 
  8030b7:	ff d0                	callq  *%rax
  8030b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030c0:	79 05                	jns    8030c7 <readn+0x57>
			return m;
  8030c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c5:	eb 1c                	jmp    8030e3 <readn+0x73>
		if (m == 0)
  8030c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030cb:	75 02                	jne    8030cf <readn+0x5f>
			break;
  8030cd:	eb 11                	jmp    8030e0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	48 98                	cltq   
  8030da:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030de:	72 ac                	jb     80308c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8030e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030e3:	c9                   	leaveq 
  8030e4:	c3                   	retq   

00000000008030e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8030e5:	55                   	push   %rbp
  8030e6:	48 89 e5             	mov    %rsp,%rbp
  8030e9:	48 83 ec 40          	sub    $0x40,%rsp
  8030ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030f4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030fc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030ff:	48 89 d6             	mov    %rdx,%rsi
  803102:	89 c7                	mov    %eax,%edi
  803104:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  80310b:	00 00 00 
  80310e:	ff d0                	callq  *%rax
  803110:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803113:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803117:	78 24                	js     80313d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311d:	8b 00                	mov    (%rax),%eax
  80311f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803123:	48 89 d6             	mov    %rdx,%rsi
  803126:	89 c7                	mov    %eax,%edi
  803128:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
  803134:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313b:	79 05                	jns    803142 <write+0x5d>
		return r;
  80313d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803140:	eb 42                	jmp    803184 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803146:	8b 40 08             	mov    0x8(%rax),%eax
  803149:	83 e0 03             	and    $0x3,%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	75 07                	jne    803157 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803150:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803155:	eb 2d                	jmp    803184 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80315f:	48 85 c0             	test   %rax,%rax
  803162:	75 07                	jne    80316b <write+0x86>
		return -E_NOT_SUPP;
  803164:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803169:	eb 19                	jmp    803184 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  80316b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803173:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803177:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80317b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80317f:	48 89 cf             	mov    %rcx,%rdi
  803182:	ff d0                	callq  *%rax
}
  803184:	c9                   	leaveq 
  803185:	c3                   	retq   

0000000000803186 <seek>:

int
seek(int fdnum, off_t offset)
{
  803186:	55                   	push   %rbp
  803187:	48 89 e5             	mov    %rsp,%rbp
  80318a:	48 83 ec 18          	sub    $0x18,%rsp
  80318e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803191:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803194:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80319b:	48 89 d6             	mov    %rdx,%rsi
  80319e:	89 c7                	mov    %eax,%edi
  8031a0:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b3:	79 05                	jns    8031ba <seek+0x34>
		return r;
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b8:	eb 0f                	jmp    8031c9 <seek+0x43>
	fd->fd_offset = offset;
  8031ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031c1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8031c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c9:	c9                   	leaveq 
  8031ca:	c3                   	retq   

00000000008031cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031cb:	55                   	push   %rbp
  8031cc:	48 89 e5             	mov    %rsp,%rbp
  8031cf:	48 83 ec 30          	sub    $0x30,%rsp
  8031d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031e0:	48 89 d6             	mov    %rdx,%rsi
  8031e3:	89 c7                	mov    %eax,%edi
  8031e5:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f8:	78 24                	js     80321e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fe:	8b 00                	mov    (%rax),%eax
  803200:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803204:	48 89 d6             	mov    %rdx,%rsi
  803207:	89 c7                	mov    %eax,%edi
  803209:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  803210:	00 00 00 
  803213:	ff d0                	callq  *%rax
  803215:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803218:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321c:	79 05                	jns    803223 <ftruncate+0x58>
		return r;
  80321e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803221:	eb 72                	jmp    803295 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803227:	8b 40 08             	mov    0x8(%rax),%eax
  80322a:	83 e0 03             	and    $0x3,%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	75 3a                	jne    80326b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803231:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803238:	00 00 00 
  80323b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80323e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803244:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803247:	89 c6                	mov    %eax,%esi
  803249:	48 bf 30 4d 80 00 00 	movabs $0x804d30,%rdi
  803250:	00 00 00 
  803253:	b8 00 00 00 00       	mov    $0x0,%eax
  803258:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  80325f:	00 00 00 
  803262:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803264:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803269:	eb 2a                	jmp    803295 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803273:	48 85 c0             	test   %rax,%rax
  803276:	75 07                	jne    80327f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803278:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80327d:	eb 16                	jmp    803295 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80327f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803283:	48 8b 40 30          	mov    0x30(%rax),%rax
  803287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80328b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80328e:	89 ce                	mov    %ecx,%esi
  803290:	48 89 d7             	mov    %rdx,%rdi
  803293:	ff d0                	callq  *%rax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 30          	sub    $0x30,%rsp
  80329f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032ad:	48 89 d6             	mov    %rdx,%rsi
  8032b0:	89 c7                	mov    %eax,%edi
  8032b2:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c5:	78 24                	js     8032eb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cb:	8b 00                	mov    (%rax),%eax
  8032cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032d1:	48 89 d6             	mov    %rdx,%rsi
  8032d4:	89 c7                	mov    %eax,%edi
  8032d6:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
  8032e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e9:	79 05                	jns    8032f0 <fstat+0x59>
		return r;
  8032eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ee:	eb 5e                	jmp    80334e <fstat+0xb7>
	if (!dev->dev_stat)
  8032f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032f8:	48 85 c0             	test   %rax,%rax
  8032fb:	75 07                	jne    803304 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803302:	eb 4a                	jmp    80334e <fstat+0xb7>
	stat->st_name[0] = 0;
  803304:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803308:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80330b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803316:	00 00 00 
	stat->st_isdir = 0;
  803319:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803324:	00 00 00 
	stat->st_dev = dev;
  803327:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80332b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80333e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803342:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803346:	48 89 ce             	mov    %rcx,%rsi
  803349:	48 89 d7             	mov    %rdx,%rdi
  80334c:	ff d0                	callq  *%rax
}
  80334e:	c9                   	leaveq 
  80334f:	c3                   	retq   

0000000000803350 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803350:	55                   	push   %rbp
  803351:	48 89 e5             	mov    %rsp,%rbp
  803354:	48 83 ec 20          	sub    $0x20,%rsp
  803358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80335c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803364:	be 00 00 00 00       	mov    $0x0,%esi
  803369:	48 89 c7             	mov    %rax,%rdi
  80336c:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337f:	79 05                	jns    803386 <stat+0x36>
		return fd;
  803381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803384:	eb 2f                	jmp    8033b5 <stat+0x65>
	r = fstat(fd, stat);
  803386:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80338a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338d:	48 89 d6             	mov    %rdx,%rsi
  803390:	89 c7                	mov    %eax,%edi
  803392:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
  80339e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a4:	89 c7                	mov    %eax,%edi
  8033a6:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
	return r;
  8033b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033b5:	c9                   	leaveq 
  8033b6:	c3                   	retq   

00000000008033b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033b7:	55                   	push   %rbp
  8033b8:	48 89 e5             	mov    %rsp,%rbp
  8033bb:	48 83 ec 10          	sub    $0x10,%rsp
  8033bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8033c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033cd:	00 00 00 
  8033d0:	8b 00                	mov    (%rax),%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	75 1d                	jne    8033f3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033d6:	bf 01 00 00 00       	mov    $0x1,%edi
  8033db:	48 b8 11 2a 80 00 00 	movabs $0x802a11,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8033ee:	00 00 00 
  8033f1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033fa:	00 00 00 
  8033fd:	8b 00                	mov    (%rax),%eax
  8033ff:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803402:	b9 07 00 00 00       	mov    $0x7,%ecx
  803407:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80340e:	00 00 00 
  803411:	89 c7                	mov    %eax,%edi
  803413:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80341f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803423:	ba 00 00 00 00       	mov    $0x0,%edx
  803428:	48 89 c6             	mov    %rax,%rsi
  80342b:	bf 00 00 00 00       	mov    $0x0,%edi
  803430:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
}
  80343c:	c9                   	leaveq 
  80343d:	c3                   	retq   

000000000080343e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80343e:	55                   	push   %rbp
  80343f:	48 89 e5             	mov    %rsp,%rbp
  803442:	48 83 ec 30          	sub    $0x30,%rsp
  803446:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80344a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80344d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803454:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80345b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803462:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803467:	75 08                	jne    803471 <open+0x33>
	{
		return r;
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346c:	e9 f2 00 00 00       	jmpq   803563 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803475:	48 89 c7             	mov    %rax,%rdi
  803478:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax
  803484:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803487:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80348e:	7e 0a                	jle    80349a <open+0x5c>
	{
		return -E_BAD_PATH;
  803490:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803495:	e9 c9 00 00 00       	jmpq   803563 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80349a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8034a1:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8034a2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8034a6:	48 89 c7             	mov    %rax,%rdi
  8034a9:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
  8034b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bc:	78 09                	js     8034c7 <open+0x89>
  8034be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c2:	48 85 c0             	test   %rax,%rax
  8034c5:	75 08                	jne    8034cf <open+0x91>
		{
			return r;
  8034c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ca:	e9 94 00 00 00       	jmpq   803563 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8034cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034d3:	ba 00 04 00 00       	mov    $0x400,%edx
  8034d8:	48 89 c6             	mov    %rax,%rsi
  8034db:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8034e2:	00 00 00 
  8034e5:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  8034ec:	00 00 00 
  8034ef:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8034f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034f8:	00 00 00 
  8034fb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8034fe:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803508:	48 89 c6             	mov    %rax,%rsi
  80350b:	bf 01 00 00 00       	mov    $0x1,%edi
  803510:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
  80351c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80351f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803523:	79 2b                	jns    803550 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803529:	be 00 00 00 00       	mov    $0x0,%esi
  80352e:	48 89 c7             	mov    %rax,%rdi
  803531:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
  80353d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803540:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803544:	79 05                	jns    80354b <open+0x10d>
			{
				return d;
  803546:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803549:	eb 18                	jmp    803563 <open+0x125>
			}
			return r;
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	eb 13                	jmp    803563 <open+0x125>
		}	
		return fd2num(fd_store);
  803550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803554:	48 89 c7             	mov    %rax,%rdi
  803557:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  80355e:	00 00 00 
  803561:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803563:	c9                   	leaveq 
  803564:	c3                   	retq   

0000000000803565 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803565:	55                   	push   %rbp
  803566:	48 89 e5             	mov    %rsp,%rbp
  803569:	48 83 ec 10          	sub    $0x10,%rsp
  80356d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803575:	8b 50 0c             	mov    0xc(%rax),%edx
  803578:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80357f:	00 00 00 
  803582:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803584:	be 00 00 00 00       	mov    $0x0,%esi
  803589:	bf 06 00 00 00       	mov    $0x6,%edi
  80358e:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
}
  80359a:	c9                   	leaveq 
  80359b:	c3                   	retq   

000000000080359c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80359c:	55                   	push   %rbp
  80359d:	48 89 e5             	mov    %rsp,%rbp
  8035a0:	48 83 ec 30          	sub    $0x30,%rsp
  8035a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8035b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8035b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035bc:	74 07                	je     8035c5 <devfile_read+0x29>
  8035be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035c3:	75 07                	jne    8035cc <devfile_read+0x30>
		return -E_INVAL;
  8035c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8035ca:	eb 77                	jmp    803643 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8035d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035da:	00 00 00 
  8035dd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035df:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035e6:	00 00 00 
  8035e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035ed:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8035f1:	be 00 00 00 00       	mov    $0x0,%esi
  8035f6:	bf 03 00 00 00       	mov    $0x3,%edi
  8035fb:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803602:	00 00 00 
  803605:	ff d0                	callq  *%rax
  803607:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360e:	7f 05                	jg     803615 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803613:	eb 2e                	jmp    803643 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803618:	48 63 d0             	movslq %eax,%rdx
  80361b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803626:	00 00 00 
  803629:	48 89 c7             	mov    %rax,%rdi
  80362c:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803638:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80363c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803640:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803643:	c9                   	leaveq 
  803644:	c3                   	retq   

0000000000803645 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803645:	55                   	push   %rbp
  803646:	48 89 e5             	mov    %rsp,%rbp
  803649:	48 83 ec 30          	sub    $0x30,%rsp
  80364d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803651:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803655:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803659:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803660:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803665:	74 07                	je     80366e <devfile_write+0x29>
  803667:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80366c:	75 08                	jne    803676 <devfile_write+0x31>
		return r;
  80366e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803671:	e9 9a 00 00 00       	jmpq   803710 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367a:	8b 50 0c             	mov    0xc(%rax),%edx
  80367d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803684:	00 00 00 
  803687:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803689:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803690:	00 
  803691:	76 08                	jbe    80369b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803693:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80369a:	00 
	}
	fsipcbuf.write.req_n = n;
  80369b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036a2:	00 00 00 
  8036a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036a9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8036ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b5:	48 89 c6             	mov    %rax,%rsi
  8036b8:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8036bf:	00 00 00 
  8036c2:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8036ce:	be 00 00 00 00       	mov    $0x0,%esi
  8036d3:	bf 04 00 00 00       	mov    $0x4,%edi
  8036d8:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036eb:	7f 20                	jg     80370d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8036ed:	48 bf 56 4d 80 00 00 	movabs $0x804d56,%rdi
  8036f4:	00 00 00 
  8036f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fc:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803703:	00 00 00 
  803706:	ff d2                	callq  *%rdx
		return r;
  803708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370b:	eb 03                	jmp    803710 <devfile_write+0xcb>
	}
	return r;
  80370d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803710:	c9                   	leaveq 
  803711:	c3                   	retq   

0000000000803712 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803712:	55                   	push   %rbp
  803713:	48 89 e5             	mov    %rsp,%rbp
  803716:	48 83 ec 20          	sub    $0x20,%rsp
  80371a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80371e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803726:	8b 50 0c             	mov    0xc(%rax),%edx
  803729:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803730:	00 00 00 
  803733:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803735:	be 00 00 00 00       	mov    $0x0,%esi
  80373a:	bf 05 00 00 00       	mov    $0x5,%edi
  80373f:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
  80374b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803752:	79 05                	jns    803759 <devfile_stat+0x47>
		return r;
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803757:	eb 56                	jmp    8037af <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803759:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803764:	00 00 00 
  803767:	48 89 c7             	mov    %rax,%rdi
  80376a:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803776:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80377d:	00 00 00 
  803780:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803790:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803797:	00 00 00 
  80379a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8037a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8037aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037af:	c9                   	leaveq 
  8037b0:	c3                   	retq   

00000000008037b1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8037b1:	55                   	push   %rbp
  8037b2:	48 89 e5             	mov    %rsp,%rbp
  8037b5:	48 83 ec 10          	sub    $0x10,%rsp
  8037b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037bd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8037c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8037c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8037ce:	00 00 00 
  8037d1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8037d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8037da:	00 00 00 
  8037dd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8037e3:	be 00 00 00 00       	mov    $0x0,%esi
  8037e8:	bf 02 00 00 00       	mov    $0x2,%edi
  8037ed:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
}
  8037f9:	c9                   	leaveq 
  8037fa:	c3                   	retq   

00000000008037fb <remove>:

// Delete a file
int
remove(const char *path)
{
  8037fb:	55                   	push   %rbp
  8037fc:	48 89 e5             	mov    %rsp,%rbp
  8037ff:	48 83 ec 10          	sub    $0x10,%rsp
  803803:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803807:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380b:	48 89 c7             	mov    %rax,%rdi
  80380e:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
  80381a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80381f:	7e 07                	jle    803828 <remove+0x2d>
		return -E_BAD_PATH;
  803821:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803826:	eb 33                	jmp    80385b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382c:	48 89 c6             	mov    %rax,%rsi
  80382f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803836:	00 00 00 
  803839:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803845:	be 00 00 00 00       	mov    $0x0,%esi
  80384a:	bf 07 00 00 00       	mov    $0x7,%edi
  80384f:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
}
  80385b:	c9                   	leaveq 
  80385c:	c3                   	retq   

000000000080385d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803861:	be 00 00 00 00       	mov    $0x0,%esi
  803866:	bf 08 00 00 00       	mov    $0x8,%edi
  80386b:	48 b8 b7 33 80 00 00 	movabs $0x8033b7,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
}
  803877:	5d                   	pop    %rbp
  803878:	c3                   	retq   

0000000000803879 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803879:	55                   	push   %rbp
  80387a:	48 89 e5             	mov    %rsp,%rbp
  80387d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803884:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80388b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803892:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803899:	be 00 00 00 00       	mov    $0x0,%esi
  80389e:	48 89 c7             	mov    %rax,%rdi
  8038a1:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
  8038ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8038b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b4:	79 28                	jns    8038de <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8038b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b9:	89 c6                	mov    %eax,%esi
  8038bb:	48 bf 72 4d 80 00 00 	movabs $0x804d72,%rdi
  8038c2:	00 00 00 
  8038c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ca:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8038d1:	00 00 00 
  8038d4:	ff d2                	callq  *%rdx
		return fd_src;
  8038d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d9:	e9 74 01 00 00       	jmpq   803a52 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8038de:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8038e5:	be 01 01 00 00       	mov    $0x101,%esi
  8038ea:	48 89 c7             	mov    %rax,%rdi
  8038ed:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
  8038f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8038fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803900:	79 39                	jns    80393b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803902:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803905:	89 c6                	mov    %eax,%esi
  803907:	48 bf 88 4d 80 00 00 	movabs $0x804d88,%rdi
  80390e:	00 00 00 
  803911:	b8 00 00 00 00       	mov    $0x0,%eax
  803916:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80391d:	00 00 00 
  803920:	ff d2                	callq  *%rdx
		close(fd_src);
  803922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803925:	89 c7                	mov    %eax,%edi
  803927:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
		return fd_dest;
  803933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803936:	e9 17 01 00 00       	jmpq   803a52 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80393b:	eb 74                	jmp    8039b1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80393d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803940:	48 63 d0             	movslq %eax,%rdx
  803943:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80394a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80394d:	48 89 ce             	mov    %rcx,%rsi
  803950:	89 c7                	mov    %eax,%edi
  803952:	48 b8 e5 30 80 00 00 	movabs $0x8030e5,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
  80395e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803961:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803965:	79 4a                	jns    8039b1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803967:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80396a:	89 c6                	mov    %eax,%esi
  80396c:	48 bf a2 4d 80 00 00 	movabs $0x804da2,%rdi
  803973:	00 00 00 
  803976:	b8 00 00 00 00       	mov    $0x0,%eax
  80397b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803982:	00 00 00 
  803985:	ff d2                	callq  *%rdx
			close(fd_src);
  803987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398a:	89 c7                	mov    %eax,%edi
  80398c:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
			close(fd_dest);
  803998:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399b:	89 c7                	mov    %eax,%edi
  80399d:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  8039a4:	00 00 00 
  8039a7:	ff d0                	callq  *%rax
			return write_size;
  8039a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039ac:	e9 a1 00 00 00       	jmpq   803a52 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8039b1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bb:	ba 00 02 00 00       	mov    $0x200,%edx
  8039c0:	48 89 ce             	mov    %rcx,%rsi
  8039c3:	89 c7                	mov    %eax,%edi
  8039c5:	48 b8 9b 2f 80 00 00 	movabs $0x802f9b,%rax
  8039cc:	00 00 00 
  8039cf:	ff d0                	callq  *%rax
  8039d1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039d8:	0f 8f 5f ff ff ff    	jg     80393d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8039de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039e2:	79 47                	jns    803a2b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8039e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039e7:	89 c6                	mov    %eax,%esi
  8039e9:	48 bf b5 4d 80 00 00 	movabs $0x804db5,%rdi
  8039f0:	00 00 00 
  8039f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f8:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8039ff:	00 00 00 
  803a02:	ff d2                	callq  *%rdx
		close(fd_src);
  803a04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a07:	89 c7                	mov    %eax,%edi
  803a09:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  803a10:	00 00 00 
  803a13:	ff d0                	callq  *%rax
		close(fd_dest);
  803a15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a18:	89 c7                	mov    %eax,%edi
  803a1a:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
		return read_size;
  803a26:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a29:	eb 27                	jmp    803a52 <copy+0x1d9>
	}
	close(fd_src);
  803a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2e:	89 c7                	mov    %eax,%edi
  803a30:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
	close(fd_dest);
  803a3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a3f:	89 c7                	mov    %eax,%edi
  803a41:	48 b8 79 2d 80 00 00 	movabs $0x802d79,%rax
  803a48:	00 00 00 
  803a4b:	ff d0                	callq  *%rax
	return 0;
  803a4d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	53                   	push   %rbx
  803a59:	48 83 ec 38          	sub    $0x38,%rsp
  803a5d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a61:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7b:	0f 88 bf 01 00 00    	js     803c40 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a85:	ba 07 04 00 00       	mov    $0x407,%edx
  803a8a:	48 89 c6             	mov    %rax,%rsi
  803a8d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a92:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aa5:	0f 88 95 01 00 00    	js     803c40 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803aab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803aaf:	48 89 c7             	mov    %rax,%rdi
  803ab2:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  803ab9:	00 00 00 
  803abc:	ff d0                	callq  *%rax
  803abe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ac5:	0f 88 5d 01 00 00    	js     803c28 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803acb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803acf:	ba 07 04 00 00       	mov    $0x407,%edx
  803ad4:	48 89 c6             	mov    %rax,%rsi
  803ad7:	bf 00 00 00 00       	mov    $0x0,%edi
  803adc:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803ae3:	00 00 00 
  803ae6:	ff d0                	callq  *%rax
  803ae8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aeb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aef:	0f 88 33 01 00 00    	js     803c28 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af9:	48 89 c7             	mov    %rax,%rdi
  803afc:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
  803b08:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b10:	ba 07 04 00 00       	mov    $0x407,%edx
  803b15:	48 89 c6             	mov    %rax,%rsi
  803b18:	bf 00 00 00 00       	mov    $0x0,%edi
  803b1d:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	callq  *%rax
  803b29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b30:	79 05                	jns    803b37 <pipe+0xe3>
		goto err2;
  803b32:	e9 d9 00 00 00       	jmpq   803c10 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3b:	48 89 c7             	mov    %rax,%rdi
  803b3e:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	48 89 c2             	mov    %rax,%rdx
  803b4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b51:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b57:	48 89 d1             	mov    %rdx,%rcx
  803b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b5f:	48 89 c6             	mov    %rax,%rsi
  803b62:	bf 00 00 00 00       	mov    $0x0,%edi
  803b67:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
  803b73:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b76:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b7a:	79 1b                	jns    803b97 <pipe+0x143>
		goto err3;
  803b7c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b81:	48 89 c6             	mov    %rax,%rsi
  803b84:	bf 00 00 00 00       	mov    $0x0,%edi
  803b89:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803b90:	00 00 00 
  803b93:	ff d0                	callq  *%rax
  803b95:	eb 79                	jmp    803c10 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b9b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ba2:	00 00 00 
  803ba5:	8b 12                	mov    (%rdx),%edx
  803ba7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803ba9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803bb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803bbf:	00 00 00 
  803bc2:	8b 12                	mov    (%rdx),%edx
  803bc4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803bc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd5:	48 89 c7             	mov    %rax,%rdi
  803bd8:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  803bdf:	00 00 00 
  803be2:	ff d0                	callq  *%rax
  803be4:	89 c2                	mov    %eax,%edx
  803be6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bea:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bf0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf8:	48 89 c7             	mov    %rax,%rdi
  803bfb:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  803c02:	00 00 00 
  803c05:	ff d0                	callq  *%rax
  803c07:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c09:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0e:	eb 33                	jmp    803c43 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803c10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c14:	48 89 c6             	mov    %rax,%rsi
  803c17:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1c:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c2c:	48 89 c6             	mov    %rax,%rsi
  803c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c34:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803c3b:	00 00 00 
  803c3e:	ff d0                	callq  *%rax
err:
	return r;
  803c40:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c43:	48 83 c4 38          	add    $0x38,%rsp
  803c47:	5b                   	pop    %rbx
  803c48:	5d                   	pop    %rbp
  803c49:	c3                   	retq   

0000000000803c4a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c4a:	55                   	push   %rbp
  803c4b:	48 89 e5             	mov    %rsp,%rbp
  803c4e:	53                   	push   %rbx
  803c4f:	48 83 ec 28          	sub    $0x28,%rsp
  803c53:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c57:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c5b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c62:	00 00 00 
  803c65:	48 8b 00             	mov    (%rax),%rax
  803c68:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c75:	48 89 c7             	mov    %rax,%rdi
  803c78:	48 b8 d0 42 80 00 00 	movabs $0x8042d0,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
  803c84:	89 c3                	mov    %eax,%ebx
  803c86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c8a:	48 89 c7             	mov    %rax,%rdi
  803c8d:	48 b8 d0 42 80 00 00 	movabs $0x8042d0,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
  803c99:	39 c3                	cmp    %eax,%ebx
  803c9b:	0f 94 c0             	sete   %al
  803c9e:	0f b6 c0             	movzbl %al,%eax
  803ca1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ca4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cab:	00 00 00 
  803cae:	48 8b 00             	mov    (%rax),%rax
  803cb1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cb7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803cba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cbd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cc0:	75 05                	jne    803cc7 <_pipeisclosed+0x7d>
			return ret;
  803cc2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cc5:	eb 4f                	jmp    803d16 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803cc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cca:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ccd:	74 42                	je     803d11 <_pipeisclosed+0xc7>
  803ccf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cd3:	75 3c                	jne    803d11 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cd5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cdc:	00 00 00 
  803cdf:	48 8b 00             	mov    (%rax),%rax
  803ce2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ce8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ceb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cee:	89 c6                	mov    %eax,%esi
  803cf0:	48 bf d5 4d 80 00 00 	movabs $0x804dd5,%rdi
  803cf7:	00 00 00 
  803cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803cff:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  803d06:	00 00 00 
  803d09:	41 ff d0             	callq  *%r8
	}
  803d0c:	e9 4a ff ff ff       	jmpq   803c5b <_pipeisclosed+0x11>
  803d11:	e9 45 ff ff ff       	jmpq   803c5b <_pipeisclosed+0x11>
}
  803d16:	48 83 c4 28          	add    $0x28,%rsp
  803d1a:	5b                   	pop    %rbx
  803d1b:	5d                   	pop    %rbp
  803d1c:	c3                   	retq   

0000000000803d1d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803d1d:	55                   	push   %rbp
  803d1e:	48 89 e5             	mov    %rsp,%rbp
  803d21:	48 83 ec 30          	sub    $0x30,%rsp
  803d25:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d2f:	48 89 d6             	mov    %rdx,%rsi
  803d32:	89 c7                	mov    %eax,%edi
  803d34:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
  803d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d47:	79 05                	jns    803d4e <pipeisclosed+0x31>
		return r;
  803d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4c:	eb 31                	jmp    803d7f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d52:	48 89 c7             	mov    %rax,%rdi
  803d55:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803d5c:	00 00 00 
  803d5f:	ff d0                	callq  *%rax
  803d61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d6d:	48 89 d6             	mov    %rdx,%rsi
  803d70:	48 89 c7             	mov    %rax,%rdi
  803d73:	48 b8 4a 3c 80 00 00 	movabs $0x803c4a,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
}
  803d7f:	c9                   	leaveq 
  803d80:	c3                   	retq   

0000000000803d81 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d81:	55                   	push   %rbp
  803d82:	48 89 e5             	mov    %rsp,%rbp
  803d85:	48 83 ec 40          	sub    $0x40,%rsp
  803d89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d99:	48 89 c7             	mov    %rax,%rdi
  803d9c:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	callq  *%rax
  803da8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803dac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803db4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803dbb:	00 
  803dbc:	e9 92 00 00 00       	jmpq   803e53 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803dc1:	eb 41                	jmp    803e04 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803dc3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803dc8:	74 09                	je     803dd3 <devpipe_read+0x52>
				return i;
  803dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dce:	e9 92 00 00 00       	jmpq   803e65 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803dd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ddb:	48 89 d6             	mov    %rdx,%rsi
  803dde:	48 89 c7             	mov    %rax,%rdi
  803de1:	48 b8 4a 3c 80 00 00 	movabs $0x803c4a,%rax
  803de8:	00 00 00 
  803deb:	ff d0                	callq  *%rax
  803ded:	85 c0                	test   %eax,%eax
  803def:	74 07                	je     803df8 <devpipe_read+0x77>
				return 0;
  803df1:	b8 00 00 00 00       	mov    $0x0,%eax
  803df6:	eb 6d                	jmp    803e65 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803df8:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  803dff:	00 00 00 
  803e02:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e08:	8b 10                	mov    (%rax),%edx
  803e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0e:	8b 40 04             	mov    0x4(%rax),%eax
  803e11:	39 c2                	cmp    %eax,%edx
  803e13:	74 ae                	je     803dc3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e1d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e25:	8b 00                	mov    (%rax),%eax
  803e27:	99                   	cltd   
  803e28:	c1 ea 1b             	shr    $0x1b,%edx
  803e2b:	01 d0                	add    %edx,%eax
  803e2d:	83 e0 1f             	and    $0x1f,%eax
  803e30:	29 d0                	sub    %edx,%eax
  803e32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e36:	48 98                	cltq   
  803e38:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e3d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e43:	8b 00                	mov    (%rax),%eax
  803e45:	8d 50 01             	lea    0x1(%rax),%edx
  803e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e4e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e57:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e5b:	0f 82 60 ff ff ff    	jb     803dc1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e65:	c9                   	leaveq 
  803e66:	c3                   	retq   

0000000000803e67 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e67:	55                   	push   %rbp
  803e68:	48 89 e5             	mov    %rsp,%rbp
  803e6b:	48 83 ec 40          	sub    $0x40,%rsp
  803e6f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e73:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e77:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7f:	48 89 c7             	mov    %rax,%rdi
  803e82:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
  803e8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e9a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ea1:	00 
  803ea2:	e9 8e 00 00 00       	jmpq   803f35 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ea7:	eb 31                	jmp    803eda <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb1:	48 89 d6             	mov    %rdx,%rsi
  803eb4:	48 89 c7             	mov    %rax,%rdi
  803eb7:	48 b8 4a 3c 80 00 00 	movabs $0x803c4a,%rax
  803ebe:	00 00 00 
  803ec1:	ff d0                	callq  *%rax
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	74 07                	je     803ece <devpipe_write+0x67>
				return 0;
  803ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecc:	eb 79                	jmp    803f47 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ece:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ede:	8b 40 04             	mov    0x4(%rax),%eax
  803ee1:	48 63 d0             	movslq %eax,%rdx
  803ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee8:	8b 00                	mov    (%rax),%eax
  803eea:	48 98                	cltq   
  803eec:	48 83 c0 20          	add    $0x20,%rax
  803ef0:	48 39 c2             	cmp    %rax,%rdx
  803ef3:	73 b4                	jae    803ea9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef9:	8b 40 04             	mov    0x4(%rax),%eax
  803efc:	99                   	cltd   
  803efd:	c1 ea 1b             	shr    $0x1b,%edx
  803f00:	01 d0                	add    %edx,%eax
  803f02:	83 e0 1f             	and    $0x1f,%eax
  803f05:	29 d0                	sub    %edx,%eax
  803f07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f0b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f0f:	48 01 ca             	add    %rcx,%rdx
  803f12:	0f b6 0a             	movzbl (%rdx),%ecx
  803f15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f19:	48 98                	cltq   
  803f1b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f23:	8b 40 04             	mov    0x4(%rax),%eax
  803f26:	8d 50 01             	lea    0x1(%rax),%edx
  803f29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f2d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f30:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f39:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f3d:	0f 82 64 ff ff ff    	jb     803ea7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f47:	c9                   	leaveq 
  803f48:	c3                   	retq   

0000000000803f49 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f49:	55                   	push   %rbp
  803f4a:	48 89 e5             	mov    %rsp,%rbp
  803f4d:	48 83 ec 20          	sub    $0x20,%rsp
  803f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f5d:	48 89 c7             	mov    %rax,%rdi
  803f60:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  803f67:	00 00 00 
  803f6a:	ff d0                	callq  *%rax
  803f6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f74:	48 be e8 4d 80 00 00 	movabs $0x804de8,%rsi
  803f7b:	00 00 00 
  803f7e:	48 89 c7             	mov    %rax,%rdi
  803f81:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f91:	8b 50 04             	mov    0x4(%rax),%edx
  803f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f98:	8b 00                	mov    (%rax),%eax
  803f9a:	29 c2                	sub    %eax,%edx
  803f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803fa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803faa:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803fb1:	00 00 00 
	stat->st_dev = &devpipe;
  803fb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb8:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803fbf:	00 00 00 
  803fc2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fce:	c9                   	leaveq 
  803fcf:	c3                   	retq   

0000000000803fd0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fd0:	55                   	push   %rbp
  803fd1:	48 89 e5             	mov    %rsp,%rbp
  803fd4:	48 83 ec 10          	sub    $0x10,%rsp
  803fd8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe0:	48 89 c6             	mov    %rax,%rsi
  803fe3:	bf 00 00 00 00       	mov    $0x0,%edi
  803fe8:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803fef:	00 00 00 
  803ff2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ff4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff8:	48 89 c7             	mov    %rax,%rdi
  803ffb:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
  804007:	48 89 c6             	mov    %rax,%rsi
  80400a:	bf 00 00 00 00       	mov    $0x0,%edi
  80400f:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  804016:	00 00 00 
  804019:	ff d0                	callq  *%rax
}
  80401b:	c9                   	leaveq 
  80401c:	c3                   	retq   

000000000080401d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80401d:	55                   	push   %rbp
  80401e:	48 89 e5             	mov    %rsp,%rbp
  804021:	48 83 ec 20          	sub    $0x20,%rsp
  804025:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804028:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80402e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804032:	be 01 00 00 00       	mov    $0x1,%esi
  804037:	48 89 c7             	mov    %rax,%rdi
  80403a:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
}
  804046:	c9                   	leaveq 
  804047:	c3                   	retq   

0000000000804048 <getchar>:

int
getchar(void)
{
  804048:	55                   	push   %rbp
  804049:	48 89 e5             	mov    %rsp,%rbp
  80404c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804050:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804054:	ba 01 00 00 00       	mov    $0x1,%edx
  804059:	48 89 c6             	mov    %rax,%rsi
  80405c:	bf 00 00 00 00       	mov    $0x0,%edi
  804061:	48 b8 9b 2f 80 00 00 	movabs $0x802f9b,%rax
  804068:	00 00 00 
  80406b:	ff d0                	callq  *%rax
  80406d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804074:	79 05                	jns    80407b <getchar+0x33>
		return r;
  804076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804079:	eb 14                	jmp    80408f <getchar+0x47>
	if (r < 1)
  80407b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80407f:	7f 07                	jg     804088 <getchar+0x40>
		return -E_EOF;
  804081:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804086:	eb 07                	jmp    80408f <getchar+0x47>
	return c;
  804088:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80408c:	0f b6 c0             	movzbl %al,%eax
}
  80408f:	c9                   	leaveq 
  804090:	c3                   	retq   

0000000000804091 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804091:	55                   	push   %rbp
  804092:	48 89 e5             	mov    %rsp,%rbp
  804095:	48 83 ec 20          	sub    $0x20,%rsp
  804099:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80409c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040a3:	48 89 d6             	mov    %rdx,%rsi
  8040a6:	89 c7                	mov    %eax,%edi
  8040a8:	48 b8 69 2b 80 00 00 	movabs $0x802b69,%rax
  8040af:	00 00 00 
  8040b2:	ff d0                	callq  *%rax
  8040b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040bb:	79 05                	jns    8040c2 <iscons+0x31>
		return r;
  8040bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c0:	eb 1a                	jmp    8040dc <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8040c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c6:	8b 10                	mov    (%rax),%edx
  8040c8:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8040cf:	00 00 00 
  8040d2:	8b 00                	mov    (%rax),%eax
  8040d4:	39 c2                	cmp    %eax,%edx
  8040d6:	0f 94 c0             	sete   %al
  8040d9:	0f b6 c0             	movzbl %al,%eax
}
  8040dc:	c9                   	leaveq 
  8040dd:	c3                   	retq   

00000000008040de <opencons>:

int
opencons(void)
{
  8040de:	55                   	push   %rbp
  8040df:	48 89 e5             	mov    %rsp,%rbp
  8040e2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040e6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040ea:	48 89 c7             	mov    %rax,%rdi
  8040ed:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  8040f4:	00 00 00 
  8040f7:	ff d0                	callq  *%rax
  8040f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804100:	79 05                	jns    804107 <opencons+0x29>
		return r;
  804102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804105:	eb 5b                	jmp    804162 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410b:	ba 07 04 00 00       	mov    $0x407,%edx
  804110:	48 89 c6             	mov    %rax,%rsi
  804113:	bf 00 00 00 00       	mov    $0x0,%edi
  804118:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  80411f:	00 00 00 
  804122:	ff d0                	callq  *%rax
  804124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412b:	79 05                	jns    804132 <opencons+0x54>
		return r;
  80412d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804130:	eb 30                	jmp    804162 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804136:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80413d:	00 00 00 
  804140:	8b 12                	mov    (%rdx),%edx
  804142:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804148:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80414f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804153:	48 89 c7             	mov    %rax,%rdi
  804156:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  80415d:	00 00 00 
  804160:	ff d0                	callq  *%rax
}
  804162:	c9                   	leaveq 
  804163:	c3                   	retq   

0000000000804164 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804164:	55                   	push   %rbp
  804165:	48 89 e5             	mov    %rsp,%rbp
  804168:	48 83 ec 30          	sub    $0x30,%rsp
  80416c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804170:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804174:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804178:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80417d:	75 07                	jne    804186 <devcons_read+0x22>
		return 0;
  80417f:	b8 00 00 00 00       	mov    $0x0,%eax
  804184:	eb 4b                	jmp    8041d1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804186:	eb 0c                	jmp    804194 <devcons_read+0x30>
		sys_yield();
  804188:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804194:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  80419b:	00 00 00 
  80419e:	ff d0                	callq  *%rax
  8041a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041a7:	74 df                	je     804188 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8041a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ad:	79 05                	jns    8041b4 <devcons_read+0x50>
		return c;
  8041af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b2:	eb 1d                	jmp    8041d1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8041b4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8041b8:	75 07                	jne    8041c1 <devcons_read+0x5d>
		return 0;
  8041ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8041bf:	eb 10                	jmp    8041d1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8041c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c4:	89 c2                	mov    %eax,%edx
  8041c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ca:	88 10                	mov    %dl,(%rax)
	return 1;
  8041cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8041d1:	c9                   	leaveq 
  8041d2:	c3                   	retq   

00000000008041d3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041d3:	55                   	push   %rbp
  8041d4:	48 89 e5             	mov    %rsp,%rbp
  8041d7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041de:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041e5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041ec:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041fa:	eb 76                	jmp    804272 <devcons_write+0x9f>
		m = n - tot;
  8041fc:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804203:	89 c2                	mov    %eax,%edx
  804205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804208:	29 c2                	sub    %eax,%edx
  80420a:	89 d0                	mov    %edx,%eax
  80420c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80420f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804212:	83 f8 7f             	cmp    $0x7f,%eax
  804215:	76 07                	jbe    80421e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804217:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80421e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804221:	48 63 d0             	movslq %eax,%rdx
  804224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804227:	48 63 c8             	movslq %eax,%rcx
  80422a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804231:	48 01 c1             	add    %rax,%rcx
  804234:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80423b:	48 89 ce             	mov    %rcx,%rsi
  80423e:	48 89 c7             	mov    %rax,%rdi
  804241:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  804248:	00 00 00 
  80424b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80424d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804250:	48 63 d0             	movslq %eax,%rdx
  804253:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80425a:	48 89 d6             	mov    %rdx,%rsi
  80425d:	48 89 c7             	mov    %rax,%rdi
  804260:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  804267:	00 00 00 
  80426a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80426c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80426f:	01 45 fc             	add    %eax,-0x4(%rbp)
  804272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804275:	48 98                	cltq   
  804277:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80427e:	0f 82 78 ff ff ff    	jb     8041fc <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804284:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804287:	c9                   	leaveq 
  804288:	c3                   	retq   

0000000000804289 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804289:	55                   	push   %rbp
  80428a:	48 89 e5             	mov    %rsp,%rbp
  80428d:	48 83 ec 08          	sub    $0x8,%rsp
  804291:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80429a:	c9                   	leaveq 
  80429b:	c3                   	retq   

000000000080429c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80429c:	55                   	push   %rbp
  80429d:	48 89 e5             	mov    %rsp,%rbp
  8042a0:	48 83 ec 10          	sub    $0x10,%rsp
  8042a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8042ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b0:	48 be f4 4d 80 00 00 	movabs $0x804df4,%rsi
  8042b7:	00 00 00 
  8042ba:	48 89 c7             	mov    %rax,%rdi
  8042bd:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
	return 0;
  8042c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042ce:	c9                   	leaveq 
  8042cf:	c3                   	retq   

00000000008042d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8042d0:	55                   	push   %rbp
  8042d1:	48 89 e5             	mov    %rsp,%rbp
  8042d4:	48 83 ec 18          	sub    $0x18,%rsp
  8042d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e0:	48 c1 e8 15          	shr    $0x15,%rax
  8042e4:	48 89 c2             	mov    %rax,%rdx
  8042e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042ee:	01 00 00 
  8042f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042f5:	83 e0 01             	and    $0x1,%eax
  8042f8:	48 85 c0             	test   %rax,%rax
  8042fb:	75 07                	jne    804304 <pageref+0x34>
		return 0;
  8042fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804302:	eb 53                	jmp    804357 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804308:	48 c1 e8 0c          	shr    $0xc,%rax
  80430c:	48 89 c2             	mov    %rax,%rdx
  80430f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804316:	01 00 00 
  804319:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80431d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804325:	83 e0 01             	and    $0x1,%eax
  804328:	48 85 c0             	test   %rax,%rax
  80432b:	75 07                	jne    804334 <pageref+0x64>
		return 0;
  80432d:	b8 00 00 00 00       	mov    $0x0,%eax
  804332:	eb 23                	jmp    804357 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804338:	48 c1 e8 0c          	shr    $0xc,%rax
  80433c:	48 89 c2             	mov    %rax,%rdx
  80433f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804346:	00 00 00 
  804349:	48 c1 e2 04          	shl    $0x4,%rdx
  80434d:	48 01 d0             	add    %rdx,%rax
  804350:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804354:	0f b7 c0             	movzwl %ax,%eax
}
  804357:	c9                   	leaveq 
  804358:	c3                   	retq   
