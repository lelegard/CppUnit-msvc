               Binary installers for CppUnit static libraries
                     for Microsoft Visual Studio 2015
                      and Microsoft Visual C/C++ 14


Each installer has the same version number as the corresponding CppUnit framework.
Thus, cppunit-msvc-1.12.1.exe installs the binary static libraries for cppunit 1.12.1.

The static libraries are provided for "Release" and "Debug" configurations on
platforms "Win32", "x86" and "x64" ("Win32" and "x86" are identical). The
installers can be used on 32-bit or 64-bit Windows. The libraries are installed
for both architectures.

After installation, the environment variable CppUnitRoot points to the CppUnit root,
typically C:\Program Files (x86)\CppUnit or C:\Program Files\CppUnit.

From Visual Studio, you can reference CppUnit libraries using the CppUnit property
sheet %CppUnitRoot%\CppUnit.props. In your Visual Studio project file, an XML file
ending in .vcxproj, add the following section.

  <ImportGroup Label="PropertySheets">
    <Import Project="$(CppUnitRoot)\CppUnit.props" />
  </ImportGroup>

From C source files of your application's unitary tests, use CppUnit the same way
as on any platform. Namely, from any source file:

  #include <cppunit/TestAssert.h>

Compiling and linking from Visual Studio is done transparently.
