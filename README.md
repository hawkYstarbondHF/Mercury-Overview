# Mercury Overview for Programming Languages

## Installing

To install Mercury on GitHub codespaces, use the following sequence of commands. They are broken up into two blocks.

```
sudo apt update
sudo apt install -y wget ca-certificates
wget https://paul.bone.id.au/paul.asc
sudo cp paul.asc /etc/apt/trusted.gpg.d/paulbone.asc
rm paul.asc
sudo cp mercury.list /etc/apt/sources.list.d/
```

Note that you have to update the available packages again after adding the 
source to install Mercury from. Then you can actually install Mercury.

```
sudo apt update
sudo apt install -y gcc-multilib mercury-recommended
```

Installing Mercury on your personal machine is not recommended. The instructions above are based on [this website](https://dl.mercurylang.org/deb/), but they really only work easily on a Linux system. Mac users can supposedly use this [brew formula](https://formulae.brew.sh/formula/mercury). If you find an easy approach that works for Windows, let me know. 

## Running

Once Mercury is installed, you can compile the code with this command.

```
mmc --make main
```

Compiling the original code will produce several warnings, but should succeed. This creates an executable, that you can run with this command.

```
./main
```

However, note that the file you will actually edit is `mercury_overview.m`. The file `main.m` imports code from `mercury_overview.m` and executes it. Do not modify `main.m`.

## Testing

Because Mercury is fairly new, I am not aware of any official or established unit testing framework. However, I have created my own program that will your code. The file `test.m` contains the testing code, and you should not modify this file in any way. However, you may find it useful to look at its contents. To simplify execution of the tests, I have provided this command:

```
bash test.bash
```

Running this command will compile the `test.m` file and report several test failures. However, the output starts with several lines of output that start with `Making`. These are outputs from the compiler. If the code has not changed since the last time it was compiled, then the only line of output will be `Making test`. If all of the tests pass, then this will also be the last line of output. In other words, executing `test.m` does not output anything if your code fully works. It only reports test failures.

## Project Objectives

TODO: Explain the point of this assignment in your own words with a brief paragraph. Say what the code does.

## Files

TODO: Bulleted list with brief description of each file

## Known Issues

TODO: Describe any problems with your submission, or indicate that you believe everything functions correctly.

## Author

**Eleanor Wagner**
