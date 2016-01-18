#define LDSO_ELFINTERP "elfinterp.c"

#define RESOLVER "../inet/resolv.c"

# define PTHREAD_THREADS_MAX	1024

#define __UCLIBC_CLK_TCK_CONST	100
#define CLOCKS_PER_SEC  1000000l

#ifdef UCLIBC_HAS_STDIO_FUTEXES
#define __USE_STDIO_FUTEXES__
#endif

#ifdef __UCLIBC_HAS_WCHAR__
#define DO_WIDE_CHAR 1
#define __WCHAR_ENABLED 1
#endif

#ifdef __UCLIBC_MALLOC_DEBUGGING__
#define MALLOC_DEBUGGING 
#define HEAP_DEBUGGING

#ifdef __UCLIBC_UCLINUX_BROKEN_MUNMAP__
#define MALLOC_MMB_DEBUGGING
#endif

#endif

#define __FUNCTION__ __func__

#define LIBPTHREAD_SO "libpthread.so.0"

//#define _LIBC	


//#define  __FreeBSD__ 0

#define _FILE_OFFSET_BITS 32 

//#define __cplusplus 0

//not sure where these are generated from, but taken from .i files
#define __OPTIMIZE_SIZE__ 1
#define __OPTIMIZE__ 1
#define _FORTIFY_SOURCE 2
