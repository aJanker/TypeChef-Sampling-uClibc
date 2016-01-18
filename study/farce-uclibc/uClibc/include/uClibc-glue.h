#if defined(__UCLIBC_HAS_THREADS_NATIVE__)
#include "libpthread/nptl/sysdeps/pthread/uClibc-glue.h"
#endif

#if defined (__LINUXTHREADS_NEW__)
#include "libpthread/linuxthreads/sysdeps/pthread/uClibc-glue.h"
#endif
