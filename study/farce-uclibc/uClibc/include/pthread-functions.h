#if defined(__UCLIBC_HAS_THREADS_NATIVE__)
#include "libpthread/nptl/sysdeps/pthread/pthread-functions.h"
#endif

#if defined(__LINUXTHREADS_OLD__)
#include "libpthread/linuxthreads.old/sysdeps/pthread/pthread-functions.h"
#endif

#if defined(__LINUXTHREADS_NEW__)
#include "libpthread/linuxthreads/sysdeps/pthread/pthread-functions.h"
#endif

