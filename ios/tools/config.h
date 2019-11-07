#if   defined(__aarch64__)
    #include "arm64/config.h"
#elif defined(__x86_64__)
    #nclude "x86_64/config.h"
#elif defined(__arm__)
    #if defined(__ARM_ARCH_7S__)
        #include "armv7s/config.h"
    #elif defined(__ARM_ARCH)
        #if __ARM_ARCH == 7
            #include "armv7/config.h"
        #else
            #error Unsupport ARM architecture
        #endif
    #else
        #error Unsupport ARM architecture
    #endif
#elif defined(__i386__)
    #include "i386/config.h"
#else
    #error Unsupport architecture
#endif
