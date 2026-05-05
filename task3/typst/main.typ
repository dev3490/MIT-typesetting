#import "template/conf.typ": conf, intro, conclusion, annexes-start
#show: conf.with(
  title: [Конец эпохи LaTeX и рождение Typst: сравнительный анализ систем вёрстки документов],
  type: "coursework",
  info: (
    author: (
      name: [Иванова Ивана Ивановича],
      faculty: [КНиИТ],
      group: "251",
      sex: "male",
    ),
    inspector: (
      degree: "доцент, к. ф.-м. н.",
      name: "С. В. Миронов",
    ),
  ),
  settings: (
    title_page: (
      enabled: true,
    ),
    contents_page: (
      enabled: true,
    ),
  ),
)

#set ref(supplement: none) // fix of "[n,]" in bibl. refs.
//                                      ^ comma should not be here

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)
#codly(zebra-fill: none)

#let codeblock(filename) = raw(read(filename), block: true, lang: "rust")

#intro
#include "src/01_intro.typ"

= Обзор систем вёрстки документов
#include "src/02_overview.typ"

= Сравнительный анализ
#include "src/03_comparison.typ"

= Примеры программного кода
#include "src/04_examples.typ"

#conclusion
#include "src/05_conclusion.typ"

#bibliography("thesis.yml", style: "gost-r-705-2008-numeric")

#show: annexes-start

= Листинг Rust-программы для измерения времени компиляции <app:rust_benchmark>
#codeblock("assets/code/compile_benchmark.rs")

= Листинг программы на Rust для анализа документа <app:rust_analyzer>
#codeblock("assets/code/doc_analyzer.rs")
