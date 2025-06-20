作为一个文档转换工具，帮我将 markdown 转换为 typst 内容。注意不仅是语法的转换（参见附件 typst_cheatsheet-syntax.pdf），包括一些修改规则:

- 注意快捷符号处理：
	- 一级标题即 `# Top tilte` 在下面的模板中作为 template 的 `title` ；
	- 标题符号 `##` 改为 `=`，`###` 改为 `==`；
	- 粗体符号： `**加粗部分**` 改为 `*加粗部分*` ；
	- 反引号：
		- 使用单反引号包裹的内容依旧使用反引号；
		- 使用三反引号包裹的代码：
			- 对于少于等于 5 行的代码，你应该使用下面的 `codex` 格式的格式 1
			- 对于多于 5 行的代码，我将会把其放入另外的文件内，你应该使用下面的 `codex` 格式 2 进行引用
			- （如果没有指定名称，需要依据代码内容进行推断文件名和扩展名）

```py title="code_cite"
# 格式 1
#codex(lang: "python", name: "code_cite.py", line-numbers: false)[```py
    line1
    line2
    ...
    ```]

# 格式 2
#codex(read("code/code_site.py"), lang: "python", name: "code_cite.py")
```

---

- 在开头引入 typst 包和模板

```typst title="template of zju report"
#import "../../../../template/Typst-ZJU-template/src/lib.typ": template
#import "@preview/tablem:0.2.0": tablem, three-line-table
#import "../../../ZJU-Project-Report-Template/template.typ": codex
#import "../../../../template/typst-algorithms/algo.typ": algo, i, d, comment as comment-algo

#show: template.with(
  article_type: "report",
  title: [Top title],
  course: text(size: 20pt)[Artificial Intelligence security],
  authors: (
    (
      name: "Name",
      id: "323010xxxx",
      institution: "Institution",
      mail: "323010xxxx@zju.edu.cn",
    ),
  ),
  columns: 2,
  language: "zh", // if using chinese, otherwise use "en"
)

```

---

- 注意图片/表格（表格使用 three-line-table 时支持 markdown 的表格形式）的格式处理，**并修改图片引用**（如果有）

```markdown
![Flow of our work](attachments/workflow.png)

如上图所示，……

| *item* | views | likes | downloads | sales | score | follower |
| :----: | :---: | :---: | :---: | :---: | :---: | :---: |
| *info* | 241 | 3.9k | 244 | 624 | 4.9 | 133 |
```

```typst
#[#show figure.caption: set align(center)
  #figure(
    placement: auto,
    scope: "column",
    image("attachments/workflow.png", width: 90%),
    caption: [Flow of our work],
  )<img:workflow>
]

如@img:workflow

#[#show figure.caption: set align(center)
  #figure(
    placement: auto,
    scope: "column",
    three-line-table[
      | *item* | views | likes | downloads | sales | score | follower |
      | :----: | :---: | :---: | :---: | :---: | :---: | :---: |
      | *info* | 241 | 3.9k | 244 | 624 | 4.9 | 133 |
    ],
    caption: [Info of seller],
  )<tbl:seller_info>
]
```

---

- 注意有序/无序列表的处理：

```markdown
1. aaa
2. bbb
3. ...

* aaa
* bbb
* ...
```

```typst
+ aaa
+ bbb
+ ...

- aaa
- bbb
- ...
```

---

- 注意数学公式的转换
	- typst 使用 `$` 周围是否有空格区分公式类型：
		- `$pi$` 表示行内公式，对应于 tex 中 `$\pi$` 
		- `$ pi $` 表示行间公式，对应于 tex 中 `$$\pi$$`
	- typst 的数学符号不依赖于 `\` ，使用空格分隔；对于未定义的变量应该使用 `""` 包裹，例如 `$"Hex"(x)$`，示例如下：

```typst
PGD的工作原理是：在每一次迭代中，它都会沿着损失函数梯度方向更新扰动，然后将更新后的扰动投影回一个由 $epsilon$ 值定义的 L-infinity 范数球内。这个投影操作确保了扰动始终在人眼无法察觉的范围内。

PGD 的迭代公式为：

$ x^(t+1) = Pi_(x+S)(x^t + alpha dot "sgn"(nabla_x L(theta, x^t, y))) $
```

---

- 注意对于脚注的转换

```markdown
正文内容[^fn1]

[^fn1]: 脚注内容
```

```typst
正文内容#footnote[脚注内容]
```
