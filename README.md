

**Program Usage Instructions**:

The program accepts Pascal-S source code as standard input by default and outputs the generated C code to standard output. It also outputs the debug information generated during the compilation process to standard error. All three input/output streams can be redirected to files.

This program is a command-line tool, and the executable file after project building is called "pascals-to-c". The command syntax is as follows:

pascals-to-c [-h] [-i <file>] [-o <file>] [-l <file>]

Command options:

- -h, --help: View the help information.
- -d, --debug: Enable debug mode.
- -i, --input <file>: Redirect input code to the specified file.
- -o, --output <file>: Redirect output target code to the specified file.
- -l, --log <file>: Redirect debug information to the specified file.

The program requires CMake for compilation. After building, use `cmake .. make .` in the build folder.

Then, you can run `ctest .` to execute all tests, or `ctest -R +unit name` to run tests for a specific batch. For example, `ctest -R codegen` runs the code generation tests.

**Development Environment**:

OS: Linux Ubuntu 20.04

Programming Language: C++ 20

Tools Used:

- gcc 9.4.0 x86_64-linux-gnu
- flex 2.6.4
- bison (GNU Bison) 3.5.1

IDEs:

- VSCode 1.76.2
- CLion 2022.3

Project Building: cmake version 3.16.3

Testing Tool: ctest version 3.16.3

