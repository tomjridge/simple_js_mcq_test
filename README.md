# Simple JavaScript MCQ test

This is a simple OCaml/JavaScript program for formative
multiple-choice question and answer tests. It is designed to be as
simple as possible to make a test and deploy it.


## Install

You don't need to build anything. Just copy the 3 files in src-other
to a directory on your webserver; modify `index.html` (to add the
title of the test etc) and `questions.md` (for the questions) to your
liking, and you are done.


## Question format 

Ssee src-other/questions.md :

~~~
What is the capital of the UK?

A. London
B. York
C. Leicester
ANSWER: A

---

Which is the best programming language?

A. Java
B. JavaScript
C. Python
D. OCaml
ANSWER: D

---

Which university is 84th in the Guardian league table?

A. Cambridge
B. Oxford
C. Leicester
ANSWER: C

~~~

