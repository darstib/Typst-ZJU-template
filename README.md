# Typst-ZJU-template

typst template for ZJU, modify from [graceful-genetics](https://github.com/jamesrswift/graceful-genetics).

> Examples and details are coming soon ...

## Get started

```typ
#import "../src/lib.typ": template

#show: template.with(
  article_type: "report",
  title: [Lab title],
  course: text(size: font_size)[course name],
  authors: (
    (
      name: "Darstib",
      id: "xxxxxxxxxx",
      institution: "xxxx",
      mail: "darstib@zju.edu.cn",
    ),
  ),
  columns: 2,
)
```