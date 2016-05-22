
vmm/guest/obj/user/vmm:     file format elf64-x86-64


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
  80003c:	e8 cd 05 00 00       	callq  80060e <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <map_in_guest>:
// Return 0 on success, <0 on failure.
//

static int
map_in_guest( envid_t guest, uintptr_t gpa, size_t memsz, 
	      int fd, size_t filesz, off_t fileoffset ) {
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 70          	sub    $0x70,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  800052:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  800056:	89 4d b8             	mov    %ecx,-0x48(%rbp)
  800059:	4c 89 45 a0          	mov    %r8,-0x60(%rbp)
  80005d:	44 89 4d 9c          	mov    %r9d,-0x64(%rbp)
	/* Your code here */
	int i=0;
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	int result = 0;
  800068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	int rdsize =0;
  80006f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	/*1st of all round down/up all the sizes*/
	ROUNDDOWN(gpa,PGSIZE);
  800076:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80007a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	ROUNDDOWN(fileoffset,PGSIZE);
  80007e:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800081:	48 98                	cltq   
  800083:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	ROUNDUP(memsz,PGSIZE);
  800087:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  80008e:	00 
  80008f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800093:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800097:	48 01 d0             	add    %rdx,%rax
  80009a:	48 83 e8 01          	sub    $0x1,%rax
  80009e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	ROUNDUP(filesz,PGSIZE);
  8000a2:	48 c7 45 c8 00 10 00 	movq   $0x1000,-0x38(%rbp)
  8000a9:	00 
  8000aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8000ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8000b2:	48 01 d0             	add    %rdx,%rax
  8000b5:	48 83 e8 01          	sub    $0x1,%rax
  8000b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

	/*copy memsz at gpa*/
	for (i = 0;i< memsz;i+=PGSIZE){
  8000bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c4:	e9 28 01 00 00       	jmpq   8001f1 <map_in_guest+0x1ae>

		if((result = sys_page_alloc(0,UTEMP,__EPTE_FULL))<0)
  8000c9:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ce:	be 00 00 40 00       	mov    $0x400000,%esi
  8000d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8000d8:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	callq  *%rax
  8000e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000eb:	79 0a                	jns    8000f7 <map_in_guest+0xb4>
			return -E_NO_SYS; 	
  8000ed:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  8000f2:	e9 0e 01 00 00       	jmpq   800205 <map_in_guest+0x1c2>
		//if file is smaller than memsz, dont return error, simply map empty pages. 
		if(i<filesz){
  8000f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fa:	48 98                	cltq   
  8000fc:	48 3b 45 a0          	cmp    -0x60(%rbp),%rax
  800100:	73 7e                	jae    800180 <map_in_guest+0x13d>
			if((result = seek(fd,fileoffset+i))<0)
  800102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800105:	8b 55 9c             	mov    -0x64(%rbp),%edx
  800108:	01 c2                	add    %eax,%edx
  80010a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80010d:	89 d6                	mov    %edx,%esi
  80010f:	89 c7                	mov    %eax,%edi
  800111:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  800118:	00 00 00 
  80011b:	ff d0                	callq  *%rax
  80011d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800120:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800124:	79 0a                	jns    800130 <map_in_guest+0xed>
				return -E_NO_SYS; 
  800126:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  80012b:	e9 d5 00 00 00       	jmpq   800205 <map_in_guest+0x1c2>
			rdsize = (filesz-i > PGSIZE) ? PGSIZE:filesz-i;
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	48 98                	cltq   
  800135:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800139:	48 29 c2             	sub    %rax,%rdx
  80013c:	48 89 d0             	mov    %rdx,%rax
  80013f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800144:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  80014a:	48 0f 47 c2          	cmova  %rdx,%rax
  80014e:	89 45 f4             	mov    %eax,-0xc(%rbp)
			if((result = readn(fd, UTEMP,rdsize))<0)
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	48 63 d0             	movslq %eax,%rdx
  800157:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80015a:	be 00 00 40 00       	mov    $0x400000,%esi
  80015f:	89 c7                	mov    %eax,%edi
  800161:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800170:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800174:	79 0a                	jns    800180 <map_in_guest+0x13d>
				return -E_NO_SYS; 
  800176:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  80017b:	e9 85 00 00 00       	jmpq   800205 <map_in_guest+0x1c2>
		}
		//cprintf("going to call or gpa = [%x], rdsize = [%d]\n",gpa+i,rdsize);
		if((result = sys_ept_map(0,UTEMP,guest,(void*)(gpa+i),__EPTE_FULL))<0)
  800180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800183:	48 63 d0             	movslq %eax,%rdx
  800186:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80018a:	48 01 d0             	add    %rdx,%rax
  80018d:	48 89 c2             	mov    %rax,%rdx
  800190:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800193:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800199:	48 89 d1             	mov    %rdx,%rcx
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	be 00 00 40 00       	mov    $0x400000,%esi
  8001a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a8:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8001b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001bb:	79 07                	jns    8001c4 <map_in_guest+0x181>
			return -E_NO_SYS; 
  8001bd:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  8001c2:	eb 41                	jmp    800205 <map_in_guest+0x1c2>
		if((result = sys_page_unmap(0,UTEMP))<0)
  8001c4:	be 00 00 40 00       	mov    $0x400000,%esi
  8001c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ce:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax
  8001da:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8001dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001e1:	79 07                	jns    8001ea <map_in_guest+0x1a7>
			return -E_NO_SYS; 
  8001e3:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  8001e8:	eb 1b                	jmp    800205 <map_in_guest+0x1c2>
	ROUNDDOWN(fileoffset,PGSIZE);
	ROUNDUP(memsz,PGSIZE);
	ROUNDUP(filesz,PGSIZE);

	/*copy memsz at gpa*/
	for (i = 0;i< memsz;i+=PGSIZE){
  8001ea:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8001f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f4:	48 98                	cltq   
  8001f6:	48 3b 45 a8          	cmp    -0x58(%rbp),%rax
  8001fa:	0f 82 c9 fe ff ff    	jb     8000c9 <map_in_guest+0x86>
			return -E_NO_SYS; 
		if((result = sys_page_unmap(0,UTEMP))<0)
			return -E_NO_SYS; 
			
	}
	return 0;
  800200:	b8 00 00 00 00       	mov    $0x0,%eax
//	return -E_NO_SYS;

} 
  800205:	c9                   	leaveq 
  800206:	c3                   	retq   

0000000000800207 <copy_guest_kern_gpa>:
static int
copy_guest_kern_gpa( envid_t guest, char* fname ) {
  800207:	55                   	push   %rbp
  800208:	48 89 e5             	mov    %rsp,%rbp
  80020b:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800212:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
  800218:	48 89 b5 c0 fd ff ff 	mov    %rsi,-0x240(%rbp)

/* Your code here */
int fd;
int result = 0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
struct PageInfo *p;
struct Elf * elfHeader;
struct Proghdr *ph, *eph;
char buf[512] = {0};
  800226:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80022d:	b8 00 00 00 00       	mov    $0x0,%eax
  800232:	ba 40 00 00 00       	mov    $0x40,%edx
  800237:	48 89 f7             	mov    %rsi,%rdi
  80023a:	48 89 d1             	mov    %rdx,%rcx
  80023d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
int bytesRead = 0;
  800240:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)

if(fname == NULL)
  800247:	48 83 bd c0 fd ff ff 	cmpq   $0x0,-0x240(%rbp)
  80024e:	00 
  80024f:	75 0a                	jne    80025b <copy_guest_kern_gpa+0x54>
{
        return -E_NO_SYS;
  800251:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
  800256:	e9 1d 02 00 00       	jmpq   800478 <copy_guest_kern_gpa+0x271>
}
if ((fd = open(fname, O_RDONLY)) < 0 ) {
  80025b:	48 8b 85 c0 fd ff ff 	mov    -0x240(%rbp),%rax
  800262:	be 00 00 00 00       	mov    $0x0,%esi
  800267:	48 89 c7             	mov    %rax,%rdi
  80026a:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  800271:	00 00 00 
  800274:	ff d0                	callq  *%rax
  800276:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800279:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80027d:	79 32                	jns    8002b1 <copy_guest_kern_gpa+0xaa>
        cprintf("open %s for read: %e\n", fname, fd );
  80027f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800282:	48 8b 85 c0 fd ff ff 	mov    -0x240(%rbp),%rax
  800289:	48 89 c6             	mov    %rax,%rsi
  80028c:	48 bf e0 3f 80 00 00 	movabs $0x803fe0,%rdi
  800293:	00 00 00 
  800296:	b8 00 00 00 00       	mov    $0x0,%eax
  80029b:	48 b9 d9 07 80 00 00 	movabs $0x8007d9,%rcx
  8002a2:	00 00 00 
  8002a5:	ff d1                	callq  *%rcx
        return -E_INVAL;
  8002a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8002ac:	e9 c7 01 00 00       	jmpq   800478 <copy_guest_kern_gpa+0x271>
}

bytesRead = read(fd, buf, 512);
  8002b1:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8002b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bb:	ba 00 02 00 00       	mov    $0x200,%edx
  8002c0:	48 89 ce             	mov    %rcx,%rsi
  8002c3:	89 c7                	mov    %eax,%edi
  8002c5:	48 b8 25 25 80 00 00 	movabs $0x802525,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
  8002d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
if(bytesRead < 512)
  8002d4:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8002db:	7f 3b                	jg     800318 <copy_guest_kern_gpa+0x111>
{
        close(fd);
  8002dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e0:	89 c7                	mov    %eax,%edi
  8002e2:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
        cprintf("Error in reading ELF header bytes read are %d\n", bytesRead);
  8002ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002f1:	89 c6                	mov    %eax,%esi
  8002f3:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  8002fa:	00 00 00 
  8002fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800302:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  800309:	00 00 00 
  80030c:	ff d2                	callq  *%rdx
        return -E_NOT_EXEC;
  80030e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800313:	e9 60 01 00 00       	jmpq   800478 <copy_guest_kern_gpa+0x271>
}
elfHeader = (struct Elf *) buf;
  800318:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80031f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
// is this a valid ELF?
if (elfHeader->e_magic != ELF_MAGIC){
  800323:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800327:	8b 00                	mov    (%rax),%eax
  800329:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80032e:	74 36                	je     800366 <copy_guest_kern_gpa+0x15f>
        close(fd);
  800330:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800333:	89 c7                	mov    %eax,%edi
  800335:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
        cprintf("loading ELF header Failed due to Corrupt Kernel ELF\n");
  800341:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  800348:	00 00 00 
  80034b:	b8 00 00 00 00       	mov    $0x0,%eax
  800350:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  800357:	00 00 00 
  80035a:	ff d2                	callq  *%rdx
        return -E_NOT_EXEC;
  80035c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800361:	e9 12 01 00 00       	jmpq   800478 <copy_guest_kern_gpa+0x271>
}

   ph = (struct Proghdr *) (buf + elfHeader->e_phoff);
  800366:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80036a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80036e:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800375:	48 01 d0             	add    %rdx,%rax
  800378:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		eph = ph + elfHeader->e_phnum;
  80037c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800380:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  800384:	0f b7 c0             	movzwl %ax,%eax
  800387:	48 c1 e0 03          	shl    $0x3,%rax
  80038b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800392:	00 
  800393:	48 29 c2             	sub    %rax,%rdx
  800396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80039a:	48 01 d0             	add    %rdx,%rax
  80039d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

		for (;ph < eph; ph++){
  8003a1:	e9 ae 00 00 00       	jmpq   800454 <copy_guest_kern_gpa+0x24d>
				if(ELF_PROG_LOAD == ph->p_type){
  8003a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003aa:	8b 00                	mov    (%rax),%eax
  8003ac:	83 f8 01             	cmp    $0x1,%eax
  8003af:	0f 85 9a 00 00 00    	jne    80044f <copy_guest_kern_gpa+0x248>
						if(ph->p_filesz <= ph->p_memsz){
  8003b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003b9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8003bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8003c5:	48 39 c2             	cmp    %rax,%rdx
  8003c8:	0f 87 81 00 00 00    	ja     80044f <copy_guest_kern_gpa+0x248>
								if ((result = map_in_guest(guest, ph->p_pa, ph->p_memsz, fd, ph->p_filesz, ph->p_offset)) < 0) {
  8003ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003d2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8003d6:	41 89 c0             	mov    %eax,%r8d
  8003d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003dd:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8003e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e5:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8003e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ed:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8003f1:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  8003f4:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8003fa:	45 89 c1             	mov    %r8d,%r9d
  8003fd:	49 89 f8             	mov    %rdi,%r8
  800400:	89 c7                	mov    %eax,%edi
  800402:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800409:	00 00 00 
  80040c:	ff d0                	callq  *%rax
  80040e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800411:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800415:	79 38                	jns    80044f <copy_guest_kern_gpa+0x248>
										cprintf("Error mapping bootloader into the guest - %d\n.", result);
  800417:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80041a:	89 c6                	mov    %eax,%esi
  80041c:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  800423:	00 00 00 
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  800432:	00 00 00 
  800435:	ff d2                	callq  *%rdx
										close(fd);
  800437:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80043a:	89 c7                	mov    %eax,%edi
  80043c:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
										return -E_INVAL;
  800448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044d:	eb 29                	jmp    800478 <copy_guest_kern_gpa+0x271>
}

   ph = (struct Proghdr *) (buf + elfHeader->e_phoff);
		eph = ph + elfHeader->e_phnum;

		for (;ph < eph; ph++){
  80044f:	48 83 45 f8 38       	addq   $0x38,-0x8(%rbp)
  800454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800458:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80045c:	0f 82 44 ff ff ff    	jb     8003a6 <copy_guest_kern_gpa+0x19f>
										return -E_INVAL;
								}
						}
				}
		}
		close(fd);
  800462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800465:	89 c7                	mov    %eax,%edi
  800467:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  80046e:	00 00 00 
  800471:	ff d0                	callq  *%rax
		return 0;
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800478:	c9                   	leaveq 
  800479:	c3                   	retq   

000000000080047a <umain>:
// Return 0 on success, <0 on error
//
// Hint: compare with ELF parsing in env.c, and use map_in_guest for each segment.

void
umain(int argc, char **argv) {
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	48 83 ec 50          	sub    $0x50,%rsp
  800482:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800485:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
  800489:	be 00 70 00 00       	mov    $0x7000,%esi
  80048e:	bf 00 00 00 01       	mov    $0x1000000,%edi
  800493:	48 b8 c3 1f 80 00 00 	movabs $0x801fc3,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	callq  *%rax
  80049f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004a6:	79 2c                	jns    8004d4 <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  8004a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ab:	89 c6                	mov    %eax,%esi
  8004ad:	48 bf 90 40 80 00 00 	movabs $0x804090,%rdi
  8004b4:	00 00 00 
  8004b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bc:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  8004c3:	00 00 00 
  8004c6:	ff d2                	callq  *%rdx
		exit();
  8004c8:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
	}
	guest = ret;
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8004da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004dd:	48 be b3 40 80 00 00 	movabs $0x8040b3,%rsi
  8004e4:	00 00 00 
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 07 02 80 00 00 	movabs $0x800207,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
  8004f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004fc:	79 2c                	jns    80052a <umain+0xb0>
		cprintf("Error copying page into the guest - %d\n.", ret);
  8004fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800501:	89 c6                	mov    %eax,%esi
  800503:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  80050a:	00 00 00 
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  800519:	00 00 00 
  80051c:	ff d2                	callq  *%rdx
		exit();
  80051e:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  80052a:	be 00 00 00 00       	mov    $0x0,%esi
  80052f:	48 bf e9 40 80 00 00 	movabs $0x8040e9,%rdi
  800536:	00 00 00 
  800539:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  800540:	00 00 00 
  800543:	ff d0                	callq  *%rax
  800545:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800548:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80054c:	79 36                	jns    800584 <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  80054e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800551:	89 c2                	mov    %eax,%edx
  800553:	48 be e9 40 80 00 00 	movabs $0x8040e9,%rsi
  80055a:	00 00 00 
  80055d:	48 bf e0 3f 80 00 00 	movabs $0x803fe0,%rdi
  800564:	00 00 00 
  800567:	b8 00 00 00 00       	mov    $0x0,%eax
  80056c:	48 b9 d9 07 80 00 00 	movabs $0x8007d9,%rcx
  800573:	00 00 00 
  800576:	ff d1                	callq  *%rcx
		exit();
  800578:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
	}

	// sizeof(bootloader) < 512.
	if ((ret = map_in_guest(guest, JOS_ENTRY, 512, fd, 512, 0)) < 0) {
  800584:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800587:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80058a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800590:	41 b8 00 02 00 00    	mov    $0x200,%r8d
  800596:	89 d1                	mov    %edx,%ecx
  800598:	ba 00 02 00 00       	mov    $0x200,%edx
  80059d:	be 00 70 00 00       	mov    $0x7000,%esi
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
  8005b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8005b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005b7:	79 2c                	jns    8005e5 <umain+0x16b>
		cprintf("Error mapping bootloader into the guest - %d\n.", ret);
  8005b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005bc:	89 c6                	mov    %eax,%esi
  8005be:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  8005c5:	00 00 00 
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  8005d4:	00 00 00 
  8005d7:	ff d2                	callq  *%rdx
		exit();
  8005d9:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  8005e0:	00 00 00 
  8005e3:	ff d0                	callq  *%rax
        }
        
        cprintf("Create VHD finished\n");
#endif
	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  8005e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005e8:	be 02 00 00 00       	mov    $0x2,%esi
  8005ed:	89 c7                	mov    %eax,%edi
  8005ef:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8005f6:	00 00 00 
  8005f9:	ff d0                	callq  *%rax
	wait(guest);
  8005fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fe:	89 c7                	mov    %eax,%edi
  800600:	48 b8 a7 35 80 00 00 	movabs $0x8035a7,%rax
  800607:	00 00 00 
  80060a:	ff d0                	callq  *%rax
}
  80060c:	c9                   	leaveq 
  80060d:	c3                   	retq   

000000000080060e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80060e:	55                   	push   %rbp
  80060f:	48 89 e5             	mov    %rsp,%rbp
  800612:	48 83 ec 10          	sub    $0x10,%rsp
  800616:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800619:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80061d:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  800624:	00 00 00 
  800627:	ff d0                	callq  *%rax
  800629:	25 ff 03 00 00       	and    $0x3ff,%eax
  80062e:	48 98                	cltq   
  800630:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800637:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80063e:	00 00 00 
  800641:	48 01 c2             	add    %rax,%rdx
  800644:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80064b:	00 00 00 
  80064e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800655:	7e 14                	jle    80066b <libmain+0x5d>
		binaryname = argv[0];
  800657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065b:	48 8b 10             	mov    (%rax),%rdx
  80065e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800665:	00 00 00 
  800668:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80066b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800672:	48 89 d6             	mov    %rdx,%rsi
  800675:	89 c7                	mov    %eax,%edi
  800677:	48 b8 7a 04 80 00 00 	movabs $0x80047a,%rax
  80067e:	00 00 00 
  800681:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800683:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  80068a:	00 00 00 
  80068d:	ff d0                	callq  *%rax
}
  80068f:	c9                   	leaveq 
  800690:	c3                   	retq   

0000000000800691 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800691:	55                   	push   %rbp
  800692:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800695:	48 b8 4e 23 80 00 00 	movabs $0x80234e,%rax
  80069c:	00 00 00 
  80069f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8006a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8006a6:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax

}
  8006b2:	5d                   	pop    %rbp
  8006b3:	c3                   	retq   

00000000008006b4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006b4:	55                   	push   %rbp
  8006b5:	48 89 e5             	mov    %rsp,%rbp
  8006b8:	48 83 ec 10          	sub    $0x10,%rsp
  8006bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	8d 48 01             	lea    0x1(%rax),%ecx
  8006cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006d0:	89 0a                	mov    %ecx,(%rdx)
  8006d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006d5:	89 d1                	mov    %edx,%ecx
  8006d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006db:	48 98                	cltq   
  8006dd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ec:	75 2c                	jne    80071a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f2:	8b 00                	mov    (%rax),%eax
  8006f4:	48 98                	cltq   
  8006f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fa:	48 83 c2 08          	add    $0x8,%rdx
  8006fe:	48 89 c6             	mov    %rax,%rsi
  800701:	48 89 d7             	mov    %rdx,%rdi
  800704:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  80070b:	00 00 00 
  80070e:	ff d0                	callq  *%rax
        b->idx = 0;
  800710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800714:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80071a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071e:	8b 40 04             	mov    0x4(%rax),%eax
  800721:	8d 50 01             	lea    0x1(%rax),%edx
  800724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800728:	89 50 04             	mov    %edx,0x4(%rax)
}
  80072b:	c9                   	leaveq 
  80072c:	c3                   	retq   

000000000080072d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80072d:	55                   	push   %rbp
  80072e:	48 89 e5             	mov    %rsp,%rbp
  800731:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800738:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80073f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800746:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80074d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800754:	48 8b 0a             	mov    (%rdx),%rcx
  800757:	48 89 08             	mov    %rcx,(%rax)
  80075a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80075e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800762:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800766:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80076a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800771:	00 00 00 
    b.cnt = 0;
  800774:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80077b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80077e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800785:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80078c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800793:	48 89 c6             	mov    %rax,%rsi
  800796:	48 bf b4 06 80 00 00 	movabs $0x8006b4,%rdi
  80079d:	00 00 00 
  8007a0:	48 b8 8c 0b 80 00 00 	movabs $0x800b8c,%rax
  8007a7:	00 00 00 
  8007aa:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007ac:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007b2:	48 98                	cltq   
  8007b4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007bb:	48 83 c2 08          	add    $0x8,%rdx
  8007bf:	48 89 c6             	mov    %rax,%rsi
  8007c2:	48 89 d7             	mov    %rdx,%rdi
  8007c5:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007d7:	c9                   	leaveq 
  8007d8:	c3                   	retq   

00000000008007d9 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007d9:	55                   	push   %rbp
  8007da:	48 89 e5             	mov    %rsp,%rbp
  8007dd:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007e4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007eb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8007f2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007f9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800800:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800807:	84 c0                	test   %al,%al
  800809:	74 20                	je     80082b <cprintf+0x52>
  80080b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80080f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800813:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800817:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80081b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80081f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800823:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800827:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80082b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800832:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800839:	00 00 00 
  80083c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800843:	00 00 00 
  800846:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80084a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800851:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800858:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80085f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800866:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80086d:	48 8b 0a             	mov    (%rdx),%rcx
  800870:	48 89 08             	mov    %rcx,(%rax)
  800873:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800877:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80087b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800883:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80088a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800891:	48 89 d6             	mov    %rdx,%rsi
  800894:	48 89 c7             	mov    %rax,%rdi
  800897:	48 b8 2d 07 80 00 00 	movabs $0x80072d,%rax
  80089e:	00 00 00 
  8008a1:	ff d0                	callq  *%rax
  8008a3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008a9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008af:	c9                   	leaveq 
  8008b0:	c3                   	retq   

00000000008008b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008b1:	55                   	push   %rbp
  8008b2:	48 89 e5             	mov    %rsp,%rbp
  8008b5:	53                   	push   %rbx
  8008b6:	48 83 ec 38          	sub    $0x38,%rsp
  8008ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008c6:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008c9:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008cd:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008d4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8008d8:	77 3b                	ja     800915 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008da:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8008dd:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8008e1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8008e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ed:	48 f7 f3             	div    %rbx
  8008f0:	48 89 c2             	mov    %rax,%rdx
  8008f3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8008f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008f9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	41 89 f9             	mov    %edi,%r9d
  800904:	48 89 c7             	mov    %rax,%rdi
  800907:	48 b8 b1 08 80 00 00 	movabs $0x8008b1,%rax
  80090e:	00 00 00 
  800911:	ff d0                	callq  *%rax
  800913:	eb 1e                	jmp    800933 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800915:	eb 12                	jmp    800929 <printnum+0x78>
			putch(padc, putdat);
  800917:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80091b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800922:	48 89 ce             	mov    %rcx,%rsi
  800925:	89 d7                	mov    %edx,%edi
  800927:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800929:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80092d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800931:	7f e4                	jg     800917 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800933:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	48 f7 f1             	div    %rcx
  800942:	48 89 d0             	mov    %rdx,%rax
  800945:	48 ba f0 42 80 00 00 	movabs $0x8042f0,%rdx
  80094c:	00 00 00 
  80094f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800953:	0f be d0             	movsbl %al,%edx
  800956:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	48 89 ce             	mov    %rcx,%rsi
  800961:	89 d7                	mov    %edx,%edi
  800963:	ff d0                	callq  *%rax
}
  800965:	48 83 c4 38          	add    $0x38,%rsp
  800969:	5b                   	pop    %rbx
  80096a:	5d                   	pop    %rbp
  80096b:	c3                   	retq   

000000000080096c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80096c:	55                   	push   %rbp
  80096d:	48 89 e5             	mov    %rsp,%rbp
  800970:	48 83 ec 1c          	sub    $0x1c,%rsp
  800974:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800978:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80097b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80097f:	7e 52                	jle    8009d3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	83 f8 30             	cmp    $0x30,%eax
  80098a:	73 24                	jae    8009b0 <getuint+0x44>
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	8b 00                	mov    (%rax),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	8b 12                	mov    (%rdx),%edx
  8009a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	89 0a                	mov    %ecx,(%rdx)
  8009ae:	eb 17                	jmp    8009c7 <getuint+0x5b>
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b8:	48 89 d0             	mov    %rdx,%rax
  8009bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c7:	48 8b 00             	mov    (%rax),%rax
  8009ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009ce:	e9 a3 00 00 00       	jmpq   800a76 <getuint+0x10a>
	else if (lflag)
  8009d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009d7:	74 4f                	je     800a28 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	8b 00                	mov    (%rax),%eax
  8009df:	83 f8 30             	cmp    $0x30,%eax
  8009e2:	73 24                	jae    800a08 <getuint+0x9c>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	8b 00                	mov    (%rax),%eax
  8009f2:	89 c0                	mov    %eax,%eax
  8009f4:	48 01 d0             	add    %rdx,%rax
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	8b 12                	mov    (%rdx),%edx
  8009fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a04:	89 0a                	mov    %ecx,(%rdx)
  800a06:	eb 17                	jmp    800a1f <getuint+0xb3>
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a10:	48 89 d0             	mov    %rdx,%rax
  800a13:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1f:	48 8b 00             	mov    (%rax),%rax
  800a22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a26:	eb 4e                	jmp    800a76 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2c:	8b 00                	mov    (%rax),%eax
  800a2e:	83 f8 30             	cmp    $0x30,%eax
  800a31:	73 24                	jae    800a57 <getuint+0xeb>
  800a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a37:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3f:	8b 00                	mov    (%rax),%eax
  800a41:	89 c0                	mov    %eax,%eax
  800a43:	48 01 d0             	add    %rdx,%rax
  800a46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4a:	8b 12                	mov    (%rdx),%edx
  800a4c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a53:	89 0a                	mov    %ecx,(%rdx)
  800a55:	eb 17                	jmp    800a6e <getuint+0x102>
  800a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a5f:	48 89 d0             	mov    %rdx,%rax
  800a62:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6e:	8b 00                	mov    (%rax),%eax
  800a70:	89 c0                	mov    %eax,%eax
  800a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a7a:	c9                   	leaveq 
  800a7b:	c3                   	retq   

0000000000800a7c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a7c:	55                   	push   %rbp
  800a7d:	48 89 e5             	mov    %rsp,%rbp
  800a80:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a88:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a8b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a8f:	7e 52                	jle    800ae3 <getint+0x67>
		x=va_arg(*ap, long long);
  800a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a95:	8b 00                	mov    (%rax),%eax
  800a97:	83 f8 30             	cmp    $0x30,%eax
  800a9a:	73 24                	jae    800ac0 <getint+0x44>
  800a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa8:	8b 00                	mov    (%rax),%eax
  800aaa:	89 c0                	mov    %eax,%eax
  800aac:	48 01 d0             	add    %rdx,%rax
  800aaf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab3:	8b 12                	mov    (%rdx),%edx
  800ab5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abc:	89 0a                	mov    %ecx,(%rdx)
  800abe:	eb 17                	jmp    800ad7 <getint+0x5b>
  800ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ac8:	48 89 d0             	mov    %rdx,%rax
  800acb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800acf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad7:	48 8b 00             	mov    (%rax),%rax
  800ada:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ade:	e9 a3 00 00 00       	jmpq   800b86 <getint+0x10a>
	else if (lflag)
  800ae3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ae7:	74 4f                	je     800b38 <getint+0xbc>
		x=va_arg(*ap, long);
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	8b 00                	mov    (%rax),%eax
  800aef:	83 f8 30             	cmp    $0x30,%eax
  800af2:	73 24                	jae    800b18 <getint+0x9c>
  800af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b00:	8b 00                	mov    (%rax),%eax
  800b02:	89 c0                	mov    %eax,%eax
  800b04:	48 01 d0             	add    %rdx,%rax
  800b07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0b:	8b 12                	mov    (%rdx),%edx
  800b0d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b14:	89 0a                	mov    %ecx,(%rdx)
  800b16:	eb 17                	jmp    800b2f <getint+0xb3>
  800b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b20:	48 89 d0             	mov    %rdx,%rax
  800b23:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b2f:	48 8b 00             	mov    (%rax),%rax
  800b32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b36:	eb 4e                	jmp    800b86 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3c:	8b 00                	mov    (%rax),%eax
  800b3e:	83 f8 30             	cmp    $0x30,%eax
  800b41:	73 24                	jae    800b67 <getint+0xeb>
  800b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b47:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4f:	8b 00                	mov    (%rax),%eax
  800b51:	89 c0                	mov    %eax,%eax
  800b53:	48 01 d0             	add    %rdx,%rax
  800b56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5a:	8b 12                	mov    (%rdx),%edx
  800b5c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b63:	89 0a                	mov    %ecx,(%rdx)
  800b65:	eb 17                	jmp    800b7e <getint+0x102>
  800b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b6f:	48 89 d0             	mov    %rdx,%rax
  800b72:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b7e:	8b 00                	mov    (%rax),%eax
  800b80:	48 98                	cltq   
  800b82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b8a:	c9                   	leaveq 
  800b8b:	c3                   	retq   

0000000000800b8c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b8c:	55                   	push   %rbp
  800b8d:	48 89 e5             	mov    %rsp,%rbp
  800b90:	41 54                	push   %r12
  800b92:	53                   	push   %rbx
  800b93:	48 83 ec 60          	sub    $0x60,%rsp
  800b97:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b9b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b9f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ba7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bab:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800baf:	48 8b 0a             	mov    (%rdx),%rcx
  800bb2:	48 89 08             	mov    %rcx,(%rax)
  800bb5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bbd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc5:	eb 17                	jmp    800bde <vprintfmt+0x52>
			if (ch == '\0')
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	0f 84 cc 04 00 00    	je     80109b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800bcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	48 89 d6             	mov    %rdx,%rsi
  800bda:	89 df                	mov    %ebx,%edi
  800bdc:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bde:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800be6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bea:	0f b6 00             	movzbl (%rax),%eax
  800bed:	0f b6 d8             	movzbl %al,%ebx
  800bf0:	83 fb 25             	cmp    $0x25,%ebx
  800bf3:	75 d2                	jne    800bc7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bf5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bf9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c00:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c0e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c19:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c1d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c21:	0f b6 00             	movzbl (%rax),%eax
  800c24:	0f b6 d8             	movzbl %al,%ebx
  800c27:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c2a:	83 f8 55             	cmp    $0x55,%eax
  800c2d:	0f 87 34 04 00 00    	ja     801067 <vprintfmt+0x4db>
  800c33:	89 c0                	mov    %eax,%eax
  800c35:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c3c:	00 
  800c3d:	48 b8 18 43 80 00 00 	movabs $0x804318,%rax
  800c44:	00 00 00 
  800c47:	48 01 d0             	add    %rdx,%rax
  800c4a:	48 8b 00             	mov    (%rax),%rax
  800c4d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c4f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c53:	eb c0                	jmp    800c15 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c55:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c59:	eb ba                	jmp    800c15 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c62:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c65:	89 d0                	mov    %edx,%eax
  800c67:	c1 e0 02             	shl    $0x2,%eax
  800c6a:	01 d0                	add    %edx,%eax
  800c6c:	01 c0                	add    %eax,%eax
  800c6e:	01 d8                	add    %ebx,%eax
  800c70:	83 e8 30             	sub    $0x30,%eax
  800c73:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7a:	0f b6 00             	movzbl (%rax),%eax
  800c7d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c80:	83 fb 2f             	cmp    $0x2f,%ebx
  800c83:	7e 0c                	jle    800c91 <vprintfmt+0x105>
  800c85:	83 fb 39             	cmp    $0x39,%ebx
  800c88:	7f 07                	jg     800c91 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0xd6>
			goto process_precision;
  800c91:	eb 58                	jmp    800ceb <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c96:	83 f8 30             	cmp    $0x30,%eax
  800c99:	73 17                	jae    800cb2 <vprintfmt+0x126>
  800c9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	89 c0                	mov    %eax,%eax
  800ca4:	48 01 d0             	add    %rdx,%rax
  800ca7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800caa:	83 c2 08             	add    $0x8,%edx
  800cad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb0:	eb 0f                	jmp    800cc1 <vprintfmt+0x135>
  800cb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb6:	48 89 d0             	mov    %rdx,%rax
  800cb9:	48 83 c2 08          	add    $0x8,%rdx
  800cbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc1:	8b 00                	mov    (%rax),%eax
  800cc3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cc6:	eb 23                	jmp    800ceb <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ccc:	79 0c                	jns    800cda <vprintfmt+0x14e>
				width = 0;
  800cce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cd5:	e9 3b ff ff ff       	jmpq   800c15 <vprintfmt+0x89>
  800cda:	e9 36 ff ff ff       	jmpq   800c15 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cdf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ce6:	e9 2a ff ff ff       	jmpq   800c15 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ceb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cef:	79 12                	jns    800d03 <vprintfmt+0x177>
				width = precision, precision = -1;
  800cf1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cf4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cf7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cfe:	e9 12 ff ff ff       	jmpq   800c15 <vprintfmt+0x89>
  800d03:	e9 0d ff ff ff       	jmpq   800c15 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d08:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d0c:	e9 04 ff ff ff       	jmpq   800c15 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d14:	83 f8 30             	cmp    $0x30,%eax
  800d17:	73 17                	jae    800d30 <vprintfmt+0x1a4>
  800d19:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d20:	89 c0                	mov    %eax,%eax
  800d22:	48 01 d0             	add    %rdx,%rax
  800d25:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d28:	83 c2 08             	add    $0x8,%edx
  800d2b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d2e:	eb 0f                	jmp    800d3f <vprintfmt+0x1b3>
  800d30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d34:	48 89 d0             	mov    %rdx,%rax
  800d37:	48 83 c2 08          	add    $0x8,%rdx
  800d3b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d3f:	8b 10                	mov    (%rax),%edx
  800d41:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d49:	48 89 ce             	mov    %rcx,%rsi
  800d4c:	89 d7                	mov    %edx,%edi
  800d4e:	ff d0                	callq  *%rax
			break;
  800d50:	e9 40 03 00 00       	jmpq   801095 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d58:	83 f8 30             	cmp    $0x30,%eax
  800d5b:	73 17                	jae    800d74 <vprintfmt+0x1e8>
  800d5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d64:	89 c0                	mov    %eax,%eax
  800d66:	48 01 d0             	add    %rdx,%rax
  800d69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6c:	83 c2 08             	add    $0x8,%edx
  800d6f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d72:	eb 0f                	jmp    800d83 <vprintfmt+0x1f7>
  800d74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d78:	48 89 d0             	mov    %rdx,%rax
  800d7b:	48 83 c2 08          	add    $0x8,%rdx
  800d7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d83:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d85:	85 db                	test   %ebx,%ebx
  800d87:	79 02                	jns    800d8b <vprintfmt+0x1ff>
				err = -err;
  800d89:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d8b:	83 fb 15             	cmp    $0x15,%ebx
  800d8e:	7f 16                	jg     800da6 <vprintfmt+0x21a>
  800d90:	48 b8 40 42 80 00 00 	movabs $0x804240,%rax
  800d97:	00 00 00 
  800d9a:	48 63 d3             	movslq %ebx,%rdx
  800d9d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800da1:	4d 85 e4             	test   %r12,%r12
  800da4:	75 2e                	jne    800dd4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800da6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800daa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dae:	89 d9                	mov    %ebx,%ecx
  800db0:	48 ba 01 43 80 00 00 	movabs $0x804301,%rdx
  800db7:	00 00 00 
  800dba:	48 89 c7             	mov    %rax,%rdi
  800dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc2:	49 b8 a4 10 80 00 00 	movabs $0x8010a4,%r8
  800dc9:	00 00 00 
  800dcc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dcf:	e9 c1 02 00 00       	jmpq   801095 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddc:	4c 89 e1             	mov    %r12,%rcx
  800ddf:	48 ba 0a 43 80 00 00 	movabs $0x80430a,%rdx
  800de6:	00 00 00 
  800de9:	48 89 c7             	mov    %rax,%rdi
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	49 b8 a4 10 80 00 00 	movabs $0x8010a4,%r8
  800df8:	00 00 00 
  800dfb:	41 ff d0             	callq  *%r8
			break;
  800dfe:	e9 92 02 00 00       	jmpq   801095 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e06:	83 f8 30             	cmp    $0x30,%eax
  800e09:	73 17                	jae    800e22 <vprintfmt+0x296>
  800e0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e12:	89 c0                	mov    %eax,%eax
  800e14:	48 01 d0             	add    %rdx,%rax
  800e17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1a:	83 c2 08             	add    $0x8,%edx
  800e1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e20:	eb 0f                	jmp    800e31 <vprintfmt+0x2a5>
  800e22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e26:	48 89 d0             	mov    %rdx,%rax
  800e29:	48 83 c2 08          	add    $0x8,%rdx
  800e2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e31:	4c 8b 20             	mov    (%rax),%r12
  800e34:	4d 85 e4             	test   %r12,%r12
  800e37:	75 0a                	jne    800e43 <vprintfmt+0x2b7>
				p = "(null)";
  800e39:	49 bc 0d 43 80 00 00 	movabs $0x80430d,%r12
  800e40:	00 00 00 
			if (width > 0 && padc != '-')
  800e43:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e47:	7e 3f                	jle    800e88 <vprintfmt+0x2fc>
  800e49:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e4d:	74 39                	je     800e88 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e52:	48 98                	cltq   
  800e54:	48 89 c6             	mov    %rax,%rsi
  800e57:	4c 89 e7             	mov    %r12,%rdi
  800e5a:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  800e61:	00 00 00 
  800e64:	ff d0                	callq  *%rax
  800e66:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e69:	eb 17                	jmp    800e82 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e6b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e6f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e77:	48 89 ce             	mov    %rcx,%rsi
  800e7a:	89 d7                	mov    %edx,%edi
  800e7c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e82:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e86:	7f e3                	jg     800e6b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e88:	eb 37                	jmp    800ec1 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e8e:	74 1e                	je     800eae <vprintfmt+0x322>
  800e90:	83 fb 1f             	cmp    $0x1f,%ebx
  800e93:	7e 05                	jle    800e9a <vprintfmt+0x30e>
  800e95:	83 fb 7e             	cmp    $0x7e,%ebx
  800e98:	7e 14                	jle    800eae <vprintfmt+0x322>
					putch('?', putdat);
  800e9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea2:	48 89 d6             	mov    %rdx,%rsi
  800ea5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800eaa:	ff d0                	callq  *%rax
  800eac:	eb 0f                	jmp    800ebd <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800eae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb6:	48 89 d6             	mov    %rdx,%rsi
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec1:	4c 89 e0             	mov    %r12,%rax
  800ec4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ec8:	0f b6 00             	movzbl (%rax),%eax
  800ecb:	0f be d8             	movsbl %al,%ebx
  800ece:	85 db                	test   %ebx,%ebx
  800ed0:	74 10                	je     800ee2 <vprintfmt+0x356>
  800ed2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ed6:	78 b2                	js     800e8a <vprintfmt+0x2fe>
  800ed8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800edc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ee0:	79 a8                	jns    800e8a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee2:	eb 16                	jmp    800efa <vprintfmt+0x36e>
				putch(' ', putdat);
  800ee4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	bf 20 00 00 00       	mov    $0x20,%edi
  800ef4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800efa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800efe:	7f e4                	jg     800ee4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f00:	e9 90 01 00 00       	jmpq   801095 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f09:	be 03 00 00 00       	mov    $0x3,%esi
  800f0e:	48 89 c7             	mov    %rax,%rdi
  800f11:	48 b8 7c 0a 80 00 00 	movabs $0x800a7c,%rax
  800f18:	00 00 00 
  800f1b:	ff d0                	callq  *%rax
  800f1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f25:	48 85 c0             	test   %rax,%rax
  800f28:	79 1d                	jns    800f47 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f32:	48 89 d6             	mov    %rdx,%rsi
  800f35:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f3a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f40:	48 f7 d8             	neg    %rax
  800f43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f47:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f4e:	e9 d5 00 00 00       	jmpq   801028 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f57:	be 03 00 00 00       	mov    $0x3,%esi
  800f5c:	48 89 c7             	mov    %rax,%rdi
  800f5f:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  800f66:	00 00 00 
  800f69:	ff d0                	callq  *%rax
  800f6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f76:	e9 ad 00 00 00       	jmpq   801028 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800f7b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800f7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f82:	89 d6                	mov    %edx,%esi
  800f84:	48 89 c7             	mov    %rax,%rdi
  800f87:	48 b8 7c 0a 80 00 00 	movabs $0x800a7c,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	callq  *%rax
  800f93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f97:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f9e:	e9 85 00 00 00       	jmpq   801028 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800fa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fab:	48 89 d6             	mov    %rdx,%rsi
  800fae:	bf 30 00 00 00       	mov    $0x30,%edi
  800fb3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbd:	48 89 d6             	mov    %rdx,%rsi
  800fc0:	bf 78 00 00 00       	mov    $0x78,%edi
  800fc5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fca:	83 f8 30             	cmp    $0x30,%eax
  800fcd:	73 17                	jae    800fe6 <vprintfmt+0x45a>
  800fcf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd6:	89 c0                	mov    %eax,%eax
  800fd8:	48 01 d0             	add    %rdx,%rax
  800fdb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fde:	83 c2 08             	add    $0x8,%edx
  800fe1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe4:	eb 0f                	jmp    800ff5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800fe6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fea:	48 89 d0             	mov    %rdx,%rax
  800fed:	48 83 c2 08          	add    $0x8,%rdx
  800ff1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ff5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ff8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ffc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801003:	eb 23                	jmp    801028 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801005:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801009:	be 03 00 00 00       	mov    $0x3,%esi
  80100e:	48 89 c7             	mov    %rax,%rdi
  801011:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  801018:	00 00 00 
  80101b:	ff d0                	callq  *%rax
  80101d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801021:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801028:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80102d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801030:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801033:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801037:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80103b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103f:	45 89 c1             	mov    %r8d,%r9d
  801042:	41 89 f8             	mov    %edi,%r8d
  801045:	48 89 c7             	mov    %rax,%rdi
  801048:	48 b8 b1 08 80 00 00 	movabs $0x8008b1,%rax
  80104f:	00 00 00 
  801052:	ff d0                	callq  *%rax
			break;
  801054:	eb 3f                	jmp    801095 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801056:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80105a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80105e:	48 89 d6             	mov    %rdx,%rsi
  801061:	89 df                	mov    %ebx,%edi
  801063:	ff d0                	callq  *%rax
			break;
  801065:	eb 2e                	jmp    801095 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801067:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80106b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80106f:	48 89 d6             	mov    %rdx,%rsi
  801072:	bf 25 00 00 00       	mov    $0x25,%edi
  801077:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801079:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80107e:	eb 05                	jmp    801085 <vprintfmt+0x4f9>
  801080:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801085:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801089:	48 83 e8 01          	sub    $0x1,%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	3c 25                	cmp    $0x25,%al
  801092:	75 ec                	jne    801080 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801094:	90                   	nop
		}
	}
  801095:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801096:	e9 43 fb ff ff       	jmpq   800bde <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80109b:	48 83 c4 60          	add    $0x60,%rsp
  80109f:	5b                   	pop    %rbx
  8010a0:	41 5c                	pop    %r12
  8010a2:	5d                   	pop    %rbp
  8010a3:	c3                   	retq   

00000000008010a4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010af:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010b6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010bd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010c4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010cb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d2:	84 c0                	test   %al,%al
  8010d4:	74 20                	je     8010f6 <printfmt+0x52>
  8010d6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010da:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010de:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010e6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010ea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010ee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010f6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010fd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801104:	00 00 00 
  801107:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80110e:	00 00 00 
  801111:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801115:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80111c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801123:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80112a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801131:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801138:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80113f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801146:	48 89 c7             	mov    %rax,%rdi
  801149:	48 b8 8c 0b 80 00 00 	movabs $0x800b8c,%rax
  801150:	00 00 00 
  801153:	ff d0                	callq  *%rax
	va_end(ap);
}
  801155:	c9                   	leaveq 
  801156:	c3                   	retq   

0000000000801157 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801157:	55                   	push   %rbp
  801158:	48 89 e5             	mov    %rsp,%rbp
  80115b:	48 83 ec 10          	sub    $0x10,%rsp
  80115f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801162:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80116a:	8b 40 10             	mov    0x10(%rax),%eax
  80116d:	8d 50 01             	lea    0x1(%rax),%edx
  801170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801174:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117b:	48 8b 10             	mov    (%rax),%rdx
  80117e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801182:	48 8b 40 08          	mov    0x8(%rax),%rax
  801186:	48 39 c2             	cmp    %rax,%rdx
  801189:	73 17                	jae    8011a2 <sprintputch+0x4b>
		*b->buf++ = ch;
  80118b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118f:	48 8b 00             	mov    (%rax),%rax
  801192:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801196:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80119a:	48 89 0a             	mov    %rcx,(%rdx)
  80119d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011a0:	88 10                	mov    %dl,(%rax)
}
  8011a2:	c9                   	leaveq 
  8011a3:	c3                   	retq   

00000000008011a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 50          	sub    $0x50,%rsp
  8011ac:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011b0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011b3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011b7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011bb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011bf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011c3:	48 8b 0a             	mov    (%rdx),%rcx
  8011c6:	48 89 08             	mov    %rcx,(%rax)
  8011c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011dd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011e1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011e4:	48 98                	cltq   
  8011e6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011ee:	48 01 d0             	add    %rdx,%rax
  8011f1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011fc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801201:	74 06                	je     801209 <vsnprintf+0x65>
  801203:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801207:	7f 07                	jg     801210 <vsnprintf+0x6c>
		return -E_INVAL;
  801209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120e:	eb 2f                	jmp    80123f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801210:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801214:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801218:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80121c:	48 89 c6             	mov    %rax,%rsi
  80121f:	48 bf 57 11 80 00 00 	movabs $0x801157,%rdi
  801226:	00 00 00 
  801229:	48 b8 8c 0b 80 00 00 	movabs $0x800b8c,%rax
  801230:	00 00 00 
  801233:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801235:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801239:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80123c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80123f:	c9                   	leaveq 
  801240:	c3                   	retq   

0000000000801241 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80124c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801253:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801259:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801260:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801267:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80126e:	84 c0                	test   %al,%al
  801270:	74 20                	je     801292 <snprintf+0x51>
  801272:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801276:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80127a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80127e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801282:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801286:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80128a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80128e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801292:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801299:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012a0:	00 00 00 
  8012a3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012aa:	00 00 00 
  8012ad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012b1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012b8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012bf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012c6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012cd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012d4:	48 8b 0a             	mov    (%rdx),%rcx
  8012d7:	48 89 08             	mov    %rcx,(%rax)
  8012da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012de:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012e2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012e6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012ea:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012f1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012f8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012fe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801305:	48 89 c7             	mov    %rax,%rdi
  801308:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  80130f:	00 00 00 
  801312:	ff d0                	callq  *%rax
  801314:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80131a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 18          	sub    $0x18,%rsp
  80132a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80132e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801335:	eb 09                	jmp    801340 <strlen+0x1e>
		n++;
  801337:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80133b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801344:	0f b6 00             	movzbl (%rax),%eax
  801347:	84 c0                	test   %al,%al
  801349:	75 ec                	jne    801337 <strlen+0x15>
		n++;
	return n;
  80134b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80134e:	c9                   	leaveq 
  80134f:	c3                   	retq   

0000000000801350 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801350:	55                   	push   %rbp
  801351:	48 89 e5             	mov    %rsp,%rbp
  801354:	48 83 ec 20          	sub    $0x20,%rsp
  801358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801360:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801367:	eb 0e                	jmp    801377 <strnlen+0x27>
		n++;
  801369:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80136d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801372:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801377:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80137c:	74 0b                	je     801389 <strnlen+0x39>
  80137e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801382:	0f b6 00             	movzbl (%rax),%eax
  801385:	84 c0                	test   %al,%al
  801387:	75 e0                	jne    801369 <strnlen+0x19>
		n++;
	return n;
  801389:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 20          	sub    $0x20,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013a6:	90                   	nop
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013bb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013bf:	0f b6 12             	movzbl (%rdx),%edx
  8013c2:	88 10                	mov    %dl,(%rax)
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 dc                	jne    8013a7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013cf:	c9                   	leaveq 
  8013d0:	c3                   	retq   

00000000008013d1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013d1:	55                   	push   %rbp
  8013d2:	48 89 e5             	mov    %rsp,%rbp
  8013d5:	48 83 ec 20          	sub    $0x20,%rsp
  8013d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	48 89 c7             	mov    %rax,%rdi
  8013e8:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  8013ef:	00 00 00 
  8013f2:	ff d0                	callq  *%rax
  8013f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013fa:	48 63 d0             	movslq %eax,%rdx
  8013fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801401:	48 01 c2             	add    %rax,%rdx
  801404:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801408:	48 89 c6             	mov    %rax,%rsi
  80140b:	48 89 d7             	mov    %rdx,%rdi
  80140e:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  801415:	00 00 00 
  801418:	ff d0                	callq  *%rax
	return dst;
  80141a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80141e:	c9                   	leaveq 
  80141f:	c3                   	retq   

0000000000801420 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
  801424:	48 83 ec 28          	sub    $0x28,%rsp
  801428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801430:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801438:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80143c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801443:	00 
  801444:	eb 2a                	jmp    801470 <strncpy+0x50>
		*dst++ = *src;
  801446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80144e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801452:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801456:	0f b6 12             	movzbl (%rdx),%edx
  801459:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80145b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	74 05                	je     80146b <strncpy+0x4b>
			src++;
  801466:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80146b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801474:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801478:	72 cc                	jb     801446 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80147a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80147e:	c9                   	leaveq 
  80147f:	c3                   	retq   

0000000000801480 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801480:	55                   	push   %rbp
  801481:	48 89 e5             	mov    %rsp,%rbp
  801484:	48 83 ec 28          	sub    $0x28,%rsp
  801488:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801490:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801498:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80149c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014a1:	74 3d                	je     8014e0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014a3:	eb 1d                	jmp    8014c2 <strlcpy+0x42>
			*dst++ = *src++;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014b5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014b9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014bd:	0f b6 12             	movzbl (%rdx),%edx
  8014c0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014cc:	74 0b                	je     8014d9 <strlcpy+0x59>
  8014ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	84 c0                	test   %al,%al
  8014d7:	75 cc                	jne    8014a5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	48 29 c2             	sub    %rax,%rdx
  8014eb:	48 89 d0             	mov    %rdx,%rax
}
  8014ee:	c9                   	leaveq 
  8014ef:	c3                   	retq   

00000000008014f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f0:	55                   	push   %rbp
  8014f1:	48 89 e5             	mov    %rsp,%rbp
  8014f4:	48 83 ec 10          	sub    $0x10,%rsp
  8014f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801500:	eb 0a                	jmp    80150c <strcmp+0x1c>
		p++, q++;
  801502:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801507:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	84 c0                	test   %al,%al
  801515:	74 12                	je     801529 <strcmp+0x39>
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151b:	0f b6 10             	movzbl (%rax),%edx
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	38 c2                	cmp    %al,%dl
  801527:	74 d9                	je     801502 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f b6 d0             	movzbl %al,%edx
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	0f b6 c0             	movzbl %al,%eax
  80153d:	29 c2                	sub    %eax,%edx
  80153f:	89 d0                	mov    %edx,%eax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 18          	sub    $0x18,%rsp
  80154b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801553:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801557:	eb 0f                	jmp    801568 <strncmp+0x25>
		n--, p++, q++;
  801559:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80155e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801563:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801568:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80156d:	74 1d                	je     80158c <strncmp+0x49>
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	84 c0                	test   %al,%al
  801578:	74 12                	je     80158c <strncmp+0x49>
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 cd                	je     801559 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80158c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801591:	75 07                	jne    80159a <strncmp+0x57>
		return 0;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 18                	jmp    8015b2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80159a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	0f b6 d0             	movzbl %al,%edx
  8015a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	0f b6 c0             	movzbl %al,%eax
  8015ae:	29 c2                	sub    %eax,%edx
  8015b0:	89 d0                	mov    %edx,%eax
}
  8015b2:	c9                   	leaveq 
  8015b3:	c3                   	retq   

00000000008015b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015b4:	55                   	push   %rbp
  8015b5:	48 89 e5             	mov    %rsp,%rbp
  8015b8:	48 83 ec 0c          	sub    $0xc,%rsp
  8015bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c0:	89 f0                	mov    %esi,%eax
  8015c2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015c5:	eb 17                	jmp    8015de <strchr+0x2a>
		if (*s == c)
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015d1:	75 06                	jne    8015d9 <strchr+0x25>
			return (char *) s;
  8015d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d7:	eb 15                	jmp    8015ee <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	84 c0                	test   %al,%al
  8015e7:	75 de                	jne    8015c7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ee:	c9                   	leaveq 
  8015ef:	c3                   	retq   

00000000008015f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015f0:	55                   	push   %rbp
  8015f1:	48 89 e5             	mov    %rsp,%rbp
  8015f4:	48 83 ec 0c          	sub    $0xc,%rsp
  8015f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fc:	89 f0                	mov    %esi,%eax
  8015fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801601:	eb 13                	jmp    801616 <strfind+0x26>
		if (*s == c)
  801603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80160d:	75 02                	jne    801611 <strfind+0x21>
			break;
  80160f:	eb 10                	jmp    801621 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801611:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	84 c0                	test   %al,%al
  80161f:	75 e2                	jne    801603 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801625:	c9                   	leaveq 
  801626:	c3                   	retq   

0000000000801627 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 18          	sub    $0x18,%rsp
  80162f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801633:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801636:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80163a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80163f:	75 06                	jne    801647 <memset+0x20>
		return v;
  801641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801645:	eb 69                	jmp    8016b0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164b:	83 e0 03             	and    $0x3,%eax
  80164e:	48 85 c0             	test   %rax,%rax
  801651:	75 48                	jne    80169b <memset+0x74>
  801653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801657:	83 e0 03             	and    $0x3,%eax
  80165a:	48 85 c0             	test   %rax,%rax
  80165d:	75 3c                	jne    80169b <memset+0x74>
		c &= 0xFF;
  80165f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801666:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801669:	c1 e0 18             	shl    $0x18,%eax
  80166c:	89 c2                	mov    %eax,%edx
  80166e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801671:	c1 e0 10             	shl    $0x10,%eax
  801674:	09 c2                	or     %eax,%edx
  801676:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801679:	c1 e0 08             	shl    $0x8,%eax
  80167c:	09 d0                	or     %edx,%eax
  80167e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801685:	48 c1 e8 02          	shr    $0x2,%rax
  801689:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80168c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801690:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801693:	48 89 d7             	mov    %rdx,%rdi
  801696:	fc                   	cld    
  801697:	f3 ab                	rep stos %eax,%es:(%rdi)
  801699:	eb 11                	jmp    8016ac <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80169b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016a6:	48 89 d7             	mov    %rdx,%rdi
  8016a9:	fc                   	cld    
  8016aa:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016b0:	c9                   	leaveq 
  8016b1:	c3                   	retq   

00000000008016b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016b2:	55                   	push   %rbp
  8016b3:	48 89 e5             	mov    %rsp,%rbp
  8016b6:	48 83 ec 28          	sub    $0x28,%rsp
  8016ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016de:	0f 83 88 00 00 00    	jae    80176c <memmove+0xba>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ec:	48 01 d0             	add    %rdx,%rax
  8016ef:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016f3:	76 77                	jbe    80176c <memmove+0xba>
		s += n;
  8016f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801709:	83 e0 03             	and    $0x3,%eax
  80170c:	48 85 c0             	test   %rax,%rax
  80170f:	75 3b                	jne    80174c <memmove+0x9a>
  801711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801715:	83 e0 03             	and    $0x3,%eax
  801718:	48 85 c0             	test   %rax,%rax
  80171b:	75 2f                	jne    80174c <memmove+0x9a>
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	83 e0 03             	and    $0x3,%eax
  801724:	48 85 c0             	test   %rax,%rax
  801727:	75 23                	jne    80174c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172d:	48 83 e8 04          	sub    $0x4,%rax
  801731:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801735:	48 83 ea 04          	sub    $0x4,%rdx
  801739:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801741:	48 89 c7             	mov    %rax,%rdi
  801744:	48 89 d6             	mov    %rdx,%rsi
  801747:	fd                   	std    
  801748:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80174a:	eb 1d                	jmp    801769 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80174c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801750:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801758:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801760:	48 89 d7             	mov    %rdx,%rdi
  801763:	48 89 c1             	mov    %rax,%rcx
  801766:	fd                   	std    
  801767:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801769:	fc                   	cld    
  80176a:	eb 57                	jmp    8017c3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80176c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801770:	83 e0 03             	and    $0x3,%eax
  801773:	48 85 c0             	test   %rax,%rax
  801776:	75 36                	jne    8017ae <memmove+0xfc>
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177c:	83 e0 03             	and    $0x3,%eax
  80177f:	48 85 c0             	test   %rax,%rax
  801782:	75 2a                	jne    8017ae <memmove+0xfc>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	83 e0 03             	and    $0x3,%eax
  80178b:	48 85 c0             	test   %rax,%rax
  80178e:	75 1e                	jne    8017ae <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	48 c1 e8 02          	shr    $0x2,%rax
  801798:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80179b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a3:	48 89 c7             	mov    %rax,%rdi
  8017a6:	48 89 d6             	mov    %rdx,%rsi
  8017a9:	fc                   	cld    
  8017aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ac:	eb 15                	jmp    8017c3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017ba:	48 89 c7             	mov    %rax,%rdi
  8017bd:	48 89 d6             	mov    %rdx,%rsi
  8017c0:	fc                   	cld    
  8017c1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017c7:	c9                   	leaveq 
  8017c8:	c3                   	retq   

00000000008017c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	48 83 ec 18          	sub    $0x18,%rsp
  8017d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e9:	48 89 ce             	mov    %rcx,%rsi
  8017ec:	48 89 c7             	mov    %rax,%rdi
  8017ef:	48 b8 b2 16 80 00 00 	movabs $0x8016b2,%rax
  8017f6:	00 00 00 
  8017f9:	ff d0                	callq  *%rax
}
  8017fb:	c9                   	leaveq 
  8017fc:	c3                   	retq   

00000000008017fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017fd:	55                   	push   %rbp
  8017fe:	48 89 e5             	mov    %rsp,%rbp
  801801:	48 83 ec 28          	sub    $0x28,%rsp
  801805:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801809:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80180d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801815:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801819:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80181d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801821:	eb 36                	jmp    801859 <memcmp+0x5c>
		if (*s1 != *s2)
  801823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801827:	0f b6 10             	movzbl (%rax),%edx
  80182a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182e:	0f b6 00             	movzbl (%rax),%eax
  801831:	38 c2                	cmp    %al,%dl
  801833:	74 1a                	je     80184f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801835:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	0f b6 d0             	movzbl %al,%edx
  80183f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801843:	0f b6 00             	movzbl (%rax),%eax
  801846:	0f b6 c0             	movzbl %al,%eax
  801849:	29 c2                	sub    %eax,%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	eb 20                	jmp    80186f <memcmp+0x72>
		s1++, s2++;
  80184f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801854:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801861:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801865:	48 85 c0             	test   %rax,%rax
  801868:	75 b9                	jne    801823 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186f:	c9                   	leaveq 
  801870:	c3                   	retq   

0000000000801871 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801871:	55                   	push   %rbp
  801872:	48 89 e5             	mov    %rsp,%rbp
  801875:	48 83 ec 28          	sub    $0x28,%rsp
  801879:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80187d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801880:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188c:	48 01 d0             	add    %rdx,%rax
  80188f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801893:	eb 15                	jmp    8018aa <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801899:	0f b6 10             	movzbl (%rax),%edx
  80189c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80189f:	38 c2                	cmp    %al,%dl
  8018a1:	75 02                	jne    8018a5 <memfind+0x34>
			break;
  8018a3:	eb 0f                	jmp    8018b4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ae:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018b2:	72 e1                	jb     801895 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018b8:	c9                   	leaveq 
  8018b9:	c3                   	retq   

00000000008018ba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 34          	sub    $0x34,%rsp
  8018c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018ca:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018d4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018db:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018dc:	eb 05                	jmp    8018e3 <strtol+0x29>
		s++;
  8018de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e7:	0f b6 00             	movzbl (%rax),%eax
  8018ea:	3c 20                	cmp    $0x20,%al
  8018ec:	74 f0                	je     8018de <strtol+0x24>
  8018ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f2:	0f b6 00             	movzbl (%rax),%eax
  8018f5:	3c 09                	cmp    $0x9,%al
  8018f7:	74 e5                	je     8018de <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	0f b6 00             	movzbl (%rax),%eax
  801900:	3c 2b                	cmp    $0x2b,%al
  801902:	75 07                	jne    80190b <strtol+0x51>
		s++;
  801904:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801909:	eb 17                	jmp    801922 <strtol+0x68>
	else if (*s == '-')
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3c 2d                	cmp    $0x2d,%al
  801914:	75 0c                	jne    801922 <strtol+0x68>
		s++, neg = 1;
  801916:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80191b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801922:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801926:	74 06                	je     80192e <strtol+0x74>
  801928:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80192c:	75 28                	jne    801956 <strtol+0x9c>
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	0f b6 00             	movzbl (%rax),%eax
  801935:	3c 30                	cmp    $0x30,%al
  801937:	75 1d                	jne    801956 <strtol+0x9c>
  801939:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193d:	48 83 c0 01          	add    $0x1,%rax
  801941:	0f b6 00             	movzbl (%rax),%eax
  801944:	3c 78                	cmp    $0x78,%al
  801946:	75 0e                	jne    801956 <strtol+0x9c>
		s += 2, base = 16;
  801948:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80194d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801954:	eb 2c                	jmp    801982 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801956:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80195a:	75 19                	jne    801975 <strtol+0xbb>
  80195c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801960:	0f b6 00             	movzbl (%rax),%eax
  801963:	3c 30                	cmp    $0x30,%al
  801965:	75 0e                	jne    801975 <strtol+0xbb>
		s++, base = 8;
  801967:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801973:	eb 0d                	jmp    801982 <strtol+0xc8>
	else if (base == 0)
  801975:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801979:	75 07                	jne    801982 <strtol+0xc8>
		base = 10;
  80197b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801982:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801986:	0f b6 00             	movzbl (%rax),%eax
  801989:	3c 2f                	cmp    $0x2f,%al
  80198b:	7e 1d                	jle    8019aa <strtol+0xf0>
  80198d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801991:	0f b6 00             	movzbl (%rax),%eax
  801994:	3c 39                	cmp    $0x39,%al
  801996:	7f 12                	jg     8019aa <strtol+0xf0>
			dig = *s - '0';
  801998:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199c:	0f b6 00             	movzbl (%rax),%eax
  80199f:	0f be c0             	movsbl %al,%eax
  8019a2:	83 e8 30             	sub    $0x30,%eax
  8019a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019a8:	eb 4e                	jmp    8019f8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ae:	0f b6 00             	movzbl (%rax),%eax
  8019b1:	3c 60                	cmp    $0x60,%al
  8019b3:	7e 1d                	jle    8019d2 <strtol+0x118>
  8019b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b9:	0f b6 00             	movzbl (%rax),%eax
  8019bc:	3c 7a                	cmp    $0x7a,%al
  8019be:	7f 12                	jg     8019d2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c4:	0f b6 00             	movzbl (%rax),%eax
  8019c7:	0f be c0             	movsbl %al,%eax
  8019ca:	83 e8 57             	sub    $0x57,%eax
  8019cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d0:	eb 26                	jmp    8019f8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d6:	0f b6 00             	movzbl (%rax),%eax
  8019d9:	3c 40                	cmp    $0x40,%al
  8019db:	7e 48                	jle    801a25 <strtol+0x16b>
  8019dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e1:	0f b6 00             	movzbl (%rax),%eax
  8019e4:	3c 5a                	cmp    $0x5a,%al
  8019e6:	7f 3d                	jg     801a25 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	0f b6 00             	movzbl (%rax),%eax
  8019ef:	0f be c0             	movsbl %al,%eax
  8019f2:	83 e8 37             	sub    $0x37,%eax
  8019f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019fb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019fe:	7c 02                	jl     801a02 <strtol+0x148>
			break;
  801a00:	eb 23                	jmp    801a25 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a02:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a07:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a0a:	48 98                	cltq   
  801a0c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a11:	48 89 c2             	mov    %rax,%rdx
  801a14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a17:	48 98                	cltq   
  801a19:	48 01 d0             	add    %rdx,%rax
  801a1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a20:	e9 5d ff ff ff       	jmpq   801982 <strtol+0xc8>

	if (endptr)
  801a25:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a2a:	74 0b                	je     801a37 <strtol+0x17d>
		*endptr = (char *) s;
  801a2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a34:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a3b:	74 09                	je     801a46 <strtol+0x18c>
  801a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a41:	48 f7 d8             	neg    %rax
  801a44:	eb 04                	jmp    801a4a <strtol+0x190>
  801a46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a4a:	c9                   	leaveq 
  801a4b:	c3                   	retq   

0000000000801a4c <strstr>:

char * strstr(const char *in, const char *str)
{
  801a4c:	55                   	push   %rbp
  801a4d:	48 89 e5             	mov    %rsp,%rbp
  801a50:	48 83 ec 30          	sub    $0x30,%rsp
  801a54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a58:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a60:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a64:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a68:	0f b6 00             	movzbl (%rax),%eax
  801a6b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a6e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a72:	75 06                	jne    801a7a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	eb 6b                	jmp    801ae5 <strstr+0x99>

	len = strlen(str);
  801a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a7e:	48 89 c7             	mov    %rax,%rdi
  801a81:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  801a88:	00 00 00 
  801a8b:	ff d0                	callq  *%rax
  801a8d:	48 98                	cltq   
  801a8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a97:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a9b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a9f:	0f b6 00             	movzbl (%rax),%eax
  801aa2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801aa5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801aa9:	75 07                	jne    801ab2 <strstr+0x66>
				return (char *) 0;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab0:	eb 33                	jmp    801ae5 <strstr+0x99>
		} while (sc != c);
  801ab2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ab6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ab9:	75 d8                	jne    801a93 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801abb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac7:	48 89 ce             	mov    %rcx,%rsi
  801aca:	48 89 c7             	mov    %rax,%rdi
  801acd:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	callq  *%rax
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	75 b6                	jne    801a93 <strstr+0x47>

	return (char *) (in - 1);
  801add:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae1:	48 83 e8 01          	sub    $0x1,%rax
}
  801ae5:	c9                   	leaveq 
  801ae6:	c3                   	retq   

0000000000801ae7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ae7:	55                   	push   %rbp
  801ae8:	48 89 e5             	mov    %rsp,%rbp
  801aeb:	53                   	push   %rbx
  801aec:	48 83 ec 48          	sub    $0x48,%rsp
  801af0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801af3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801af6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801afa:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801afe:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b02:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b06:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b09:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b0d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b11:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b15:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b19:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b1d:	4c 89 c3             	mov    %r8,%rbx
  801b20:	cd 30                	int    $0x30
  801b22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b26:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b2a:	74 3e                	je     801b6a <syscall+0x83>
  801b2c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b31:	7e 37                	jle    801b6a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b3a:	49 89 d0             	mov    %rdx,%r8
  801b3d:	89 c1                	mov    %eax,%ecx
  801b3f:	48 ba c8 45 80 00 00 	movabs $0x8045c8,%rdx
  801b46:	00 00 00 
  801b49:	be 23 00 00 00       	mov    $0x23,%esi
  801b4e:	48 bf e5 45 80 00 00 	movabs $0x8045e5,%rdi
  801b55:	00 00 00 
  801b58:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5d:	49 b9 ef 38 80 00 00 	movabs $0x8038ef,%r9
  801b64:	00 00 00 
  801b67:	41 ff d1             	callq  *%r9

	return ret;
  801b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b6e:	48 83 c4 48          	add    $0x48,%rsp
  801b72:	5b                   	pop    %rbx
  801b73:	5d                   	pop    %rbp
  801b74:	c3                   	retq   

0000000000801b75 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b75:	55                   	push   %rbp
  801b76:	48 89 e5             	mov    %rsp,%rbp
  801b79:	48 83 ec 20          	sub    $0x20,%rsp
  801b7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b94:	00 
  801b95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba1:	48 89 d1             	mov    %rdx,%rcx
  801ba4:	48 89 c2             	mov    %rax,%rdx
  801ba7:	be 00 00 00 00       	mov    $0x0,%esi
  801bac:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb1:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	callq  *%rax
}
  801bbd:	c9                   	leaveq 
  801bbe:	c3                   	retq   

0000000000801bbf <sys_cgetc>:

int
sys_cgetc(void)
{
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bc7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bce:	00 
  801bcf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be0:	ba 00 00 00 00       	mov    $0x0,%edx
  801be5:	be 00 00 00 00       	mov    $0x0,%esi
  801bea:	bf 01 00 00 00       	mov    $0x1,%edi
  801bef:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	callq  *%rax
}
  801bfb:	c9                   	leaveq 
  801bfc:	c3                   	retq   

0000000000801bfd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bfd:	55                   	push   %rbp
  801bfe:	48 89 e5             	mov    %rsp,%rbp
  801c01:	48 83 ec 10          	sub    $0x10,%rsp
  801c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c14:	00 
  801c15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c26:	48 89 c2             	mov    %rax,%rdx
  801c29:	be 01 00 00 00       	mov    $0x1,%esi
  801c2e:	bf 03 00 00 00       	mov    $0x3,%edi
  801c33:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
}
  801c3f:	c9                   	leaveq 
  801c40:	c3                   	retq   

0000000000801c41 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c41:	55                   	push   %rbp
  801c42:	48 89 e5             	mov    %rsp,%rbp
  801c45:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c50:	00 
  801c51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
  801c67:	be 00 00 00 00       	mov    $0x0,%esi
  801c6c:	bf 02 00 00 00       	mov    $0x2,%edi
  801c71:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
}
  801c7d:	c9                   	leaveq 
  801c7e:	c3                   	retq   

0000000000801c7f <sys_yield>:

void
sys_yield(void)
{
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8e:	00 
  801c8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca5:	be 00 00 00 00       	mov    $0x0,%esi
  801caa:	bf 0b 00 00 00       	mov    $0xb,%edi
  801caf:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	callq  *%rax
}
  801cbb:	c9                   	leaveq 
  801cbc:	c3                   	retq   

0000000000801cbd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cbd:	55                   	push   %rbp
  801cbe:	48 89 e5             	mov    %rsp,%rbp
  801cc1:	48 83 ec 20          	sub    $0x20,%rsp
  801cc5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ccc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ccf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd2:	48 63 c8             	movslq %eax,%rcx
  801cd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdc:	48 98                	cltq   
  801cde:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce5:	00 
  801ce6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cec:	49 89 c8             	mov    %rcx,%r8
  801cef:	48 89 d1             	mov    %rdx,%rcx
  801cf2:	48 89 c2             	mov    %rax,%rdx
  801cf5:	be 01 00 00 00       	mov    $0x1,%esi
  801cfa:	bf 04 00 00 00       	mov    $0x4,%edi
  801cff:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	callq  *%rax
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 30          	sub    $0x30,%rsp
  801d15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d1c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d1f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d23:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d27:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d2a:	48 63 c8             	movslq %eax,%rcx
  801d2d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d34:	48 63 f0             	movslq %eax,%rsi
  801d37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3e:	48 98                	cltq   
  801d40:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d44:	49 89 f9             	mov    %rdi,%r9
  801d47:	49 89 f0             	mov    %rsi,%r8
  801d4a:	48 89 d1             	mov    %rdx,%rcx
  801d4d:	48 89 c2             	mov    %rax,%rdx
  801d50:	be 01 00 00 00       	mov    $0x1,%esi
  801d55:	bf 05 00 00 00       	mov    $0x5,%edi
  801d5a:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
}
  801d66:	c9                   	leaveq 
  801d67:	c3                   	retq   

0000000000801d68 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 20          	sub    $0x20,%rsp
  801d70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7e:	48 98                	cltq   
  801d80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d87:	00 
  801d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d94:	48 89 d1             	mov    %rdx,%rcx
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	be 01 00 00 00       	mov    $0x1,%esi
  801d9f:	bf 06 00 00 00       	mov    $0x6,%edi
  801da4:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	48 83 ec 10          	sub    $0x10,%rsp
  801dba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dbd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc3:	48 63 d0             	movslq %eax,%rdx
  801dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc9:	48 98                	cltq   
  801dcb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd2:	00 
  801dd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddf:	48 89 d1             	mov    %rdx,%rcx
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	be 01 00 00 00       	mov    $0x1,%esi
  801dea:	bf 08 00 00 00       	mov    $0x8,%edi
  801def:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 20          	sub    $0x20,%rsp
  801e05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e13:	48 98                	cltq   
  801e15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1c:	00 
  801e1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e29:	48 89 d1             	mov    %rdx,%rcx
  801e2c:	48 89 c2             	mov    %rax,%rdx
  801e2f:	be 01 00 00 00       	mov    $0x1,%esi
  801e34:	bf 09 00 00 00       	mov    $0x9,%edi
  801e39:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	callq  *%rax
}
  801e45:	c9                   	leaveq 
  801e46:	c3                   	retq   

0000000000801e47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e47:	55                   	push   %rbp
  801e48:	48 89 e5             	mov    %rsp,%rbp
  801e4b:	48 83 ec 20          	sub    $0x20,%rsp
  801e4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5d:	48 98                	cltq   
  801e5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e66:	00 
  801e67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e73:	48 89 d1             	mov    %rdx,%rcx
  801e76:	48 89 c2             	mov    %rax,%rdx
  801e79:	be 01 00 00 00       	mov    $0x1,%esi
  801e7e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e83:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 83 ec 20          	sub    $0x20,%rsp
  801e99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ea0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ea4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ea7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eaa:	48 63 f0             	movslq %eax,%rsi
  801ead:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb4:	48 98                	cltq   
  801eb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec1:	00 
  801ec2:	49 89 f1             	mov    %rsi,%r9
  801ec5:	49 89 c8             	mov    %rcx,%r8
  801ec8:	48 89 d1             	mov    %rdx,%rcx
  801ecb:	48 89 c2             	mov    %rax,%rdx
  801ece:	be 00 00 00 00       	mov    $0x0,%esi
  801ed3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ed8:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801edf:	00 00 00 
  801ee2:	ff d0                	callq  *%rax
}
  801ee4:	c9                   	leaveq 
  801ee5:	c3                   	retq   

0000000000801ee6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ee6:	55                   	push   %rbp
  801ee7:	48 89 e5             	mov    %rsp,%rbp
  801eea:	48 83 ec 10          	sub    $0x10,%rsp
  801eee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801efd:	00 
  801efe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f0f:	48 89 c2             	mov    %rax,%rdx
  801f12:	be 01 00 00 00       	mov    $0x1,%esi
  801f17:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f1c:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	callq  *%rax
}
  801f28:	c9                   	leaveq 
  801f29:	c3                   	retq   

0000000000801f2a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f39:	00 
  801f3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f50:	be 00 00 00 00       	mov    $0x0,%esi
  801f55:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f5a:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
}
  801f66:	c9                   	leaveq 
  801f67:	c3                   	retq   

0000000000801f68 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	48 83 ec 30          	sub    $0x30,%rsp
  801f70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f77:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f7a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f7e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f82:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f85:	48 63 c8             	movslq %eax,%rcx
  801f88:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f8f:	48 63 f0             	movslq %eax,%rsi
  801f92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f99:	48 98                	cltq   
  801f9b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f9f:	49 89 f9             	mov    %rdi,%r9
  801fa2:	49 89 f0             	mov    %rsi,%r8
  801fa5:	48 89 d1             	mov    %rdx,%rcx
  801fa8:	48 89 c2             	mov    %rax,%rdx
  801fab:	be 00 00 00 00       	mov    $0x0,%esi
  801fb0:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fb5:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 20          	sub    $0x20,%rsp
  801fcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801fd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fdb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe2:	00 
  801fe3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fef:	48 89 d1             	mov    %rdx,%rcx
  801ff2:	48 89 c2             	mov    %rax,%rdx
  801ff5:	be 00 00 00 00       	mov    $0x0,%esi
  801ffa:	bf 10 00 00 00       	mov    $0x10,%edi
  801fff:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  802006:	00 00 00 
  802009:	ff d0                	callq  *%rax
}
  80200b:	c9                   	leaveq 
  80200c:	c3                   	retq   

000000000080200d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80200d:	55                   	push   %rbp
  80200e:	48 89 e5             	mov    %rsp,%rbp
  802011:	48 83 ec 08          	sub    $0x8,%rsp
  802015:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802019:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80201d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802024:	ff ff ff 
  802027:	48 01 d0             	add    %rdx,%rax
  80202a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	48 83 ec 08          	sub    $0x8,%rsp
  802038:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80203c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802040:	48 89 c7             	mov    %rax,%rdi
  802043:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
  80204f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802055:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802059:	c9                   	leaveq 
  80205a:	c3                   	retq   

000000000080205b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80205b:	55                   	push   %rbp
  80205c:	48 89 e5             	mov    %rsp,%rbp
  80205f:	48 83 ec 18          	sub    $0x18,%rsp
  802063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80206e:	eb 6b                	jmp    8020db <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802073:	48 98                	cltq   
  802075:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80207b:	48 c1 e0 0c          	shl    $0xc,%rax
  80207f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802087:	48 c1 e8 15          	shr    $0x15,%rax
  80208b:	48 89 c2             	mov    %rax,%rdx
  80208e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802095:	01 00 00 
  802098:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209c:	83 e0 01             	and    $0x1,%eax
  80209f:	48 85 c0             	test   %rax,%rax
  8020a2:	74 21                	je     8020c5 <fd_alloc+0x6a>
  8020a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8020ac:	48 89 c2             	mov    %rax,%rdx
  8020af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020b6:	01 00 00 
  8020b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020bd:	83 e0 01             	and    $0x1,%eax
  8020c0:	48 85 c0             	test   %rax,%rax
  8020c3:	75 12                	jne    8020d7 <fd_alloc+0x7c>
			*fd_store = fd;
  8020c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020cd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	eb 1a                	jmp    8020f1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020db:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020df:	7e 8f                	jle    802070 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020ec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020f1:	c9                   	leaveq 
  8020f2:	c3                   	retq   

00000000008020f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020f3:	55                   	push   %rbp
  8020f4:	48 89 e5             	mov    %rsp,%rbp
  8020f7:	48 83 ec 20          	sub    $0x20,%rsp
  8020fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802102:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802106:	78 06                	js     80210e <fd_lookup+0x1b>
  802108:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80210c:	7e 07                	jle    802115 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80210e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802113:	eb 6c                	jmp    802181 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802118:	48 98                	cltq   
  80211a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802120:	48 c1 e0 0c          	shl    $0xc,%rax
  802124:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80212c:	48 c1 e8 15          	shr    $0x15,%rax
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80213a:	01 00 00 
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	74 21                	je     80216a <fd_lookup+0x77>
  802149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214d:	48 c1 e8 0c          	shr    $0xc,%rax
  802151:	48 89 c2             	mov    %rax,%rdx
  802154:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80215b:	01 00 00 
  80215e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802162:	83 e0 01             	and    $0x1,%eax
  802165:	48 85 c0             	test   %rax,%rax
  802168:	75 07                	jne    802171 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80216a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80216f:	eb 10                	jmp    802181 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802171:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802175:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802179:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802181:	c9                   	leaveq 
  802182:	c3                   	retq   

0000000000802183 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802183:	55                   	push   %rbp
  802184:	48 89 e5             	mov    %rsp,%rbp
  802187:	48 83 ec 30          	sub    $0x30,%rsp
  80218b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80218f:	89 f0                	mov    %esi,%eax
  802191:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802198:	48 89 c7             	mov    %rax,%rdi
  80219b:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	callq  *%rax
  8021a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021ab:	48 89 d6             	mov    %rdx,%rsi
  8021ae:	89 c7                	mov    %eax,%edi
  8021b0:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c3:	78 0a                	js     8021cf <fd_close+0x4c>
	    || fd != fd2)
  8021c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021cd:	74 12                	je     8021e1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8021cf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021d3:	74 05                	je     8021da <fd_close+0x57>
  8021d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d8:	eb 05                	jmp    8021df <fd_close+0x5c>
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	eb 69                	jmp    80224a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e5:	8b 00                	mov    (%rax),%eax
  8021e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021eb:	48 89 d6             	mov    %rdx,%rsi
  8021ee:	89 c7                	mov    %eax,%edi
  8021f0:	48 b8 4c 22 80 00 00 	movabs $0x80224c,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
  8021fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802203:	78 2a                	js     80222f <fd_close+0xac>
		if (dev->dev_close)
  802205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802209:	48 8b 40 20          	mov    0x20(%rax),%rax
  80220d:	48 85 c0             	test   %rax,%rax
  802210:	74 16                	je     802228 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 8b 40 20          	mov    0x20(%rax),%rax
  80221a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80221e:	48 89 d7             	mov    %rdx,%rdi
  802221:	ff d0                	callq  *%rax
  802223:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802226:	eb 07                	jmp    80222f <fd_close+0xac>
		else
			r = 0;
  802228:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80222f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802233:	48 89 c6             	mov    %rax,%rsi
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
	return r;
  802247:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80224a:	c9                   	leaveq 
  80224b:	c3                   	retq   

000000000080224c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80224c:	55                   	push   %rbp
  80224d:	48 89 e5             	mov    %rsp,%rbp
  802250:	48 83 ec 20          	sub    $0x20,%rsp
  802254:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802257:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80225b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802262:	eb 41                	jmp    8022a5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802264:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80226b:	00 00 00 
  80226e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802271:	48 63 d2             	movslq %edx,%rdx
  802274:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802278:	8b 00                	mov    (%rax),%eax
  80227a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80227d:	75 22                	jne    8022a1 <dev_lookup+0x55>
			*dev = devtab[i];
  80227f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802286:	00 00 00 
  802289:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80228c:	48 63 d2             	movslq %edx,%rdx
  80228f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802297:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
  80229f:	eb 60                	jmp    802301 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8022a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022a5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022ac:	00 00 00 
  8022af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022b2:	48 63 d2             	movslq %edx,%rdx
  8022b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b9:	48 85 c0             	test   %rax,%rax
  8022bc:	75 a6                	jne    802264 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022be:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022c5:	00 00 00 
  8022c8:	48 8b 00             	mov    (%rax),%rax
  8022cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022d4:	89 c6                	mov    %eax,%esi
  8022d6:	48 bf f8 45 80 00 00 	movabs $0x8045f8,%rdi
  8022dd:	00 00 00 
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	48 b9 d9 07 80 00 00 	movabs $0x8007d9,%rcx
  8022ec:	00 00 00 
  8022ef:	ff d1                	callq  *%rcx
	*dev = 0;
  8022f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022f5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802301:	c9                   	leaveq 
  802302:	c3                   	retq   

0000000000802303 <close>:

int
close(int fdnum)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 20          	sub    $0x20,%rsp
  80230b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80230e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802312:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802315:	48 89 d6             	mov    %rdx,%rsi
  802318:	89 c7                	mov    %eax,%edi
  80231a:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802321:	00 00 00 
  802324:	ff d0                	callq  *%rax
  802326:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232d:	79 05                	jns    802334 <close+0x31>
		return r;
  80232f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802332:	eb 18                	jmp    80234c <close+0x49>
	else
		return fd_close(fd, 1);
  802334:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802338:	be 01 00 00 00       	mov    $0x1,%esi
  80233d:	48 89 c7             	mov    %rax,%rdi
  802340:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
}
  80234c:	c9                   	leaveq 
  80234d:	c3                   	retq   

000000000080234e <close_all>:

void
close_all(void)
{
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80235d:	eb 15                	jmp    802374 <close_all+0x26>
		close(i);
  80235f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802362:	89 c7                	mov    %eax,%edi
  802364:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  80236b:	00 00 00 
  80236e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802370:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802374:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802378:	7e e5                	jle    80235f <close_all+0x11>
		close(i);
}
  80237a:	c9                   	leaveq 
  80237b:	c3                   	retq   

000000000080237c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80237c:	55                   	push   %rbp
  80237d:	48 89 e5             	mov    %rsp,%rbp
  802380:	48 83 ec 40          	sub    $0x40,%rsp
  802384:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802387:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80238a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80238e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	79 08                	jns    8023b3 <dup+0x37>
		return r;
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	e9 70 01 00 00       	jmpq   802523 <dup+0x1a7>
	close(newfdnum);
  8023b3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023b6:	89 c7                	mov    %eax,%edi
  8023b8:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023c4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023c7:	48 98                	cltq   
  8023c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8023d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023db:	48 89 c7             	mov    %rax,%rdi
  8023de:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8023e5:	00 00 00 
  8023e8:	ff d0                	callq  *%rax
  8023ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f2:	48 89 c7             	mov    %rax,%rdi
  8023f5:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	callq  *%rax
  802401:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802409:	48 c1 e8 15          	shr    $0x15,%rax
  80240d:	48 89 c2             	mov    %rax,%rdx
  802410:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802417:	01 00 00 
  80241a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241e:	83 e0 01             	and    $0x1,%eax
  802421:	48 85 c0             	test   %rax,%rax
  802424:	74 73                	je     802499 <dup+0x11d>
  802426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242a:	48 c1 e8 0c          	shr    $0xc,%rax
  80242e:	48 89 c2             	mov    %rax,%rdx
  802431:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802438:	01 00 00 
  80243b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243f:	83 e0 01             	and    $0x1,%eax
  802442:	48 85 c0             	test   %rax,%rax
  802445:	74 52                	je     802499 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244b:	48 c1 e8 0c          	shr    $0xc,%rax
  80244f:	48 89 c2             	mov    %rax,%rdx
  802452:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802459:	01 00 00 
  80245c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802460:	25 07 0e 00 00       	and    $0xe07,%eax
  802465:	89 c1                	mov    %eax,%ecx
  802467:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80246b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246f:	41 89 c8             	mov    %ecx,%r8d
  802472:	48 89 d1             	mov    %rdx,%rcx
  802475:	ba 00 00 00 00       	mov    $0x0,%edx
  80247a:	48 89 c6             	mov    %rax,%rsi
  80247d:	bf 00 00 00 00       	mov    $0x0,%edi
  802482:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  802489:	00 00 00 
  80248c:	ff d0                	callq  *%rax
  80248e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802495:	79 02                	jns    802499 <dup+0x11d>
			goto err;
  802497:	eb 57                	jmp    8024f0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249d:	48 c1 e8 0c          	shr    $0xc,%rax
  8024a1:	48 89 c2             	mov    %rax,%rdx
  8024a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ab:	01 00 00 
  8024ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8024b7:	89 c1                	mov    %eax,%ecx
  8024b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c1:	41 89 c8             	mov    %ecx,%r8d
  8024c4:	48 89 d1             	mov    %rdx,%rcx
  8024c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cc:	48 89 c6             	mov    %rax,%rsi
  8024cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d4:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8024db:	00 00 00 
  8024de:	ff d0                	callq  *%rax
  8024e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e7:	79 02                	jns    8024eb <dup+0x16f>
		goto err;
  8024e9:	eb 05                	jmp    8024f0 <dup+0x174>

	return newfdnum;
  8024eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024ee:	eb 33                	jmp    802523 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f4:	48 89 c6             	mov    %rax,%rsi
  8024f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fc:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802508:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80250c:	48 89 c6             	mov    %rax,%rsi
  80250f:	bf 00 00 00 00       	mov    $0x0,%edi
  802514:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax
	return r;
  802520:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802523:	c9                   	leaveq 
  802524:	c3                   	retq   

0000000000802525 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802525:	55                   	push   %rbp
  802526:	48 89 e5             	mov    %rsp,%rbp
  802529:	48 83 ec 40          	sub    $0x40,%rsp
  80252d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802530:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802534:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802538:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80253c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80253f:	48 89 d6             	mov    %rdx,%rsi
  802542:	89 c7                	mov    %eax,%edi
  802544:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax
  802550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802557:	78 24                	js     80257d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255d:	8b 00                	mov    (%rax),%eax
  80255f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802563:	48 89 d6             	mov    %rdx,%rsi
  802566:	89 c7                	mov    %eax,%edi
  802568:	48 b8 4c 22 80 00 00 	movabs $0x80224c,%rax
  80256f:	00 00 00 
  802572:	ff d0                	callq  *%rax
  802574:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802577:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257b:	79 05                	jns    802582 <read+0x5d>
		return r;
  80257d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802580:	eb 76                	jmp    8025f8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802586:	8b 40 08             	mov    0x8(%rax),%eax
  802589:	83 e0 03             	and    $0x3,%eax
  80258c:	83 f8 01             	cmp    $0x1,%eax
  80258f:	75 3a                	jne    8025cb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802591:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802598:	00 00 00 
  80259b:	48 8b 00             	mov    (%rax),%rax
  80259e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025a7:	89 c6                	mov    %eax,%esi
  8025a9:	48 bf 17 46 80 00 00 	movabs $0x804617,%rdi
  8025b0:	00 00 00 
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	48 b9 d9 07 80 00 00 	movabs $0x8007d9,%rcx
  8025bf:	00 00 00 
  8025c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c9:	eb 2d                	jmp    8025f8 <read+0xd3>
	}
	if (!dev->dev_read)
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025d3:	48 85 c0             	test   %rax,%rax
  8025d6:	75 07                	jne    8025df <read+0xba>
		return -E_NOT_SUPP;
  8025d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025dd:	eb 19                	jmp    8025f8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025ef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025f3:	48 89 cf             	mov    %rcx,%rdi
  8025f6:	ff d0                	callq  *%rax
}
  8025f8:	c9                   	leaveq 
  8025f9:	c3                   	retq   

00000000008025fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	48 83 ec 30          	sub    $0x30,%rsp
  802602:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802605:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802609:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80260d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802614:	eb 49                	jmp    80265f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802619:	48 98                	cltq   
  80261b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80261f:	48 29 c2             	sub    %rax,%rdx
  802622:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802625:	48 63 c8             	movslq %eax,%rcx
  802628:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262c:	48 01 c1             	add    %rax,%rcx
  80262f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802632:	48 89 ce             	mov    %rcx,%rsi
  802635:	89 c7                	mov    %eax,%edi
  802637:	48 b8 25 25 80 00 00 	movabs $0x802525,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
  802643:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802646:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80264a:	79 05                	jns    802651 <readn+0x57>
			return m;
  80264c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80264f:	eb 1c                	jmp    80266d <readn+0x73>
		if (m == 0)
  802651:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802655:	75 02                	jne    802659 <readn+0x5f>
			break;
  802657:	eb 11                	jmp    80266a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802659:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80265f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802662:	48 98                	cltq   
  802664:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802668:	72 ac                	jb     802616 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80266a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 40          	sub    $0x40,%rsp
  802677:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80267a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80267e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802682:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802686:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802689:	48 89 d6             	mov    %rdx,%rsi
  80268c:	89 c7                	mov    %eax,%edi
  80268e:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802695:	00 00 00 
  802698:	ff d0                	callq  *%rax
  80269a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a1:	78 24                	js     8026c7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a7:	8b 00                	mov    (%rax),%eax
  8026a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ad:	48 89 d6             	mov    %rdx,%rsi
  8026b0:	89 c7                	mov    %eax,%edi
  8026b2:	48 b8 4c 22 80 00 00 	movabs $0x80224c,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	79 05                	jns    8026cc <write+0x5d>
		return r;
  8026c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ca:	eb 42                	jmp    80270e <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d0:	8b 40 08             	mov    0x8(%rax),%eax
  8026d3:	83 e0 03             	and    $0x3,%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	75 07                	jne    8026e1 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026df:	eb 2d                	jmp    80270e <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026e9:	48 85 c0             	test   %rax,%rax
  8026ec:	75 07                	jne    8026f5 <write+0x86>
		return -E_NOT_SUPP;
  8026ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f3:	eb 19                	jmp    80270e <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8026f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802701:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802705:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802709:	48 89 cf             	mov    %rcx,%rdi
  80270c:	ff d0                	callq  *%rax
}
  80270e:	c9                   	leaveq 
  80270f:	c3                   	retq   

0000000000802710 <seek>:

int
seek(int fdnum, off_t offset)
{
  802710:	55                   	push   %rbp
  802711:	48 89 e5             	mov    %rsp,%rbp
  802714:	48 83 ec 18          	sub    $0x18,%rsp
  802718:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80271b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802722:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802725:	48 89 d6             	mov    %rdx,%rsi
  802728:	89 c7                	mov    %eax,%edi
  80272a:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802731:	00 00 00 
  802734:	ff d0                	callq  *%rax
  802736:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802739:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273d:	79 05                	jns    802744 <seek+0x34>
		return r;
  80273f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802742:	eb 0f                	jmp    802753 <seek+0x43>
	fd->fd_offset = offset;
  802744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802748:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80274b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802753:	c9                   	leaveq 
  802754:	c3                   	retq   

0000000000802755 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802755:	55                   	push   %rbp
  802756:	48 89 e5             	mov    %rsp,%rbp
  802759:	48 83 ec 30          	sub    $0x30,%rsp
  80275d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802760:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802763:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802767:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80276a:	48 89 d6             	mov    %rdx,%rsi
  80276d:	89 c7                	mov    %eax,%edi
  80276f:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	78 24                	js     8027a8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802788:	8b 00                	mov    (%rax),%eax
  80278a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278e:	48 89 d6             	mov    %rdx,%rsi
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 4c 22 80 00 00 	movabs $0x80224c,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	79 05                	jns    8027ad <ftruncate+0x58>
		return r;
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	eb 72                	jmp    80281f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b1:	8b 40 08             	mov    0x8(%rax),%eax
  8027b4:	83 e0 03             	and    $0x3,%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	75 3a                	jne    8027f5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027bb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027c2:	00 00 00 
  8027c5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027c8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027ce:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027d1:	89 c6                	mov    %eax,%esi
  8027d3:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  8027da:	00 00 00 
  8027dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e2:	48 b9 d9 07 80 00 00 	movabs $0x8007d9,%rcx
  8027e9:	00 00 00 
  8027ec:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f3:	eb 2a                	jmp    80281f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027fd:	48 85 c0             	test   %rax,%rax
  802800:	75 07                	jne    802809 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802802:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802807:	eb 16                	jmp    80281f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802809:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802815:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802818:	89 ce                	mov    %ecx,%esi
  80281a:	48 89 d7             	mov    %rdx,%rdi
  80281d:	ff d0                	callq  *%rax
}
  80281f:	c9                   	leaveq 
  802820:	c3                   	retq   

0000000000802821 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802821:	55                   	push   %rbp
  802822:	48 89 e5             	mov    %rsp,%rbp
  802825:	48 83 ec 30          	sub    $0x30,%rsp
  802829:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80282c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802830:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802834:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802837:	48 89 d6             	mov    %rdx,%rsi
  80283a:	89 c7                	mov    %eax,%edi
  80283c:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
  802848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284f:	78 24                	js     802875 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802855:	8b 00                	mov    (%rax),%eax
  802857:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285b:	48 89 d6             	mov    %rdx,%rsi
  80285e:	89 c7                	mov    %eax,%edi
  802860:	48 b8 4c 22 80 00 00 	movabs $0x80224c,%rax
  802867:	00 00 00 
  80286a:	ff d0                	callq  *%rax
  80286c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802873:	79 05                	jns    80287a <fstat+0x59>
		return r;
  802875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802878:	eb 5e                	jmp    8028d8 <fstat+0xb7>
	if (!dev->dev_stat)
  80287a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802882:	48 85 c0             	test   %rax,%rax
  802885:	75 07                	jne    80288e <fstat+0x6d>
		return -E_NOT_SUPP;
  802887:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80288c:	eb 4a                	jmp    8028d8 <fstat+0xb7>
	stat->st_name[0] = 0;
  80288e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802892:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802895:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802899:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028a0:	00 00 00 
	stat->st_isdir = 0;
  8028a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028ae:	00 00 00 
	stat->st_dev = dev;
  8028b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028b9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028cc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028d0:	48 89 ce             	mov    %rcx,%rsi
  8028d3:	48 89 d7             	mov    %rdx,%rdi
  8028d6:	ff d0                	callq  *%rax
}
  8028d8:	c9                   	leaveq 
  8028d9:	c3                   	retq   

00000000008028da <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	48 83 ec 20          	sub    $0x20,%rsp
  8028e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ee:	be 00 00 00 00       	mov    $0x0,%esi
  8028f3:	48 89 c7             	mov    %rax,%rdi
  8028f6:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	79 05                	jns    802910 <stat+0x36>
		return fd;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	eb 2f                	jmp    80293f <stat+0x65>
	r = fstat(fd, stat);
  802910:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802917:	48 89 d6             	mov    %rdx,%rsi
  80291a:	89 c7                	mov    %eax,%edi
  80291c:	48 b8 21 28 80 00 00 	movabs $0x802821,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80292b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292e:	89 c7                	mov    %eax,%edi
  802930:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802937:	00 00 00 
  80293a:	ff d0                	callq  *%rax
	return r;
  80293c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80293f:	c9                   	leaveq 
  802940:	c3                   	retq   

0000000000802941 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802941:	55                   	push   %rbp
  802942:	48 89 e5             	mov    %rsp,%rbp
  802945:	48 83 ec 10          	sub    $0x10,%rsp
  802949:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80294c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802950:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802957:	00 00 00 
  80295a:	8b 00                	mov    (%rax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	75 1d                	jne    80297d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802960:	bf 01 00 00 00       	mov    $0x1,%edi
  802965:	48 b8 ce 3e 80 00 00 	movabs $0x803ece,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
  802971:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802978:	00 00 00 
  80297b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80297d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802984:	00 00 00 
  802987:	8b 00                	mov    (%rax),%eax
  802989:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80298c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802991:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802998:	00 00 00 
  80299b:	89 c7                	mov    %eax,%edi
  80299d:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b2:	48 89 c6             	mov    %rax,%rsi
  8029b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ba:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  8029c1:	00 00 00 
  8029c4:	ff d0                	callq  *%rax
}
  8029c6:	c9                   	leaveq 
  8029c7:	c3                   	retq   

00000000008029c8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029c8:	55                   	push   %rbp
  8029c9:	48 89 e5             	mov    %rsp,%rbp
  8029cc:	48 83 ec 30          	sub    $0x30,%rsp
  8029d0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029d4:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8029d7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8029de:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8029e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8029ec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8029f1:	75 08                	jne    8029fb <open+0x33>
	{
		return r;
  8029f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f6:	e9 f2 00 00 00       	jmpq   802aed <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8029fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ff:	48 89 c7             	mov    %rax,%rdi
  802a02:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a11:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802a18:	7e 0a                	jle    802a24 <open+0x5c>
	{
		return -E_BAD_PATH;
  802a1a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a1f:	e9 c9 00 00 00       	jmpq   802aed <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802a24:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802a2b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802a2c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a30:	48 89 c7             	mov    %rax,%rdi
  802a33:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	callq  *%rax
  802a3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a46:	78 09                	js     802a51 <open+0x89>
  802a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4c:	48 85 c0             	test   %rax,%rax
  802a4f:	75 08                	jne    802a59 <open+0x91>
		{
			return r;
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a54:	e9 94 00 00 00       	jmpq   802aed <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a5d:	ba 00 04 00 00       	mov    $0x400,%edx
  802a62:	48 89 c6             	mov    %rax,%rsi
  802a65:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a6c:	00 00 00 
  802a6f:	48 b8 20 14 80 00 00 	movabs $0x801420,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802a7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a82:	00 00 00 
  802a85:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802a88:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a92:	48 89 c6             	mov    %rax,%rsi
  802a95:	bf 01 00 00 00       	mov    $0x1,%edi
  802a9a:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802aa1:	00 00 00 
  802aa4:	ff d0                	callq  *%rax
  802aa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aad:	79 2b                	jns    802ada <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab3:	be 00 00 00 00       	mov    $0x0,%esi
  802ab8:	48 89 c7             	mov    %rax,%rdi
  802abb:	48 b8 83 21 80 00 00 	movabs $0x802183,%rax
  802ac2:	00 00 00 
  802ac5:	ff d0                	callq  *%rax
  802ac7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802aca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ace:	79 05                	jns    802ad5 <open+0x10d>
			{
				return d;
  802ad0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad3:	eb 18                	jmp    802aed <open+0x125>
			}
			return r;
  802ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad8:	eb 13                	jmp    802aed <open+0x125>
		}	
		return fd2num(fd_store);
  802ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ade:	48 89 c7             	mov    %rax,%rdi
  802ae1:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802aed:	c9                   	leaveq 
  802aee:	c3                   	retq   

0000000000802aef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802aef:	55                   	push   %rbp
  802af0:	48 89 e5             	mov    %rsp,%rbp
  802af3:	48 83 ec 10          	sub    $0x10,%rsp
  802af7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802afb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aff:	8b 50 0c             	mov    0xc(%rax),%edx
  802b02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b09:	00 00 00 
  802b0c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b0e:	be 00 00 00 00       	mov    $0x0,%esi
  802b13:	bf 06 00 00 00       	mov    $0x6,%edi
  802b18:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
}
  802b24:	c9                   	leaveq 
  802b25:	c3                   	retq   

0000000000802b26 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b26:	55                   	push   %rbp
  802b27:	48 89 e5             	mov    %rsp,%rbp
  802b2a:	48 83 ec 30          	sub    $0x30,%rsp
  802b2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802b41:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802b46:	74 07                	je     802b4f <devfile_read+0x29>
  802b48:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b4d:	75 07                	jne    802b56 <devfile_read+0x30>
		return -E_INVAL;
  802b4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b54:	eb 77                	jmp    802bcd <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5a:	8b 50 0c             	mov    0xc(%rax),%edx
  802b5d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b64:	00 00 00 
  802b67:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b69:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b70:	00 00 00 
  802b73:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b77:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802b7b:	be 00 00 00 00       	mov    $0x0,%esi
  802b80:	bf 03 00 00 00       	mov    $0x3,%edi
  802b85:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	7f 05                	jg     802b9f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	eb 2e                	jmp    802bcd <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba2:	48 63 d0             	movslq %eax,%rdx
  802ba5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802bb0:	00 00 00 
  802bb3:	48 89 c7             	mov    %rax,%rdi
  802bb6:	48 b8 b2 16 80 00 00 	movabs $0x8016b2,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802bc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	48 83 ec 30          	sub    $0x30,%rsp
  802bd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802be3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802bea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802bef:	74 07                	je     802bf8 <devfile_write+0x29>
  802bf1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802bf6:	75 08                	jne    802c00 <devfile_write+0x31>
		return r;
  802bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfb:	e9 9a 00 00 00       	jmpq   802c9a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c04:	8b 50 0c             	mov    0xc(%rax),%edx
  802c07:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c0e:	00 00 00 
  802c11:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802c13:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802c1a:	00 
  802c1b:	76 08                	jbe    802c25 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802c1d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802c24:	00 
	}
	fsipcbuf.write.req_n = n;
  802c25:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c2c:	00 00 00 
  802c2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c33:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802c37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c3f:	48 89 c6             	mov    %rax,%rsi
  802c42:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802c49:	00 00 00 
  802c4c:	48 b8 b2 16 80 00 00 	movabs $0x8016b2,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802c58:	be 00 00 00 00       	mov    $0x0,%esi
  802c5d:	bf 04 00 00 00       	mov    $0x4,%edi
  802c62:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
  802c6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c75:	7f 20                	jg     802c97 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802c77:	48 bf 5e 46 80 00 00 	movabs $0x80465e,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  802c8d:	00 00 00 
  802c90:	ff d2                	callq  *%rdx
		return r;
  802c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c95:	eb 03                	jmp    802c9a <devfile_write+0xcb>
	}
	return r;
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802c9a:	c9                   	leaveq 
  802c9b:	c3                   	retq   

0000000000802c9c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802c9c:	55                   	push   %rbp
  802c9d:	48 89 e5             	mov    %rsp,%rbp
  802ca0:	48 83 ec 20          	sub    $0x20,%rsp
  802ca4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb0:	8b 50 0c             	mov    0xc(%rax),%edx
  802cb3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cba:	00 00 00 
  802cbd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802cbf:	be 00 00 00 00       	mov    $0x0,%esi
  802cc4:	bf 05 00 00 00       	mov    $0x5,%edi
  802cc9:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802cd0:	00 00 00 
  802cd3:	ff d0                	callq  *%rax
  802cd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdc:	79 05                	jns    802ce3 <devfile_stat+0x47>
		return r;
  802cde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce1:	eb 56                	jmp    802d39 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ce3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cee:	00 00 00 
  802cf1:	48 89 c7             	mov    %rax,%rdi
  802cf4:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d00:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d07:	00 00 00 
  802d0a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d14:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d1a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d21:	00 00 00 
  802d24:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802d2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d39:	c9                   	leaveq 
  802d3a:	c3                   	retq   

0000000000802d3b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d3b:	55                   	push   %rbp
  802d3c:	48 89 e5             	mov    %rsp,%rbp
  802d3f:	48 83 ec 10          	sub    $0x10,%rsp
  802d43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d47:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d4e:	8b 50 0c             	mov    0xc(%rax),%edx
  802d51:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d58:	00 00 00 
  802d5b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802d5d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d64:	00 00 00 
  802d67:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802d6a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d6d:	be 00 00 00 00       	mov    $0x0,%esi
  802d72:	bf 02 00 00 00       	mov    $0x2,%edi
  802d77:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
}
  802d83:	c9                   	leaveq 
  802d84:	c3                   	retq   

0000000000802d85 <remove>:

// Delete a file
int
remove(const char *path)
{
  802d85:	55                   	push   %rbp
  802d86:	48 89 e5             	mov    %rsp,%rbp
  802d89:	48 83 ec 10          	sub    $0x10,%rsp
  802d8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d95:	48 89 c7             	mov    %rax,%rdi
  802d98:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
  802da4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802da9:	7e 07                	jle    802db2 <remove+0x2d>
		return -E_BAD_PATH;
  802dab:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802db0:	eb 33                	jmp    802de5 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db6:	48 89 c6             	mov    %rax,%rsi
  802db9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802dc0:	00 00 00 
  802dc3:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802dcf:	be 00 00 00 00       	mov    $0x0,%esi
  802dd4:	bf 07 00 00 00       	mov    $0x7,%edi
  802dd9:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802deb:	be 00 00 00 00       	mov    $0x0,%esi
  802df0:	bf 08 00 00 00       	mov    $0x8,%edi
  802df5:	48 b8 41 29 80 00 00 	movabs $0x802941,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
}
  802e01:	5d                   	pop    %rbp
  802e02:	c3                   	retq   

0000000000802e03 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e03:	55                   	push   %rbp
  802e04:	48 89 e5             	mov    %rsp,%rbp
  802e07:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e0e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e15:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e1c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802e23:	be 00 00 00 00       	mov    $0x0,%esi
  802e28:	48 89 c7             	mov    %rax,%rdi
  802e2b:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3e:	79 28                	jns    802e68 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e43:	89 c6                	mov    %eax,%esi
  802e45:	48 bf 7a 46 80 00 00 	movabs $0x80467a,%rdi
  802e4c:	00 00 00 
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e54:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  802e5b:	00 00 00 
  802e5e:	ff d2                	callq  *%rdx
		return fd_src;
  802e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e63:	e9 74 01 00 00       	jmpq   802fdc <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802e68:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802e6f:	be 01 01 00 00       	mov    $0x101,%esi
  802e74:	48 89 c7             	mov    %rax,%rdi
  802e77:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
  802e83:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802e86:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e8a:	79 39                	jns    802ec5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802e8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e8f:	89 c6                	mov    %eax,%esi
  802e91:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  802e98:	00 00 00 
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea0:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  802ea7:	00 00 00 
  802eaa:	ff d2                	callq  *%rdx
		close(fd_src);
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
		return fd_dest;
  802ebd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ec0:	e9 17 01 00 00       	jmpq   802fdc <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ec5:	eb 74                	jmp    802f3b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ec7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eca:	48 63 d0             	movslq %eax,%rdx
  802ecd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ed4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed7:	48 89 ce             	mov    %rcx,%rsi
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802eef:	79 4a                	jns    802f3b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ef1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ef4:	89 c6                	mov    %eax,%esi
  802ef6:	48 bf aa 46 80 00 00 	movabs $0x8046aa,%rdi
  802efd:	00 00 00 
  802f00:	b8 00 00 00 00       	mov    $0x0,%eax
  802f05:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  802f0c:	00 00 00 
  802f0f:	ff d2                	callq  *%rdx
			close(fd_src);
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	89 c7                	mov    %eax,%edi
  802f16:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802f1d:	00 00 00 
  802f20:	ff d0                	callq  *%rax
			close(fd_dest);
  802f22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f25:	89 c7                	mov    %eax,%edi
  802f27:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
			return write_size;
  802f33:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f36:	e9 a1 00 00 00       	jmpq   802fdc <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f3b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f45:	ba 00 02 00 00       	mov    $0x200,%edx
  802f4a:	48 89 ce             	mov    %rcx,%rsi
  802f4d:	89 c7                	mov    %eax,%edi
  802f4f:	48 b8 25 25 80 00 00 	movabs $0x802525,%rax
  802f56:	00 00 00 
  802f59:	ff d0                	callq  *%rax
  802f5b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f62:	0f 8f 5f ff ff ff    	jg     802ec7 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802f6c:	79 47                	jns    802fb5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802f6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f71:	89 c6                	mov    %eax,%esi
  802f73:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  802f7a:	00 00 00 
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f82:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  802f89:	00 00 00 
  802f8c:	ff d2                	callq  *%rdx
		close(fd_src);
  802f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f91:	89 c7                	mov    %eax,%edi
  802f93:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
		close(fd_dest);
  802f9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
		return read_size;
  802fb0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb3:	eb 27                	jmp    802fdc <copy+0x1d9>
	}
	close(fd_src);
  802fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
	close(fd_dest);
  802fc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
	return 0;
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	53                   	push   %rbx
  802fe3:	48 83 ec 38          	sub    $0x38,%rsp
  802fe7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802feb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802fef:	48 89 c7             	mov    %rax,%rdi
  802ff2:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
  802ffe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803001:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803005:	0f 88 bf 01 00 00    	js     8031ca <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80300b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300f:	ba 07 04 00 00       	mov    $0x407,%edx
  803014:	48 89 c6             	mov    %rax,%rsi
  803017:	bf 00 00 00 00       	mov    $0x0,%edi
  80301c:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax
  803028:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80302b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80302f:	0f 88 95 01 00 00    	js     8031ca <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803035:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803039:	48 89 c7             	mov    %rax,%rdi
  80303c:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
  803048:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80304b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80304f:	0f 88 5d 01 00 00    	js     8031b2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803055:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803059:	ba 07 04 00 00       	mov    $0x407,%edx
  80305e:	48 89 c6             	mov    %rax,%rsi
  803061:	bf 00 00 00 00       	mov    $0x0,%edi
  803066:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803075:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803079:	0f 88 33 01 00 00    	js     8031b2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80307f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803083:	48 89 c7             	mov    %rax,%rdi
  803086:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
  803092:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803096:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80309a:	ba 07 04 00 00       	mov    $0x407,%edx
  80309f:	48 89 c6             	mov    %rax,%rsi
  8030a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a7:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030ba:	79 05                	jns    8030c1 <pipe+0xe3>
		goto err2;
  8030bc:	e9 d9 00 00 00       	jmpq   80319a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c5:	48 89 c7             	mov    %rax,%rdi
  8030c8:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	48 89 c2             	mov    %rax,%rdx
  8030d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030db:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8030e1:	48 89 d1             	mov    %rdx,%rcx
  8030e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e9:	48 89 c6             	mov    %rax,%rsi
  8030ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f1:	48 b8 0d 1d 80 00 00 	movabs $0x801d0d,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803100:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803104:	79 1b                	jns    803121 <pipe+0x143>
		goto err3;
  803106:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803107:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310b:	48 89 c6             	mov    %rax,%rsi
  80310e:	bf 00 00 00 00       	mov    $0x0,%edi
  803113:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  80311a:	00 00 00 
  80311d:	ff d0                	callq  *%rax
  80311f:	eb 79                	jmp    80319a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803121:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803125:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80312c:	00 00 00 
  80312f:	8b 12                	mov    (%rdx),%edx
  803131:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803133:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803137:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80313e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803142:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803149:	00 00 00 
  80314c:	8b 12                	mov    (%rdx),%edx
  80314e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803150:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803154:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80315b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315f:	48 89 c7             	mov    %rax,%rdi
  803162:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
  80316e:	89 c2                	mov    %eax,%edx
  803170:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803174:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803176:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80317a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80317e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803182:	48 89 c7             	mov    %rax,%rdi
  803185:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	89 03                	mov    %eax,(%rbx)
	return 0;
  803193:	b8 00 00 00 00       	mov    $0x0,%eax
  803198:	eb 33                	jmp    8031cd <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80319a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80319e:	48 89 c6             	mov    %rax,%rsi
  8031a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a6:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8031b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b6:	48 89 c6             	mov    %rax,%rsi
  8031b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031be:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
err:
	return r;
  8031ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8031cd:	48 83 c4 38          	add    $0x38,%rsp
  8031d1:	5b                   	pop    %rbx
  8031d2:	5d                   	pop    %rbp
  8031d3:	c3                   	retq   

00000000008031d4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	53                   	push   %rbx
  8031d9:	48 83 ec 28          	sub    $0x28,%rsp
  8031dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8031e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031ec:	00 00 00 
  8031ef:	48 8b 00             	mov    (%rax),%rax
  8031f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8031fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	89 c3                	mov    %eax,%ebx
  803210:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803214:	48 89 c7             	mov    %rax,%rdi
  803217:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  80321e:	00 00 00 
  803221:	ff d0                	callq  *%rax
  803223:	39 c3                	cmp    %eax,%ebx
  803225:	0f 94 c0             	sete   %al
  803228:	0f b6 c0             	movzbl %al,%eax
  80322b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80322e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803235:	00 00 00 
  803238:	48 8b 00             	mov    (%rax),%rax
  80323b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803241:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803244:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803247:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80324a:	75 05                	jne    803251 <_pipeisclosed+0x7d>
			return ret;
  80324c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80324f:	eb 4f                	jmp    8032a0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803251:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803254:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803257:	74 42                	je     80329b <_pipeisclosed+0xc7>
  803259:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80325d:	75 3c                	jne    80329b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80325f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803266:	00 00 00 
  803269:	48 8b 00             	mov    (%rax),%rax
  80326c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803272:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803275:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803278:	89 c6                	mov    %eax,%esi
  80327a:	48 bf dd 46 80 00 00 	movabs $0x8046dd,%rdi
  803281:	00 00 00 
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	49 b8 d9 07 80 00 00 	movabs $0x8007d9,%r8
  803290:	00 00 00 
  803293:	41 ff d0             	callq  *%r8
	}
  803296:	e9 4a ff ff ff       	jmpq   8031e5 <_pipeisclosed+0x11>
  80329b:	e9 45 ff ff ff       	jmpq   8031e5 <_pipeisclosed+0x11>
}
  8032a0:	48 83 c4 28          	add    $0x28,%rsp
  8032a4:	5b                   	pop    %rbx
  8032a5:	5d                   	pop    %rbp
  8032a6:	c3                   	retq   

00000000008032a7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8032a7:	55                   	push   %rbp
  8032a8:	48 89 e5             	mov    %rsp,%rbp
  8032ab:	48 83 ec 30          	sub    $0x30,%rsp
  8032af:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032b9:	48 89 d6             	mov    %rdx,%rsi
  8032bc:	89 c7                	mov    %eax,%edi
  8032be:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d1:	79 05                	jns    8032d8 <pipeisclosed+0x31>
		return r;
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d6:	eb 31                	jmp    803309 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8032d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032dc:	48 89 c7             	mov    %rax,%rdi
  8032df:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8032ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032f7:	48 89 d6             	mov    %rdx,%rsi
  8032fa:	48 89 c7             	mov    %rax,%rdi
  8032fd:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
}
  803309:	c9                   	leaveq 
  80330a:	c3                   	retq   

000000000080330b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80330b:	55                   	push   %rbp
  80330c:	48 89 e5             	mov    %rsp,%rbp
  80330f:	48 83 ec 40          	sub    $0x40,%rsp
  803313:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803317:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80331b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80331f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803323:	48 89 c7             	mov    %rax,%rdi
  803326:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803336:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80333e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803345:	00 
  803346:	e9 92 00 00 00       	jmpq   8033dd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80334b:	eb 41                	jmp    80338e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80334d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803352:	74 09                	je     80335d <devpipe_read+0x52>
				return i;
  803354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803358:	e9 92 00 00 00       	jmpq   8033ef <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80335d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803365:	48 89 d6             	mov    %rdx,%rsi
  803368:	48 89 c7             	mov    %rax,%rdi
  80336b:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
  803377:	85 c0                	test   %eax,%eax
  803379:	74 07                	je     803382 <devpipe_read+0x77>
				return 0;
  80337b:	b8 00 00 00 00       	mov    $0x0,%eax
  803380:	eb 6d                	jmp    8033ef <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803382:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80338e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803392:	8b 10                	mov    (%rax),%edx
  803394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803398:	8b 40 04             	mov    0x4(%rax),%eax
  80339b:	39 c2                	cmp    %eax,%edx
  80339d:	74 ae                	je     80334d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80339f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033a7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8033ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033af:	8b 00                	mov    (%rax),%eax
  8033b1:	99                   	cltd   
  8033b2:	c1 ea 1b             	shr    $0x1b,%edx
  8033b5:	01 d0                	add    %edx,%eax
  8033b7:	83 e0 1f             	and    $0x1f,%eax
  8033ba:	29 d0                	sub    %edx,%eax
  8033bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c0:	48 98                	cltq   
  8033c2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8033c7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8033c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cd:	8b 00                	mov    (%rax),%eax
  8033cf:	8d 50 01             	lea    0x1(%rax),%edx
  8033d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033e5:	0f 82 60 ff ff ff    	jb     80334b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8033eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033ef:	c9                   	leaveq 
  8033f0:	c3                   	retq   

00000000008033f1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033f1:	55                   	push   %rbp
  8033f2:	48 89 e5             	mov    %rsp,%rbp
  8033f5:	48 83 ec 40          	sub    $0x40,%rsp
  8033f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803401:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803409:	48 89 c7             	mov    %rax,%rdi
  80340c:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
  803418:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80341c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803420:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803424:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80342b:	00 
  80342c:	e9 8e 00 00 00       	jmpq   8034bf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803431:	eb 31                	jmp    803464 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803433:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80343b:	48 89 d6             	mov    %rdx,%rsi
  80343e:	48 89 c7             	mov    %rax,%rdi
  803441:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 07                	je     803458 <devpipe_write+0x67>
				return 0;
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
  803456:	eb 79                	jmp    8034d1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803458:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  80345f:	00 00 00 
  803462:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803468:	8b 40 04             	mov    0x4(%rax),%eax
  80346b:	48 63 d0             	movslq %eax,%rdx
  80346e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803472:	8b 00                	mov    (%rax),%eax
  803474:	48 98                	cltq   
  803476:	48 83 c0 20          	add    $0x20,%rax
  80347a:	48 39 c2             	cmp    %rax,%rdx
  80347d:	73 b4                	jae    803433 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80347f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803483:	8b 40 04             	mov    0x4(%rax),%eax
  803486:	99                   	cltd   
  803487:	c1 ea 1b             	shr    $0x1b,%edx
  80348a:	01 d0                	add    %edx,%eax
  80348c:	83 e0 1f             	and    $0x1f,%eax
  80348f:	29 d0                	sub    %edx,%eax
  803491:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803495:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803499:	48 01 ca             	add    %rcx,%rdx
  80349c:	0f b6 0a             	movzbl (%rdx),%ecx
  80349f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034a3:	48 98                	cltq   
  8034a5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8034a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ad:	8b 40 04             	mov    0x4(%rax),%eax
  8034b0:	8d 50 01             	lea    0x1(%rax),%edx
  8034b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034c7:	0f 82 64 ff ff ff    	jb     803431 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8034cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034d1:	c9                   	leaveq 
  8034d2:	c3                   	retq   

00000000008034d3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034d3:	55                   	push   %rbp
  8034d4:	48 89 e5             	mov    %rsp,%rbp
  8034d7:	48 83 ec 20          	sub    $0x20,%rsp
  8034db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e7:	48 89 c7             	mov    %rax,%rdi
  8034ea:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8034fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fe:	48 be f0 46 80 00 00 	movabs $0x8046f0,%rsi
  803505:	00 00 00 
  803508:	48 89 c7             	mov    %rax,%rdi
  80350b:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803512:	00 00 00 
  803515:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351b:	8b 50 04             	mov    0x4(%rax),%edx
  80351e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803522:	8b 00                	mov    (%rax),%eax
  803524:	29 c2                	sub    %eax,%edx
  803526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80352a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803530:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803534:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80353b:	00 00 00 
	stat->st_dev = &devpipe;
  80353e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803542:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803549:	00 00 00 
  80354c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803558:	c9                   	leaveq 
  803559:	c3                   	retq   

000000000080355a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80355a:	55                   	push   %rbp
  80355b:	48 89 e5             	mov    %rsp,%rbp
  80355e:	48 83 ec 10          	sub    $0x10,%rsp
  803562:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356a:	48 89 c6             	mov    %rax,%rsi
  80356d:	bf 00 00 00 00       	mov    $0x0,%edi
  803572:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80357e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803582:	48 89 c7             	mov    %rax,%rdi
  803585:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80358c:	00 00 00 
  80358f:	ff d0                	callq  *%rax
  803591:	48 89 c6             	mov    %rax,%rsi
  803594:	bf 00 00 00 00       	mov    $0x0,%edi
  803599:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
}
  8035a5:	c9                   	leaveq 
  8035a6:	c3                   	retq   

00000000008035a7 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8035a7:	55                   	push   %rbp
  8035a8:	48 89 e5             	mov    %rsp,%rbp
  8035ab:	48 83 ec 20          	sub    $0x20,%rsp
  8035af:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8035b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b6:	75 35                	jne    8035ed <wait+0x46>
  8035b8:	48 b9 f7 46 80 00 00 	movabs $0x8046f7,%rcx
  8035bf:	00 00 00 
  8035c2:	48 ba 02 47 80 00 00 	movabs $0x804702,%rdx
  8035c9:	00 00 00 
  8035cc:	be 09 00 00 00       	mov    $0x9,%esi
  8035d1:	48 bf 17 47 80 00 00 	movabs $0x804717,%rdi
  8035d8:	00 00 00 
  8035db:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e0:	49 b8 ef 38 80 00 00 	movabs $0x8038ef,%r8
  8035e7:	00 00 00 
  8035ea:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8035ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8035f5:	48 98                	cltq   
  8035f7:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8035fe:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803605:	00 00 00 
  803608:	48 01 d0             	add    %rdx,%rax
  80360b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80360f:	eb 0c                	jmp    80361d <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  803611:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803618:	00 00 00 
  80361b:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80361d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803621:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803627:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80362a:	75 0e                	jne    80363a <wait+0x93>
  80362c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803630:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	75 d7                	jne    803611 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80363a:	c9                   	leaveq 
  80363b:	c3                   	retq   

000000000080363c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80363c:	55                   	push   %rbp
  80363d:	48 89 e5             	mov    %rsp,%rbp
  803640:	48 83 ec 20          	sub    $0x20,%rsp
  803644:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803647:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80364a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80364d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803651:	be 01 00 00 00       	mov    $0x1,%esi
  803656:	48 89 c7             	mov    %rax,%rdi
  803659:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
}
  803665:	c9                   	leaveq 
  803666:	c3                   	retq   

0000000000803667 <getchar>:

int
getchar(void)
{
  803667:	55                   	push   %rbp
  803668:	48 89 e5             	mov    %rsp,%rbp
  80366b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80366f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803673:	ba 01 00 00 00       	mov    $0x1,%edx
  803678:	48 89 c6             	mov    %rax,%rsi
  80367b:	bf 00 00 00 00       	mov    $0x0,%edi
  803680:	48 b8 25 25 80 00 00 	movabs $0x802525,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
  80368c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80368f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803693:	79 05                	jns    80369a <getchar+0x33>
		return r;
  803695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803698:	eb 14                	jmp    8036ae <getchar+0x47>
	if (r < 1)
  80369a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369e:	7f 07                	jg     8036a7 <getchar+0x40>
		return -E_EOF;
  8036a0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036a5:	eb 07                	jmp    8036ae <getchar+0x47>
	return c;
  8036a7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036ab:	0f b6 c0             	movzbl %al,%eax
}
  8036ae:	c9                   	leaveq 
  8036af:	c3                   	retq   

00000000008036b0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036b0:	55                   	push   %rbp
  8036b1:	48 89 e5             	mov    %rsp,%rbp
  8036b4:	48 83 ec 20          	sub    $0x20,%rsp
  8036b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c2:	48 89 d6             	mov    %rdx,%rsi
  8036c5:	89 c7                	mov    %eax,%edi
  8036c7:	48 b8 f3 20 80 00 00 	movabs $0x8020f3,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
  8036d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036da:	79 05                	jns    8036e1 <iscons+0x31>
		return r;
  8036dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036df:	eb 1a                	jmp    8036fb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e5:	8b 10                	mov    (%rax),%edx
  8036e7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8036ee:	00 00 00 
  8036f1:	8b 00                	mov    (%rax),%eax
  8036f3:	39 c2                	cmp    %eax,%edx
  8036f5:	0f 94 c0             	sete   %al
  8036f8:	0f b6 c0             	movzbl %al,%eax
}
  8036fb:	c9                   	leaveq 
  8036fc:	c3                   	retq   

00000000008036fd <opencons>:

int
opencons(void)
{
  8036fd:	55                   	push   %rbp
  8036fe:	48 89 e5             	mov    %rsp,%rbp
  803701:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803705:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803709:	48 89 c7             	mov    %rax,%rdi
  80370c:	48 b8 5b 20 80 00 00 	movabs $0x80205b,%rax
  803713:	00 00 00 
  803716:	ff d0                	callq  *%rax
  803718:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371f:	79 05                	jns    803726 <opencons+0x29>
		return r;
  803721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803724:	eb 5b                	jmp    803781 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372a:	ba 07 04 00 00       	mov    $0x407,%edx
  80372f:	48 89 c6             	mov    %rax,%rsi
  803732:	bf 00 00 00 00       	mov    $0x0,%edi
  803737:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
  803743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803746:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374a:	79 05                	jns    803751 <opencons+0x54>
		return r;
  80374c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374f:	eb 30                	jmp    803781 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803755:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80375c:	00 00 00 
  80375f:	8b 12                	mov    (%rdx),%edx
  803761:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80376e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803772:	48 89 c7             	mov    %rax,%rdi
  803775:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  80377c:	00 00 00 
  80377f:	ff d0                	callq  *%rax
}
  803781:	c9                   	leaveq 
  803782:	c3                   	retq   

0000000000803783 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803783:	55                   	push   %rbp
  803784:	48 89 e5             	mov    %rsp,%rbp
  803787:	48 83 ec 30          	sub    $0x30,%rsp
  80378b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80378f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803793:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803797:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80379c:	75 07                	jne    8037a5 <devcons_read+0x22>
		return 0;
  80379e:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a3:	eb 4b                	jmp    8037f0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037a5:	eb 0c                	jmp    8037b3 <devcons_read+0x30>
		sys_yield();
  8037a7:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8037b3:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
  8037bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c6:	74 df                	je     8037a7 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cc:	79 05                	jns    8037d3 <devcons_read+0x50>
		return c;
  8037ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d1:	eb 1d                	jmp    8037f0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037d3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037d7:	75 07                	jne    8037e0 <devcons_read+0x5d>
		return 0;
  8037d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037de:	eb 10                	jmp    8037f0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e3:	89 c2                	mov    %eax,%edx
  8037e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e9:	88 10                	mov    %dl,(%rax)
	return 1;
  8037eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037f0:	c9                   	leaveq 
  8037f1:	c3                   	retq   

00000000008037f2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037f2:	55                   	push   %rbp
  8037f3:	48 89 e5             	mov    %rsp,%rbp
  8037f6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037fd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803804:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80380b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803812:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803819:	eb 76                	jmp    803891 <devcons_write+0x9f>
		m = n - tot;
  80381b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803822:	89 c2                	mov    %eax,%edx
  803824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803827:	29 c2                	sub    %eax,%edx
  803829:	89 d0                	mov    %edx,%eax
  80382b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80382e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803831:	83 f8 7f             	cmp    $0x7f,%eax
  803834:	76 07                	jbe    80383d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803836:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80383d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803840:	48 63 d0             	movslq %eax,%rdx
  803843:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803846:	48 63 c8             	movslq %eax,%rcx
  803849:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803850:	48 01 c1             	add    %rax,%rcx
  803853:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80385a:	48 89 ce             	mov    %rcx,%rsi
  80385d:	48 89 c7             	mov    %rax,%rdi
  803860:	48 b8 b2 16 80 00 00 	movabs $0x8016b2,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80386c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386f:	48 63 d0             	movslq %eax,%rdx
  803872:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803879:	48 89 d6             	mov    %rdx,%rsi
  80387c:	48 89 c7             	mov    %rax,%rdi
  80387f:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80388b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80388e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803891:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803894:	48 98                	cltq   
  803896:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80389d:	0f 82 78 ff ff ff    	jb     80381b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8038a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038a6:	c9                   	leaveq 
  8038a7:	c3                   	retq   

00000000008038a8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038a8:	55                   	push   %rbp
  8038a9:	48 89 e5             	mov    %rsp,%rbp
  8038ac:	48 83 ec 08          	sub    $0x8,%rsp
  8038b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b9:	c9                   	leaveq 
  8038ba:	c3                   	retq   

00000000008038bb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
  8038bf:	48 83 ec 10          	sub    $0x10,%rsp
  8038c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cf:	48 be 27 47 80 00 00 	movabs $0x804727,%rsi
  8038d6:	00 00 00 
  8038d9:	48 89 c7             	mov    %rax,%rdi
  8038dc:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
	return 0;
  8038e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ed:	c9                   	leaveq 
  8038ee:	c3                   	retq   

00000000008038ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8038ef:	55                   	push   %rbp
  8038f0:	48 89 e5             	mov    %rsp,%rbp
  8038f3:	53                   	push   %rbx
  8038f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803902:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803908:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80390f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803916:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80391d:	84 c0                	test   %al,%al
  80391f:	74 23                	je     803944 <_panic+0x55>
  803921:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803928:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80392c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803930:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803934:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803938:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80393c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803940:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803944:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80394b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803952:	00 00 00 
  803955:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80395c:	00 00 00 
  80395f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803963:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80396a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803971:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803978:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80397f:	00 00 00 
  803982:	48 8b 18             	mov    (%rax),%rbx
  803985:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
  803991:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803997:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80399e:	41 89 c8             	mov    %ecx,%r8d
  8039a1:	48 89 d1             	mov    %rdx,%rcx
  8039a4:	48 89 da             	mov    %rbx,%rdx
  8039a7:	89 c6                	mov    %eax,%esi
  8039a9:	48 bf 30 47 80 00 00 	movabs $0x804730,%rdi
  8039b0:	00 00 00 
  8039b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b8:	49 b9 d9 07 80 00 00 	movabs $0x8007d9,%r9
  8039bf:	00 00 00 
  8039c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8039c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8039cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039d3:	48 89 d6             	mov    %rdx,%rsi
  8039d6:	48 89 c7             	mov    %rax,%rdi
  8039d9:	48 b8 2d 07 80 00 00 	movabs $0x80072d,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8039e5:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  8039ec:	00 00 00 
  8039ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f4:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  8039fb:	00 00 00 
  8039fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a00:	cc                   	int3   
  803a01:	eb fd                	jmp    803a00 <_panic+0x111>

0000000000803a03 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a03:	55                   	push   %rbp
  803a04:	48 89 e5             	mov    %rsp,%rbp
  803a07:	48 83 ec 30          	sub    $0x30,%rsp
  803a0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803a17:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a1e:	00 00 00 
  803a21:	48 8b 00             	mov    (%rax),%rax
  803a24:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	75 34                	jne    803a62 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a2e:	48 b8 41 1c 80 00 00 	movabs $0x801c41,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
  803a3a:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a3f:	48 98                	cltq   
  803a41:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803a48:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a4f:	00 00 00 
  803a52:	48 01 c2             	add    %rax,%rdx
  803a55:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a5c:	00 00 00 
  803a5f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a62:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a67:	75 0e                	jne    803a77 <ipc_recv+0x74>
		pg = (void*) UTOP;
  803a69:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a70:	00 00 00 
  803a73:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803a77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7b:	48 89 c7             	mov    %rax,%rdi
  803a7e:	48 b8 e6 1e 80 00 00 	movabs $0x801ee6,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
  803a8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803a8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a91:	79 19                	jns    803aac <ipc_recv+0xa9>
		*from_env_store = 0;
  803a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a97:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aaa:	eb 53                	jmp    803aff <ipc_recv+0xfc>
	}
	if(from_env_store)
  803aac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ab1:	74 19                	je     803acc <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803ab3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803aba:	00 00 00 
  803abd:	48 8b 00             	mov    (%rax),%rax
  803ac0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aca:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803acc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ad1:	74 19                	je     803aec <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803ad3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ada:	00 00 00 
  803add:	48 8b 00             	mov    (%rax),%rax
  803ae0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ae6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aea:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803aec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803af3:	00 00 00 
  803af6:	48 8b 00             	mov    (%rax),%rax
  803af9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803aff:	c9                   	leaveq 
  803b00:	c3                   	retq   

0000000000803b01 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b01:	55                   	push   %rbp
  803b02:	48 89 e5             	mov    %rsp,%rbp
  803b05:	48 83 ec 30          	sub    $0x30,%rsp
  803b09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b0c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b0f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b13:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803b16:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b1b:	75 0e                	jne    803b2b <ipc_send+0x2a>
		pg = (void*)UTOP;
  803b1d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b24:	00 00 00 
  803b27:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b2b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b2e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b38:	89 c7                	mov    %eax,%edi
  803b3a:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803b41:	00 00 00 
  803b44:	ff d0                	callq  *%rax
  803b46:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803b49:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b4d:	75 0c                	jne    803b5b <ipc_send+0x5a>
			sys_yield();
  803b4f:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b5b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b5f:	74 ca                	je     803b2b <ipc_send+0x2a>
	if(result != 0)
  803b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b65:	74 20                	je     803b87 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6a:	89 c6                	mov    %eax,%esi
  803b6c:	48 bf 58 47 80 00 00 	movabs $0x804758,%rdi
  803b73:	00 00 00 
  803b76:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7b:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  803b82:	00 00 00 
  803b85:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803b87:	c9                   	leaveq 
  803b88:	c3                   	retq   

0000000000803b89 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803b89:	55                   	push   %rbp
  803b8a:	48 89 e5             	mov    %rsp,%rbp
  803b8d:	53                   	push   %rbx
  803b8e:	48 83 ec 58          	sub    $0x58,%rsp
  803b92:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  803b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803b9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803ba5:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803bac:	00 
  803bad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803bb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803bbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bc1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803bc5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803bc9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd1:	48 c1 e8 27          	shr    $0x27,%rax
  803bd5:	48 89 c2             	mov    %rax,%rdx
  803bd8:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803bdf:	01 00 00 
  803be2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803be6:	83 e0 01             	and    $0x1,%eax
  803be9:	48 85 c0             	test   %rax,%rax
  803bec:	0f 85 91 00 00 00    	jne    803c83 <ipc_host_recv+0xfa>
  803bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf6:	48 c1 e8 1e          	shr    $0x1e,%rax
  803bfa:	48 89 c2             	mov    %rax,%rdx
  803bfd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c04:	01 00 00 
  803c07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0b:	83 e0 01             	and    $0x1,%eax
  803c0e:	48 85 c0             	test   %rax,%rax
  803c11:	74 70                	je     803c83 <ipc_host_recv+0xfa>
  803c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c17:	48 c1 e8 15          	shr    $0x15,%rax
  803c1b:	48 89 c2             	mov    %rax,%rdx
  803c1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c25:	01 00 00 
  803c28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2c:	83 e0 01             	and    $0x1,%eax
  803c2f:	48 85 c0             	test   %rax,%rax
  803c32:	74 4f                	je     803c83 <ipc_host_recv+0xfa>
  803c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c38:	48 c1 e8 0c          	shr    $0xc,%rax
  803c3c:	48 89 c2             	mov    %rax,%rdx
  803c3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c46:	01 00 00 
  803c49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4d:	83 e0 01             	and    $0x1,%eax
  803c50:	48 85 c0             	test   %rax,%rax
  803c53:	74 2e                	je     803c83 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c59:	ba 07 04 00 00       	mov    $0x407,%edx
  803c5e:	48 89 c6             	mov    %rax,%rsi
  803c61:	bf 00 00 00 00       	mov    $0x0,%edi
  803c66:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
  803c72:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803c75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803c79:	79 08                	jns    803c83 <ipc_host_recv+0xfa>
	    	return result;
  803c7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803c7e:	e9 84 00 00 00       	jmpq   803d07 <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803c83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c87:	48 c1 e8 0c          	shr    $0xc,%rax
  803c8b:	48 89 c2             	mov    %rax,%rdx
  803c8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c95:	01 00 00 
  803c98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c9c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803ca2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  803ca6:	b8 03 00 00 00       	mov    $0x3,%eax
  803cab:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803caf:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803cb3:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  803cb7:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803cbb:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803cbf:	4c 89 c3             	mov    %r8,%rbx
  803cc2:	0f 01 c1             	vmcall 
  803cc5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  803cc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803ccc:	7e 36                	jle    803d04 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  803cce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803cd1:	41 89 c0             	mov    %eax,%r8d
  803cd4:	b9 03 00 00 00       	mov    $0x3,%ecx
  803cd9:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  803ce0:	00 00 00 
  803ce3:	be 67 00 00 00       	mov    $0x67,%esi
  803ce8:	48 bf 9d 47 80 00 00 	movabs $0x80479d,%rdi
  803cef:	00 00 00 
  803cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf7:	49 b9 ef 38 80 00 00 	movabs $0x8038ef,%r9
  803cfe:	00 00 00 
  803d01:	41 ff d1             	callq  *%r9
	return result;
  803d04:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  803d07:	48 83 c4 58          	add    $0x58,%rsp
  803d0b:	5b                   	pop    %rbx
  803d0c:	5d                   	pop    %rbp
  803d0d:	c3                   	retq   

0000000000803d0e <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d0e:	55                   	push   %rbp
  803d0f:	48 89 e5             	mov    %rsp,%rbp
  803d12:	53                   	push   %rbx
  803d13:	48 83 ec 68          	sub    $0x68,%rsp
  803d17:	89 7d ac             	mov    %edi,-0x54(%rbp)
  803d1a:	89 75 a8             	mov    %esi,-0x58(%rbp)
  803d1d:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  803d21:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  803d24:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803d28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803d2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803d33:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803d3a:	00 
  803d3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803d43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d4f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803d53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d57:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  803d5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5f:	48 c1 e8 27          	shr    $0x27,%rax
  803d63:	48 89 c2             	mov    %rax,%rdx
  803d66:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803d6d:	01 00 00 
  803d70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d74:	83 e0 01             	and    $0x1,%eax
  803d77:	48 85 c0             	test   %rax,%rax
  803d7a:	0f 85 88 00 00 00    	jne    803e08 <ipc_host_send+0xfa>
  803d80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d84:	48 c1 e8 1e          	shr    $0x1e,%rax
  803d88:	48 89 c2             	mov    %rax,%rdx
  803d8b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803d92:	01 00 00 
  803d95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d99:	83 e0 01             	and    $0x1,%eax
  803d9c:	48 85 c0             	test   %rax,%rax
  803d9f:	74 67                	je     803e08 <ipc_host_send+0xfa>
  803da1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da5:	48 c1 e8 15          	shr    $0x15,%rax
  803da9:	48 89 c2             	mov    %rax,%rdx
  803dac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803db3:	01 00 00 
  803db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dba:	83 e0 01             	and    $0x1,%eax
  803dbd:	48 85 c0             	test   %rax,%rax
  803dc0:	74 46                	je     803e08 <ipc_host_send+0xfa>
  803dc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc6:	48 c1 e8 0c          	shr    $0xc,%rax
  803dca:	48 89 c2             	mov    %rax,%rdx
  803dcd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dd4:	01 00 00 
  803dd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ddb:	83 e0 01             	and    $0x1,%eax
  803dde:	48 85 c0             	test   %rax,%rax
  803de1:	74 25                	je     803e08 <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de7:	48 c1 e8 0c          	shr    $0xc,%rax
  803deb:	48 89 c2             	mov    %rax,%rdx
  803dee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803df5:	01 00 00 
  803df8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dfc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803e02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803e06:	eb 0e                	jmp    803e16 <ipc_host_send+0x108>
	else
		a3 = UTOP;
  803e08:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e0f:	00 00 00 
  803e12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  803e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1a:	48 89 c6             	mov    %rax,%rsi
  803e1d:	48 bf a7 47 80 00 00 	movabs $0x8047a7,%rdi
  803e24:	00 00 00 
  803e27:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2c:	48 ba d9 07 80 00 00 	movabs $0x8007d9,%rdx
  803e33:	00 00 00 
  803e36:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  803e38:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803e3b:	48 98                	cltq   
  803e3d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  803e41:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803e44:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  803e48:	8b 45 9c             	mov    -0x64(%rbp),%eax
  803e4b:	48 98                	cltq   
  803e4d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803e51:	b8 02 00 00 00       	mov    $0x2,%eax
  803e56:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803e5a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803e5e:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803e62:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803e66:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803e6a:	4c 89 c3             	mov    %r8,%rbx
  803e6d:	0f 01 c1             	vmcall 
  803e70:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803e73:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803e77:	75 0c                	jne    803e85 <ipc_host_send+0x177>
			sys_yield();
  803e79:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803e85:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  803e89:	74 c6                	je     803e51 <ipc_host_send+0x143>
	
	if(result !=0)
  803e8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e8f:	74 36                	je     803ec7 <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803e91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e94:	41 89 c0             	mov    %eax,%r8d
  803e97:	b9 02 00 00 00       	mov    $0x2,%ecx
  803e9c:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  803ea3:	00 00 00 
  803ea6:	be 94 00 00 00       	mov    $0x94,%esi
  803eab:	48 bf 9d 47 80 00 00 	movabs $0x80479d,%rdi
  803eb2:	00 00 00 
  803eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eba:	49 b9 ef 38 80 00 00 	movabs $0x8038ef,%r9
  803ec1:	00 00 00 
  803ec4:	41 ff d1             	callq  *%r9
}
  803ec7:	48 83 c4 68          	add    $0x68,%rsp
  803ecb:	5b                   	pop    %rbx
  803ecc:	5d                   	pop    %rbp
  803ecd:	c3                   	retq   

0000000000803ece <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ece:	55                   	push   %rbp
  803ecf:	48 89 e5             	mov    %rsp,%rbp
  803ed2:	48 83 ec 14          	sub    $0x14,%rsp
  803ed6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ee0:	eb 4e                	jmp    803f30 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803ee2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ee9:	00 00 00 
  803eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eef:	48 98                	cltq   
  803ef1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803ef8:	48 01 d0             	add    %rdx,%rax
  803efb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f01:	8b 00                	mov    (%rax),%eax
  803f03:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f06:	75 24                	jne    803f2c <ipc_find_env+0x5e>
			return envs[i].env_id;
  803f08:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f0f:	00 00 00 
  803f12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f15:	48 98                	cltq   
  803f17:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f1e:	48 01 d0             	add    %rdx,%rax
  803f21:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f27:	8b 40 08             	mov    0x8(%rax),%eax
  803f2a:	eb 12                	jmp    803f3e <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f30:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f37:	7e a9                	jle    803ee2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f3e:	c9                   	leaveq 
  803f3f:	c3                   	retq   

0000000000803f40 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f40:	55                   	push   %rbp
  803f41:	48 89 e5             	mov    %rsp,%rbp
  803f44:	48 83 ec 18          	sub    $0x18,%rsp
  803f48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f50:	48 c1 e8 15          	shr    $0x15,%rax
  803f54:	48 89 c2             	mov    %rax,%rdx
  803f57:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f5e:	01 00 00 
  803f61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f65:	83 e0 01             	and    $0x1,%eax
  803f68:	48 85 c0             	test   %rax,%rax
  803f6b:	75 07                	jne    803f74 <pageref+0x34>
		return 0;
  803f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f72:	eb 53                	jmp    803fc7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f78:	48 c1 e8 0c          	shr    $0xc,%rax
  803f7c:	48 89 c2             	mov    %rax,%rdx
  803f7f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f86:	01 00 00 
  803f89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f95:	83 e0 01             	and    $0x1,%eax
  803f98:	48 85 c0             	test   %rax,%rax
  803f9b:	75 07                	jne    803fa4 <pageref+0x64>
		return 0;
  803f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa2:	eb 23                	jmp    803fc7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa8:	48 c1 e8 0c          	shr    $0xc,%rax
  803fac:	48 89 c2             	mov    %rax,%rdx
  803faf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fb6:	00 00 00 
  803fb9:	48 c1 e2 04          	shl    $0x4,%rdx
  803fbd:	48 01 d0             	add    %rdx,%rax
  803fc0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fc4:	0f b7 c0             	movzwl %ax,%eax
}
  803fc7:	c9                   	leaveq 
  803fc8:	c3                   	retq   
