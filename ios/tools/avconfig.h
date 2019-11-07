#if defined(__aarch64__)
    #include "arm64/avconfig.h"
#elif defined(__x86_64__)
    #include "x86_64/avconfig.h"
#elif defined(__arm__)
    #if defined(__ARM_ARCH_7S__)
        #include "armv7s/avconfig.h"
    #elif defined(__ARM_ARCH)
        #if __ARM_ARCH == 7
            #include "armv7/avconfig.h"
        #else
            #error Unsupport ARM architecture
        #endif
    #else
        #error Unsupport ARM architecture
    #endif
#elif defined(__i386__)
    #include "i386/avconfig.h"
#else
    #error Unsupport architecture
#endif
