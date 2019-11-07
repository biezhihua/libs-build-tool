#if defined(__aarch64__)
    #include "arm64/ffversion.h"
#elif defined(__x86_64__)
    #include "x86_64/ffversion.h"
#elif defined(__arm__)
    #if defined(__ARM_ARCH_7S__)
        #include "armv7s/ffversion.h"
    #elif defined(__ARM_ARCH_7__)
        #include "armv7/ffversion.h"
    #else
        #error Unsupport ARM architecture
    #endif
#elif defined(__i386__)
    #include "i386/ffversion.h"
#else
    #error Unsupport architecture
#endif
