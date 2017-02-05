# Footwork

PCB designs as code and EDA as code synthesis

<img style="width:300px;float:right" src=images/mod.svg>

<font size=5>
Kaspar Emanuel
---

<img src=images/kicad_logo_paths.svg>
<img src=images/kicad_web.png width=100%>


???
- As most people know here KiCAD is a PCB editing suite
- This all began with the text-based KiCAD formats
- Quite happy that, if something wasn't supported by the GUI, I can open up a text editor and do it myself
- The older formats seemed a bit ad-hoc and ugly, but I am a big fan of the newer S-expression based formats
---
<img class=fullscreen src=images/kicad_screenshot.png>

???
- Whenever I had to dive down into the text and change things I wished KiCAD would refresh everything automatically so I could see my changes right away
---
# haskell-kicad-data
```haskell
> let pad = parse "(pad 1 smd rect (size 1 1) (at 1 1) (layers F.Cu))"
> pad
Right (PcbnewExprItem (PcbnewPad {padNumber = "1", padType = SMD, padShape =
Rect, itemAt = PcbnewAtT {pcbnewAtPoint = (1.0,1.0), pcbnewAtOrientation =
0.0}, itemSize = (1.0,1.0), padLayers = [FCu], padAttributes_ = []}))
> fmap write pad
Right "(pad \"1\" smd rect (at 1 1) (size 1 1) (layers F.Cu))"
```
- <i class="fa fa-github"></i> [monostable/haskell-kicad-data](https://github.com/monostable/haskell-kicad-data)
- MIT licensed
- Well tested: 
   - With all the footprints available on the internet (over [20,000](https://github.com/monostable/kicad_footprints))
   - QuickCheck 
???

- When I was learning Haskell, I decided to write a parser for KiCAD footprints as an excersise
- Since I had heard s-expressions are easy to parse
- Writing this parser I learnt about s-expressions
- So I have spent a lot of time testing this library, mostly because I enjoyed it
- And I run the parser against all the footprints i can find
- But one of my favorite things about learning haskell was finding out about quickchec

---
#QuickCheck

Quickcheck will generate random test cases to try and disprove your logical assertion.

```
parse (write (expression)) == expression
```

Then it will reduce it down to the simplest possible case.

```
PcbnewExpr:
  parse fp_line correctly: [OK, passed 100 tests]
  parse fp_arc correctly: [OK, passed 100 tests]
  parse fp_poly correctly: [OK, passed 100 tests]
  parse and write any PcbnewExpr: [Failed]
*** Failed! Falsifiable (after 32 tests): 
PcbnewExprModule (PcbnewModule {pcbnewModuleName = "A<", ...
```

???
- Quickcheck will pretty much throw randomly generated data at your program to disprove you
- So in my case the assertion is mostly that whatever is written and then parsed is the same as the original expression


---
# S-expressions

S-expressions are a representation of the parse tree.
```racket
(* 2 (+ 3 4))
```
<img src=images/tree.png>
<font size=4 style="float:right">

image: Wikipedia, <a href=https://en.wikipedia.org/wiki/User:Natecull>Natecull</a>

???
- Anyway in wrting this parser i also learnt about s-expressions
- Not only easy to parse but they are actually a simple representation of the parse tree
- The data structure that you use to exectute the code

</font>
---
<font size=3>
<p style="float:right">
image: https://xkcd.com/297/
</p>
</font>
<img src=images/lisp_cycles.png>

<img src=images/racket.png>

"A programmable programming language"

???
- Started looking into lisps
- Because of this ease of manipulating the s-expression structure that the programs are written in, lisps have a strong focus on macros and re-defining the language
- Discovered Racket, a scheme
- Racket takes the macros to the extreme, letting you define your own domain specific languages

---
<img width=100% src=images/drracket0.png>

???
- Has very mature bindings to GTK  and this wicked IDE called drrracket
- This is a drracket window
---
<img width=100% src=images/drracket.png>

???
- Notice the lang slideshow at the top, so this is the slideshow languages
- And the REPL can actually give you graphical output!

---
<img width=100% src=images/drracket2.png>

???
- But it's taken macros to the extreme, you can do away with s-expressions
- There is even an implementation of Python

---

<img src=images/lang_kicad.png>

???

So the idea would be to implement a language for kicad in racket

---
<img class=fullheight src=images/screenshot.png> 

???

- And this is as far as I got with implementing this language
- and the dual pane editor I was dreaming about
- So you can mix in your general purpose programming langage into the footprint defenition
- So we have a for loop here, this is more like a map if you are used to functional programming, it will return the statement following it
- You can recurse arbitrarly deep into this and it will all be flattened at the end
- Before you get too excited this screen is really showing my program in the best light
- It can do what is shown here but this isn't actually true to kicad's units or coordinates yet

---

#A side note on parens
[Parinfer](https://shaunlebron.github.io/parinfer/) is really nice for beginners

<img src=images/parinfer.gif width=100%>

???

- This is a little side note for people that are put off by the parentheses
- As a beginner I found parinfer plugins really nice
- They are available for quite a few popular editors
- And it infers your parenthesis from your indentation
- So as someone that isn't used to putting in all these parentheses
- That's quite nice  
- It's probably horrible for seasoneed lispers, but as a beginner is quite nice


---

<img class=fullheight src=images/screenshot.png> 

???

- So back to the footwork editor
- In addition to the programming and text-editing
- It would also be quite nice to add graphical or "direct" manipulation 

---

<img class=fullscreen src=images/sketchnsketch.png>

???

- And I found a project that is trying to do just that with SVG editing
- It is called sketch-n-sketch and it's a web app that you can run
- This is also quite experimental but they are coming up with some interesting tequniques for a similar ideas


---

How can you make arbitrary constructs like this

```racket
(for ([i (range 0 100 10)]) 
   (pad (at 0 i) (size 5 5))
```

???

- So I started researching into how can I get my program to make arbitrary constructs like this
- And I found out about code synthesis 

---

```racket
#lang rosette
```

[Rosette](https://emina.github.io/rosette/) is a solver-aided programming language that extends Racket with language constructs for program synthesis, verification, and more. 

???

So I had heard of formal verification, and that is something you might do for really safety critical systems. But I had never heard you could use it for programming synthesis.

---
- Rosette connects Racket up to SMT solvers
- SMT (and SAT) solvers try and exhaustively disprove your logical assertions
- How do they do this?

???

- That's a great question
- At this point I haven't learnt enough about this to present it to someone else
- There are a lot of interesting algorithms for this and to try and reduce the search area
- This seems to be an active area of research
- What I do know is that there are a lot of these

---

<img class=zero src=images/smts.png>

???

- This is  section of the list of smt solvers from wikipedia
- And they implement different algorithm a
- The one Rosette uses by default is the Z3 solver from microsoft at the bottom here

---
<img width=100% src=images/emina.png>

From: "Synthesis and Verification for All" - Emina Torlak, [Sixth RacketCon](http://con.racket-lang.org/)
([Youtube](https://www.youtube.com/watch?v=nOyIKCszNeI&list=PLXr4KViVC0qKSiKGO6Vz9EtxUfKPb1Ma0))

---

So how can we use this for synthesis?

The basic principle seems to be:

- Give it a template of our desired construct
- With holes for the bits we want to synthesize

```racket
(define loop
   (for ([i (range ?? ?? ??)]) 
      (pad (at 0 i)))
```
---
- Give it some sot of assertion

```racket
(assert 
   (eq (execute loop) 
      ((pad (at 0 1)) (pad (at 0 2)))))
```

- And the solver/Rosette will figure out the rest

---
Even more possibility than my weird footprint editor!

<img src=images/flashfill.gif>

---
Questions?

- https://emina.github.io/rosette/
- get in touch with me: https://github.com/kasbah
