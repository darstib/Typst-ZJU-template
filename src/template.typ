#import "font.typ": font_serif, font_sans_serif, font_mono

#let make-venue(
  course,
) = move(
  dy: -1cm,
  {
    box(
      rect(fill: rgb("004b71"), inset: 8pt, height: 2.2cm, width: 7cm)[
        #align(left + top)[#image("image/zju_logo.min.svg", width: 5cm)]
        #set text(fill: white, weight: 600, size: 13pt)
        #align(bottom + right)[Zhejiang University]
      ],
    )
    box(pad(left: 10pt, bottom: 10pt, [#course]))
  },
)

#let make-title(
  title,
  authors,
  language: "en",
  article_type: "report",
  abstract,
  abstract_zh,
  keywords,
  keywords_zh,
) = {
  // --- Title ---
  if article_type == "paper" {
    align(center)[#text(24pt, fill: rgb("004b71"), title, weight: "bold")]
  } else {
    par(justify: false)[#text(24pt, fill: rgb("004b71"), title, weight: "bold")]
  }

  // --- Authors ---
  if authors.len() > 0 {
    let author_content_final = {
      // Use a block to scope the `set text`
      set text(12pt) // Default text size for author block
      if authors.len() == 1 {
        let author = authors.first()
        [
          #text(author.name) #h(1em)
          #if (author.id != "") { text(author.id) } #h(1em)
          #if (author.institution != none) { text(author.institution) } #h(1em)
          #if (author.mail != none) { link("mailto:" + author.mail, text(author.mail)) }
        ]
      } else {
        // More than one author
        grid(
          columns: authors.len(),
          row-gutter: 0.3em, // Vertical spacing within each author's stack
          column-gutter: 1.5em, // Horizontal spacing between author columns
          ..authors.map(author => align(center)[
            // Center the stack for this author
            #stack(
              dir: ttb, // Top-to-bottom arrangement of details
              spacing: 0.5em, // Spacing between items in the stack
              text(author.name, weight: "medium"),
              if author.id != "" { text(10pt, author.id) },
              if (author.institution != none) { text(author.institution) },
              if (author.mail != none) { link("mailto:" + author.mail, text(author.mail)) },
            )
          ])
        )
      }
    }

    if article_type == "paper" {
      align(center, author_content_final)
    } else {
      author_content_final
    }
    parbreak()
  }

  v(10pt)

  // --- Abstract / Table of Contents ---
  set text(
    10pt,
    font: font_serif, // Base fonts for this section
    lang: language,
  )
  set par(spacing: 1em, justify: true)

  if article_type == "paper" {
    if language == "zh" {
      // Local scope for Chinese abstract settings
      {
        align(center)[#heading(outlined: false, bookmarked: false, numbering: none)[*摘要*]]
        text[#h(2em) #abstract_zh]
        v(3pt)
        [*关键词：* #keywords_zh.join(text("； "))]
      }
    }

    align(center)[#heading(outlined: false, bookmarked: false, numbering: none)[Abstract]]
    text(abstract)
    v(3pt)
    [*Keywords:* #keywords.join(text("; "))]
  } else if article_type == "report" {
    // Table of Contents
    if language == "zh" {
      {
        set text(font: font_serif, lang: "zh") // Ensure correct font for "目录"
        outline(depth: 3, indent: 1.2em, title: "目录")
      }
    } else {
      outline(depth: 3, indent: 1.2em, title: "Table of Contents")
    }
  }
  v(18pt)
}

#let template(
  title: [],
  authors: (
    (name: "", id: "", institution: "", mail: ""),
  ),
  date: [],
  doi: "",
  language: "en",
  article_type: "report",
  keywords: ("keyword1", "keyword2"),
  keywords_zh: ("关键词1", "关键词2"),
  abstract: [abstract content],
  abstract_zh: [摘要内容],
  course: [course name],
  make-venue: make-venue,
  make-title: make-title,
  pagebreak_after_title: true,
  columns: 1,
  body,
) = {
  set page(
    paper: "a4",
    margin: (top: 1cm, bottom: 1in, x: 1.6cm),
    columns: columns,
    numbering: "1 / 1",
  )

  set text(
    10pt,
    font: font_serif,
    lang: language,
  )

  set heading(numbering: "I.1.")
  show heading: set text(size: 11pt)
  show heading.where(level: 1): set text(fill: rgb("004b71"), size: 12pt)
  show heading: set block(below: 8pt)
  show heading.where(level: 1): set block(below: 12pt)
  show heading: it => {
    // 为了中文段落能够顺利缩进两行
    // https://github.com/shuosc/SHU-Bachelor-Thesis-Typst/issues/12#issuecomment-1506872937
    it
    v(-1.0em)
    par(leading: 0em)[#text(size: 0em)[#h(0em)]]
  }

  place(make-venue(course), top, scope: "parent", float: true)
  place(
    make-title(
      title,
      authors,
      language: language,
      article_type: article_type,
      abstract,
      abstract_zh,
      keywords,
      keywords_zh,
    ),
    top,
    scope: "parent",
    float: true,
  )
  if pagebreak_after_title {
    pagebreak()
  }

  show math.equation: set text(font: "New Computer Modern Math")
  show raw: set text(font: font_mono)
  show raw.where(block: false): box.with(
    fill: luma(243),
    inset: (x: 1pt, y: 0pt),
    outset: (y: 2pt),
    radius: 2pt,
  )
  // use codex instead
  // show raw.where(block: true): block.with(
  //   stroke: luma(88.49%),
  //   inset: 5pt,
  //   radius: 2pt,
  // )
  set par(justify: true, first-line-indent: if language == "zh" { 2em } else { 0pt })
  show link: underline
  set list(
    indent: 1em,
    marker: (
      $bullet$,
      $triangle.filled.small.r$,
      $diamond.filled.small$,
      $square.filled.small$,
      $star.filled$,
    ),
  )

  show figure: set text(8pt)
  show figure: align.with(center)
  show figure.caption: pad.with(x: 5%)
  show figure.where(kind: table): it => {
    stack(
      dir: ttb,
      spacing: 0.75em, // Adjust spacing as needed
      align(center, it.caption), // Center the caption
      align(center, it.body), // Center the table body
    )
  }

  // for unnumbered headings label
  show ref: it => {
    if it.element != none and it.element.func() == heading and it.element.numbering == none {
      it.element.body
    } else {
      it
    }
  }
  body
}
