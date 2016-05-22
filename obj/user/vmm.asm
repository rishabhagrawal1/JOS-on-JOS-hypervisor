
obj/user/vmm:     file format elf64-x86-64


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
  80003c:	e8 93 06 00 00       	callq  8006d4 <libmain>
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
  8000d8:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
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
  800111:	48 b8 d4 28 80 00 00 	movabs $0x8028d4,%rax
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
  800161:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
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
  8001a8:	48 b8 2e 20 80 00 00 	movabs $0x80202e,%rax
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
  8001ce:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
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
  80026a:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  800271:	00 00 00 
  800274:	ff d0                	callq  *%rax
  800276:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800279:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80027d:	79 32                	jns    8002b1 <copy_guest_kern_gpa+0xaa>
        cprintf("open %s for read: %e\n", fname, fd );
  80027f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800282:	48 8b 85 c0 fd ff ff 	mov    -0x240(%rbp),%rax
  800289:	48 89 c6             	mov    %rax,%rsi
  80028c:	48 bf 60 3e 80 00 00 	movabs $0x803e60,%rdi
  800293:	00 00 00 
  800296:	b8 00 00 00 00       	mov    $0x0,%eax
  80029b:	48 b9 9f 08 80 00 00 	movabs $0x80089f,%rcx
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
  8002c5:	48 b8 e9 26 80 00 00 	movabs $0x8026e9,%rax
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
  8002e2:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
        cprintf("Error in reading ELF header bytes read are %d\n", bytesRead);
  8002ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002f1:	89 c6                	mov    %eax,%esi
  8002f3:	48 bf 78 3e 80 00 00 	movabs $0x803e78,%rdi
  8002fa:	00 00 00 
  8002fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800302:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
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
  800335:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
        cprintf("loading ELF header Failed due to Corrupt Kernel ELF\n");
  800341:	48 bf a8 3e 80 00 00 	movabs $0x803ea8,%rdi
  800348:	00 00 00 
  80034b:	b8 00 00 00 00       	mov    $0x0,%eax
  800350:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
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
  80041c:	48 bf e0 3e 80 00 00 	movabs $0x803ee0,%rdi
  800423:	00 00 00 
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  800432:	00 00 00 
  800435:	ff d2                	callq  *%rdx
										close(fd);
  800437:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80043a:	89 c7                	mov    %eax,%edi
  80043c:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
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
  800467:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
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
  80047e:	48 83 ec 60          	sub    $0x60,%rsp
  800482:	89 7d ac             	mov    %edi,-0x54(%rbp)
  800485:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	int ret;
	envid_t guest;
	char filename_buffer[50];	//buffer to save the path 
	int vmdisk_number;
	int r;
	if ((ret = sys_env_mkguest( GUEST_MEM_SZ, JOS_ENTRY )) < 0) {
  800489:	be 00 70 00 00       	mov    $0x7000,%esi
  80048e:	bf 00 00 00 01       	mov    $0x1000000,%edi
  800493:	48 b8 89 20 80 00 00 	movabs $0x802089,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	callq  *%rax
  80049f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004a6:	79 2c                	jns    8004d4 <umain+0x5a>
		cprintf("Error creating a guest OS env: %e\n", ret );
  8004a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ab:	89 c6                	mov    %eax,%esi
  8004ad:	48 bf 10 3f 80 00 00 	movabs $0x803f10,%rdi
  8004b4:	00 00 00 
  8004b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bc:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  8004c3:	00 00 00 
  8004c6:	ff d2                	callq  *%rdx
		exit();
  8004c8:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
	}
	guest = ret;
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Copy the guest kernel code into guest phys mem.
	if((ret = copy_guest_kern_gpa(guest, GUEST_KERN)) < 0) {
  8004da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004dd:	48 be 33 3f 80 00 00 	movabs $0x803f33,%rsi
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
  800503:	48 bf 40 3f 80 00 00 	movabs $0x803f40,%rdi
  80050a:	00 00 00 
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  800519:	00 00 00 
  80051c:	ff d2                	callq  *%rdx
		exit();
  80051e:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
	}

	// Now copy the bootloader.
	int fd;
	if ((fd = open( GUEST_BOOT, O_RDONLY)) < 0 ) {
  80052a:	be 00 00 00 00       	mov    $0x0,%esi
  80052f:	48 bf 69 3f 80 00 00 	movabs $0x803f69,%rdi
  800536:	00 00 00 
  800539:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  800540:	00 00 00 
  800543:	ff d0                	callq  *%rax
  800545:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800548:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80054c:	79 36                	jns    800584 <umain+0x10a>
		cprintf("open %s for read: %e\n", GUEST_BOOT, fd );
  80054e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800551:	89 c2                	mov    %eax,%edx
  800553:	48 be 69 3f 80 00 00 	movabs $0x803f69,%rsi
  80055a:	00 00 00 
  80055d:	48 bf 60 3e 80 00 00 	movabs $0x803e60,%rdi
  800564:	00 00 00 
  800567:	b8 00 00 00 00       	mov    $0x0,%eax
  80056c:	48 b9 9f 08 80 00 00 	movabs $0x80089f,%rcx
  800573:	00 00 00 
  800576:	ff d1                	callq  *%rcx
		exit();
  800578:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
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
  8005be:	48 bf e0 3e 80 00 00 	movabs $0x803ee0,%rdi
  8005c5:	00 00 00 
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  8005d4:	00 00 00 
  8005d7:	ff d2                	callq  *%rdx
		exit();
  8005d9:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  8005e0:	00 00 00 
  8005e3:	ff d0                	callq  *%rax
	}
#ifndef VMM_GUEST	
	sys_vmx_incr_vmdisk_number();	//increase the vmdisk number
  8005e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ea:	48 ba 93 21 80 00 00 	movabs $0x802193,%rdx
  8005f1:	00 00 00 
  8005f4:	ff d2                	callq  *%rdx
	//create a new guest disk image
	
	vmdisk_number = sys_vmx_get_vmdisk_number();
  8005f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fb:	48 ba 55 21 80 00 00 	movabs $0x802155,%rdx
  800602:	00 00 00 
  800605:	ff d2                	callq  *%rdx
  800607:	89 45 f0             	mov    %eax,-0x10(%rbp)
	snprintf(filename_buffer, 50, "/vmm/fs%d.img", vmdisk_number);
  80060a:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80060d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800611:	89 d1                	mov    %edx,%ecx
  800613:	48 ba 73 3f 80 00 00 	movabs $0x803f73,%rdx
  80061a:	00 00 00 
  80061d:	be 32 00 00 00       	mov    $0x32,%esi
  800622:	48 89 c7             	mov    %rax,%rdi
  800625:	b8 00 00 00 00       	mov    $0x0,%eax
  80062a:	49 b8 07 13 80 00 00 	movabs $0x801307,%r8
  800631:	00 00 00 
  800634:	41 ff d0             	callq  *%r8
	
	cprintf("Creating a new virtual HDD at /vmm/fs%d.img\n", vmdisk_number);
  800637:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80063a:	89 c6                	mov    %eax,%esi
  80063c:	48 bf 88 3f 80 00 00 	movabs $0x803f88,%rdi
  800643:	00 00 00 
  800646:	b8 00 00 00 00       	mov    $0x0,%eax
  80064b:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  800652:	00 00 00 
  800655:	ff d2                	callq  *%rdx
        //r = copy("vmm/clean-fs.img", filename_buffer);
        r = 0;
  800657:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        if (r < 0) {
  80065e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800662:	79 2c                	jns    800690 <umain+0x216>
        	cprintf("Create new virtual HDD failed: %e\n", r);
  800664:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800667:	89 c6                	mov    %eax,%esi
  800669:	48 bf b8 3f 80 00 00 	movabs $0x803fb8,%rdi
  800670:	00 00 00 
  800673:	b8 00 00 00 00       	mov    $0x0,%eax
  800678:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  80067f:	00 00 00 
  800682:	ff d2                	callq  *%rdx
        	exit();
  800684:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  80068b:	00 00 00 
  80068e:	ff d0                	callq  *%rax
        }
        
        cprintf("Create VHD finished\n");
  800690:	48 bf db 3f 80 00 00 	movabs $0x803fdb,%rdi
  800697:	00 00 00 
  80069a:	b8 00 00 00 00       	mov    $0x0,%eax
  80069f:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  8006a6:	00 00 00 
  8006a9:	ff d2                	callq  *%rdx
#endif
	// Mark the guest as runnable.
	sys_env_set_status(guest, ENV_RUNNABLE);
  8006ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8006ae:	be 02 00 00 00       	mov    $0x2,%esi
  8006b3:	89 c7                	mov    %eax,%edi
  8006b5:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  8006bc:	00 00 00 
  8006bf:	ff d0                	callq  *%rax
	wait(guest);
  8006c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8006c4:	89 c7                	mov    %eax,%edi
  8006c6:	48 b8 6b 37 80 00 00 	movabs $0x80376b,%rax
  8006cd:	00 00 00 
  8006d0:	ff d0                	callq  *%rax
}
  8006d2:	c9                   	leaveq 
  8006d3:	c3                   	retq   

00000000008006d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006d4:	55                   	push   %rbp
  8006d5:	48 89 e5             	mov    %rsp,%rbp
  8006d8:	48 83 ec 10          	sub    $0x10,%rsp
  8006dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8006e3:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8006ea:	00 00 00 
  8006ed:	ff d0                	callq  *%rax
  8006ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006f4:	48 98                	cltq   
  8006f6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8006fd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800704:	00 00 00 
  800707:	48 01 c2             	add    %rax,%rdx
  80070a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800711:	00 00 00 
  800714:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80071b:	7e 14                	jle    800731 <libmain+0x5d>
		binaryname = argv[0];
  80071d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800721:	48 8b 10             	mov    (%rax),%rdx
  800724:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80072b:	00 00 00 
  80072e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800731:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800738:	48 89 d6             	mov    %rdx,%rsi
  80073b:	89 c7                	mov    %eax,%edi
  80073d:	48 b8 7a 04 80 00 00 	movabs $0x80047a,%rax
  800744:	00 00 00 
  800747:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800749:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800750:	00 00 00 
  800753:	ff d0                	callq  *%rax
}
  800755:	c9                   	leaveq 
  800756:	c3                   	retq   

0000000000800757 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80075b:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  800762:	00 00 00 
  800765:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800767:	bf 00 00 00 00       	mov    $0x0,%edi
  80076c:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  800773:	00 00 00 
  800776:	ff d0                	callq  *%rax

}
  800778:	5d                   	pop    %rbp
  800779:	c3                   	retq   

000000000080077a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80077a:	55                   	push   %rbp
  80077b:	48 89 e5             	mov    %rsp,%rbp
  80077e:	48 83 ec 10          	sub    $0x10,%rsp
  800782:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800785:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80078d:	8b 00                	mov    (%rax),%eax
  80078f:	8d 48 01             	lea    0x1(%rax),%ecx
  800792:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800796:	89 0a                	mov    %ecx,(%rdx)
  800798:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80079b:	89 d1                	mov    %edx,%ecx
  80079d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007a1:	48 98                	cltq   
  8007a3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8007a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ab:	8b 00                	mov    (%rax),%eax
  8007ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b2:	75 2c                	jne    8007e0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8007b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b8:	8b 00                	mov    (%rax),%eax
  8007ba:	48 98                	cltq   
  8007bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007c0:	48 83 c2 08          	add    $0x8,%rdx
  8007c4:	48 89 c6             	mov    %rax,%rsi
  8007c7:	48 89 d7             	mov    %rdx,%rdi
  8007ca:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  8007d1:	00 00 00 
  8007d4:	ff d0                	callq  *%rax
        b->idx = 0;
  8007d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007da:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8007e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007e4:	8b 40 04             	mov    0x4(%rax),%eax
  8007e7:	8d 50 01             	lea    0x1(%rax),%edx
  8007ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ee:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007f1:	c9                   	leaveq 
  8007f2:	c3                   	retq   

00000000008007f3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8007f3:	55                   	push   %rbp
  8007f4:	48 89 e5             	mov    %rsp,%rbp
  8007f7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8007fe:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800805:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80080c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800813:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80081a:	48 8b 0a             	mov    (%rdx),%rcx
  80081d:	48 89 08             	mov    %rcx,(%rax)
  800820:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800824:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800828:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80082c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800830:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800837:	00 00 00 
    b.cnt = 0;
  80083a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800841:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800844:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80084b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800852:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800859:	48 89 c6             	mov    %rax,%rsi
  80085c:	48 bf 7a 07 80 00 00 	movabs $0x80077a,%rdi
  800863:	00 00 00 
  800866:	48 b8 52 0c 80 00 00 	movabs $0x800c52,%rax
  80086d:	00 00 00 
  800870:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800872:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800878:	48 98                	cltq   
  80087a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800881:	48 83 c2 08          	add    $0x8,%rdx
  800885:	48 89 c6             	mov    %rax,%rsi
  800888:	48 89 d7             	mov    %rdx,%rdi
  80088b:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  800892:	00 00 00 
  800895:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800897:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80089d:	c9                   	leaveq 
  80089e:	c3                   	retq   

000000000080089f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80089f:	55                   	push   %rbp
  8008a0:	48 89 e5             	mov    %rsp,%rbp
  8008a3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8008aa:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8008b1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8008b8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8008bf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8008c6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8008cd:	84 c0                	test   %al,%al
  8008cf:	74 20                	je     8008f1 <cprintf+0x52>
  8008d1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8008d5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008d9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008dd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008e1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008e5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008e9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008ed:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8008f1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8008f8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8008ff:	00 00 00 
  800902:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800909:	00 00 00 
  80090c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800910:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800917:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80091e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800925:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80092c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800933:	48 8b 0a             	mov    (%rdx),%rcx
  800936:	48 89 08             	mov    %rcx,(%rax)
  800939:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80093d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800941:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800945:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800949:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800950:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800957:	48 89 d6             	mov    %rdx,%rsi
  80095a:	48 89 c7             	mov    %rax,%rdi
  80095d:	48 b8 f3 07 80 00 00 	movabs $0x8007f3,%rax
  800964:	00 00 00 
  800967:	ff d0                	callq  *%rax
  800969:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80096f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800975:	c9                   	leaveq 
  800976:	c3                   	retq   

0000000000800977 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800977:	55                   	push   %rbp
  800978:	48 89 e5             	mov    %rsp,%rbp
  80097b:	53                   	push   %rbx
  80097c:	48 83 ec 38          	sub    $0x38,%rsp
  800980:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800984:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800988:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80098c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80098f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800993:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800997:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80099a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80099e:	77 3b                	ja     8009db <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009a0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8009a3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8009a7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8009aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	48 f7 f3             	div    %rbx
  8009b6:	48 89 c2             	mov    %rax,%rdx
  8009b9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8009bc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8009bf:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	41 89 f9             	mov    %edi,%r9d
  8009ca:	48 89 c7             	mov    %rax,%rdi
  8009cd:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  8009d4:	00 00 00 
  8009d7:	ff d0                	callq  *%rax
  8009d9:	eb 1e                	jmp    8009f9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009db:	eb 12                	jmp    8009ef <printnum+0x78>
			putch(padc, putdat);
  8009dd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009e1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 89 ce             	mov    %rcx,%rsi
  8009eb:	89 d7                	mov    %edx,%edi
  8009ed:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009ef:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8009f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8009f7:	7f e4                	jg     8009dd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009f9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8009fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
  800a05:	48 f7 f1             	div    %rcx
  800a08:	48 89 d0             	mov    %rdx,%rax
  800a0b:	48 ba f0 41 80 00 00 	movabs $0x8041f0,%rdx
  800a12:	00 00 00 
  800a15:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800a19:	0f be d0             	movsbl %al,%edx
  800a1c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	48 89 ce             	mov    %rcx,%rsi
  800a27:	89 d7                	mov    %edx,%edi
  800a29:	ff d0                	callq  *%rax
}
  800a2b:	48 83 c4 38          	add    $0x38,%rsp
  800a2f:	5b                   	pop    %rbx
  800a30:	5d                   	pop    %rbp
  800a31:	c3                   	retq   

0000000000800a32 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a32:	55                   	push   %rbp
  800a33:	48 89 e5             	mov    %rsp,%rbp
  800a36:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a3e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a41:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a45:	7e 52                	jle    800a99 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4b:	8b 00                	mov    (%rax),%eax
  800a4d:	83 f8 30             	cmp    $0x30,%eax
  800a50:	73 24                	jae    800a76 <getuint+0x44>
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	89 c0                	mov    %eax,%eax
  800a62:	48 01 d0             	add    %rdx,%rax
  800a65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a69:	8b 12                	mov    (%rdx),%edx
  800a6b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a72:	89 0a                	mov    %ecx,(%rdx)
  800a74:	eb 17                	jmp    800a8d <getuint+0x5b>
  800a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a7e:	48 89 d0             	mov    %rdx,%rax
  800a81:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a89:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8d:	48 8b 00             	mov    (%rax),%rax
  800a90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a94:	e9 a3 00 00 00       	jmpq   800b3c <getuint+0x10a>
	else if (lflag)
  800a99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a9d:	74 4f                	je     800aee <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa3:	8b 00                	mov    (%rax),%eax
  800aa5:	83 f8 30             	cmp    $0x30,%eax
  800aa8:	73 24                	jae    800ace <getuint+0x9c>
  800aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab6:	8b 00                	mov    (%rax),%eax
  800ab8:	89 c0                	mov    %eax,%eax
  800aba:	48 01 d0             	add    %rdx,%rax
  800abd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac1:	8b 12                	mov    (%rdx),%edx
  800ac3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aca:	89 0a                	mov    %ecx,(%rdx)
  800acc:	eb 17                	jmp    800ae5 <getuint+0xb3>
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ad6:	48 89 d0             	mov    %rdx,%rax
  800ad9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae5:	48 8b 00             	mov    (%rax),%rax
  800ae8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aec:	eb 4e                	jmp    800b3c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	8b 00                	mov    (%rax),%eax
  800af4:	83 f8 30             	cmp    $0x30,%eax
  800af7:	73 24                	jae    800b1d <getuint+0xeb>
  800af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b05:	8b 00                	mov    (%rax),%eax
  800b07:	89 c0                	mov    %eax,%eax
  800b09:	48 01 d0             	add    %rdx,%rax
  800b0c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b10:	8b 12                	mov    (%rdx),%edx
  800b12:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b15:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b19:	89 0a                	mov    %ecx,(%rdx)
  800b1b:	eb 17                	jmp    800b34 <getuint+0x102>
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b25:	48 89 d0             	mov    %rdx,%rax
  800b28:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b2c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b30:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b34:	8b 00                	mov    (%rax),%eax
  800b36:	89 c0                	mov    %eax,%eax
  800b38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b40:	c9                   	leaveq 
  800b41:	c3                   	retq   

0000000000800b42 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b42:	55                   	push   %rbp
  800b43:	48 89 e5             	mov    %rsp,%rbp
  800b46:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b4e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b51:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b55:	7e 52                	jle    800ba9 <getint+0x67>
		x=va_arg(*ap, long long);
  800b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5b:	8b 00                	mov    (%rax),%eax
  800b5d:	83 f8 30             	cmp    $0x30,%eax
  800b60:	73 24                	jae    800b86 <getint+0x44>
  800b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b66:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6e:	8b 00                	mov    (%rax),%eax
  800b70:	89 c0                	mov    %eax,%eax
  800b72:	48 01 d0             	add    %rdx,%rax
  800b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b79:	8b 12                	mov    (%rdx),%edx
  800b7b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b82:	89 0a                	mov    %ecx,(%rdx)
  800b84:	eb 17                	jmp    800b9d <getint+0x5b>
  800b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b8e:	48 89 d0             	mov    %rdx,%rax
  800b91:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b99:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b9d:	48 8b 00             	mov    (%rax),%rax
  800ba0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ba4:	e9 a3 00 00 00       	jmpq   800c4c <getint+0x10a>
	else if (lflag)
  800ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800bad:	74 4f                	je     800bfe <getint+0xbc>
		x=va_arg(*ap, long);
  800baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb3:	8b 00                	mov    (%rax),%eax
  800bb5:	83 f8 30             	cmp    $0x30,%eax
  800bb8:	73 24                	jae    800bde <getint+0x9c>
  800bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc6:	8b 00                	mov    (%rax),%eax
  800bc8:	89 c0                	mov    %eax,%eax
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bd1:	8b 12                	mov    (%rdx),%edx
  800bd3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bda:	89 0a                	mov    %ecx,(%rdx)
  800bdc:	eb 17                	jmp    800bf5 <getint+0xb3>
  800bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800be6:	48 89 d0             	mov    %rdx,%rax
  800be9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bf5:	48 8b 00             	mov    (%rax),%rax
  800bf8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bfc:	eb 4e                	jmp    800c4c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c02:	8b 00                	mov    (%rax),%eax
  800c04:	83 f8 30             	cmp    $0x30,%eax
  800c07:	73 24                	jae    800c2d <getint+0xeb>
  800c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c15:	8b 00                	mov    (%rax),%eax
  800c17:	89 c0                	mov    %eax,%eax
  800c19:	48 01 d0             	add    %rdx,%rax
  800c1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c20:	8b 12                	mov    (%rdx),%edx
  800c22:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c29:	89 0a                	mov    %ecx,(%rdx)
  800c2b:	eb 17                	jmp    800c44 <getint+0x102>
  800c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c31:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c35:	48 89 d0             	mov    %rdx,%rax
  800c38:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c40:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c44:	8b 00                	mov    (%rax),%eax
  800c46:	48 98                	cltq   
  800c48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c50:	c9                   	leaveq 
  800c51:	c3                   	retq   

0000000000800c52 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c52:	55                   	push   %rbp
  800c53:	48 89 e5             	mov    %rsp,%rbp
  800c56:	41 54                	push   %r12
  800c58:	53                   	push   %rbx
  800c59:	48 83 ec 60          	sub    $0x60,%rsp
  800c5d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c61:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c65:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c69:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c6d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c71:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c75:	48 8b 0a             	mov    (%rdx),%rcx
  800c78:	48 89 08             	mov    %rcx,(%rax)
  800c7b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c7f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c87:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8b:	eb 17                	jmp    800ca4 <vprintfmt+0x52>
			if (ch == '\0')
  800c8d:	85 db                	test   %ebx,%ebx
  800c8f:	0f 84 cc 04 00 00    	je     801161 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800c95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9d:	48 89 d6             	mov    %rdx,%rsi
  800ca0:	89 df                	mov    %ebx,%edi
  800ca2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cac:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cb0:	0f b6 00             	movzbl (%rax),%eax
  800cb3:	0f b6 d8             	movzbl %al,%ebx
  800cb6:	83 fb 25             	cmp    $0x25,%ebx
  800cb9:	75 d2                	jne    800c8d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cbb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800cbf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800cc6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800cd4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cdb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cdf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ce3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ce7:	0f b6 00             	movzbl (%rax),%eax
  800cea:	0f b6 d8             	movzbl %al,%ebx
  800ced:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800cf0:	83 f8 55             	cmp    $0x55,%eax
  800cf3:	0f 87 34 04 00 00    	ja     80112d <vprintfmt+0x4db>
  800cf9:	89 c0                	mov    %eax,%eax
  800cfb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800d02:	00 
  800d03:	48 b8 18 42 80 00 00 	movabs $0x804218,%rax
  800d0a:	00 00 00 
  800d0d:	48 01 d0             	add    %rdx,%rax
  800d10:	48 8b 00             	mov    (%rax),%rax
  800d13:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800d15:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d19:	eb c0                	jmp    800cdb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d1b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d1f:	eb ba                	jmp    800cdb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d21:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d28:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d2b:	89 d0                	mov    %edx,%eax
  800d2d:	c1 e0 02             	shl    $0x2,%eax
  800d30:	01 d0                	add    %edx,%eax
  800d32:	01 c0                	add    %eax,%eax
  800d34:	01 d8                	add    %ebx,%eax
  800d36:	83 e8 30             	sub    $0x30,%eax
  800d39:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d40:	0f b6 00             	movzbl (%rax),%eax
  800d43:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d46:	83 fb 2f             	cmp    $0x2f,%ebx
  800d49:	7e 0c                	jle    800d57 <vprintfmt+0x105>
  800d4b:	83 fb 39             	cmp    $0x39,%ebx
  800d4e:	7f 07                	jg     800d57 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d50:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d55:	eb d1                	jmp    800d28 <vprintfmt+0xd6>
			goto process_precision;
  800d57:	eb 58                	jmp    800db1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800d59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5c:	83 f8 30             	cmp    $0x30,%eax
  800d5f:	73 17                	jae    800d78 <vprintfmt+0x126>
  800d61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d68:	89 c0                	mov    %eax,%eax
  800d6a:	48 01 d0             	add    %rdx,%rax
  800d6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d70:	83 c2 08             	add    $0x8,%edx
  800d73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d76:	eb 0f                	jmp    800d87 <vprintfmt+0x135>
  800d78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7c:	48 89 d0             	mov    %rdx,%rax
  800d7f:	48 83 c2 08          	add    $0x8,%rdx
  800d83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d87:	8b 00                	mov    (%rax),%eax
  800d89:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d8c:	eb 23                	jmp    800db1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d92:	79 0c                	jns    800da0 <vprintfmt+0x14e>
				width = 0;
  800d94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d9b:	e9 3b ff ff ff       	jmpq   800cdb <vprintfmt+0x89>
  800da0:	e9 36 ff ff ff       	jmpq   800cdb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800da5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800dac:	e9 2a ff ff ff       	jmpq   800cdb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800db1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db5:	79 12                	jns    800dc9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800db7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dba:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800dbd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800dc4:	e9 12 ff ff ff       	jmpq   800cdb <vprintfmt+0x89>
  800dc9:	e9 0d ff ff ff       	jmpq   800cdb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dce:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800dd2:	e9 04 ff ff ff       	jmpq   800cdb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800dd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dda:	83 f8 30             	cmp    $0x30,%eax
  800ddd:	73 17                	jae    800df6 <vprintfmt+0x1a4>
  800ddf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800de3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de6:	89 c0                	mov    %eax,%eax
  800de8:	48 01 d0             	add    %rdx,%rax
  800deb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dee:	83 c2 08             	add    $0x8,%edx
  800df1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800df4:	eb 0f                	jmp    800e05 <vprintfmt+0x1b3>
  800df6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dfa:	48 89 d0             	mov    %rdx,%rax
  800dfd:	48 83 c2 08          	add    $0x8,%rdx
  800e01:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e05:	8b 10                	mov    (%rax),%edx
  800e07:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0f:	48 89 ce             	mov    %rcx,%rsi
  800e12:	89 d7                	mov    %edx,%edi
  800e14:	ff d0                	callq  *%rax
			break;
  800e16:	e9 40 03 00 00       	jmpq   80115b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800e1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1e:	83 f8 30             	cmp    $0x30,%eax
  800e21:	73 17                	jae    800e3a <vprintfmt+0x1e8>
  800e23:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2a:	89 c0                	mov    %eax,%eax
  800e2c:	48 01 d0             	add    %rdx,%rax
  800e2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e32:	83 c2 08             	add    $0x8,%edx
  800e35:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e38:	eb 0f                	jmp    800e49 <vprintfmt+0x1f7>
  800e3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3e:	48 89 d0             	mov    %rdx,%rax
  800e41:	48 83 c2 08          	add    $0x8,%rdx
  800e45:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e49:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e4b:	85 db                	test   %ebx,%ebx
  800e4d:	79 02                	jns    800e51 <vprintfmt+0x1ff>
				err = -err;
  800e4f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e51:	83 fb 15             	cmp    $0x15,%ebx
  800e54:	7f 16                	jg     800e6c <vprintfmt+0x21a>
  800e56:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  800e5d:	00 00 00 
  800e60:	48 63 d3             	movslq %ebx,%rdx
  800e63:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e67:	4d 85 e4             	test   %r12,%r12
  800e6a:	75 2e                	jne    800e9a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800e6c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e74:	89 d9                	mov    %ebx,%ecx
  800e76:	48 ba 01 42 80 00 00 	movabs $0x804201,%rdx
  800e7d:	00 00 00 
  800e80:	48 89 c7             	mov    %rax,%rdi
  800e83:	b8 00 00 00 00       	mov    $0x0,%eax
  800e88:	49 b8 6a 11 80 00 00 	movabs $0x80116a,%r8
  800e8f:	00 00 00 
  800e92:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e95:	e9 c1 02 00 00       	jmpq   80115b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea2:	4c 89 e1             	mov    %r12,%rcx
  800ea5:	48 ba 0a 42 80 00 00 	movabs $0x80420a,%rdx
  800eac:	00 00 00 
  800eaf:	48 89 c7             	mov    %rax,%rdi
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb7:	49 b8 6a 11 80 00 00 	movabs $0x80116a,%r8
  800ebe:	00 00 00 
  800ec1:	41 ff d0             	callq  *%r8
			break;
  800ec4:	e9 92 02 00 00       	jmpq   80115b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ec9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ecc:	83 f8 30             	cmp    $0x30,%eax
  800ecf:	73 17                	jae    800ee8 <vprintfmt+0x296>
  800ed1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ed5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed8:	89 c0                	mov    %eax,%eax
  800eda:	48 01 d0             	add    %rdx,%rax
  800edd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ee0:	83 c2 08             	add    $0x8,%edx
  800ee3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ee6:	eb 0f                	jmp    800ef7 <vprintfmt+0x2a5>
  800ee8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eec:	48 89 d0             	mov    %rdx,%rax
  800eef:	48 83 c2 08          	add    $0x8,%rdx
  800ef3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ef7:	4c 8b 20             	mov    (%rax),%r12
  800efa:	4d 85 e4             	test   %r12,%r12
  800efd:	75 0a                	jne    800f09 <vprintfmt+0x2b7>
				p = "(null)";
  800eff:	49 bc 0d 42 80 00 00 	movabs $0x80420d,%r12
  800f06:	00 00 00 
			if (width > 0 && padc != '-')
  800f09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f0d:	7e 3f                	jle    800f4e <vprintfmt+0x2fc>
  800f0f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800f13:	74 39                	je     800f4e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f15:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f18:	48 98                	cltq   
  800f1a:	48 89 c6             	mov    %rax,%rsi
  800f1d:	4c 89 e7             	mov    %r12,%rdi
  800f20:	48 b8 16 14 80 00 00 	movabs $0x801416,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
  800f2c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f2f:	eb 17                	jmp    800f48 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800f31:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800f35:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3d:	48 89 ce             	mov    %rcx,%rsi
  800f40:	89 d7                	mov    %edx,%edi
  800f42:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f44:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f48:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f4c:	7f e3                	jg     800f31 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f4e:	eb 37                	jmp    800f87 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800f50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f54:	74 1e                	je     800f74 <vprintfmt+0x322>
  800f56:	83 fb 1f             	cmp    $0x1f,%ebx
  800f59:	7e 05                	jle    800f60 <vprintfmt+0x30e>
  800f5b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f5e:	7e 14                	jle    800f74 <vprintfmt+0x322>
					putch('?', putdat);
  800f60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f68:	48 89 d6             	mov    %rdx,%rsi
  800f6b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f70:	ff d0                	callq  *%rax
  800f72:	eb 0f                	jmp    800f83 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800f74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7c:	48 89 d6             	mov    %rdx,%rsi
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f83:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f87:	4c 89 e0             	mov    %r12,%rax
  800f8a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f8e:	0f b6 00             	movzbl (%rax),%eax
  800f91:	0f be d8             	movsbl %al,%ebx
  800f94:	85 db                	test   %ebx,%ebx
  800f96:	74 10                	je     800fa8 <vprintfmt+0x356>
  800f98:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f9c:	78 b2                	js     800f50 <vprintfmt+0x2fe>
  800f9e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800fa2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800fa6:	79 a8                	jns    800f50 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fa8:	eb 16                	jmp    800fc0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800faa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb2:	48 89 d6             	mov    %rdx,%rsi
  800fb5:	bf 20 00 00 00       	mov    $0x20,%edi
  800fba:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fbc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fc4:	7f e4                	jg     800faa <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800fc6:	e9 90 01 00 00       	jmpq   80115b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800fcb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fcf:	be 03 00 00 00       	mov    $0x3,%esi
  800fd4:	48 89 c7             	mov    %rax,%rdi
  800fd7:	48 b8 42 0b 80 00 00 	movabs $0x800b42,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	callq  *%rax
  800fe3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	48 85 c0             	test   %rax,%rax
  800fee:	79 1d                	jns    80100d <vprintfmt+0x3bb>
				putch('-', putdat);
  800ff0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff8:	48 89 d6             	mov    %rdx,%rsi
  800ffb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801000:	ff d0                	callq  *%rax
				num = -(long long) num;
  801002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801006:	48 f7 d8             	neg    %rax
  801009:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80100d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801014:	e9 d5 00 00 00       	jmpq   8010ee <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801019:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80101d:	be 03 00 00 00       	mov    $0x3,%esi
  801022:	48 89 c7             	mov    %rax,%rdi
  801025:	48 b8 32 0a 80 00 00 	movabs $0x800a32,%rax
  80102c:	00 00 00 
  80102f:	ff d0                	callq  *%rax
  801031:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801035:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80103c:	e9 ad 00 00 00       	jmpq   8010ee <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801041:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801044:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801048:	89 d6                	mov    %edx,%esi
  80104a:	48 89 c7             	mov    %rax,%rdi
  80104d:	48 b8 42 0b 80 00 00 	movabs $0x800b42,%rax
  801054:	00 00 00 
  801057:	ff d0                	callq  *%rax
  801059:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80105d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801064:	e9 85 00 00 00       	jmpq   8010ee <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801069:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80106d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801071:	48 89 d6             	mov    %rdx,%rsi
  801074:	bf 30 00 00 00       	mov    $0x30,%edi
  801079:	ff d0                	callq  *%rax
			putch('x', putdat);
  80107b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80107f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801083:	48 89 d6             	mov    %rdx,%rsi
  801086:	bf 78 00 00 00       	mov    $0x78,%edi
  80108b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80108d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801090:	83 f8 30             	cmp    $0x30,%eax
  801093:	73 17                	jae    8010ac <vprintfmt+0x45a>
  801095:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801099:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80109c:	89 c0                	mov    %eax,%eax
  80109e:	48 01 d0             	add    %rdx,%rax
  8010a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010a4:	83 c2 08             	add    $0x8,%edx
  8010a7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010aa:	eb 0f                	jmp    8010bb <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8010ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010b0:	48 89 d0             	mov    %rdx,%rax
  8010b3:	48 83 c2 08          	add    $0x8,%rdx
  8010b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010bb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8010c2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8010c9:	eb 23                	jmp    8010ee <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8010cb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010cf:	be 03 00 00 00       	mov    $0x3,%esi
  8010d4:	48 89 c7             	mov    %rax,%rdi
  8010d7:	48 b8 32 0a 80 00 00 	movabs $0x800a32,%rax
  8010de:	00 00 00 
  8010e1:	ff d0                	callq  *%rax
  8010e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010e7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010ee:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010f3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010f6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010fd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801101:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801105:	45 89 c1             	mov    %r8d,%r9d
  801108:	41 89 f8             	mov    %edi,%r8d
  80110b:	48 89 c7             	mov    %rax,%rdi
  80110e:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  801115:	00 00 00 
  801118:	ff d0                	callq  *%rax
			break;
  80111a:	eb 3f                	jmp    80115b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80111c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801120:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801124:	48 89 d6             	mov    %rdx,%rsi
  801127:	89 df                	mov    %ebx,%edi
  801129:	ff d0                	callq  *%rax
			break;
  80112b:	eb 2e                	jmp    80115b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80112d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801131:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801135:	48 89 d6             	mov    %rdx,%rsi
  801138:	bf 25 00 00 00       	mov    $0x25,%edi
  80113d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80113f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801144:	eb 05                	jmp    80114b <vprintfmt+0x4f9>
  801146:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80114b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80114f:	48 83 e8 01          	sub    $0x1,%rax
  801153:	0f b6 00             	movzbl (%rax),%eax
  801156:	3c 25                	cmp    $0x25,%al
  801158:	75 ec                	jne    801146 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80115a:	90                   	nop
		}
	}
  80115b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80115c:	e9 43 fb ff ff       	jmpq   800ca4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801161:	48 83 c4 60          	add    $0x60,%rsp
  801165:	5b                   	pop    %rbx
  801166:	41 5c                	pop    %r12
  801168:	5d                   	pop    %rbp
  801169:	c3                   	retq   

000000000080116a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80116a:	55                   	push   %rbp
  80116b:	48 89 e5             	mov    %rsp,%rbp
  80116e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801175:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80117c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801183:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80118a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801191:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801198:	84 c0                	test   %al,%al
  80119a:	74 20                	je     8011bc <printfmt+0x52>
  80119c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011bc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8011c3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8011ca:	00 00 00 
  8011cd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011d4:	00 00 00 
  8011d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011db:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011e9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011f0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011f7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011fe:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801205:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80120c:	48 89 c7             	mov    %rax,%rdi
  80120f:	48 b8 52 0c 80 00 00 	movabs $0x800c52,%rax
  801216:	00 00 00 
  801219:	ff d0                	callq  *%rax
	va_end(ap);
}
  80121b:	c9                   	leaveq 
  80121c:	c3                   	retq   

000000000080121d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80121d:	55                   	push   %rbp
  80121e:	48 89 e5             	mov    %rsp,%rbp
  801221:	48 83 ec 10          	sub    $0x10,%rsp
  801225:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80122c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801230:	8b 40 10             	mov    0x10(%rax),%eax
  801233:	8d 50 01             	lea    0x1(%rax),%edx
  801236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80123d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801241:	48 8b 10             	mov    (%rax),%rdx
  801244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801248:	48 8b 40 08          	mov    0x8(%rax),%rax
  80124c:	48 39 c2             	cmp    %rax,%rdx
  80124f:	73 17                	jae    801268 <sprintputch+0x4b>
		*b->buf++ = ch;
  801251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801255:	48 8b 00             	mov    (%rax),%rax
  801258:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80125c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801260:	48 89 0a             	mov    %rcx,(%rdx)
  801263:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801266:	88 10                	mov    %dl,(%rax)
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 83 ec 50          	sub    $0x50,%rsp
  801272:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801276:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801279:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80127d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801281:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801285:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801289:	48 8b 0a             	mov    (%rdx),%rcx
  80128c:	48 89 08             	mov    %rcx,(%rax)
  80128f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801293:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801297:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80129b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80129f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012a3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8012a7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8012aa:	48 98                	cltq   
  8012ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012b4:	48 01 d0             	add    %rdx,%rax
  8012b7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8012bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8012c2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8012c7:	74 06                	je     8012cf <vsnprintf+0x65>
  8012c9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8012cd:	7f 07                	jg     8012d6 <vsnprintf+0x6c>
		return -E_INVAL;
  8012cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d4:	eb 2f                	jmp    801305 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012d6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012da:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012de:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012e2:	48 89 c6             	mov    %rax,%rsi
  8012e5:	48 bf 1d 12 80 00 00 	movabs $0x80121d,%rdi
  8012ec:	00 00 00 
  8012ef:	48 b8 52 0c 80 00 00 	movabs $0x800c52,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012ff:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801302:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801305:	c9                   	leaveq 
  801306:	c3                   	retq   

0000000000801307 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801312:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801319:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80131f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801326:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80132d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801334:	84 c0                	test   %al,%al
  801336:	74 20                	je     801358 <snprintf+0x51>
  801338:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80133c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801340:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801344:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801348:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80134c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801350:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801354:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801358:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80135f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801366:	00 00 00 
  801369:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801370:	00 00 00 
  801373:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801377:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80137e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801385:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80138c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801393:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80139a:	48 8b 0a             	mov    (%rdx),%rcx
  80139d:	48 89 08             	mov    %rcx,(%rax)
  8013a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8013b0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8013b7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8013be:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8013c4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8013cb:	48 89 c7             	mov    %rax,%rdi
  8013ce:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	callq  *%rax
  8013da:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013e0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013e6:	c9                   	leaveq 
  8013e7:	c3                   	retq   

00000000008013e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013e8:	55                   	push   %rbp
  8013e9:	48 89 e5             	mov    %rsp,%rbp
  8013ec:	48 83 ec 18          	sub    $0x18,%rsp
  8013f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013fb:	eb 09                	jmp    801406 <strlen+0x1e>
		n++;
  8013fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801401:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	84 c0                	test   %al,%al
  80140f:	75 ec                	jne    8013fd <strlen+0x15>
		n++;
	return n;
  801411:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801414:	c9                   	leaveq 
  801415:	c3                   	retq   

0000000000801416 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801416:	55                   	push   %rbp
  801417:	48 89 e5             	mov    %rsp,%rbp
  80141a:	48 83 ec 20          	sub    $0x20,%rsp
  80141e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801422:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80142d:	eb 0e                	jmp    80143d <strnlen+0x27>
		n++;
  80142f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801433:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801438:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80143d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801442:	74 0b                	je     80144f <strnlen+0x39>
  801444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	84 c0                	test   %al,%al
  80144d:	75 e0                	jne    80142f <strnlen+0x19>
		n++;
	return n;
  80144f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801452:	c9                   	leaveq 
  801453:	c3                   	retq   

0000000000801454 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801454:	55                   	push   %rbp
  801455:	48 89 e5             	mov    %rsp,%rbp
  801458:	48 83 ec 20          	sub    $0x20,%rsp
  80145c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801460:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80146c:	90                   	nop
  80146d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801471:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801475:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801479:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80147d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801481:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801485:	0f b6 12             	movzbl (%rdx),%edx
  801488:	88 10                	mov    %dl,(%rax)
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	84 c0                	test   %al,%al
  80148f:	75 dc                	jne    80146d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801495:	c9                   	leaveq 
  801496:	c3                   	retq   

0000000000801497 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801497:	55                   	push   %rbp
  801498:	48 89 e5             	mov    %rsp,%rbp
  80149b:	48 83 ec 20          	sub    $0x20,%rsp
  80149f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ab:	48 89 c7             	mov    %rax,%rdi
  8014ae:	48 b8 e8 13 80 00 00 	movabs $0x8013e8,%rax
  8014b5:	00 00 00 
  8014b8:	ff d0                	callq  *%rax
  8014ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c0:	48 63 d0             	movslq %eax,%rdx
  8014c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c7:	48 01 c2             	add    %rax,%rdx
  8014ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ce:	48 89 c6             	mov    %rax,%rsi
  8014d1:	48 89 d7             	mov    %rdx,%rdi
  8014d4:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  8014db:	00 00 00 
  8014de:	ff d0                	callq  *%rax
	return dst;
  8014e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801502:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801509:	00 
  80150a:	eb 2a                	jmp    801536 <strncpy+0x50>
		*dst++ = *src;
  80150c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801510:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801514:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801518:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80151c:	0f b6 12             	movzbl (%rdx),%edx
  80151f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	84 c0                	test   %al,%al
  80152a:	74 05                	je     801531 <strncpy+0x4b>
			src++;
  80152c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801531:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80153e:	72 cc                	jb     80150c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801544:	c9                   	leaveq 
  801545:	c3                   	retq   

0000000000801546 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801546:	55                   	push   %rbp
  801547:	48 89 e5             	mov    %rsp,%rbp
  80154a:	48 83 ec 28          	sub    $0x28,%rsp
  80154e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801552:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801556:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80155a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801562:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801567:	74 3d                	je     8015a6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801569:	eb 1d                	jmp    801588 <strlcpy+0x42>
			*dst++ = *src++;
  80156b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801573:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801577:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80157b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80157f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801583:	0f b6 12             	movzbl (%rdx),%edx
  801586:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801588:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80158d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801592:	74 0b                	je     80159f <strlcpy+0x59>
  801594:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	84 c0                	test   %al,%al
  80159d:	75 cc                	jne    80156b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	48 29 c2             	sub    %rax,%rdx
  8015b1:	48 89 d0             	mov    %rdx,%rax
}
  8015b4:	c9                   	leaveq 
  8015b5:	c3                   	retq   

00000000008015b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015b6:	55                   	push   %rbp
  8015b7:	48 89 e5             	mov    %rsp,%rbp
  8015ba:	48 83 ec 10          	sub    $0x10,%rsp
  8015be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015c6:	eb 0a                	jmp    8015d2 <strcmp+0x1c>
		p++, q++;
  8015c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015cd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	84 c0                	test   %al,%al
  8015db:	74 12                	je     8015ef <strcmp+0x39>
  8015dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e1:	0f b6 10             	movzbl (%rax),%edx
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	38 c2                	cmp    %al,%dl
  8015ed:	74 d9                	je     8015c8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f3:	0f b6 00             	movzbl (%rax),%eax
  8015f6:	0f b6 d0             	movzbl %al,%edx
  8015f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	0f b6 c0             	movzbl %al,%eax
  801603:	29 c2                	sub    %eax,%edx
  801605:	89 d0                	mov    %edx,%eax
}
  801607:	c9                   	leaveq 
  801608:	c3                   	retq   

0000000000801609 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 83 ec 18          	sub    $0x18,%rsp
  801611:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801615:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801619:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80161d:	eb 0f                	jmp    80162e <strncmp+0x25>
		n--, p++, q++;
  80161f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801624:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801629:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80162e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801633:	74 1d                	je     801652 <strncmp+0x49>
  801635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	84 c0                	test   %al,%al
  80163e:	74 12                	je     801652 <strncmp+0x49>
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	0f b6 10             	movzbl (%rax),%edx
  801647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	38 c2                	cmp    %al,%dl
  801650:	74 cd                	je     80161f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801652:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801657:	75 07                	jne    801660 <strncmp+0x57>
		return 0;
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
  80165e:	eb 18                	jmp    801678 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	0f b6 d0             	movzbl %al,%edx
  80166a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166e:	0f b6 00             	movzbl (%rax),%eax
  801671:	0f b6 c0             	movzbl %al,%eax
  801674:	29 c2                	sub    %eax,%edx
  801676:	89 d0                	mov    %edx,%eax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 0c          	sub    $0xc,%rsp
  801682:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801686:	89 f0                	mov    %esi,%eax
  801688:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80168b:	eb 17                	jmp    8016a4 <strchr+0x2a>
		if (*s == c)
  80168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801697:	75 06                	jne    80169f <strchr+0x25>
			return (char *) s;
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	eb 15                	jmp    8016b4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80169f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	0f b6 00             	movzbl (%rax),%eax
  8016ab:	84 c0                	test   %al,%al
  8016ad:	75 de                	jne    80168d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b4:	c9                   	leaveq 
  8016b5:	c3                   	retq   

00000000008016b6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016b6:	55                   	push   %rbp
  8016b7:	48 89 e5             	mov    %rsp,%rbp
  8016ba:	48 83 ec 0c          	sub    $0xc,%rsp
  8016be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c2:	89 f0                	mov    %esi,%eax
  8016c4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016c7:	eb 13                	jmp    8016dc <strfind+0x26>
		if (*s == c)
  8016c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016d3:	75 02                	jne    8016d7 <strfind+0x21>
			break;
  8016d5:	eb 10                	jmp    8016e7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e0:	0f b6 00             	movzbl (%rax),%eax
  8016e3:	84 c0                	test   %al,%al
  8016e5:	75 e2                	jne    8016c9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016eb:	c9                   	leaveq 
  8016ec:	c3                   	retq   

00000000008016ed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 18          	sub    $0x18,%rsp
  8016f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801700:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801705:	75 06                	jne    80170d <memset+0x20>
		return v;
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170b:	eb 69                	jmp    801776 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80170d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801711:	83 e0 03             	and    $0x3,%eax
  801714:	48 85 c0             	test   %rax,%rax
  801717:	75 48                	jne    801761 <memset+0x74>
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171d:	83 e0 03             	and    $0x3,%eax
  801720:	48 85 c0             	test   %rax,%rax
  801723:	75 3c                	jne    801761 <memset+0x74>
		c &= 0xFF;
  801725:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80172c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80172f:	c1 e0 18             	shl    $0x18,%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801737:	c1 e0 10             	shl    $0x10,%eax
  80173a:	09 c2                	or     %eax,%edx
  80173c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80173f:	c1 e0 08             	shl    $0x8,%eax
  801742:	09 d0                	or     %edx,%eax
  801744:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174b:	48 c1 e8 02          	shr    $0x2,%rax
  80174f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801752:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801756:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801759:	48 89 d7             	mov    %rdx,%rdi
  80175c:	fc                   	cld    
  80175d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80175f:	eb 11                	jmp    801772 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801761:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801765:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801768:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80176c:	48 89 d7             	mov    %rdx,%rdi
  80176f:	fc                   	cld    
  801770:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801776:	c9                   	leaveq 
  801777:	c3                   	retq   

0000000000801778 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801778:	55                   	push   %rbp
  801779:	48 89 e5             	mov    %rsp,%rbp
  80177c:	48 83 ec 28          	sub    $0x28,%rsp
  801780:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801784:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801788:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80178c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801790:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801798:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80179c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017a4:	0f 83 88 00 00 00    	jae    801832 <memmove+0xba>
  8017aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b2:	48 01 d0             	add    %rdx,%rax
  8017b5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017b9:	76 77                	jbe    801832 <memmove+0xba>
		s += n;
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017cf:	83 e0 03             	and    $0x3,%eax
  8017d2:	48 85 c0             	test   %rax,%rax
  8017d5:	75 3b                	jne    801812 <memmove+0x9a>
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017db:	83 e0 03             	and    $0x3,%eax
  8017de:	48 85 c0             	test   %rax,%rax
  8017e1:	75 2f                	jne    801812 <memmove+0x9a>
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	83 e0 03             	and    $0x3,%eax
  8017ea:	48 85 c0             	test   %rax,%rax
  8017ed:	75 23                	jne    801812 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f3:	48 83 e8 04          	sub    $0x4,%rax
  8017f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017fb:	48 83 ea 04          	sub    $0x4,%rdx
  8017ff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801803:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801807:	48 89 c7             	mov    %rax,%rdi
  80180a:	48 89 d6             	mov    %rdx,%rsi
  80180d:	fd                   	std    
  80180e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801810:	eb 1d                	jmp    80182f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801816:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80181a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	48 89 d7             	mov    %rdx,%rdi
  801829:	48 89 c1             	mov    %rax,%rcx
  80182c:	fd                   	std    
  80182d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80182f:	fc                   	cld    
  801830:	eb 57                	jmp    801889 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801836:	83 e0 03             	and    $0x3,%eax
  801839:	48 85 c0             	test   %rax,%rax
  80183c:	75 36                	jne    801874 <memmove+0xfc>
  80183e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801842:	83 e0 03             	and    $0x3,%eax
  801845:	48 85 c0             	test   %rax,%rax
  801848:	75 2a                	jne    801874 <memmove+0xfc>
  80184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184e:	83 e0 03             	and    $0x3,%eax
  801851:	48 85 c0             	test   %rax,%rax
  801854:	75 1e                	jne    801874 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	48 c1 e8 02          	shr    $0x2,%rax
  80185e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801865:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 89 d6             	mov    %rdx,%rsi
  80186f:	fc                   	cld    
  801870:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801872:	eb 15                	jmp    801889 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801878:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80187c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801880:	48 89 c7             	mov    %rax,%rdi
  801883:	48 89 d6             	mov    %rdx,%rsi
  801886:	fc                   	cld    
  801887:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80188d:	c9                   	leaveq 
  80188e:	c3                   	retq   

000000000080188f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
  801893:	48 83 ec 18          	sub    $0x18,%rsp
  801897:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80189b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80189f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018af:	48 89 ce             	mov    %rcx,%rsi
  8018b2:	48 89 c7             	mov    %rax,%rdi
  8018b5:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	callq  *%rax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 28          	sub    $0x28,%rsp
  8018cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018e7:	eb 36                	jmp    80191f <memcmp+0x5c>
		if (*s1 != *s2)
  8018e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ed:	0f b6 10             	movzbl (%rax),%edx
  8018f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f4:	0f b6 00             	movzbl (%rax),%eax
  8018f7:	38 c2                	cmp    %al,%dl
  8018f9:	74 1a                	je     801915 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	0f b6 d0             	movzbl %al,%edx
  801905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	0f b6 c0             	movzbl %al,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	eb 20                	jmp    801935 <memcmp+0x72>
		s1++, s2++;
  801915:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80191a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801927:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80192b:	48 85 c0             	test   %rax,%rax
  80192e:	75 b9                	jne    8018e9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
  80193b:	48 83 ec 28          	sub    $0x28,%rsp
  80193f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801943:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801946:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80194a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801952:	48 01 d0             	add    %rdx,%rax
  801955:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801959:	eb 15                	jmp    801970 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80195b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80195f:	0f b6 10             	movzbl (%rax),%edx
  801962:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801965:	38 c2                	cmp    %al,%dl
  801967:	75 02                	jne    80196b <memfind+0x34>
			break;
  801969:	eb 0f                	jmp    80197a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80196b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801974:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801978:	72 e1                	jb     80195b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80197a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	48 83 ec 34          	sub    $0x34,%rsp
  801988:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80198c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801990:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801993:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80199a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019a1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a2:	eb 05                	jmp    8019a9 <strtol+0x29>
		s++;
  8019a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ad:	0f b6 00             	movzbl (%rax),%eax
  8019b0:	3c 20                	cmp    $0x20,%al
  8019b2:	74 f0                	je     8019a4 <strtol+0x24>
  8019b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b8:	0f b6 00             	movzbl (%rax),%eax
  8019bb:	3c 09                	cmp    $0x9,%al
  8019bd:	74 e5                	je     8019a4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	3c 2b                	cmp    $0x2b,%al
  8019c8:	75 07                	jne    8019d1 <strtol+0x51>
		s++;
  8019ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019cf:	eb 17                	jmp    8019e8 <strtol+0x68>
	else if (*s == '-')
  8019d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d5:	0f b6 00             	movzbl (%rax),%eax
  8019d8:	3c 2d                	cmp    $0x2d,%al
  8019da:	75 0c                	jne    8019e8 <strtol+0x68>
		s++, neg = 1;
  8019dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ec:	74 06                	je     8019f4 <strtol+0x74>
  8019ee:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019f2:	75 28                	jne    801a1c <strtol+0x9c>
  8019f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f8:	0f b6 00             	movzbl (%rax),%eax
  8019fb:	3c 30                	cmp    $0x30,%al
  8019fd:	75 1d                	jne    801a1c <strtol+0x9c>
  8019ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a03:	48 83 c0 01          	add    $0x1,%rax
  801a07:	0f b6 00             	movzbl (%rax),%eax
  801a0a:	3c 78                	cmp    $0x78,%al
  801a0c:	75 0e                	jne    801a1c <strtol+0x9c>
		s += 2, base = 16;
  801a0e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a13:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a1a:	eb 2c                	jmp    801a48 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a1c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a20:	75 19                	jne    801a3b <strtol+0xbb>
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	3c 30                	cmp    $0x30,%al
  801a2b:	75 0e                	jne    801a3b <strtol+0xbb>
		s++, base = 8;
  801a2d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a32:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a39:	eb 0d                	jmp    801a48 <strtol+0xc8>
	else if (base == 0)
  801a3b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a3f:	75 07                	jne    801a48 <strtol+0xc8>
		base = 10;
  801a41:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	3c 2f                	cmp    $0x2f,%al
  801a51:	7e 1d                	jle    801a70 <strtol+0xf0>
  801a53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a57:	0f b6 00             	movzbl (%rax),%eax
  801a5a:	3c 39                	cmp    $0x39,%al
  801a5c:	7f 12                	jg     801a70 <strtol+0xf0>
			dig = *s - '0';
  801a5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a62:	0f b6 00             	movzbl (%rax),%eax
  801a65:	0f be c0             	movsbl %al,%eax
  801a68:	83 e8 30             	sub    $0x30,%eax
  801a6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a6e:	eb 4e                	jmp    801abe <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a74:	0f b6 00             	movzbl (%rax),%eax
  801a77:	3c 60                	cmp    $0x60,%al
  801a79:	7e 1d                	jle    801a98 <strtol+0x118>
  801a7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7f:	0f b6 00             	movzbl (%rax),%eax
  801a82:	3c 7a                	cmp    $0x7a,%al
  801a84:	7f 12                	jg     801a98 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8a:	0f b6 00             	movzbl (%rax),%eax
  801a8d:	0f be c0             	movsbl %al,%eax
  801a90:	83 e8 57             	sub    $0x57,%eax
  801a93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a96:	eb 26                	jmp    801abe <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9c:	0f b6 00             	movzbl (%rax),%eax
  801a9f:	3c 40                	cmp    $0x40,%al
  801aa1:	7e 48                	jle    801aeb <strtol+0x16b>
  801aa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa7:	0f b6 00             	movzbl (%rax),%eax
  801aaa:	3c 5a                	cmp    $0x5a,%al
  801aac:	7f 3d                	jg     801aeb <strtol+0x16b>
			dig = *s - 'A' + 10;
  801aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab2:	0f b6 00             	movzbl (%rax),%eax
  801ab5:	0f be c0             	movsbl %al,%eax
  801ab8:	83 e8 37             	sub    $0x37,%eax
  801abb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801abe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ac4:	7c 02                	jl     801ac8 <strtol+0x148>
			break;
  801ac6:	eb 23                	jmp    801aeb <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ac8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801acd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ad0:	48 98                	cltq   
  801ad2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ad7:	48 89 c2             	mov    %rax,%rdx
  801ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 01 d0             	add    %rdx,%rax
  801ae2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ae6:	e9 5d ff ff ff       	jmpq   801a48 <strtol+0xc8>

	if (endptr)
  801aeb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801af0:	74 0b                	je     801afd <strtol+0x17d>
		*endptr = (char *) s;
  801af2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801af6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801afa:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801afd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b01:	74 09                	je     801b0c <strtol+0x18c>
  801b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b07:	48 f7 d8             	neg    %rax
  801b0a:	eb 04                	jmp    801b10 <strtol+0x190>
  801b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b10:	c9                   	leaveq 
  801b11:	c3                   	retq   

0000000000801b12 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b12:	55                   	push   %rbp
  801b13:	48 89 e5             	mov    %rsp,%rbp
  801b16:	48 83 ec 30          	sub    $0x30,%rsp
  801b1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b1e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b2a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b2e:	0f b6 00             	movzbl (%rax),%eax
  801b31:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b34:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b38:	75 06                	jne    801b40 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b3e:	eb 6b                	jmp    801bab <strstr+0x99>

	len = strlen(str);
  801b40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b44:	48 89 c7             	mov    %rax,%rdi
  801b47:	48 b8 e8 13 80 00 00 	movabs $0x8013e8,%rax
  801b4e:	00 00 00 
  801b51:	ff d0                	callq  *%rax
  801b53:	48 98                	cltq   
  801b55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b65:	0f b6 00             	movzbl (%rax),%eax
  801b68:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b6b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b6f:	75 07                	jne    801b78 <strstr+0x66>
				return (char *) 0;
  801b71:	b8 00 00 00 00       	mov    $0x0,%eax
  801b76:	eb 33                	jmp    801bab <strstr+0x99>
		} while (sc != c);
  801b78:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b7c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b7f:	75 d8                	jne    801b59 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b85:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8d:	48 89 ce             	mov    %rcx,%rsi
  801b90:	48 89 c7             	mov    %rax,%rdi
  801b93:	48 b8 09 16 80 00 00 	movabs $0x801609,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	75 b6                	jne    801b59 <strstr+0x47>

	return (char *) (in - 1);
  801ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba7:	48 83 e8 01          	sub    $0x1,%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	53                   	push   %rbx
  801bb2:	48 83 ec 48          	sub    $0x48,%rsp
  801bb6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bb9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bbc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bc0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bc4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bc8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bcc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bcf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bd3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bd7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801bdb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bdf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801be3:	4c 89 c3             	mov    %r8,%rbx
  801be6:	cd 30                	int    $0x30
  801be8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bec:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bf0:	74 3e                	je     801c30 <syscall+0x83>
  801bf2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bf7:	7e 37                	jle    801c30 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bfd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c00:	49 89 d0             	mov    %rdx,%r8
  801c03:	89 c1                	mov    %eax,%ecx
  801c05:	48 ba c8 44 80 00 00 	movabs $0x8044c8,%rdx
  801c0c:	00 00 00 
  801c0f:	be 23 00 00 00       	mov    $0x23,%esi
  801c14:	48 bf e5 44 80 00 00 	movabs $0x8044e5,%rdi
  801c1b:	00 00 00 
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	49 b9 b3 3a 80 00 00 	movabs $0x803ab3,%r9
  801c2a:	00 00 00 
  801c2d:	41 ff d1             	callq  *%r9

	return ret;
  801c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c34:	48 83 c4 48          	add    $0x48,%rsp
  801c38:	5b                   	pop    %rbx
  801c39:	5d                   	pop    %rbp
  801c3a:	c3                   	retq   

0000000000801c3b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c3b:	55                   	push   %rbp
  801c3c:	48 89 e5             	mov    %rsp,%rbp
  801c3f:	48 83 ec 20          	sub    $0x20,%rsp
  801c43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5a:	00 
  801c5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c67:	48 89 d1             	mov    %rdx,%rcx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 00 00 00 00       	mov    $0x0,%esi
  801c72:	bf 00 00 00 00       	mov    $0x0,%edi
  801c77:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
}
  801c83:	c9                   	leaveq 
  801c84:	c3                   	retq   

0000000000801c85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c94:	00 
  801c95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	be 00 00 00 00       	mov    $0x0,%esi
  801cb0:	bf 01 00 00 00       	mov    $0x1,%edi
  801cb5:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	callq  *%rax
}
  801cc1:	c9                   	leaveq 
  801cc2:	c3                   	retq   

0000000000801cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	48 83 ec 10          	sub    $0x10,%rsp
  801ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd1:	48 98                	cltq   
  801cd3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cda:	00 
  801cdb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cec:	48 89 c2             	mov    %rax,%rdx
  801cef:	be 01 00 00 00       	mov    $0x1,%esi
  801cf4:	bf 03 00 00 00       	mov    $0x3,%edi
  801cf9:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	callq  *%rax
}
  801d05:	c9                   	leaveq 
  801d06:	c3                   	retq   

0000000000801d07 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d07:	55                   	push   %rbp
  801d08:	48 89 e5             	mov    %rsp,%rbp
  801d0b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d16:	00 
  801d17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d28:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2d:	be 00 00 00 00       	mov    $0x0,%esi
  801d32:	bf 02 00 00 00       	mov    $0x2,%edi
  801d37:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801d3e:	00 00 00 
  801d41:	ff d0                	callq  *%rax
}
  801d43:	c9                   	leaveq 
  801d44:	c3                   	retq   

0000000000801d45 <sys_yield>:

void
sys_yield(void)
{
  801d45:	55                   	push   %rbp
  801d46:	48 89 e5             	mov    %rsp,%rbp
  801d49:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d54:	00 
  801d55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d66:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6b:	be 00 00 00 00       	mov    $0x0,%esi
  801d70:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d75:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	callq  *%rax
}
  801d81:	c9                   	leaveq 
  801d82:	c3                   	retq   

0000000000801d83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	48 83 ec 20          	sub    $0x20,%rsp
  801d8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d92:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d98:	48 63 c8             	movslq %eax,%rcx
  801d9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dab:	00 
  801dac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db2:	49 89 c8             	mov    %rcx,%r8
  801db5:	48 89 d1             	mov    %rdx,%rcx
  801db8:	48 89 c2             	mov    %rax,%rdx
  801dbb:	be 01 00 00 00       	mov    $0x1,%esi
  801dc0:	bf 04 00 00 00       	mov    $0x4,%edi
  801dc5:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	callq  *%rax
}
  801dd1:	c9                   	leaveq 
  801dd2:	c3                   	retq   

0000000000801dd3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801dd3:	55                   	push   %rbp
  801dd4:	48 89 e5             	mov    %rsp,%rbp
  801dd7:	48 83 ec 30          	sub    $0x30,%rsp
  801ddb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801de2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801de5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801de9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ded:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801df0:	48 63 c8             	movslq %eax,%rcx
  801df3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801df7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dfa:	48 63 f0             	movslq %eax,%rsi
  801dfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e04:	48 98                	cltq   
  801e06:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e0a:	49 89 f9             	mov    %rdi,%r9
  801e0d:	49 89 f0             	mov    %rsi,%r8
  801e10:	48 89 d1             	mov    %rdx,%rcx
  801e13:	48 89 c2             	mov    %rax,%rdx
  801e16:	be 01 00 00 00       	mov    $0x1,%esi
  801e1b:	bf 05 00 00 00       	mov    $0x5,%edi
  801e20:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	callq  *%rax
}
  801e2c:	c9                   	leaveq 
  801e2d:	c3                   	retq   

0000000000801e2e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e2e:	55                   	push   %rbp
  801e2f:	48 89 e5             	mov    %rsp,%rbp
  801e32:	48 83 ec 20          	sub    $0x20,%rsp
  801e36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e44:	48 98                	cltq   
  801e46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4d:	00 
  801e4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5a:	48 89 d1             	mov    %rdx,%rcx
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	be 01 00 00 00       	mov    $0x1,%esi
  801e65:	bf 06 00 00 00       	mov    $0x6,%edi
  801e6a:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	48 83 ec 10          	sub    $0x10,%rsp
  801e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e83:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e89:	48 63 d0             	movslq %eax,%rdx
  801e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8f:	48 98                	cltq   
  801e91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e98:	00 
  801e99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea5:	48 89 d1             	mov    %rdx,%rcx
  801ea8:	48 89 c2             	mov    %rax,%rdx
  801eab:	be 01 00 00 00       	mov    $0x1,%esi
  801eb0:	bf 08 00 00 00       	mov    $0x8,%edi
  801eb5:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
}
  801ec1:	c9                   	leaveq 
  801ec2:	c3                   	retq   

0000000000801ec3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ec3:	55                   	push   %rbp
  801ec4:	48 89 e5             	mov    %rsp,%rbp
  801ec7:	48 83 ec 20          	sub    $0x20,%rsp
  801ecb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ece:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ed2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed9:	48 98                	cltq   
  801edb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee2:	00 
  801ee3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eef:	48 89 d1             	mov    %rdx,%rcx
  801ef2:	48 89 c2             	mov    %rax,%rdx
  801ef5:	be 01 00 00 00       	mov    $0x1,%esi
  801efa:	bf 09 00 00 00       	mov    $0x9,%edi
  801eff:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
}
  801f0b:	c9                   	leaveq 
  801f0c:	c3                   	retq   

0000000000801f0d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
  801f11:	48 83 ec 20          	sub    $0x20,%rsp
  801f15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f23:	48 98                	cltq   
  801f25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2c:	00 
  801f2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f39:	48 89 d1             	mov    %rdx,%rcx
  801f3c:	48 89 c2             	mov    %rax,%rdx
  801f3f:	be 01 00 00 00       	mov    $0x1,%esi
  801f44:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f49:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
}
  801f55:	c9                   	leaveq 
  801f56:	c3                   	retq   

0000000000801f57 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f57:	55                   	push   %rbp
  801f58:	48 89 e5             	mov    %rsp,%rbp
  801f5b:	48 83 ec 20          	sub    $0x20,%rsp
  801f5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f6a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f70:	48 63 f0             	movslq %eax,%rsi
  801f73:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7a:	48 98                	cltq   
  801f7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f87:	00 
  801f88:	49 89 f1             	mov    %rsi,%r9
  801f8b:	49 89 c8             	mov    %rcx,%r8
  801f8e:	48 89 d1             	mov    %rdx,%rcx
  801f91:	48 89 c2             	mov    %rax,%rdx
  801f94:	be 00 00 00 00       	mov    $0x0,%esi
  801f99:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f9e:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
}
  801faa:	c9                   	leaveq 
  801fab:	c3                   	retq   

0000000000801fac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fac:	55                   	push   %rbp
  801fad:	48 89 e5             	mov    %rsp,%rbp
  801fb0:	48 83 ec 10          	sub    $0x10,%rsp
  801fb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fc3:	00 
  801fc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd5:	48 89 c2             	mov    %rax,%rdx
  801fd8:	be 01 00 00 00       	mov    $0x1,%esi
  801fdd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fe2:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ff8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fff:	00 
  802000:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802006:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80200c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802011:	ba 00 00 00 00       	mov    $0x0,%edx
  802016:	be 00 00 00 00       	mov    $0x0,%esi
  80201b:	bf 0e 00 00 00       	mov    $0xe,%edi
  802020:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  802027:	00 00 00 
  80202a:	ff d0                	callq  *%rax
}
  80202c:	c9                   	leaveq 
  80202d:	c3                   	retq   

000000000080202e <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
  802032:	48 83 ec 30          	sub    $0x30,%rsp
  802036:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802039:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80203d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802040:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802044:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802048:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80204b:	48 63 c8             	movslq %eax,%rcx
  80204e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802052:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802055:	48 63 f0             	movslq %eax,%rsi
  802058:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80205c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205f:	48 98                	cltq   
  802061:	48 89 0c 24          	mov    %rcx,(%rsp)
  802065:	49 89 f9             	mov    %rdi,%r9
  802068:	49 89 f0             	mov    %rsi,%r8
  80206b:	48 89 d1             	mov    %rdx,%rcx
  80206e:	48 89 c2             	mov    %rax,%rdx
  802071:	be 00 00 00 00       	mov    $0x0,%esi
  802076:	bf 0f 00 00 00       	mov    $0xf,%edi
  80207b:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802087:	c9                   	leaveq 
  802088:	c3                   	retq   

0000000000802089 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802089:	55                   	push   %rbp
  80208a:	48 89 e5             	mov    %rsp,%rbp
  80208d:	48 83 ec 20          	sub    $0x20,%rsp
  802091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802095:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802099:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80209d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020a8:	00 
  8020a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020b5:	48 89 d1             	mov    %rdx,%rcx
  8020b8:	48 89 c2             	mov    %rax,%rdx
  8020bb:	be 00 00 00 00       	mov    $0x0,%esi
  8020c0:	bf 10 00 00 00       	mov    $0x10,%edi
  8020c5:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  8020cc:	00 00 00 
  8020cf:	ff d0                	callq  *%rax
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
  8020d7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8020db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e2:	00 
  8020e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f9:	be 00 00 00 00       	mov    $0x0,%esi
  8020fe:	bf 11 00 00 00       	mov    $0x11,%edi
  802103:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  80210f:	c9                   	leaveq 
  802110:	c3                   	retq   

0000000000802111 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	48 83 ec 10          	sub    $0x10,%rsp
  802119:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  80211c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211f:	48 98                	cltq   
  802121:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802128:	00 
  802129:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80212f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802135:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	be 00 00 00 00       	mov    $0x0,%esi
  802142:	bf 12 00 00 00       	mov    $0x12,%edi
  802147:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  80214e:	00 00 00 
  802151:	ff d0                	callq  *%rax
}
  802153:	c9                   	leaveq 
  802154:	c3                   	retq   

0000000000802155 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802155:	55                   	push   %rbp
  802156:	48 89 e5             	mov    %rsp,%rbp
  802159:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80215d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802164:	00 
  802165:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80216b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802171:	b9 00 00 00 00       	mov    $0x0,%ecx
  802176:	ba 00 00 00 00       	mov    $0x0,%edx
  80217b:	be 00 00 00 00       	mov    $0x0,%esi
  802180:	bf 13 00 00 00       	mov    $0x13,%edi
  802185:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	callq  *%rax
}
  802191:	c9                   	leaveq 
  802192:	c3                   	retq   

0000000000802193 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802193:	55                   	push   %rbp
  802194:	48 89 e5             	mov    %rsp,%rbp
  802197:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80219b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021a2:	00 
  8021a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b9:	be 00 00 00 00       	mov    $0x0,%esi
  8021be:	bf 14 00 00 00       	mov    $0x14,%edi
  8021c3:	48 b8 ad 1b 80 00 00 	movabs $0x801bad,%rax
  8021ca:	00 00 00 
  8021cd:	ff d0                	callq  *%rax
}
  8021cf:	c9                   	leaveq 
  8021d0:	c3                   	retq   

00000000008021d1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021d1:	55                   	push   %rbp
  8021d2:	48 89 e5             	mov    %rsp,%rbp
  8021d5:	48 83 ec 08          	sub    $0x8,%rsp
  8021d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021e1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021e8:	ff ff ff 
  8021eb:	48 01 d0             	add    %rdx,%rax
  8021ee:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021f2:	c9                   	leaveq 
  8021f3:	c3                   	retq   

00000000008021f4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021f4:	55                   	push   %rbp
  8021f5:	48 89 e5             	mov    %rsp,%rbp
  8021f8:	48 83 ec 08          	sub    $0x8,%rsp
  8021fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802204:	48 89 c7             	mov    %rax,%rdi
  802207:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  80220e:	00 00 00 
  802211:	ff d0                	callq  *%rax
  802213:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802219:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80221d:	c9                   	leaveq 
  80221e:	c3                   	retq   

000000000080221f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80221f:	55                   	push   %rbp
  802220:	48 89 e5             	mov    %rsp,%rbp
  802223:	48 83 ec 18          	sub    $0x18,%rsp
  802227:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80222b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802232:	eb 6b                	jmp    80229f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802237:	48 98                	cltq   
  802239:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223f:	48 c1 e0 0c          	shl    $0xc,%rax
  802243:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224b:	48 c1 e8 15          	shr    $0x15,%rax
  80224f:	48 89 c2             	mov    %rax,%rdx
  802252:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802259:	01 00 00 
  80225c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802260:	83 e0 01             	and    $0x1,%eax
  802263:	48 85 c0             	test   %rax,%rax
  802266:	74 21                	je     802289 <fd_alloc+0x6a>
  802268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226c:	48 c1 e8 0c          	shr    $0xc,%rax
  802270:	48 89 c2             	mov    %rax,%rdx
  802273:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227a:	01 00 00 
  80227d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802281:	83 e0 01             	and    $0x1,%eax
  802284:	48 85 c0             	test   %rax,%rax
  802287:	75 12                	jne    80229b <fd_alloc+0x7c>
			*fd_store = fd;
  802289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802291:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	eb 1a                	jmp    8022b5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80229b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80229f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022a3:	7e 8f                	jle    802234 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022b0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022b5:	c9                   	leaveq 
  8022b6:	c3                   	retq   

00000000008022b7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022b7:	55                   	push   %rbp
  8022b8:	48 89 e5             	mov    %rsp,%rbp
  8022bb:	48 83 ec 20          	sub    $0x20,%rsp
  8022bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022ca:	78 06                	js     8022d2 <fd_lookup+0x1b>
  8022cc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022d0:	7e 07                	jle    8022d9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d7:	eb 6c                	jmp    802345 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022dc:	48 98                	cltq   
  8022de:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022e4:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f0:	48 c1 e8 15          	shr    $0x15,%rax
  8022f4:	48 89 c2             	mov    %rax,%rdx
  8022f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022fe:	01 00 00 
  802301:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802305:	83 e0 01             	and    $0x1,%eax
  802308:	48 85 c0             	test   %rax,%rax
  80230b:	74 21                	je     80232e <fd_lookup+0x77>
  80230d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802311:	48 c1 e8 0c          	shr    $0xc,%rax
  802315:	48 89 c2             	mov    %rax,%rdx
  802318:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80231f:	01 00 00 
  802322:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802326:	83 e0 01             	and    $0x1,%eax
  802329:	48 85 c0             	test   %rax,%rax
  80232c:	75 07                	jne    802335 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80232e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802333:	eb 10                	jmp    802345 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802335:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802339:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80233d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802345:	c9                   	leaveq 
  802346:	c3                   	retq   

0000000000802347 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
  80234b:	48 83 ec 30          	sub    $0x30,%rsp
  80234f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802353:	89 f0                	mov    %esi,%eax
  802355:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235c:	48 89 c7             	mov    %rax,%rdi
  80235f:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax
  80236b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80236f:	48 89 d6             	mov    %rdx,%rsi
  802372:	89 c7                	mov    %eax,%edi
  802374:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  80237b:	00 00 00 
  80237e:	ff d0                	callq  *%rax
  802380:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802387:	78 0a                	js     802393 <fd_close+0x4c>
	    || fd != fd2)
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802391:	74 12                	je     8023a5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802393:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802397:	74 05                	je     80239e <fd_close+0x57>
  802399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239c:	eb 05                	jmp    8023a3 <fd_close+0x5c>
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a3:	eb 69                	jmp    80240e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a9:	8b 00                	mov    (%rax),%eax
  8023ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023af:	48 89 d6             	mov    %rdx,%rsi
  8023b2:	89 c7                	mov    %eax,%edi
  8023b4:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	callq  *%rax
  8023c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c7:	78 2a                	js     8023f3 <fd_close+0xac>
		if (dev->dev_close)
  8023c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023d1:	48 85 c0             	test   %rax,%rax
  8023d4:	74 16                	je     8023ec <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023e2:	48 89 d7             	mov    %rdx,%rdi
  8023e5:	ff d0                	callq  *%rax
  8023e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ea:	eb 07                	jmp    8023f3 <fd_close+0xac>
		else
			r = 0;
  8023ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f7:	48 89 c6             	mov    %rax,%rsi
  8023fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ff:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
	return r;
  80240b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80240e:	c9                   	leaveq 
  80240f:	c3                   	retq   

0000000000802410 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802410:	55                   	push   %rbp
  802411:	48 89 e5             	mov    %rsp,%rbp
  802414:	48 83 ec 20          	sub    $0x20,%rsp
  802418:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80241b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80241f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802426:	eb 41                	jmp    802469 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802428:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80242f:	00 00 00 
  802432:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802435:	48 63 d2             	movslq %edx,%rdx
  802438:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243c:	8b 00                	mov    (%rax),%eax
  80243e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802441:	75 22                	jne    802465 <dev_lookup+0x55>
			*dev = devtab[i];
  802443:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80244a:	00 00 00 
  80244d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802450:	48 63 d2             	movslq %edx,%rdx
  802453:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802457:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80245b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	eb 60                	jmp    8024c5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802465:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802469:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802470:	00 00 00 
  802473:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802476:	48 63 d2             	movslq %edx,%rdx
  802479:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247d:	48 85 c0             	test   %rax,%rax
  802480:	75 a6                	jne    802428 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802482:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802489:	00 00 00 
  80248c:	48 8b 00             	mov    (%rax),%rax
  80248f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802495:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802498:	89 c6                	mov    %eax,%esi
  80249a:	48 bf f8 44 80 00 00 	movabs $0x8044f8,%rdi
  8024a1:	00 00 00 
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	48 b9 9f 08 80 00 00 	movabs $0x80089f,%rcx
  8024b0:	00 00 00 
  8024b3:	ff d1                	callq  *%rcx
	*dev = 0;
  8024b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024c5:	c9                   	leaveq 
  8024c6:	c3                   	retq   

00000000008024c7 <close>:

int
close(int fdnum)
{
  8024c7:	55                   	push   %rbp
  8024c8:	48 89 e5             	mov    %rsp,%rbp
  8024cb:	48 83 ec 20          	sub    $0x20,%rsp
  8024cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d9:	48 89 d6             	mov    %rdx,%rsi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f1:	79 05                	jns    8024f8 <close+0x31>
		return r;
  8024f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f6:	eb 18                	jmp    802510 <close+0x49>
	else
		return fd_close(fd, 1);
  8024f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fc:	be 01 00 00 00       	mov    $0x1,%esi
  802501:	48 89 c7             	mov    %rax,%rdi
  802504:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
}
  802510:	c9                   	leaveq 
  802511:	c3                   	retq   

0000000000802512 <close_all>:

void
close_all(void)
{
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80251a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802521:	eb 15                	jmp    802538 <close_all+0x26>
		close(i);
  802523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802526:	89 c7                	mov    %eax,%edi
  802528:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80252f:	00 00 00 
  802532:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802534:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802538:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80253c:	7e e5                	jle    802523 <close_all+0x11>
		close(i);
}
  80253e:	c9                   	leaveq 
  80253f:	c3                   	retq   

0000000000802540 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802540:	55                   	push   %rbp
  802541:	48 89 e5             	mov    %rsp,%rbp
  802544:	48 83 ec 40          	sub    $0x40,%rsp
  802548:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80254b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80254e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802552:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802555:	48 89 d6             	mov    %rdx,%rsi
  802558:	89 c7                	mov    %eax,%edi
  80255a:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax
  802566:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256d:	79 08                	jns    802577 <dup+0x37>
		return r;
  80256f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802572:	e9 70 01 00 00       	jmpq   8026e7 <dup+0x1a7>
	close(newfdnum);
  802577:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80257a:	89 c7                	mov    %eax,%edi
  80257c:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802588:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80258b:	48 98                	cltq   
  80258d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802593:	48 c1 e0 0c          	shl    $0xc,%rax
  802597:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80259b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80259f:	48 89 c7             	mov    %rax,%rdi
  8025a2:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8025a9:	00 00 00 
  8025ac:	ff d0                	callq  *%rax
  8025ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b6:	48 89 c7             	mov    %rax,%rdi
  8025b9:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
  8025c5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cd:	48 c1 e8 15          	shr    $0x15,%rax
  8025d1:	48 89 c2             	mov    %rax,%rdx
  8025d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025db:	01 00 00 
  8025de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e2:	83 e0 01             	and    $0x1,%eax
  8025e5:	48 85 c0             	test   %rax,%rax
  8025e8:	74 73                	je     80265d <dup+0x11d>
  8025ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8025f2:	48 89 c2             	mov    %rax,%rdx
  8025f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025fc:	01 00 00 
  8025ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802603:	83 e0 01             	and    $0x1,%eax
  802606:	48 85 c0             	test   %rax,%rax
  802609:	74 52                	je     80265d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80260b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260f:	48 c1 e8 0c          	shr    $0xc,%rax
  802613:	48 89 c2             	mov    %rax,%rdx
  802616:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261d:	01 00 00 
  802620:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802624:	25 07 0e 00 00       	and    $0xe07,%eax
  802629:	89 c1                	mov    %eax,%ecx
  80262b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80262f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802633:	41 89 c8             	mov    %ecx,%r8d
  802636:	48 89 d1             	mov    %rdx,%rcx
  802639:	ba 00 00 00 00       	mov    $0x0,%edx
  80263e:	48 89 c6             	mov    %rax,%rsi
  802641:	bf 00 00 00 00       	mov    $0x0,%edi
  802646:	48 b8 d3 1d 80 00 00 	movabs $0x801dd3,%rax
  80264d:	00 00 00 
  802650:	ff d0                	callq  *%rax
  802652:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802655:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802659:	79 02                	jns    80265d <dup+0x11d>
			goto err;
  80265b:	eb 57                	jmp    8026b4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80265d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802661:	48 c1 e8 0c          	shr    $0xc,%rax
  802665:	48 89 c2             	mov    %rax,%rdx
  802668:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80266f:	01 00 00 
  802672:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802676:	25 07 0e 00 00       	and    $0xe07,%eax
  80267b:	89 c1                	mov    %eax,%ecx
  80267d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802681:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802685:	41 89 c8             	mov    %ecx,%r8d
  802688:	48 89 d1             	mov    %rdx,%rcx
  80268b:	ba 00 00 00 00       	mov    $0x0,%edx
  802690:	48 89 c6             	mov    %rax,%rsi
  802693:	bf 00 00 00 00       	mov    $0x0,%edi
  802698:	48 b8 d3 1d 80 00 00 	movabs $0x801dd3,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
  8026a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ab:	79 02                	jns    8026af <dup+0x16f>
		goto err;
  8026ad:	eb 05                	jmp    8026b4 <dup+0x174>

	return newfdnum;
  8026af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026b2:	eb 33                	jmp    8026e7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b8:	48 89 c6             	mov    %rax,%rsi
  8026bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c0:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	48 89 c6             	mov    %rax,%rsi
  8026d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d8:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
	return r;
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e7:	c9                   	leaveq 
  8026e8:	c3                   	retq   

00000000008026e9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026e9:	55                   	push   %rbp
  8026ea:	48 89 e5             	mov    %rsp,%rbp
  8026ed:	48 83 ec 40          	sub    $0x40,%rsp
  8026f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802700:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802703:	48 89 d6             	mov    %rdx,%rsi
  802706:	89 c7                	mov    %eax,%edi
  802708:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
  802714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271b:	78 24                	js     802741 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80271d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802721:	8b 00                	mov    (%rax),%eax
  802723:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802727:	48 89 d6             	mov    %rdx,%rsi
  80272a:	89 c7                	mov    %eax,%edi
  80272c:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
  802738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273f:	79 05                	jns    802746 <read+0x5d>
		return r;
  802741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802744:	eb 76                	jmp    8027bc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	8b 40 08             	mov    0x8(%rax),%eax
  80274d:	83 e0 03             	and    $0x3,%eax
  802750:	83 f8 01             	cmp    $0x1,%eax
  802753:	75 3a                	jne    80278f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802755:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80275c:	00 00 00 
  80275f:	48 8b 00             	mov    (%rax),%rax
  802762:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802768:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80276b:	89 c6                	mov    %eax,%esi
  80276d:	48 bf 17 45 80 00 00 	movabs $0x804517,%rdi
  802774:	00 00 00 
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	48 b9 9f 08 80 00 00 	movabs $0x80089f,%rcx
  802783:	00 00 00 
  802786:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80278d:	eb 2d                	jmp    8027bc <read+0xd3>
	}
	if (!dev->dev_read)
  80278f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802793:	48 8b 40 10          	mov    0x10(%rax),%rax
  802797:	48 85 c0             	test   %rax,%rax
  80279a:	75 07                	jne    8027a3 <read+0xba>
		return -E_NOT_SUPP;
  80279c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a1:	eb 19                	jmp    8027bc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027ab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027b3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027b7:	48 89 cf             	mov    %rcx,%rdi
  8027ba:	ff d0                	callq  *%rax
}
  8027bc:	c9                   	leaveq 
  8027bd:	c3                   	retq   

00000000008027be <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	48 83 ec 30          	sub    $0x30,%rsp
  8027c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027d8:	eb 49                	jmp    802823 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dd:	48 98                	cltq   
  8027df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e3:	48 29 c2             	sub    %rax,%rdx
  8027e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e9:	48 63 c8             	movslq %eax,%rcx
  8027ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f0:	48 01 c1             	add    %rax,%rcx
  8027f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f6:	48 89 ce             	mov    %rcx,%rsi
  8027f9:	89 c7                	mov    %eax,%edi
  8027fb:	48 b8 e9 26 80 00 00 	movabs $0x8026e9,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
  802807:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80280a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80280e:	79 05                	jns    802815 <readn+0x57>
			return m;
  802810:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802813:	eb 1c                	jmp    802831 <readn+0x73>
		if (m == 0)
  802815:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802819:	75 02                	jne    80281d <readn+0x5f>
			break;
  80281b:	eb 11                	jmp    80282e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80281d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802820:	01 45 fc             	add    %eax,-0x4(%rbp)
  802823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802826:	48 98                	cltq   
  802828:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80282c:	72 ac                	jb     8027da <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80282e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802831:	c9                   	leaveq 
  802832:	c3                   	retq   

0000000000802833 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802833:	55                   	push   %rbp
  802834:	48 89 e5             	mov    %rsp,%rbp
  802837:	48 83 ec 40          	sub    $0x40,%rsp
  80283b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80283e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802842:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802846:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80284a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80284d:	48 89 d6             	mov    %rdx,%rsi
  802850:	89 c7                	mov    %eax,%edi
  802852:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  802859:	00 00 00 
  80285c:	ff d0                	callq  *%rax
  80285e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802861:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802865:	78 24                	js     80288b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286b:	8b 00                	mov    (%rax),%eax
  80286d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802871:	48 89 d6             	mov    %rdx,%rsi
  802874:	89 c7                	mov    %eax,%edi
  802876:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  80287d:	00 00 00 
  802880:	ff d0                	callq  *%rax
  802882:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802885:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802889:	79 05                	jns    802890 <write+0x5d>
		return r;
  80288b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288e:	eb 42                	jmp    8028d2 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802894:	8b 40 08             	mov    0x8(%rax),%eax
  802897:	83 e0 03             	and    $0x3,%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	75 07                	jne    8028a5 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80289e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a3:	eb 2d                	jmp    8028d2 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028ad:	48 85 c0             	test   %rax,%rax
  8028b0:	75 07                	jne    8028b9 <write+0x86>
		return -E_NOT_SUPP;
  8028b2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b7:	eb 19                	jmp    8028d2 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  8028b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028c9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028cd:	48 89 cf             	mov    %rcx,%rdi
  8028d0:	ff d0                	callq  *%rax
}
  8028d2:	c9                   	leaveq 
  8028d3:	c3                   	retq   

00000000008028d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028d4:	55                   	push   %rbp
  8028d5:	48 89 e5             	mov    %rsp,%rbp
  8028d8:	48 83 ec 18          	sub    $0x18,%rsp
  8028dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028df:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e9:	48 89 d6             	mov    %rdx,%rsi
  8028ec:	89 c7                	mov    %eax,%edi
  8028ee:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802901:	79 05                	jns    802908 <seek+0x34>
		return r;
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	eb 0f                	jmp    802917 <seek+0x43>
	fd->fd_offset = offset;
  802908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80290f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802912:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802917:	c9                   	leaveq 
  802918:	c3                   	retq   

0000000000802919 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	48 83 ec 30          	sub    $0x30,%rsp
  802921:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802924:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802927:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80292b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292e:	48 89 d6             	mov    %rdx,%rsi
  802931:	89 c7                	mov    %eax,%edi
  802933:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
  80293f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802942:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802946:	78 24                	js     80296c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294c:	8b 00                	mov    (%rax),%eax
  80294e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802952:	48 89 d6             	mov    %rdx,%rsi
  802955:	89 c7                	mov    %eax,%edi
  802957:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax
  802963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802966:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296a:	79 05                	jns    802971 <ftruncate+0x58>
		return r;
  80296c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296f:	eb 72                	jmp    8029e3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802975:	8b 40 08             	mov    0x8(%rax),%eax
  802978:	83 e0 03             	and    $0x3,%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 3a                	jne    8029b9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80297f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802986:	00 00 00 
  802989:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80298c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802992:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802995:	89 c6                	mov    %eax,%esi
  802997:	48 bf 38 45 80 00 00 	movabs $0x804538,%rdi
  80299e:	00 00 00 
  8029a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a6:	48 b9 9f 08 80 00 00 	movabs $0x80089f,%rcx
  8029ad:	00 00 00 
  8029b0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b7:	eb 2a                	jmp    8029e3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029c1:	48 85 c0             	test   %rax,%rax
  8029c4:	75 07                	jne    8029cd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029c6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029cb:	eb 16                	jmp    8029e3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029d9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029dc:	89 ce                	mov    %ecx,%esi
  8029de:	48 89 d7             	mov    %rdx,%rdi
  8029e1:	ff d0                	callq  *%rax
}
  8029e3:	c9                   	leaveq 
  8029e4:	c3                   	retq   

00000000008029e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029e5:	55                   	push   %rbp
  8029e6:	48 89 e5             	mov    %rsp,%rbp
  8029e9:	48 83 ec 30          	sub    $0x30,%rsp
  8029ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fb:	48 89 d6             	mov    %rdx,%rsi
  8029fe:	89 c7                	mov    %eax,%edi
  802a00:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
  802a0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a13:	78 24                	js     802a39 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a19:	8b 00                	mov    (%rax),%eax
  802a1b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1f:	48 89 d6             	mov    %rdx,%rsi
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	48 b8 10 24 80 00 00 	movabs $0x802410,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a37:	79 05                	jns    802a3e <fstat+0x59>
		return r;
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	eb 5e                	jmp    802a9c <fstat+0xb7>
	if (!dev->dev_stat)
  802a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a42:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a46:	48 85 c0             	test   %rax,%rax
  802a49:	75 07                	jne    802a52 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a4b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a50:	eb 4a                	jmp    802a9c <fstat+0xb7>
	stat->st_name[0] = 0;
  802a52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a56:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a64:	00 00 00 
	stat->st_isdir = 0;
  802a67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a72:	00 00 00 
	stat->st_dev = dev;
  802a75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a88:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a90:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a94:	48 89 ce             	mov    %rcx,%rsi
  802a97:	48 89 d7             	mov    %rdx,%rdi
  802a9a:	ff d0                	callq  *%rax
}
  802a9c:	c9                   	leaveq 
  802a9d:	c3                   	retq   

0000000000802a9e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a9e:	55                   	push   %rbp
  802a9f:	48 89 e5             	mov    %rsp,%rbp
  802aa2:	48 83 ec 20          	sub    $0x20,%rsp
  802aa6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab2:	be 00 00 00 00       	mov    $0x0,%esi
  802ab7:	48 89 c7             	mov    %rax,%rdi
  802aba:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802ac1:	00 00 00 
  802ac4:	ff d0                	callq  *%rax
  802ac6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acd:	79 05                	jns    802ad4 <stat+0x36>
		return fd;
  802acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad2:	eb 2f                	jmp    802b03 <stat+0x65>
	r = fstat(fd, stat);
  802ad4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adb:	48 89 d6             	mov    %rdx,%rsi
  802ade:	89 c7                	mov    %eax,%edi
  802ae0:	48 b8 e5 29 80 00 00 	movabs $0x8029e5,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
  802aec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
	return r;
  802b00:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
  802b09:	48 83 ec 10          	sub    $0x10,%rsp
  802b0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b14:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b1b:	00 00 00 
  802b1e:	8b 00                	mov    (%rax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	75 1d                	jne    802b41 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b24:	bf 01 00 00 00       	mov    $0x1,%edi
  802b29:	48 b8 4d 3d 80 00 00 	movabs $0x803d4d,%rax
  802b30:	00 00 00 
  802b33:	ff d0                	callq  *%rax
  802b35:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b3c:	00 00 00 
  802b3f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b41:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b48:	00 00 00 
  802b4b:	8b 00                	mov    (%rax),%eax
  802b4d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b50:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b55:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b5c:	00 00 00 
  802b5f:	89 c7                	mov    %eax,%edi
  802b61:	48 b8 c5 3c 80 00 00 	movabs $0x803cc5,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b71:	ba 00 00 00 00       	mov    $0x0,%edx
  802b76:	48 89 c6             	mov    %rax,%rsi
  802b79:	bf 00 00 00 00       	mov    $0x0,%edi
  802b7e:	48 b8 c7 3b 80 00 00 	movabs $0x803bc7,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
}
  802b8a:	c9                   	leaveq 
  802b8b:	c3                   	retq   

0000000000802b8c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 30          	sub    $0x30,%rsp
  802b94:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b98:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802b9b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802ba2:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802bb0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bb5:	75 08                	jne    802bbf <open+0x33>
	{
		return r;
  802bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bba:	e9 f2 00 00 00       	jmpq   802cb1 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc3:	48 89 c7             	mov    %rax,%rdi
  802bc6:	48 b8 e8 13 80 00 00 	movabs $0x8013e8,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bd5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802bdc:	7e 0a                	jle    802be8 <open+0x5c>
	{
		return -E_BAD_PATH;
  802bde:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802be3:	e9 c9 00 00 00       	jmpq   802cb1 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802be8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802bef:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802bf0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802bf4:	48 89 c7             	mov    %rax,%rdi
  802bf7:	48 b8 1f 22 80 00 00 	movabs $0x80221f,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
  802c03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0a:	78 09                	js     802c15 <open+0x89>
  802c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c10:	48 85 c0             	test   %rax,%rax
  802c13:	75 08                	jne    802c1d <open+0x91>
		{
			return r;
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	e9 94 00 00 00       	jmpq   802cb1 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c21:	ba 00 04 00 00       	mov    $0x400,%edx
  802c26:	48 89 c6             	mov    %rax,%rsi
  802c29:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c30:	00 00 00 
  802c33:	48 b8 e6 14 80 00 00 	movabs $0x8014e6,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c46:	00 00 00 
  802c49:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c4c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c56:	48 89 c6             	mov    %rax,%rsi
  802c59:	bf 01 00 00 00       	mov    $0x1,%edi
  802c5e:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c71:	79 2b                	jns    802c9e <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c77:	be 00 00 00 00       	mov    $0x0,%esi
  802c7c:	48 89 c7             	mov    %rax,%rdi
  802c7f:	48 b8 47 23 80 00 00 	movabs $0x802347,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802c8e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c92:	79 05                	jns    802c99 <open+0x10d>
			{
				return d;
  802c94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c97:	eb 18                	jmp    802cb1 <open+0x125>
			}
			return r;
  802c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9c:	eb 13                	jmp    802cb1 <open+0x125>
		}	
		return fd2num(fd_store);
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca2:	48 89 c7             	mov    %rax,%rdi
  802ca5:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 10          	sub    $0x10,%rsp
  802cbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc3:	8b 50 0c             	mov    0xc(%rax),%edx
  802cc6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ccd:	00 00 00 
  802cd0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cd2:	be 00 00 00 00       	mov    $0x0,%esi
  802cd7:	bf 06 00 00 00       	mov    $0x6,%edi
  802cdc:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
}
  802ce8:	c9                   	leaveq 
  802ce9:	c3                   	retq   

0000000000802cea <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802cea:	55                   	push   %rbp
  802ceb:	48 89 e5             	mov    %rsp,%rbp
  802cee:	48 83 ec 30          	sub    $0x30,%rsp
  802cf2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cf6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cfa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d05:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d0a:	74 07                	je     802d13 <devfile_read+0x29>
  802d0c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d11:	75 07                	jne    802d1a <devfile_read+0x30>
		return -E_INVAL;
  802d13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d18:	eb 77                	jmp    802d91 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1e:	8b 50 0c             	mov    0xc(%rax),%edx
  802d21:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d28:	00 00 00 
  802d2b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d2d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d34:	00 00 00 
  802d37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d3b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d3f:	be 00 00 00 00       	mov    $0x0,%esi
  802d44:	bf 03 00 00 00       	mov    $0x3,%edi
  802d49:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
  802d55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5c:	7f 05                	jg     802d63 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d61:	eb 2e                	jmp    802d91 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d66:	48 63 d0             	movslq %eax,%rdx
  802d69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d74:	00 00 00 
  802d77:	48 89 c7             	mov    %rax,%rdi
  802d7a:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d91:	c9                   	leaveq 
  802d92:	c3                   	retq   

0000000000802d93 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d93:	55                   	push   %rbp
  802d94:	48 89 e5             	mov    %rsp,%rbp
  802d97:	48 83 ec 30          	sub    $0x30,%rsp
  802d9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802da3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802da7:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802dae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802db3:	74 07                	je     802dbc <devfile_write+0x29>
  802db5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dba:	75 08                	jne    802dc4 <devfile_write+0x31>
		return r;
  802dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbf:	e9 9a 00 00 00       	jmpq   802e5e <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc8:	8b 50 0c             	mov    0xc(%rax),%edx
  802dcb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd2:	00 00 00 
  802dd5:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802dd7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802dde:	00 
  802ddf:	76 08                	jbe    802de9 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802de1:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802de8:	00 
	}
	fsipcbuf.write.req_n = n;
  802de9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df0:	00 00 00 
  802df3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802df7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802dfb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e03:	48 89 c6             	mov    %rax,%rsi
  802e06:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e0d:	00 00 00 
  802e10:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e1c:	be 00 00 00 00       	mov    $0x0,%esi
  802e21:	bf 04 00 00 00       	mov    $0x4,%edi
  802e26:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e39:	7f 20                	jg     802e5b <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e3b:	48 bf 5e 45 80 00 00 	movabs $0x80455e,%rdi
  802e42:	00 00 00 
  802e45:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4a:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  802e51:	00 00 00 
  802e54:	ff d2                	callq  *%rdx
		return r;
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	eb 03                	jmp    802e5e <devfile_write+0xcb>
	}
	return r;
  802e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e5e:	c9                   	leaveq 
  802e5f:	c3                   	retq   

0000000000802e60 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
  802e64:	48 83 ec 20          	sub    $0x20,%rsp
  802e68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e74:	8b 50 0c             	mov    0xc(%rax),%edx
  802e77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7e:	00 00 00 
  802e81:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e83:	be 00 00 00 00       	mov    $0x0,%esi
  802e88:	bf 05 00 00 00       	mov    $0x5,%edi
  802e8d:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
  802e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea0:	79 05                	jns    802ea7 <devfile_stat+0x47>
		return r;
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	eb 56                	jmp    802efd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eab:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802eb2:	00 00 00 
  802eb5:	48 89 c7             	mov    %rax,%rdi
  802eb8:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ec4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ecb:	00 00 00 
  802ece:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ed4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ede:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee5:	00 00 00 
  802ee8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802eee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efd:	c9                   	leaveq 
  802efe:	c3                   	retq   

0000000000802eff <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802eff:	55                   	push   %rbp
  802f00:	48 89 e5             	mov    %rsp,%rbp
  802f03:	48 83 ec 10          	sub    $0x10,%rsp
  802f07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f0b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f12:	8b 50 0c             	mov    0xc(%rax),%edx
  802f15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f1c:	00 00 00 
  802f1f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f21:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f28:	00 00 00 
  802f2b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f31:	be 00 00 00 00       	mov    $0x0,%esi
  802f36:	bf 02 00 00 00       	mov    $0x2,%edi
  802f3b:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
}
  802f47:	c9                   	leaveq 
  802f48:	c3                   	retq   

0000000000802f49 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f49:	55                   	push   %rbp
  802f4a:	48 89 e5             	mov    %rsp,%rbp
  802f4d:	48 83 ec 10          	sub    $0x10,%rsp
  802f51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f59:	48 89 c7             	mov    %rax,%rdi
  802f5c:	48 b8 e8 13 80 00 00 	movabs $0x8013e8,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
  802f68:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f6d:	7e 07                	jle    802f76 <remove+0x2d>
		return -E_BAD_PATH;
  802f6f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f74:	eb 33                	jmp    802fa9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7a:	48 89 c6             	mov    %rax,%rsi
  802f7d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f84:	00 00 00 
  802f87:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f93:	be 00 00 00 00       	mov    $0x0,%esi
  802f98:	bf 07 00 00 00       	mov    $0x7,%edi
  802f9d:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
}
  802fa9:	c9                   	leaveq 
  802faa:	c3                   	retq   

0000000000802fab <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fab:	55                   	push   %rbp
  802fac:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802faf:	be 00 00 00 00       	mov    $0x0,%esi
  802fb4:	bf 08 00 00 00       	mov    $0x8,%edi
  802fb9:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
}
  802fc5:	5d                   	pop    %rbp
  802fc6:	c3                   	retq   

0000000000802fc7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fd2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fd9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fe0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fe7:	be 00 00 00 00       	mov    $0x0,%esi
  802fec:	48 89 c7             	mov    %rax,%rdi
  802fef:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
  802ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803002:	79 28                	jns    80302c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	89 c6                	mov    %eax,%esi
  803009:	48 bf 7a 45 80 00 00 	movabs $0x80457a,%rdi
  803010:	00 00 00 
  803013:	b8 00 00 00 00       	mov    $0x0,%eax
  803018:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  80301f:	00 00 00 
  803022:	ff d2                	callq  *%rdx
		return fd_src;
  803024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803027:	e9 74 01 00 00       	jmpq   8031a0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80302c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803033:	be 01 01 00 00       	mov    $0x101,%esi
  803038:	48 89 c7             	mov    %rax,%rdi
  80303b:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80304a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80304e:	79 39                	jns    803089 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803050:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803053:	89 c6                	mov    %eax,%esi
  803055:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  80305c:	00 00 00 
  80305f:	b8 00 00 00 00       	mov    $0x0,%eax
  803064:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  80306b:	00 00 00 
  80306e:	ff d2                	callq  *%rdx
		close(fd_src);
  803070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803073:	89 c7                	mov    %eax,%edi
  803075:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80307c:	00 00 00 
  80307f:	ff d0                	callq  *%rax
		return fd_dest;
  803081:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803084:	e9 17 01 00 00       	jmpq   8031a0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803089:	eb 74                	jmp    8030ff <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80308b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80308e:	48 63 d0             	movslq %eax,%rdx
  803091:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803098:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80309b:	48 89 ce             	mov    %rcx,%rsi
  80309e:	89 c7                	mov    %eax,%edi
  8030a0:	48 b8 33 28 80 00 00 	movabs $0x802833,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
  8030ac:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030af:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030b3:	79 4a                	jns    8030ff <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030b5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030b8:	89 c6                	mov    %eax,%esi
  8030ba:	48 bf aa 45 80 00 00 	movabs $0x8045aa,%rdi
  8030c1:	00 00 00 
  8030c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c9:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  8030d0:	00 00 00 
  8030d3:	ff d2                	callq  *%rdx
			close(fd_src);
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	89 c7                	mov    %eax,%edi
  8030da:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
			close(fd_dest);
  8030e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e9:	89 c7                	mov    %eax,%edi
  8030eb:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8030f2:	00 00 00 
  8030f5:	ff d0                	callq  *%rax
			return write_size;
  8030f7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030fa:	e9 a1 00 00 00       	jmpq   8031a0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030ff:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803109:	ba 00 02 00 00       	mov    $0x200,%edx
  80310e:	48 89 ce             	mov    %rcx,%rsi
  803111:	89 c7                	mov    %eax,%edi
  803113:	48 b8 e9 26 80 00 00 	movabs $0x8026e9,%rax
  80311a:	00 00 00 
  80311d:	ff d0                	callq  *%rax
  80311f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803122:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803126:	0f 8f 5f ff ff ff    	jg     80308b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80312c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803130:	79 47                	jns    803179 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803132:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803135:	89 c6                	mov    %eax,%esi
  803137:	48 bf bd 45 80 00 00 	movabs $0x8045bd,%rdi
  80313e:	00 00 00 
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
  803146:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  80314d:	00 00 00 
  803150:	ff d2                	callq  *%rdx
		close(fd_src);
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	89 c7                	mov    %eax,%edi
  803157:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
		close(fd_dest);
  803163:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803166:	89 c7                	mov    %eax,%edi
  803168:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
		return read_size;
  803174:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803177:	eb 27                	jmp    8031a0 <copy+0x1d9>
	}
	close(fd_src);
  803179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317c:	89 c7                	mov    %eax,%edi
  80317e:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
	close(fd_dest);
  80318a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80318d:	89 c7                	mov    %eax,%edi
  80318f:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
	return 0;
  80319b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031a0:	c9                   	leaveq 
  8031a1:	c3                   	retq   

00000000008031a2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031a2:	55                   	push   %rbp
  8031a3:	48 89 e5             	mov    %rsp,%rbp
  8031a6:	53                   	push   %rbx
  8031a7:	48 83 ec 38          	sub    $0x38,%rsp
  8031ab:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031af:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031b3:	48 89 c7             	mov    %rax,%rdi
  8031b6:	48 b8 1f 22 80 00 00 	movabs $0x80221f,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
  8031c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031c9:	0f 88 bf 01 00 00    	js     80338e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d3:	ba 07 04 00 00       	mov    $0x407,%edx
  8031d8:	48 89 c6             	mov    %rax,%rsi
  8031db:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e0:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
  8031ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031f3:	0f 88 95 01 00 00    	js     80338e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031f9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031fd:	48 89 c7             	mov    %rax,%rdi
  803200:	48 b8 1f 22 80 00 00 	movabs $0x80221f,%rax
  803207:	00 00 00 
  80320a:	ff d0                	callq  *%rax
  80320c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80320f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803213:	0f 88 5d 01 00 00    	js     803376 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803219:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321d:	ba 07 04 00 00       	mov    $0x407,%edx
  803222:	48 89 c6             	mov    %rax,%rsi
  803225:	bf 00 00 00 00       	mov    $0x0,%edi
  80322a:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803231:	00 00 00 
  803234:	ff d0                	callq  *%rax
  803236:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803239:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80323d:	0f 88 33 01 00 00    	js     803376 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803247:	48 89 c7             	mov    %rax,%rdi
  80324a:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80325a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325e:	ba 07 04 00 00       	mov    $0x407,%edx
  803263:	48 89 c6             	mov    %rax,%rsi
  803266:	bf 00 00 00 00       	mov    $0x0,%edi
  80326b:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327e:	79 05                	jns    803285 <pipe+0xe3>
		goto err2;
  803280:	e9 d9 00 00 00       	jmpq   80335e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803285:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803289:	48 89 c7             	mov    %rax,%rdi
  80328c:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	48 89 c2             	mov    %rax,%rdx
  80329b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032a5:	48 89 d1             	mov    %rdx,%rcx
  8032a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ad:	48 89 c6             	mov    %rax,%rsi
  8032b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b5:	48 b8 d3 1d 80 00 00 	movabs $0x801dd3,%rax
  8032bc:	00 00 00 
  8032bf:	ff d0                	callq  *%rax
  8032c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c8:	79 1b                	jns    8032e5 <pipe+0x143>
		goto err3;
  8032ca:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8032cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032cf:	48 89 c6             	mov    %rax,%rsi
  8032d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d7:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	eb 79                	jmp    80335e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e9:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032f0:	00 00 00 
  8032f3:	8b 12                	mov    (%rdx),%edx
  8032f5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803302:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803306:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80330d:	00 00 00 
  803310:	8b 12                	mov    (%rdx),%edx
  803312:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803314:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803318:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80331f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803323:	48 89 c7             	mov    %rax,%rdi
  803326:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	89 c2                	mov    %eax,%edx
  803334:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803338:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80333a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80333e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803342:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803346:	48 89 c7             	mov    %rax,%rdi
  803349:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	89 03                	mov    %eax,(%rbx)
	return 0;
  803357:	b8 00 00 00 00       	mov    $0x0,%eax
  80335c:	eb 33                	jmp    803391 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80335e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803362:	48 89 c6             	mov    %rax,%rsi
  803365:	bf 00 00 00 00       	mov    $0x0,%edi
  80336a:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337a:	48 89 c6             	mov    %rax,%rsi
  80337d:	bf 00 00 00 00       	mov    $0x0,%edi
  803382:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
err:
	return r;
  80338e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803391:	48 83 c4 38          	add    $0x38,%rsp
  803395:	5b                   	pop    %rbx
  803396:	5d                   	pop    %rbp
  803397:	c3                   	retq   

0000000000803398 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803398:	55                   	push   %rbp
  803399:	48 89 e5             	mov    %rsp,%rbp
  80339c:	53                   	push   %rbx
  80339d:	48 83 ec 28          	sub    $0x28,%rsp
  8033a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033b0:	00 00 00 
  8033b3:	48 8b 00             	mov    (%rax),%rax
  8033b6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c3:	48 89 c7             	mov    %rax,%rdi
  8033c6:	48 b8 bf 3d 80 00 00 	movabs $0x803dbf,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
  8033d2:	89 c3                	mov    %eax,%ebx
  8033d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d8:	48 89 c7             	mov    %rax,%rdi
  8033db:	48 b8 bf 3d 80 00 00 	movabs $0x803dbf,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	39 c3                	cmp    %eax,%ebx
  8033e9:	0f 94 c0             	sete   %al
  8033ec:	0f b6 c0             	movzbl %al,%eax
  8033ef:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033f9:	00 00 00 
  8033fc:	48 8b 00             	mov    (%rax),%rax
  8033ff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803405:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803408:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80340e:	75 05                	jne    803415 <_pipeisclosed+0x7d>
			return ret;
  803410:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803413:	eb 4f                	jmp    803464 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803415:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803418:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80341b:	74 42                	je     80345f <_pipeisclosed+0xc7>
  80341d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803421:	75 3c                	jne    80345f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803423:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80342a:	00 00 00 
  80342d:	48 8b 00             	mov    (%rax),%rax
  803430:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803436:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803439:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343c:	89 c6                	mov    %eax,%esi
  80343e:	48 bf dd 45 80 00 00 	movabs $0x8045dd,%rdi
  803445:	00 00 00 
  803448:	b8 00 00 00 00       	mov    $0x0,%eax
  80344d:	49 b8 9f 08 80 00 00 	movabs $0x80089f,%r8
  803454:	00 00 00 
  803457:	41 ff d0             	callq  *%r8
	}
  80345a:	e9 4a ff ff ff       	jmpq   8033a9 <_pipeisclosed+0x11>
  80345f:	e9 45 ff ff ff       	jmpq   8033a9 <_pipeisclosed+0x11>
}
  803464:	48 83 c4 28          	add    $0x28,%rsp
  803468:	5b                   	pop    %rbx
  803469:	5d                   	pop    %rbp
  80346a:	c3                   	retq   

000000000080346b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80346b:	55                   	push   %rbp
  80346c:	48 89 e5             	mov    %rsp,%rbp
  80346f:	48 83 ec 30          	sub    $0x30,%rsp
  803473:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803476:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80347a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80347d:	48 89 d6             	mov    %rdx,%rsi
  803480:	89 c7                	mov    %eax,%edi
  803482:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
  80348e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803491:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803495:	79 05                	jns    80349c <pipeisclosed+0x31>
		return r;
  803497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349a:	eb 31                	jmp    8034cd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80349c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a0:	48 89 c7             	mov    %rax,%rdi
  8034a3:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
  8034af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034bb:	48 89 d6             	mov    %rdx,%rsi
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 98 33 80 00 00 	movabs $0x803398,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
}
  8034cd:	c9                   	leaveq 
  8034ce:	c3                   	retq   

00000000008034cf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034cf:	55                   	push   %rbp
  8034d0:	48 89 e5             	mov    %rsp,%rbp
  8034d3:	48 83 ec 40          	sub    $0x40,%rsp
  8034d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034df:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e7:	48 89 c7             	mov    %rax,%rdi
  8034ea:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803502:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803509:	00 
  80350a:	e9 92 00 00 00       	jmpq   8035a1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80350f:	eb 41                	jmp    803552 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803511:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803516:	74 09                	je     803521 <devpipe_read+0x52>
				return i;
  803518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351c:	e9 92 00 00 00       	jmpq   8035b3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803521:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803529:	48 89 d6             	mov    %rdx,%rsi
  80352c:	48 89 c7             	mov    %rax,%rdi
  80352f:	48 b8 98 33 80 00 00 	movabs $0x803398,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	85 c0                	test   %eax,%eax
  80353d:	74 07                	je     803546 <devpipe_read+0x77>
				return 0;
  80353f:	b8 00 00 00 00       	mov    $0x0,%eax
  803544:	eb 6d                	jmp    8035b3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803546:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803556:	8b 10                	mov    (%rax),%edx
  803558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355c:	8b 40 04             	mov    0x4(%rax),%eax
  80355f:	39 c2                	cmp    %eax,%edx
  803561:	74 ae                	je     803511 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80356b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80356f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803573:	8b 00                	mov    (%rax),%eax
  803575:	99                   	cltd   
  803576:	c1 ea 1b             	shr    $0x1b,%edx
  803579:	01 d0                	add    %edx,%eax
  80357b:	83 e0 1f             	and    $0x1f,%eax
  80357e:	29 d0                	sub    %edx,%eax
  803580:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803584:	48 98                	cltq   
  803586:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80358b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80358d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803591:	8b 00                	mov    (%rax),%eax
  803593:	8d 50 01             	lea    0x1(%rax),%edx
  803596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80359c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035a9:	0f 82 60 ff ff ff    	jb     80350f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035b3:	c9                   	leaveq 
  8035b4:	c3                   	retq   

00000000008035b5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035b5:	55                   	push   %rbp
  8035b6:	48 89 e5             	mov    %rsp,%rbp
  8035b9:	48 83 ec 40          	sub    $0x40,%rsp
  8035bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035c5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035cd:	48 89 c7             	mov    %rax,%rdi
  8035d0:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
  8035dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035e4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035ef:	00 
  8035f0:	e9 8e 00 00 00       	jmpq   803683 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035f5:	eb 31                	jmp    803628 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ff:	48 89 d6             	mov    %rdx,%rsi
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 98 33 80 00 00 	movabs $0x803398,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 07                	je     80361c <devpipe_write+0x67>
				return 0;
  803615:	b8 00 00 00 00       	mov    $0x0,%eax
  80361a:	eb 79                	jmp    803695 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80361c:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362c:	8b 40 04             	mov    0x4(%rax),%eax
  80362f:	48 63 d0             	movslq %eax,%rdx
  803632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803636:	8b 00                	mov    (%rax),%eax
  803638:	48 98                	cltq   
  80363a:	48 83 c0 20          	add    $0x20,%rax
  80363e:	48 39 c2             	cmp    %rax,%rdx
  803641:	73 b4                	jae    8035f7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803647:	8b 40 04             	mov    0x4(%rax),%eax
  80364a:	99                   	cltd   
  80364b:	c1 ea 1b             	shr    $0x1b,%edx
  80364e:	01 d0                	add    %edx,%eax
  803650:	83 e0 1f             	and    $0x1f,%eax
  803653:	29 d0                	sub    %edx,%eax
  803655:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803659:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80365d:	48 01 ca             	add    %rcx,%rdx
  803660:	0f b6 0a             	movzbl (%rdx),%ecx
  803663:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803667:	48 98                	cltq   
  803669:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80366d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803671:	8b 40 04             	mov    0x4(%rax),%eax
  803674:	8d 50 01             	lea    0x1(%rax),%edx
  803677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80367e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803687:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80368b:	0f 82 64 ff ff ff    	jb     8035f5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803695:	c9                   	leaveq 
  803696:	c3                   	retq   

0000000000803697 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803697:	55                   	push   %rbp
  803698:	48 89 e5             	mov    %rsp,%rbp
  80369b:	48 83 ec 20          	sub    $0x20,%rsp
  80369f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ab:	48 89 c7             	mov    %rax,%rdi
  8036ae:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  8036b5:	00 00 00 
  8036b8:	ff d0                	callq  *%rax
  8036ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c2:	48 be f0 45 80 00 00 	movabs $0x8045f0,%rsi
  8036c9:	00 00 00 
  8036cc:	48 89 c7             	mov    %rax,%rdi
  8036cf:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036df:	8b 50 04             	mov    0x4(%rax),%edx
  8036e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e6:	8b 00                	mov    (%rax),%eax
  8036e8:	29 c2                	sub    %eax,%edx
  8036ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ee:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036ff:	00 00 00 
	stat->st_dev = &devpipe;
  803702:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803706:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80370d:	00 00 00 
  803710:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80371c:	c9                   	leaveq 
  80371d:	c3                   	retq   

000000000080371e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80371e:	55                   	push   %rbp
  80371f:	48 89 e5             	mov    %rsp,%rbp
  803722:	48 83 ec 10          	sub    $0x10,%rsp
  803726:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80372a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372e:	48 89 c6             	mov    %rax,%rsi
  803731:	bf 00 00 00 00       	mov    $0x0,%edi
  803736:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803746:	48 89 c7             	mov    %rax,%rdi
  803749:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  803750:	00 00 00 
  803753:	ff d0                	callq  *%rax
  803755:	48 89 c6             	mov    %rax,%rsi
  803758:	bf 00 00 00 00       	mov    $0x0,%edi
  80375d:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  803764:	00 00 00 
  803767:	ff d0                	callq  *%rax
}
  803769:	c9                   	leaveq 
  80376a:	c3                   	retq   

000000000080376b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80376b:	55                   	push   %rbp
  80376c:	48 89 e5             	mov    %rsp,%rbp
  80376f:	48 83 ec 20          	sub    $0x20,%rsp
  803773:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803776:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80377a:	75 35                	jne    8037b1 <wait+0x46>
  80377c:	48 b9 f7 45 80 00 00 	movabs $0x8045f7,%rcx
  803783:	00 00 00 
  803786:	48 ba 02 46 80 00 00 	movabs $0x804602,%rdx
  80378d:	00 00 00 
  803790:	be 09 00 00 00       	mov    $0x9,%esi
  803795:	48 bf 17 46 80 00 00 	movabs $0x804617,%rdi
  80379c:	00 00 00 
  80379f:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a4:	49 b8 b3 3a 80 00 00 	movabs $0x803ab3,%r8
  8037ab:	00 00 00 
  8037ae:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8037b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8037b9:	48 98                	cltq   
  8037bb:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8037c2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8037c9:	00 00 00 
  8037cc:	48 01 d0             	add    %rdx,%rax
  8037cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8037d3:	eb 0c                	jmp    8037e1 <wait+0x76>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  8037d5:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8037e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8037eb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8037ee:	75 0e                	jne    8037fe <wait+0x93>
  8037f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f4:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8037fa:	85 c0                	test   %eax,%eax
  8037fc:	75 d7                	jne    8037d5 <wait+0x6a>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  8037fe:	c9                   	leaveq 
  8037ff:	c3                   	retq   

0000000000803800 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803800:	55                   	push   %rbp
  803801:	48 89 e5             	mov    %rsp,%rbp
  803804:	48 83 ec 20          	sub    $0x20,%rsp
  803808:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80380b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803811:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803815:	be 01 00 00 00       	mov    $0x1,%esi
  80381a:	48 89 c7             	mov    %rax,%rdi
  80381d:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803824:	00 00 00 
  803827:	ff d0                	callq  *%rax
}
  803829:	c9                   	leaveq 
  80382a:	c3                   	retq   

000000000080382b <getchar>:

int
getchar(void)
{
  80382b:	55                   	push   %rbp
  80382c:	48 89 e5             	mov    %rsp,%rbp
  80382f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803833:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803837:	ba 01 00 00 00       	mov    $0x1,%edx
  80383c:	48 89 c6             	mov    %rax,%rsi
  80383f:	bf 00 00 00 00       	mov    $0x0,%edi
  803844:	48 b8 e9 26 80 00 00 	movabs $0x8026e9,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803857:	79 05                	jns    80385e <getchar+0x33>
		return r;
  803859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385c:	eb 14                	jmp    803872 <getchar+0x47>
	if (r < 1)
  80385e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803862:	7f 07                	jg     80386b <getchar+0x40>
		return -E_EOF;
  803864:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803869:	eb 07                	jmp    803872 <getchar+0x47>
	return c;
  80386b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80386f:	0f b6 c0             	movzbl %al,%eax
}
  803872:	c9                   	leaveq 
  803873:	c3                   	retq   

0000000000803874 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803874:	55                   	push   %rbp
  803875:	48 89 e5             	mov    %rsp,%rbp
  803878:	48 83 ec 20          	sub    $0x20,%rsp
  80387c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80387f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803883:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803886:	48 89 d6             	mov    %rdx,%rsi
  803889:	89 c7                	mov    %eax,%edi
  80388b:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
  803897:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389e:	79 05                	jns    8038a5 <iscons+0x31>
		return r;
  8038a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a3:	eb 1a                	jmp    8038bf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a9:	8b 10                	mov    (%rax),%edx
  8038ab:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038b2:	00 00 00 
  8038b5:	8b 00                	mov    (%rax),%eax
  8038b7:	39 c2                	cmp    %eax,%edx
  8038b9:	0f 94 c0             	sete   %al
  8038bc:	0f b6 c0             	movzbl %al,%eax
}
  8038bf:	c9                   	leaveq 
  8038c0:	c3                   	retq   

00000000008038c1 <opencons>:

int
opencons(void)
{
  8038c1:	55                   	push   %rbp
  8038c2:	48 89 e5             	mov    %rsp,%rbp
  8038c5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038c9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038cd:	48 89 c7             	mov    %rax,%rdi
  8038d0:	48 b8 1f 22 80 00 00 	movabs $0x80221f,%rax
  8038d7:	00 00 00 
  8038da:	ff d0                	callq  *%rax
  8038dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e3:	79 05                	jns    8038ea <opencons+0x29>
		return r;
  8038e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e8:	eb 5b                	jmp    803945 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8038ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ee:	ba 07 04 00 00       	mov    $0x407,%edx
  8038f3:	48 89 c6             	mov    %rax,%rsi
  8038f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8038fb:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  803902:	00 00 00 
  803905:	ff d0                	callq  *%rax
  803907:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80390a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390e:	79 05                	jns    803915 <opencons+0x54>
		return r;
  803910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803913:	eb 30                	jmp    803945 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803915:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803919:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803920:	00 00 00 
  803923:	8b 12                	mov    (%rdx),%edx
  803925:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803936:	48 89 c7             	mov    %rax,%rdi
  803939:	48 b8 d1 21 80 00 00 	movabs $0x8021d1,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
}
  803945:	c9                   	leaveq 
  803946:	c3                   	retq   

0000000000803947 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803947:	55                   	push   %rbp
  803948:	48 89 e5             	mov    %rsp,%rbp
  80394b:	48 83 ec 30          	sub    $0x30,%rsp
  80394f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803953:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803957:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80395b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803960:	75 07                	jne    803969 <devcons_read+0x22>
		return 0;
  803962:	b8 00 00 00 00       	mov    $0x0,%eax
  803967:	eb 4b                	jmp    8039b4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803969:	eb 0c                	jmp    803977 <devcons_read+0x30>
		sys_yield();
  80396b:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803977:	48 b8 85 1c 80 00 00 	movabs $0x801c85,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
  803983:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398a:	74 df                	je     80396b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80398c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803990:	79 05                	jns    803997 <devcons_read+0x50>
		return c;
  803992:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803995:	eb 1d                	jmp    8039b4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803997:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80399b:	75 07                	jne    8039a4 <devcons_read+0x5d>
		return 0;
  80399d:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a2:	eb 10                	jmp    8039b4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a7:	89 c2                	mov    %eax,%edx
  8039a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ad:	88 10                	mov    %dl,(%rax)
	return 1;
  8039af:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039b4:	c9                   	leaveq 
  8039b5:	c3                   	retq   

00000000008039b6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039b6:	55                   	push   %rbp
  8039b7:	48 89 e5             	mov    %rsp,%rbp
  8039ba:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039c1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039c8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039cf:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039dd:	eb 76                	jmp    803a55 <devcons_write+0x9f>
		m = n - tot;
  8039df:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039e6:	89 c2                	mov    %eax,%edx
  8039e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039eb:	29 c2                	sub    %eax,%edx
  8039ed:	89 d0                	mov    %edx,%eax
  8039ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8039f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f5:	83 f8 7f             	cmp    $0x7f,%eax
  8039f8:	76 07                	jbe    803a01 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8039fa:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a04:	48 63 d0             	movslq %eax,%rdx
  803a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0a:	48 63 c8             	movslq %eax,%rcx
  803a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a14:	48 01 c1             	add    %rax,%rcx
  803a17:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a1e:	48 89 ce             	mov    %rcx,%rsi
  803a21:	48 89 c7             	mov    %rax,%rdi
  803a24:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a33:	48 63 d0             	movslq %eax,%rdx
  803a36:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a3d:	48 89 d6             	mov    %rdx,%rsi
  803a40:	48 89 c7             	mov    %rax,%rdi
  803a43:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a52:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a58:	48 98                	cltq   
  803a5a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a61:	0f 82 78 ff ff ff    	jb     8039df <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a6a:	c9                   	leaveq 
  803a6b:	c3                   	retq   

0000000000803a6c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a6c:	55                   	push   %rbp
  803a6d:	48 89 e5             	mov    %rsp,%rbp
  803a70:	48 83 ec 08          	sub    $0x8,%rsp
  803a74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a7d:	c9                   	leaveq 
  803a7e:	c3                   	retq   

0000000000803a7f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a7f:	55                   	push   %rbp
  803a80:	48 89 e5             	mov    %rsp,%rbp
  803a83:	48 83 ec 10          	sub    $0x10,%rsp
  803a87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a93:	48 be 27 46 80 00 00 	movabs $0x804627,%rsi
  803a9a:	00 00 00 
  803a9d:	48 89 c7             	mov    %rax,%rdi
  803aa0:	48 b8 54 14 80 00 00 	movabs $0x801454,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
	return 0;
  803aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab1:	c9                   	leaveq 
  803ab2:	c3                   	retq   

0000000000803ab3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803ab3:	55                   	push   %rbp
  803ab4:	48 89 e5             	mov    %rsp,%rbp
  803ab7:	53                   	push   %rbx
  803ab8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803abf:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ac6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803acc:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ad3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ada:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ae1:	84 c0                	test   %al,%al
  803ae3:	74 23                	je     803b08 <_panic+0x55>
  803ae5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803aec:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803af0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803af4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803af8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803afc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b00:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b04:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b08:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b0f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b16:	00 00 00 
  803b19:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b20:	00 00 00 
  803b23:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b27:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b2e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b3c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803b43:	00 00 00 
  803b46:	48 8b 18             	mov    (%rax),%rbx
  803b49:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
  803b55:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b5b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b62:	41 89 c8             	mov    %ecx,%r8d
  803b65:	48 89 d1             	mov    %rdx,%rcx
  803b68:	48 89 da             	mov    %rbx,%rdx
  803b6b:	89 c6                	mov    %eax,%esi
  803b6d:	48 bf 30 46 80 00 00 	movabs $0x804630,%rdi
  803b74:	00 00 00 
  803b77:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7c:	49 b9 9f 08 80 00 00 	movabs $0x80089f,%r9
  803b83:	00 00 00 
  803b86:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b89:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803b90:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b97:	48 89 d6             	mov    %rdx,%rsi
  803b9a:	48 89 c7             	mov    %rax,%rdi
  803b9d:	48 b8 f3 07 80 00 00 	movabs $0x8007f3,%rax
  803ba4:	00 00 00 
  803ba7:	ff d0                	callq  *%rax
	cprintf("\n");
  803ba9:	48 bf 53 46 80 00 00 	movabs $0x804653,%rdi
  803bb0:	00 00 00 
  803bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb8:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  803bbf:	00 00 00 
  803bc2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803bc4:	cc                   	int3   
  803bc5:	eb fd                	jmp    803bc4 <_panic+0x111>

0000000000803bc7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bc7:	55                   	push   %rbp
  803bc8:	48 89 e5             	mov    %rsp,%rbp
  803bcb:	48 83 ec 30          	sub    $0x30,%rsp
  803bcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803bdb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803be2:	00 00 00 
  803be5:	48 8b 00             	mov    (%rax),%rax
  803be8:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	75 34                	jne    803c26 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803bf2:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
  803bfe:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c03:	48 98                	cltq   
  803c05:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803c0c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c13:	00 00 00 
  803c16:	48 01 c2             	add    %rax,%rdx
  803c19:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c20:	00 00 00 
  803c23:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c26:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c2b:	75 0e                	jne    803c3b <ipc_recv+0x74>
		pg = (void*) UTOP;
  803c2d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c34:	00 00 00 
  803c37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3f:	48 89 c7             	mov    %rax,%rdi
  803c42:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
  803c4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c55:	79 19                	jns    803c70 <ipc_recv+0xa9>
		*from_env_store = 0;
  803c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c5b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c65:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6e:	eb 53                	jmp    803cc3 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803c70:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c75:	74 19                	je     803c90 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803c77:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c7e:	00 00 00 
  803c81:	48 8b 00             	mov    (%rax),%rax
  803c84:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803c90:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c95:	74 19                	je     803cb0 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  803c97:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c9e:	00 00 00 
  803ca1:	48 8b 00             	mov    (%rax),%rax
  803ca4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803caa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cae:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803cb0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cb7:	00 00 00 
  803cba:	48 8b 00             	mov    (%rax),%rax
  803cbd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 30          	sub    $0x30,%rsp
  803ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cd0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cd3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cd7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803cda:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cdf:	75 0e                	jne    803cef <ipc_send+0x2a>
		pg = (void*)UTOP;
  803ce1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ce8:	00 00 00 
  803ceb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803cef:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cf2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803cf5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cfc:	89 c7                	mov    %eax,%edi
  803cfe:	48 b8 57 1f 80 00 00 	movabs $0x801f57,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d0d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d11:	75 0c                	jne    803d1f <ipc_send+0x5a>
			sys_yield();
  803d13:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  803d1a:	00 00 00 
  803d1d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d1f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d23:	74 ca                	je     803cef <ipc_send+0x2a>
	if(result != 0)
  803d25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d29:	74 20                	je     803d4b <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2e:	89 c6                	mov    %eax,%esi
  803d30:	48 bf 55 46 80 00 00 	movabs $0x804655,%rdi
  803d37:	00 00 00 
  803d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3f:	48 ba 9f 08 80 00 00 	movabs $0x80089f,%rdx
  803d46:	00 00 00 
  803d49:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803d4b:	c9                   	leaveq 
  803d4c:	c3                   	retq   

0000000000803d4d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d4d:	55                   	push   %rbp
  803d4e:	48 89 e5             	mov    %rsp,%rbp
  803d51:	48 83 ec 14          	sub    $0x14,%rsp
  803d55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d5f:	eb 4e                	jmp    803daf <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803d61:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d68:	00 00 00 
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	48 98                	cltq   
  803d70:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803d77:	48 01 d0             	add    %rdx,%rax
  803d7a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d80:	8b 00                	mov    (%rax),%eax
  803d82:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d85:	75 24                	jne    803dab <ipc_find_env+0x5e>
			return envs[i].env_id;
  803d87:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d8e:	00 00 00 
  803d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d94:	48 98                	cltq   
  803d96:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803d9d:	48 01 d0             	add    %rdx,%rax
  803da0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803da6:	8b 40 08             	mov    0x8(%rax),%eax
  803da9:	eb 12                	jmp    803dbd <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803dab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803daf:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803db6:	7e a9                	jle    803d61 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dbd:	c9                   	leaveq 
  803dbe:	c3                   	retq   

0000000000803dbf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dbf:	55                   	push   %rbp
  803dc0:	48 89 e5             	mov    %rsp,%rbp
  803dc3:	48 83 ec 18          	sub    $0x18,%rsp
  803dc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dcf:	48 c1 e8 15          	shr    $0x15,%rax
  803dd3:	48 89 c2             	mov    %rax,%rdx
  803dd6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ddd:	01 00 00 
  803de0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803de4:	83 e0 01             	and    $0x1,%eax
  803de7:	48 85 c0             	test   %rax,%rax
  803dea:	75 07                	jne    803df3 <pageref+0x34>
		return 0;
  803dec:	b8 00 00 00 00       	mov    $0x0,%eax
  803df1:	eb 53                	jmp    803e46 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df7:	48 c1 e8 0c          	shr    $0xc,%rax
  803dfb:	48 89 c2             	mov    %rax,%rdx
  803dfe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e05:	01 00 00 
  803e08:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e14:	83 e0 01             	and    $0x1,%eax
  803e17:	48 85 c0             	test   %rax,%rax
  803e1a:	75 07                	jne    803e23 <pageref+0x64>
		return 0;
  803e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e21:	eb 23                	jmp    803e46 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e27:	48 c1 e8 0c          	shr    $0xc,%rax
  803e2b:	48 89 c2             	mov    %rax,%rdx
  803e2e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e35:	00 00 00 
  803e38:	48 c1 e2 04          	shl    $0x4,%rdx
  803e3c:	48 01 d0             	add    %rdx,%rax
  803e3f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e43:	0f b7 c0             	movzwl %ax,%eax
}
  803e46:	c9                   	leaveq 
  803e47:	c3                   	retq   
