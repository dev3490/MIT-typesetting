#import "@preview/equate:0.3.2": equate

#set text(lang: "ru", size: 12pt, hyphenate: true)
#set page(
  "us-letter",
  margin: 2cm,
  header-ascent: 0.2cm,
  footer-descent: 0.6cm,
  numbering: "1"
)

#show heading: set block(below: 1em)
#set par(justify: true, first-line-indent: (amount: 1.5em, all: true))

#show: equate.with(sub-numbering: false)
#set math.equation(numbering: "(1)")

#let noindent = par.with(first-line-indent: 0pt)

= Вариант 21

Зная зависимости изменения плотности газа при нагнетании, мы можем рассчитать производительность компрессора как расход газа через третью ступень компрессора:

$ G(t) = lambda_3 V_(Pi 3) n rho_3 (t) $

#noindent[где $rho_3 (t)$~--- известная зависимость плотности газа от времени на 3-й ступени компрессора.]

Теперь мы можем рассчитать потребление электроэнергии компрессором:

$ N(t) &= G(t) R k / (k - 1) sum^2_(j = 1) (theta.alt_(H j)(t) - theta.alt_0) + Delta N, \

Delta N &=
    (G(t) * R * T_1 * delta P_1) /
    ((V_(Pi 1)) / (V_(Pi 2)) P_"ATM") +

    (G(t) R T_2 delta P_2) /
    (((V_(Pi 1)) / (V_(Pi 2)) P_"ATM" - delta P_1) (V_(Pi 2)) / (V_(Pi 3)))
$

#noindent[где $G(t)$~--- искомая производительность компрессора; $Delta N$ ~--- потери мощности в промежуточных газоохладителях; $R$ ~--- газовая постоянная; $T_1$, $T_2$ ~--- среднее арифметическое температур воды и воздуха в воздухоохладителях; $delta P_1$, $delta P_2$ ~--- потери давления воздуха в воздухоохладителях; $P_"ATM"$ — атмосферное давление.]
