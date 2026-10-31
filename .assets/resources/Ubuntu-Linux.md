![Banner Light](../images/banner-c-dev-env-light.png#gh-light-mode-only)
![banner Dark](../images/banner-c-dev-env-dark.png#gh-dark-mode-only)

# C/C++ Setup for Ubuntu Linux

## Build Tools

Ubuntu may be installed with the Gnu C/C++ environment.
Open a terminal window and run the following commands to see if the tools are installed ($ is the command prompt):

```sh
$ gcc --version
bash: gcc: No such file or directory
$ gdb --version
bash: make: No such file or directory
$ make --version
bash: make: No such file or directory
$
```

Use `sudo` and `apt` to install the the build tools including gcc and make, and the debugger, if they are
not installed:

```sh
$ sudo apt update
$ sudo apt install build-essential
$ sudo apt install gdb
$ 
```

## Visual Studio Code

If VS Code is not already installed on your computer you will need to install it.
Visual studio code is not available through the Ubuntu repositories.
Visit the [VS Code download page](https://code.visualstudio.com/download) and click the button to
download the *deb* installation file for *Debian/Ubuntu Linux*.

In the terminal window make sure you are in your home directory by using the command `cd`,
then change directory to the *Downloads* folder.
Install the *deb* file using `apt`.
Your filename may vary depending on the version number, so the installation command uses the asterisk to match then name:

```sh
$ cd
$ cd Downloads
$ sudo app install ./code_*.deb
$
```

Open the VS Code application.
On the left-side *Activity Bar* select the extensions icon (puzzle piece).
In the extensions search bar enter *ms-vscode.cpptools*.
Click on the extension in the list, this will load the page for the extension into the editor window.
If the extension is not already installed, install it.

![Microsoft C/C++ tools extension](../images/vscode-extensions.png)

Refer to the instructions for the [launch configuration instructions](../../README.md/#launch-configuration) to enable compiling and running the open C/C++ source file from
the user interface in the IDE.