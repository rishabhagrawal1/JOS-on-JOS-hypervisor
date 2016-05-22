
vmm/guest/obj/user/idle:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba a0 39 80 00 00 	movabs $0x8039a0,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	25 ff 03 00 00       	and    $0x3ff,%eax
  800097:	48 98                	cltq   
  800099:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8000a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000a7:	00 00 00 
  8000aa:	48 01 c2             	add    %rax,%rdx
  8000ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000b4:	00 00 00 
  8000b7:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000be:	7e 14                	jle    8000d4 <libmain+0x5d>
		binaryname = argv[0];
  8000c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c4:	48 8b 10             	mov    (%rax),%rdx
  8000c7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000ce:	00 00 00 
  8000d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000db:	48 89 d6             	mov    %rdx,%rsi
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8000ec:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	c9                   	leaveq 
  8000f9:	c3                   	retq   

00000000008000fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000fe:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80010a:	bf 00 00 00 00       	mov    $0x0,%edi
  80010f:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  800116:	00 00 00 
  800119:	ff d0                	callq  *%rax

}
  80011b:	5d                   	pop    %rbp
  80011c:	c3                   	retq   

000000000080011d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011d:	55                   	push   %rbp
  80011e:	48 89 e5             	mov    %rsp,%rbp
  800121:	53                   	push   %rbx
  800122:	48 83 ec 48          	sub    $0x48,%rsp
  800126:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800129:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800130:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800134:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800138:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800143:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800147:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800153:	4c 89 c3             	mov    %r8,%rbx
  800156:	cd 30                	int    $0x30
  800158:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800160:	74 3e                	je     8001a0 <syscall+0x83>
  800162:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800167:	7e 37                	jle    8001a0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800169:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800170:	49 89 d0             	mov    %rdx,%r8
  800173:	89 c1                	mov    %eax,%ecx
  800175:	48 ba af 39 80 00 00 	movabs $0x8039af,%rdx
  80017c:	00 00 00 
  80017f:	be 23 00 00 00       	mov    $0x23,%esi
  800184:	48 bf cc 39 80 00 00 	movabs $0x8039cc,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 90 1e 80 00 00 	movabs $0x801e90,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9

	return ret;
  8001a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a4:	48 83 c4 48          	add    $0x48,%rsp
  8001a8:	5b                   	pop    %rbx
  8001a9:	5d                   	pop    %rbp
  8001aa:	c3                   	retq   

00000000008001ab <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ab:	55                   	push   %rbp
  8001ac:	48 89 e5             	mov    %rsp,%rbp
  8001af:	48 83 ec 20          	sub    $0x20,%rsp
  8001b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ca:	00 
  8001cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d7:	48 89 d1             	mov    %rdx,%rcx
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	be 00 00 00 00       	mov    $0x0,%esi
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
}
  8001f3:	c9                   	leaveq 
  8001f4:	c3                   	retq   

00000000008001f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
  8001f9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800204:	00 
  800205:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800211:	b9 00 00 00 00       	mov    $0x0,%ecx
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
  80021b:	be 00 00 00 00       	mov    $0x0,%esi
  800220:	bf 01 00 00 00       	mov    $0x1,%edi
  800225:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
}
  800231:	c9                   	leaveq 
  800232:	c3                   	retq   

0000000000800233 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	48 83 ec 10          	sub    $0x10,%rsp
  80023b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800241:	48 98                	cltq   
  800243:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024a:	00 
  80024b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800251:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800257:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025c:	48 89 c2             	mov    %rax,%rdx
  80025f:	be 01 00 00 00       	mov    $0x1,%esi
  800264:	bf 03 00 00 00       	mov    $0x3,%edi
  800269:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
}
  800275:	c9                   	leaveq 
  800276:	c3                   	retq   

0000000000800277 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800286:	00 
  800287:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800293:	b9 00 00 00 00       	mov    $0x0,%ecx
  800298:	ba 00 00 00 00       	mov    $0x0,%edx
  80029d:	be 00 00 00 00       	mov    $0x0,%esi
  8002a2:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a7:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	callq  *%rax
}
  8002b3:	c9                   	leaveq 
  8002b4:	c3                   	retq   

00000000008002b5 <sys_yield>:

void
sys_yield(void)
{
  8002b5:	55                   	push   %rbp
  8002b6:	48 89 e5             	mov    %rsp,%rbp
  8002b9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c4:	00 
  8002c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002db:	be 00 00 00 00       	mov    $0x0,%esi
  8002e0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002e5:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
}
  8002f1:	c9                   	leaveq 
  8002f2:	c3                   	retq   

00000000008002f3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f3:	55                   	push   %rbp
  8002f4:	48 89 e5             	mov    %rsp,%rbp
  8002f7:	48 83 ec 20          	sub    $0x20,%rsp
  8002fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800302:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800305:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800308:	48 63 c8             	movslq %eax,%rcx
  80030b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800312:	48 98                	cltq   
  800314:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80031b:	00 
  80031c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800322:	49 89 c8             	mov    %rcx,%r8
  800325:	48 89 d1             	mov    %rdx,%rcx
  800328:	48 89 c2             	mov    %rax,%rdx
  80032b:	be 01 00 00 00       	mov    $0x1,%esi
  800330:	bf 04 00 00 00       	mov    $0x4,%edi
  800335:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
}
  800341:	c9                   	leaveq 
  800342:	c3                   	retq   

0000000000800343 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800343:	55                   	push   %rbp
  800344:	48 89 e5             	mov    %rsp,%rbp
  800347:	48 83 ec 30          	sub    $0x30,%rsp
  80034b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800352:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800355:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800359:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800360:	48 63 c8             	movslq %eax,%rcx
  800363:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036a:	48 63 f0             	movslq %eax,%rsi
  80036d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800374:	48 98                	cltq   
  800376:	48 89 0c 24          	mov    %rcx,(%rsp)
  80037a:	49 89 f9             	mov    %rdi,%r9
  80037d:	49 89 f0             	mov    %rsi,%r8
  800380:	48 89 d1             	mov    %rdx,%rcx
  800383:	48 89 c2             	mov    %rax,%rdx
  800386:	be 01 00 00 00       	mov    $0x1,%esi
  80038b:	bf 05 00 00 00       	mov    $0x5,%edi
  800390:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800397:	00 00 00 
  80039a:	ff d0                	callq  *%rax
}
  80039c:	c9                   	leaveq 
  80039d:	c3                   	retq   

000000000080039e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80039e:	55                   	push   %rbp
  80039f:	48 89 e5             	mov    %rsp,%rbp
  8003a2:	48 83 ec 20          	sub    $0x20,%rsp
  8003a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b4:	48 98                	cltq   
  8003b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003bd:	00 
  8003be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ca:	48 89 d1             	mov    %rdx,%rcx
  8003cd:	48 89 c2             	mov    %rax,%rdx
  8003d0:	be 01 00 00 00       	mov    $0x1,%esi
  8003d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003da:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 83 ec 10          	sub    $0x10,%rsp
  8003f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f9:	48 63 d0             	movslq %eax,%rdx
  8003fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ff:	48 98                	cltq   
  800401:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800408:	00 
  800409:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80040f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800415:	48 89 d1             	mov    %rdx,%rcx
  800418:	48 89 c2             	mov    %rax,%rdx
  80041b:	be 01 00 00 00       	mov    $0x1,%esi
  800420:	bf 08 00 00 00       	mov    $0x8,%edi
  800425:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80042c:	00 00 00 
  80042f:	ff d0                	callq  *%rax
}
  800431:	c9                   	leaveq 
  800432:	c3                   	retq   

0000000000800433 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800433:	55                   	push   %rbp
  800434:	48 89 e5             	mov    %rsp,%rbp
  800437:	48 83 ec 20          	sub    $0x20,%rsp
  80043b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80043e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800442:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800449:	48 98                	cltq   
  80044b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800452:	00 
  800453:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800459:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045f:	48 89 d1             	mov    %rdx,%rcx
  800462:	48 89 c2             	mov    %rax,%rdx
  800465:	be 01 00 00 00       	mov    $0x1,%esi
  80046a:	bf 09 00 00 00       	mov    $0x9,%edi
  80046f:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
}
  80047b:	c9                   	leaveq 
  80047c:	c3                   	retq   

000000000080047d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80047d:	55                   	push   %rbp
  80047e:	48 89 e5             	mov    %rsp,%rbp
  800481:	48 83 ec 20          	sub    $0x20,%rsp
  800485:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800488:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80048c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800493:	48 98                	cltq   
  800495:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80049c:	00 
  80049d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004a9:	48 89 d1             	mov    %rdx,%rcx
  8004ac:	48 89 c2             	mov    %rax,%rdx
  8004af:	be 01 00 00 00       	mov    $0x1,%esi
  8004b4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004b9:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
}
  8004c5:	c9                   	leaveq 
  8004c6:	c3                   	retq   

00000000008004c7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	48 83 ec 20          	sub    $0x20,%rsp
  8004cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004da:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004e0:	48 63 f0             	movslq %eax,%rsi
  8004e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ea:	48 98                	cltq   
  8004ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004f7:	00 
  8004f8:	49 89 f1             	mov    %rsi,%r9
  8004fb:	49 89 c8             	mov    %rcx,%r8
  8004fe:	48 89 d1             	mov    %rdx,%rcx
  800501:	48 89 c2             	mov    %rax,%rdx
  800504:	be 00 00 00 00       	mov    $0x0,%esi
  800509:	bf 0c 00 00 00       	mov    $0xc,%edi
  80050e:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax
}
  80051a:	c9                   	leaveq 
  80051b:	c3                   	retq   

000000000080051c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	48 83 ec 10          	sub    $0x10,%rsp
  800524:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800533:	00 
  800534:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80053a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	48 89 c2             	mov    %rax,%rdx
  800548:	be 01 00 00 00       	mov    $0x1,%esi
  80054d:	bf 0d 00 00 00       	mov    $0xd,%edi
  800552:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800559:	00 00 00 
  80055c:	ff d0                	callq  *%rax
}
  80055e:	c9                   	leaveq 
  80055f:	c3                   	retq   

0000000000800560 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800560:	55                   	push   %rbp
  800561:	48 89 e5             	mov    %rsp,%rbp
  800564:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800568:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80056f:	00 
  800570:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800576:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80057c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
  800586:	be 00 00 00 00       	mov    $0x0,%esi
  80058b:	bf 0e 00 00 00       	mov    $0xe,%edi
  800590:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800597:	00 00 00 
  80059a:	ff d0                	callq  *%rax
}
  80059c:	c9                   	leaveq 
  80059d:	c3                   	retq   

000000000080059e <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	48 83 ec 30          	sub    $0x30,%rsp
  8005a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005ad:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8005b0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005b4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8005b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005bb:	48 63 c8             	movslq %eax,%rcx
  8005be:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8005c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005c5:	48 63 f0             	movslq %eax,%rsi
  8005c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005cf:	48 98                	cltq   
  8005d1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005d5:	49 89 f9             	mov    %rdi,%r9
  8005d8:	49 89 f0             	mov    %rsi,%r8
  8005db:	48 89 d1             	mov    %rdx,%rcx
  8005de:	48 89 c2             	mov    %rax,%rdx
  8005e1:	be 00 00 00 00       	mov    $0x0,%esi
  8005e6:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005eb:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8005f2:	00 00 00 
  8005f5:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8005f7:	c9                   	leaveq 
  8005f8:	c3                   	retq   

00000000008005f9 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8005f9:	55                   	push   %rbp
  8005fa:	48 89 e5             	mov    %rsp,%rbp
  8005fd:	48 83 ec 20          	sub    $0x20,%rsp
  800601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800605:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800609:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80060d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800611:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800618:	00 
  800619:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80061f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800625:	48 89 d1             	mov    %rdx,%rcx
  800628:	48 89 c2             	mov    %rax,%rdx
  80062b:	be 00 00 00 00       	mov    $0x0,%esi
  800630:	bf 10 00 00 00       	mov    $0x10,%edi
  800635:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80063c:	00 00 00 
  80063f:	ff d0                	callq  *%rax
}
  800641:	c9                   	leaveq 
  800642:	c3                   	retq   

0000000000800643 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800643:	55                   	push   %rbp
  800644:	48 89 e5             	mov    %rsp,%rbp
  800647:	48 83 ec 08          	sub    $0x8,%rsp
  80064b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80064f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800653:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80065a:	ff ff ff 
  80065d:	48 01 d0             	add    %rdx,%rax
  800660:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800676:	48 89 c7             	mov    %rax,%rdi
  800679:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  800680:	00 00 00 
  800683:	ff d0                	callq  *%rax
  800685:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80068b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80068f:	c9                   	leaveq 
  800690:	c3                   	retq   

0000000000800691 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800691:	55                   	push   %rbp
  800692:	48 89 e5             	mov    %rsp,%rbp
  800695:	48 83 ec 18          	sub    $0x18,%rsp
  800699:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80069d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006a4:	eb 6b                	jmp    800711 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006a9:	48 98                	cltq   
  8006ab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006b1:	48 c1 e0 0c          	shl    $0xc,%rax
  8006b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006bd:	48 c1 e8 15          	shr    $0x15,%rax
  8006c1:	48 89 c2             	mov    %rax,%rdx
  8006c4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006cb:	01 00 00 
  8006ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006d2:	83 e0 01             	and    $0x1,%eax
  8006d5:	48 85 c0             	test   %rax,%rax
  8006d8:	74 21                	je     8006fb <fd_alloc+0x6a>
  8006da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006de:	48 c1 e8 0c          	shr    $0xc,%rax
  8006e2:	48 89 c2             	mov    %rax,%rdx
  8006e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006ec:	01 00 00 
  8006ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006f3:	83 e0 01             	and    $0x1,%eax
  8006f6:	48 85 c0             	test   %rax,%rax
  8006f9:	75 12                	jne    80070d <fd_alloc+0x7c>
			*fd_store = fd;
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800703:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800706:	b8 00 00 00 00       	mov    $0x0,%eax
  80070b:	eb 1a                	jmp    800727 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80070d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800711:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800715:	7e 8f                	jle    8006a6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800722:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800727:	c9                   	leaveq 
  800728:	c3                   	retq   

0000000000800729 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800729:	55                   	push   %rbp
  80072a:	48 89 e5             	mov    %rsp,%rbp
  80072d:	48 83 ec 20          	sub    $0x20,%rsp
  800731:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800734:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800738:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80073c:	78 06                	js     800744 <fd_lookup+0x1b>
  80073e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800742:	7e 07                	jle    80074b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800749:	eb 6c                	jmp    8007b7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80074b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80074e:	48 98                	cltq   
  800750:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800756:	48 c1 e0 0c          	shl    $0xc,%rax
  80075a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80075e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800762:	48 c1 e8 15          	shr    $0x15,%rax
  800766:	48 89 c2             	mov    %rax,%rdx
  800769:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800770:	01 00 00 
  800773:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800777:	83 e0 01             	and    $0x1,%eax
  80077a:	48 85 c0             	test   %rax,%rax
  80077d:	74 21                	je     8007a0 <fd_lookup+0x77>
  80077f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800783:	48 c1 e8 0c          	shr    $0xc,%rax
  800787:	48 89 c2             	mov    %rax,%rdx
  80078a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800791:	01 00 00 
  800794:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800798:	83 e0 01             	and    $0x1,%eax
  80079b:	48 85 c0             	test   %rax,%rax
  80079e:	75 07                	jne    8007a7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a5:	eb 10                	jmp    8007b7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007af:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007b7:	c9                   	leaveq 
  8007b8:	c3                   	retq   

00000000008007b9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007b9:	55                   	push   %rbp
  8007ba:	48 89 e5             	mov    %rsp,%rbp
  8007bd:	48 83 ec 30          	sub    $0x30,%rsp
  8007c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007c5:	89 f0                	mov    %esi,%eax
  8007c7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ce:	48 89 c7             	mov    %rax,%rdi
  8007d1:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  8007d8:	00 00 00 
  8007db:	ff d0                	callq  *%rax
  8007dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8007e1:	48 89 d6             	mov    %rdx,%rsi
  8007e4:	89 c7                	mov    %eax,%edi
  8007e6:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	callq  *%rax
  8007f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007f9:	78 0a                	js     800805 <fd_close+0x4c>
	    || fd != fd2)
  8007fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ff:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800803:	74 12                	je     800817 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800805:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800809:	74 05                	je     800810 <fd_close+0x57>
  80080b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80080e:	eb 05                	jmp    800815 <fd_close+0x5c>
  800810:	b8 00 00 00 00       	mov    $0x0,%eax
  800815:	eb 69                	jmp    800880 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081b:	8b 00                	mov    (%rax),%eax
  80081d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800821:	48 89 d6             	mov    %rdx,%rsi
  800824:	89 c7                	mov    %eax,%edi
  800826:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  80082d:	00 00 00 
  800830:	ff d0                	callq  *%rax
  800832:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800835:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800839:	78 2a                	js     800865 <fd_close+0xac>
		if (dev->dev_close)
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800843:	48 85 c0             	test   %rax,%rax
  800846:	74 16                	je     80085e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 40 20          	mov    0x20(%rax),%rax
  800850:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800854:	48 89 d7             	mov    %rdx,%rdi
  800857:	ff d0                	callq  *%rax
  800859:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80085c:	eb 07                	jmp    800865 <fd_close+0xac>
		else
			r = 0;
  80085e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800869:	48 89 c6             	mov    %rax,%rsi
  80086c:	bf 00 00 00 00       	mov    $0x0,%edi
  800871:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800878:	00 00 00 
  80087b:	ff d0                	callq  *%rax
	return r;
  80087d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800880:	c9                   	leaveq 
  800881:	c3                   	retq   

0000000000800882 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800882:	55                   	push   %rbp
  800883:	48 89 e5             	mov    %rsp,%rbp
  800886:	48 83 ec 20          	sub    $0x20,%rsp
  80088a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80088d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800891:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800898:	eb 41                	jmp    8008db <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80089a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008a1:	00 00 00 
  8008a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008a7:	48 63 d2             	movslq %edx,%rdx
  8008aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008ae:	8b 00                	mov    (%rax),%eax
  8008b0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008b3:	75 22                	jne    8008d7 <dev_lookup+0x55>
			*dev = devtab[i];
  8008b5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008bc:	00 00 00 
  8008bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008c2:	48 63 d2             	movslq %edx,%rdx
  8008c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008cd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d5:	eb 60                	jmp    800937 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008db:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8008e2:	00 00 00 
  8008e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008e8:	48 63 d2             	movslq %edx,%rdx
  8008eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008ef:	48 85 c0             	test   %rax,%rax
  8008f2:	75 a6                	jne    80089a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008f4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008fb:	00 00 00 
  8008fe:	48 8b 00             	mov    (%rax),%rax
  800901:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800907:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80090a:	89 c6                	mov    %eax,%esi
  80090c:	48 bf e0 39 80 00 00 	movabs $0x8039e0,%rdi
  800913:	00 00 00 
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	48 b9 c9 20 80 00 00 	movabs $0x8020c9,%rcx
  800922:	00 00 00 
  800925:	ff d1                	callq  *%rcx
	*dev = 0;
  800927:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80092b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800932:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800937:	c9                   	leaveq 
  800938:	c3                   	retq   

0000000000800939 <close>:

int
close(int fdnum)
{
  800939:	55                   	push   %rbp
  80093a:	48 89 e5             	mov    %rsp,%rbp
  80093d:	48 83 ec 20          	sub    $0x20,%rsp
  800941:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800944:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800948:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80094b:	48 89 d6             	mov    %rdx,%rsi
  80094e:	89 c7                	mov    %eax,%edi
  800950:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800957:	00 00 00 
  80095a:	ff d0                	callq  *%rax
  80095c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80095f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800963:	79 05                	jns    80096a <close+0x31>
		return r;
  800965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800968:	eb 18                	jmp    800982 <close+0x49>
	else
		return fd_close(fd, 1);
  80096a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80096e:	be 01 00 00 00       	mov    $0x1,%esi
  800973:	48 89 c7             	mov    %rax,%rdi
  800976:	48 b8 b9 07 80 00 00 	movabs $0x8007b9,%rax
  80097d:	00 00 00 
  800980:	ff d0                	callq  *%rax
}
  800982:	c9                   	leaveq 
  800983:	c3                   	retq   

0000000000800984 <close_all>:

void
close_all(void)
{
  800984:	55                   	push   %rbp
  800985:	48 89 e5             	mov    %rsp,%rbp
  800988:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80098c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800993:	eb 15                	jmp    8009aa <close_all+0x26>
		close(i);
  800995:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800998:	89 c7                	mov    %eax,%edi
  80099a:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009aa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009ae:	7e e5                	jle    800995 <close_all+0x11>
		close(i);
}
  8009b0:	c9                   	leaveq 
  8009b1:	c3                   	retq   

00000000008009b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009b2:	55                   	push   %rbp
  8009b3:	48 89 e5             	mov    %rsp,%rbp
  8009b6:	48 83 ec 40          	sub    $0x40,%rsp
  8009ba:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009bd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009c0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009c4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009c7:	48 89 d6             	mov    %rdx,%rsi
  8009ca:	89 c7                	mov    %eax,%edi
  8009cc:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  8009d3:	00 00 00 
  8009d6:	ff d0                	callq  *%rax
  8009d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009df:	79 08                	jns    8009e9 <dup+0x37>
		return r;
  8009e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009e4:	e9 70 01 00 00       	jmpq   800b59 <dup+0x1a7>
	close(newfdnum);
  8009e9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009ec:	89 c7                	mov    %eax,%edi
  8009ee:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8009f5:	00 00 00 
  8009f8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009fd:	48 98                	cltq   
  8009ff:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a05:	48 c1 e0 0c          	shl    $0xc,%rax
  800a09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a11:	48 89 c7             	mov    %rax,%rdi
  800a14:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  800a1b:	00 00 00 
  800a1e:	ff d0                	callq  *%rax
  800a20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a28:	48 89 c7             	mov    %rax,%rdi
  800a2b:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  800a32:	00 00 00 
  800a35:	ff d0                	callq  *%rax
  800a37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3f:	48 c1 e8 15          	shr    $0x15,%rax
  800a43:	48 89 c2             	mov    %rax,%rdx
  800a46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a4d:	01 00 00 
  800a50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a54:	83 e0 01             	and    $0x1,%eax
  800a57:	48 85 c0             	test   %rax,%rax
  800a5a:	74 73                	je     800acf <dup+0x11d>
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 c1 e8 0c          	shr    $0xc,%rax
  800a64:	48 89 c2             	mov    %rax,%rdx
  800a67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a6e:	01 00 00 
  800a71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a75:	83 e0 01             	and    $0x1,%eax
  800a78:	48 85 c0             	test   %rax,%rax
  800a7b:	74 52                	je     800acf <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 c1 e8 0c          	shr    $0xc,%rax
  800a85:	48 89 c2             	mov    %rax,%rdx
  800a88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a8f:	01 00 00 
  800a92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a96:	25 07 0e 00 00       	and    $0xe07,%eax
  800a9b:	89 c1                	mov    %eax,%ecx
  800a9d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa5:	41 89 c8             	mov    %ecx,%r8d
  800aa8:	48 89 d1             	mov    %rdx,%rcx
  800aab:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab0:	48 89 c6             	mov    %rax,%rsi
  800ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab8:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800abf:	00 00 00 
  800ac2:	ff d0                	callq  *%rax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ac7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800acb:	79 02                	jns    800acf <dup+0x11d>
			goto err;
  800acd:	eb 57                	jmp    800b26 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800acf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ad3:	48 c1 e8 0c          	shr    $0xc,%rax
  800ad7:	48 89 c2             	mov    %rax,%rdx
  800ada:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ae1:	01 00 00 
  800ae4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ae8:	25 07 0e 00 00       	and    $0xe07,%eax
  800aed:	89 c1                	mov    %eax,%ecx
  800aef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800af3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800af7:	41 89 c8             	mov    %ecx,%r8d
  800afa:	48 89 d1             	mov    %rdx,%rcx
  800afd:	ba 00 00 00 00       	mov    $0x0,%edx
  800b02:	48 89 c6             	mov    %rax,%rsi
  800b05:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0a:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800b11:	00 00 00 
  800b14:	ff d0                	callq  *%rax
  800b16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b1d:	79 02                	jns    800b21 <dup+0x16f>
		goto err;
  800b1f:	eb 05                	jmp    800b26 <dup+0x174>

	return newfdnum;
  800b21:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b24:	eb 33                	jmp    800b59 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2a:	48 89 c6             	mov    %rax,%rsi
  800b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b32:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800b39:	00 00 00 
  800b3c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b42:	48 89 c6             	mov    %rax,%rsi
  800b45:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4a:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
	return r;
  800b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b59:	c9                   	leaveq 
  800b5a:	c3                   	retq   

0000000000800b5b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b5b:	55                   	push   %rbp
  800b5c:	48 89 e5             	mov    %rsp,%rbp
  800b5f:	48 83 ec 40          	sub    $0x40,%rsp
  800b63:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b6e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b75:	48 89 d6             	mov    %rdx,%rsi
  800b78:	89 c7                	mov    %eax,%edi
  800b7a:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b8d:	78 24                	js     800bb3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b93:	8b 00                	mov    (%rax),%eax
  800b95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b99:	48 89 d6             	mov    %rdx,%rsi
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800ba5:	00 00 00 
  800ba8:	ff d0                	callq  *%rax
  800baa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bb1:	79 05                	jns    800bb8 <read+0x5d>
		return r;
  800bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bb6:	eb 76                	jmp    800c2e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbc:	8b 40 08             	mov    0x8(%rax),%eax
  800bbf:	83 e0 03             	and    $0x3,%eax
  800bc2:	83 f8 01             	cmp    $0x1,%eax
  800bc5:	75 3a                	jne    800c01 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bc7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bce:	00 00 00 
  800bd1:	48 8b 00             	mov    (%rax),%rax
  800bd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800bda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800bdd:	89 c6                	mov    %eax,%esi
  800bdf:	48 bf ff 39 80 00 00 	movabs $0x8039ff,%rdi
  800be6:	00 00 00 
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	48 b9 c9 20 80 00 00 	movabs $0x8020c9,%rcx
  800bf5:	00 00 00 
  800bf8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800bfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bff:	eb 2d                	jmp    800c2e <read+0xd3>
	}
	if (!dev->dev_read)
  800c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c05:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c09:	48 85 c0             	test   %rax,%rax
  800c0c:	75 07                	jne    800c15 <read+0xba>
		return -E_NOT_SUPP;
  800c0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c13:	eb 19                	jmp    800c2e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c19:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c25:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c29:	48 89 cf             	mov    %rcx,%rdi
  800c2c:	ff d0                	callq  *%rax
}
  800c2e:	c9                   	leaveq 
  800c2f:	c3                   	retq   

0000000000800c30 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c30:	55                   	push   %rbp
  800c31:	48 89 e5             	mov    %rsp,%rbp
  800c34:	48 83 ec 30          	sub    $0x30,%rsp
  800c38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c4a:	eb 49                	jmp    800c95 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4f:	48 98                	cltq   
  800c51:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c55:	48 29 c2             	sub    %rax,%rdx
  800c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c5b:	48 63 c8             	movslq %eax,%rcx
  800c5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c62:	48 01 c1             	add    %rax,%rcx
  800c65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c68:	48 89 ce             	mov    %rcx,%rsi
  800c6b:	89 c7                	mov    %eax,%edi
  800c6d:	48 b8 5b 0b 80 00 00 	movabs $0x800b5b,%rax
  800c74:	00 00 00 
  800c77:	ff d0                	callq  *%rax
  800c79:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c7c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c80:	79 05                	jns    800c87 <readn+0x57>
			return m;
  800c82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c85:	eb 1c                	jmp    800ca3 <readn+0x73>
		if (m == 0)
  800c87:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c8b:	75 02                	jne    800c8f <readn+0x5f>
			break;
  800c8d:	eb 11                	jmp    800ca0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c92:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c98:	48 98                	cltq   
  800c9a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c9e:	72 ac                	jb     800c4c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ca3:	c9                   	leaveq 
  800ca4:	c3                   	retq   

0000000000800ca5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800ca5:	55                   	push   %rbp
  800ca6:	48 89 e5             	mov    %rsp,%rbp
  800ca9:	48 83 ec 40          	sub    $0x40,%rsp
  800cad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cb0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cb4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cb8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cbc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cbf:	48 89 d6             	mov    %rdx,%rsi
  800cc2:	89 c7                	mov    %eax,%edi
  800cc4:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800ccb:	00 00 00 
  800cce:	ff d0                	callq  *%rax
  800cd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cd7:	78 24                	js     800cfd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdd:	8b 00                	mov    (%rax),%eax
  800cdf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ce3:	48 89 d6             	mov    %rdx,%rsi
  800ce6:	89 c7                	mov    %eax,%edi
  800ce8:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800cef:	00 00 00 
  800cf2:	ff d0                	callq  *%rax
  800cf4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cfb:	79 05                	jns    800d02 <write+0x5d>
		return r;
  800cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d00:	eb 42                	jmp    800d44 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d06:	8b 40 08             	mov    0x8(%rax),%eax
  800d09:	83 e0 03             	and    $0x3,%eax
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	75 07                	jne    800d17 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800d10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d15:	eb 2d                	jmp    800d44 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d1b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d1f:	48 85 c0             	test   %rax,%rax
  800d22:	75 07                	jne    800d2b <write+0x86>
		return -E_NOT_SUPP;
  800d24:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d29:	eb 19                	jmp    800d44 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  800d2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d33:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d3b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d3f:	48 89 cf             	mov    %rcx,%rdi
  800d42:	ff d0                	callq  *%rax
}
  800d44:	c9                   	leaveq 
  800d45:	c3                   	retq   

0000000000800d46 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d46:	55                   	push   %rbp
  800d47:	48 89 e5             	mov    %rsp,%rbp
  800d4a:	48 83 ec 18          	sub    $0x18,%rsp
  800d4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d51:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	89 c7                	mov    %eax,%edi
  800d60:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800d67:	00 00 00 
  800d6a:	ff d0                	callq  *%rax
  800d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d73:	79 05                	jns    800d7a <seek+0x34>
		return r;
  800d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d78:	eb 0f                	jmp    800d89 <seek+0x43>
	fd->fd_offset = offset;
  800d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800d81:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d89:	c9                   	leaveq 
  800d8a:	c3                   	retq   

0000000000800d8b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d8b:	55                   	push   %rbp
  800d8c:	48 89 e5             	mov    %rsp,%rbp
  800d8f:	48 83 ec 30          	sub    $0x30,%rsp
  800d93:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d96:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d99:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d9d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800da0:	48 89 d6             	mov    %rdx,%rsi
  800da3:	89 c7                	mov    %eax,%edi
  800da5:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800dac:	00 00 00 
  800daf:	ff d0                	callq  *%rax
  800db1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800db8:	78 24                	js     800dde <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbe:	8b 00                	mov    (%rax),%eax
  800dc0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	89 c7                	mov    %eax,%edi
  800dc9:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800dd0:	00 00 00 
  800dd3:	ff d0                	callq  *%rax
  800dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ddc:	79 05                	jns    800de3 <ftruncate+0x58>
		return r;
  800dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800de1:	eb 72                	jmp    800e55 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	8b 40 08             	mov    0x8(%rax),%eax
  800dea:	83 e0 03             	and    $0x3,%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	75 3a                	jne    800e2b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800df1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800df8:	00 00 00 
  800dfb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800dfe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e04:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e07:	89 c6                	mov    %eax,%esi
  800e09:	48 bf 20 3a 80 00 00 	movabs $0x803a20,%rdi
  800e10:	00 00 00 
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
  800e18:	48 b9 c9 20 80 00 00 	movabs $0x8020c9,%rcx
  800e1f:	00 00 00 
  800e22:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e29:	eb 2a                	jmp    800e55 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2f:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e33:	48 85 c0             	test   %rax,%rax
  800e36:	75 07                	jne    800e3f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e3d:	eb 16                	jmp    800e55 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e43:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e4e:	89 ce                	mov    %ecx,%esi
  800e50:	48 89 d7             	mov    %rdx,%rdi
  800e53:	ff d0                	callq  *%rax
}
  800e55:	c9                   	leaveq 
  800e56:	c3                   	retq   

0000000000800e57 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e57:	55                   	push   %rbp
  800e58:	48 89 e5             	mov    %rsp,%rbp
  800e5b:	48 83 ec 30          	sub    $0x30,%rsp
  800e5f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e62:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e6d:	48 89 d6             	mov    %rdx,%rsi
  800e70:	89 c7                	mov    %eax,%edi
  800e72:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e85:	78 24                	js     800eab <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	8b 00                	mov    (%rax),%eax
  800e8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e91:	48 89 d6             	mov    %rdx,%rsi
  800e94:	89 c7                	mov    %eax,%edi
  800e96:	48 b8 82 08 80 00 00 	movabs $0x800882,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
  800ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ea9:	79 05                	jns    800eb0 <fstat+0x59>
		return r;
  800eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eae:	eb 5e                	jmp    800f0e <fstat+0xb7>
	if (!dev->dev_stat)
  800eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb4:	48 8b 40 28          	mov    0x28(%rax),%rax
  800eb8:	48 85 c0             	test   %rax,%rax
  800ebb:	75 07                	jne    800ec4 <fstat+0x6d>
		return -E_NOT_SUPP;
  800ebd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ec2:	eb 4a                	jmp    800f0e <fstat+0xb7>
	stat->st_name[0] = 0;
  800ec4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800ecb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ecf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800ed6:	00 00 00 
	stat->st_isdir = 0;
  800ed9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800edd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800ee4:	00 00 00 
	stat->st_dev = dev;
  800ee7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eeb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eef:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efa:	48 8b 40 28          	mov    0x28(%rax),%rax
  800efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f02:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f06:	48 89 ce             	mov    %rcx,%rsi
  800f09:	48 89 d7             	mov    %rdx,%rdi
  800f0c:	ff d0                	callq  *%rax
}
  800f0e:	c9                   	leaveq 
  800f0f:	c3                   	retq   

0000000000800f10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	48 83 ec 20          	sub    $0x20,%rsp
  800f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f24:	be 00 00 00 00       	mov    $0x0,%esi
  800f29:	48 89 c7             	mov    %rax,%rdi
  800f2c:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  800f33:	00 00 00 
  800f36:	ff d0                	callq  *%rax
  800f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f3f:	79 05                	jns    800f46 <stat+0x36>
		return fd;
  800f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f44:	eb 2f                	jmp    800f75 <stat+0x65>
	r = fstat(fd, stat);
  800f46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4d:	48 89 d6             	mov    %rdx,%rsi
  800f50:	89 c7                	mov    %eax,%edi
  800f52:	48 b8 57 0e 80 00 00 	movabs $0x800e57,%rax
  800f59:	00 00 00 
  800f5c:	ff d0                	callq  *%rax
  800f5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f64:	89 c7                	mov    %eax,%edi
  800f66:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	callq  *%rax
	return r;
  800f72:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f75:	c9                   	leaveq 
  800f76:	c3                   	retq   

0000000000800f77 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f77:	55                   	push   %rbp
  800f78:	48 89 e5             	mov    %rsp,%rbp
  800f7b:	48 83 ec 10          	sub    $0x10,%rsp
  800f7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800f86:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f8d:	00 00 00 
  800f90:	8b 00                	mov    (%rax),%eax
  800f92:	85 c0                	test   %eax,%eax
  800f94:	75 1d                	jne    800fb3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f96:	bf 01 00 00 00       	mov    $0x1,%edi
  800f9b:	48 b8 a2 38 80 00 00 	movabs $0x8038a2,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
  800fa7:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800fae:	00 00 00 
  800fb1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fb3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fba:	00 00 00 
  800fbd:	8b 00                	mov    (%rax),%eax
  800fbf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fc2:	b9 07 00 00 00       	mov    $0x7,%ecx
  800fc7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fce:	00 00 00 
  800fd1:	89 c7                	mov    %eax,%edi
  800fd3:	48 b8 d5 34 80 00 00 	movabs $0x8034d5,%rax
  800fda:	00 00 00 
  800fdd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe8:	48 89 c6             	mov    %rax,%rsi
  800feb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff0:	48 b8 d7 33 80 00 00 	movabs $0x8033d7,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	callq  *%rax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 30          	sub    $0x30,%rsp
  801006:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80100a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80100d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  801014:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80101b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  801022:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801027:	75 08                	jne    801031 <open+0x33>
	{
		return r;
  801029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102c:	e9 f2 00 00 00       	jmpq   801123 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  801031:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801035:	48 89 c7             	mov    %rax,%rdi
  801038:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  80103f:	00 00 00 
  801042:	ff d0                	callq  *%rax
  801044:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801047:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80104e:	7e 0a                	jle    80105a <open+0x5c>
	{
		return -E_BAD_PATH;
  801050:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801055:	e9 c9 00 00 00       	jmpq   801123 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80105a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801061:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801062:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801066:	48 89 c7             	mov    %rax,%rdi
  801069:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  801070:	00 00 00 
  801073:	ff d0                	callq  *%rax
  801075:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801078:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80107c:	78 09                	js     801087 <open+0x89>
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	48 85 c0             	test   %rax,%rax
  801085:	75 08                	jne    80108f <open+0x91>
		{
			return r;
  801087:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108a:	e9 94 00 00 00       	jmpq   801123 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80108f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801093:	ba 00 04 00 00       	mov    $0x400,%edx
  801098:	48 89 c6             	mov    %rax,%rsi
  80109b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8010a2:	00 00 00 
  8010a5:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  8010ac:	00 00 00 
  8010af:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8010b1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010b8:	00 00 00 
  8010bb:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010be:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8010c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c8:	48 89 c6             	mov    %rax,%rsi
  8010cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8010d0:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  8010d7:	00 00 00 
  8010da:	ff d0                	callq  *%rax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010e3:	79 2b                	jns    801110 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8010e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e9:	be 00 00 00 00       	mov    $0x0,%esi
  8010ee:	48 89 c7             	mov    %rax,%rdi
  8010f1:	48 b8 b9 07 80 00 00 	movabs $0x8007b9,%rax
  8010f8:	00 00 00 
  8010fb:	ff d0                	callq  *%rax
  8010fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801100:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801104:	79 05                	jns    80110b <open+0x10d>
			{
				return d;
  801106:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801109:	eb 18                	jmp    801123 <open+0x125>
			}
			return r;
  80110b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80110e:	eb 13                	jmp    801123 <open+0x125>
		}	
		return fd2num(fd_store);
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 89 c7             	mov    %rax,%rdi
  801117:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  80111e:	00 00 00 
  801121:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801123:	c9                   	leaveq 
  801124:	c3                   	retq   

0000000000801125 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801125:	55                   	push   %rbp
  801126:	48 89 e5             	mov    %rsp,%rbp
  801129:	48 83 ec 10          	sub    $0x10,%rsp
  80112d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801135:	8b 50 0c             	mov    0xc(%rax),%edx
  801138:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80113f:	00 00 00 
  801142:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801144:	be 00 00 00 00       	mov    $0x0,%esi
  801149:	bf 06 00 00 00       	mov    $0x6,%edi
  80114e:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  801155:	00 00 00 
  801158:	ff d0                	callq  *%rax
}
  80115a:	c9                   	leaveq 
  80115b:	c3                   	retq   

000000000080115c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	48 83 ec 30          	sub    $0x30,%rsp
  801164:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801168:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801170:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801177:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117c:	74 07                	je     801185 <devfile_read+0x29>
  80117e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801183:	75 07                	jne    80118c <devfile_read+0x30>
		return -E_INVAL;
  801185:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118a:	eb 77                	jmp    801203 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	8b 50 0c             	mov    0xc(%rax),%edx
  801193:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80119a:	00 00 00 
  80119d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80119f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011a6:	00 00 00 
  8011a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011ad:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8011b1:	be 00 00 00 00       	mov    $0x0,%esi
  8011b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8011bb:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  8011c2:	00 00 00 
  8011c5:	ff d0                	callq  *%rax
  8011c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011ce:	7f 05                	jg     8011d5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8011d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d3:	eb 2e                	jmp    801203 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8011d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d8:	48 63 d0             	movslq %eax,%rdx
  8011db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011df:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011e6:	00 00 00 
  8011e9:	48 89 c7             	mov    %rax,%rdi
  8011ec:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  8011f3:	00 00 00 
  8011f6:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8011f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801200:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801203:	c9                   	leaveq 
  801204:	c3                   	retq   

0000000000801205 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801205:	55                   	push   %rbp
  801206:	48 89 e5             	mov    %rsp,%rbp
  801209:	48 83 ec 30          	sub    $0x30,%rsp
  80120d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801211:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801215:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801219:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801220:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801225:	74 07                	je     80122e <devfile_write+0x29>
  801227:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80122c:	75 08                	jne    801236 <devfile_write+0x31>
		return r;
  80122e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801231:	e9 9a 00 00 00       	jmpq   8012d0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	8b 50 0c             	mov    0xc(%rax),%edx
  80123d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801244:	00 00 00 
  801247:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801249:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801250:	00 
  801251:	76 08                	jbe    80125b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801253:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80125a:	00 
	}
	fsipcbuf.write.req_n = n;
  80125b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801262:	00 00 00 
  801265:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801269:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80126d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801275:	48 89 c6             	mov    %rax,%rsi
  801278:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80127f:	00 00 00 
  801282:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  801289:	00 00 00 
  80128c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80128e:	be 00 00 00 00       	mov    $0x0,%esi
  801293:	bf 04 00 00 00       	mov    $0x4,%edi
  801298:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  80129f:	00 00 00 
  8012a2:	ff d0                	callq  *%rax
  8012a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ab:	7f 20                	jg     8012cd <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8012ad:	48 bf 46 3a 80 00 00 	movabs $0x803a46,%rdi
  8012b4:	00 00 00 
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bc:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  8012c3:	00 00 00 
  8012c6:	ff d2                	callq  *%rdx
		return r;
  8012c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012cb:	eb 03                	jmp    8012d0 <devfile_write+0xcb>
	}
	return r;
  8012cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8012d0:	c9                   	leaveq 
  8012d1:	c3                   	retq   

00000000008012d2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012d2:	55                   	push   %rbp
  8012d3:	48 89 e5             	mov    %rsp,%rbp
  8012d6:	48 83 ec 20          	sub    $0x20,%rsp
  8012da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e6:	8b 50 0c             	mov    0xc(%rax),%edx
  8012e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012f0:	00 00 00 
  8012f3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012f5:	be 00 00 00 00       	mov    $0x0,%esi
  8012fa:	bf 05 00 00 00       	mov    $0x5,%edi
  8012ff:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  801306:	00 00 00 
  801309:	ff d0                	callq  *%rax
  80130b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80130e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801312:	79 05                	jns    801319 <devfile_stat+0x47>
		return r;
  801314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801317:	eb 56                	jmp    80136f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801324:	00 00 00 
  801327:	48 89 c7             	mov    %rax,%rdi
  80132a:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  801331:	00 00 00 
  801334:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801336:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80133d:	00 00 00 
  801340:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801346:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801350:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801357:	00 00 00 
  80135a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801360:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801364:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136f:	c9                   	leaveq 
  801370:	c3                   	retq   

0000000000801371 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801371:	55                   	push   %rbp
  801372:	48 89 e5             	mov    %rsp,%rbp
  801375:	48 83 ec 10          	sub    $0x10,%rsp
  801379:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80137d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	8b 50 0c             	mov    0xc(%rax),%edx
  801387:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80138e:	00 00 00 
  801391:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801393:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80139a:	00 00 00 
  80139d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013a0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013a3:	be 00 00 00 00       	mov    $0x0,%esi
  8013a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8013ad:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	callq  *%rax
}
  8013b9:	c9                   	leaveq 
  8013ba:	c3                   	retq   

00000000008013bb <remove>:

// Delete a file
int
remove(const char *path)
{
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	48 83 ec 10          	sub    $0x10,%rsp
  8013c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	48 89 c7             	mov    %rax,%rdi
  8013ce:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	callq  *%rax
  8013da:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013df:	7e 07                	jle    8013e8 <remove+0x2d>
		return -E_BAD_PATH;
  8013e1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8013e6:	eb 33                	jmp    80141b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	48 89 c6             	mov    %rax,%rsi
  8013ef:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8013f6:	00 00 00 
  8013f9:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  801400:	00 00 00 
  801403:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801405:	be 00 00 00 00       	mov    $0x0,%esi
  80140a:	bf 07 00 00 00       	mov    $0x7,%edi
  80140f:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  801416:	00 00 00 
  801419:	ff d0                	callq  *%rax
}
  80141b:	c9                   	leaveq 
  80141c:	c3                   	retq   

000000000080141d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80141d:	55                   	push   %rbp
  80141e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801421:	be 00 00 00 00       	mov    $0x0,%esi
  801426:	bf 08 00 00 00       	mov    $0x8,%edi
  80142b:	48 b8 77 0f 80 00 00 	movabs $0x800f77,%rax
  801432:	00 00 00 
  801435:	ff d0                	callq  *%rax
}
  801437:	5d                   	pop    %rbp
  801438:	c3                   	retq   

0000000000801439 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801439:	55                   	push   %rbp
  80143a:	48 89 e5             	mov    %rsp,%rbp
  80143d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801444:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80144b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801452:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801459:	be 00 00 00 00       	mov    $0x0,%esi
  80145e:	48 89 c7             	mov    %rax,%rdi
  801461:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  801468:	00 00 00 
  80146b:	ff d0                	callq  *%rax
  80146d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801470:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801474:	79 28                	jns    80149e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801479:	89 c6                	mov    %eax,%esi
  80147b:	48 bf 62 3a 80 00 00 	movabs $0x803a62,%rdi
  801482:	00 00 00 
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
  80148a:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  801491:	00 00 00 
  801494:	ff d2                	callq  *%rdx
		return fd_src;
  801496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801499:	e9 74 01 00 00       	jmpq   801612 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80149e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014a5:	be 01 01 00 00       	mov    $0x101,%esi
  8014aa:	48 89 c7             	mov    %rax,%rdi
  8014ad:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  8014b4:	00 00 00 
  8014b7:	ff d0                	callq  *%rax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014c0:	79 39                	jns    8014fb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014c5:	89 c6                	mov    %eax,%esi
  8014c7:	48 bf 78 3a 80 00 00 	movabs $0x803a78,%rdi
  8014ce:	00 00 00 
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  8014dd:	00 00 00 
  8014e0:	ff d2                	callq  *%rdx
		close(fd_src);
  8014e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e5:	89 c7                	mov    %eax,%edi
  8014e7:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8014ee:	00 00 00 
  8014f1:	ff d0                	callq  *%rax
		return fd_dest;
  8014f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014f6:	e9 17 01 00 00       	jmpq   801612 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014fb:	eb 74                	jmp    801571 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8014fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801500:	48 63 d0             	movslq %eax,%rdx
  801503:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80150a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80150d:	48 89 ce             	mov    %rcx,%rsi
  801510:	89 c7                	mov    %eax,%edi
  801512:	48 b8 a5 0c 80 00 00 	movabs $0x800ca5,%rax
  801519:	00 00 00 
  80151c:	ff d0                	callq  *%rax
  80151e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801521:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801525:	79 4a                	jns    801571 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801527:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80152a:	89 c6                	mov    %eax,%esi
  80152c:	48 bf 92 3a 80 00 00 	movabs $0x803a92,%rdi
  801533:	00 00 00 
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  801542:	00 00 00 
  801545:	ff d2                	callq  *%rdx
			close(fd_src);
  801547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80154a:	89 c7                	mov    %eax,%edi
  80154c:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  801553:	00 00 00 
  801556:	ff d0                	callq  *%rax
			close(fd_dest);
  801558:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80155b:	89 c7                	mov    %eax,%edi
  80155d:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
			return write_size;
  801569:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80156c:	e9 a1 00 00 00       	jmpq   801612 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801571:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80157b:	ba 00 02 00 00       	mov    $0x200,%edx
  801580:	48 89 ce             	mov    %rcx,%rsi
  801583:	89 c7                	mov    %eax,%edi
  801585:	48 b8 5b 0b 80 00 00 	movabs $0x800b5b,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	callq  *%rax
  801591:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801594:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801598:	0f 8f 5f ff ff ff    	jg     8014fd <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80159e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015a2:	79 47                	jns    8015eb <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015a7:	89 c6                	mov    %eax,%esi
  8015a9:	48 bf a5 3a 80 00 00 	movabs $0x803aa5,%rdi
  8015b0:	00 00 00 
  8015b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b8:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  8015bf:	00 00 00 
  8015c2:	ff d2                	callq  *%rdx
		close(fd_src);
  8015c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015c7:	89 c7                	mov    %eax,%edi
  8015c9:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8015d0:	00 00 00 
  8015d3:	ff d0                	callq  *%rax
		close(fd_dest);
  8015d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015d8:	89 c7                	mov    %eax,%edi
  8015da:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
		return read_size;
  8015e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e9:	eb 27                	jmp    801612 <copy+0x1d9>
	}
	close(fd_src);
  8015eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ee:	89 c7                	mov    %eax,%edi
  8015f0:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  8015f7:	00 00 00 
  8015fa:	ff d0                	callq  *%rax
	close(fd_dest);
  8015fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015ff:	89 c7                	mov    %eax,%edi
  801601:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  801608:	00 00 00 
  80160b:	ff d0                	callq  *%rax
	return 0;
  80160d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801612:	c9                   	leaveq 
  801613:	c3                   	retq   

0000000000801614 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801614:	55                   	push   %rbp
  801615:	48 89 e5             	mov    %rsp,%rbp
  801618:	53                   	push   %rbx
  801619:	48 83 ec 38          	sub    $0x38,%rsp
  80161d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801621:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
  801634:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801637:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80163b:	0f 88 bf 01 00 00    	js     801800 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	ba 07 04 00 00       	mov    $0x407,%edx
  80164a:	48 89 c6             	mov    %rax,%rsi
  80164d:	bf 00 00 00 00       	mov    $0x0,%edi
  801652:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801659:	00 00 00 
  80165c:	ff d0                	callq  *%rax
  80165e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801661:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801665:	0f 88 95 01 00 00    	js     801800 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80166b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80166f:	48 89 c7             	mov    %rax,%rdi
  801672:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  801679:	00 00 00 
  80167c:	ff d0                	callq  *%rax
  80167e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801681:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801685:	0f 88 5d 01 00 00    	js     8017e8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80168b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80168f:	ba 07 04 00 00       	mov    $0x407,%edx
  801694:	48 89 c6             	mov    %rax,%rsi
  801697:	bf 00 00 00 00       	mov    $0x0,%edi
  80169c:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8016a3:	00 00 00 
  8016a6:	ff d0                	callq  *%rax
  8016a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016af:	0f 88 33 01 00 00    	js     8017e8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	48 89 c7             	mov    %rax,%rdi
  8016bc:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  8016c3:	00 00 00 
  8016c6:	ff d0                	callq  *%rax
  8016c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8016d5:	48 89 c6             	mov    %rax,%rsi
  8016d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016dd:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8016e4:	00 00 00 
  8016e7:	ff d0                	callq  *%rax
  8016e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016f0:	79 05                	jns    8016f7 <pipe+0xe3>
		goto err2;
  8016f2:	e9 d9 00 00 00       	jmpq   8017d0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fb:	48 89 c7             	mov    %rax,%rdi
  8016fe:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  801705:	00 00 00 
  801708:	ff d0                	callq  *%rax
  80170a:	48 89 c2             	mov    %rax,%rdx
  80170d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801711:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801717:	48 89 d1             	mov    %rdx,%rcx
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	48 89 c6             	mov    %rax,%rsi
  801722:	bf 00 00 00 00       	mov    $0x0,%edi
  801727:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  80172e:	00 00 00 
  801731:	ff d0                	callq  *%rax
  801733:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801736:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80173a:	79 1b                	jns    801757 <pipe+0x143>
		goto err3;
  80173c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80173d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801741:	48 89 c6             	mov    %rax,%rsi
  801744:	bf 00 00 00 00       	mov    $0x0,%edi
  801749:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
  801755:	eb 79                	jmp    8017d0 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801757:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175b:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801762:	00 00 00 
  801765:	8b 12                	mov    (%rdx),%edx
  801767:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801774:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801778:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80177f:	00 00 00 
  801782:	8b 12                	mov    (%rdx),%edx
  801784:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801786:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	48 89 c7             	mov    %rax,%rdi
  801798:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
  8017a4:	89 c2                	mov    %eax,%edx
  8017a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017aa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8017ac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017b0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8017b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b8:	48 89 c7             	mov    %rax,%rdi
  8017bb:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	callq  *%rax
  8017c7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	eb 33                	jmp    801803 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8017d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d4:	48 89 c6             	mov    %rax,%rsi
  8017d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8017dc:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8017e3:	00 00 00 
  8017e6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	48 89 c6             	mov    %rax,%rsi
  8017ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8017f4:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
err:
	return r;
  801800:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801803:	48 83 c4 38          	add    $0x38,%rsp
  801807:	5b                   	pop    %rbx
  801808:	5d                   	pop    %rbp
  801809:	c3                   	retq   

000000000080180a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80180a:	55                   	push   %rbp
  80180b:	48 89 e5             	mov    %rsp,%rbp
  80180e:	53                   	push   %rbx
  80180f:	48 83 ec 28          	sub    $0x28,%rsp
  801813:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801817:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80181b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801822:	00 00 00 
  801825:	48 8b 00             	mov    (%rax),%rax
  801828:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80182e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	48 89 c7             	mov    %rax,%rdi
  801838:	48 b8 14 39 80 00 00 	movabs $0x803914,%rax
  80183f:	00 00 00 
  801842:	ff d0                	callq  *%rax
  801844:	89 c3                	mov    %eax,%ebx
  801846:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184a:	48 89 c7             	mov    %rax,%rdi
  80184d:	48 b8 14 39 80 00 00 	movabs $0x803914,%rax
  801854:	00 00 00 
  801857:	ff d0                	callq  *%rax
  801859:	39 c3                	cmp    %eax,%ebx
  80185b:	0f 94 c0             	sete   %al
  80185e:	0f b6 c0             	movzbl %al,%eax
  801861:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801864:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80186b:	00 00 00 
  80186e:	48 8b 00             	mov    (%rax),%rax
  801871:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801877:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80187a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80187d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801880:	75 05                	jne    801887 <_pipeisclosed+0x7d>
			return ret;
  801882:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801885:	eb 4f                	jmp    8018d6 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801887:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80188a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80188d:	74 42                	je     8018d1 <_pipeisclosed+0xc7>
  80188f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801893:	75 3c                	jne    8018d1 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801895:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80189c:	00 00 00 
  80189f:	48 8b 00             	mov    (%rax),%rax
  8018a2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8018a8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8018ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018ae:	89 c6                	mov    %eax,%esi
  8018b0:	48 bf c5 3a 80 00 00 	movabs $0x803ac5,%rdi
  8018b7:	00 00 00 
  8018ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bf:	49 b8 c9 20 80 00 00 	movabs $0x8020c9,%r8
  8018c6:	00 00 00 
  8018c9:	41 ff d0             	callq  *%r8
	}
  8018cc:	e9 4a ff ff ff       	jmpq   80181b <_pipeisclosed+0x11>
  8018d1:	e9 45 ff ff ff       	jmpq   80181b <_pipeisclosed+0x11>
}
  8018d6:	48 83 c4 28          	add    $0x28,%rsp
  8018da:	5b                   	pop    %rbx
  8018db:	5d                   	pop    %rbp
  8018dc:	c3                   	retq   

00000000008018dd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	48 83 ec 30          	sub    $0x30,%rsp
  8018e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8018ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018ef:	48 89 d6             	mov    %rdx,%rsi
  8018f2:	89 c7                	mov    %eax,%edi
  8018f4:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
  801900:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801903:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801907:	79 05                	jns    80190e <pipeisclosed+0x31>
		return r;
  801909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190c:	eb 31                	jmp    80193f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80190e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801912:	48 89 c7             	mov    %rax,%rdi
  801915:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  80191c:	00 00 00 
  80191f:	ff d0                	callq  *%rax
  801921:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192d:	48 89 d6             	mov    %rdx,%rsi
  801930:	48 89 c7             	mov    %rax,%rdi
  801933:	48 b8 0a 18 80 00 00 	movabs $0x80180a,%rax
  80193a:	00 00 00 
  80193d:	ff d0                	callq  *%rax
}
  80193f:	c9                   	leaveq 
  801940:	c3                   	retq   

0000000000801941 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801941:	55                   	push   %rbp
  801942:	48 89 e5             	mov    %rsp,%rbp
  801945:	48 83 ec 40          	sub    $0x40,%rsp
  801949:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80194d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801951:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	48 89 c7             	mov    %rax,%rdi
  80195c:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  801963:	00 00 00 
  801966:	ff d0                	callq  *%rax
  801968:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80196c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801970:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801974:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80197b:	00 
  80197c:	e9 92 00 00 00       	jmpq   801a13 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801981:	eb 41                	jmp    8019c4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801983:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801988:	74 09                	je     801993 <devpipe_read+0x52>
				return i;
  80198a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198e:	e9 92 00 00 00       	jmpq   801a25 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801993:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	48 89 d6             	mov    %rdx,%rsi
  80199e:	48 89 c7             	mov    %rax,%rdi
  8019a1:	48 b8 0a 18 80 00 00 	movabs $0x80180a,%rax
  8019a8:	00 00 00 
  8019ab:	ff d0                	callq  *%rax
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 07                	je     8019b8 <devpipe_read+0x77>
				return 0;
  8019b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b6:	eb 6d                	jmp    801a25 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8019b8:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  8019bf:	00 00 00 
  8019c2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8019c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c8:	8b 10                	mov    (%rax),%edx
  8019ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ce:	8b 40 04             	mov    0x4(%rax),%eax
  8019d1:	39 c2                	cmp    %eax,%edx
  8019d3:	74 ae                	je     801983 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019dd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8019e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e5:	8b 00                	mov    (%rax),%eax
  8019e7:	99                   	cltd   
  8019e8:	c1 ea 1b             	shr    $0x1b,%edx
  8019eb:	01 d0                	add    %edx,%eax
  8019ed:	83 e0 1f             	and    $0x1f,%eax
  8019f0:	29 d0                	sub    %edx,%eax
  8019f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f6:	48 98                	cltq   
  8019f8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8019fd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8019ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a03:	8b 00                	mov    (%rax),%eax
  801a05:	8d 50 01             	lea    0x1(%rax),%edx
  801a08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a0c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a0e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a17:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a1b:	0f 82 60 ff ff ff    	jb     801981 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 40          	sub    $0x40,%rsp
  801a2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a37:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	48 89 c7             	mov    %rax,%rdi
  801a42:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  801a49:	00 00 00 
  801a4c:	ff d0                	callq  *%rax
  801a4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801a52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801a5a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a61:	00 
  801a62:	e9 8e 00 00 00       	jmpq   801af5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a67:	eb 31                	jmp    801a9a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a71:	48 89 d6             	mov    %rdx,%rsi
  801a74:	48 89 c7             	mov    %rax,%rdi
  801a77:	48 b8 0a 18 80 00 00 	movabs $0x80180a,%rax
  801a7e:	00 00 00 
  801a81:	ff d0                	callq  *%rax
  801a83:	85 c0                	test   %eax,%eax
  801a85:	74 07                	je     801a8e <devpipe_write+0x67>
				return 0;
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8c:	eb 79                	jmp    801b07 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a8e:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801a95:	00 00 00 
  801a98:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9e:	8b 40 04             	mov    0x4(%rax),%eax
  801aa1:	48 63 d0             	movslq %eax,%rdx
  801aa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa8:	8b 00                	mov    (%rax),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 83 c0 20          	add    $0x20,%rax
  801ab0:	48 39 c2             	cmp    %rax,%rdx
  801ab3:	73 b4                	jae    801a69 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab9:	8b 40 04             	mov    0x4(%rax),%eax
  801abc:	99                   	cltd   
  801abd:	c1 ea 1b             	shr    $0x1b,%edx
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	83 e0 1f             	and    $0x1f,%eax
  801ac5:	29 d0                	sub    %edx,%eax
  801ac7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801acb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801acf:	48 01 ca             	add    %rcx,%rdx
  801ad2:	0f b6 0a             	movzbl (%rdx),%ecx
  801ad5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad9:	48 98                	cltq   
  801adb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae3:	8b 40 04             	mov    0x4(%rax),%eax
  801ae6:	8d 50 01             	lea    0x1(%rax),%edx
  801ae9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aed:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801af0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801af5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801afd:	0f 82 64 ff ff ff    	jb     801a67 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 20          	sub    $0x20,%rsp
  801b11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b1d:	48 89 c7             	mov    %rax,%rdi
  801b20:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  801b27:	00 00 00 
  801b2a:	ff d0                	callq  *%rax
  801b2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801b30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b34:	48 be d8 3a 80 00 00 	movabs $0x803ad8,%rsi
  801b3b:	00 00 00 
  801b3e:	48 89 c7             	mov    %rax,%rdi
  801b41:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b51:	8b 50 04             	mov    0x4(%rax),%edx
  801b54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b58:	8b 00                	mov    (%rax),%eax
  801b5a:	29 c2                	sub    %eax,%edx
  801b5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b60:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b6a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b71:	00 00 00 
	stat->st_dev = &devpipe;
  801b74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b78:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  801b7f:	00 00 00 
  801b82:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 10          	sub    $0x10,%rsp
  801b98:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba0:	48 89 c6             	mov    %rax,%rsi
  801ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba8:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb8:	48 89 c7             	mov    %rax,%rdi
  801bbb:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	callq  *%rax
  801bc7:	48 89 c6             	mov    %rax,%rsi
  801bca:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcf:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	callq  *%rax
}
  801bdb:	c9                   	leaveq 
  801bdc:	c3                   	retq   

0000000000801bdd <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
  801be1:	48 83 ec 20          	sub    $0x20,%rsp
  801be5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801be8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801beb:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801bee:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801bf2:	be 01 00 00 00       	mov    $0x1,%esi
  801bf7:	48 89 c7             	mov    %rax,%rdi
  801bfa:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	callq  *%rax
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <getchar>:

int
getchar(void)
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c10:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801c14:	ba 01 00 00 00       	mov    $0x1,%edx
  801c19:	48 89 c6             	mov    %rax,%rsi
  801c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c21:	48 b8 5b 0b 80 00 00 	movabs $0x800b5b,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
  801c2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801c30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c34:	79 05                	jns    801c3b <getchar+0x33>
		return r;
  801c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c39:	eb 14                	jmp    801c4f <getchar+0x47>
	if (r < 1)
  801c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c3f:	7f 07                	jg     801c48 <getchar+0x40>
		return -E_EOF;
  801c41:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801c46:	eb 07                	jmp    801c4f <getchar+0x47>
	return c;
  801c48:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801c4c:	0f b6 c0             	movzbl %al,%eax
}
  801c4f:	c9                   	leaveq 
  801c50:	c3                   	retq   

0000000000801c51 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c51:	55                   	push   %rbp
  801c52:	48 89 e5             	mov    %rsp,%rbp
  801c55:	48 83 ec 20          	sub    $0x20,%rsp
  801c59:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c63:	48 89 d6             	mov    %rdx,%rsi
  801c66:	89 c7                	mov    %eax,%edi
  801c68:	48 b8 29 07 80 00 00 	movabs $0x800729,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7b:	79 05                	jns    801c82 <iscons+0x31>
		return r;
  801c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c80:	eb 1a                	jmp    801c9c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c86:	8b 10                	mov    (%rax),%edx
  801c88:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  801c8f:	00 00 00 
  801c92:	8b 00                	mov    (%rax),%eax
  801c94:	39 c2                	cmp    %eax,%edx
  801c96:	0f 94 c0             	sete   %al
  801c99:	0f b6 c0             	movzbl %al,%eax
}
  801c9c:	c9                   	leaveq 
  801c9d:	c3                   	retq   

0000000000801c9e <opencons>:

int
opencons(void)
{
  801c9e:	55                   	push   %rbp
  801c9f:	48 89 e5             	mov    %rsp,%rbp
  801ca2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ca6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801caa:	48 89 c7             	mov    %rax,%rdi
  801cad:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  801cb4:	00 00 00 
  801cb7:	ff d0                	callq  *%rax
  801cb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cc0:	79 05                	jns    801cc7 <opencons+0x29>
		return r;
  801cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc5:	eb 5b                	jmp    801d22 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccb:	ba 07 04 00 00       	mov    $0x407,%edx
  801cd0:	48 89 c6             	mov    %rax,%rsi
  801cd3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd8:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
  801ce4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ceb:	79 05                	jns    801cf2 <opencons+0x54>
		return r;
  801ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf0:	eb 30                	jmp    801d22 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf6:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  801cfd:	00 00 00 
  801d00:	8b 12                	mov    (%rdx),%edx
  801d02:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d08:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801d0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d13:	48 89 c7             	mov    %rax,%rdi
  801d16:	48 b8 43 06 80 00 00 	movabs $0x800643,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	callq  *%rax
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 30          	sub    $0x30,%rsp
  801d2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801d38:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801d3d:	75 07                	jne    801d46 <devcons_read+0x22>
		return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	eb 4b                	jmp    801d91 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801d46:	eb 0c                	jmp    801d54 <devcons_read+0x30>
		sys_yield();
  801d48:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801d4f:	00 00 00 
  801d52:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d54:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  801d5b:	00 00 00 
  801d5e:	ff d0                	callq  *%rax
  801d60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d67:	74 df                	je     801d48 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d6d:	79 05                	jns    801d74 <devcons_read+0x50>
		return c;
  801d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d72:	eb 1d                	jmp    801d91 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d74:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d78:	75 07                	jne    801d81 <devcons_read+0x5d>
		return 0;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	eb 10                	jmp    801d91 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d84:	89 c2                	mov    %eax,%edx
  801d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d8a:	88 10                	mov    %dl,(%rax)
	return 1;
  801d8c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d9e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801da5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801dac:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dba:	eb 76                	jmp    801e32 <devcons_write+0x9f>
		m = n - tot;
  801dbc:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc8:	29 c2                	sub    %eax,%edx
  801dca:	89 d0                	mov    %edx,%eax
  801dcc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801dcf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd2:	83 f8 7f             	cmp    $0x7f,%eax
  801dd5:	76 07                	jbe    801dde <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801dd7:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801dde:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801de1:	48 63 d0             	movslq %eax,%rdx
  801de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de7:	48 63 c8             	movslq %eax,%rcx
  801dea:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801df1:	48 01 c1             	add    %rax,%rcx
  801df4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801dfb:	48 89 ce             	mov    %rcx,%rsi
  801dfe:	48 89 c7             	mov    %rax,%rdi
  801e01:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801e0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e10:	48 63 d0             	movslq %eax,%rdx
  801e13:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801e1a:	48 89 d6             	mov    %rdx,%rsi
  801e1d:	48 89 c7             	mov    %rax,%rdi
  801e20:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e2f:	01 45 fc             	add    %eax,-0x4(%rbp)
  801e32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e35:	48 98                	cltq   
  801e37:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801e3e:	0f 82 78 ff ff ff    	jb     801dbc <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e47:	c9                   	leaveq 
  801e48:	c3                   	retq   

0000000000801e49 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801e49:	55                   	push   %rbp
  801e4a:	48 89 e5             	mov    %rsp,%rbp
  801e4d:	48 83 ec 08          	sub    $0x8,%rsp
  801e51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	c9                   	leaveq 
  801e5b:	c3                   	retq   

0000000000801e5c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	48 83 ec 10          	sub    $0x10,%rsp
  801e64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e70:	48 be e4 3a 80 00 00 	movabs $0x803ae4,%rsi
  801e77:	00 00 00 
  801e7a:	48 89 c7             	mov    %rax,%rdi
  801e7d:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	callq  *%rax
	return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8e:	c9                   	leaveq 
  801e8f:	c3                   	retq   

0000000000801e90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	53                   	push   %rbx
  801e95:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e9c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801ea3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801ea9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801eb0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801eb7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801ebe:	84 c0                	test   %al,%al
  801ec0:	74 23                	je     801ee5 <_panic+0x55>
  801ec2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801ec9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801ecd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801ed1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801ed5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801ed9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801edd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801ee1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801ee5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801eec:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801ef3:	00 00 00 
  801ef6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801efd:	00 00 00 
  801f00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f04:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801f0b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801f12:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f19:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801f20:	00 00 00 
  801f23:	48 8b 18             	mov    (%rax),%rbx
  801f26:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
  801f32:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801f38:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801f3f:	41 89 c8             	mov    %ecx,%r8d
  801f42:	48 89 d1             	mov    %rdx,%rcx
  801f45:	48 89 da             	mov    %rbx,%rdx
  801f48:	89 c6                	mov    %eax,%esi
  801f4a:	48 bf f0 3a 80 00 00 	movabs $0x803af0,%rdi
  801f51:	00 00 00 
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	49 b9 c9 20 80 00 00 	movabs $0x8020c9,%r9
  801f60:	00 00 00 
  801f63:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f66:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f6d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f74:	48 89 d6             	mov    %rdx,%rsi
  801f77:	48 89 c7             	mov    %rax,%rdi
  801f7a:	48 b8 1d 20 80 00 00 	movabs $0x80201d,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
	cprintf("\n");
  801f86:	48 bf 13 3b 80 00 00 	movabs $0x803b13,%rdi
  801f8d:	00 00 00 
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  801f9c:	00 00 00 
  801f9f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fa1:	cc                   	int3   
  801fa2:	eb fd                	jmp    801fa1 <_panic+0x111>

0000000000801fa4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801fa4:	55                   	push   %rbp
  801fa5:	48 89 e5             	mov    %rsp,%rbp
  801fa8:	48 83 ec 10          	sub    $0x10,%rsp
  801fac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801faf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb7:	8b 00                	mov    (%rax),%eax
  801fb9:	8d 48 01             	lea    0x1(%rax),%ecx
  801fbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc0:	89 0a                	mov    %ecx,(%rdx)
  801fc2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc5:	89 d1                	mov    %edx,%ecx
  801fc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fcb:	48 98                	cltq   
  801fcd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd5:	8b 00                	mov    (%rax),%eax
  801fd7:	3d ff 00 00 00       	cmp    $0xff,%eax
  801fdc:	75 2c                	jne    80200a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe2:	8b 00                	mov    (%rax),%eax
  801fe4:	48 98                	cltq   
  801fe6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fea:	48 83 c2 08          	add    $0x8,%rdx
  801fee:	48 89 c6             	mov    %rax,%rsi
  801ff1:	48 89 d7             	mov    %rdx,%rdi
  801ff4:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
        b->idx = 0;
  802000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802004:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80200a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200e:	8b 40 04             	mov    0x4(%rax),%eax
  802011:	8d 50 01             	lea    0x1(%rax),%edx
  802014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802018:	89 50 04             	mov    %edx,0x4(%rax)
}
  80201b:	c9                   	leaveq 
  80201c:	c3                   	retq   

000000000080201d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
  802021:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802028:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80202f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802036:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80203d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802044:	48 8b 0a             	mov    (%rdx),%rcx
  802047:	48 89 08             	mov    %rcx,(%rax)
  80204a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80204e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802052:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802056:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80205a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802061:	00 00 00 
    b.cnt = 0;
  802064:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80206b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80206e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802075:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80207c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802083:	48 89 c6             	mov    %rax,%rsi
  802086:	48 bf a4 1f 80 00 00 	movabs $0x801fa4,%rdi
  80208d:	00 00 00 
  802090:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802097:	00 00 00 
  80209a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80209c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8020a2:	48 98                	cltq   
  8020a4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8020ab:	48 83 c2 08          	add    $0x8,%rdx
  8020af:	48 89 c6             	mov    %rax,%rsi
  8020b2:	48 89 d7             	mov    %rdx,%rdi
  8020b5:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8020c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8020d4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8020db:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8020e2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8020e9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8020f0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8020f7:	84 c0                	test   %al,%al
  8020f9:	74 20                	je     80211b <cprintf+0x52>
  8020fb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020ff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802103:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802107:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80210b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80210f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802113:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802117:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80211b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802122:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802129:	00 00 00 
  80212c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802133:	00 00 00 
  802136:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80213a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802141:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802148:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80214f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802156:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80215d:	48 8b 0a             	mov    (%rdx),%rcx
  802160:	48 89 08             	mov    %rcx,(%rax)
  802163:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802167:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80216b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80216f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802173:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80217a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802181:	48 89 d6             	mov    %rdx,%rsi
  802184:	48 89 c7             	mov    %rax,%rdi
  802187:	48 b8 1d 20 80 00 00 	movabs $0x80201d,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
  802193:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802199:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80219f:	c9                   	leaveq 
  8021a0:	c3                   	retq   

00000000008021a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8021a1:	55                   	push   %rbp
  8021a2:	48 89 e5             	mov    %rsp,%rbp
  8021a5:	53                   	push   %rbx
  8021a6:	48 83 ec 38          	sub    $0x38,%rsp
  8021aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021b6:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8021b9:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8021bd:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8021c1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021c4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8021c8:	77 3b                	ja     802205 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8021ca:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8021cd:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8021d1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8021d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dd:	48 f7 f3             	div    %rbx
  8021e0:	48 89 c2             	mov    %rax,%rdx
  8021e3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8021e6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021e9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8021ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f1:	41 89 f9             	mov    %edi,%r9d
  8021f4:	48 89 c7             	mov    %rax,%rdi
  8021f7:	48 b8 a1 21 80 00 00 	movabs $0x8021a1,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
  802203:	eb 1e                	jmp    802223 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802205:	eb 12                	jmp    802219 <printnum+0x78>
			putch(padc, putdat);
  802207:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80220b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80220e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802212:	48 89 ce             	mov    %rcx,%rsi
  802215:	89 d7                	mov    %edx,%edi
  802217:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802219:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80221d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802221:	7f e4                	jg     802207 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802223:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222a:	ba 00 00 00 00       	mov    $0x0,%edx
  80222f:	48 f7 f1             	div    %rcx
  802232:	48 89 d0             	mov    %rdx,%rax
  802235:	48 ba 10 3d 80 00 00 	movabs $0x803d10,%rdx
  80223c:	00 00 00 
  80223f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802243:	0f be d0             	movsbl %al,%edx
  802246:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80224a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224e:	48 89 ce             	mov    %rcx,%rsi
  802251:	89 d7                	mov    %edx,%edi
  802253:	ff d0                	callq  *%rax
}
  802255:	48 83 c4 38          	add    $0x38,%rsp
  802259:	5b                   	pop    %rbx
  80225a:	5d                   	pop    %rbp
  80225b:	c3                   	retq   

000000000080225c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80225c:	55                   	push   %rbp
  80225d:	48 89 e5             	mov    %rsp,%rbp
  802260:	48 83 ec 1c          	sub    $0x1c,%rsp
  802264:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802268:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80226b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80226f:	7e 52                	jle    8022c3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802275:	8b 00                	mov    (%rax),%eax
  802277:	83 f8 30             	cmp    $0x30,%eax
  80227a:	73 24                	jae    8022a0 <getuint+0x44>
  80227c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802280:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802288:	8b 00                	mov    (%rax),%eax
  80228a:	89 c0                	mov    %eax,%eax
  80228c:	48 01 d0             	add    %rdx,%rax
  80228f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802293:	8b 12                	mov    (%rdx),%edx
  802295:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802298:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80229c:	89 0a                	mov    %ecx,(%rdx)
  80229e:	eb 17                	jmp    8022b7 <getuint+0x5b>
  8022a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022a8:	48 89 d0             	mov    %rdx,%rax
  8022ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022b7:	48 8b 00             	mov    (%rax),%rax
  8022ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022be:	e9 a3 00 00 00       	jmpq   802366 <getuint+0x10a>
	else if (lflag)
  8022c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022c7:	74 4f                	je     802318 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	8b 00                	mov    (%rax),%eax
  8022cf:	83 f8 30             	cmp    $0x30,%eax
  8022d2:	73 24                	jae    8022f8 <getuint+0x9c>
  8022d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e0:	8b 00                	mov    (%rax),%eax
  8022e2:	89 c0                	mov    %eax,%eax
  8022e4:	48 01 d0             	add    %rdx,%rax
  8022e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022eb:	8b 12                	mov    (%rdx),%edx
  8022ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f4:	89 0a                	mov    %ecx,(%rdx)
  8022f6:	eb 17                	jmp    80230f <getuint+0xb3>
  8022f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802300:	48 89 d0             	mov    %rdx,%rax
  802303:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802307:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80230b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80230f:	48 8b 00             	mov    (%rax),%rax
  802312:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802316:	eb 4e                	jmp    802366 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231c:	8b 00                	mov    (%rax),%eax
  80231e:	83 f8 30             	cmp    $0x30,%eax
  802321:	73 24                	jae    802347 <getuint+0xeb>
  802323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802327:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80232b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232f:	8b 00                	mov    (%rax),%eax
  802331:	89 c0                	mov    %eax,%eax
  802333:	48 01 d0             	add    %rdx,%rax
  802336:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80233a:	8b 12                	mov    (%rdx),%edx
  80233c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80233f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802343:	89 0a                	mov    %ecx,(%rdx)
  802345:	eb 17                	jmp    80235e <getuint+0x102>
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80234f:	48 89 d0             	mov    %rdx,%rax
  802352:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802356:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80235e:	8b 00                	mov    (%rax),%eax
  802360:	89 c0                	mov    %eax,%eax
  802362:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 1c          	sub    $0x1c,%rsp
  802374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802378:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80237b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80237f:	7e 52                	jle    8023d3 <getint+0x67>
		x=va_arg(*ap, long long);
  802381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802385:	8b 00                	mov    (%rax),%eax
  802387:	83 f8 30             	cmp    $0x30,%eax
  80238a:	73 24                	jae    8023b0 <getint+0x44>
  80238c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802390:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802398:	8b 00                	mov    (%rax),%eax
  80239a:	89 c0                	mov    %eax,%eax
  80239c:	48 01 d0             	add    %rdx,%rax
  80239f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a3:	8b 12                	mov    (%rdx),%edx
  8023a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ac:	89 0a                	mov    %ecx,(%rdx)
  8023ae:	eb 17                	jmp    8023c7 <getint+0x5b>
  8023b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023b8:	48 89 d0             	mov    %rdx,%rax
  8023bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023c7:	48 8b 00             	mov    (%rax),%rax
  8023ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023ce:	e9 a3 00 00 00       	jmpq   802476 <getint+0x10a>
	else if (lflag)
  8023d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023d7:	74 4f                	je     802428 <getint+0xbc>
		x=va_arg(*ap, long);
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	8b 00                	mov    (%rax),%eax
  8023df:	83 f8 30             	cmp    $0x30,%eax
  8023e2:	73 24                	jae    802408 <getint+0x9c>
  8023e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f0:	8b 00                	mov    (%rax),%eax
  8023f2:	89 c0                	mov    %eax,%eax
  8023f4:	48 01 d0             	add    %rdx,%rax
  8023f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023fb:	8b 12                	mov    (%rdx),%edx
  8023fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802400:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802404:	89 0a                	mov    %ecx,(%rdx)
  802406:	eb 17                	jmp    80241f <getint+0xb3>
  802408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802410:	48 89 d0             	mov    %rdx,%rax
  802413:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802417:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80241b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80241f:	48 8b 00             	mov    (%rax),%rax
  802422:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802426:	eb 4e                	jmp    802476 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242c:	8b 00                	mov    (%rax),%eax
  80242e:	83 f8 30             	cmp    $0x30,%eax
  802431:	73 24                	jae    802457 <getint+0xeb>
  802433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802437:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80243b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243f:	8b 00                	mov    (%rax),%eax
  802441:	89 c0                	mov    %eax,%eax
  802443:	48 01 d0             	add    %rdx,%rax
  802446:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80244a:	8b 12                	mov    (%rdx),%edx
  80244c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80244f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802453:	89 0a                	mov    %ecx,(%rdx)
  802455:	eb 17                	jmp    80246e <getint+0x102>
  802457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80245f:	48 89 d0             	mov    %rdx,%rax
  802462:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802466:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80246a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80246e:	8b 00                	mov    (%rax),%eax
  802470:	48 98                	cltq   
  802472:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80247a:	c9                   	leaveq 
  80247b:	c3                   	retq   

000000000080247c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80247c:	55                   	push   %rbp
  80247d:	48 89 e5             	mov    %rsp,%rbp
  802480:	41 54                	push   %r12
  802482:	53                   	push   %rbx
  802483:	48 83 ec 60          	sub    $0x60,%rsp
  802487:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80248b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80248f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802493:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802497:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80249b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80249f:	48 8b 0a             	mov    (%rdx),%rcx
  8024a2:	48 89 08             	mov    %rcx,(%rax)
  8024a5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8024a9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8024ad:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8024b1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8024b5:	eb 17                	jmp    8024ce <vprintfmt+0x52>
			if (ch == '\0')
  8024b7:	85 db                	test   %ebx,%ebx
  8024b9:	0f 84 cc 04 00 00    	je     80298b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8024bf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8024c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024c7:	48 89 d6             	mov    %rdx,%rsi
  8024ca:	89 df                	mov    %ebx,%edi
  8024cc:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8024ce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024d6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024da:	0f b6 00             	movzbl (%rax),%eax
  8024dd:	0f b6 d8             	movzbl %al,%ebx
  8024e0:	83 fb 25             	cmp    $0x25,%ebx
  8024e3:	75 d2                	jne    8024b7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8024e5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8024e9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8024f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8024f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8024fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802505:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802509:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80250d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802511:	0f b6 00             	movzbl (%rax),%eax
  802514:	0f b6 d8             	movzbl %al,%ebx
  802517:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80251a:	83 f8 55             	cmp    $0x55,%eax
  80251d:	0f 87 34 04 00 00    	ja     802957 <vprintfmt+0x4db>
  802523:	89 c0                	mov    %eax,%eax
  802525:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80252c:	00 
  80252d:	48 b8 38 3d 80 00 00 	movabs $0x803d38,%rax
  802534:	00 00 00 
  802537:	48 01 d0             	add    %rdx,%rax
  80253a:	48 8b 00             	mov    (%rax),%rax
  80253d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80253f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802543:	eb c0                	jmp    802505 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802545:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802549:	eb ba                	jmp    802505 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80254b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802552:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802555:	89 d0                	mov    %edx,%eax
  802557:	c1 e0 02             	shl    $0x2,%eax
  80255a:	01 d0                	add    %edx,%eax
  80255c:	01 c0                	add    %eax,%eax
  80255e:	01 d8                	add    %ebx,%eax
  802560:	83 e8 30             	sub    $0x30,%eax
  802563:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802566:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80256a:	0f b6 00             	movzbl (%rax),%eax
  80256d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802570:	83 fb 2f             	cmp    $0x2f,%ebx
  802573:	7e 0c                	jle    802581 <vprintfmt+0x105>
  802575:	83 fb 39             	cmp    $0x39,%ebx
  802578:	7f 07                	jg     802581 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80257a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80257f:	eb d1                	jmp    802552 <vprintfmt+0xd6>
			goto process_precision;
  802581:	eb 58                	jmp    8025db <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802583:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802586:	83 f8 30             	cmp    $0x30,%eax
  802589:	73 17                	jae    8025a2 <vprintfmt+0x126>
  80258b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802592:	89 c0                	mov    %eax,%eax
  802594:	48 01 d0             	add    %rdx,%rax
  802597:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80259a:	83 c2 08             	add    $0x8,%edx
  80259d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025a0:	eb 0f                	jmp    8025b1 <vprintfmt+0x135>
  8025a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025a6:	48 89 d0             	mov    %rdx,%rax
  8025a9:	48 83 c2 08          	add    $0x8,%rdx
  8025ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025b1:	8b 00                	mov    (%rax),%eax
  8025b3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8025b6:	eb 23                	jmp    8025db <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8025b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025bc:	79 0c                	jns    8025ca <vprintfmt+0x14e>
				width = 0;
  8025be:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8025c5:	e9 3b ff ff ff       	jmpq   802505 <vprintfmt+0x89>
  8025ca:	e9 36 ff ff ff       	jmpq   802505 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8025cf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8025d6:	e9 2a ff ff ff       	jmpq   802505 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8025db:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025df:	79 12                	jns    8025f3 <vprintfmt+0x177>
				width = precision, precision = -1;
  8025e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025e4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8025e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8025ee:	e9 12 ff ff ff       	jmpq   802505 <vprintfmt+0x89>
  8025f3:	e9 0d ff ff ff       	jmpq   802505 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8025f8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8025fc:	e9 04 ff ff ff       	jmpq   802505 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802601:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802604:	83 f8 30             	cmp    $0x30,%eax
  802607:	73 17                	jae    802620 <vprintfmt+0x1a4>
  802609:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80260d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802610:	89 c0                	mov    %eax,%eax
  802612:	48 01 d0             	add    %rdx,%rax
  802615:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802618:	83 c2 08             	add    $0x8,%edx
  80261b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80261e:	eb 0f                	jmp    80262f <vprintfmt+0x1b3>
  802620:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802624:	48 89 d0             	mov    %rdx,%rax
  802627:	48 83 c2 08          	add    $0x8,%rdx
  80262b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80262f:	8b 10                	mov    (%rax),%edx
  802631:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802635:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802639:	48 89 ce             	mov    %rcx,%rsi
  80263c:	89 d7                	mov    %edx,%edi
  80263e:	ff d0                	callq  *%rax
			break;
  802640:	e9 40 03 00 00       	jmpq   802985 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802645:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802648:	83 f8 30             	cmp    $0x30,%eax
  80264b:	73 17                	jae    802664 <vprintfmt+0x1e8>
  80264d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802651:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802654:	89 c0                	mov    %eax,%eax
  802656:	48 01 d0             	add    %rdx,%rax
  802659:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80265c:	83 c2 08             	add    $0x8,%edx
  80265f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802662:	eb 0f                	jmp    802673 <vprintfmt+0x1f7>
  802664:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802668:	48 89 d0             	mov    %rdx,%rax
  80266b:	48 83 c2 08          	add    $0x8,%rdx
  80266f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802673:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802675:	85 db                	test   %ebx,%ebx
  802677:	79 02                	jns    80267b <vprintfmt+0x1ff>
				err = -err;
  802679:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80267b:	83 fb 15             	cmp    $0x15,%ebx
  80267e:	7f 16                	jg     802696 <vprintfmt+0x21a>
  802680:	48 b8 60 3c 80 00 00 	movabs $0x803c60,%rax
  802687:	00 00 00 
  80268a:	48 63 d3             	movslq %ebx,%rdx
  80268d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802691:	4d 85 e4             	test   %r12,%r12
  802694:	75 2e                	jne    8026c4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802696:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80269a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80269e:	89 d9                	mov    %ebx,%ecx
  8026a0:	48 ba 21 3d 80 00 00 	movabs $0x803d21,%rdx
  8026a7:	00 00 00 
  8026aa:	48 89 c7             	mov    %rax,%rdi
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	49 b8 94 29 80 00 00 	movabs $0x802994,%r8
  8026b9:	00 00 00 
  8026bc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8026bf:	e9 c1 02 00 00       	jmpq   802985 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8026c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026cc:	4c 89 e1             	mov    %r12,%rcx
  8026cf:	48 ba 2a 3d 80 00 00 	movabs $0x803d2a,%rdx
  8026d6:	00 00 00 
  8026d9:	48 89 c7             	mov    %rax,%rdi
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	49 b8 94 29 80 00 00 	movabs $0x802994,%r8
  8026e8:	00 00 00 
  8026eb:	41 ff d0             	callq  *%r8
			break;
  8026ee:	e9 92 02 00 00       	jmpq   802985 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8026f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026f6:	83 f8 30             	cmp    $0x30,%eax
  8026f9:	73 17                	jae    802712 <vprintfmt+0x296>
  8026fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802702:	89 c0                	mov    %eax,%eax
  802704:	48 01 d0             	add    %rdx,%rax
  802707:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80270a:	83 c2 08             	add    $0x8,%edx
  80270d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802710:	eb 0f                	jmp    802721 <vprintfmt+0x2a5>
  802712:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802716:	48 89 d0             	mov    %rdx,%rax
  802719:	48 83 c2 08          	add    $0x8,%rdx
  80271d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802721:	4c 8b 20             	mov    (%rax),%r12
  802724:	4d 85 e4             	test   %r12,%r12
  802727:	75 0a                	jne    802733 <vprintfmt+0x2b7>
				p = "(null)";
  802729:	49 bc 2d 3d 80 00 00 	movabs $0x803d2d,%r12
  802730:	00 00 00 
			if (width > 0 && padc != '-')
  802733:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802737:	7e 3f                	jle    802778 <vprintfmt+0x2fc>
  802739:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80273d:	74 39                	je     802778 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80273f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802742:	48 98                	cltq   
  802744:	48 89 c6             	mov    %rax,%rsi
  802747:	4c 89 e7             	mov    %r12,%rdi
  80274a:	48 b8 40 2c 80 00 00 	movabs $0x802c40,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802759:	eb 17                	jmp    802772 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80275b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80275f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802763:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802767:	48 89 ce             	mov    %rcx,%rsi
  80276a:	89 d7                	mov    %edx,%edi
  80276c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80276e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802772:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802776:	7f e3                	jg     80275b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802778:	eb 37                	jmp    8027b1 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80277a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80277e:	74 1e                	je     80279e <vprintfmt+0x322>
  802780:	83 fb 1f             	cmp    $0x1f,%ebx
  802783:	7e 05                	jle    80278a <vprintfmt+0x30e>
  802785:	83 fb 7e             	cmp    $0x7e,%ebx
  802788:	7e 14                	jle    80279e <vprintfmt+0x322>
					putch('?', putdat);
  80278a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80278e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802792:	48 89 d6             	mov    %rdx,%rsi
  802795:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80279a:	ff d0                	callq  *%rax
  80279c:	eb 0f                	jmp    8027ad <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80279e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027a2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027a6:	48 89 d6             	mov    %rdx,%rsi
  8027a9:	89 df                	mov    %ebx,%edi
  8027ab:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8027ad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027b1:	4c 89 e0             	mov    %r12,%rax
  8027b4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8027b8:	0f b6 00             	movzbl (%rax),%eax
  8027bb:	0f be d8             	movsbl %al,%ebx
  8027be:	85 db                	test   %ebx,%ebx
  8027c0:	74 10                	je     8027d2 <vprintfmt+0x356>
  8027c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027c6:	78 b2                	js     80277a <vprintfmt+0x2fe>
  8027c8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8027cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027d0:	79 a8                	jns    80277a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027d2:	eb 16                	jmp    8027ea <vprintfmt+0x36e>
				putch(' ', putdat);
  8027d4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027dc:	48 89 d6             	mov    %rdx,%rsi
  8027df:	bf 20 00 00 00       	mov    $0x20,%edi
  8027e4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027e6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8027ee:	7f e4                	jg     8027d4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8027f0:	e9 90 01 00 00       	jmpq   802985 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8027f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027f9:	be 03 00 00 00       	mov    $0x3,%esi
  8027fe:	48 89 c7             	mov    %rax,%rdi
  802801:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802808:	00 00 00 
  80280b:	ff d0                	callq  *%rax
  80280d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802815:	48 85 c0             	test   %rax,%rax
  802818:	79 1d                	jns    802837 <vprintfmt+0x3bb>
				putch('-', putdat);
  80281a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80281e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802822:	48 89 d6             	mov    %rdx,%rsi
  802825:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80282a:	ff d0                	callq  *%rax
				num = -(long long) num;
  80282c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802830:	48 f7 d8             	neg    %rax
  802833:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802837:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80283e:	e9 d5 00 00 00       	jmpq   802918 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802843:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802847:	be 03 00 00 00       	mov    $0x3,%esi
  80284c:	48 89 c7             	mov    %rax,%rdi
  80284f:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  802856:	00 00 00 
  802859:	ff d0                	callq  *%rax
  80285b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80285f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802866:	e9 ad 00 00 00       	jmpq   802918 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80286b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80286e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802872:	89 d6                	mov    %edx,%esi
  802874:	48 89 c7             	mov    %rax,%rdi
  802877:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  80287e:	00 00 00 
  802881:	ff d0                	callq  *%rax
  802883:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  802887:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80288e:	e9 85 00 00 00       	jmpq   802918 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  802893:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802897:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80289b:	48 89 d6             	mov    %rdx,%rsi
  80289e:	bf 30 00 00 00       	mov    $0x30,%edi
  8028a3:	ff d0                	callq  *%rax
			putch('x', putdat);
  8028a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028ad:	48 89 d6             	mov    %rdx,%rsi
  8028b0:	bf 78 00 00 00       	mov    $0x78,%edi
  8028b5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8028b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028ba:	83 f8 30             	cmp    $0x30,%eax
  8028bd:	73 17                	jae    8028d6 <vprintfmt+0x45a>
  8028bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028c6:	89 c0                	mov    %eax,%eax
  8028c8:	48 01 d0             	add    %rdx,%rax
  8028cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8028ce:	83 c2 08             	add    $0x8,%edx
  8028d1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028d4:	eb 0f                	jmp    8028e5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8028d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028da:	48 89 d0             	mov    %rdx,%rax
  8028dd:	48 83 c2 08          	add    $0x8,%rdx
  8028e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8028e5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8028ec:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028f3:	eb 23                	jmp    802918 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028f9:	be 03 00 00 00       	mov    $0x3,%esi
  8028fe:	48 89 c7             	mov    %rax,%rdi
  802901:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
  80290d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802911:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802918:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80291d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802920:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802923:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802927:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80292b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80292f:	45 89 c1             	mov    %r8d,%r9d
  802932:	41 89 f8             	mov    %edi,%r8d
  802935:	48 89 c7             	mov    %rax,%rdi
  802938:	48 b8 a1 21 80 00 00 	movabs $0x8021a1,%rax
  80293f:	00 00 00 
  802942:	ff d0                	callq  *%rax
			break;
  802944:	eb 3f                	jmp    802985 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802946:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80294a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80294e:	48 89 d6             	mov    %rdx,%rsi
  802951:	89 df                	mov    %ebx,%edi
  802953:	ff d0                	callq  *%rax
			break;
  802955:	eb 2e                	jmp    802985 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802957:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80295b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80295f:	48 89 d6             	mov    %rdx,%rsi
  802962:	bf 25 00 00 00       	mov    $0x25,%edi
  802967:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802969:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80296e:	eb 05                	jmp    802975 <vprintfmt+0x4f9>
  802970:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802975:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802979:	48 83 e8 01          	sub    $0x1,%rax
  80297d:	0f b6 00             	movzbl (%rax),%eax
  802980:	3c 25                	cmp    $0x25,%al
  802982:	75 ec                	jne    802970 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  802984:	90                   	nop
		}
	}
  802985:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802986:	e9 43 fb ff ff       	jmpq   8024ce <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80298b:	48 83 c4 60          	add    $0x60,%rsp
  80298f:	5b                   	pop    %rbx
  802990:	41 5c                	pop    %r12
  802992:	5d                   	pop    %rbp
  802993:	c3                   	retq   

0000000000802994 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802994:	55                   	push   %rbp
  802995:	48 89 e5             	mov    %rsp,%rbp
  802998:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80299f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8029a6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8029ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8029bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8029c2:	84 c0                	test   %al,%al
  8029c4:	74 20                	je     8029e6 <printfmt+0x52>
  8029c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8029ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8029ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8029e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8029e6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8029ed:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8029f4:	00 00 00 
  8029f7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029fe:	00 00 00 
  802a01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802a0c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a13:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802a1a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802a21:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802a28:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802a2f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802a36:	48 89 c7             	mov    %rax,%rdi
  802a39:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
	va_end(ap);
}
  802a45:	c9                   	leaveq 
  802a46:	c3                   	retq   

0000000000802a47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802a47:	55                   	push   %rbp
  802a48:	48 89 e5             	mov    %rsp,%rbp
  802a4b:	48 83 ec 10          	sub    $0x10,%rsp
  802a4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5a:	8b 40 10             	mov    0x10(%rax),%eax
  802a5d:	8d 50 01             	lea    0x1(%rax),%edx
  802a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a64:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6b:	48 8b 10             	mov    (%rax),%rdx
  802a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a72:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a76:	48 39 c2             	cmp    %rax,%rdx
  802a79:	73 17                	jae    802a92 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7f:	48 8b 00             	mov    (%rax),%rax
  802a82:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a8a:	48 89 0a             	mov    %rcx,(%rdx)
  802a8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a90:	88 10                	mov    %dl,(%rax)
}
  802a92:	c9                   	leaveq 
  802a93:	c3                   	retq   

0000000000802a94 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a94:	55                   	push   %rbp
  802a95:	48 89 e5             	mov    %rsp,%rbp
  802a98:	48 83 ec 50          	sub    $0x50,%rsp
  802a9c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802aa0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802aa3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802aa7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802aab:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802aaf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802ab3:	48 8b 0a             	mov    (%rdx),%rcx
  802ab6:	48 89 08             	mov    %rcx,(%rax)
  802ab9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802abd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ac1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ac5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802ac9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802acd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802ad1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802ad4:	48 98                	cltq   
  802ad6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ada:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ade:	48 01 d0             	add    %rdx,%rax
  802ae1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802ae5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802aec:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802af1:	74 06                	je     802af9 <vsnprintf+0x65>
  802af3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802af7:	7f 07                	jg     802b00 <vsnprintf+0x6c>
		return -E_INVAL;
  802af9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802afe:	eb 2f                	jmp    802b2f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802b00:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802b04:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802b08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b0c:	48 89 c6             	mov    %rax,%rsi
  802b0f:	48 bf 47 2a 80 00 00 	movabs $0x802a47,%rdi
  802b16:	00 00 00 
  802b19:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802b25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b29:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802b2c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802b2f:	c9                   	leaveq 
  802b30:	c3                   	retq   

0000000000802b31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802b31:	55                   	push   %rbp
  802b32:	48 89 e5             	mov    %rsp,%rbp
  802b35:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802b3c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802b43:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802b49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b5e:	84 c0                	test   %al,%al
  802b60:	74 20                	je     802b82 <snprintf+0x51>
  802b62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b82:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b89:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b90:	00 00 00 
  802b93:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b9a:	00 00 00 
  802b9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ba1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ba8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802baf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802bb6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802bbd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802bc4:	48 8b 0a             	mov    (%rdx),%rcx
  802bc7:	48 89 08             	mov    %rcx,(%rax)
  802bca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802bce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802bd2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802bd6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802bda:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802be1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802be8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802bee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802bf5:	48 89 c7             	mov    %rax,%rdi
  802bf8:	48 b8 94 2a 80 00 00 	movabs $0x802a94,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
  802c04:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802c0a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802c10:	c9                   	leaveq 
  802c11:	c3                   	retq   

0000000000802c12 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802c12:	55                   	push   %rbp
  802c13:	48 89 e5             	mov    %rsp,%rbp
  802c16:	48 83 ec 18          	sub    $0x18,%rsp
  802c1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c25:	eb 09                	jmp    802c30 <strlen+0x1e>
		n++;
  802c27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802c2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	0f b6 00             	movzbl (%rax),%eax
  802c37:	84 c0                	test   %al,%al
  802c39:	75 ec                	jne    802c27 <strlen+0x15>
		n++;
	return n;
  802c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 20          	sub    $0x20,%rsp
  802c48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c57:	eb 0e                	jmp    802c67 <strnlen+0x27>
		n++;
  802c59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c5d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c62:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c67:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c6c:	74 0b                	je     802c79 <strnlen+0x39>
  802c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c72:	0f b6 00             	movzbl (%rax),%eax
  802c75:	84 c0                	test   %al,%al
  802c77:	75 e0                	jne    802c59 <strnlen+0x19>
		n++;
	return n;
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c7c:	c9                   	leaveq 
  802c7d:	c3                   	retq   

0000000000802c7e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c7e:	55                   	push   %rbp
  802c7f:	48 89 e5             	mov    %rsp,%rbp
  802c82:	48 83 ec 20          	sub    $0x20,%rsp
  802c86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c96:	90                   	nop
  802c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ca3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ca7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802cab:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802caf:	0f b6 12             	movzbl (%rdx),%edx
  802cb2:	88 10                	mov    %dl,(%rax)
  802cb4:	0f b6 00             	movzbl (%rax),%eax
  802cb7:	84 c0                	test   %al,%al
  802cb9:	75 dc                	jne    802c97 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cbf:	c9                   	leaveq 
  802cc0:	c3                   	retq   

0000000000802cc1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802cc1:	55                   	push   %rbp
  802cc2:	48 89 e5             	mov    %rsp,%rbp
  802cc5:	48 83 ec 20          	sub    $0x20,%rsp
  802cc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ccd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802cd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd5:	48 89 c7             	mov    %rax,%rdi
  802cd8:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
  802ce4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cea:	48 63 d0             	movslq %eax,%rdx
  802ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf1:	48 01 c2             	add    %rax,%rdx
  802cf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf8:	48 89 c6             	mov    %rax,%rsi
  802cfb:	48 89 d7             	mov    %rdx,%rdi
  802cfe:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
	return dst;
  802d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802d0e:	c9                   	leaveq 
  802d0f:	c3                   	retq   

0000000000802d10 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802d10:	55                   	push   %rbp
  802d11:	48 89 e5             	mov    %rsp,%rbp
  802d14:	48 83 ec 28          	sub    $0x28,%rsp
  802d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802d2c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d33:	00 
  802d34:	eb 2a                	jmp    802d60 <strncpy+0x50>
		*dst++ = *src;
  802d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d46:	0f b6 12             	movzbl (%rdx),%edx
  802d49:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802d4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d4f:	0f b6 00             	movzbl (%rax),%eax
  802d52:	84 c0                	test   %al,%al
  802d54:	74 05                	je     802d5b <strncpy+0x4b>
			src++;
  802d56:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d5b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d64:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d68:	72 cc                	jb     802d36 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d6e:	c9                   	leaveq 
  802d6f:	c3                   	retq   

0000000000802d70 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d70:	55                   	push   %rbp
  802d71:	48 89 e5             	mov    %rsp,%rbp
  802d74:	48 83 ec 28          	sub    $0x28,%rsp
  802d78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d88:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d8c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d91:	74 3d                	je     802dd0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d93:	eb 1d                	jmp    802db2 <strlcpy+0x42>
			*dst++ = *src++;
  802d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802da1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802da9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802dad:	0f b6 12             	movzbl (%rdx),%edx
  802db0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802db2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802db7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802dbc:	74 0b                	je     802dc9 <strlcpy+0x59>
  802dbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc2:	0f b6 00             	movzbl (%rax),%eax
  802dc5:	84 c0                	test   %al,%al
  802dc7:	75 cc                	jne    802d95 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802dd0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd8:	48 29 c2             	sub    %rax,%rdx
  802ddb:	48 89 d0             	mov    %rdx,%rax
}
  802dde:	c9                   	leaveq 
  802ddf:	c3                   	retq   

0000000000802de0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802de0:	55                   	push   %rbp
  802de1:	48 89 e5             	mov    %rsp,%rbp
  802de4:	48 83 ec 10          	sub    $0x10,%rsp
  802de8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802df0:	eb 0a                	jmp    802dfc <strcmp+0x1c>
		p++, q++;
  802df2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802df7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e00:	0f b6 00             	movzbl (%rax),%eax
  802e03:	84 c0                	test   %al,%al
  802e05:	74 12                	je     802e19 <strcmp+0x39>
  802e07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0b:	0f b6 10             	movzbl (%rax),%edx
  802e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e12:	0f b6 00             	movzbl (%rax),%eax
  802e15:	38 c2                	cmp    %al,%dl
  802e17:	74 d9                	je     802df2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802e19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1d:	0f b6 00             	movzbl (%rax),%eax
  802e20:	0f b6 d0             	movzbl %al,%edx
  802e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e27:	0f b6 00             	movzbl (%rax),%eax
  802e2a:	0f b6 c0             	movzbl %al,%eax
  802e2d:	29 c2                	sub    %eax,%edx
  802e2f:	89 d0                	mov    %edx,%eax
}
  802e31:	c9                   	leaveq 
  802e32:	c3                   	retq   

0000000000802e33 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802e33:	55                   	push   %rbp
  802e34:	48 89 e5             	mov    %rsp,%rbp
  802e37:	48 83 ec 18          	sub    $0x18,%rsp
  802e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e43:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802e47:	eb 0f                	jmp    802e58 <strncmp+0x25>
		n--, p++, q++;
  802e49:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e4e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e53:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e58:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e5d:	74 1d                	je     802e7c <strncmp+0x49>
  802e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e63:	0f b6 00             	movzbl (%rax),%eax
  802e66:	84 c0                	test   %al,%al
  802e68:	74 12                	je     802e7c <strncmp+0x49>
  802e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6e:	0f b6 10             	movzbl (%rax),%edx
  802e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e75:	0f b6 00             	movzbl (%rax),%eax
  802e78:	38 c2                	cmp    %al,%dl
  802e7a:	74 cd                	je     802e49 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e7c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e81:	75 07                	jne    802e8a <strncmp+0x57>
		return 0;
  802e83:	b8 00 00 00 00       	mov    $0x0,%eax
  802e88:	eb 18                	jmp    802ea2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8e:	0f b6 00             	movzbl (%rax),%eax
  802e91:	0f b6 d0             	movzbl %al,%edx
  802e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e98:	0f b6 00             	movzbl (%rax),%eax
  802e9b:	0f b6 c0             	movzbl %al,%eax
  802e9e:	29 c2                	sub    %eax,%edx
  802ea0:	89 d0                	mov    %edx,%eax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 0c          	sub    $0xc,%rsp
  802eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb0:	89 f0                	mov    %esi,%eax
  802eb2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802eb5:	eb 17                	jmp    802ece <strchr+0x2a>
		if (*s == c)
  802eb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebb:	0f b6 00             	movzbl (%rax),%eax
  802ebe:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ec1:	75 06                	jne    802ec9 <strchr+0x25>
			return (char *) s;
  802ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec7:	eb 15                	jmp    802ede <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802ec9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed2:	0f b6 00             	movzbl (%rax),%eax
  802ed5:	84 c0                	test   %al,%al
  802ed7:	75 de                	jne    802eb7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ede:	c9                   	leaveq 
  802edf:	c3                   	retq   

0000000000802ee0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802ee0:	55                   	push   %rbp
  802ee1:	48 89 e5             	mov    %rsp,%rbp
  802ee4:	48 83 ec 0c          	sub    $0xc,%rsp
  802ee8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eec:	89 f0                	mov    %esi,%eax
  802eee:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ef1:	eb 13                	jmp    802f06 <strfind+0x26>
		if (*s == c)
  802ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef7:	0f b6 00             	movzbl (%rax),%eax
  802efa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802efd:	75 02                	jne    802f01 <strfind+0x21>
			break;
  802eff:	eb 10                	jmp    802f11 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802f01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0a:	0f b6 00             	movzbl (%rax),%eax
  802f0d:	84 c0                	test   %al,%al
  802f0f:	75 e2                	jne    802ef3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f15:	c9                   	leaveq 
  802f16:	c3                   	retq   

0000000000802f17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 18          	sub    $0x18,%rsp
  802f1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f23:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802f26:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802f2a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f2f:	75 06                	jne    802f37 <memset+0x20>
		return v;
  802f31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f35:	eb 69                	jmp    802fa0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f3b:	83 e0 03             	and    $0x3,%eax
  802f3e:	48 85 c0             	test   %rax,%rax
  802f41:	75 48                	jne    802f8b <memset+0x74>
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	83 e0 03             	and    $0x3,%eax
  802f4a:	48 85 c0             	test   %rax,%rax
  802f4d:	75 3c                	jne    802f8b <memset+0x74>
		c &= 0xFF;
  802f4f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f59:	c1 e0 18             	shl    $0x18,%eax
  802f5c:	89 c2                	mov    %eax,%edx
  802f5e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f61:	c1 e0 10             	shl    $0x10,%eax
  802f64:	09 c2                	or     %eax,%edx
  802f66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f69:	c1 e0 08             	shl    $0x8,%eax
  802f6c:	09 d0                	or     %edx,%eax
  802f6e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f75:	48 c1 e8 02          	shr    $0x2,%rax
  802f79:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f80:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f83:	48 89 d7             	mov    %rdx,%rdi
  802f86:	fc                   	cld    
  802f87:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f89:	eb 11                	jmp    802f9c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f8b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f8f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f96:	48 89 d7             	mov    %rdx,%rdi
  802f99:	fc                   	cld    
  802f9a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fa0:	c9                   	leaveq 
  802fa1:	c3                   	retq   

0000000000802fa2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802fa2:	55                   	push   %rbp
  802fa3:	48 89 e5             	mov    %rsp,%rbp
  802fa6:	48 83 ec 28          	sub    $0x28,%rsp
  802faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fb2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802fc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fca:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802fce:	0f 83 88 00 00 00    	jae    80305c <memmove+0xba>
  802fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fdc:	48 01 d0             	add    %rdx,%rax
  802fdf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802fe3:	76 77                	jbe    80305c <memmove+0xba>
		s += n;
  802fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	83 e0 03             	and    $0x3,%eax
  802ffc:	48 85 c0             	test   %rax,%rax
  802fff:	75 3b                	jne    80303c <memmove+0x9a>
  803001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803005:	83 e0 03             	and    $0x3,%eax
  803008:	48 85 c0             	test   %rax,%rax
  80300b:	75 2f                	jne    80303c <memmove+0x9a>
  80300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803011:	83 e0 03             	and    $0x3,%eax
  803014:	48 85 c0             	test   %rax,%rax
  803017:	75 23                	jne    80303c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301d:	48 83 e8 04          	sub    $0x4,%rax
  803021:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803025:	48 83 ea 04          	sub    $0x4,%rdx
  803029:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80302d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803031:	48 89 c7             	mov    %rax,%rdi
  803034:	48 89 d6             	mov    %rdx,%rsi
  803037:	fd                   	std    
  803038:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80303a:	eb 1d                	jmp    803059 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80303c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803040:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803048:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80304c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803050:	48 89 d7             	mov    %rdx,%rdi
  803053:	48 89 c1             	mov    %rax,%rcx
  803056:	fd                   	std    
  803057:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803059:	fc                   	cld    
  80305a:	eb 57                	jmp    8030b3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80305c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803060:	83 e0 03             	and    $0x3,%eax
  803063:	48 85 c0             	test   %rax,%rax
  803066:	75 36                	jne    80309e <memmove+0xfc>
  803068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306c:	83 e0 03             	and    $0x3,%eax
  80306f:	48 85 c0             	test   %rax,%rax
  803072:	75 2a                	jne    80309e <memmove+0xfc>
  803074:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803078:	83 e0 03             	and    $0x3,%eax
  80307b:	48 85 c0             	test   %rax,%rax
  80307e:	75 1e                	jne    80309e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803080:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803084:	48 c1 e8 02          	shr    $0x2,%rax
  803088:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803093:	48 89 c7             	mov    %rax,%rdi
  803096:	48 89 d6             	mov    %rdx,%rsi
  803099:	fc                   	cld    
  80309a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80309c:	eb 15                	jmp    8030b3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80309e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030a6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8030aa:	48 89 c7             	mov    %rax,%rdi
  8030ad:	48 89 d6             	mov    %rdx,%rsi
  8030b0:	fc                   	cld    
  8030b1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8030b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8030b7:	c9                   	leaveq 
  8030b8:	c3                   	retq   

00000000008030b9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8030b9:	55                   	push   %rbp
  8030ba:	48 89 e5             	mov    %rsp,%rbp
  8030bd:	48 83 ec 18          	sub    $0x18,%rsp
  8030c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8030cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d9:	48 89 ce             	mov    %rcx,%rsi
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 28          	sub    $0x28,%rsp
  8030f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803105:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803111:	eb 36                	jmp    803149 <memcmp+0x5c>
		if (*s1 != *s2)
  803113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803117:	0f b6 10             	movzbl (%rax),%edx
  80311a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311e:	0f b6 00             	movzbl (%rax),%eax
  803121:	38 c2                	cmp    %al,%dl
  803123:	74 1a                	je     80313f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803129:	0f b6 00             	movzbl (%rax),%eax
  80312c:	0f b6 d0             	movzbl %al,%edx
  80312f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803133:	0f b6 00             	movzbl (%rax),%eax
  803136:	0f b6 c0             	movzbl %al,%eax
  803139:	29 c2                	sub    %eax,%edx
  80313b:	89 d0                	mov    %edx,%eax
  80313d:	eb 20                	jmp    80315f <memcmp+0x72>
		s1++, s2++;
  80313f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803144:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803149:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803151:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803155:	48 85 c0             	test   %rax,%rax
  803158:	75 b9                	jne    803113 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315f:	c9                   	leaveq 
  803160:	c3                   	retq   

0000000000803161 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
  803165:	48 83 ec 28          	sub    $0x28,%rsp
  803169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80316d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803170:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803178:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80317c:	48 01 d0             	add    %rdx,%rax
  80317f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803183:	eb 15                	jmp    80319a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803189:	0f b6 10             	movzbl (%rax),%edx
  80318c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80318f:	38 c2                	cmp    %al,%dl
  803191:	75 02                	jne    803195 <memfind+0x34>
			break;
  803193:	eb 0f                	jmp    8031a4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803195:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8031a2:	72 e1                	jb     803185 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8031a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8031a8:	c9                   	leaveq 
  8031a9:	c3                   	retq   

00000000008031aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8031aa:	55                   	push   %rbp
  8031ab:	48 89 e5             	mov    %rsp,%rbp
  8031ae:	48 83 ec 34          	sub    $0x34,%rsp
  8031b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031ba:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8031bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8031c4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8031cb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8031cc:	eb 05                	jmp    8031d3 <strtol+0x29>
		s++;
  8031ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8031d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d7:	0f b6 00             	movzbl (%rax),%eax
  8031da:	3c 20                	cmp    $0x20,%al
  8031dc:	74 f0                	je     8031ce <strtol+0x24>
  8031de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e2:	0f b6 00             	movzbl (%rax),%eax
  8031e5:	3c 09                	cmp    $0x9,%al
  8031e7:	74 e5                	je     8031ce <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8031e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ed:	0f b6 00             	movzbl (%rax),%eax
  8031f0:	3c 2b                	cmp    $0x2b,%al
  8031f2:	75 07                	jne    8031fb <strtol+0x51>
		s++;
  8031f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031f9:	eb 17                	jmp    803212 <strtol+0x68>
	else if (*s == '-')
  8031fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ff:	0f b6 00             	movzbl (%rax),%eax
  803202:	3c 2d                	cmp    $0x2d,%al
  803204:	75 0c                	jne    803212 <strtol+0x68>
		s++, neg = 1;
  803206:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80320b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803212:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803216:	74 06                	je     80321e <strtol+0x74>
  803218:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80321c:	75 28                	jne    803246 <strtol+0x9c>
  80321e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803222:	0f b6 00             	movzbl (%rax),%eax
  803225:	3c 30                	cmp    $0x30,%al
  803227:	75 1d                	jne    803246 <strtol+0x9c>
  803229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322d:	48 83 c0 01          	add    $0x1,%rax
  803231:	0f b6 00             	movzbl (%rax),%eax
  803234:	3c 78                	cmp    $0x78,%al
  803236:	75 0e                	jne    803246 <strtol+0x9c>
		s += 2, base = 16;
  803238:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80323d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803244:	eb 2c                	jmp    803272 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803246:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80324a:	75 19                	jne    803265 <strtol+0xbb>
  80324c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803250:	0f b6 00             	movzbl (%rax),%eax
  803253:	3c 30                	cmp    $0x30,%al
  803255:	75 0e                	jne    803265 <strtol+0xbb>
		s++, base = 8;
  803257:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80325c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803263:	eb 0d                	jmp    803272 <strtol+0xc8>
	else if (base == 0)
  803265:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803269:	75 07                	jne    803272 <strtol+0xc8>
		base = 10;
  80326b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803276:	0f b6 00             	movzbl (%rax),%eax
  803279:	3c 2f                	cmp    $0x2f,%al
  80327b:	7e 1d                	jle    80329a <strtol+0xf0>
  80327d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803281:	0f b6 00             	movzbl (%rax),%eax
  803284:	3c 39                	cmp    $0x39,%al
  803286:	7f 12                	jg     80329a <strtol+0xf0>
			dig = *s - '0';
  803288:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328c:	0f b6 00             	movzbl (%rax),%eax
  80328f:	0f be c0             	movsbl %al,%eax
  803292:	83 e8 30             	sub    $0x30,%eax
  803295:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803298:	eb 4e                	jmp    8032e8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80329a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329e:	0f b6 00             	movzbl (%rax),%eax
  8032a1:	3c 60                	cmp    $0x60,%al
  8032a3:	7e 1d                	jle    8032c2 <strtol+0x118>
  8032a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a9:	0f b6 00             	movzbl (%rax),%eax
  8032ac:	3c 7a                	cmp    $0x7a,%al
  8032ae:	7f 12                	jg     8032c2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8032b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b4:	0f b6 00             	movzbl (%rax),%eax
  8032b7:	0f be c0             	movsbl %al,%eax
  8032ba:	83 e8 57             	sub    $0x57,%eax
  8032bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c0:	eb 26                	jmp    8032e8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8032c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c6:	0f b6 00             	movzbl (%rax),%eax
  8032c9:	3c 40                	cmp    $0x40,%al
  8032cb:	7e 48                	jle    803315 <strtol+0x16b>
  8032cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d1:	0f b6 00             	movzbl (%rax),%eax
  8032d4:	3c 5a                	cmp    $0x5a,%al
  8032d6:	7f 3d                	jg     803315 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8032d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032dc:	0f b6 00             	movzbl (%rax),%eax
  8032df:	0f be c0             	movsbl %al,%eax
  8032e2:	83 e8 37             	sub    $0x37,%eax
  8032e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8032e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032eb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8032ee:	7c 02                	jl     8032f2 <strtol+0x148>
			break;
  8032f0:	eb 23                	jmp    803315 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8032f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032f7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032fa:	48 98                	cltq   
  8032fc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803301:	48 89 c2             	mov    %rax,%rdx
  803304:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803307:	48 98                	cltq   
  803309:	48 01 d0             	add    %rdx,%rax
  80330c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803310:	e9 5d ff ff ff       	jmpq   803272 <strtol+0xc8>

	if (endptr)
  803315:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80331a:	74 0b                	je     803327 <strtol+0x17d>
		*endptr = (char *) s;
  80331c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803320:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803324:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803327:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332b:	74 09                	je     803336 <strtol+0x18c>
  80332d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803331:	48 f7 d8             	neg    %rax
  803334:	eb 04                	jmp    80333a <strtol+0x190>
  803336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <strstr>:

char * strstr(const char *in, const char *str)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 30          	sub    $0x30,%rsp
  803344:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803348:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80334c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803350:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803354:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803358:	0f b6 00             	movzbl (%rax),%eax
  80335b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80335e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803362:	75 06                	jne    80336a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803364:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803368:	eb 6b                	jmp    8033d5 <strstr+0x99>

	len = strlen(str);
  80336a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336e:	48 89 c7             	mov    %rax,%rdi
  803371:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  803378:	00 00 00 
  80337b:	ff d0                	callq  *%rax
  80337d:	48 98                	cltq   
  80337f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803387:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80338b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80338f:	0f b6 00             	movzbl (%rax),%eax
  803392:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803395:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803399:	75 07                	jne    8033a2 <strstr+0x66>
				return (char *) 0;
  80339b:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a0:	eb 33                	jmp    8033d5 <strstr+0x99>
		} while (sc != c);
  8033a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8033a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8033a9:	75 d8                	jne    803383 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8033ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8033b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b7:	48 89 ce             	mov    %rcx,%rsi
  8033ba:	48 89 c7             	mov    %rax,%rdi
  8033bd:	48 b8 33 2e 80 00 00 	movabs $0x802e33,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	75 b6                	jne    803383 <strstr+0x47>

	return (char *) (in - 1);
  8033cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8033d5:	c9                   	leaveq 
  8033d6:	c3                   	retq   

00000000008033d7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033d7:	55                   	push   %rbp
  8033d8:	48 89 e5             	mov    %rsp,%rbp
  8033db:	48 83 ec 30          	sub    $0x30,%rsp
  8033df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8033eb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033f2:	00 00 00 
  8033f5:	48 8b 00             	mov    (%rax),%rax
  8033f8:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	75 34                	jne    803436 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803402:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803413:	48 98                	cltq   
  803415:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80341c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803423:	00 00 00 
  803426:	48 01 c2             	add    %rax,%rdx
  803429:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803430:	00 00 00 
  803433:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803436:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80343b:	75 0e                	jne    80344b <ipc_recv+0x74>
		pg = (void*) UTOP;
  80343d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803444:	00 00 00 
  803447:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80344b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344f:	48 89 c7             	mov    %rax,%rdi
  803452:	48 b8 1c 05 80 00 00 	movabs $0x80051c,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
  80345e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803461:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803465:	79 19                	jns    803480 <ipc_recv+0xa9>
		*from_env_store = 0;
  803467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803475:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80347b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347e:	eb 53                	jmp    8034d3 <ipc_recv+0xfc>
	}
	if(from_env_store)
  803480:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803485:	74 19                	je     8034a0 <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803487:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80348e:	00 00 00 
  803491:	48 8b 00             	mov    (%rax),%rax
  803494:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80349a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8034a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034a5:	74 19                	je     8034c0 <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8034a7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034ae:	00 00 00 
  8034b1:	48 8b 00             	mov    (%rax),%rax
  8034b4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8034ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034be:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8034c0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034c7:	00 00 00 
  8034ca:	48 8b 00             	mov    (%rax),%rax
  8034cd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8034d3:	c9                   	leaveq 
  8034d4:	c3                   	retq   

00000000008034d5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034d5:	55                   	push   %rbp
  8034d6:	48 89 e5             	mov    %rsp,%rbp
  8034d9:	48 83 ec 30          	sub    $0x30,%rsp
  8034dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034e0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034e3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034e7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8034ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034ef:	75 0e                	jne    8034ff <ipc_send+0x2a>
		pg = (void*)UTOP;
  8034f1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034f8:	00 00 00 
  8034fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8034ff:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803502:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803505:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803509:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80350c:	89 c7                	mov    %eax,%edi
  80350e:	48 b8 c7 04 80 00 00 	movabs $0x8004c7,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
  80351a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80351d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803521:	75 0c                	jne    80352f <ipc_send+0x5a>
			sys_yield();
  803523:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80352f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803533:	74 ca                	je     8034ff <ipc_send+0x2a>
	if(result != 0)
  803535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803539:	74 20                	je     80355b <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  80353b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353e:	89 c6                	mov    %eax,%esi
  803540:	48 bf e8 3f 80 00 00 	movabs $0x803fe8,%rdi
  803547:	00 00 00 
  80354a:	b8 00 00 00 00       	mov    $0x0,%eax
  80354f:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  803556:	00 00 00 
  803559:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  80355b:	c9                   	leaveq 
  80355c:	c3                   	retq   

000000000080355d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80355d:	55                   	push   %rbp
  80355e:	48 89 e5             	mov    %rsp,%rbp
  803561:	53                   	push   %rbx
  803562:	48 83 ec 58          	sub    $0x58,%rsp
  803566:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	// LAB 8: Your code here.
	uint64_t addr = (uint64_t)pg;
  80356a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80356e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	int result = 0;
  803572:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803579:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803580:	00 
  803581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803585:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803589:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80358d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803591:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803595:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803599:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80359d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  8035a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a5:	48 c1 e8 27          	shr    $0x27,%rax
  8035a9:	48 89 c2             	mov    %rax,%rdx
  8035ac:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8035b3:	01 00 00 
  8035b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ba:	83 e0 01             	and    $0x1,%eax
  8035bd:	48 85 c0             	test   %rax,%rax
  8035c0:	0f 85 91 00 00 00    	jne    803657 <ipc_host_recv+0xfa>
  8035c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ca:	48 c1 e8 1e          	shr    $0x1e,%rax
  8035ce:	48 89 c2             	mov    %rax,%rdx
  8035d1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8035d8:	01 00 00 
  8035db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035df:	83 e0 01             	and    $0x1,%eax
  8035e2:	48 85 c0             	test   %rax,%rax
  8035e5:	74 70                	je     803657 <ipc_host_recv+0xfa>
  8035e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035eb:	48 c1 e8 15          	shr    $0x15,%rax
  8035ef:	48 89 c2             	mov    %rax,%rdx
  8035f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035f9:	01 00 00 
  8035fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803600:	83 e0 01             	and    $0x1,%eax
  803603:	48 85 c0             	test   %rax,%rax
  803606:	74 4f                	je     803657 <ipc_host_recv+0xfa>
  803608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360c:	48 c1 e8 0c          	shr    $0xc,%rax
  803610:	48 89 c2             	mov    %rax,%rdx
  803613:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80361a:	01 00 00 
  80361d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803621:	83 e0 01             	and    $0x1,%eax
  803624:	48 85 c0             	test   %rax,%rax
  803627:	74 2e                	je     803657 <ipc_host_recv+0xfa>
		if((result = sys_page_alloc(0, (void *) addr , PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362d:	ba 07 04 00 00       	mov    $0x407,%edx
  803632:	48 89 c6             	mov    %rax,%rsi
  803635:	bf 00 00 00 00       	mov    $0x0,%edi
  80363a:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
  803646:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803649:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80364d:	79 08                	jns    803657 <ipc_host_recv+0xfa>
	    	return result;
  80364f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803652:	e9 84 00 00 00       	jmpq   8036db <ipc_host_recv+0x17e>
	a1 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  803657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365b:	48 c1 e8 0c          	shr    $0xc,%rax
  80365f:	48 89 c2             	mov    %rax,%rdx
  803662:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803669:	01 00 00 
  80366c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803670:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803676:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    asm volatile("vmcall\n"
  80367a:	b8 03 00 00 00       	mov    $0x3,%eax
  80367f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803683:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803687:	4c 8b 45 c8          	mov    -0x38(%rbp),%r8
  80368b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80368f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803693:	4c 89 c3             	mov    %r8,%rbx
  803696:	0f 01 c1             	vmcall 
  803699:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	      "c" (a2),
	      "b" (a3),
	      "D" (a4),
	      "S" (a5)
	    : "cc", "memory");
	if (result > 0)
  80369c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8036a0:	7e 36                	jle    8036d8 <ipc_host_recv+0x17b>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCRECV, result);
  8036a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8036a5:	41 89 c0             	mov    %eax,%r8d
  8036a8:	b9 03 00 00 00       	mov    $0x3,%ecx
  8036ad:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  8036b4:	00 00 00 
  8036b7:	be 67 00 00 00       	mov    $0x67,%esi
  8036bc:	48 bf 2d 40 80 00 00 	movabs $0x80402d,%rdi
  8036c3:	00 00 00 
  8036c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cb:	49 b9 90 1e 80 00 00 	movabs $0x801e90,%r9
  8036d2:	00 00 00 
  8036d5:	41 ff d1             	callq  *%r9
	return result;
  8036d8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	
	//panic("ipc_recv not implemented in VM guest");
}
  8036db:	48 83 c4 58          	add    $0x58,%rsp
  8036df:	5b                   	pop    %rbx
  8036e0:	5d                   	pop    %rbp
  8036e1:	c3                   	retq   

00000000008036e2 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8036e2:	55                   	push   %rbp
  8036e3:	48 89 e5             	mov    %rsp,%rbp
  8036e6:	53                   	push   %rbx
  8036e7:	48 83 ec 68          	sub    $0x68,%rsp
  8036eb:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8036ee:	89 75 a8             	mov    %esi,-0x58(%rbp)
  8036f1:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  8036f5:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
	// LAB 8: Your code here.
	
	uint64_t addr = (uint64_t)pg;
  8036f8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8036fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int result = 0;
  803700:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	uint64_t a1,a2,a3,a4,a5;
	a1 = a2 = a3 = a4 = a5 = 0;
  803707:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80370e:	00 
  80370f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803713:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803717:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80371b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80371f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803723:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803727:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80372b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	if(!(uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr)] & PTE_P) && (uvpd[VPD(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P))
  80372f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803733:	48 c1 e8 27          	shr    $0x27,%rax
  803737:	48 89 c2             	mov    %rax,%rdx
  80373a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803741:	01 00 00 
  803744:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803748:	83 e0 01             	and    $0x1,%eax
  80374b:	48 85 c0             	test   %rax,%rax
  80374e:	0f 85 88 00 00 00    	jne    8037dc <ipc_host_send+0xfa>
  803754:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803758:	48 c1 e8 1e          	shr    $0x1e,%rax
  80375c:	48 89 c2             	mov    %rax,%rdx
  80375f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803766:	01 00 00 
  803769:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80376d:	83 e0 01             	and    $0x1,%eax
  803770:	48 85 c0             	test   %rax,%rax
  803773:	74 67                	je     8037dc <ipc_host_send+0xfa>
  803775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803779:	48 c1 e8 15          	shr    $0x15,%rax
  80377d:	48 89 c2             	mov    %rax,%rdx
  803780:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803787:	01 00 00 
  80378a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80378e:	83 e0 01             	and    $0x1,%eax
  803791:	48 85 c0             	test   %rax,%rax
  803794:	74 46                	je     8037dc <ipc_host_send+0xfa>
  803796:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379a:	48 c1 e8 0c          	shr    $0xc,%rax
  80379e:	48 89 c2             	mov    %rax,%rdx
  8037a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037a8:	01 00 00 
  8037ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037af:	83 e0 01             	and    $0x1,%eax
  8037b2:	48 85 c0             	test   %rax,%rax
  8037b5:	74 25                	je     8037dc <ipc_host_send+0xfa>
		a3 = (uint64_t)PTE_ADDR(uvpt[VPN(addr)]);
  8037b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8037bf:	48 89 c2             	mov    %rax,%rdx
  8037c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037c9:	01 00 00 
  8037cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037d0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8037d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8037da:	eb 0e                	jmp    8037ea <ipc_host_send+0x108>
	else
		a3 = UTOP;
  8037dc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8037e3:	00 00 00 
  8037e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cprintf("a3 is [%x]",a3);
  8037ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ee:	48 89 c6             	mov    %rax,%rsi
  8037f1:	48 bf 37 40 80 00 00 	movabs $0x804037,%rdi
  8037f8:	00 00 00 
  8037fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803800:	48 ba c9 20 80 00 00 	movabs $0x8020c9,%rdx
  803807:	00 00 00 
  80380a:	ff d2                	callq  *%rdx
	
	a1 =  to_env;
  80380c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80380f:	48 98                	cltq   
  803811:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	a2 = val;
  803815:	8b 45 a8             	mov    -0x58(%rbp),%eax
  803818:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	a4 = perm;
  80381c:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80381f:	48 98                	cltq   
  803821:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	do{
		asm volatile("vmcall\n"
  803825:	b8 02 00 00 00       	mov    $0x2,%eax
  80382a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80382e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803832:	4c 8b 45 e8          	mov    -0x18(%rbp),%r8
  803836:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80383a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80383e:	4c 89 c3             	mov    %r8,%rbx
  803841:	0f 01 c1             	vmcall 
  803844:	89 45 dc             	mov    %eax,-0x24(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");
		
		 if (result == -E_IPC_NOT_RECV)
  803847:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80384b:	75 0c                	jne    803859 <ipc_host_send+0x177>
			sys_yield();
  80384d:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  803854:	00 00 00 
  803857:	ff d0                	callq  *%rax
	}while(result == -E_IPC_NOT_RECV);
  803859:	83 7d dc f8          	cmpl   $0xfffffff8,-0x24(%rbp)
  80385d:	74 c6                	je     803825 <ipc_host_send+0x143>
	
	if(result !=0)
  80385f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803863:	74 36                	je     80389b <ipc_host_send+0x1b9>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", VMX_VMCALL_IPCSEND, result);
  803865:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803868:	41 89 c0             	mov    %eax,%r8d
  80386b:	b9 02 00 00 00       	mov    $0x2,%ecx
  803870:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  803877:	00 00 00 
  80387a:	be 94 00 00 00       	mov    $0x94,%esi
  80387f:	48 bf 2d 40 80 00 00 	movabs $0x80402d,%rdi
  803886:	00 00 00 
  803889:	b8 00 00 00 00       	mov    $0x0,%eax
  80388e:	49 b9 90 1e 80 00 00 	movabs $0x801e90,%r9
  803895:	00 00 00 
  803898:	41 ff d1             	callq  *%r9
}
  80389b:	48 83 c4 68          	add    $0x68,%rsp
  80389f:	5b                   	pop    %rbx
  8038a0:	5d                   	pop    %rbp
  8038a1:	c3                   	retq   

00000000008038a2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8038a2:	55                   	push   %rbp
  8038a3:	48 89 e5             	mov    %rsp,%rbp
  8038a6:	48 83 ec 14          	sub    $0x14,%rsp
  8038aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8038ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038b4:	eb 4e                	jmp    803904 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8038b6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038bd:	00 00 00 
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	48 98                	cltq   
  8038c5:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8038cc:	48 01 d0             	add    %rdx,%rax
  8038cf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8038d5:	8b 00                	mov    (%rax),%eax
  8038d7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8038da:	75 24                	jne    803900 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8038dc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8038e3:	00 00 00 
  8038e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e9:	48 98                	cltq   
  8038eb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8038f2:	48 01 d0             	add    %rdx,%rax
  8038f5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8038fb:	8b 40 08             	mov    0x8(%rax),%eax
  8038fe:	eb 12                	jmp    803912 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803900:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803904:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80390b:	7e a9                	jle    8038b6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80390d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 83 ec 18          	sub    $0x18,%rsp
  80391c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803924:	48 c1 e8 15          	shr    $0x15,%rax
  803928:	48 89 c2             	mov    %rax,%rdx
  80392b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803932:	01 00 00 
  803935:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803939:	83 e0 01             	and    $0x1,%eax
  80393c:	48 85 c0             	test   %rax,%rax
  80393f:	75 07                	jne    803948 <pageref+0x34>
		return 0;
  803941:	b8 00 00 00 00       	mov    $0x0,%eax
  803946:	eb 53                	jmp    80399b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394c:	48 c1 e8 0c          	shr    $0xc,%rax
  803950:	48 89 c2             	mov    %rax,%rdx
  803953:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80395a:	01 00 00 
  80395d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803961:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803969:	83 e0 01             	and    $0x1,%eax
  80396c:	48 85 c0             	test   %rax,%rax
  80396f:	75 07                	jne    803978 <pageref+0x64>
		return 0;
  803971:	b8 00 00 00 00       	mov    $0x0,%eax
  803976:	eb 23                	jmp    80399b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397c:	48 c1 e8 0c          	shr    $0xc,%rax
  803980:	48 89 c2             	mov    %rax,%rdx
  803983:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80398a:	00 00 00 
  80398d:	48 c1 e2 04          	shl    $0x4,%rdx
  803991:	48 01 d0             	add    %rdx,%rax
  803994:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803998:	0f b7 c0             	movzwl %ax,%eax
}
  80399b:	c9                   	leaveq 
  80399c:	c3                   	retq   
