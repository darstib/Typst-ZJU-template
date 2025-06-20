#import "@preview/touying:0.6.0": *
#import themes.university: *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong,
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: university-theme.with(
  aspect-ratio: "16-9",
  //   config-common(handout: true),
  config-info(
    title: [Typst Cheat Sheet],
    subtitle: [#text(
        size: 20pt,
      )[powered by #link("https://typst.app")[Typst], modified from #link("https://touying-typ.github.io/zh/")[Touying]]],
    author: [by #link("https://darstib.github.io/")[Darstib]],
    date: datetime.today(),
    // institution: [personal],
    logo: emoji.school,
    // logo: image("imgs/zju-logo.png", width: 30pt),
  ),
)

// set heading
#set heading(numbering: numbly("{1}.", default: "1.1"))
// #set heading(numbering: "1.1")
// #set heading(numbering: "一. 1.")
// set table
#show table.cell.where(y: 0): strong
#set table(
  columns: (auto, auto, auto),
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center } else { left }
  ),
)
// set link
#show link: set text(rgb("#418f79"))

/* Content begin */
#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(max-count: 2, outline(title: none, indent: 1em))

= #link("https://typst.app/docs/reference/syntax/")[Syntax]

== Modes<modes>

fdsaf

#table(
  // columns: (auto, auto, auto),
  inset: 8pt,
  align: (center + horizon),
  [*New mode*], [*Syntax*], [*Example*],
  [Code], [Prefix the code with `#`], [Number: `#(1 + 2)`],
  [Math], [Surround equation with `$..$`], [`$-x$` is the opposite of `$x$`],
  [Markup], [Surround markup with `[..]`], [#raw("#let name = [*Typst!*]", lang: "typst")],
)

== #link("https://typst.app/docs/reference/syntax/#markup")[Markup]
<markup>

#slide(composer: (1fr, 1fr))[
  Typst is a markup language. This means that you can use simple syntax to accomplish common layout tasks.
  #parbreak() // equal to a blank line
  - symbol
    + *strong*
    + _emphasis_
    + `raw text`
    + `<label>` and `@reference`
    + @markup @fn/* comment */ // comment
][

  - function
    + #strong[strong]
    + #emph[emphasis]
    + #raw("fn main();", lang: "rust")
    + #link("https://typst.app/docs/reference/text/raw/")[Link to raw usage]
    + #overline[overline]
    + #underline[underline]
    + #highlight[highlight]
    + #strike[strike]
    + #footnote[this is a footnote]<fn>
]

== Math

A in line function: $a^2 + b^2 = c^2$

A block function:

$ e^(i pi) + 1 = 0 $

more complex:

$ Mu:= mat(1, 2, 3, 4, 5, 6, 7, 8, 9) $

#link("https://typst.app/docs/reference/symbols/sym/")[*More symbol*]

== #link("https://typst.app/docs/reference/syntax/#code")[Code]

#slide[
  *Data type:* #raw("#type()", lang: "typst")
  - Length: 1em, 2pt, 3mm
  - Angle: 1deg, 2rad, 3grad
  - Fraction: 1fr
  - Ratio: 50%
  - Array: (1, 2, 3)
  - Dictionary: (a: 1, b: 2, c: "hi")
  - `[content](link)`
  - #link("https://typst.app/docs/reference/foundations/content/")[Content block: `[content]`]
  - Code block: {let x =1; x+1}
][
  *Usage:*
  - Field access: field.name
  - Function call: function()
  - Arg spreading: function(..args)
  - Method call: field.method()
  - #link("https://typst.app/docs/reference/foundations/function/#unnamed")[Unnamed func]: `#show "once?": it => [#it #it]"`
  - Named: #raw("#let add(a,b)=a+b", lang: "typst")
  - Let blinding: `#let a = 1`
  - #link("http://typst.app/docs/reference/styling/")[`#set` and `#show`]
  - #link("https://typst.app/docs/reference/context/")[`#context`]
]

= Get deeper

== #link("https://typst.app/docs/reference/scripting/")[Scripting]

#slide[

  === Field
  ```typst
  #let it = [== subtitle]
  #let dict = (greet: "Hello")
  #it.fields()
  #dict.greet
  #emoji.face
  ```
][\ \ \
  #let it = [== subtitle]
  #let dict = (greet: "Hello")
  // #dict.fields() // type dictionary has no method `fields`
  #it.fields()
  #dict.greet \
  #emoji.face \
  #emoji.cyclone
]

#slide(composer: (2fr, 1fr))[
  === Method

  Just like in python
  ```typst
  #let demo_str = "Hello, typst!"
  #demo_str
  #demo_str.len()
  #str.len(demo_str)
  ```
][
  \ \ \
  #let demo_str = "Hello, typst!"
  #demo_str \
  #demo_str.len() \
  #str.len(demo_str)
]

#slide[
  === Flow

  *Loop*


  ```typ
  #let n = 2
  #while n < 10 {
      n = (n * 2) - 1
      (n,)
  }

  #let s = "Hello, typst!"
  #for char in s [
      (#char,)
  ]
  ```
][
  Just like in python\
  *Condition*

  ```typ
  #if 1 < 2 [
    This is shown
  ] else [
    This is not.
  ]
  ```
]

== #link("https://typst.app/docs/reference/styling/")[Styling]

#[
  Words before `#set` looks like.

  ```typ
  #set text(font: "New Computer Modern") // set font
  ```

  #set text(font: "New Computer Modern")

  Words after `#set` looks like.
]

// #set text(font: "New Computer Modern")

```typ
#show table.cell.where(y: 0): strong
#show link: set text(rgb("#347c67"))
```

== #link("https://typst.app/docs/reference/foundations/selector/")[Selector]

#slide(composer: (3fr, 5fr))[
  === constructor

  - *func element*: \ `heading` `figure`
  - *special field*: `self.where(..any)`
  - *regex*: `^[a-z]+`
  - *location*: `#here().page()`
  - *`<lable>`*
][
  #raw("#show table.cell.where(y: 0): strong", lang: "typst")

  === definition
  - *self.or*(selector)
  - *self.and*(selector)
  - *self.before*(selector)
  - *self.after*(selector)
]

== #link("https://typst.app/docs/reference/foundations/function/")[Function]

#let alert(body, fill: red, inset: 8pt, radius: 4pt) = {
  set text(white)
  set align(center)
  rect(
    fill: fill,
    inset: inset,
    radius: radius,
    [*Warning:\ #body*],
  )
}

#slide[

  === define<inside-title>

  Using `#let` blinding to define a function, with a code block as the body.
  // #pause
  #alert(fill: blue)[
    This is a warning message.
  ]
][
  ```typst
  #let alert(body, fill: red, inset: 8pt, radius: 4pt) = {
    set text(white)
    set align(center)
    rect(
      fill: fill,
      inset: inset,
      radius: radius,
      [*Warning:\ #body*],
    )
  }
  ```
]

=== Import

#text[
  #set par(justify: true)
  Functions can be imported from one file (module) into another using import. For example, assume that we have defined the alert function from the previous example in a file called foo.typ. We can import it into another file by writing #raw("import 'foo.typ': alert.", lang: "t")
]

== #link("https://typst.app/docs/reference/model/figure/")[Figure]

#show figure: set block(breakable: false)
#show figure.caption: emph
#show figure.where(kind: table): set figure.caption(position: top)

=== #link("https://typst.app/docs/reference/visualize/image/")[image]

#figure(
  image("imgs/demo1.png", alt: "kamisato", width: 40%),
  caption: [Kamisato Ayaka],
  //   placement: auto,
  //   kind: image,
)<demo1>

The @demo1 is a demo picture.

=== #link("https://typst.app/docs/reference/model/table/")[table]

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 8pt,
    align: horizon,
    table.header(
      [],
      [Volume],
      [Parameters],
    ),

    [function1],
    $ pi h (D^2 - d^2) / 4 $,
    [
      $h$: height \
      $D$: outer radius \
      $d$: inner radius
    ],

    [function2], $ sqrt(2) / 12 a^3 $, [$a$: edge length],
  ),
  caption: [Timing results],
)<timeresult>

The @timeresult is a demo table.

== Other

#slide(composer: (2fr, 1fr))[

  === basic graph
  ```typ
  - #circle(radius: 10pt, fill: orange)
  - #rect(height: 20pt, fill: blue)
  - #square with gradient
  - #ellipse(height: 20pt, fill: green)
  - #polygon
  - #line
  ```
][\
  - #circle(radius: 10pt, fill: orange)
  - #rect(height: 15pt, fill: blue)
    #set square(height: 20pt)
  - #stack(
      dir: ltr,
      spacing: 1fr,
      square(fill: gradient.linear(..color.map.rainbow)),
      square(fill: gradient.radial(..color.map.rainbow)),
      square(fill: gradient.conic(..color.map.rainbow)),
    )
  - #ellipse(height: 20pt, fill: green)
  - #polygon(
      fill: blue.lighten(80%),
      stroke: blue,
      (20%, 0pt),
      (60%, 0pt),
      (80%, 20pt),
      (0%, 20pt),
    )
  - #stack(
      dir: ltr,
      spacing: 1em,
      line(stroke: 2pt + red),
      line(stroke: (paint: blue, thickness: 4pt, cap: "round")),
      line(stroke: (paint: blue, thickness: 1pt, dash: "dashed")),
      line(stroke: 2pt + gradient.linear(..color.map.rainbow)),
    )
]


#slide[
  === Sinks & Spreading
  #v(10pt)
  We can specify an argument sink which collects all excess arguments as `..args` and just spread it with `..args`
  #line(length: 100%, stroke: 0.1pt)
  #let format(title, ..authors) = {
    let by = authors.pos().join(", ", last: " and ")
    [*#title* \ _Written by #by;_]
  }
  #format("ArtosFlow", "Jane", "Joe", "Jake")
  #let arr = (1, 3, 5, 7, 9)
  #calc.max(..arr)
][
  ```typ
  #let format(title, ..authors) = {
    let by = authors.pos()
      .join(", ", last: " and ")
    [*#title* \ _Written by #by;_]
  }
  #format("ArtosFlow", "Jane", "Joe", "Jake")
  #let arr = (1, 3, 5, 7, 9)
  #calc.min(..arr)
  ```
]

#slide[
  === #link("https://typst.app/docs/reference/foundations/regex/")[Regex]
  ```typ
  // Works with string methods.
  #"a,b;c".split(regex("[,;]"))

  // Works with show rules.
  #show regex("\d+"): set text(red)

  The numbers 1 to 10.
  ```
][\ \
  // Works with string methods.
  #"a,b;c".split(regex("[,;]"))
  // Works with show rules.
  #show regex("\d+"): set text(red)
  \ \ \ \ \
  The numbers 1 to 10.
]

=== Box & block

The `#box` is a simple box, which inline just like #box(stroke: 1pt + orange, inset: 3pt)[this]. While the `#block` is a block element, which will be displayed as a "separate paragraphs", just like:

#block(stroke: 1pt + orange, inset: 3pt, width: auto)[this]

#rect[This is a rectangle, which is more convenient to use.]

#pagebreak()
=== #link("https://sitandr.github.io/typst-examples-book/book/basics/must_know/spacing.html")[Spacing]

Lorem ipsum dolor sit amet, #h(3em) consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magnam aliquam quaerat
voluptatem.

#v(2em)

Ut enim aeque doleamus animo, cum corpore dolemus.

#pagebreak()
=== #link("https://typst.app/docs/reference/model/quote/")[Quote]

#[
  #set quote(block: true)
  #show quote: set pad(x: 3em)
  // #show quote: set align(center)

  #quote(attribution: [Plato])[
    ... ἔοικα γοῦν τούτου γε σμικρῷ τινι αὐτῷ τούτῳ σοφώτερος εἶναι, ὅτι
    ἃ μὴ οἶδα οὐδὲ οἴομαι εἰδέναι.
  ]

  #pause

  #quote(attribution: "柏拉图")[
    #text(20pt)[... 因此，在我看来，在这件小事上，我至少比这个人稍微聪明一点，因为我不知道的事情，我也不认为自己知道。]
  ]
]
