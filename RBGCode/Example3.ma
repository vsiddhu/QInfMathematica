(*
Name    : Example3.ma;
Aim     : To correctly load the mathematica package when using mathematica in
          script mode.;
Author  : Vikesh Siddhu <vsiddhu@andrew.cmu.edu>;
Date    : 18 Jan 2020;

1.  In your current directory place qinf050.m. If the qinf050.m file is placed
    in some other directory with full path "/home/uname/MathPackage" then right
    after this commented region add a line 

    AppendTo[$Path, "/home/uname/MathPackage"];

2.  In command line run this file, Example3.ma. On ubuntu one can use
    Mathematica from command line as follows

        MathKernel -script Example3.ma >> Example3Output &

    where 'MathKernel' calls Mathematica, '-scrpit' is for running Mathematica
    in script mode (as opposed to the default interactive mode), 'Example3.ma'
    is the file being run, '>>' appends the Mathematica output to a file named
    'Example3Output', and '&' ensured this whole command runs in the background.

*)

(*Read in the Wolfram Language package with filename qinf050.m*)
<< qinf050`

(*Get a list of the contexts corresponding to all packages which have been loaded in your current Wolfram System session*)

Print["Packages"]
Print[$Packages]

(*Get names of all functions in the package*)
Print["Names of Functions in qinf050"]
Print[Names["qinf050`*"]]

(*Show usage of a function*)

Print["Usage of cphase"]
Print[?cphase]

(*Show definition of a function*)

Print["Definition of cphase"]
Print[Definition[cphase]]

(*Show usage of a function*)

Print["Usage of entropy"]
Print[?entropy]

(*Show definition of a function*)

Print["Definition of entropy"]
Print[Definition[entropy]]

