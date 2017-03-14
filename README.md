# Footwork

*Work in progress*

![screenshot](doc/screenshot.png)

An experimental footprint (text) editor for [KiCAD][kicad]. The aim is to allow [Racket][racket] scripting mixed in with data to generate and edit footprints.
More direct traditional manipulation (clicking and dragging and such) will be added as calls to scripting functions.

[sketch-n-sketch][sketch-n-sketch] is an inspiration which aims to provide a similar editor for SVGs and calls this style of manipulation "prodirect" (programmatic + direct).

## Planned features

- The interface is text-first allowing users to make arbitrary edits: their needs need not be anticipated by the user interface
- Users can use a fully featured general purpose programming languages to generate and modify footprints
- Traditional (mouse based) manipulation is being added as calls to scripting
- Racket's [Rosette language][rosette], an interface to SMT solvers, offers the exciting opportunity to make use of cutting edge techniques in programming synthesis for design automation

[kicad]: http://kicad-pcb.org
[racket]: http://racket-lang.org
[sketch-n-sketch]: https://ravichugh.github.io/sketch-n-sketch/
[rosette]: https://emina.github.io/rosette/
