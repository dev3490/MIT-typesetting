#set text(lang: "ru", size: 12pt)

#show smallcaps: set text(font: "New Computer Modern")
// Этот латексный шрифт необходим для работы капители, тк на момент typst 0.14.2 (b33de9de) в Libertinus нет её поддержки для кириллицы.

#set par(
  justify: true,
  first-line-indent: (amount: 1.5em, all: true),
  leading: 0.65em,
  spacing: 0.65em
)

#set page(numbering: "1")

#let noindent = par.with(first-line-indent: 0pt)

#let story(file_name) = {
  v(1em)
  include("stories/" + file_name)
  v(1em)
  align(center)[\* \* \*]
  v(1em)
}

#align(center)[
  #v(2em)
  #text(size: 2em)[Избранные произведения] \
  #v(1.2em)

  #text(size: 1.2em)[ДАНИИЛ ХАРМС] \
  #v(1em)

  #text(size: 1.2em)[4 мая 2026 г.]
  #v(3em)
]

= СУД ЛИНЧА
#story("lynch_law.typ")

= ТЮК!
#story("knock.typ")

= ВЛАС И МИШКА
#story("vlas_and_mishka.typ")

= ЧТО ТЕПЕРЬ ПРОДАЮТ В МАГАЗИНАХ
#story("what_they_sell_in_stores_nowadays.typ")

= МАШКИН УБИЛ КОШКИНА
#story("mashkin_killed_koshkin.typ")
