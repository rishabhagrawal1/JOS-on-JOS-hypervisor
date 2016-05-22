
obj/user/idle:     file format elf64-x86-64


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
  80005c:	48 ba 60 37 80 00 00 	movabs $0x803760,%rdx
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
  8000fe:	48 b8 82 0a 80 00 00 	movabs $0x800a82,%rax
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
  800175:	48 ba 6f 37 80 00 00 	movabs $0x80376f,%rdx
  80017c:	00 00 00 
  80017f:	be 23 00 00 00       	mov    $0x23,%esi
  800184:	48 bf 8c 37 80 00 00 	movabs $0x80378c,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 8e 1f 80 00 00 	movabs $0x801f8e,%r9
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

0000000000800643 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  800643:	55                   	push   %rbp
  800644:	48 89 e5             	mov    %rsp,%rbp
  800647:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_list_vms, 0, 0, 
  80064b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800652:	00 
  800653:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800659:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	ba 00 00 00 00       	mov    $0x0,%edx
  800669:	be 00 00 00 00       	mov    $0x0,%esi
  80066e:	bf 11 00 00 00       	mov    $0x11,%edi
  800673:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80067a:	00 00 00 
  80067d:	ff d0                	callq  *%rax
		       0, 0, 0, 0);
}
  80067f:	c9                   	leaveq 
  800680:	c3                   	retq   

0000000000800681 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  800681:	55                   	push   %rbp
  800682:	48 89 e5             	mov    %rsp,%rbp
  800685:	48 83 ec 10          	sub    $0x10,%rsp
  800689:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  80068c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80068f:	48 98                	cltq   
  800691:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800698:	00 
  800699:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80069f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8006a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006aa:	48 89 c2             	mov    %rax,%rdx
  8006ad:	be 00 00 00 00       	mov    $0x0,%esi
  8006b2:	bf 12 00 00 00       	mov    $0x12,%edi
  8006b7:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8006be:	00 00 00 
  8006c1:	ff d0                	callq  *%rax
}
  8006c3:	c9                   	leaveq 
  8006c4:	c3                   	retq   

00000000008006c5 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8006c5:	55                   	push   %rbp
  8006c6:	48 89 e5             	mov    %rsp,%rbp
  8006c9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8006cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8006d4:	00 
  8006d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8006db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	bf 13 00 00 00       	mov    $0x13,%edi
  8006f5:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  8006fc:	00 00 00 
  8006ff:	ff d0                	callq  *%rax
}
  800701:	c9                   	leaveq 
  800702:	c3                   	retq   

0000000000800703 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  800703:	55                   	push   %rbp
  800704:	48 89 e5             	mov    %rsp,%rbp
  800707:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80070b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800712:	00 
  800713:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800719:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	be 00 00 00 00       	mov    $0x0,%esi
  80072e:	bf 14 00 00 00       	mov    $0x14,%edi
  800733:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  80073a:	00 00 00 
  80073d:	ff d0                	callq  *%rax
}
  80073f:	c9                   	leaveq 
  800740:	c3                   	retq   

0000000000800741 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800741:	55                   	push   %rbp
  800742:	48 89 e5             	mov    %rsp,%rbp
  800745:	48 83 ec 08          	sub    $0x8,%rsp
  800749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80074d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800751:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800758:	ff ff ff 
  80075b:	48 01 d0             	add    %rdx,%rax
  80075e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800762:	c9                   	leaveq 
  800763:	c3                   	retq   

0000000000800764 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800764:	55                   	push   %rbp
  800765:	48 89 e5             	mov    %rsp,%rbp
  800768:	48 83 ec 08          	sub    $0x8,%rsp
  80076c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800774:	48 89 c7             	mov    %rax,%rdi
  800777:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  80077e:	00 00 00 
  800781:	ff d0                	callq  *%rax
  800783:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800789:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80078d:	c9                   	leaveq 
  80078e:	c3                   	retq   

000000000080078f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80078f:	55                   	push   %rbp
  800790:	48 89 e5             	mov    %rsp,%rbp
  800793:	48 83 ec 18          	sub    $0x18,%rsp
  800797:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80079b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007a2:	eb 6b                	jmp    80080f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8007a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007a7:	48 98                	cltq   
  8007a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8007af:	48 c1 e0 0c          	shl    $0xc,%rax
  8007b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8007b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007bb:	48 c1 e8 15          	shr    $0x15,%rax
  8007bf:	48 89 c2             	mov    %rax,%rdx
  8007c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007c9:	01 00 00 
  8007cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d0:	83 e0 01             	and    $0x1,%eax
  8007d3:	48 85 c0             	test   %rax,%rax
  8007d6:	74 21                	je     8007f9 <fd_alloc+0x6a>
  8007d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8007e0:	48 89 c2             	mov    %rax,%rdx
  8007e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007ea:	01 00 00 
  8007ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f1:	83 e0 01             	and    $0x1,%eax
  8007f4:	48 85 c0             	test   %rax,%rax
  8007f7:	75 12                	jne    80080b <fd_alloc+0x7c>
			*fd_store = fd;
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800801:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	eb 1a                	jmp    800825 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80080b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80080f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800813:	7e 8f                	jle    8007a4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800819:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800820:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800825:	c9                   	leaveq 
  800826:	c3                   	retq   

0000000000800827 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800827:	55                   	push   %rbp
  800828:	48 89 e5             	mov    %rsp,%rbp
  80082b:	48 83 ec 20          	sub    $0x20,%rsp
  80082f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800832:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800836:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80083a:	78 06                	js     800842 <fd_lookup+0x1b>
  80083c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800840:	7e 07                	jle    800849 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800842:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800847:	eb 6c                	jmp    8008b5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800849:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80084c:	48 98                	cltq   
  80084e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800854:	48 c1 e0 0c          	shl    $0xc,%rax
  800858:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80085c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800860:	48 c1 e8 15          	shr    $0x15,%rax
  800864:	48 89 c2             	mov    %rax,%rdx
  800867:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80086e:	01 00 00 
  800871:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800875:	83 e0 01             	and    $0x1,%eax
  800878:	48 85 c0             	test   %rax,%rax
  80087b:	74 21                	je     80089e <fd_lookup+0x77>
  80087d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800881:	48 c1 e8 0c          	shr    $0xc,%rax
  800885:	48 89 c2             	mov    %rax,%rdx
  800888:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80088f:	01 00 00 
  800892:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800896:	83 e0 01             	and    $0x1,%eax
  800899:	48 85 c0             	test   %rax,%rax
  80089c:	75 07                	jne    8008a5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80089e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a3:	eb 10                	jmp    8008b5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8008a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8008ad:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8008b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b5:	c9                   	leaveq 
  8008b6:	c3                   	retq   

00000000008008b7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8008b7:	55                   	push   %rbp
  8008b8:	48 89 e5             	mov    %rsp,%rbp
  8008bb:	48 83 ec 30          	sub    $0x30,%rsp
  8008bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cc:	48 89 c7             	mov    %rax,%rdi
  8008cf:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  8008d6:	00 00 00 
  8008d9:	ff d0                	callq  *%rax
  8008db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8008df:	48 89 d6             	mov    %rdx,%rsi
  8008e2:	89 c7                	mov    %eax,%edi
  8008e4:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  8008eb:	00 00 00 
  8008ee:	ff d0                	callq  *%rax
  8008f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008f7:	78 0a                	js     800903 <fd_close+0x4c>
	    || fd != fd2)
  8008f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008fd:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800901:	74 12                	je     800915 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800903:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800907:	74 05                	je     80090e <fd_close+0x57>
  800909:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80090c:	eb 05                	jmp    800913 <fd_close+0x5c>
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	eb 69                	jmp    80097e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800919:	8b 00                	mov    (%rax),%eax
  80091b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80091f:	48 89 d6             	mov    %rdx,%rsi
  800922:	89 c7                	mov    %eax,%edi
  800924:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  80092b:	00 00 00 
  80092e:	ff d0                	callq  *%rax
  800930:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800937:	78 2a                	js     800963 <fd_close+0xac>
		if (dev->dev_close)
  800939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093d:	48 8b 40 20          	mov    0x20(%rax),%rax
  800941:	48 85 c0             	test   %rax,%rax
  800944:	74 16                	je     80095c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80094e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800952:	48 89 d7             	mov    %rdx,%rdi
  800955:	ff d0                	callq  *%rax
  800957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80095a:	eb 07                	jmp    800963 <fd_close+0xac>
		else
			r = 0;
  80095c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800967:	48 89 c6             	mov    %rax,%rsi
  80096a:	bf 00 00 00 00       	mov    $0x0,%edi
  80096f:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800976:	00 00 00 
  800979:	ff d0                	callq  *%rax
	return r;
  80097b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80097e:	c9                   	leaveq 
  80097f:	c3                   	retq   

0000000000800980 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800980:	55                   	push   %rbp
  800981:	48 89 e5             	mov    %rsp,%rbp
  800984:	48 83 ec 20          	sub    $0x20,%rsp
  800988:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80098b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80098f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800996:	eb 41                	jmp    8009d9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800998:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80099f:	00 00 00 
  8009a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8009a5:	48 63 d2             	movslq %edx,%rdx
  8009a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009ac:	8b 00                	mov    (%rax),%eax
  8009ae:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8009b1:	75 22                	jne    8009d5 <dev_lookup+0x55>
			*dev = devtab[i];
  8009b3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8009ba:	00 00 00 
  8009bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8009c0:	48 63 d2             	movslq %edx,%rdx
  8009c3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8009c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009cb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8009ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d3:	eb 60                	jmp    800a35 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8009d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009d9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8009e0:	00 00 00 
  8009e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8009e6:	48 63 d2             	movslq %edx,%rdx
  8009e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009ed:	48 85 c0             	test   %rax,%rax
  8009f0:	75 a6                	jne    800998 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8009f2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8009f9:	00 00 00 
  8009fc:	48 8b 00             	mov    (%rax),%rax
  8009ff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800a05:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800a08:	89 c6                	mov    %eax,%esi
  800a0a:	48 bf a0 37 80 00 00 	movabs $0x8037a0,%rdi
  800a11:	00 00 00 
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
  800a19:	48 b9 c7 21 80 00 00 	movabs $0x8021c7,%rcx
  800a20:	00 00 00 
  800a23:	ff d1                	callq  *%rcx
	*dev = 0;
  800a25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a29:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800a30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a35:	c9                   	leaveq 
  800a36:	c3                   	retq   

0000000000800a37 <close>:

int
close(int fdnum)
{
  800a37:	55                   	push   %rbp
  800a38:	48 89 e5             	mov    %rsp,%rbp
  800a3b:	48 83 ec 20          	sub    $0x20,%rsp
  800a3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800a46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800a49:	48 89 d6             	mov    %rdx,%rsi
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800a55:	00 00 00 
  800a58:	ff d0                	callq  *%rax
  800a5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a61:	79 05                	jns    800a68 <close+0x31>
		return r;
  800a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a66:	eb 18                	jmp    800a80 <close+0x49>
	else
		return fd_close(fd, 1);
  800a68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6c:	be 01 00 00 00       	mov    $0x1,%esi
  800a71:	48 89 c7             	mov    %rax,%rdi
  800a74:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  800a7b:	00 00 00 
  800a7e:	ff d0                	callq  *%rax
}
  800a80:	c9                   	leaveq 
  800a81:	c3                   	retq   

0000000000800a82 <close_all>:

void
close_all(void)
{
  800a82:	55                   	push   %rbp
  800a83:	48 89 e5             	mov    %rsp,%rbp
  800a86:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800a91:	eb 15                	jmp    800aa8 <close_all+0x26>
		close(i);
  800a93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a96:	89 c7                	mov    %eax,%edi
  800a98:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  800a9f:	00 00 00 
  800aa2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800aa4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800aa8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800aac:	7e e5                	jle    800a93 <close_all+0x11>
		close(i);
}
  800aae:	c9                   	leaveq 
  800aaf:	c3                   	retq   

0000000000800ab0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ab0:	55                   	push   %rbp
  800ab1:	48 89 e5             	mov    %rsp,%rbp
  800ab4:	48 83 ec 40          	sub    $0x40,%rsp
  800ab8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800abb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800abe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800ac2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800ac5:	48 89 d6             	mov    %rdx,%rsi
  800ac8:	89 c7                	mov    %eax,%edi
  800aca:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800ad1:	00 00 00 
  800ad4:	ff d0                	callq  *%rax
  800ad6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800add:	79 08                	jns    800ae7 <dup+0x37>
		return r;
  800adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae2:	e9 70 01 00 00       	jmpq   800c57 <dup+0x1a7>
	close(newfdnum);
  800ae7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  800af3:	00 00 00 
  800af6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800af8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800afb:	48 98                	cltq   
  800afd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800b03:	48 c1 e0 0c          	shl    $0xc,%rax
  800b07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b0f:	48 89 c7             	mov    %rax,%rdi
  800b12:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  800b19:	00 00 00 
  800b1c:	ff d0                	callq  *%rax
  800b1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b26:	48 89 c7             	mov    %rax,%rdi
  800b29:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
  800b35:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 c1 e8 15          	shr    $0x15,%rax
  800b41:	48 89 c2             	mov    %rax,%rdx
  800b44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800b4b:	01 00 00 
  800b4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b52:	83 e0 01             	and    $0x1,%eax
  800b55:	48 85 c0             	test   %rax,%rax
  800b58:	74 73                	je     800bcd <dup+0x11d>
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	48 c1 e8 0c          	shr    $0xc,%rax
  800b62:	48 89 c2             	mov    %rax,%rdx
  800b65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b6c:	01 00 00 
  800b6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b73:	83 e0 01             	and    $0x1,%eax
  800b76:	48 85 c0             	test   %rax,%rax
  800b79:	74 52                	je     800bcd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7f:	48 c1 e8 0c          	shr    $0xc,%rax
  800b83:	48 89 c2             	mov    %rax,%rdx
  800b86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b8d:	01 00 00 
  800b90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b94:	25 07 0e 00 00       	and    $0xe07,%eax
  800b99:	89 c1                	mov    %eax,%ecx
  800b9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba3:	41 89 c8             	mov    %ecx,%r8d
  800ba6:	48 89 d1             	mov    %rdx,%rcx
  800ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bae:	48 89 c6             	mov    %rax,%rsi
  800bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb6:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800bbd:	00 00 00 
  800bc0:	ff d0                	callq  *%rax
  800bc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bc9:	79 02                	jns    800bcd <dup+0x11d>
			goto err;
  800bcb:	eb 57                	jmp    800c24 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800bcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800bd1:	48 c1 e8 0c          	shr    $0xc,%rax
  800bd5:	48 89 c2             	mov    %rax,%rdx
  800bd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800bdf:	01 00 00 
  800be2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800be6:	25 07 0e 00 00       	and    $0xe07,%eax
  800beb:	89 c1                	mov    %eax,%ecx
  800bed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800bf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bf5:	41 89 c8             	mov    %ecx,%r8d
  800bf8:	48 89 d1             	mov    %rdx,%rcx
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	48 89 c6             	mov    %rax,%rsi
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
  800c08:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	callq  *%rax
  800c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c1b:	79 02                	jns    800c1f <dup+0x16f>
		goto err;
  800c1d:	eb 05                	jmp    800c24 <dup+0x174>

	return newfdnum;
  800c1f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800c22:	eb 33                	jmp    800c57 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	48 89 c6             	mov    %rax,%rsi
  800c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c30:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800c37:	00 00 00 
  800c3a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800c3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c40:	48 89 c6             	mov    %rax,%rsi
  800c43:	bf 00 00 00 00       	mov    $0x0,%edi
  800c48:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	callq  *%rax
	return r;
  800c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c57:	c9                   	leaveq 
  800c58:	c3                   	retq   

0000000000800c59 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800c59:	55                   	push   %rbp
  800c5a:	48 89 e5             	mov    %rsp,%rbp
  800c5d:	48 83 ec 40          	sub    $0x40,%rsp
  800c61:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c68:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c70:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c73:	48 89 d6             	mov    %rdx,%rsi
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800c7f:	00 00 00 
  800c82:	ff d0                	callq  *%rax
  800c84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c8b:	78 24                	js     800cb1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c91:	8b 00                	mov    (%rax),%eax
  800c93:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c97:	48 89 d6             	mov    %rdx,%rsi
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800caf:	79 05                	jns    800cb6 <read+0x5d>
		return r;
  800cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb4:	eb 76                	jmp    800d2c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cba:	8b 40 08             	mov    0x8(%rax),%eax
  800cbd:	83 e0 03             	and    $0x3,%eax
  800cc0:	83 f8 01             	cmp    $0x1,%eax
  800cc3:	75 3a                	jne    800cff <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800cc5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ccc:	00 00 00 
  800ccf:	48 8b 00             	mov    (%rax),%rax
  800cd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800cd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800cdb:	89 c6                	mov    %eax,%esi
  800cdd:	48 bf bf 37 80 00 00 	movabs $0x8037bf,%rdi
  800ce4:	00 00 00 
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	48 b9 c7 21 80 00 00 	movabs $0x8021c7,%rcx
  800cf3:	00 00 00 
  800cf6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cfd:	eb 2d                	jmp    800d2c <read+0xd3>
	}
	if (!dev->dev_read)
  800cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d03:	48 8b 40 10          	mov    0x10(%rax),%rax
  800d07:	48 85 c0             	test   %rax,%rax
  800d0a:	75 07                	jne    800d13 <read+0xba>
		return -E_NOT_SUPP;
  800d0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d11:	eb 19                	jmp    800d2c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d17:	48 8b 40 10          	mov    0x10(%rax),%rax
  800d1b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d23:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d27:	48 89 cf             	mov    %rcx,%rdi
  800d2a:	ff d0                	callq  *%rax
}
  800d2c:	c9                   	leaveq 
  800d2d:	c3                   	retq   

0000000000800d2e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800d2e:	55                   	push   %rbp
  800d2f:	48 89 e5             	mov    %rsp,%rbp
  800d32:	48 83 ec 30          	sub    $0x30,%rsp
  800d36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800d3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d48:	eb 49                	jmp    800d93 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d4d:	48 98                	cltq   
  800d4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800d53:	48 29 c2             	sub    %rax,%rdx
  800d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d59:	48 63 c8             	movslq %eax,%rcx
  800d5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800d60:	48 01 c1             	add    %rax,%rcx
  800d63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d66:	48 89 ce             	mov    %rcx,%rsi
  800d69:	89 c7                	mov    %eax,%edi
  800d6b:	48 b8 59 0c 80 00 00 	movabs $0x800c59,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
  800d77:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800d7a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d7e:	79 05                	jns    800d85 <readn+0x57>
			return m;
  800d80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d83:	eb 1c                	jmp    800da1 <readn+0x73>
		if (m == 0)
  800d85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d89:	75 02                	jne    800d8d <readn+0x5f>
			break;
  800d8b:	eb 11                	jmp    800d9e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d90:	01 45 fc             	add    %eax,-0x4(%rbp)
  800d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d96:	48 98                	cltq   
  800d98:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800d9c:	72 ac                	jb     800d4a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800da1:	c9                   	leaveq 
  800da2:	c3                   	retq   

0000000000800da3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800da3:	55                   	push   %rbp
  800da4:	48 89 e5             	mov    %rsp,%rbp
  800da7:	48 83 ec 40          	sub    $0x40,%rsp
  800dab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800db2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800db6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dbd:	48 89 d6             	mov    %rdx,%rsi
  800dc0:	89 c7                	mov    %eax,%edi
  800dc2:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800dc9:	00 00 00 
  800dcc:	ff d0                	callq  *%rax
  800dce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dd5:	78 24                	js     800dfb <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddb:	8b 00                	mov    (%rax),%eax
  800ddd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de1:	48 89 d6             	mov    %rdx,%rsi
  800de4:	89 c7                	mov    %eax,%edi
  800de6:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  800ded:	00 00 00 
  800df0:	ff d0                	callq  *%rax
  800df2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df9:	79 05                	jns    800e00 <write+0x5d>
		return r;
  800dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dfe:	eb 42                	jmp    800e42 <write+0x9f>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e04:	8b 40 08             	mov    0x8(%rax),%eax
  800e07:	83 e0 03             	and    $0x3,%eax
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	75 07                	jne    800e15 <write+0x72>
		//cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e13:	eb 2d                	jmp    800e42 <write+0x9f>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e19:	48 8b 40 18          	mov    0x18(%rax),%rax
  800e1d:	48 85 c0             	test   %rax,%rax
  800e20:	75 07                	jne    800e29 <write+0x86>
		return -E_NOT_SUPP;
  800e22:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e27:	eb 19                	jmp    800e42 <write+0x9f>
	return (*dev->dev_write)(fd, buf, n);
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	48 8b 40 18          	mov    0x18(%rax),%rax
  800e31:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800e35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e39:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800e3d:	48 89 cf             	mov    %rcx,%rdi
  800e40:	ff d0                	callq  *%rax
}
  800e42:	c9                   	leaveq 
  800e43:	c3                   	retq   

0000000000800e44 <seek>:

int
seek(int fdnum, off_t offset)
{
  800e44:	55                   	push   %rbp
  800e45:	48 89 e5             	mov    %rsp,%rbp
  800e48:	48 83 ec 18          	sub    $0x18,%rsp
  800e4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800e4f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e52:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800e59:	48 89 d6             	mov    %rdx,%rsi
  800e5c:	89 c7                	mov    %eax,%edi
  800e5e:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800e65:	00 00 00 
  800e68:	ff d0                	callq  *%rax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e71:	79 05                	jns    800e78 <seek+0x34>
		return r;
  800e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e76:	eb 0f                	jmp    800e87 <seek+0x43>
	fd->fd_offset = offset;
  800e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800e7f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e87:	c9                   	leaveq 
  800e88:	c3                   	retq   

0000000000800e89 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e89:	55                   	push   %rbp
  800e8a:	48 89 e5             	mov    %rsp,%rbp
  800e8d:	48 83 ec 30          	sub    $0x30,%rsp
  800e91:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e94:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e97:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e9b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e9e:	48 89 d6             	mov    %rdx,%rsi
  800ea1:	89 c7                	mov    %eax,%edi
  800ea3:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
  800eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eb6:	78 24                	js     800edc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	8b 00                	mov    (%rax),%eax
  800ebe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ec2:	48 89 d6             	mov    %rdx,%rsi
  800ec5:	89 c7                	mov    %eax,%edi
  800ec7:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  800ece:	00 00 00 
  800ed1:	ff d0                	callq  *%rax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ed6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eda:	79 05                	jns    800ee1 <ftruncate+0x58>
		return r;
  800edc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800edf:	eb 72                	jmp    800f53 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	8b 40 08             	mov    0x8(%rax),%eax
  800ee8:	83 e0 03             	and    $0x3,%eax
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 3a                	jne    800f29 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800eef:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ef6:	00 00 00 
  800ef9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800efc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800f02:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800f05:	89 c6                	mov    %eax,%esi
  800f07:	48 bf e0 37 80 00 00 	movabs $0x8037e0,%rdi
  800f0e:	00 00 00 
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	48 b9 c7 21 80 00 00 	movabs $0x8021c7,%rcx
  800f1d:	00 00 00 
  800f20:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800f22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f27:	eb 2a                	jmp    800f53 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800f29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2d:	48 8b 40 30          	mov    0x30(%rax),%rax
  800f31:	48 85 c0             	test   %rax,%rax
  800f34:	75 07                	jne    800f3d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800f36:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f3b:	eb 16                	jmp    800f53 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f41:	48 8b 40 30          	mov    0x30(%rax),%rax
  800f45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f49:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800f4c:	89 ce                	mov    %ecx,%esi
  800f4e:	48 89 d7             	mov    %rdx,%rdi
  800f51:	ff d0                	callq  *%rax
}
  800f53:	c9                   	leaveq 
  800f54:	c3                   	retq   

0000000000800f55 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f55:	55                   	push   %rbp
  800f56:	48 89 e5             	mov    %rsp,%rbp
  800f59:	48 83 ec 30          	sub    $0x30,%rsp
  800f5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800f60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800f68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800f6b:	48 89 d6             	mov    %rdx,%rsi
  800f6e:	89 c7                	mov    %eax,%edi
  800f70:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	callq  *%rax
  800f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f83:	78 24                	js     800fa9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f89:	8b 00                	mov    (%rax),%eax
  800f8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f8f:	48 89 d6             	mov    %rdx,%rsi
  800f92:	89 c7                	mov    %eax,%edi
  800f94:	48 b8 80 09 80 00 00 	movabs $0x800980,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa7:	79 05                	jns    800fae <fstat+0x59>
		return r;
  800fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fac:	eb 5e                	jmp    80100c <fstat+0xb7>
	if (!dev->dev_stat)
  800fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb2:	48 8b 40 28          	mov    0x28(%rax),%rax
  800fb6:	48 85 c0             	test   %rax,%rax
  800fb9:	75 07                	jne    800fc2 <fstat+0x6d>
		return -E_NOT_SUPP;
  800fbb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800fc0:	eb 4a                	jmp    80100c <fstat+0xb7>
	stat->st_name[0] = 0;
  800fc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fc6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800fc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fcd:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800fd4:	00 00 00 
	stat->st_isdir = 0;
  800fd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fdb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800fe2:	00 00 00 
	stat->st_dev = dev;
  800fe5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fe9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fed:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff8:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801000:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801004:	48 89 ce             	mov    %rcx,%rsi
  801007:	48 89 d7             	mov    %rdx,%rdi
  80100a:	ff d0                	callq  *%rax
}
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 20          	sub    $0x20,%rsp
  801016:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80101e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801022:	be 00 00 00 00       	mov    $0x0,%esi
  801027:	48 89 c7             	mov    %rax,%rdi
  80102a:	48 b8 fc 10 80 00 00 	movabs $0x8010fc,%rax
  801031:	00 00 00 
  801034:	ff d0                	callq  *%rax
  801036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801039:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80103d:	79 05                	jns    801044 <stat+0x36>
		return fd;
  80103f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801042:	eb 2f                	jmp    801073 <stat+0x65>
	r = fstat(fd, stat);
  801044:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80104b:	48 89 d6             	mov    %rdx,%rsi
  80104e:	89 c7                	mov    %eax,%edi
  801050:	48 b8 55 0f 80 00 00 	movabs $0x800f55,%rax
  801057:	00 00 00 
  80105a:	ff d0                	callq  *%rax
  80105c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80105f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801062:	89 c7                	mov    %eax,%edi
  801064:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  80106b:	00 00 00 
  80106e:	ff d0                	callq  *%rax
	return r;
  801070:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801073:	c9                   	leaveq 
  801074:	c3                   	retq   

0000000000801075 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	48 83 ec 10          	sub    $0x10,%rsp
  80107d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801080:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801084:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80108b:	00 00 00 
  80108e:	8b 00                	mov    (%rax),%eax
  801090:	85 c0                	test   %eax,%eax
  801092:	75 1d                	jne    8010b1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801094:	bf 01 00 00 00       	mov    $0x1,%edi
  801099:	48 b8 5b 36 80 00 00 	movabs $0x80365b,%rax
  8010a0:	00 00 00 
  8010a3:	ff d0                	callq  *%rax
  8010a5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8010ac:	00 00 00 
  8010af:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8010b1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8010b8:	00 00 00 
  8010bb:	8b 00                	mov    (%rax),%eax
  8010bd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8010c0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8010c5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8010cc:	00 00 00 
  8010cf:	89 c7                	mov    %eax,%edi
  8010d1:	48 b8 d3 35 80 00 00 	movabs $0x8035d3,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8010dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e6:	48 89 c6             	mov    %rax,%rsi
  8010e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ee:	48 b8 d5 34 80 00 00 	movabs $0x8034d5,%rax
  8010f5:	00 00 00 
  8010f8:	ff d0                	callq  *%rax
}
  8010fa:	c9                   	leaveq 
  8010fb:	c3                   	retq   

00000000008010fc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
  801100:	48 83 ec 30          	sub    $0x30,%rsp
  801104:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801108:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80110b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  801112:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  801119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  801120:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801125:	75 08                	jne    80112f <open+0x33>
	{
		return r;
  801127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112a:	e9 f2 00 00 00       	jmpq   801221 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80112f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801133:	48 89 c7             	mov    %rax,%rdi
  801136:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  80113d:	00 00 00 
  801140:	ff d0                	callq  *%rax
  801142:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801145:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80114c:	7e 0a                	jle    801158 <open+0x5c>
	{
		return -E_BAD_PATH;
  80114e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801153:	e9 c9 00 00 00       	jmpq   801221 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801158:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80115f:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801160:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801164:	48 89 c7             	mov    %rax,%rdi
  801167:	48 b8 8f 07 80 00 00 	movabs $0x80078f,%rax
  80116e:	00 00 00 
  801171:	ff d0                	callq  *%rax
  801173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80117a:	78 09                	js     801185 <open+0x89>
  80117c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801180:	48 85 c0             	test   %rax,%rax
  801183:	75 08                	jne    80118d <open+0x91>
		{
			return r;
  801185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801188:	e9 94 00 00 00       	jmpq   801221 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80118d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801191:	ba 00 04 00 00       	mov    $0x400,%edx
  801196:	48 89 c6             	mov    %rax,%rsi
  801199:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8011a0:	00 00 00 
  8011a3:	48 b8 0e 2e 80 00 00 	movabs $0x802e0e,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8011af:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011b6:	00 00 00 
  8011b9:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8011bc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	48 89 c6             	mov    %rax,%rsi
  8011c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8011ce:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  8011d5:	00 00 00 
  8011d8:	ff d0                	callq  *%rax
  8011da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011e1:	79 2b                	jns    80120e <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	be 00 00 00 00       	mov    $0x0,%esi
  8011ec:	48 89 c7             	mov    %rax,%rdi
  8011ef:	48 b8 b7 08 80 00 00 	movabs $0x8008b7,%rax
  8011f6:	00 00 00 
  8011f9:	ff d0                	callq  *%rax
  8011fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8011fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801202:	79 05                	jns    801209 <open+0x10d>
			{
				return d;
  801204:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801207:	eb 18                	jmp    801221 <open+0x125>
			}
			return r;
  801209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120c:	eb 13                	jmp    801221 <open+0x125>
		}	
		return fd2num(fd_store);
  80120e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801212:	48 89 c7             	mov    %rax,%rdi
  801215:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  80121c:	00 00 00 
  80121f:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801221:	c9                   	leaveq 
  801222:	c3                   	retq   

0000000000801223 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801223:	55                   	push   %rbp
  801224:	48 89 e5             	mov    %rsp,%rbp
  801227:	48 83 ec 10          	sub    $0x10,%rsp
  80122b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80122f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801233:	8b 50 0c             	mov    0xc(%rax),%edx
  801236:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80123d:	00 00 00 
  801240:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801242:	be 00 00 00 00       	mov    $0x0,%esi
  801247:	bf 06 00 00 00       	mov    $0x6,%edi
  80124c:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  801253:	00 00 00 
  801256:	ff d0                	callq  *%rax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 30          	sub    $0x30,%rsp
  801262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80126e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801275:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127a:	74 07                	je     801283 <devfile_read+0x29>
  80127c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801281:	75 07                	jne    80128a <devfile_read+0x30>
		return -E_INVAL;
  801283:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801288:	eb 77                	jmp    801301 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80128a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128e:	8b 50 0c             	mov    0xc(%rax),%edx
  801291:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801298:	00 00 00 
  80129b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80129d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012a4:	00 00 00 
  8012a7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8012af:	be 00 00 00 00       	mov    $0x0,%esi
  8012b4:	bf 03 00 00 00       	mov    $0x3,%edi
  8012b9:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  8012c0:	00 00 00 
  8012c3:	ff d0                	callq  *%rax
  8012c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012cc:	7f 05                	jg     8012d3 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8012ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012d1:	eb 2e                	jmp    801301 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8012d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012d6:	48 63 d0             	movslq %eax,%rdx
  8012d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012dd:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012e4:	00 00 00 
  8012e7:	48 89 c7             	mov    %rax,%rdi
  8012ea:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  8012f1:	00 00 00 
  8012f4:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8012f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8012fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 30          	sub    $0x30,%rsp
  80130b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801317:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80131e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801323:	74 07                	je     80132c <devfile_write+0x29>
  801325:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80132a:	75 08                	jne    801334 <devfile_write+0x31>
		return r;
  80132c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80132f:	e9 9a 00 00 00       	jmpq   8013ce <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	8b 50 0c             	mov    0xc(%rax),%edx
  80133b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801342:	00 00 00 
  801345:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801347:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80134e:	00 
  80134f:	76 08                	jbe    801359 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801351:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801358:	00 
	}
	fsipcbuf.write.req_n = n;
  801359:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801360:	00 00 00 
  801363:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801367:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80136b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80136f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801373:	48 89 c6             	mov    %rax,%rsi
  801376:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80137d:	00 00 00 
  801380:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  801387:	00 00 00 
  80138a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80138c:	be 00 00 00 00       	mov    $0x0,%esi
  801391:	bf 04 00 00 00       	mov    $0x4,%edi
  801396:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  80139d:	00 00 00 
  8013a0:	ff d0                	callq  *%rax
  8013a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013a9:	7f 20                	jg     8013cb <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8013ab:	48 bf 06 38 80 00 00 	movabs $0x803806,%rdi
  8013b2:	00 00 00 
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  8013c1:	00 00 00 
  8013c4:	ff d2                	callq  *%rdx
		return r;
  8013c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c9:	eb 03                	jmp    8013ce <devfile_write+0xcb>
	}
	return r;
  8013cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 83 ec 20          	sub    $0x20,%rsp
  8013d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8013e7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013ee:	00 00 00 
  8013f1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013f3:	be 00 00 00 00       	mov    $0x0,%esi
  8013f8:	bf 05 00 00 00       	mov    $0x5,%edi
  8013fd:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  801404:	00 00 00 
  801407:	ff d0                	callq  *%rax
  801409:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80140c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801410:	79 05                	jns    801417 <devfile_stat+0x47>
		return r;
  801412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801415:	eb 56                	jmp    80146d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801417:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801422:	00 00 00 
  801425:	48 89 c7             	mov    %rax,%rdi
  801428:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  80142f:	00 00 00 
  801432:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801434:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80143b:	00 00 00 
  80143e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801444:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801448:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80144e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801455:	00 00 00 
  801458:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80145e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801462:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 10          	sub    $0x10,%rsp
  801477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	8b 50 0c             	mov    0xc(%rax),%edx
  801485:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80148c:	00 00 00 
  80148f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801491:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801498:	00 00 00 
  80149b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80149e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014a1:	be 00 00 00 00       	mov    $0x0,%esi
  8014a6:	bf 02 00 00 00       	mov    $0x2,%edi
  8014ab:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	callq  *%rax
}
  8014b7:	c9                   	leaveq 
  8014b8:	c3                   	retq   

00000000008014b9 <remove>:

// Delete a file
int
remove(const char *path)
{
  8014b9:	55                   	push   %rbp
  8014ba:	48 89 e5             	mov    %rsp,%rbp
  8014bd:	48 83 ec 10          	sub    $0x10,%rsp
  8014c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	48 89 c7             	mov    %rax,%rdi
  8014cc:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  8014d3:	00 00 00 
  8014d6:	ff d0                	callq  *%rax
  8014d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014dd:	7e 07                	jle    8014e6 <remove+0x2d>
		return -E_BAD_PATH;
  8014df:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8014e4:	eb 33                	jmp    801519 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	48 89 c6             	mov    %rax,%rsi
  8014ed:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8014f4:	00 00 00 
  8014f7:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  8014fe:	00 00 00 
  801501:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801503:	be 00 00 00 00       	mov    $0x0,%esi
  801508:	bf 07 00 00 00       	mov    $0x7,%edi
  80150d:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
}
  801519:	c9                   	leaveq 
  80151a:	c3                   	retq   

000000000080151b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80151b:	55                   	push   %rbp
  80151c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80151f:	be 00 00 00 00       	mov    $0x0,%esi
  801524:	bf 08 00 00 00       	mov    $0x8,%edi
  801529:	48 b8 75 10 80 00 00 	movabs $0x801075,%rax
  801530:	00 00 00 
  801533:	ff d0                	callq  *%rax
}
  801535:	5d                   	pop    %rbp
  801536:	c3                   	retq   

0000000000801537 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801542:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801549:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801550:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801557:	be 00 00 00 00       	mov    $0x0,%esi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 fc 10 80 00 00 	movabs $0x8010fc,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
  80156b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80156e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801572:	79 28                	jns    80159c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801577:	89 c6                	mov    %eax,%esi
  801579:	48 bf 22 38 80 00 00 	movabs $0x803822,%rdi
  801580:	00 00 00 
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
  801588:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  80158f:	00 00 00 
  801592:	ff d2                	callq  *%rdx
		return fd_src;
  801594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801597:	e9 74 01 00 00       	jmpq   801710 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80159c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8015a3:	be 01 01 00 00       	mov    $0x101,%esi
  8015a8:	48 89 c7             	mov    %rax,%rdi
  8015ab:	48 b8 fc 10 80 00 00 	movabs $0x8010fc,%rax
  8015b2:	00 00 00 
  8015b5:	ff d0                	callq  *%rax
  8015b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8015ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8015be:	79 39                	jns    8015f9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8015c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015c3:	89 c6                	mov    %eax,%esi
  8015c5:	48 bf 38 38 80 00 00 	movabs $0x803838,%rdi
  8015cc:	00 00 00 
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  8015db:	00 00 00 
  8015de:	ff d2                	callq  *%rdx
		close(fd_src);
  8015e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e3:	89 c7                	mov    %eax,%edi
  8015e5:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  8015ec:	00 00 00 
  8015ef:	ff d0                	callq  *%rax
		return fd_dest;
  8015f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015f4:	e9 17 01 00 00       	jmpq   801710 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8015f9:	eb 74                	jmp    80166f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8015fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fe:	48 63 d0             	movslq %eax,%rdx
  801601:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801608:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80160b:	48 89 ce             	mov    %rcx,%rsi
  80160e:	89 c7                	mov    %eax,%edi
  801610:	48 b8 a3 0d 80 00 00 	movabs $0x800da3,%rax
  801617:	00 00 00 
  80161a:	ff d0                	callq  *%rax
  80161c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80161f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801623:	79 4a                	jns    80166f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801625:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801628:	89 c6                	mov    %eax,%esi
  80162a:	48 bf 52 38 80 00 00 	movabs $0x803852,%rdi
  801631:	00 00 00 
  801634:	b8 00 00 00 00       	mov    $0x0,%eax
  801639:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  801640:	00 00 00 
  801643:	ff d2                	callq  *%rdx
			close(fd_src);
  801645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801648:	89 c7                	mov    %eax,%edi
  80164a:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  801651:	00 00 00 
  801654:	ff d0                	callq  *%rax
			close(fd_dest);
  801656:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801659:	89 c7                	mov    %eax,%edi
  80165b:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  801662:	00 00 00 
  801665:	ff d0                	callq  *%rax
			return write_size;
  801667:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80166a:	e9 a1 00 00 00       	jmpq   801710 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80166f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801676:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801679:	ba 00 02 00 00       	mov    $0x200,%edx
  80167e:	48 89 ce             	mov    %rcx,%rsi
  801681:	89 c7                	mov    %eax,%edi
  801683:	48 b8 59 0c 80 00 00 	movabs $0x800c59,%rax
  80168a:	00 00 00 
  80168d:	ff d0                	callq  *%rax
  80168f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801692:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801696:	0f 8f 5f ff ff ff    	jg     8015fb <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80169c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8016a0:	79 47                	jns    8016e9 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8016a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a5:	89 c6                	mov    %eax,%esi
  8016a7:	48 bf 65 38 80 00 00 	movabs $0x803865,%rdi
  8016ae:	00 00 00 
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b6:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  8016bd:	00 00 00 
  8016c0:	ff d2                	callq  *%rdx
		close(fd_src);
  8016c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016c5:	89 c7                	mov    %eax,%edi
  8016c7:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  8016ce:	00 00 00 
  8016d1:	ff d0                	callq  *%rax
		close(fd_dest);
  8016d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016d6:	89 c7                	mov    %eax,%edi
  8016d8:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  8016df:	00 00 00 
  8016e2:	ff d0                	callq  *%rax
		return read_size;
  8016e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e7:	eb 27                	jmp    801710 <copy+0x1d9>
	}
	close(fd_src);
  8016e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ec:	89 c7                	mov    %eax,%edi
  8016ee:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  8016f5:	00 00 00 
  8016f8:	ff d0                	callq  *%rax
	close(fd_dest);
  8016fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016fd:	89 c7                	mov    %eax,%edi
  8016ff:	48 b8 37 0a 80 00 00 	movabs $0x800a37,%rax
  801706:	00 00 00 
  801709:	ff d0                	callq  *%rax
	return 0;
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801710:	c9                   	leaveq 
  801711:	c3                   	retq   

0000000000801712 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801712:	55                   	push   %rbp
  801713:	48 89 e5             	mov    %rsp,%rbp
  801716:	53                   	push   %rbx
  801717:	48 83 ec 38          	sub    $0x38,%rsp
  80171b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80171f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801723:	48 89 c7             	mov    %rax,%rdi
  801726:	48 b8 8f 07 80 00 00 	movabs $0x80078f,%rax
  80172d:	00 00 00 
  801730:	ff d0                	callq  *%rax
  801732:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801735:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801739:	0f 88 bf 01 00 00    	js     8018fe <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	ba 07 04 00 00       	mov    $0x407,%edx
  801748:	48 89 c6             	mov    %rax,%rsi
  80174b:	bf 00 00 00 00       	mov    $0x0,%edi
  801750:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
  80175c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80175f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801763:	0f 88 95 01 00 00    	js     8018fe <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801769:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80176d:	48 89 c7             	mov    %rax,%rdi
  801770:	48 b8 8f 07 80 00 00 	movabs $0x80078f,%rax
  801777:	00 00 00 
  80177a:	ff d0                	callq  *%rax
  80177c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80177f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801783:	0f 88 5d 01 00 00    	js     8018e6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801789:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178d:	ba 07 04 00 00       	mov    $0x407,%edx
  801792:	48 89 c6             	mov    %rax,%rsi
  801795:	bf 00 00 00 00       	mov    $0x0,%edi
  80179a:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8017a1:	00 00 00 
  8017a4:	ff d0                	callq  *%rax
  8017a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8017ad:	0f 88 33 01 00 00    	js     8018e6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	48 89 c7             	mov    %rax,%rdi
  8017ba:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	callq  *%rax
  8017c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8017d3:	48 89 c6             	mov    %rax,%rsi
  8017d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8017db:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8017e2:	00 00 00 
  8017e5:	ff d0                	callq  *%rax
  8017e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8017ee:	79 05                	jns    8017f5 <pipe+0xe3>
		goto err2;
  8017f0:	e9 d9 00 00 00       	jmpq   8018ce <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f9:	48 89 c7             	mov    %rax,%rdi
  8017fc:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801803:	00 00 00 
  801806:	ff d0                	callq  *%rax
  801808:	48 89 c2             	mov    %rax,%rdx
  80180b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801815:	48 89 d1             	mov    %rdx,%rcx
  801818:	ba 00 00 00 00       	mov    $0x0,%edx
  80181d:	48 89 c6             	mov    %rax,%rsi
  801820:	bf 00 00 00 00       	mov    $0x0,%edi
  801825:	48 b8 43 03 80 00 00 	movabs $0x800343,%rax
  80182c:	00 00 00 
  80182f:	ff d0                	callq  *%rax
  801831:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801834:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801838:	79 1b                	jns    801855 <pipe+0x143>
		goto err3;
  80183a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80183b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80183f:	48 89 c6             	mov    %rax,%rsi
  801842:	bf 00 00 00 00       	mov    $0x0,%edi
  801847:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  80184e:	00 00 00 
  801851:	ff d0                	callq  *%rax
  801853:	eb 79                	jmp    8018ce <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801859:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  801860:	00 00 00 
  801863:	8b 12                	mov    (%rdx),%edx
  801865:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801876:	48 ba e0 50 80 00 00 	movabs $0x8050e0,%rdx
  80187d:	00 00 00 
  801880:	8b 12                	mov    (%rdx),%edx
  801882:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801884:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801888:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80188f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801893:	48 89 c7             	mov    %rax,%rdi
  801896:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  80189d:	00 00 00 
  8018a0:	ff d0                	callq  *%rax
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8018a8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8018aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8018ae:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8018b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b6:	48 89 c7             	mov    %rax,%rdi
  8018b9:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
  8018c5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	eb 33                	jmp    801901 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8018ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d2:	48 89 c6             	mov    %rax,%rsi
  8018d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018da:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8018e1:	00 00 00 
  8018e4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8018e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ea:	48 89 c6             	mov    %rax,%rsi
  8018ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f2:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
err:
	return r;
  8018fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801901:	48 83 c4 38          	add    $0x38,%rsp
  801905:	5b                   	pop    %rbx
  801906:	5d                   	pop    %rbp
  801907:	c3                   	retq   

0000000000801908 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801908:	55                   	push   %rbp
  801909:	48 89 e5             	mov    %rsp,%rbp
  80190c:	53                   	push   %rbx
  80190d:	48 83 ec 28          	sub    $0x28,%rsp
  801911:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801915:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801919:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801920:	00 00 00 
  801923:	48 8b 00             	mov    (%rax),%rax
  801926:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80192c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	48 89 c7             	mov    %rax,%rdi
  801936:	48 b8 cd 36 80 00 00 	movabs $0x8036cd,%rax
  80193d:	00 00 00 
  801940:	ff d0                	callq  *%rax
  801942:	89 c3                	mov    %eax,%ebx
  801944:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801948:	48 89 c7             	mov    %rax,%rdi
  80194b:	48 b8 cd 36 80 00 00 	movabs $0x8036cd,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
  801957:	39 c3                	cmp    %eax,%ebx
  801959:	0f 94 c0             	sete   %al
  80195c:	0f b6 c0             	movzbl %al,%eax
  80195f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801962:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801969:	00 00 00 
  80196c:	48 8b 00             	mov    (%rax),%rax
  80196f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801975:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801978:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80197e:	75 05                	jne    801985 <_pipeisclosed+0x7d>
			return ret;
  801980:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801983:	eb 4f                	jmp    8019d4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801985:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801988:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80198b:	74 42                	je     8019cf <_pipeisclosed+0xc7>
  80198d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801991:	75 3c                	jne    8019cf <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801993:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80199a:	00 00 00 
  80199d:	48 8b 00             	mov    (%rax),%rax
  8019a0:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8019a6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8019a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019ac:	89 c6                	mov    %eax,%esi
  8019ae:	48 bf 85 38 80 00 00 	movabs $0x803885,%rdi
  8019b5:	00 00 00 
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bd:	49 b8 c7 21 80 00 00 	movabs $0x8021c7,%r8
  8019c4:	00 00 00 
  8019c7:	41 ff d0             	callq  *%r8
	}
  8019ca:	e9 4a ff ff ff       	jmpq   801919 <_pipeisclosed+0x11>
  8019cf:	e9 45 ff ff ff       	jmpq   801919 <_pipeisclosed+0x11>
}
  8019d4:	48 83 c4 28          	add    $0x28,%rsp
  8019d8:	5b                   	pop    %rbx
  8019d9:	5d                   	pop    %rbp
  8019da:	c3                   	retq   

00000000008019db <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 30          	sub    $0x30,%rsp
  8019e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8019ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019ed:	48 89 d6             	mov    %rdx,%rsi
  8019f0:	89 c7                	mov    %eax,%edi
  8019f2:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  8019f9:	00 00 00 
  8019fc:	ff d0                	callq  *%rax
  8019fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a05:	79 05                	jns    801a0c <pipeisclosed+0x31>
		return r;
  801a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0a:	eb 31                	jmp    801a3d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a10:	48 89 c7             	mov    %rax,%rdi
  801a13:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
  801a1f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2b:	48 89 d6             	mov    %rdx,%rsi
  801a2e:	48 89 c7             	mov    %rax,%rdi
  801a31:	48 b8 08 19 80 00 00 	movabs $0x801908,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	callq  *%rax
}
  801a3d:	c9                   	leaveq 
  801a3e:	c3                   	retq   

0000000000801a3f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	48 83 ec 40          	sub    $0x40,%rsp
  801a47:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a4b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a4f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a57:	48 89 c7             	mov    %rax,%rdi
  801a5a:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
  801a66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801a6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801a72:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a79:	00 
  801a7a:	e9 92 00 00 00       	jmpq   801b11 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801a7f:	eb 41                	jmp    801ac2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a81:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801a86:	74 09                	je     801a91 <devpipe_read+0x52>
				return i;
  801a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8c:	e9 92 00 00 00       	jmpq   801b23 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a99:	48 89 d6             	mov    %rdx,%rsi
  801a9c:	48 89 c7             	mov    %rax,%rdi
  801a9f:	48 b8 08 19 80 00 00 	movabs $0x801908,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	callq  *%rax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	74 07                	je     801ab6 <devpipe_read+0x77>
				return 0;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	eb 6d                	jmp    801b23 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ab6:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801abd:	00 00 00 
  801ac0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac6:	8b 10                	mov    (%rax),%edx
  801ac8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801acc:	8b 40 04             	mov    0x4(%rax),%eax
  801acf:	39 c2                	cmp    %eax,%edx
  801ad1:	74 ae                	je     801a81 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801adb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae3:	8b 00                	mov    (%rax),%eax
  801ae5:	99                   	cltd   
  801ae6:	c1 ea 1b             	shr    $0x1b,%edx
  801ae9:	01 d0                	add    %edx,%eax
  801aeb:	83 e0 1f             	and    $0x1f,%eax
  801aee:	29 d0                	sub    %edx,%eax
  801af0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af4:	48 98                	cltq   
  801af6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801afb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b01:	8b 00                	mov    (%rax),%eax
  801b03:	8d 50 01             	lea    0x1(%rax),%edx
  801b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b0c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b15:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801b19:	0f 82 60 ff ff ff    	jb     801a7f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b23:	c9                   	leaveq 
  801b24:	c3                   	retq   

0000000000801b25 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b25:	55                   	push   %rbp
  801b26:	48 89 e5             	mov    %rsp,%rbp
  801b29:	48 83 ec 40          	sub    $0x40,%rsp
  801b2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801b35:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801b39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b3d:	48 89 c7             	mov    %rax,%rdi
  801b40:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
  801b4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801b50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801b58:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801b5f:	00 
  801b60:	e9 8e 00 00 00       	jmpq   801bf3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b65:	eb 31                	jmp    801b98 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801b67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6f:	48 89 d6             	mov    %rdx,%rsi
  801b72:	48 89 c7             	mov    %rax,%rdi
  801b75:	48 b8 08 19 80 00 00 	movabs $0x801908,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 07                	je     801b8c <devpipe_write+0x67>
				return 0;
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8a:	eb 79                	jmp    801c05 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801b8c:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b9c:	8b 40 04             	mov    0x4(%rax),%eax
  801b9f:	48 63 d0             	movslq %eax,%rdx
  801ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba6:	8b 00                	mov    (%rax),%eax
  801ba8:	48 98                	cltq   
  801baa:	48 83 c0 20          	add    $0x20,%rax
  801bae:	48 39 c2             	cmp    %rax,%rdx
  801bb1:	73 b4                	jae    801b67 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb7:	8b 40 04             	mov    0x4(%rax),%eax
  801bba:	99                   	cltd   
  801bbb:	c1 ea 1b             	shr    $0x1b,%edx
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	83 e0 1f             	and    $0x1f,%eax
  801bc3:	29 d0                	sub    %edx,%eax
  801bc5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bc9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bcd:	48 01 ca             	add    %rcx,%rdx
  801bd0:	0f b6 0a             	movzbl (%rdx),%ecx
  801bd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd7:	48 98                	cltq   
  801bd9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801bdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801be1:	8b 40 04             	mov    0x4(%rax),%eax
  801be4:	8d 50 01             	lea    0x1(%rax),%edx
  801be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801beb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801bee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801bfb:	0f 82 64 ff ff ff    	jb     801b65 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c05:	c9                   	leaveq 
  801c06:	c3                   	retq   

0000000000801c07 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c07:	55                   	push   %rbp
  801c08:	48 89 e5             	mov    %rsp,%rbp
  801c0b:	48 83 ec 20          	sub    $0x20,%rsp
  801c0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1b:	48 89 c7             	mov    %rax,%rdi
  801c1e:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801c25:	00 00 00 
  801c28:	ff d0                	callq  *%rax
  801c2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801c2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c32:	48 be 98 38 80 00 00 	movabs $0x803898,%rsi
  801c39:	00 00 00 
  801c3c:	48 89 c7             	mov    %rax,%rdi
  801c3f:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4f:	8b 50 04             	mov    0x4(%rax),%edx
  801c52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c56:	8b 00                	mov    (%rax),%eax
  801c58:	29 c2                	sub    %eax,%edx
  801c5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801c64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c68:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801c6f:	00 00 00 
	stat->st_dev = &devpipe;
  801c72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c76:	48 b9 e0 50 80 00 00 	movabs $0x8050e0,%rcx
  801c7d:	00 00 00 
  801c80:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8c:	c9                   	leaveq 
  801c8d:	c3                   	retq   

0000000000801c8e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	48 83 ec 10          	sub    $0x10,%rsp
  801c96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801c9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9e:	48 89 c6             	mov    %rax,%rsi
  801ca1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca6:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801cad:	00 00 00 
  801cb0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb6:	48 89 c7             	mov    %rax,%rdi
  801cb9:	48 b8 64 07 80 00 00 	movabs $0x800764,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	callq  *%rax
  801cc5:	48 89 c6             	mov    %rax,%rsi
  801cc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccd:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
}
  801cd9:	c9                   	leaveq 
  801cda:	c3                   	retq   

0000000000801cdb <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801cdb:	55                   	push   %rbp
  801cdc:	48 89 e5             	mov    %rsp,%rbp
  801cdf:	48 83 ec 20          	sub    $0x20,%rsp
  801ce3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801ce6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ce9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801cec:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801cf0:	be 01 00 00 00       	mov    $0x1,%esi
  801cf5:	48 89 c7             	mov    %rax,%rdi
  801cf8:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	callq  *%rax
}
  801d04:	c9                   	leaveq 
  801d05:	c3                   	retq   

0000000000801d06 <getchar>:

int
getchar(void)
{
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d0e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801d12:	ba 01 00 00 00       	mov    $0x1,%edx
  801d17:	48 89 c6             	mov    %rax,%rsi
  801d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1f:	48 b8 59 0c 80 00 00 	movabs $0x800c59,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax
  801d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d32:	79 05                	jns    801d39 <getchar+0x33>
		return r;
  801d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d37:	eb 14                	jmp    801d4d <getchar+0x47>
	if (r < 1)
  801d39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d3d:	7f 07                	jg     801d46 <getchar+0x40>
		return -E_EOF;
  801d3f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d44:	eb 07                	jmp    801d4d <getchar+0x47>
	return c;
  801d46:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801d4a:	0f b6 c0             	movzbl %al,%eax
}
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 83 ec 20          	sub    $0x20,%rsp
  801d57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d5a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d61:	48 89 d6             	mov    %rdx,%rsi
  801d64:	89 c7                	mov    %eax,%edi
  801d66:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  801d6d:	00 00 00 
  801d70:	ff d0                	callq  *%rax
  801d72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d79:	79 05                	jns    801d80 <iscons+0x31>
		return r;
  801d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7e:	eb 1a                	jmp    801d9a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d84:	8b 10                	mov    (%rax),%edx
  801d86:	48 b8 20 51 80 00 00 	movabs $0x805120,%rax
  801d8d:	00 00 00 
  801d90:	8b 00                	mov    (%rax),%eax
  801d92:	39 c2                	cmp    %eax,%edx
  801d94:	0f 94 c0             	sete   %al
  801d97:	0f b6 c0             	movzbl %al,%eax
}
  801d9a:	c9                   	leaveq 
  801d9b:	c3                   	retq   

0000000000801d9c <opencons>:

int
opencons(void)
{
  801d9c:	55                   	push   %rbp
  801d9d:	48 89 e5             	mov    %rsp,%rbp
  801da0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801da4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 8f 07 80 00 00 	movabs $0x80078f,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dbe:	79 05                	jns    801dc5 <opencons+0x29>
		return r;
  801dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc3:	eb 5b                	jmp    801e20 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc9:	ba 07 04 00 00       	mov    $0x407,%edx
  801dce:	48 89 c6             	mov    %rax,%rsi
  801dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd6:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  801ddd:	00 00 00 
  801de0:	ff d0                	callq  *%rax
  801de2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801de5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de9:	79 05                	jns    801df0 <opencons+0x54>
		return r;
  801deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dee:	eb 30                	jmp    801e20 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801df0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df4:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  801dfb:	00 00 00 
  801dfe:	8b 12                	mov    (%rdx),%edx
  801e00:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e11:	48 89 c7             	mov    %rax,%rdi
  801e14:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
}
  801e20:	c9                   	leaveq 
  801e21:	c3                   	retq   

0000000000801e22 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e22:	55                   	push   %rbp
  801e23:	48 89 e5             	mov    %rsp,%rbp
  801e26:	48 83 ec 30          	sub    $0x30,%rsp
  801e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e32:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801e36:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801e3b:	75 07                	jne    801e44 <devcons_read+0x22>
		return 0;
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	eb 4b                	jmp    801e8f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801e44:	eb 0c                	jmp    801e52 <devcons_read+0x30>
		sys_yield();
  801e46:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  801e4d:	00 00 00 
  801e50:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801e52:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  801e59:	00 00 00 
  801e5c:	ff d0                	callq  *%rax
  801e5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e65:	74 df                	je     801e46 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e6b:	79 05                	jns    801e72 <devcons_read+0x50>
		return c;
  801e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e70:	eb 1d                	jmp    801e8f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801e72:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801e76:	75 07                	jne    801e7f <devcons_read+0x5d>
		return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	eb 10                	jmp    801e8f <devcons_read+0x6d>
	*(char*)vbuf = c;
  801e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e82:	89 c2                	mov    %eax,%edx
  801e84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e88:	88 10                	mov    %dl,(%rax)
	return 1;
  801e8a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801e9c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801ea3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801eaa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eb8:	eb 76                	jmp    801f30 <devcons_write+0x9f>
		m = n - tot;
  801eba:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801ec1:	89 c2                	mov    %eax,%edx
  801ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec6:	29 c2                	sub    %eax,%edx
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801ecd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ed0:	83 f8 7f             	cmp    $0x7f,%eax
  801ed3:	76 07                	jbe    801edc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801ed5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801edc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801edf:	48 63 d0             	movslq %eax,%rdx
  801ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee5:	48 63 c8             	movslq %eax,%rcx
  801ee8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801eef:	48 01 c1             	add    %rax,%rcx
  801ef2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801ef9:	48 89 ce             	mov    %rcx,%rsi
  801efc:	48 89 c7             	mov    %rax,%rdi
  801eff:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801f0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f0e:	48 63 d0             	movslq %eax,%rdx
  801f11:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801f18:	48 89 d6             	mov    %rdx,%rsi
  801f1b:	48 89 c7             	mov    %rax,%rdi
  801f1e:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f2d:	01 45 fc             	add    %eax,-0x4(%rbp)
  801f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f33:	48 98                	cltq   
  801f35:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801f3c:	0f 82 78 ff ff ff    	jb     801eba <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f45:	c9                   	leaveq 
  801f46:	c3                   	retq   

0000000000801f47 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	48 83 ec 08          	sub    $0x8,%rsp
  801f4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f58:	c9                   	leaveq 
  801f59:	c3                   	retq   

0000000000801f5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f5a:	55                   	push   %rbp
  801f5b:	48 89 e5             	mov    %rsp,%rbp
  801f5e:	48 83 ec 10          	sub    $0x10,%rsp
  801f62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6e:	48 be a4 38 80 00 00 	movabs $0x8038a4,%rsi
  801f75:	00 00 00 
  801f78:	48 89 c7             	mov    %rax,%rdi
  801f7b:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
	return 0;
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8c:	c9                   	leaveq 
  801f8d:	c3                   	retq   

0000000000801f8e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f8e:	55                   	push   %rbp
  801f8f:	48 89 e5             	mov    %rsp,%rbp
  801f92:	53                   	push   %rbx
  801f93:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801f9a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801fa1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801fa7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801fae:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801fb5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801fbc:	84 c0                	test   %al,%al
  801fbe:	74 23                	je     801fe3 <_panic+0x55>
  801fc0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801fc7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801fcb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801fcf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801fd3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801fd7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801fdb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801fdf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801fe3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801fea:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801ff1:	00 00 00 
  801ff4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801ffb:	00 00 00 
  801ffe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802002:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802009:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802010:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802017:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80201e:	00 00 00 
  802021:	48 8b 18             	mov    (%rax),%rbx
  802024:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
  802030:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802036:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80203d:	41 89 c8             	mov    %ecx,%r8d
  802040:	48 89 d1             	mov    %rdx,%rcx
  802043:	48 89 da             	mov    %rbx,%rdx
  802046:	89 c6                	mov    %eax,%esi
  802048:	48 bf b0 38 80 00 00 	movabs $0x8038b0,%rdi
  80204f:	00 00 00 
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
  802057:	49 b9 c7 21 80 00 00 	movabs $0x8021c7,%r9
  80205e:	00 00 00 
  802061:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802064:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80206b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802072:	48 89 d6             	mov    %rdx,%rsi
  802075:	48 89 c7             	mov    %rax,%rdi
  802078:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax
	cprintf("\n");
  802084:	48 bf d3 38 80 00 00 	movabs $0x8038d3,%rdi
  80208b:	00 00 00 
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  80209a:	00 00 00 
  80209d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80209f:	cc                   	int3   
  8020a0:	eb fd                	jmp    80209f <_panic+0x111>

00000000008020a2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8020a2:	55                   	push   %rbp
  8020a3:	48 89 e5             	mov    %rsp,%rbp
  8020a6:	48 83 ec 10          	sub    $0x10,%rsp
  8020aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8020b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b5:	8b 00                	mov    (%rax),%eax
  8020b7:	8d 48 01             	lea    0x1(%rax),%ecx
  8020ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020be:	89 0a                	mov    %ecx,(%rdx)
  8020c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c3:	89 d1                	mov    %edx,%ecx
  8020c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c9:	48 98                	cltq   
  8020cb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8020cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d3:	8b 00                	mov    (%rax),%eax
  8020d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8020da:	75 2c                	jne    802108 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8020dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e0:	8b 00                	mov    (%rax),%eax
  8020e2:	48 98                	cltq   
  8020e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e8:	48 83 c2 08          	add    $0x8,%rdx
  8020ec:	48 89 c6             	mov    %rax,%rsi
  8020ef:	48 89 d7             	mov    %rdx,%rdi
  8020f2:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
        b->idx = 0;
  8020fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802102:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210c:	8b 40 04             	mov    0x4(%rax),%eax
  80210f:	8d 50 01             	lea    0x1(%rax),%edx
  802112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802116:	89 50 04             	mov    %edx,0x4(%rax)
}
  802119:	c9                   	leaveq 
  80211a:	c3                   	retq   

000000000080211b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80211b:	55                   	push   %rbp
  80211c:	48 89 e5             	mov    %rsp,%rbp
  80211f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802126:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80212d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802134:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80213b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802142:	48 8b 0a             	mov    (%rdx),%rcx
  802145:	48 89 08             	mov    %rcx,(%rax)
  802148:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80214c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802150:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802154:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802158:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80215f:	00 00 00 
    b.cnt = 0;
  802162:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802169:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80216c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802173:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80217a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802181:	48 89 c6             	mov    %rax,%rsi
  802184:	48 bf a2 20 80 00 00 	movabs $0x8020a2,%rdi
  80218b:	00 00 00 
  80218e:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80219a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8021a0:	48 98                	cltq   
  8021a2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8021a9:	48 83 c2 08          	add    $0x8,%rdx
  8021ad:	48 89 c6             	mov    %rax,%rsi
  8021b0:	48 89 d7             	mov    %rdx,%rdi
  8021b3:	48 b8 ab 01 80 00 00 	movabs $0x8001ab,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8021bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8021c5:	c9                   	leaveq 
  8021c6:	c3                   	retq   

00000000008021c7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8021c7:	55                   	push   %rbp
  8021c8:	48 89 e5             	mov    %rsp,%rbp
  8021cb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8021d2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8021d9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8021e0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8021e7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8021ee:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8021f5:	84 c0                	test   %al,%al
  8021f7:	74 20                	je     802219 <cprintf+0x52>
  8021f9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8021fd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802201:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802205:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802209:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80220d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802211:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802215:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802219:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802220:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802227:	00 00 00 
  80222a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802231:	00 00 00 
  802234:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802238:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80223f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802246:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80224d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80225b:	48 8b 0a             	mov    (%rdx),%rcx
  80225e:	48 89 08             	mov    %rcx,(%rax)
  802261:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802265:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802269:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80226d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802271:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802278:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80227f:	48 89 d6             	mov    %rdx,%rsi
  802282:	48 89 c7             	mov    %rax,%rdi
  802285:	48 b8 1b 21 80 00 00 	movabs $0x80211b,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802297:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	53                   	push   %rbx
  8022a4:	48 83 ec 38          	sub    $0x38,%rsp
  8022a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8022b4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8022b7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8022bb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8022bf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022c2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022c6:	77 3b                	ja     802303 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8022c8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8022cb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8022cf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8022d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8022db:	48 f7 f3             	div    %rbx
  8022de:	48 89 c2             	mov    %rax,%rdx
  8022e1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8022e4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8022e7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	41 89 f9             	mov    %edi,%r9d
  8022f2:	48 89 c7             	mov    %rax,%rdi
  8022f5:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	eb 1e                	jmp    802321 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802303:	eb 12                	jmp    802317 <printnum+0x78>
			putch(padc, putdat);
  802305:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802309:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80230c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802310:	48 89 ce             	mov    %rcx,%rsi
  802313:	89 d7                	mov    %edx,%edi
  802315:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802317:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80231b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80231f:	7f e4                	jg     802305 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802321:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802324:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802328:	ba 00 00 00 00       	mov    $0x0,%edx
  80232d:	48 f7 f1             	div    %rcx
  802330:	48 89 d0             	mov    %rdx,%rax
  802333:	48 ba d0 3a 80 00 00 	movabs $0x803ad0,%rdx
  80233a:	00 00 00 
  80233d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802341:	0f be d0             	movsbl %al,%edx
  802344:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234c:	48 89 ce             	mov    %rcx,%rsi
  80234f:	89 d7                	mov    %edx,%edi
  802351:	ff d0                	callq  *%rax
}
  802353:	48 83 c4 38          	add    $0x38,%rsp
  802357:	5b                   	pop    %rbx
  802358:	5d                   	pop    %rbp
  802359:	c3                   	retq   

000000000080235a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80235a:	55                   	push   %rbp
  80235b:	48 89 e5             	mov    %rsp,%rbp
  80235e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802362:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802366:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802369:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80236d:	7e 52                	jle    8023c1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80236f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802373:	8b 00                	mov    (%rax),%eax
  802375:	83 f8 30             	cmp    $0x30,%eax
  802378:	73 24                	jae    80239e <getuint+0x44>
  80237a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802386:	8b 00                	mov    (%rax),%eax
  802388:	89 c0                	mov    %eax,%eax
  80238a:	48 01 d0             	add    %rdx,%rax
  80238d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802391:	8b 12                	mov    (%rdx),%edx
  802393:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802396:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239a:	89 0a                	mov    %ecx,(%rdx)
  80239c:	eb 17                	jmp    8023b5 <getuint+0x5b>
  80239e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023a6:	48 89 d0             	mov    %rdx,%rax
  8023a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023b5:	48 8b 00             	mov    (%rax),%rax
  8023b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023bc:	e9 a3 00 00 00       	jmpq   802464 <getuint+0x10a>
	else if (lflag)
  8023c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023c5:	74 4f                	je     802416 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	8b 00                	mov    (%rax),%eax
  8023cd:	83 f8 30             	cmp    $0x30,%eax
  8023d0:	73 24                	jae    8023f6 <getuint+0x9c>
  8023d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023de:	8b 00                	mov    (%rax),%eax
  8023e0:	89 c0                	mov    %eax,%eax
  8023e2:	48 01 d0             	add    %rdx,%rax
  8023e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e9:	8b 12                	mov    (%rdx),%edx
  8023eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f2:	89 0a                	mov    %ecx,(%rdx)
  8023f4:	eb 17                	jmp    80240d <getuint+0xb3>
  8023f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023fe:	48 89 d0             	mov    %rdx,%rax
  802401:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802405:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802409:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80240d:	48 8b 00             	mov    (%rax),%rax
  802410:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802414:	eb 4e                	jmp    802464 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241a:	8b 00                	mov    (%rax),%eax
  80241c:	83 f8 30             	cmp    $0x30,%eax
  80241f:	73 24                	jae    802445 <getuint+0xeb>
  802421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802425:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242d:	8b 00                	mov    (%rax),%eax
  80242f:	89 c0                	mov    %eax,%eax
  802431:	48 01 d0             	add    %rdx,%rax
  802434:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802438:	8b 12                	mov    (%rdx),%edx
  80243a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80243d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802441:	89 0a                	mov    %ecx,(%rdx)
  802443:	eb 17                	jmp    80245c <getuint+0x102>
  802445:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802449:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80244d:	48 89 d0             	mov    %rdx,%rax
  802450:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802454:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802458:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80245c:	8b 00                	mov    (%rax),%eax
  80245e:	89 c0                	mov    %eax,%eax
  802460:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802468:	c9                   	leaveq 
  802469:	c3                   	retq   

000000000080246a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80246a:	55                   	push   %rbp
  80246b:	48 89 e5             	mov    %rsp,%rbp
  80246e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802472:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802476:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802479:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80247d:	7e 52                	jle    8024d1 <getint+0x67>
		x=va_arg(*ap, long long);
  80247f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802483:	8b 00                	mov    (%rax),%eax
  802485:	83 f8 30             	cmp    $0x30,%eax
  802488:	73 24                	jae    8024ae <getint+0x44>
  80248a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802496:	8b 00                	mov    (%rax),%eax
  802498:	89 c0                	mov    %eax,%eax
  80249a:	48 01 d0             	add    %rdx,%rax
  80249d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024a1:	8b 12                	mov    (%rdx),%edx
  8024a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8024a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024aa:	89 0a                	mov    %ecx,(%rdx)
  8024ac:	eb 17                	jmp    8024c5 <getint+0x5b>
  8024ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8024b6:	48 89 d0             	mov    %rdx,%rax
  8024b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8024bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8024c5:	48 8b 00             	mov    (%rax),%rax
  8024c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8024cc:	e9 a3 00 00 00       	jmpq   802574 <getint+0x10a>
	else if (lflag)
  8024d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8024d5:	74 4f                	je     802526 <getint+0xbc>
		x=va_arg(*ap, long);
  8024d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024db:	8b 00                	mov    (%rax),%eax
  8024dd:	83 f8 30             	cmp    $0x30,%eax
  8024e0:	73 24                	jae    802506 <getint+0x9c>
  8024e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8024ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ee:	8b 00                	mov    (%rax),%eax
  8024f0:	89 c0                	mov    %eax,%eax
  8024f2:	48 01 d0             	add    %rdx,%rax
  8024f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024f9:	8b 12                	mov    (%rdx),%edx
  8024fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8024fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802502:	89 0a                	mov    %ecx,(%rdx)
  802504:	eb 17                	jmp    80251d <getint+0xb3>
  802506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80250e:	48 89 d0             	mov    %rdx,%rax
  802511:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802515:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802519:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80251d:	48 8b 00             	mov    (%rax),%rax
  802520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802524:	eb 4e                	jmp    802574 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252a:	8b 00                	mov    (%rax),%eax
  80252c:	83 f8 30             	cmp    $0x30,%eax
  80252f:	73 24                	jae    802555 <getint+0xeb>
  802531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802535:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253d:	8b 00                	mov    (%rax),%eax
  80253f:	89 c0                	mov    %eax,%eax
  802541:	48 01 d0             	add    %rdx,%rax
  802544:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802548:	8b 12                	mov    (%rdx),%edx
  80254a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80254d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802551:	89 0a                	mov    %ecx,(%rdx)
  802553:	eb 17                	jmp    80256c <getint+0x102>
  802555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802559:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80255d:	48 89 d0             	mov    %rdx,%rax
  802560:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802568:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80256c:	8b 00                	mov    (%rax),%eax
  80256e:	48 98                	cltq   
  802570:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802578:	c9                   	leaveq 
  802579:	c3                   	retq   

000000000080257a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80257a:	55                   	push   %rbp
  80257b:	48 89 e5             	mov    %rsp,%rbp
  80257e:	41 54                	push   %r12
  802580:	53                   	push   %rbx
  802581:	48 83 ec 60          	sub    $0x60,%rsp
  802585:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802589:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80258d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802591:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802595:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802599:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80259d:	48 8b 0a             	mov    (%rdx),%rcx
  8025a0:	48 89 08             	mov    %rcx,(%rax)
  8025a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8025a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8025ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8025af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8025b3:	eb 17                	jmp    8025cc <vprintfmt+0x52>
			if (ch == '\0')
  8025b5:	85 db                	test   %ebx,%ebx
  8025b7:	0f 84 cc 04 00 00    	je     802a89 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8025bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8025c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025c5:	48 89 d6             	mov    %rdx,%rsi
  8025c8:	89 df                	mov    %ebx,%edi
  8025ca:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8025cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8025d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8025d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8025d8:	0f b6 00             	movzbl (%rax),%eax
  8025db:	0f b6 d8             	movzbl %al,%ebx
  8025de:	83 fb 25             	cmp    $0x25,%ebx
  8025e1:	75 d2                	jne    8025b5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8025e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8025e7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8025ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8025f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8025fc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802603:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802607:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80260b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80260f:	0f b6 00             	movzbl (%rax),%eax
  802612:	0f b6 d8             	movzbl %al,%ebx
  802615:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802618:	83 f8 55             	cmp    $0x55,%eax
  80261b:	0f 87 34 04 00 00    	ja     802a55 <vprintfmt+0x4db>
  802621:	89 c0                	mov    %eax,%eax
  802623:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80262a:	00 
  80262b:	48 b8 f8 3a 80 00 00 	movabs $0x803af8,%rax
  802632:	00 00 00 
  802635:	48 01 d0             	add    %rdx,%rax
  802638:	48 8b 00             	mov    (%rax),%rax
  80263b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80263d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802641:	eb c0                	jmp    802603 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802643:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802647:	eb ba                	jmp    802603 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802649:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802650:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802653:	89 d0                	mov    %edx,%eax
  802655:	c1 e0 02             	shl    $0x2,%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	01 c0                	add    %eax,%eax
  80265c:	01 d8                	add    %ebx,%eax
  80265e:	83 e8 30             	sub    $0x30,%eax
  802661:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802664:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802668:	0f b6 00             	movzbl (%rax),%eax
  80266b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80266e:	83 fb 2f             	cmp    $0x2f,%ebx
  802671:	7e 0c                	jle    80267f <vprintfmt+0x105>
  802673:	83 fb 39             	cmp    $0x39,%ebx
  802676:	7f 07                	jg     80267f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802678:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80267d:	eb d1                	jmp    802650 <vprintfmt+0xd6>
			goto process_precision;
  80267f:	eb 58                	jmp    8026d9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802681:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802684:	83 f8 30             	cmp    $0x30,%eax
  802687:	73 17                	jae    8026a0 <vprintfmt+0x126>
  802689:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80268d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802690:	89 c0                	mov    %eax,%eax
  802692:	48 01 d0             	add    %rdx,%rax
  802695:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802698:	83 c2 08             	add    $0x8,%edx
  80269b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80269e:	eb 0f                	jmp    8026af <vprintfmt+0x135>
  8026a0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026a4:	48 89 d0             	mov    %rdx,%rax
  8026a7:	48 83 c2 08          	add    $0x8,%rdx
  8026ab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026af:	8b 00                	mov    (%rax),%eax
  8026b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8026b4:	eb 23                	jmp    8026d9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8026b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026ba:	79 0c                	jns    8026c8 <vprintfmt+0x14e>
				width = 0;
  8026bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8026c3:	e9 3b ff ff ff       	jmpq   802603 <vprintfmt+0x89>
  8026c8:	e9 36 ff ff ff       	jmpq   802603 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8026cd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8026d4:	e9 2a ff ff ff       	jmpq   802603 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8026d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026dd:	79 12                	jns    8026f1 <vprintfmt+0x177>
				width = precision, precision = -1;
  8026df:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026e2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8026e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8026ec:	e9 12 ff ff ff       	jmpq   802603 <vprintfmt+0x89>
  8026f1:	e9 0d ff ff ff       	jmpq   802603 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8026f6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8026fa:	e9 04 ff ff ff       	jmpq   802603 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8026ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802702:	83 f8 30             	cmp    $0x30,%eax
  802705:	73 17                	jae    80271e <vprintfmt+0x1a4>
  802707:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80270b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80270e:	89 c0                	mov    %eax,%eax
  802710:	48 01 d0             	add    %rdx,%rax
  802713:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802716:	83 c2 08             	add    $0x8,%edx
  802719:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80271c:	eb 0f                	jmp    80272d <vprintfmt+0x1b3>
  80271e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802722:	48 89 d0             	mov    %rdx,%rax
  802725:	48 83 c2 08          	add    $0x8,%rdx
  802729:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80272d:	8b 10                	mov    (%rax),%edx
  80272f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802733:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802737:	48 89 ce             	mov    %rcx,%rsi
  80273a:	89 d7                	mov    %edx,%edi
  80273c:	ff d0                	callq  *%rax
			break;
  80273e:	e9 40 03 00 00       	jmpq   802a83 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802743:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802746:	83 f8 30             	cmp    $0x30,%eax
  802749:	73 17                	jae    802762 <vprintfmt+0x1e8>
  80274b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80274f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802752:	89 c0                	mov    %eax,%eax
  802754:	48 01 d0             	add    %rdx,%rax
  802757:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80275a:	83 c2 08             	add    $0x8,%edx
  80275d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802760:	eb 0f                	jmp    802771 <vprintfmt+0x1f7>
  802762:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802766:	48 89 d0             	mov    %rdx,%rax
  802769:	48 83 c2 08          	add    $0x8,%rdx
  80276d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802771:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802773:	85 db                	test   %ebx,%ebx
  802775:	79 02                	jns    802779 <vprintfmt+0x1ff>
				err = -err;
  802777:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802779:	83 fb 15             	cmp    $0x15,%ebx
  80277c:	7f 16                	jg     802794 <vprintfmt+0x21a>
  80277e:	48 b8 20 3a 80 00 00 	movabs $0x803a20,%rax
  802785:	00 00 00 
  802788:	48 63 d3             	movslq %ebx,%rdx
  80278b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80278f:	4d 85 e4             	test   %r12,%r12
  802792:	75 2e                	jne    8027c2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802794:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802798:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80279c:	89 d9                	mov    %ebx,%ecx
  80279e:	48 ba e1 3a 80 00 00 	movabs $0x803ae1,%rdx
  8027a5:	00 00 00 
  8027a8:	48 89 c7             	mov    %rax,%rdi
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	49 b8 92 2a 80 00 00 	movabs $0x802a92,%r8
  8027b7:	00 00 00 
  8027ba:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8027bd:	e9 c1 02 00 00       	jmpq   802a83 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8027c2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8027c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027ca:	4c 89 e1             	mov    %r12,%rcx
  8027cd:	48 ba ea 3a 80 00 00 	movabs $0x803aea,%rdx
  8027d4:	00 00 00 
  8027d7:	48 89 c7             	mov    %rax,%rdi
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	49 b8 92 2a 80 00 00 	movabs $0x802a92,%r8
  8027e6:	00 00 00 
  8027e9:	41 ff d0             	callq  *%r8
			break;
  8027ec:	e9 92 02 00 00       	jmpq   802a83 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8027f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027f4:	83 f8 30             	cmp    $0x30,%eax
  8027f7:	73 17                	jae    802810 <vprintfmt+0x296>
  8027f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802800:	89 c0                	mov    %eax,%eax
  802802:	48 01 d0             	add    %rdx,%rax
  802805:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802808:	83 c2 08             	add    $0x8,%edx
  80280b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80280e:	eb 0f                	jmp    80281f <vprintfmt+0x2a5>
  802810:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802814:	48 89 d0             	mov    %rdx,%rax
  802817:	48 83 c2 08          	add    $0x8,%rdx
  80281b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80281f:	4c 8b 20             	mov    (%rax),%r12
  802822:	4d 85 e4             	test   %r12,%r12
  802825:	75 0a                	jne    802831 <vprintfmt+0x2b7>
				p = "(null)";
  802827:	49 bc ed 3a 80 00 00 	movabs $0x803aed,%r12
  80282e:	00 00 00 
			if (width > 0 && padc != '-')
  802831:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802835:	7e 3f                	jle    802876 <vprintfmt+0x2fc>
  802837:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80283b:	74 39                	je     802876 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80283d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802840:	48 98                	cltq   
  802842:	48 89 c6             	mov    %rax,%rsi
  802845:	4c 89 e7             	mov    %r12,%rdi
  802848:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802857:	eb 17                	jmp    802870 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802859:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80285d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802861:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802865:	48 89 ce             	mov    %rcx,%rsi
  802868:	89 d7                	mov    %edx,%edi
  80286a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80286c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802870:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802874:	7f e3                	jg     802859 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802876:	eb 37                	jmp    8028af <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802878:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80287c:	74 1e                	je     80289c <vprintfmt+0x322>
  80287e:	83 fb 1f             	cmp    $0x1f,%ebx
  802881:	7e 05                	jle    802888 <vprintfmt+0x30e>
  802883:	83 fb 7e             	cmp    $0x7e,%ebx
  802886:	7e 14                	jle    80289c <vprintfmt+0x322>
					putch('?', putdat);
  802888:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80288c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802890:	48 89 d6             	mov    %rdx,%rsi
  802893:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802898:	ff d0                	callq  *%rax
  80289a:	eb 0f                	jmp    8028ab <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80289c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028a4:	48 89 d6             	mov    %rdx,%rsi
  8028a7:	89 df                	mov    %ebx,%edi
  8028a9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8028ab:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8028af:	4c 89 e0             	mov    %r12,%rax
  8028b2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8028b6:	0f b6 00             	movzbl (%rax),%eax
  8028b9:	0f be d8             	movsbl %al,%ebx
  8028bc:	85 db                	test   %ebx,%ebx
  8028be:	74 10                	je     8028d0 <vprintfmt+0x356>
  8028c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8028c4:	78 b2                	js     802878 <vprintfmt+0x2fe>
  8028c6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8028ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8028ce:	79 a8                	jns    802878 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8028d0:	eb 16                	jmp    8028e8 <vprintfmt+0x36e>
				putch(' ', putdat);
  8028d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028da:	48 89 d6             	mov    %rdx,%rsi
  8028dd:	bf 20 00 00 00       	mov    $0x20,%edi
  8028e2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8028e4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8028e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8028ec:	7f e4                	jg     8028d2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8028ee:	e9 90 01 00 00       	jmpq   802a83 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8028f3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028f7:	be 03 00 00 00       	mov    $0x3,%esi
  8028fc:	48 89 c7             	mov    %rax,%rdi
  8028ff:	48 b8 6a 24 80 00 00 	movabs $0x80246a,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80290f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802913:	48 85 c0             	test   %rax,%rax
  802916:	79 1d                	jns    802935 <vprintfmt+0x3bb>
				putch('-', putdat);
  802918:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80291c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802920:	48 89 d6             	mov    %rdx,%rsi
  802923:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802928:	ff d0                	callq  *%rax
				num = -(long long) num;
  80292a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292e:	48 f7 d8             	neg    %rax
  802931:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802935:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80293c:	e9 d5 00 00 00       	jmpq   802a16 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802941:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802945:	be 03 00 00 00       	mov    $0x3,%esi
  80294a:	48 89 c7             	mov    %rax,%rdi
  80294d:	48 b8 5a 23 80 00 00 	movabs $0x80235a,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
  802959:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80295d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802964:	e9 ad 00 00 00       	jmpq   802a16 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  802969:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80296c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802970:	89 d6                	mov    %edx,%esi
  802972:	48 89 c7             	mov    %rax,%rdi
  802975:	48 b8 6a 24 80 00 00 	movabs $0x80246a,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
  802981:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  802985:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80298c:	e9 85 00 00 00       	jmpq   802a16 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  802991:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802995:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802999:	48 89 d6             	mov    %rdx,%rsi
  80299c:	bf 30 00 00 00       	mov    $0x30,%edi
  8029a1:	ff d0                	callq  *%rax
			putch('x', putdat);
  8029a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8029a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8029ab:	48 89 d6             	mov    %rdx,%rsi
  8029ae:	bf 78 00 00 00       	mov    $0x78,%edi
  8029b3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8029b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8029b8:	83 f8 30             	cmp    $0x30,%eax
  8029bb:	73 17                	jae    8029d4 <vprintfmt+0x45a>
  8029bd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8029c4:	89 c0                	mov    %eax,%eax
  8029c6:	48 01 d0             	add    %rdx,%rax
  8029c9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8029cc:	83 c2 08             	add    $0x8,%edx
  8029cf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8029d2:	eb 0f                	jmp    8029e3 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8029d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8029d8:	48 89 d0             	mov    %rdx,%rax
  8029db:	48 83 c2 08          	add    $0x8,%rdx
  8029df:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8029e3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8029e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8029ea:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8029f1:	eb 23                	jmp    802a16 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8029f3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8029f7:	be 03 00 00 00       	mov    $0x3,%esi
  8029fc:	48 89 c7             	mov    %rax,%rdi
  8029ff:	48 b8 5a 23 80 00 00 	movabs $0x80235a,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802a0f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802a16:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802a1b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802a1e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802a21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a25:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802a29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802a2d:	45 89 c1             	mov    %r8d,%r9d
  802a30:	41 89 f8             	mov    %edi,%r8d
  802a33:	48 89 c7             	mov    %rax,%rdi
  802a36:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  802a3d:	00 00 00 
  802a40:	ff d0                	callq  *%rax
			break;
  802a42:	eb 3f                	jmp    802a83 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802a44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802a48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802a4c:	48 89 d6             	mov    %rdx,%rsi
  802a4f:	89 df                	mov    %ebx,%edi
  802a51:	ff d0                	callq  *%rax
			break;
  802a53:	eb 2e                	jmp    802a83 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802a55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802a59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802a5d:	48 89 d6             	mov    %rdx,%rsi
  802a60:	bf 25 00 00 00       	mov    $0x25,%edi
  802a65:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802a67:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802a6c:	eb 05                	jmp    802a73 <vprintfmt+0x4f9>
  802a6e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802a73:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a77:	48 83 e8 01          	sub    $0x1,%rax
  802a7b:	0f b6 00             	movzbl (%rax),%eax
  802a7e:	3c 25                	cmp    $0x25,%al
  802a80:	75 ec                	jne    802a6e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  802a82:	90                   	nop
		}
	}
  802a83:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802a84:	e9 43 fb ff ff       	jmpq   8025cc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802a89:	48 83 c4 60          	add    $0x60,%rsp
  802a8d:	5b                   	pop    %rbx
  802a8e:	41 5c                	pop    %r12
  802a90:	5d                   	pop    %rbp
  802a91:	c3                   	retq   

0000000000802a92 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802a9d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802aa4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802aab:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ab2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802ab9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ac0:	84 c0                	test   %al,%al
  802ac2:	74 20                	je     802ae4 <printfmt+0x52>
  802ac4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ac8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802acc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ad0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802ad4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ad8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802adc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ae0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ae4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802aeb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802af2:	00 00 00 
  802af5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802afc:	00 00 00 
  802aff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b03:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802b0a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b11:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802b18:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802b1f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802b26:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802b2d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802b34:	48 89 c7             	mov    %rax,%rdi
  802b37:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
	va_end(ap);
}
  802b43:	c9                   	leaveq 
  802b44:	c3                   	retq   

0000000000802b45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802b45:	55                   	push   %rbp
  802b46:	48 89 e5             	mov    %rsp,%rbp
  802b49:	48 83 ec 10          	sub    $0x10,%rsp
  802b4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802b54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b58:	8b 40 10             	mov    0x10(%rax),%eax
  802b5b:	8d 50 01             	lea    0x1(%rax),%edx
  802b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b62:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802b65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b69:	48 8b 10             	mov    (%rax),%rdx
  802b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b70:	48 8b 40 08          	mov    0x8(%rax),%rax
  802b74:	48 39 c2             	cmp    %rax,%rdx
  802b77:	73 17                	jae    802b90 <sprintputch+0x4b>
		*b->buf++ = ch;
  802b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7d:	48 8b 00             	mov    (%rax),%rax
  802b80:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802b84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b88:	48 89 0a             	mov    %rcx,(%rdx)
  802b8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b8e:	88 10                	mov    %dl,(%rax)
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 50          	sub    $0x50,%rsp
  802b9a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b9e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802ba1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802ba5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802ba9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802bad:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802bb1:	48 8b 0a             	mov    (%rdx),%rcx
  802bb4:	48 89 08             	mov    %rcx,(%rax)
  802bb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802bbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802bbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802bc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802bc7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bcb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802bcf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802bd2:	48 98                	cltq   
  802bd4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802bd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bdc:	48 01 d0             	add    %rdx,%rax
  802bdf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802be3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802bea:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802bef:	74 06                	je     802bf7 <vsnprintf+0x65>
  802bf1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802bf5:	7f 07                	jg     802bfe <vsnprintf+0x6c>
		return -E_INVAL;
  802bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bfc:	eb 2f                	jmp    802c2d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802bfe:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802c02:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802c06:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c0a:	48 89 c6             	mov    %rax,%rsi
  802c0d:	48 bf 45 2b 80 00 00 	movabs $0x802b45,%rdi
  802c14:	00 00 00 
  802c17:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802c23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c27:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802c2a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802c2d:	c9                   	leaveq 
  802c2e:	c3                   	retq   

0000000000802c2f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802c2f:	55                   	push   %rbp
  802c30:	48 89 e5             	mov    %rsp,%rbp
  802c33:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802c3a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802c41:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802c47:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802c4e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802c55:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802c5c:	84 c0                	test   %al,%al
  802c5e:	74 20                	je     802c80 <snprintf+0x51>
  802c60:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802c64:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802c68:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802c6c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802c70:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802c74:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802c78:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802c7c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802c80:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802c87:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802c8e:	00 00 00 
  802c91:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802c98:	00 00 00 
  802c9b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c9f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ca6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802cad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802cb4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802cbb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802cc2:	48 8b 0a             	mov    (%rdx),%rcx
  802cc5:	48 89 08             	mov    %rcx,(%rax)
  802cc8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ccc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cd0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802cd4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802cd8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802cdf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802ce6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802cec:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802cf3:	48 89 c7             	mov    %rax,%rdi
  802cf6:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	callq  *%rax
  802d02:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802d08:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d0e:	c9                   	leaveq 
  802d0f:	c3                   	retq   

0000000000802d10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802d10:	55                   	push   %rbp
  802d11:	48 89 e5             	mov    %rsp,%rbp
  802d14:	48 83 ec 18          	sub    $0x18,%rsp
  802d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802d1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d23:	eb 09                	jmp    802d2e <strlen+0x1e>
		n++;
  802d25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802d29:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	0f b6 00             	movzbl (%rax),%eax
  802d35:	84 c0                	test   %al,%al
  802d37:	75 ec                	jne    802d25 <strlen+0x15>
		n++;
	return n;
  802d39:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d3c:	c9                   	leaveq 
  802d3d:	c3                   	retq   

0000000000802d3e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802d3e:	55                   	push   %rbp
  802d3f:	48 89 e5             	mov    %rsp,%rbp
  802d42:	48 83 ec 20          	sub    $0x20,%rsp
  802d46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d55:	eb 0e                	jmp    802d65 <strnlen+0x27>
		n++;
  802d57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802d5b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802d60:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802d65:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d6a:	74 0b                	je     802d77 <strnlen+0x39>
  802d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d70:	0f b6 00             	movzbl (%rax),%eax
  802d73:	84 c0                	test   %al,%al
  802d75:	75 e0                	jne    802d57 <strnlen+0x19>
		n++;
	return n;
  802d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d7a:	c9                   	leaveq 
  802d7b:	c3                   	retq   

0000000000802d7c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802d7c:	55                   	push   %rbp
  802d7d:	48 89 e5             	mov    %rsp,%rbp
  802d80:	48 83 ec 20          	sub    $0x20,%rsp
  802d84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d88:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802d94:	90                   	nop
  802d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802da1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802da9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802dad:	0f b6 12             	movzbl (%rdx),%edx
  802db0:	88 10                	mov    %dl,(%rax)
  802db2:	0f b6 00             	movzbl (%rax),%eax
  802db5:	84 c0                	test   %al,%al
  802db7:	75 dc                	jne    802d95 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802db9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802dbd:	c9                   	leaveq 
  802dbe:	c3                   	retq   

0000000000802dbf <strcat>:

char *
strcat(char *dst, const char *src)
{
  802dbf:	55                   	push   %rbp
  802dc0:	48 89 e5             	mov    %rsp,%rbp
  802dc3:	48 83 ec 20          	sub    $0x20,%rsp
  802dc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dcb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de8:	48 63 d0             	movslq %eax,%rdx
  802deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802def:	48 01 c2             	add    %rax,%rdx
  802df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df6:	48 89 c6             	mov    %rax,%rsi
  802df9:	48 89 d7             	mov    %rdx,%rdi
  802dfc:	48 b8 7c 2d 80 00 00 	movabs $0x802d7c,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
	return dst;
  802e08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802e0c:	c9                   	leaveq 
  802e0d:	c3                   	retq   

0000000000802e0e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802e0e:	55                   	push   %rbp
  802e0f:	48 89 e5             	mov    %rsp,%rbp
  802e12:	48 83 ec 28          	sub    $0x28,%rsp
  802e16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802e2a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e31:	00 
  802e32:	eb 2a                	jmp    802e5e <strncpy+0x50>
		*dst++ = *src;
  802e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802e3c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802e40:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e44:	0f b6 12             	movzbl (%rdx),%edx
  802e47:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802e49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e4d:	0f b6 00             	movzbl (%rax),%eax
  802e50:	84 c0                	test   %al,%al
  802e52:	74 05                	je     802e59 <strncpy+0x4b>
			src++;
  802e54:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802e59:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e62:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e66:	72 cc                	jb     802e34 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802e6c:	c9                   	leaveq 
  802e6d:	c3                   	retq   

0000000000802e6e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 28          	sub    $0x28,%rsp
  802e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802e8a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e8f:	74 3d                	je     802ece <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802e91:	eb 1d                	jmp    802eb0 <strlcpy+0x42>
			*dst++ = *src++;
  802e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e97:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802e9b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802e9f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ea3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802ea7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802eab:	0f b6 12             	movzbl (%rdx),%edx
  802eae:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802eb0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802eb5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802eba:	74 0b                	je     802ec7 <strlcpy+0x59>
  802ebc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec0:	0f b6 00             	movzbl (%rax),%eax
  802ec3:	84 c0                	test   %al,%al
  802ec5:	75 cc                	jne    802e93 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802ece:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ed2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed6:	48 29 c2             	sub    %rax,%rdx
  802ed9:	48 89 d0             	mov    %rdx,%rax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 10          	sub    $0x10,%rsp
  802ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802eee:	eb 0a                	jmp    802efa <strcmp+0x1c>
		p++, q++;
  802ef0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ef5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efe:	0f b6 00             	movzbl (%rax),%eax
  802f01:	84 c0                	test   %al,%al
  802f03:	74 12                	je     802f17 <strcmp+0x39>
  802f05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f09:	0f b6 10             	movzbl (%rax),%edx
  802f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f10:	0f b6 00             	movzbl (%rax),%eax
  802f13:	38 c2                	cmp    %al,%dl
  802f15:	74 d9                	je     802ef0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802f17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1b:	0f b6 00             	movzbl (%rax),%eax
  802f1e:	0f b6 d0             	movzbl %al,%edx
  802f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f25:	0f b6 00             	movzbl (%rax),%eax
  802f28:	0f b6 c0             	movzbl %al,%eax
  802f2b:	29 c2                	sub    %eax,%edx
  802f2d:	89 d0                	mov    %edx,%eax
}
  802f2f:	c9                   	leaveq 
  802f30:	c3                   	retq   

0000000000802f31 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802f31:	55                   	push   %rbp
  802f32:	48 89 e5             	mov    %rsp,%rbp
  802f35:	48 83 ec 18          	sub    $0x18,%rsp
  802f39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f41:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802f45:	eb 0f                	jmp    802f56 <strncmp+0x25>
		n--, p++, q++;
  802f47:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802f4c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f51:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802f56:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f5b:	74 1d                	je     802f7a <strncmp+0x49>
  802f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f61:	0f b6 00             	movzbl (%rax),%eax
  802f64:	84 c0                	test   %al,%al
  802f66:	74 12                	je     802f7a <strncmp+0x49>
  802f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6c:	0f b6 10             	movzbl (%rax),%edx
  802f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f73:	0f b6 00             	movzbl (%rax),%eax
  802f76:	38 c2                	cmp    %al,%dl
  802f78:	74 cd                	je     802f47 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802f7a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f7f:	75 07                	jne    802f88 <strncmp+0x57>
		return 0;
  802f81:	b8 00 00 00 00       	mov    $0x0,%eax
  802f86:	eb 18                	jmp    802fa0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8c:	0f b6 00             	movzbl (%rax),%eax
  802f8f:	0f b6 d0             	movzbl %al,%edx
  802f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f96:	0f b6 00             	movzbl (%rax),%eax
  802f99:	0f b6 c0             	movzbl %al,%eax
  802f9c:	29 c2                	sub    %eax,%edx
  802f9e:	89 d0                	mov    %edx,%eax
}
  802fa0:	c9                   	leaveq 
  802fa1:	c3                   	retq   

0000000000802fa2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802fa2:	55                   	push   %rbp
  802fa3:	48 89 e5             	mov    %rsp,%rbp
  802fa6:	48 83 ec 0c          	sub    $0xc,%rsp
  802faa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fae:	89 f0                	mov    %esi,%eax
  802fb0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802fb3:	eb 17                	jmp    802fcc <strchr+0x2a>
		if (*s == c)
  802fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb9:	0f b6 00             	movzbl (%rax),%eax
  802fbc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802fbf:	75 06                	jne    802fc7 <strchr+0x25>
			return (char *) s;
  802fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc5:	eb 15                	jmp    802fdc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802fc7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd0:	0f b6 00             	movzbl (%rax),%eax
  802fd3:	84 c0                	test   %al,%al
  802fd5:	75 de                	jne    802fb5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	48 83 ec 0c          	sub    $0xc,%rsp
  802fe6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fea:	89 f0                	mov    %esi,%eax
  802fec:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802fef:	eb 13                	jmp    803004 <strfind+0x26>
		if (*s == c)
  802ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff5:	0f b6 00             	movzbl (%rax),%eax
  802ff8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ffb:	75 02                	jne    802fff <strfind+0x21>
			break;
  802ffd:	eb 10                	jmp    80300f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802fff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803008:	0f b6 00             	movzbl (%rax),%eax
  80300b:	84 c0                	test   %al,%al
  80300d:	75 e2                	jne    802ff1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80300f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803013:	c9                   	leaveq 
  803014:	c3                   	retq   

0000000000803015 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803015:	55                   	push   %rbp
  803016:	48 89 e5             	mov    %rsp,%rbp
  803019:	48 83 ec 18          	sub    $0x18,%rsp
  80301d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803021:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803024:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803028:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80302d:	75 06                	jne    803035 <memset+0x20>
		return v;
  80302f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803033:	eb 69                	jmp    80309e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803039:	83 e0 03             	and    $0x3,%eax
  80303c:	48 85 c0             	test   %rax,%rax
  80303f:	75 48                	jne    803089 <memset+0x74>
  803041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803045:	83 e0 03             	and    $0x3,%eax
  803048:	48 85 c0             	test   %rax,%rax
  80304b:	75 3c                	jne    803089 <memset+0x74>
		c &= 0xFF;
  80304d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803054:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803057:	c1 e0 18             	shl    $0x18,%eax
  80305a:	89 c2                	mov    %eax,%edx
  80305c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80305f:	c1 e0 10             	shl    $0x10,%eax
  803062:	09 c2                	or     %eax,%edx
  803064:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803067:	c1 e0 08             	shl    $0x8,%eax
  80306a:	09 d0                	or     %edx,%eax
  80306c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80306f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803073:	48 c1 e8 02          	shr    $0x2,%rax
  803077:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80307a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80307e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803081:	48 89 d7             	mov    %rdx,%rdi
  803084:	fc                   	cld    
  803085:	f3 ab                	rep stos %eax,%es:(%rdi)
  803087:	eb 11                	jmp    80309a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803089:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80308d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803090:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803094:	48 89 d7             	mov    %rdx,%rdi
  803097:	fc                   	cld    
  803098:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80309a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80309e:	c9                   	leaveq 
  80309f:	c3                   	retq   

00000000008030a0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8030a0:	55                   	push   %rbp
  8030a1:	48 89 e5             	mov    %rsp,%rbp
  8030a4:	48 83 ec 28          	sub    $0x28,%rsp
  8030a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8030b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8030bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8030c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8030cc:	0f 83 88 00 00 00    	jae    80315a <memmove+0xba>
  8030d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030da:	48 01 d0             	add    %rdx,%rax
  8030dd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8030e1:	76 77                	jbe    80315a <memmove+0xba>
		s += n;
  8030e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8030eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ef:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8030f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f7:	83 e0 03             	and    $0x3,%eax
  8030fa:	48 85 c0             	test   %rax,%rax
  8030fd:	75 3b                	jne    80313a <memmove+0x9a>
  8030ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803103:	83 e0 03             	and    $0x3,%eax
  803106:	48 85 c0             	test   %rax,%rax
  803109:	75 2f                	jne    80313a <memmove+0x9a>
  80310b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310f:	83 e0 03             	and    $0x3,%eax
  803112:	48 85 c0             	test   %rax,%rax
  803115:	75 23                	jne    80313a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311b:	48 83 e8 04          	sub    $0x4,%rax
  80311f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803123:	48 83 ea 04          	sub    $0x4,%rdx
  803127:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80312b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80312f:	48 89 c7             	mov    %rax,%rdi
  803132:	48 89 d6             	mov    %rdx,%rsi
  803135:	fd                   	std    
  803136:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803138:	eb 1d                	jmp    803157 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80313a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803146:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80314a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314e:	48 89 d7             	mov    %rdx,%rdi
  803151:	48 89 c1             	mov    %rax,%rcx
  803154:	fd                   	std    
  803155:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803157:	fc                   	cld    
  803158:	eb 57                	jmp    8031b1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80315a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80315e:	83 e0 03             	and    $0x3,%eax
  803161:	48 85 c0             	test   %rax,%rax
  803164:	75 36                	jne    80319c <memmove+0xfc>
  803166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316a:	83 e0 03             	and    $0x3,%eax
  80316d:	48 85 c0             	test   %rax,%rax
  803170:	75 2a                	jne    80319c <memmove+0xfc>
  803172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803176:	83 e0 03             	and    $0x3,%eax
  803179:	48 85 c0             	test   %rax,%rax
  80317c:	75 1e                	jne    80319c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80317e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803182:	48 c1 e8 02          	shr    $0x2,%rax
  803186:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803191:	48 89 c7             	mov    %rax,%rdi
  803194:	48 89 d6             	mov    %rdx,%rsi
  803197:	fc                   	cld    
  803198:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80319a:	eb 15                	jmp    8031b1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80319c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031a4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8031a8:	48 89 c7             	mov    %rax,%rdi
  8031ab:	48 89 d6             	mov    %rdx,%rsi
  8031ae:	fc                   	cld    
  8031af:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8031b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8031b5:	c9                   	leaveq 
  8031b6:	c3                   	retq   

00000000008031b7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8031b7:	55                   	push   %rbp
  8031b8:	48 89 e5             	mov    %rsp,%rbp
  8031bb:	48 83 ec 18          	sub    $0x18,%rsp
  8031bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8031cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031cf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d7:	48 89 ce             	mov    %rcx,%rsi
  8031da:	48 89 c7             	mov    %rax,%rdi
  8031dd:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
}
  8031e9:	c9                   	leaveq 
  8031ea:	c3                   	retq   

00000000008031eb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8031eb:	55                   	push   %rbp
  8031ec:	48 89 e5             	mov    %rsp,%rbp
  8031ef:	48 83 ec 28          	sub    $0x28,%rsp
  8031f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8031ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803203:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80320b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80320f:	eb 36                	jmp    803247 <memcmp+0x5c>
		if (*s1 != *s2)
  803211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803215:	0f b6 10             	movzbl (%rax),%edx
  803218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321c:	0f b6 00             	movzbl (%rax),%eax
  80321f:	38 c2                	cmp    %al,%dl
  803221:	74 1a                	je     80323d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803227:	0f b6 00             	movzbl (%rax),%eax
  80322a:	0f b6 d0             	movzbl %al,%edx
  80322d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803231:	0f b6 00             	movzbl (%rax),%eax
  803234:	0f b6 c0             	movzbl %al,%eax
  803237:	29 c2                	sub    %eax,%edx
  803239:	89 d0                	mov    %edx,%eax
  80323b:	eb 20                	jmp    80325d <memcmp+0x72>
		s1++, s2++;
  80323d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803242:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803247:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80324f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803253:	48 85 c0             	test   %rax,%rax
  803256:	75 b9                	jne    803211 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803258:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80325d:	c9                   	leaveq 
  80325e:	c3                   	retq   

000000000080325f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80325f:	55                   	push   %rbp
  803260:	48 89 e5             	mov    %rsp,%rbp
  803263:	48 83 ec 28          	sub    $0x28,%rsp
  803267:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80326b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80326e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80327a:	48 01 d0             	add    %rdx,%rax
  80327d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803281:	eb 15                	jmp    803298 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803287:	0f b6 10             	movzbl (%rax),%edx
  80328a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80328d:	38 c2                	cmp    %al,%dl
  80328f:	75 02                	jne    803293 <memfind+0x34>
			break;
  803291:	eb 0f                	jmp    8032a2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803293:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8032a0:	72 e1                	jb     803283 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8032a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8032a6:	c9                   	leaveq 
  8032a7:	c3                   	retq   

00000000008032a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8032a8:	55                   	push   %rbp
  8032a9:	48 89 e5             	mov    %rsp,%rbp
  8032ac:	48 83 ec 34          	sub    $0x34,%rsp
  8032b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032b8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8032bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8032c2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8032c9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8032ca:	eb 05                	jmp    8032d1 <strtol+0x29>
		s++;
  8032cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8032d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d5:	0f b6 00             	movzbl (%rax),%eax
  8032d8:	3c 20                	cmp    $0x20,%al
  8032da:	74 f0                	je     8032cc <strtol+0x24>
  8032dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e0:	0f b6 00             	movzbl (%rax),%eax
  8032e3:	3c 09                	cmp    $0x9,%al
  8032e5:	74 e5                	je     8032cc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8032e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032eb:	0f b6 00             	movzbl (%rax),%eax
  8032ee:	3c 2b                	cmp    $0x2b,%al
  8032f0:	75 07                	jne    8032f9 <strtol+0x51>
		s++;
  8032f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032f7:	eb 17                	jmp    803310 <strtol+0x68>
	else if (*s == '-')
  8032f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fd:	0f b6 00             	movzbl (%rax),%eax
  803300:	3c 2d                	cmp    $0x2d,%al
  803302:	75 0c                	jne    803310 <strtol+0x68>
		s++, neg = 1;
  803304:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803309:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803310:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803314:	74 06                	je     80331c <strtol+0x74>
  803316:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80331a:	75 28                	jne    803344 <strtol+0x9c>
  80331c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803320:	0f b6 00             	movzbl (%rax),%eax
  803323:	3c 30                	cmp    $0x30,%al
  803325:	75 1d                	jne    803344 <strtol+0x9c>
  803327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332b:	48 83 c0 01          	add    $0x1,%rax
  80332f:	0f b6 00             	movzbl (%rax),%eax
  803332:	3c 78                	cmp    $0x78,%al
  803334:	75 0e                	jne    803344 <strtol+0x9c>
		s += 2, base = 16;
  803336:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80333b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803342:	eb 2c                	jmp    803370 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803344:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803348:	75 19                	jne    803363 <strtol+0xbb>
  80334a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334e:	0f b6 00             	movzbl (%rax),%eax
  803351:	3c 30                	cmp    $0x30,%al
  803353:	75 0e                	jne    803363 <strtol+0xbb>
		s++, base = 8;
  803355:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80335a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803361:	eb 0d                	jmp    803370 <strtol+0xc8>
	else if (base == 0)
  803363:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803367:	75 07                	jne    803370 <strtol+0xc8>
		base = 10;
  803369:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803370:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803374:	0f b6 00             	movzbl (%rax),%eax
  803377:	3c 2f                	cmp    $0x2f,%al
  803379:	7e 1d                	jle    803398 <strtol+0xf0>
  80337b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337f:	0f b6 00             	movzbl (%rax),%eax
  803382:	3c 39                	cmp    $0x39,%al
  803384:	7f 12                	jg     803398 <strtol+0xf0>
			dig = *s - '0';
  803386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338a:	0f b6 00             	movzbl (%rax),%eax
  80338d:	0f be c0             	movsbl %al,%eax
  803390:	83 e8 30             	sub    $0x30,%eax
  803393:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803396:	eb 4e                	jmp    8033e6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339c:	0f b6 00             	movzbl (%rax),%eax
  80339f:	3c 60                	cmp    $0x60,%al
  8033a1:	7e 1d                	jle    8033c0 <strtol+0x118>
  8033a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a7:	0f b6 00             	movzbl (%rax),%eax
  8033aa:	3c 7a                	cmp    $0x7a,%al
  8033ac:	7f 12                	jg     8033c0 <strtol+0x118>
			dig = *s - 'a' + 10;
  8033ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b2:	0f b6 00             	movzbl (%rax),%eax
  8033b5:	0f be c0             	movsbl %al,%eax
  8033b8:	83 e8 57             	sub    $0x57,%eax
  8033bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033be:	eb 26                	jmp    8033e6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8033c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c4:	0f b6 00             	movzbl (%rax),%eax
  8033c7:	3c 40                	cmp    $0x40,%al
  8033c9:	7e 48                	jle    803413 <strtol+0x16b>
  8033cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cf:	0f b6 00             	movzbl (%rax),%eax
  8033d2:	3c 5a                	cmp    $0x5a,%al
  8033d4:	7f 3d                	jg     803413 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8033d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033da:	0f b6 00             	movzbl (%rax),%eax
  8033dd:	0f be c0             	movsbl %al,%eax
  8033e0:	83 e8 37             	sub    $0x37,%eax
  8033e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8033e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8033ec:	7c 02                	jl     8033f0 <strtol+0x148>
			break;
  8033ee:	eb 23                	jmp    803413 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8033f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8033f5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033f8:	48 98                	cltq   
  8033fa:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8033ff:	48 89 c2             	mov    %rax,%rdx
  803402:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803405:	48 98                	cltq   
  803407:	48 01 d0             	add    %rdx,%rax
  80340a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80340e:	e9 5d ff ff ff       	jmpq   803370 <strtol+0xc8>

	if (endptr)
  803413:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803418:	74 0b                	je     803425 <strtol+0x17d>
		*endptr = (char *) s;
  80341a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80341e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803422:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803429:	74 09                	je     803434 <strtol+0x18c>
  80342b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342f:	48 f7 d8             	neg    %rax
  803432:	eb 04                	jmp    803438 <strtol+0x190>
  803434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803438:	c9                   	leaveq 
  803439:	c3                   	retq   

000000000080343a <strstr>:

char * strstr(const char *in, const char *str)
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	48 83 ec 30          	sub    $0x30,%rsp
  803442:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803446:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80344a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803452:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803456:	0f b6 00             	movzbl (%rax),%eax
  803459:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80345c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803460:	75 06                	jne    803468 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803466:	eb 6b                	jmp    8034d3 <strstr+0x99>

	len = strlen(str);
  803468:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346c:	48 89 c7             	mov    %rax,%rdi
  80346f:	48 b8 10 2d 80 00 00 	movabs $0x802d10,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	48 98                	cltq   
  80347d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803485:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803489:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80348d:	0f b6 00             	movzbl (%rax),%eax
  803490:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803493:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803497:	75 07                	jne    8034a0 <strstr+0x66>
				return (char *) 0;
  803499:	b8 00 00 00 00       	mov    $0x0,%eax
  80349e:	eb 33                	jmp    8034d3 <strstr+0x99>
		} while (sc != c);
  8034a0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8034a4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8034a7:	75 d8                	jne    803481 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8034a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ad:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8034b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b5:	48 89 ce             	mov    %rcx,%rsi
  8034b8:	48 89 c7             	mov    %rax,%rdi
  8034bb:	48 b8 31 2f 80 00 00 	movabs $0x802f31,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	75 b6                	jne    803481 <strstr+0x47>

	return (char *) (in - 1);
  8034cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034cf:	48 83 e8 01          	sub    $0x1,%rax
}
  8034d3:	c9                   	leaveq 
  8034d4:	c3                   	retq   

00000000008034d5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034d5:	55                   	push   %rbp
  8034d6:	48 89 e5             	mov    %rsp,%rbp
  8034d9:	48 83 ec 30          	sub    $0x30,%rsp
  8034dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8034e9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034f0:	00 00 00 
  8034f3:	48 8b 00             	mov    (%rax),%rax
  8034f6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	75 34                	jne    803534 <ipc_recv+0x5f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803500:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803511:	48 98                	cltq   
  803513:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80351a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803521:	00 00 00 
  803524:	48 01 c2             	add    %rax,%rdx
  803527:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80352e:	00 00 00 
  803531:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803534:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803539:	75 0e                	jne    803549 <ipc_recv+0x74>
		pg = (void*) UTOP;
  80353b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803542:	00 00 00 
  803545:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803549:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354d:	48 89 c7             	mov    %rax,%rdi
  803550:	48 b8 1c 05 80 00 00 	movabs $0x80051c,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
  80355c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80355f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803563:	79 19                	jns    80357e <ipc_recv+0xa9>
		*from_env_store = 0;
  803565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803569:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80356f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803573:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357c:	eb 53                	jmp    8035d1 <ipc_recv+0xfc>
	}
	if(from_env_store)
  80357e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803583:	74 19                	je     80359e <ipc_recv+0xc9>
		*from_env_store = thisenv->env_ipc_from;
  803585:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80358c:	00 00 00 
  80358f:	48 8b 00             	mov    (%rax),%rax
  803592:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80359e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035a3:	74 19                	je     8035be <ipc_recv+0xe9>
		*perm_store = thisenv->env_ipc_perm;
  8035a5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035ac:	00 00 00 
  8035af:	48 8b 00             	mov    (%rax),%rax
  8035b2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8035b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035bc:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8035be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035c5:	00 00 00 
  8035c8:	48 8b 00             	mov    (%rax),%rax
  8035cb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8035d1:	c9                   	leaveq 
  8035d2:	c3                   	retq   

00000000008035d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8035d3:	55                   	push   %rbp
  8035d4:	48 89 e5             	mov    %rsp,%rbp
  8035d7:	48 83 ec 30          	sub    $0x30,%rsp
  8035db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035de:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035e1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8035e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8035e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035ed:	75 0e                	jne    8035fd <ipc_send+0x2a>
		pg = (void*)UTOP;
  8035ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035f6:	00 00 00 
  8035f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8035fd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803600:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803603:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803607:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80360a:	89 c7                	mov    %eax,%edi
  80360c:	48 b8 c7 04 80 00 00 	movabs $0x8004c7,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
  803618:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80361b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80361f:	75 0c                	jne    80362d <ipc_send+0x5a>
			sys_yield();
  803621:	48 b8 b5 02 80 00 00 	movabs $0x8002b5,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80362d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803631:	74 ca                	je     8035fd <ipc_send+0x2a>
	if(result != 0)
  803633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803637:	74 20                	je     803659 <ipc_send+0x86>
		cprintf("ipc_send result is [%d]",result);
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363c:	89 c6                	mov    %eax,%esi
  80363e:	48 bf a8 3d 80 00 00 	movabs $0x803da8,%rdi
  803645:	00 00 00 
  803648:	b8 00 00 00 00       	mov    $0x0,%eax
  80364d:	48 ba c7 21 80 00 00 	movabs $0x8021c7,%rdx
  803654:	00 00 00 
  803657:	ff d2                	callq  *%rdx
	//panic("ipc_send not implemented");
}
  803659:	c9                   	leaveq 
  80365a:	c3                   	retq   

000000000080365b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
  80365f:	48 83 ec 14          	sub    $0x14,%rsp
  803663:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803666:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80366d:	eb 4e                	jmp    8036bd <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80366f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803676:	00 00 00 
  803679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367c:	48 98                	cltq   
  80367e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803685:	48 01 d0             	add    %rdx,%rax
  803688:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80368e:	8b 00                	mov    (%rax),%eax
  803690:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803693:	75 24                	jne    8036b9 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803695:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80369c:	00 00 00 
  80369f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a2:	48 98                	cltq   
  8036a4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8036ab:	48 01 d0             	add    %rdx,%rax
  8036ae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8036b4:	8b 40 08             	mov    0x8(%rax),%eax
  8036b7:	eb 12                	jmp    8036cb <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8036b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8036c4:	7e a9                	jle    80366f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8036c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036cb:	c9                   	leaveq 
  8036cc:	c3                   	retq   

00000000008036cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036cd:	55                   	push   %rbp
  8036ce:	48 89 e5             	mov    %rsp,%rbp
  8036d1:	48 83 ec 18          	sub    $0x18,%rsp
  8036d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8036d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036dd:	48 c1 e8 15          	shr    $0x15,%rax
  8036e1:	48 89 c2             	mov    %rax,%rdx
  8036e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036eb:	01 00 00 
  8036ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036f2:	83 e0 01             	and    $0x1,%eax
  8036f5:	48 85 c0             	test   %rax,%rax
  8036f8:	75 07                	jne    803701 <pageref+0x34>
		return 0;
  8036fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ff:	eb 53                	jmp    803754 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803705:	48 c1 e8 0c          	shr    $0xc,%rax
  803709:	48 89 c2             	mov    %rax,%rdx
  80370c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803713:	01 00 00 
  803716:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80371a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80371e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803722:	83 e0 01             	and    $0x1,%eax
  803725:	48 85 c0             	test   %rax,%rax
  803728:	75 07                	jne    803731 <pageref+0x64>
		return 0;
  80372a:	b8 00 00 00 00       	mov    $0x0,%eax
  80372f:	eb 23                	jmp    803754 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803735:	48 c1 e8 0c          	shr    $0xc,%rax
  803739:	48 89 c2             	mov    %rax,%rdx
  80373c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803743:	00 00 00 
  803746:	48 c1 e2 04          	shl    $0x4,%rdx
  80374a:	48 01 d0             	add    %rdx,%rax
  80374d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803751:	0f b7 c0             	movzwl %ax,%eax
}
  803754:	c9                   	leaveq 
  803755:	c3                   	retq   
