#import "../src/lib.typ": *

#show: template.with(
  language: "en",
  course: [#text(size: 15pt)[English+Title_left+TOC+Single_column]],
  title: [#text(size: 16pt)[Demo for report:] \ #v(-0.8em) Usage of Advanced Utils],
  title_align: "left",
  date: [#datetime.today().display()], // 日期，默认无，datetime.today() 为当前日期
  authors: (
    (
      name: "Author Name",
      id: "0123456789",
      institution: "Major/Class",
      mail: "author@zju.edu.cn",
    ),
  ),
  pagebreak_after_toc: false,
)

虽说这篇文章展示的是英文模板的效果，但是考虑到大部分人还是习惯中文，所以讲解部分还是使用中文。

下面将讲解 `src/util.typ` 文件中设计的专用功能，修改自 #link("https://github.com/memset0/ZJU-Project-Report-Template/blob/master/template.typ")[ZJU-Project-Report-Template] 且已经获得作者许可。

= Codex

在原模板下，代码块没有行号以及代码名；经过修改后支持代码块行号和代码名，使用方式为：

+ 支持匹配类似于 markdown 中代码块

  #codex(read("code/codex.typ"), name: "codex.typ", lang: "typ", line-numbers: false)

  需要注意的是这是使用简单的正则匹配实现的，所以对于反引号和方括号的内容最好与示例保持一致。

+ 支持直接读取代码文件

  #codex(read("code/accumulation.c"), name: "accumulation.c", lang: "c")

不过已知一个 bug 是 typst 至多换行一次，如果代码行太长则可能会向右溢出。

= Blockx & extension

在 #link("https://github.com/memset0/ZJU-Project-Report-Template?tab=readme-ov-file#%E5%9D%97blocks")[ZJU-Project-Report-Template - 块] 展示了 `blockx` 的显示效果，其扩展功能使用了 default 主题，使用方式基本一致，为：

#codex(line-numbers: false)[```typ
  #block-name(name:"")[content]
  ```]

部分示例如下（有 example, proof, abstract, summary, info, note, tip, hint, success, important, help, warning, attention, caution, failure, danger, error, bug, quote, cite, question, option, comment, flag）：

#example(name: "example case")[This is an example block with a name.]

#proof(name: "proof case")[This is a proof block with a name.]

#abstract(name: "abstract case")[This is an abstract block with a name.]

#summary[This is a summary block without a name.]

#tip[This is a tip block without a name.]
