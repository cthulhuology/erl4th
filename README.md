erl4th - A forth implemented in Erlang
======================================

Quick Start
-----------

The usage of this is currently:

  erl4th:eval([ 3,2,'&','1+','2*'],[],[],[{'1+', [1,'+',';']}, {'2*',[2,'*',';']}]). 
  
This will output:

  {[6],[],[{'1+',[1,'+',';']},{'2*',[2,'*',';']}]}
  
Where the return values are:

  { DataStack, ReturnStack, Dictionary }
  
Raison d'etre
-------------

The concept behind erl4th is to implement a very simple Forth style stack machine in Erlang to prototype building a distributed
Forth system.  Using the old code is data / data is code idiom, we can represent forth code as a list of atoms and integers, and
the dictionary as a proplist mapping atoms to lists of atoms and integers.  This means we can represent our entire computer as
a set of 3 or for lists, and can easily share those lists between Erlang nodes.

Next steps will involve making a simple REPL so that strings can be typed on a command line, parsed, and evaulated.  I will then
add basic properties for passing data and programs between nodes.  My plans are to play around with moving code to where the 
data lives, and returning back programs.  I might eventually extend erl4th with other i/o capabilities which will make it more
interesting for building demos.




