# RBG Code
**Date** : *18 Jan 2020*

**Author** : Vikesh Siddhu <vsiddhu@andrew.cmu.edu>

This directory contains a mathematica package, [qinf050.m](qinf050.m). This
package is obtained by modifying a mathematica file, `qinf050.ma`, obtained from
the **Quantum Information Programs in Mathematica**
[website](https://quantum.phys.cmu.edu/QPM/) as part of a
[zipped](https://quantum.phys.cmu.edu/QPM/qinf050.zip) file. This zipped file
also has additional documentation about these functions and a 
[license file](license.txt).

The **Quantum Information Programs in Mathematica**
[website](https://quantum.phys.cmu.edu/QPM/) indicates that the collection of
functions and other objects there are *intended for tinkerers: users who want
to set up and modify their own simulation programs using Mathematica,..*.  To
faciliate such tinkering, the functions in the `qinf050.ma` file have been
turned into a package, `qinf050.m`, by

* adding
  [BeginPackage](https://reference.wolfram.com/language/ref/BeginPackage.html)
  and [Begin](https://reference.wolfram.com/language/ref/Begin.html) commands
  to `qinf050.ma`. These command set values for
  [$Context](https://reference.wolfram.com/language/ref/$Context.html) and
  [$ContextPath](https://reference.wolfram.com/language/ref/$ContextPath.html);

* moving and reformating usage text for functions. In `qinf050.ma`, such text
  was added just prior to each function. Now the usage text has been moved to
  the space between `BeginPackage[..]` and `Begin[..]` commands. During the
  move some end of line symbols within the usage text have been removed;

* commenting out a deprecated package called `Statistics`NormalDistribution`"`.

The full output of 

```
diff qinf050.m qinf050.ma
``` 

is included in the [diffOutput](diffOutput) file.

# Examples

Three examples are included in this directory

* [Example1.nb](Example1.nb) - To load the mathematica package, `qinf050.m`,
  when launching Mathematica from command line.

* [Example2.nb](Example2.nb) - To load the mathematica package, `qinf050.m`,
  when using a mathematica notebook.

* [Example3.nb](Example3.ma) - To load the mathematica package, `qinf050.m`,
  when using mathematica in script mode.

## License

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version .  

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
Street, Fifth Floor, Boston, MA 02110-1301, USA.

For additional details, see the [LICENSE](license.txt) file.

