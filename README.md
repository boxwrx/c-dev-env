[//]: # (README.md)
[//]: # (Copyright © 2026 nTier Training. All rights reserved.)
[//]: #

![Banner Light](./.assets/images/banner-c-dev-env-light.png#gh-light-mode-only)
![banner Dark](./.assets/images/banner-c-dev-env-dark.png#gh-dark-mode-only)
<div align="right">
    A <a href="https://github.com/boxwrx">Box Works</a> Coding Environment<img alt="Box Logo" src="./.assets/images/box-small.png" />
</div>

# Introduction

This repository defines how to install the C/C++ development environment for Microsoft Windows, Apple macOS, and Ubuntu Linux.
The envrionment consists of the C/C++ compiler, Visual Studio Code, and a launch configuration in VS Code to run the file
currently visible in the editor.

The *launch configuration* used by VS Code is explored first, followed by tool setup instructions for each platform:

* [Microsoft Windows](#microsoft-windows)
* [Apple macOS](#apple-macos)
* [Ubuntu Linux](#ubuntu-linux)

VS Code is the modern integrated development environment (IDE) of choice.
An introduction for the Microsoft tool is at [https://code.visualstudio.com](https://code.visualstudio.com), and the
documentation is at [https://code.visualstudio.com/docs](https://code.visualstudio.com/docs).

## Launch Configuration

Compiling and running from the command line in an embedded terminal does not require any configuration in VS Code,
other than the compiler is in the environment PATH variable.

To compile and debug inside the integrated development environment (IDE), VS Code requires a launch configuration.
The *launch.json* file is stored in the *.vscode* folder in the project:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug C file",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}${/}${fileBasenameNoExtension}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${fileDirname}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "build C file",
            "windows": {
                "program": "${fileDirname}${/}${fileBasenameNoExtension}.exe"
            },
            "osx": {
                "MIMode": "lldb"
            }
        },
...
```

The launch configuration is built to compile an run the C file that is open in the VS Code editor window.
It expects the Gnu C/C++ compiler `gcc` and the debugger `gdb` to be available in a folder included
by the *environment* `PATH` variable.
Since C and C++ require a compilation before execution, the *launch.json* file delegates this to a task named
*build C file with gcc*, which is defined in the adjacent *tasks.json* file:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            // Compile the active .c file on its own.
            // gcc adds .exe automatically on Windows (MinGW), so one -o name works everywhere.
            "label": "build C file",
            "type": "shell",
            "command": "gcc",
            "args": [
                "-g",
                "${file}",
                "-o",
                "${fileDirname}${/}${fileBasenameNoExtension}"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": ["$gcc"],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        },
...
```

The demonstration files in this project include the launch configurations for three options: build and debug the
current C file being edited, build and debug the current C++ file (the commands are different), and build and debug
a multi-file program using *make*.
The configuration for *make* lives in the *
Copy the *.vscode* folder from this repository to you current project,
or copy the *launch.json* and *tasks.json* to your existing .vscode folder.

Copy the generic *Makefile* to the root of your project.
It is configured to build *helloworld* from a single file, but extending it with multiple files and changing the
project name simply requires adapting the file and changing the name of the executable in the launch configuration
for *make*.

## Local Environment Setup

### Microsoft Windows

The generic toolchain to develop for C & C++ in the Windows environment depends on MSYS2, UCRT64, and VS Code.
The installation of MSYS2 is via the Windows package manager.
Open a PowerShell window and run the following command ($ is the command prompt):

```sh
$ winget install --id MSYS2.MSYS2 -e
```

This installs MSYS2 which has a variety of terminal windows, each with its own predefined configuration.
Click on the Windows menu icon and search for MSYS2:

![MSYS2 search results](./.assets/images/search-msys2.png)

Our choice is to use the *UCRT64 toolchain*, which is the one the Microsoft distributes.
Click on the `MSYS2 UCRT64` icon to open the terminal window.
At the command prompt ($ in this example), run the following `pacman` command to use the MSYS2 package
manager to install the toolchain.
The commands are Intel-based, but the toolchain will run on a Windows computer using the ARM64 processor.

```sh
$ pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
:: There are 13 members in group mingw-w64-ucrt-x86_64-toolchain:
:: Repository ucrt64
   1) mingw-w64-ucrt-x86_64-binutils  2) mingw-w64-ucrt-x86_64-crt  3) mingw-w64-ucrt-x86_64-gcc
   4) mingw-w64-ucrt-x86_64-gdb  5) mingw-w64-ucrt-x86_64-gdb-multiarch
   6) mingw-w64-ucrt-x86_64-headers  7) mingw-w64-ucrt-x86_64-libmangle
   8) mingw-w64-ucrt-x86_64-libwinpthread  9) mingw-w64-ucrt-x86_64-make
   10) mingw-w64-ucrt-x86_64-pkgconf  11) mingw-w64-ucrt-x86_64-tools
   12) mingw-w64-ucrt-x86_64-winpthreads  13) mingw-w64-ucrt-x86_64-winstorecompat

Enter a selection (default=all):
resolving dependencies...
looking for conflicting packages...

...
(55/55) installing mingw-w64-ucrt-x86_64-winstorecompat      [###############################] 100%
:: Running post-transaction hooks...
(1/1) Updating the info directory file...
$
```

Run the following `pacman` command to install the MINGW *make* utility:

```sh
$ pacman -S make
```

Unfortunately the default environment PATH variable does not include the *C:/msys64/ucrt64 *bin* or the
*C:/msys64/usr/bin* folders.
Go back to the PowerShell window and run the following two commands:

```sh
$ [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\msys64\ucrt64\bin', 'User')
$ [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\msys64\usr\bin', 'User')
```

Close and reopen the PowerShell window to read the new path.
Verify that the toolchain and *make* are present by running the following three commands to get the version for
`gcc`, `gdb`, and `make`.
Your version numbers may differ:

```sh
$ gcc --version
gcc.exe (Rev4, Built by MSYS2 project) 16.1.0
Copyright (C) 2026 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
$ gdb --version
GNU gdb (GDB) 17.2
Copyright (C) 2025 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
$make --version
GNU Make 4.4.1
Built for x86_64-pc-msys
Copyright (C) 1988-2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
$ 
```

When VS Code is opened it will read the new path, and it opens PowerShell as the command shell in
the embedded terminal window.
Running the `gcc` command in the terminal window will not compile C/C++ programs.

Run VS Code.
On the left-side *Activity Bar* select the extensions icon (puzzle piece).
In the extensions search bar enter *ms-vscode.cpptools*.
Click on the extension in the list, this will load the page for the extension into the editor window.
If the extension is not already installed, install it.

![Microsoft C/C++ tools extension](./.assets/images/vscode-extensions.png)

Refer to the instructions for the [launch configuration instructions](#launch-configuration) above to enable compiling and running the open C/C++ source file from
the user interface in the IDE.

### Apple macOS

(Comming soon)

### Ubuntu Linux

(Comming soon)

## License

The code is licensed under the MIT license. You may use and modify all or part of it as you choose, as long as attribution to the source is provided per the license. See the details in the [license file](./LICENSE.md) or at the [Open Source Initiative](https://opensource.org/licenses/MIT).

---
Copyright &copy; 2026 Smallrock Internet Services, Inc. All rights reserved.