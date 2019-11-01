# http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html

#normal=$(tput sgr0)                      # normal text
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37


Shared libraries are .so (or in Windows .dll, or in OS X .dylib) files. All the code relating to the library is in this file, and it is referenced by programs using it at run-time. A program using a shared library only makes reference to the code that it uses in the shared library.

Static libraries are .a (or in Windows .lib) files. All the code relating to the library is in this file, and it is directly linked into the program at compile time. A program using a static library takes copies of the code that it uses from the static library and makes it part of the program. [Windows also has .lib files which are used to reference .dll files, but they act the same way as the first one].

There are advantages and disadvantages in each method:

Shared libraries reduce the amount of code that is duplicated in each program that makes use of the library, keeping the binaries small. It also allows you to replace the shared object with one that is functionally equivalent, but may have added performance benefits without needing to recompile the program that makes use of it. Shared libraries will, however have a small additional cost for the execution of the functions as well as a run-time loading cost as all the symbols in the library need to be connected to the things they use. Additionally, shared libraries can be loaded into an application at run-time, which is the general mechanism for implementing binary plug-in systems.

Static libraries increase the overall size of the binary, but it means that you don't need to carry along a copy of the library that is being used. As the code is connected at compile time there are not any additional run-time loading costs. The code is simply there.

Personally, I prefer shared libraries, but use static libraries when needing to ensure that the binary does not have many external dependencies that may be difficult to meet, such as specific versions of the C++ standard library or specific versions of the Boost C++ library.