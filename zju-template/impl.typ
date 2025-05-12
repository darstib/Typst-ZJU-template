

#let font_serif = (
  "Source Han Serif SC",
  "New Computer Modern",
  "LXGW WenKai GB Screen",
  "Noto Serif CJK SC",
  "Times New Roman",
  "Georgia",
  "STSong",
  "SimSun",
  "Songti SC",
  //   "Nimbus Roman No9 L",
  "AR PL New Sung",
  "AR PL SungtiL GB",
  "NSimSun",
  "TW\-Sung",
  "WenQuanYi Bitmap Song",
  "AR PL UMing CN",
  "AR PL UMing HK",
  "AR PL UMing TW",
  "AR PL UMing TW MBE",
  "PMingLiU",
  "MingLiU",
)
#let font_sans_serif = (
  "Noto Sans",
  "Helvetica Neue",
  "Helvetica",
  "Nimbus Sans L",
  "Arial",
  "Liberation Sans",
  "PingFang SC",
  "Hiragino Sans GB",
  "Noto Sans CJK SC",
  "Source Han Sans SC",
  "Source Han Sans CN",
  "Microsoft YaHei",
  "Wenquanyi Micro Hei",
  "WenQuanYi Zen Hei",
  "ST Heiti",
  "SimHei",
  "WenQuanYi Zen Hei Sharp",
)
#let font_mono = ("Maple Mono NF", "Consolas", "Monaco", ..font_sans_serif)

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
  set par(spacing: 1em)

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
          #if (author.institution != "") { text(author.institution) } #h(1em)
          #if (author.mail != "") { link("mailto:" + author.mail, text(author.mail)) }
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
              text(author.name, weight: "medium"), // Uses 12pt from set text
              if author.id != "" { text(10pt, author.id) }, // Smaller for ID
              text(10pt, author.institution), // Smaller for institution
              link("mailto:" + author.mail, text(10pt, author.mail)), // Smaller for email
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

  v(8pt) // Original vertical space

  // --- Abstract / Table of Contents ---
  set text(
    10pt,
    font: font_serif, // Base fonts for this section
    lang: language,
  )
  set par(justify: true) // Justify abstract/ToC text

  if article_type == "paper" {
    if language == "zh" {
      // Local scope for Chinese abstract settings
      {
        align(center)[#heading(outlined: false, bookmarked: false, numbering: none)[*摘要*]]
        text(abstract_zh)
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
        set text(font: (..font_serif, ..font_sans_serif), lang: "zh") // Ensure correct font for "目录"
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
  columns: 2,
  body,
) = {
  set page(
    paper: "a4",
    margin: (top: 1cm, bottom: 1in, x: 1.6cm),
    columns: columns,
  )
  set par(justify: true)
  set text(
    10pt,
    font: font_serif,
    lang: language,
  )

  set list(indent: 8pt)
  set heading(numbering: "I.")
  show heading: set text(size: 11pt)
  show heading.where(level: 1): set text(fill: rgb("004b71"), size: 12pt)
  show heading: set block(below: 8pt)
  show heading.where(level: 1): set block(below: 12pt)

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

  show math.equation: set text(font: font_mono)
  show raw: set text(font: font_mono)
  show raw.where(block: false): box.with(
    fill: luma(243),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  show link: underline

  show raw.where(block: true): block.with(
    stroke: luma(200),
    inset: 3pt,
    radius: 4pt,
  )

  show figure: set text(8pt)
  show figure: align.with(center)
  show figure.caption: pad.with(x: 10%)
  show figure.where(kind: table): it => {
    stack(
      dir: ttb,
      spacing: 0.65em, // Adjust spacing as needed
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
