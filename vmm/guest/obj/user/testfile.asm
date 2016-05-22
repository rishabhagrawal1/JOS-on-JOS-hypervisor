
vmm/guest/obj/user/testfile:     file format elf64-x86-64


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
  800087:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
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
  8000af:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 8d 27 80 00 00 	movabs $0x80278d,%rax
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
  8000f6:	48 bf c6 45 80 00 00 	movabs $0x8045c6,%rdi
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
  800127:	48 ba d1 45 80 00 00 	movabs $0x8045d1,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 00 46 80 00 00 	movabs $0x804600,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 21 46 80 00 00 	movabs $0x804621,%rdi
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
  8001b2:	48 ba 2a 46 80 00 00 	movabs $0x80462a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800201:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 75 46 80 00 00 	movabs $0x804675,%rdi
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
  800279:	48 ba 89 46 80 00 00 	movabs $0x804689,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  8002ed:	48 ba 98 46 80 00 00 	movabs $0x804698,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf be 46 80 00 00 	movabs $0x8046be,%rdi
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
  80038b:	48 ba d1 46 80 00 00 	movabs $0x8046d1,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  8003e0:	48 ba df 46 80 00 00 	movabs $0x8046df,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf fd 46 80 00 00 	movabs $0x8046fd,%rdi
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
  80044e:	48 ba 10 47 80 00 00 	movabs $0x804710,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 1f 47 80 00 00 	movabs $0x80471f,%rdi
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
  8004f5:	48 ba 38 47 80 00 00 	movabs $0x804738,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf 6f 47 80 00 00 	movabs $0x80476f,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf 85 47 80 00 00 	movabs $0x804785,%rdi
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
  80056a:	48 ba 8f 47 80 00 00 	movabs $0x80478f,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  8005fc:	48 bf a8 47 80 00 00 	movabs $0x8047a8,%rdi
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
  80068d:	48 ba e8 47 80 00 00 	movabs $0x8047e8,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf f7 47 80 00 00 	movabs $0x8047f7,%rdi
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
  800737:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  80078d:	48 ba 30 48 80 00 00 	movabs $0x804830,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  8007e2:	48 ba 68 48 80 00 00 	movabs $0x804868,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf c6 45 80 00 00 	movabs $0x8045c6,%rdi
  800833:	00 00 00 
  800836:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
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
  80085d:	48 ba bc 48 80 00 00 	movabs $0x8048bc,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba d0 48 80 00 00 	movabs $0x8048d0,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 21 46 80 00 00 	movabs $0x804621,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba eb 48 80 00 00 	movabs $0x8048eb,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800946:	48 ba 00 49 80 00 00 	movabs $0x804900,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 27 49 80 00 00 	movabs $0x804927,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 35 49 80 00 00 	movabs $0x804935,%rdi
  800997:	00 00 00 
  80099a:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 3a 49 80 00 00 	movabs $0x80493a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800a34:	48 b8 2c 33 80 00 00 	movabs $0x80332c,%rax
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
  800a5b:	48 ba 49 49 80 00 00 	movabs $0x804949,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800aa8:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 35 49 80 00 00 	movabs $0x804935,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba 5b 49 80 00 00 	movabs $0x80495b,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800b3d:	48 b8 b7 32 80 00 00 	movabs $0x8032b7,%rax
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
  800b64:	48 ba 69 49 80 00 00 	movabs $0x804969,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800bad:	48 ba 80 49 80 00 00 	movabs $0x804980,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800bfc:	48 ba b0 49 80 00 00 	movabs $0x8049b0,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
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
  800c49:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf d7 49 80 00 00 	movabs $0x8049d7,%rdi
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
  800d01:	48 b8 0b 30 80 00 00 	movabs $0x80300b,%rax
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
  800dda:	48 bf f8 49 80 00 00 	movabs $0x8049f8,%rdi
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
  800e16:	48 bf 1b 4a 80 00 00 	movabs $0x804a1b,%rdi
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
  8010c5:	48 ba 10 4c 80 00 00 	movabs $0x804c10,%rdx
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
  8013bd:	48 b8 38 4c 80 00 00 	movabs $0x804c38,%rax
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
  801510:	48 b8 60 4b 80 00 00 	movabs $0x804b60,%rax
  801517:	00 00 00 
  80151a:	48 63 d3             	movslq %ebx,%rdx
  80151d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801521:	4d 85 e4             	test   %r12,%r12
  801524:	75 2e                	jne    801554 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801526:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80152a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80152e:	89 d9                	mov    %ebx,%ecx
  801530:	48 ba 21 4c 80 00 00 	movabs $0x804c21,%rdx
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
  80155f:	48 ba 2a 4c 80 00 00 	movabs $0x804c2a,%rdx
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
  8015b9:	49 bc 2d 4c 80 00 00 	movabs $0x804c2d,%r12
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
  8022bf:	48 ba e8 4e 80 00 00 	movabs $0x804ee8,%rdx
  8022c6:	00 00 00 
  8022c9:	be 23 00 00 00       	mov    $0x23,%esi
  8022ce:	48 bf 05 4f 80 00 00 	movabs $0x804f05,%rdi
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

000000000080278d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80278d:	55                   	push   %rbp
  80278e:	48 89 e5             	mov    %rsp,%rbp
  802791:	48 83 ec 30          	sub    $0x30,%rsp
  802795:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802799:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80279d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8027a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027a8:	00 00 00 
  8027ab:	48 8b 00             	mov    (%rax),%rax
  8027ae:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	75 34                	jne    8027ec <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8027b8:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027c9:	48 98                	cltq   
  8027cb:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8027d2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027d9:	00 00 00 
  8027dc:	48 01 c2             	add    %rax,%rdx
  8027df:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027e6:	00 00 00 
  8027e9:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8027ec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8027f1:	75 0e                	jne    802801 <ipc_recv+0x74>
		pg = (void*) UTOP;
  8027f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027fa:	00 00 00 
  8027fd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802801:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802805:	48 89 c7             	mov    %rax,%rdi
  802808:	48 b8 66 26 80 00 00 	movabs $0x802666,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
  802814:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802817:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281b:	79 19                	jns    802836 <ipc_recv+0xa9>
		*from_env_store = 0;
  80281d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802821:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802834:	eb 53                	jmp    802889 <ipc_recv+0xfc>
	}
	if(from_env_store)
  802836:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80283b:	74 19                	je     802856 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  80283d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802844:	00 00 00 
  802847:	48 8b 00             	mov    (%rax),%rax
  80284a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802856:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80285b:	74 19                	je     802876 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  80285d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802864:	00 00 00 
  802867:	48 8b 00             	mov    (%rax),%rax
  80286a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802874:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802876:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80287d:	00 00 00 
  802880:	48 8b 00             	mov    (%rax),%rax
  802883:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802889:	c9                   	leaveq 
  80288a:	c3                   	retq   

000000000080288b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80288b:	55                   	push   %rbp
  80288c:	48 89 e5             	mov    %rsp,%rbp
  80288f:	48 83 ec 30          	sub    $0x30,%rsp
  802893:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802896:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802899:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80289d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8028a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028a5:	75 0e                	jne    8028b5 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8028a7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028ae:	00 00 00 
  8028b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8028b5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8028b8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8028bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028c2:	89 c7                	mov    %eax,%edi
  8028c4:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8028d3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8028d7:	75 0c                	jne    8028e5 <ipc_send+0x5a>
			sys_yield();
  8028d9:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8028e5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8028e9:	74 ca                	je     8028b5 <ipc_send+0x2a>
	if(result != 0)
  8028eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ef:	74 20                	je     802911 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f4:	89 c6                	mov    %eax,%esi
  8028f6:	48 bf 18 4f 80 00 00 	movabs $0x804f18,%rdi
  8028fd:	00 00 00 
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
  802905:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80290c:	00 00 00 
  80290f:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  802911:	c9                   	leaveq 
  802912:	c3                   	retq   

0000000000802913 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	53                   	push   %rbx
  802918:	48 83 ec 58          	sub    $0x58,%rsp
  80291c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  802920:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802924:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  802928:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  80292f:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802936:	00 
  802937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80293f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802943:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802947:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80294b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80294f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802953:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  802957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295b:	48 c1 e8 27          	shr    $0x27,%rax
  80295f:	48 89 c2             	mov    %rax,%rdx
  802962:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802969:	01 00 00 
  80296c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802970:	83 e0 01             	and    $0x1,%eax
  802973:	48 85 c0             	test   %rax,%rax
  802976:	0f 85 91 00 00 00    	jne    802a0d <ipc_host_recv+0xfa>
  80297c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802980:	48 c1 e8 1e          	shr    $0x1e,%rax
  802984:	48 89 c2             	mov    %rax,%rdx
  802987:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80298e:	01 00 00 
  802991:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802995:	83 e0 01             	and    $0x1,%eax
  802998:	48 85 c0             	test   %rax,%rax
  80299b:	74 70                	je     802a0d <ipc_host_recv+0xfa>
  80299d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a1:	48 c1 e8 15          	shr    $0x15,%rax
  8029a5:	48 89 c2             	mov    %rax,%rdx
  8029a8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029af:	01 00 00 
  8029b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029b6:	83 e0 01             	and    $0x1,%eax
  8029b9:	48 85 c0             	test   %rax,%rax
  8029bc:	74 4f                	je     802a0d <ipc_host_recv+0xfa>
  8029be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c2:	48 c1 e8 0c          	shr    $0xc,%rax
  8029c6:	48 89 c2             	mov    %rax,%rdx
  8029c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029d0:	01 00 00 
  8029d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d7:	83 e0 01             	and    $0x1,%eax
  8029da:	48 85 c0             	test   %rax,%rax
  8029dd:	74 2e                	je     802a0d <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8029e8:	48 89 c6             	mov    %rax,%rsi
  8029eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f0:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	callq  *%rax
  8029fc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8029ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802a03:	79 08                	jns    802a0d <ipc_host_recv+0xfa>
	    	return result;
  802a05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802a08:	e9 84 00 00 00       	jmpq   802a91 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  802a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a11:	48 c1 e8 0c          	shr    $0xc,%rax
  802a15:	48 89 c2             	mov    %rax,%rdx
  802a18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a1f:	01 00 00 
  802a22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a26:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802a2c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  802a30:	b8 03 00 00 00       	mov    $0x3,%eax
  802a35:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a39:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802a3d:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  802a41:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802a45:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802a49:	4c 89 c3             	mov    %r8,%rbx
  802a4c:	0f 01 c1             	vmcall 
  802a4f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  802a52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802a56:	7e 36                	jle    802a8e <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  802a58:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802a5b:	41 89 c0             	mov    %eax,%r8d
  802a5e:	b9 03 00 00 00       	mov    $0x3,%ecx
  802a63:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  802a6a:	00 00 00 
  802a6d:	be 67 00 00 00       	mov    $0x67,%esi
  802a72:	48 bf 5d 4f 80 00 00 	movabs $0x804f5d,%rdi
  802a79:	00 00 00 
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a81:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  802a88:	00 00 00 
  802a8b:	41 ff d1             	callq  *%r9
	return result;
  802a8e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  802a91:	48 83 c4 58          	add    $0x58,%rsp
  802a95:	5b                   	pop    %rbx
  802a96:	5d                   	pop    %rbp
  802a97:	c3                   	retq   

0000000000802a98 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a98:	55                   	push   %rbp
  802a99:	48 89 e5             	mov    %rsp,%rbp
  802a9c:	53                   	push   %rbx
  802a9d:	48 83 ec 68          	sub    $0x68,%rsp
  802aa1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  802aa4:	89 75 a8             	mov    %esi,-0x58(%rbp)
  802aa7:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  802aab:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  802aae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802ab2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  802ab6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  802abd:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802ac4:	00 
  802ac5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802acd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ad1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802add:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ae1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  802ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae9:	48 c1 e8 27          	shr    $0x27,%rax
  802aed:	48 89 c2             	mov    %rax,%rdx
  802af0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802af7:	01 00 00 
  802afa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802afe:	83 e0 01             	and    $0x1,%eax
  802b01:	48 85 c0             	test   %rax,%rax
  802b04:	0f 85 88 00 00 00    	jne    802b92 <ipc_host_send+0xfa>
  802b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802b12:	48 89 c2             	mov    %rax,%rdx
  802b15:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802b1c:	01 00 00 
  802b1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b23:	83 e0 01             	and    $0x1,%eax
  802b26:	48 85 c0             	test   %rax,%rax
  802b29:	74 67                	je     802b92 <ipc_host_send+0xfa>
  802b2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2f:	48 c1 e8 15          	shr    $0x15,%rax
  802b33:	48 89 c2             	mov    %rax,%rdx
  802b36:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b3d:	01 00 00 
  802b40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b44:	83 e0 01             	and    $0x1,%eax
  802b47:	48 85 c0             	test   %rax,%rax
  802b4a:	74 46                	je     802b92 <ipc_host_send+0xfa>
  802b4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b50:	48 c1 e8 0c          	shr    $0xc,%rax
  802b54:	48 89 c2             	mov    %rax,%rdx
  802b57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b5e:	01 00 00 
  802b61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b65:	83 e0 01             	and    $0x1,%eax
  802b68:	48 85 c0             	test   %rax,%rax
  802b6b:	74 25                	je     802b92 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  802b6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b71:	48 c1 e8 0c          	shr    $0xc,%rax
  802b75:	48 89 c2             	mov    %rax,%rdx
  802b78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b7f:	01 00 00 
  802b82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b86:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802b8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802b90:	eb 0e                	jmp    802ba0 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  802b92:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802b99:	00 00 00 
  802b9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  802ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba4:	48 89 c6             	mov    %rax,%rsi
  802ba7:	48 bf 67 4f 80 00 00 	movabs $0x804f67,%rdi
  802bae:	00 00 00 
  802bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb6:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  802bbd:	00 00 00 
  802bc0:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  802bc2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802bc5:	48 98                	cltq   
  802bc7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  802bcb:	8b 45 a8             	mov    -0x58(%rbp),%eax
  802bce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  802bd2:	8b 45 9c             	mov    -0x64(%rbp),%eax
  802bd5:	48 98                	cltq   
  802bd7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  802bdb:	b8 02 00 00 00       	mov    $0x2,%eax
  802be0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802be4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802be8:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  802bec:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802bf0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bf4:	4c 89 c3             	mov    %r8,%rbx
  802bf7:	0f 01 c1             	vmcall 
  802bfa:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  802bfd:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  802c01:	75 0c                	jne    802c0f <ipc_host_send+0x177>
			sys_yield();
  802c03:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  802c0f:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  802c13:	74 c6                	je     802bdb <ipc_host_send+0x143>
	
	if(result !=0)
  802c15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802c19:	74 36                	je     802c51 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  802c1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c1e:	41 89 c0             	mov    %eax,%r8d
  802c21:	b9 02 00 00 00       	mov    $0x2,%ecx
  802c26:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  802c2d:	00 00 00 
  802c30:	be 94 00 00 00       	mov    $0x94,%esi
  802c35:	48 bf 5d 4f 80 00 00 	movabs $0x804f5d,%rdi
  802c3c:	00 00 00 
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c44:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  802c4b:	00 00 00 
  802c4e:	41 ff d1             	callq  *%r9
}
  802c51:	48 83 c4 68          	add    $0x68,%rsp
  802c55:	5b                   	pop    %rbx
  802c56:	5d                   	pop    %rbp
  802c57:	c3                   	retq   

0000000000802c58 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c58:	55                   	push   %rbp
  802c59:	48 89 e5             	mov    %rsp,%rbp
  802c5c:	48 83 ec 14          	sub    $0x14,%rsp
  802c60:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802c63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c6a:	eb 4e                	jmp    802cba <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  802c6c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802c73:	00 00 00 
  802c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c79:	48 98                	cltq   
  802c7b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802c82:	48 01 d0             	add    %rdx,%rax
  802c85:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802c8b:	8b 00                	mov    (%rax),%eax
  802c8d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c90:	75 24                	jne    802cb6 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802c92:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802c99:	00 00 00 
  802c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9f:	48 98                	cltq   
  802ca1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802ca8:	48 01 d0             	add    %rdx,%rax
  802cab:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802cb1:	8b 40 08             	mov    0x8(%rax),%eax
  802cb4:	eb 12                	jmp    802cc8 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802cb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cba:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802cc1:	7e a9                	jle    802c6c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc8:	c9                   	leaveq 
  802cc9:	c3                   	retq   

0000000000802cca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802cca:	55                   	push   %rbp
  802ccb:	48 89 e5             	mov    %rsp,%rbp
  802cce:	48 83 ec 08          	sub    $0x8,%rsp
  802cd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802cd6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802cda:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802ce1:	ff ff ff 
  802ce4:	48 01 d0             	add    %rdx,%rax
  802ce7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802ceb:	c9                   	leaveq 
  802cec:	c3                   	retq   

0000000000802ced <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ced:	55                   	push   %rbp
  802cee:	48 89 e5             	mov    %rsp,%rbp
  802cf1:	48 83 ec 08          	sub    $0x8,%rsp
  802cf5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802cf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cfd:	48 89 c7             	mov    %rax,%rdi
  802d00:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
  802d0c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802d12:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 18          	sub    $0x18,%rsp
  802d20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d2b:	eb 6b                	jmp    802d98 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d30:	48 98                	cltq   
  802d32:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d38:	48 c1 e0 0c          	shl    $0xc,%rax
  802d3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d44:	48 c1 e8 15          	shr    $0x15,%rax
  802d48:	48 89 c2             	mov    %rax,%rdx
  802d4b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d52:	01 00 00 
  802d55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d59:	83 e0 01             	and    $0x1,%eax
  802d5c:	48 85 c0             	test   %rax,%rax
  802d5f:	74 21                	je     802d82 <fd_alloc+0x6a>
  802d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d65:	48 c1 e8 0c          	shr    $0xc,%rax
  802d69:	48 89 c2             	mov    %rax,%rdx
  802d6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d73:	01 00 00 
  802d76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d7a:	83 e0 01             	and    $0x1,%eax
  802d7d:	48 85 c0             	test   %rax,%rax
  802d80:	75 12                	jne    802d94 <fd_alloc+0x7c>
			*fd_store = fd;
  802d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d8a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	eb 1a                	jmp    802dae <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802d94:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d98:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d9c:	7e 8f                	jle    802d2d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802da9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802dae:	c9                   	leaveq 
  802daf:	c3                   	retq   

0000000000802db0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802db0:	55                   	push   %rbp
  802db1:	48 89 e5             	mov    %rsp,%rbp
  802db4:	48 83 ec 20          	sub    $0x20,%rsp
  802db8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802dbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dc3:	78 06                	js     802dcb <fd_lookup+0x1b>
  802dc5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802dc9:	7e 07                	jle    802dd2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802dcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dd0:	eb 6c                	jmp    802e3e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802dd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd5:	48 98                	cltq   
  802dd7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ddd:	48 c1 e0 0c          	shl    $0xc,%rax
  802de1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802de5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de9:	48 c1 e8 15          	shr    $0x15,%rax
  802ded:	48 89 c2             	mov    %rax,%rdx
  802df0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802df7:	01 00 00 
  802dfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dfe:	83 e0 01             	and    $0x1,%eax
  802e01:	48 85 c0             	test   %rax,%rax
  802e04:	74 21                	je     802e27 <fd_lookup+0x77>
  802e06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0a:	48 c1 e8 0c          	shr    $0xc,%rax
  802e0e:	48 89 c2             	mov    %rax,%rdx
  802e11:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e18:	01 00 00 
  802e1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e1f:	83 e0 01             	and    $0x1,%eax
  802e22:	48 85 c0             	test   %rax,%rax
  802e25:	75 07                	jne    802e2e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802e27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e2c:	eb 10                	jmp    802e3e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802e2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e36:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3e:	c9                   	leaveq 
  802e3f:	c3                   	retq   

0000000000802e40 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802e40:	55                   	push   %rbp
  802e41:	48 89 e5             	mov    %rsp,%rbp
  802e44:	48 83 ec 30          	sub    $0x30,%rsp
  802e48:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e4c:	89 f0                	mov    %esi,%eax
  802e4e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802e51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e55:	48 89 c7             	mov    %rax,%rdi
  802e58:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
  802e64:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e68:	48 89 d6             	mov    %rdx,%rsi
  802e6b:	89 c7                	mov    %eax,%edi
  802e6d:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	callq  *%rax
  802e79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e80:	78 0a                	js     802e8c <fd_close+0x4c>
	    || fd != fd2)
  802e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e86:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802e8a:	74 12                	je     802e9e <fd_close+0x5e>
		return (must_exist ? r : 0);
  802e8c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802e90:	74 05                	je     802e97 <fd_close+0x57>
  802e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e95:	eb 05                	jmp    802e9c <fd_close+0x5c>
  802e97:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9c:	eb 69                	jmp    802f07 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802e9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea2:	8b 00                	mov    (%rax),%eax
  802ea4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ea8:	48 89 d6             	mov    %rdx,%rsi
  802eab:	89 c7                	mov    %eax,%edi
  802ead:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec0:	78 2a                	js     802eec <fd_close+0xac>
		if (dev->dev_close)
  802ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec6:	48 8b 40 20          	mov    0x20(%rax),%rax
  802eca:	48 85 c0             	test   %rax,%rax
  802ecd:	74 16                	je     802ee5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed3:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ed7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802edb:	48 89 d7             	mov    %rdx,%rdi
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	eb 07                	jmp    802eec <fd_close+0xac>
		else
			r = 0;
  802ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802eec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef0:	48 89 c6             	mov    %rax,%rsi
  802ef3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef8:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
	return r;
  802f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f07:	c9                   	leaveq 
  802f08:	c3                   	retq   

0000000000802f09 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802f09:	55                   	push   %rbp
  802f0a:	48 89 e5             	mov    %rsp,%rbp
  802f0d:	48 83 ec 20          	sub    $0x20,%rsp
  802f11:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f1f:	eb 41                	jmp    802f62 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802f21:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802f28:	00 00 00 
  802f2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f2e:	48 63 d2             	movslq %edx,%rdx
  802f31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f35:	8b 00                	mov    (%rax),%eax
  802f37:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802f3a:	75 22                	jne    802f5e <dev_lookup+0x55>
			*dev = devtab[i];
  802f3c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802f43:	00 00 00 
  802f46:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f49:	48 63 d2             	movslq %edx,%rdx
  802f4c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f54:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802f57:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5c:	eb 60                	jmp    802fbe <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802f5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f62:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802f69:	00 00 00 
  802f6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f6f:	48 63 d2             	movslq %edx,%rdx
  802f72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f76:	48 85 c0             	test   %rax,%rax
  802f79:	75 a6                	jne    802f21 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802f7b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f82:	00 00 00 
  802f85:	48 8b 00             	mov    (%rax),%rax
  802f88:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f91:	89 c6                	mov    %eax,%esi
  802f93:	48 bf 78 4f 80 00 00 	movabs $0x804f78,%rdi
  802f9a:	00 00 00 
  802f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa2:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  802fa9:	00 00 00 
  802fac:	ff d1                	callq  *%rcx
	*dev = 0;
  802fae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802fb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802fbe:	c9                   	leaveq 
  802fbf:	c3                   	retq   

0000000000802fc0 <close>:

int
close(int fdnum)
{
  802fc0:	55                   	push   %rbp
  802fc1:	48 89 e5             	mov    %rsp,%rbp
  802fc4:	48 83 ec 20          	sub    $0x20,%rsp
  802fc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fcb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fd2:	48 89 d6             	mov    %rdx,%rsi
  802fd5:	89 c7                	mov    %eax,%edi
  802fd7:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
  802fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fea:	79 05                	jns    802ff1 <close+0x31>
		return r;
  802fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fef:	eb 18                	jmp    803009 <close+0x49>
	else
		return fd_close(fd, 1);
  802ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff5:	be 01 00 00 00       	mov    $0x1,%esi
  802ffa:	48 89 c7             	mov    %rax,%rdi
  802ffd:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  803004:	00 00 00 
  803007:	ff d0                	callq  *%rax
}
  803009:	c9                   	leaveq 
  80300a:	c3                   	retq   

000000000080300b <close_all>:

void
close_all(void)
{
  80300b:	55                   	push   %rbp
  80300c:	48 89 e5             	mov    %rsp,%rbp
  80300f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80301a:	eb 15                	jmp    803031 <close_all+0x26>
		close(i);
  80301c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301f:	89 c7                	mov    %eax,%edi
  803021:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80302d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803031:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803035:	7e e5                	jle    80301c <close_all+0x11>
		close(i);
}
  803037:	c9                   	leaveq 
  803038:	c3                   	retq   

0000000000803039 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 83 ec 40          	sub    $0x40,%rsp
  803041:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803044:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803047:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80304b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80304e:	48 89 d6             	mov    %rdx,%rsi
  803051:	89 c7                	mov    %eax,%edi
  803053:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803066:	79 08                	jns    803070 <dup+0x37>
		return r;
  803068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306b:	e9 70 01 00 00       	jmpq   8031e0 <dup+0x1a7>
	close(newfdnum);
  803070:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803073:	89 c7                	mov    %eax,%edi
  803075:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  80307c:	00 00 00 
  80307f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803081:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803084:	48 98                	cltq   
  803086:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80308c:	48 c1 e0 0c          	shl    $0xc,%rax
  803090:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803094:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803098:	48 89 c7             	mov    %rax,%rdi
  80309b:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
  8030a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	48 89 c7             	mov    %rax,%rdi
  8030b2:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
  8030be:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8030c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c6:	48 c1 e8 15          	shr    $0x15,%rax
  8030ca:	48 89 c2             	mov    %rax,%rdx
  8030cd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8030d4:	01 00 00 
  8030d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030db:	83 e0 01             	and    $0x1,%eax
  8030de:	48 85 c0             	test   %rax,%rax
  8030e1:	74 73                	je     803156 <dup+0x11d>
  8030e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8030eb:	48 89 c2             	mov    %rax,%rdx
  8030ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030f5:	01 00 00 
  8030f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030fc:	83 e0 01             	and    $0x1,%eax
  8030ff:	48 85 c0             	test   %rax,%rax
  803102:	74 52                	je     803156 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803104:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803108:	48 c1 e8 0c          	shr    $0xc,%rax
  80310c:	48 89 c2             	mov    %rax,%rdx
  80310f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803116:	01 00 00 
  803119:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80311d:	25 07 0e 00 00       	and    $0xe07,%eax
  803122:	89 c1                	mov    %eax,%ecx
  803124:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312c:	41 89 c8             	mov    %ecx,%r8d
  80312f:	48 89 d1             	mov    %rdx,%rcx
  803132:	ba 00 00 00 00       	mov    $0x0,%edx
  803137:	48 89 c6             	mov    %rax,%rsi
  80313a:	bf 00 00 00 00       	mov    $0x0,%edi
  80313f:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
  80314b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803152:	79 02                	jns    803156 <dup+0x11d>
			goto err;
  803154:	eb 57                	jmp    8031ad <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803156:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315a:	48 c1 e8 0c          	shr    $0xc,%rax
  80315e:	48 89 c2             	mov    %rax,%rdx
  803161:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803168:	01 00 00 
  80316b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80316f:	25 07 0e 00 00       	and    $0xe07,%eax
  803174:	89 c1                	mov    %eax,%ecx
  803176:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80317e:	41 89 c8             	mov    %ecx,%r8d
  803181:	48 89 d1             	mov    %rdx,%rcx
  803184:	ba 00 00 00 00       	mov    $0x0,%edx
  803189:	48 89 c6             	mov    %rax,%rsi
  80318c:	bf 00 00 00 00       	mov    $0x0,%edi
  803191:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
  80319d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a4:	79 02                	jns    8031a8 <dup+0x16f>
		goto err;
  8031a6:	eb 05                	jmp    8031ad <dup+0x174>

	return newfdnum;
  8031a8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8031ab:	eb 33                	jmp    8031e0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8031ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b1:	48 89 c6             	mov    %rax,%rsi
  8031b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b9:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8031c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c9:	48 89 c6             	mov    %rax,%rsi
  8031cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d1:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
	return r;
  8031dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031e0:	c9                   	leaveq 
  8031e1:	c3                   	retq   

00000000008031e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8031e2:	55                   	push   %rbp
  8031e3:	48 89 e5             	mov    %rsp,%rbp
  8031e6:	48 83 ec 40          	sub    $0x40,%rsp
  8031ea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031fc:	48 89 d6             	mov    %rdx,%rsi
  8031ff:	89 c7                	mov    %eax,%edi
  803201:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803214:	78 24                	js     80323a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321a:	8b 00                	mov    (%rax),%eax
  80321c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803220:	48 89 d6             	mov    %rdx,%rsi
  803223:	89 c7                	mov    %eax,%edi
  803225:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803238:	79 05                	jns    80323f <read+0x5d>
		return r;
  80323a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323d:	eb 76                	jmp    8032b5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80323f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803243:	8b 40 08             	mov    0x8(%rax),%eax
  803246:	83 e0 03             	and    $0x3,%eax
  803249:	83 f8 01             	cmp    $0x1,%eax
  80324c:	75 3a                	jne    803288 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80324e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803255:	00 00 00 
  803258:	48 8b 00             	mov    (%rax),%rax
  80325b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803261:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803264:	89 c6                	mov    %eax,%esi
  803266:	48 bf 97 4f 80 00 00 	movabs $0x804f97,%rdi
  80326d:	00 00 00 
  803270:	b8 00 00 00 00       	mov    $0x0,%eax
  803275:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  80327c:	00 00 00 
  80327f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803281:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803286:	eb 2d                	jmp    8032b5 <read+0xd3>
	}
	if (!dev->dev_read)
  803288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803290:	48 85 c0             	test   %rax,%rax
  803293:	75 07                	jne    80329c <read+0xba>
		return -E_NOT_SUPP;
  803295:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80329a:	eb 19                	jmp    8032b5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80329c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8032a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8032a8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8032ac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8032b0:	48 89 cf             	mov    %rcx,%rdi
  8032b3:	ff d0                	callq  *%rax
}
  8032b5:	c9                   	leaveq 
  8032b6:	c3                   	retq   

00000000008032b7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8032b7:	55                   	push   %rbp
  8032b8:	48 89 e5             	mov    %rsp,%rbp
  8032bb:	48 83 ec 30          	sub    $0x30,%rsp
  8032bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8032ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032d1:	eb 49                	jmp    80331c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d6:	48 98                	cltq   
  8032d8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032dc:	48 29 c2             	sub    %rax,%rdx
  8032df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e2:	48 63 c8             	movslq %eax,%rcx
  8032e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e9:	48 01 c1             	add    %rax,%rcx
  8032ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ef:	48 89 ce             	mov    %rcx,%rsi
  8032f2:	89 c7                	mov    %eax,%edi
  8032f4:	48 b8 e2 31 80 00 00 	movabs $0x8031e2,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
  803300:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803303:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803307:	79 05                	jns    80330e <readn+0x57>
			return m;
  803309:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80330c:	eb 1c                	jmp    80332a <readn+0x73>
		if (m == 0)
  80330e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803312:	75 02                	jne    803316 <readn+0x5f>
			break;
  803314:	eb 11                	jmp    803327 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803316:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803319:	01 45 fc             	add    %eax,-0x4(%rbp)
  80331c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331f:	48 98                	cltq   
  803321:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803325:	72 ac                	jb     8032d3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803327:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80332a:	c9                   	leaveq 
  80332b:	c3                   	retq   

000000000080332c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80332c:	55                   	push   %rbp
  80332d:	48 89 e5             	mov    %rsp,%rbp
  803330:	48 83 ec 40          	sub    $0x40,%rsp
  803334:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803337:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80333b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80333f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803343:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803346:	48 89 d6             	mov    %rdx,%rsi
  803349:	89 c7                	mov    %eax,%edi
  80334b:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335e:	78 24                	js     803384 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803364:	8b 00                	mov    (%rax),%eax
  803366:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80336a:	48 89 d6             	mov    %rdx,%rsi
  80336d:	89 c7                	mov    %eax,%edi
  80336f:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
  80337b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803382:	79 05                	jns    803389 <write+0x5d>
		return r;
  803384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803387:	eb 42                	jmp    8033cb <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338d:	8b 40 08             	mov    0x8(%rax),%eax
  803390:	83 e0 03             	and    $0x3,%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	75 07                	jne    80339e <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80339c:	eb 2d                	jmp    8033cb <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80339e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8033a6:	48 85 c0             	test   %rax,%rax
  8033a9:	75 07                	jne    8033b2 <write+0x86>
		return -E_NOT_SUPP;
  8033ab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033b0:	eb 19                	jmp    8033cb <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8033b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8033ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8033c2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8033c6:	48 89 cf             	mov    %rcx,%rdi
  8033c9:	ff d0                	callq  *%rax
}
  8033cb:	c9                   	leaveq 
  8033cc:	c3                   	retq   

00000000008033cd <seek>:

int
seek(int fdnum, off_t offset)
{
  8033cd:	55                   	push   %rbp
  8033ce:	48 89 e5             	mov    %rsp,%rbp
  8033d1:	48 83 ec 18          	sub    $0x18,%rsp
  8033d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033d8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e2:	48 89 d6             	mov    %rdx,%rsi
  8033e5:	89 c7                	mov    %eax,%edi
  8033e7:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fa:	79 05                	jns    803401 <seek+0x34>
		return r;
  8033fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ff:	eb 0f                	jmp    803410 <seek+0x43>
	fd->fd_offset = offset;
  803401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803405:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80340b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803410:	c9                   	leaveq 
  803411:	c3                   	retq   

0000000000803412 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803412:	55                   	push   %rbp
  803413:	48 89 e5             	mov    %rsp,%rbp
  803416:	48 83 ec 30          	sub    $0x30,%rsp
  80341a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80341d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803420:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803424:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803427:	48 89 d6             	mov    %rdx,%rsi
  80342a:	89 c7                	mov    %eax,%edi
  80342c:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343f:	78 24                	js     803465 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803441:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803445:	8b 00                	mov    (%rax),%eax
  803447:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80344b:	48 89 d6             	mov    %rdx,%rsi
  80344e:	89 c7                	mov    %eax,%edi
  803450:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
  80345c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803463:	79 05                	jns    80346a <ftruncate+0x58>
		return r;
  803465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803468:	eb 72                	jmp    8034dc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80346a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346e:	8b 40 08             	mov    0x8(%rax),%eax
  803471:	83 e0 03             	and    $0x3,%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	75 3a                	jne    8034b2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803478:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80347f:	00 00 00 
  803482:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803485:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80348b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80348e:	89 c6                	mov    %eax,%esi
  803490:	48 bf b8 4f 80 00 00 	movabs $0x804fb8,%rdi
  803497:	00 00 00 
  80349a:	b8 00 00 00 00       	mov    $0x0,%eax
  80349f:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  8034a6:	00 00 00 
  8034a9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8034ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8034b0:	eb 2a                	jmp    8034dc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8034ba:	48 85 c0             	test   %rax,%rax
  8034bd:	75 07                	jne    8034c6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8034bf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034c4:	eb 16                	jmp    8034dc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8034c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ca:	48 8b 40 30          	mov    0x30(%rax),%rax
  8034ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034d2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8034d5:	89 ce                	mov    %ecx,%esi
  8034d7:	48 89 d7             	mov    %rdx,%rdi
  8034da:	ff d0                	callq  *%rax
}
  8034dc:	c9                   	leaveq 
  8034dd:	c3                   	retq   

00000000008034de <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8034de:	55                   	push   %rbp
  8034df:	48 89 e5             	mov    %rsp,%rbp
  8034e2:	48 83 ec 30          	sub    $0x30,%rsp
  8034e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8034e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034f4:	48 89 d6             	mov    %rdx,%rsi
  8034f7:	89 c7                	mov    %eax,%edi
  8034f9:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  803500:	00 00 00 
  803503:	ff d0                	callq  *%rax
  803505:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803508:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350c:	78 24                	js     803532 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80350e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803512:	8b 00                	mov    (%rax),%eax
  803514:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803518:	48 89 d6             	mov    %rdx,%rsi
  80351b:	89 c7                	mov    %eax,%edi
  80351d:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
  803529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80352c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803530:	79 05                	jns    803537 <fstat+0x59>
		return r;
  803532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803535:	eb 5e                	jmp    803595 <fstat+0xb7>
	if (!dev->dev_stat)
  803537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80353f:	48 85 c0             	test   %rax,%rax
  803542:	75 07                	jne    80354b <fstat+0x6d>
		return -E_NOT_SUPP;
  803544:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803549:	eb 4a                	jmp    803595 <fstat+0xb7>
	stat->st_name[0] = 0;
  80354b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803552:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803556:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80355d:	00 00 00 
	stat->st_isdir = 0;
  803560:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803564:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80356b:	00 00 00 
	stat->st_dev = dev;
  80356e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803576:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80357d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803581:	48 8b 40 28          	mov    0x28(%rax),%rax
  803585:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803589:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80358d:	48 89 ce             	mov    %rcx,%rsi
  803590:	48 89 d7             	mov    %rdx,%rdi
  803593:	ff d0                	callq  *%rax
}
  803595:	c9                   	leaveq 
  803596:	c3                   	retq   

0000000000803597 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803597:	55                   	push   %rbp
  803598:	48 89 e5             	mov    %rsp,%rbp
  80359b:	48 83 ec 20          	sub    $0x20,%rsp
  80359f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8035a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ab:	be 00 00 00 00       	mov    $0x0,%esi
  8035b0:	48 89 c7             	mov    %rax,%rdi
  8035b3:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c6:	79 05                	jns    8035cd <stat+0x36>
		return fd;
  8035c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cb:	eb 2f                	jmp    8035fc <stat+0x65>
	r = fstat(fd, stat);
  8035cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d4:	48 89 d6             	mov    %rdx,%rsi
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 de 34 80 00 00 	movabs $0x8034de,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
  8035e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8035e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035eb:	89 c7                	mov    %eax,%edi
  8035ed:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
	return r;
  8035f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8035fc:	c9                   	leaveq 
  8035fd:	c3                   	retq   

00000000008035fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8035fe:	55                   	push   %rbp
  8035ff:	48 89 e5             	mov    %rsp,%rbp
  803602:	48 83 ec 10          	sub    $0x10,%rsp
  803606:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803609:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80360d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803614:	00 00 00 
  803617:	8b 00                	mov    (%rax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	75 1d                	jne    80363a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80361d:	bf 01 00 00 00       	mov    $0x1,%edi
  803622:	48 b8 58 2c 80 00 00 	movabs $0x802c58,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
  80362e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  803635:	00 00 00 
  803638:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80363a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803641:	00 00 00 
  803644:	8b 00                	mov    (%rax),%eax
  803646:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803649:	b9 07 00 00 00       	mov    $0x7,%ecx
  80364e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803655:	00 00 00 
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366a:	ba 00 00 00 00       	mov    $0x0,%edx
  80366f:	48 89 c6             	mov    %rax,%rsi
  803672:	bf 00 00 00 00       	mov    $0x0,%edi
  803677:	48 b8 8d 27 80 00 00 	movabs $0x80278d,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
}
  803683:	c9                   	leaveq 
  803684:	c3                   	retq   

0000000000803685 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803685:	55                   	push   %rbp
  803686:	48 89 e5             	mov    %rsp,%rbp
  803689:	48 83 ec 30          	sub    $0x30,%rsp
  80368d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803691:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803694:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80369b:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8036a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8036a9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036ae:	75 08                	jne    8036b8 <open+0x33>
	{
		return r;
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	e9 f2 00 00 00       	jmpq   8037aa <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8036b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bc:	48 89 c7             	mov    %rax,%rdi
  8036bf:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036ce:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8036d5:	7e 0a                	jle    8036e1 <open+0x5c>
	{
		return -E_BAD_PATH;
  8036d7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8036dc:	e9 c9 00 00 00       	jmpq   8037aa <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8036e1:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8036e8:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8036e9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8036ed:	48 89 c7             	mov    %rax,%rdi
  8036f0:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
  8036fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803703:	78 09                	js     80370e <open+0x89>
  803705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803709:	48 85 c0             	test   %rax,%rax
  80370c:	75 08                	jne    803716 <open+0x91>
		{
			return r;
  80370e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803711:	e9 94 00 00 00       	jmpq   8037aa <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  803716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371a:	ba 00 04 00 00       	mov    $0x400,%edx
  80371f:	48 89 c6             	mov    %rax,%rsi
  803722:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803729:	00 00 00 
  80372c:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803738:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80373f:	00 00 00 
  803742:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803745:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80374b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374f:	48 89 c6             	mov    %rax,%rsi
  803752:	bf 01 00 00 00       	mov    $0x1,%edi
  803757:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
  803763:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803766:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376a:	79 2b                	jns    803797 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80376c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803770:	be 00 00 00 00       	mov    $0x0,%esi
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 40 2e 80 00 00 	movabs $0x802e40,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
  803784:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803787:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80378b:	79 05                	jns    803792 <open+0x10d>
			{
				return d;
  80378d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803790:	eb 18                	jmp    8037aa <open+0x125>
			}
			return r;
  803792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803795:	eb 13                	jmp    8037aa <open+0x125>
		}	
		return fd2num(fd_store);
  803797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379b:	48 89 c7             	mov    %rax,%rdi
  80379e:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8037aa:	c9                   	leaveq 
  8037ab:	c3                   	retq   

00000000008037ac <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 10          	sub    $0x10,%rsp
  8037b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8037b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8037bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8037c6:	00 00 00 
  8037c9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8037cb:	be 00 00 00 00       	mov    $0x0,%esi
  8037d0:	bf 06 00 00 00       	mov    $0x6,%edi
  8037d5:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
}
  8037e1:	c9                   	leaveq 
  8037e2:	c3                   	retq   

00000000008037e3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	48 83 ec 30          	sub    $0x30,%rsp
  8037eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8037f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8037fe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803803:	74 07                	je     80380c <devfile_read+0x29>
  803805:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80380a:	75 07                	jne    803813 <devfile_read+0x30>
		return -E_INVAL;
  80380c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803811:	eb 77                	jmp    80388a <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803817:	8b 50 0c             	mov    0xc(%rax),%edx
  80381a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803821:	00 00 00 
  803824:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803826:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80382d:	00 00 00 
  803830:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803834:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803838:	be 00 00 00 00       	mov    $0x0,%esi
  80383d:	bf 03 00 00 00       	mov    $0x3,%edi
  803842:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
  80384e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803855:	7f 05                	jg     80385c <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385a:	eb 2e                	jmp    80388a <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80385c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385f:	48 63 d0             	movslq %eax,%rdx
  803862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803866:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80386d:	00 00 00 
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80387f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803883:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803887:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80388a:	c9                   	leaveq 
  80388b:	c3                   	retq   

000000000080388c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80388c:	55                   	push   %rbp
  80388d:	48 89 e5             	mov    %rsp,%rbp
  803890:	48 83 ec 30          	sub    $0x30,%rsp
  803894:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803898:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80389c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8038a0:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8038a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8038ac:	74 07                	je     8038b5 <devfile_write+0x29>
  8038ae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8038b3:	75 08                	jne    8038bd <devfile_write+0x31>
		return r;
  8038b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b8:	e9 9a 00 00 00       	jmpq   803957 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8038bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8038c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8038cb:	00 00 00 
  8038ce:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8038d0:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8038d7:	00 
  8038d8:	76 08                	jbe    8038e2 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8038da:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8038e1:	00 
	}
	fsipcbuf.write.req_n = n;
  8038e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8038e9:	00 00 00 
  8038ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038f0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8038f4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038fc:	48 89 c6             	mov    %rax,%rsi
  8038ff:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803906:	00 00 00 
  803909:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803915:	be 00 00 00 00       	mov    $0x0,%esi
  80391a:	bf 04 00 00 00       	mov    $0x4,%edi
  80391f:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
  80392b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803932:	7f 20                	jg     803954 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803934:	48 bf de 4f 80 00 00 	movabs $0x804fde,%rdi
  80393b:	00 00 00 
  80393e:	b8 00 00 00 00       	mov    $0x0,%eax
  803943:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80394a:	00 00 00 
  80394d:	ff d2                	callq  *%rdx
		return r;
  80394f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803952:	eb 03                	jmp    803957 <devfile_write+0xcb>
	}
	return r;
  803954:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803957:	c9                   	leaveq 
  803958:	c3                   	retq   

0000000000803959 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803959:	55                   	push   %rbp
  80395a:	48 89 e5             	mov    %rsp,%rbp
  80395d:	48 83 ec 20          	sub    $0x20,%rsp
  803961:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803965:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80396d:	8b 50 0c             	mov    0xc(%rax),%edx
  803970:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803977:	00 00 00 
  80397a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80397c:	be 00 00 00 00       	mov    $0x0,%esi
  803981:	bf 05 00 00 00       	mov    $0x5,%edi
  803986:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
  803992:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803995:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803999:	79 05                	jns    8039a0 <devfile_stat+0x47>
		return r;
  80399b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399e:	eb 56                	jmp    8039f6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8039a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a4:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8039ab:	00 00 00 
  8039ae:	48 89 c7             	mov    %rax,%rdi
  8039b1:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8039bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8039c4:	00 00 00 
  8039c7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8039cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8039d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8039de:	00 00 00 
  8039e1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8039e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039eb:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8039f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f6:	c9                   	leaveq 
  8039f7:	c3                   	retq   

00000000008039f8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8039f8:	55                   	push   %rbp
  8039f9:	48 89 e5             	mov    %rsp,%rbp
  8039fc:	48 83 ec 10          	sub    $0x10,%rsp
  803a00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a04:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0b:	8b 50 0c             	mov    0xc(%rax),%edx
  803a0e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803a15:	00 00 00 
  803a18:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803a1a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803a21:	00 00 00 
  803a24:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a27:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803a2a:	be 00 00 00 00       	mov    $0x0,%esi
  803a2f:	bf 02 00 00 00       	mov    $0x2,%edi
  803a34:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803a3b:	00 00 00 
  803a3e:	ff d0                	callq  *%rax
}
  803a40:	c9                   	leaveq 
  803a41:	c3                   	retq   

0000000000803a42 <remove>:

// Delete a file
int
remove(const char *path)
{
  803a42:	55                   	push   %rbp
  803a43:	48 89 e5             	mov    %rsp,%rbp
  803a46:	48 83 ec 10          	sub    $0x10,%rsp
  803a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a52:	48 89 c7             	mov    %rax,%rdi
  803a55:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803a5c:	00 00 00 
  803a5f:	ff d0                	callq  *%rax
  803a61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803a66:	7e 07                	jle    803a6f <remove+0x2d>
		return -E_BAD_PATH;
  803a68:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803a6d:	eb 33                	jmp    803aa2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803a6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a73:	48 89 c6             	mov    %rax,%rsi
  803a76:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803a7d:	00 00 00 
  803a80:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803a87:	00 00 00 
  803a8a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803a8c:	be 00 00 00 00       	mov    $0x0,%esi
  803a91:	bf 07 00 00 00       	mov    $0x7,%edi
  803a96:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
}
  803aa2:	c9                   	leaveq 
  803aa3:	c3                   	retq   

0000000000803aa4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803aa4:	55                   	push   %rbp
  803aa5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803aa8:	be 00 00 00 00       	mov    $0x0,%esi
  803aad:	bf 08 00 00 00       	mov    $0x8,%edi
  803ab2:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  803ab9:	00 00 00 
  803abc:	ff d0                	callq  *%rax
}
  803abe:	5d                   	pop    %rbp
  803abf:	c3                   	retq   

0000000000803ac0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803acb:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803ad2:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803ad9:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803ae0:	be 00 00 00 00       	mov    $0x0,%esi
  803ae5:	48 89 c7             	mov    %rax,%rdi
  803ae8:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  803aef:	00 00 00 
  803af2:	ff d0                	callq  *%rax
  803af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afb:	79 28                	jns    803b25 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b00:	89 c6                	mov    %eax,%esi
  803b02:	48 bf fa 4f 80 00 00 	movabs $0x804ffa,%rdi
  803b09:	00 00 00 
  803b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b11:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803b18:	00 00 00 
  803b1b:	ff d2                	callq  *%rdx
		return fd_src;
  803b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b20:	e9 74 01 00 00       	jmpq   803c99 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803b25:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803b2c:	be 01 01 00 00       	mov    $0x101,%esi
  803b31:	48 89 c7             	mov    %rax,%rdi
  803b34:	48 b8 85 36 80 00 00 	movabs $0x803685,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
  803b40:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803b43:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b47:	79 39                	jns    803b82 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803b49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b4c:	89 c6                	mov    %eax,%esi
  803b4e:	48 bf 10 50 80 00 00 	movabs $0x805010,%rdi
  803b55:	00 00 00 
  803b58:	b8 00 00 00 00       	mov    $0x0,%eax
  803b5d:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803b64:	00 00 00 
  803b67:	ff d2                	callq  *%rdx
		close(fd_src);
  803b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6c:	89 c7                	mov    %eax,%edi
  803b6e:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
		return fd_dest;
  803b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7d:	e9 17 01 00 00       	jmpq   803c99 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803b82:	eb 74                	jmp    803bf8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803b84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b87:	48 63 d0             	movslq %eax,%rdx
  803b8a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803b91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b94:	48 89 ce             	mov    %rcx,%rsi
  803b97:	89 c7                	mov    %eax,%edi
  803b99:	48 b8 2c 33 80 00 00 	movabs $0x80332c,%rax
  803ba0:	00 00 00 
  803ba3:	ff d0                	callq  *%rax
  803ba5:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803bac:	79 4a                	jns    803bf8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803bae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bb1:	89 c6                	mov    %eax,%esi
  803bb3:	48 bf 2a 50 80 00 00 	movabs $0x80502a,%rdi
  803bba:	00 00 00 
  803bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc2:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803bc9:	00 00 00 
  803bcc:	ff d2                	callq  *%rdx
			close(fd_src);
  803bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd1:	89 c7                	mov    %eax,%edi
  803bd3:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
			close(fd_dest);
  803bdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803be2:	89 c7                	mov    %eax,%edi
  803be4:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803beb:	00 00 00 
  803bee:	ff d0                	callq  *%rax
			return write_size;
  803bf0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bf3:	e9 a1 00 00 00       	jmpq   803c99 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803bf8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c02:	ba 00 02 00 00       	mov    $0x200,%edx
  803c07:	48 89 ce             	mov    %rcx,%rsi
  803c0a:	89 c7                	mov    %eax,%edi
  803c0c:	48 b8 e2 31 80 00 00 	movabs $0x8031e2,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
  803c18:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c1f:	0f 8f 5f ff ff ff    	jg     803b84 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c29:	79 47                	jns    803c72 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803c2b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c2e:	89 c6                	mov    %eax,%esi
  803c30:	48 bf 3d 50 80 00 00 	movabs $0x80503d,%rdi
  803c37:	00 00 00 
  803c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  803c46:	00 00 00 
  803c49:	ff d2                	callq  *%rdx
		close(fd_src);
  803c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4e:	89 c7                	mov    %eax,%edi
  803c50:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
		close(fd_dest);
  803c5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5f:	89 c7                	mov    %eax,%edi
  803c61:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803c68:	00 00 00 
  803c6b:	ff d0                	callq  *%rax
		return read_size;
  803c6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c70:	eb 27                	jmp    803c99 <copy+0x1d9>
	}
	close(fd_src);
  803c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c75:	89 c7                	mov    %eax,%edi
  803c77:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803c7e:	00 00 00 
  803c81:	ff d0                	callq  *%rax
	close(fd_dest);
  803c83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c86:	89 c7                	mov    %eax,%edi
  803c88:	48 b8 c0 2f 80 00 00 	movabs $0x802fc0,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
	return 0;
  803c94:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803c99:	c9                   	leaveq 
  803c9a:	c3                   	retq   

0000000000803c9b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c9b:	55                   	push   %rbp
  803c9c:	48 89 e5             	mov    %rsp,%rbp
  803c9f:	53                   	push   %rbx
  803ca0:	48 83 ec 38          	sub    $0x38,%rsp
  803ca4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ca8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803cac:	48 89 c7             	mov    %rax,%rdi
  803caf:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
  803cbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc2:	0f 88 bf 01 00 00    	js     803e87 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ccc:	ba 07 04 00 00       	mov    $0x407,%edx
  803cd1:	48 89 c6             	mov    %rax,%rsi
  803cd4:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd9:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803ce0:	00 00 00 
  803ce3:	ff d0                	callq  *%rax
  803ce5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ce8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cec:	0f 88 95 01 00 00    	js     803e87 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cf2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cf6:	48 89 c7             	mov    %rax,%rdi
  803cf9:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  803d00:	00 00 00 
  803d03:	ff d0                	callq  *%rax
  803d05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d0c:	0f 88 5d 01 00 00    	js     803e6f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d16:	ba 07 04 00 00       	mov    $0x407,%edx
  803d1b:	48 89 c6             	mov    %rax,%rsi
  803d1e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d23:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
  803d2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d32:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d36:	0f 88 33 01 00 00    	js     803e6f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d40:	48 89 c7             	mov    %rax,%rdi
  803d43:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
  803d4f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d57:	ba 07 04 00 00       	mov    $0x407,%edx
  803d5c:	48 89 c6             	mov    %rax,%rsi
  803d5f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d64:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
  803d70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d77:	79 05                	jns    803d7e <pipe+0xe3>
		goto err2;
  803d79:	e9 d9 00 00 00       	jmpq   803e57 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d82:	48 89 c7             	mov    %rax,%rdi
  803d85:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  803d8c:	00 00 00 
  803d8f:	ff d0                	callq  *%rax
  803d91:	48 89 c2             	mov    %rax,%rdx
  803d94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d98:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d9e:	48 89 d1             	mov    %rdx,%rcx
  803da1:	ba 00 00 00 00       	mov    $0x0,%edx
  803da6:	48 89 c6             	mov    %rax,%rsi
  803da9:	bf 00 00 00 00       	mov    $0x0,%edi
  803dae:	48 b8 8d 24 80 00 00 	movabs $0x80248d,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
  803dba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc1:	79 1b                	jns    803dde <pipe+0x143>
		goto err3;
  803dc3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803dc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc8:	48 89 c6             	mov    %rax,%rsi
  803dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd0:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803dd7:	00 00 00 
  803dda:	ff d0                	callq  *%rax
  803ddc:	eb 79                	jmp    803e57 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803de9:	00 00 00 
  803dec:	8b 12                	mov    (%rdx),%edx
  803dee:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803df0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803dfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dff:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e06:	00 00 00 
  803e09:	8b 12                	mov    (%rdx),%edx
  803e0b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e11:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e1c:	48 89 c7             	mov    %rax,%rdi
  803e1f:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803e26:	00 00 00 
  803e29:	ff d0                	callq  *%rax
  803e2b:	89 c2                	mov    %eax,%edx
  803e2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e31:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e37:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3f:	48 89 c7             	mov    %rax,%rdi
  803e42:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  803e49:	00 00 00 
  803e4c:	ff d0                	callq  *%rax
  803e4e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e50:	b8 00 00 00 00       	mov    $0x0,%eax
  803e55:	eb 33                	jmp    803e8a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e5b:	48 89 c6             	mov    %rax,%rsi
  803e5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e63:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803e6a:	00 00 00 
  803e6d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e73:	48 89 c6             	mov    %rax,%rsi
  803e76:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7b:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
err:
	return r;
  803e87:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e8a:	48 83 c4 38          	add    $0x38,%rsp
  803e8e:	5b                   	pop    %rbx
  803e8f:	5d                   	pop    %rbp
  803e90:	c3                   	retq   

0000000000803e91 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e91:	55                   	push   %rbp
  803e92:	48 89 e5             	mov    %rsp,%rbp
  803e95:	53                   	push   %rbx
  803e96:	48 83 ec 28          	sub    $0x28,%rsp
  803e9a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e9e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ea2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ea9:	00 00 00 
  803eac:	48 8b 00             	mov    (%rax),%rax
  803eaf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803eb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803eb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ebc:	48 89 c7             	mov    %rax,%rdi
  803ebf:	48 b8 17 45 80 00 00 	movabs $0x804517,%rax
  803ec6:	00 00 00 
  803ec9:	ff d0                	callq  *%rax
  803ecb:	89 c3                	mov    %eax,%ebx
  803ecd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed1:	48 89 c7             	mov    %rax,%rdi
  803ed4:	48 b8 17 45 80 00 00 	movabs $0x804517,%rax
  803edb:	00 00 00 
  803ede:	ff d0                	callq  *%rax
  803ee0:	39 c3                	cmp    %eax,%ebx
  803ee2:	0f 94 c0             	sete   %al
  803ee5:	0f b6 c0             	movzbl %al,%eax
  803ee8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803eeb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ef2:	00 00 00 
  803ef5:	48 8b 00             	mov    (%rax),%rax
  803ef8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803efe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f04:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f07:	75 05                	jne    803f0e <_pipeisclosed+0x7d>
			return ret;
  803f09:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f0c:	eb 4f                	jmp    803f5d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f11:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f14:	74 42                	je     803f58 <_pipeisclosed+0xc7>
  803f16:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f1a:	75 3c                	jne    803f58 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f1c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f23:	00 00 00 
  803f26:	48 8b 00             	mov    (%rax),%rax
  803f29:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f2f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f35:	89 c6                	mov    %eax,%esi
  803f37:	48 bf 5d 50 80 00 00 	movabs $0x80505d,%rdi
  803f3e:	00 00 00 
  803f41:	b8 00 00 00 00       	mov    $0x0,%eax
  803f46:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  803f4d:	00 00 00 
  803f50:	41 ff d0             	callq  *%r8
	}
  803f53:	e9 4a ff ff ff       	jmpq   803ea2 <_pipeisclosed+0x11>
  803f58:	e9 45 ff ff ff       	jmpq   803ea2 <_pipeisclosed+0x11>
}
  803f5d:	48 83 c4 28          	add    $0x28,%rsp
  803f61:	5b                   	pop    %rbx
  803f62:	5d                   	pop    %rbp
  803f63:	c3                   	retq   

0000000000803f64 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f64:	55                   	push   %rbp
  803f65:	48 89 e5             	mov    %rsp,%rbp
  803f68:	48 83 ec 30          	sub    $0x30,%rsp
  803f6c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f76:	48 89 d6             	mov    %rdx,%rsi
  803f79:	89 c7                	mov    %eax,%edi
  803f7b:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  803f82:	00 00 00 
  803f85:	ff d0                	callq  *%rax
  803f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f8e:	79 05                	jns    803f95 <pipeisclosed+0x31>
		return r;
  803f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f93:	eb 31                	jmp    803fc6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f99:	48 89 c7             	mov    %rax,%rdi
  803f9c:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
  803fa8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fb4:	48 89 d6             	mov    %rdx,%rsi
  803fb7:	48 89 c7             	mov    %rax,%rdi
  803fba:	48 b8 91 3e 80 00 00 	movabs $0x803e91,%rax
  803fc1:	00 00 00 
  803fc4:	ff d0                	callq  *%rax
}
  803fc6:	c9                   	leaveq 
  803fc7:	c3                   	retq   

0000000000803fc8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fc8:	55                   	push   %rbp
  803fc9:	48 89 e5             	mov    %rsp,%rbp
  803fcc:	48 83 ec 40          	sub    $0x40,%rsp
  803fd0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fd4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fd8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe0:	48 89 c7             	mov    %rax,%rdi
  803fe3:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  803fea:	00 00 00 
  803fed:	ff d0                	callq  *%rax
  803fef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ff3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ffb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804002:	00 
  804003:	e9 92 00 00 00       	jmpq   80409a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804008:	eb 41                	jmp    80404b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80400a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80400f:	74 09                	je     80401a <devpipe_read+0x52>
				return i;
  804011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804015:	e9 92 00 00 00       	jmpq   8040ac <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80401a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80401e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804022:	48 89 d6             	mov    %rdx,%rsi
  804025:	48 89 c7             	mov    %rax,%rdi
  804028:	48 b8 91 3e 80 00 00 	movabs $0x803e91,%rax
  80402f:	00 00 00 
  804032:	ff d0                	callq  *%rax
  804034:	85 c0                	test   %eax,%eax
  804036:	74 07                	je     80403f <devpipe_read+0x77>
				return 0;
  804038:	b8 00 00 00 00       	mov    $0x0,%eax
  80403d:	eb 6d                	jmp    8040ac <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80403f:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80404b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404f:	8b 10                	mov    (%rax),%edx
  804051:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804055:	8b 40 04             	mov    0x4(%rax),%eax
  804058:	39 c2                	cmp    %eax,%edx
  80405a:	74 ae                	je     80400a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80405c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804060:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804064:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406c:	8b 00                	mov    (%rax),%eax
  80406e:	99                   	cltd   
  80406f:	c1 ea 1b             	shr    $0x1b,%edx
  804072:	01 d0                	add    %edx,%eax
  804074:	83 e0 1f             	and    $0x1f,%eax
  804077:	29 d0                	sub    %edx,%eax
  804079:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80407d:	48 98                	cltq   
  80407f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804084:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408a:	8b 00                	mov    (%rax),%eax
  80408c:	8d 50 01             	lea    0x1(%rax),%edx
  80408f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804093:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804095:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80409a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040a2:	0f 82 60 ff ff ff    	jb     804008 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8040a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040ac:	c9                   	leaveq 
  8040ad:	c3                   	retq   

00000000008040ae <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040ae:	55                   	push   %rbp
  8040af:	48 89 e5             	mov    %rsp,%rbp
  8040b2:	48 83 ec 40          	sub    $0x40,%rsp
  8040b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040be:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c6:	48 89 c7             	mov    %rax,%rdi
  8040c9:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8040d0:	00 00 00 
  8040d3:	ff d0                	callq  *%rax
  8040d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040e1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040e8:	00 
  8040e9:	e9 8e 00 00 00       	jmpq   80417c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040ee:	eb 31                	jmp    804121 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f8:	48 89 d6             	mov    %rdx,%rsi
  8040fb:	48 89 c7             	mov    %rax,%rdi
  8040fe:	48 b8 91 3e 80 00 00 	movabs $0x803e91,%rax
  804105:	00 00 00 
  804108:	ff d0                	callq  *%rax
  80410a:	85 c0                	test   %eax,%eax
  80410c:	74 07                	je     804115 <devpipe_write+0x67>
				return 0;
  80410e:	b8 00 00 00 00       	mov    $0x0,%eax
  804113:	eb 79                	jmp    80418e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804115:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  80411c:	00 00 00 
  80411f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804125:	8b 40 04             	mov    0x4(%rax),%eax
  804128:	48 63 d0             	movslq %eax,%rdx
  80412b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412f:	8b 00                	mov    (%rax),%eax
  804131:	48 98                	cltq   
  804133:	48 83 c0 20          	add    $0x20,%rax
  804137:	48 39 c2             	cmp    %rax,%rdx
  80413a:	73 b4                	jae    8040f0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80413c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804140:	8b 40 04             	mov    0x4(%rax),%eax
  804143:	99                   	cltd   
  804144:	c1 ea 1b             	shr    $0x1b,%edx
  804147:	01 d0                	add    %edx,%eax
  804149:	83 e0 1f             	and    $0x1f,%eax
  80414c:	29 d0                	sub    %edx,%eax
  80414e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804152:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804156:	48 01 ca             	add    %rcx,%rdx
  804159:	0f b6 0a             	movzbl (%rdx),%ecx
  80415c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804160:	48 98                	cltq   
  804162:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416a:	8b 40 04             	mov    0x4(%rax),%eax
  80416d:	8d 50 01             	lea    0x1(%rax),%edx
  804170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804174:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804177:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80417c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804180:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804184:	0f 82 64 ff ff ff    	jb     8040ee <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80418a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80418e:	c9                   	leaveq 
  80418f:	c3                   	retq   

0000000000804190 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804190:	55                   	push   %rbp
  804191:	48 89 e5             	mov    %rsp,%rbp
  804194:	48 83 ec 20          	sub    $0x20,%rsp
  804198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80419c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a4:	48 89 c7             	mov    %rax,%rdi
  8041a7:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
  8041b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8041b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041bb:	48 be 70 50 80 00 00 	movabs $0x805070,%rsi
  8041c2:	00 00 00 
  8041c5:	48 89 c7             	mov    %rax,%rdi
  8041c8:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8041cf:	00 00 00 
  8041d2:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d8:	8b 50 04             	mov    0x4(%rax),%edx
  8041db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041df:	8b 00                	mov    (%rax),%eax
  8041e1:	29 c2                	sub    %eax,%edx
  8041e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041e7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041f8:	00 00 00 
	stat->st_dev = &devpipe;
  8041fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041ff:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  804206:	00 00 00 
  804209:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804215:	c9                   	leaveq 
  804216:	c3                   	retq   

0000000000804217 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804217:	55                   	push   %rbp
  804218:	48 89 e5             	mov    %rsp,%rbp
  80421b:	48 83 ec 10          	sub    $0x10,%rsp
  80421f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804227:	48 89 c6             	mov    %rax,%rsi
  80422a:	bf 00 00 00 00       	mov    $0x0,%edi
  80422f:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  804236:	00 00 00 
  804239:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80423b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423f:	48 89 c7             	mov    %rax,%rdi
  804242:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  804249:	00 00 00 
  80424c:	ff d0                	callq  *%rax
  80424e:	48 89 c6             	mov    %rax,%rsi
  804251:	bf 00 00 00 00       	mov    $0x0,%edi
  804256:	48 b8 e8 24 80 00 00 	movabs $0x8024e8,%rax
  80425d:	00 00 00 
  804260:	ff d0                	callq  *%rax
}
  804262:	c9                   	leaveq 
  804263:	c3                   	retq   

0000000000804264 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804264:	55                   	push   %rbp
  804265:	48 89 e5             	mov    %rsp,%rbp
  804268:	48 83 ec 20          	sub    $0x20,%rsp
  80426c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80426f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804272:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804275:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804279:	be 01 00 00 00       	mov    $0x1,%esi
  80427e:	48 89 c7             	mov    %rax,%rdi
  804281:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  804288:	00 00 00 
  80428b:	ff d0                	callq  *%rax
}
  80428d:	c9                   	leaveq 
  80428e:	c3                   	retq   

000000000080428f <getchar>:

int
getchar(void)
{
  80428f:	55                   	push   %rbp
  804290:	48 89 e5             	mov    %rsp,%rbp
  804293:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804297:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80429b:	ba 01 00 00 00       	mov    $0x1,%edx
  8042a0:	48 89 c6             	mov    %rax,%rsi
  8042a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042a8:	48 b8 e2 31 80 00 00 	movabs $0x8031e2,%rax
  8042af:	00 00 00 
  8042b2:	ff d0                	callq  *%rax
  8042b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8042b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042bb:	79 05                	jns    8042c2 <getchar+0x33>
		return r;
  8042bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c0:	eb 14                	jmp    8042d6 <getchar+0x47>
	if (r < 1)
  8042c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c6:	7f 07                	jg     8042cf <getchar+0x40>
		return -E_EOF;
  8042c8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042cd:	eb 07                	jmp    8042d6 <getchar+0x47>
	return c;
  8042cf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042d3:	0f b6 c0             	movzbl %al,%eax
}
  8042d6:	c9                   	leaveq 
  8042d7:	c3                   	retq   

00000000008042d8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042d8:	55                   	push   %rbp
  8042d9:	48 89 e5             	mov    %rsp,%rbp
  8042dc:	48 83 ec 20          	sub    $0x20,%rsp
  8042e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042ea:	48 89 d6             	mov    %rdx,%rsi
  8042ed:	89 c7                	mov    %eax,%edi
  8042ef:	48 b8 b0 2d 80 00 00 	movabs $0x802db0,%rax
  8042f6:	00 00 00 
  8042f9:	ff d0                	callq  *%rax
  8042fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804302:	79 05                	jns    804309 <iscons+0x31>
		return r;
  804304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804307:	eb 1a                	jmp    804323 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430d:	8b 10                	mov    (%rax),%edx
  80430f:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804316:	00 00 00 
  804319:	8b 00                	mov    (%rax),%eax
  80431b:	39 c2                	cmp    %eax,%edx
  80431d:	0f 94 c0             	sete   %al
  804320:	0f b6 c0             	movzbl %al,%eax
}
  804323:	c9                   	leaveq 
  804324:	c3                   	retq   

0000000000804325 <opencons>:

int
opencons(void)
{
  804325:	55                   	push   %rbp
  804326:	48 89 e5             	mov    %rsp,%rbp
  804329:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80432d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804331:	48 89 c7             	mov    %rax,%rdi
  804334:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  80433b:	00 00 00 
  80433e:	ff d0                	callq  *%rax
  804340:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804343:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804347:	79 05                	jns    80434e <opencons+0x29>
		return r;
  804349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434c:	eb 5b                	jmp    8043a9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80434e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804352:	ba 07 04 00 00       	mov    $0x407,%edx
  804357:	48 89 c6             	mov    %rax,%rsi
  80435a:	bf 00 00 00 00       	mov    $0x0,%edi
  80435f:	48 b8 3d 24 80 00 00 	movabs $0x80243d,%rax
  804366:	00 00 00 
  804369:	ff d0                	callq  *%rax
  80436b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80436e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804372:	79 05                	jns    804379 <opencons+0x54>
		return r;
  804374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804377:	eb 30                	jmp    8043a9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804384:	00 00 00 
  804387:	8b 12                	mov    (%rdx),%edx
  804389:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80438b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439a:	48 89 c7             	mov    %rax,%rdi
  80439d:	48 b8 ca 2c 80 00 00 	movabs $0x802cca,%rax
  8043a4:	00 00 00 
  8043a7:	ff d0                	callq  *%rax
}
  8043a9:	c9                   	leaveq 
  8043aa:	c3                   	retq   

00000000008043ab <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043ab:	55                   	push   %rbp
  8043ac:	48 89 e5             	mov    %rsp,%rbp
  8043af:	48 83 ec 30          	sub    $0x30,%rsp
  8043b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8043bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043c4:	75 07                	jne    8043cd <devcons_read+0x22>
		return 0;
  8043c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8043cb:	eb 4b                	jmp    804418 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8043cd:	eb 0c                	jmp    8043db <devcons_read+0x30>
		sys_yield();
  8043cf:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043db:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  8043e2:	00 00 00 
  8043e5:	ff d0                	callq  *%rax
  8043e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ee:	74 df                	je     8043cf <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8043f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f4:	79 05                	jns    8043fb <devcons_read+0x50>
		return c;
  8043f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f9:	eb 1d                	jmp    804418 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8043fb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8043ff:	75 07                	jne    804408 <devcons_read+0x5d>
		return 0;
  804401:	b8 00 00 00 00       	mov    $0x0,%eax
  804406:	eb 10                	jmp    804418 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804408:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80440b:	89 c2                	mov    %eax,%edx
  80440d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804411:	88 10                	mov    %dl,(%rax)
	return 1;
  804413:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804418:	c9                   	leaveq 
  804419:	c3                   	retq   

000000000080441a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80441a:	55                   	push   %rbp
  80441b:	48 89 e5             	mov    %rsp,%rbp
  80441e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804425:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80442c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804433:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80443a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804441:	eb 76                	jmp    8044b9 <devcons_write+0x9f>
		m = n - tot;
  804443:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80444a:	89 c2                	mov    %eax,%edx
  80444c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444f:	29 c2                	sub    %eax,%edx
  804451:	89 d0                	mov    %edx,%eax
  804453:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804456:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804459:	83 f8 7f             	cmp    $0x7f,%eax
  80445c:	76 07                	jbe    804465 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80445e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804465:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804468:	48 63 d0             	movslq %eax,%rdx
  80446b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80446e:	48 63 c8             	movslq %eax,%rcx
  804471:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804478:	48 01 c1             	add    %rax,%rcx
  80447b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804482:	48 89 ce             	mov    %rcx,%rsi
  804485:	48 89 c7             	mov    %rax,%rdi
  804488:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80448f:	00 00 00 
  804492:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804494:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804497:	48 63 d0             	movslq %eax,%rdx
  80449a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8044a1:	48 89 d6             	mov    %rdx,%rsi
  8044a4:	48 89 c7             	mov    %rax,%rdi
  8044a7:	48 b8 f5 22 80 00 00 	movabs $0x8022f5,%rax
  8044ae:	00 00 00 
  8044b1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044b6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8044b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bc:	48 98                	cltq   
  8044be:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044c5:	0f 82 78 ff ff ff    	jb     804443 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044ce:	c9                   	leaveq 
  8044cf:	c3                   	retq   

00000000008044d0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044d0:	55                   	push   %rbp
  8044d1:	48 89 e5             	mov    %rsp,%rbp
  8044d4:	48 83 ec 08          	sub    $0x8,%rsp
  8044d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044e1:	c9                   	leaveq 
  8044e2:	c3                   	retq   

00000000008044e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044e3:	55                   	push   %rbp
  8044e4:	48 89 e5             	mov    %rsp,%rbp
  8044e7:	48 83 ec 10          	sub    $0x10,%rsp
  8044eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f7:	48 be 7c 50 80 00 00 	movabs $0x80507c,%rsi
  8044fe:	00 00 00 
  804501:	48 89 c7             	mov    %rax,%rdi
  804504:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  80450b:	00 00 00 
  80450e:	ff d0                	callq  *%rax
	return 0;
  804510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804515:	c9                   	leaveq 
  804516:	c3                   	retq   

0000000000804517 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804517:	55                   	push   %rbp
  804518:	48 89 e5             	mov    %rsp,%rbp
  80451b:	48 83 ec 18          	sub    $0x18,%rsp
  80451f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804527:	48 c1 e8 15          	shr    $0x15,%rax
  80452b:	48 89 c2             	mov    %rax,%rdx
  80452e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804535:	01 00 00 
  804538:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80453c:	83 e0 01             	and    $0x1,%eax
  80453f:	48 85 c0             	test   %rax,%rax
  804542:	75 07                	jne    80454b <pageref+0x34>
		return 0;
  804544:	b8 00 00 00 00       	mov    $0x0,%eax
  804549:	eb 53                	jmp    80459e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80454b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80454f:	48 c1 e8 0c          	shr    $0xc,%rax
  804553:	48 89 c2             	mov    %rax,%rdx
  804556:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80455d:	01 00 00 
  804560:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456c:	83 e0 01             	and    $0x1,%eax
  80456f:	48 85 c0             	test   %rax,%rax
  804572:	75 07                	jne    80457b <pageref+0x64>
		return 0;
  804574:	b8 00 00 00 00       	mov    $0x0,%eax
  804579:	eb 23                	jmp    80459e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80457b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457f:	48 c1 e8 0c          	shr    $0xc,%rax
  804583:	48 89 c2             	mov    %rax,%rdx
  804586:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80458d:	00 00 00 
  804590:	48 c1 e2 04          	shl    $0x4,%rdx
  804594:	48 01 d0             	add    %rdx,%rax
  804597:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80459b:	0f b7 c0             	movzwl %ax,%eax
}
  80459e:	c9                   	leaveq 
  80459f:	c3                   	retq   
