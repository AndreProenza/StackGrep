# StackGrep

`StackGrep` - An advanced custom grep engine.

## How it works?

`StackGrep` is a Haskell program that receives a file
as the only parameter on the command line. The program should
display all the lines in that file and prompt the user which string to filter.


## Example

Take for example the example-file.txt file provided in the repository. 

The file has the following content:
```
[haskell] Data.List
[haskell] System.Environment
[java] java.util.List
[java] java.util.ArrayList
[java] java.io.File
```

Run `StackGrep` with provided file example-file.txt:
```
$ runhaskell StackGrep.hs example-file.txt

[haskell] Data.List
[haskell] System.Environment
[java] java.util.List
[java] java.util.ArrayList
[java] java.io.File

Filtering:
> _
```

At this point, the program must accept any string as input. 
If this string is different from `"pop"` (this string has a special role,
explained below), we will repeat the process, showing only the lines of the
file containing the string
```
Filtering:
> java

[java] java.util.List
[java] java.util.ArrayList
[java] java.io.File

Filtering: java
> _
```

We can now repeat the process, filtering this time for example by the string `util`:
```
> util
[java] java.util.List
[java] java.util.ArrayList
Filtering: java, util

Filtering: java, util
> _
```

This time we're going to insert the special `"pop"` command. By doing so, the program
will remove the last filter applied:
```
Filtering: java, util
> pop
[java] java.util.List
[java] java.util.ArrayList
[java] java.io.File

Filtering: java
> _
```

Now we can add a filter again, or undo (unstack) the last filter. 
We opted for the second option.
```
Filtering: java
> pop
[haskell] Data.List
[haskell] System.Environment
[java] java.util.List
[java] java.util.ArrayList
[java] java.io.File

Filtering:
> _
```

One last `"pop"` terminates the program.

---


### Usage:

#### Compile
```bash
ghc --make StackGrep
```
#### Run
```bash
./StackGrep
```
#### Compile and run once
```bash
runhaskell StackGrep.hs <file.txt>
```
