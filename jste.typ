// jste.typ
// 交通工学研究発表会講演集 Typst テンプレート（書式見本①）
// Japan Society of Traffic Engineers – Conference Proceedings Template

// =====================================================================
// フォント定義
// =====================================================================
#let _serif = (
  "Times New Roman",
  "MS Mincho", // Windows (MS明朝)
  "Hiragino Mincho ProN", // macOS
  "IPAMincho", // Linux
  "Noto Serif CJK JP", // Linux / Google Fonts
)
#let _sans = (
  "Arial",
  "MS Gothic", // Windows (MSゴシック)
  "Hiragino Sans", // macOS
  "IPAGothic", // Linux
  "Noto Sans CJK JP", // Linux / Google Fonts
)

// 数字を全角文字列に変換する関数（章見出し用）
#let _to-fullwidth(n) = {
  let d = ("０", "１", "２", "３", "４", "５", "６", "７", "８", "９")
  str(n).clusters().map(c => d.at(int(c), default: c)).join()
}

// =====================================================================
// 内部ヘルパー
// =====================================================================

// 上付き番号
#let _sup(n) = text(baseline: -0.45em, size: 0.65em)[#n]

// 和文著者リスト整形  例：交通 太郎¹，工学 花子²
#let _fmt-authors-ja(authors) = {
  authors.map(a => a.name + _sup[#a.num]).join("，")
}

// 英文著者リスト整形  例：Taro KOTSU¹, Hanako KOGAKU² and John DOE³
#let _fmt-authors-en(authors) = {
  let n = authors.len()
  let parts = authors.map(a => a.name + _sup[#a.num])
  if n == 1 {
    parts.first()
  } else if n == 2 {
    parts.join(" and ")
  } else {
    parts.slice(0, n - 1).join(", ") + " and " + parts.last()
  }
}

// =====================================================================
// 本文中で使う引用・参照ヘルパー
// =====================================================================

// 補注参照  例：*1  → #jste-note(1)
#let jste-note(n) = _sup[\*#n]

// =====================================================================
// メインテンプレート関数
// =====================================================================
#let jste(
  // 論文題目（和文・英文）
  title-ja: [],
  title-en: [],
  // 著者リスト  例：((name: "交通 太郎", num: 1), ...)
  authors-ja: (),
  authors-en: (),
  // 著者所属  例：("学生会員，修士（工学），東都大学…", ...)
  affiliations: (),
  // 和文概要（300～350字）
  abstract: [],
  // キーワード（最大5つの配列）
  keywords: (),
  // フォント設定（auto = テンプレート既定のフォールバックリストを使用）
  font-serif: auto,
  font-sans: auto,
  // 本文
  body,
) = {
  // フォント解決：auto の場合は既定フォールバックリストを使用
  let serif = if font-serif == auto { _serif } else { font-serif }
  let sans = if font-sans == auto { _sans } else { font-sans }

  // -------------------------------------------------------------------
  // レイアウト定数
  //   font-size : 本文フォントサイズ（仕様：10pt）
  //   leading   : 行間（259mm ÷ 48行 − 10pt ≈ 5.3pt）
  // -------------------------------------------------------------------
  let font-size = 10pt
  // leading: Typst の leading はフォント描画高さ（ascender+descender）と次行の間の余白
  // 実測より font 描画高さ ≈ 6.6pt（font-size=10pt とは異なる）のため、
  // 48行に必要な leading = (259mm÷48) − 6.6pt ≈ 15.3pt − 6.6pt = 8.7pt
  let leading = 8.7pt

  // -------------------------------------------------------------------
  // 著者所属フッターのコンテンツ定義（高さ計算と実描画で共用）
  // -------------------------------------------------------------------
  let affil-grid = {
    set par(first-line-indent: 0pt, leading: leading)
    grid(
      columns: (2em, 1fr),
      row-gutter: leading,
      ..affiliations.enumerate().map(((i, aff)) => (str(i + 1), aff)).flatten()
    )
  }

  // -------------------------------------------------------------------
  // ページ設定（全ページ共通・仕様通り）
  // 著者所属フッターは place(bottom, float: true) でページ1底部に配置するため
  // 全ページで bottom: 19mm の均一マージンを使用できる
  // -------------------------------------------------------------------
  set page(
    paper: "a4",
    margin: (top: 19mm, bottom: 19mm, left: 20mm, right: 20mm),
  )

  // -------------------------------------------------------------------
  // テキスト・段落デフォルト
  // -------------------------------------------------------------------
  // tracking: 列幅 = (170mm − gutter 2em) ÷ 2 = 230.945pt
  // Typst の tracking は文字間隔型（N文字 → N-1 個の隙間）のため：
  //   25 × 10pt + 24 × tracking = 230.945pt → tracking = −0.794pt
  // 余裕を持たせて −0.8pt を採用
  // pt で定義することで first-line-indent との加算が可能になる
  let tracking = -0.8pt
  set text(font: serif, size: font-size, lang: "ja", tracking: tracking)
  set par(
    justify: true,
    // 字下げ幅 = 1文字ピッチ（font-size + tracking）
    // 1em のままだと tracking 分（0.77pt）だけ広くなり、字下げ行が1文字分はみ出す
    first-line-indent: (amount: font-size + tracking, all: true),
    leading: leading,
    spacing: leading,
  )
  show par: set block(breakable: true)

  // -------------------------------------------------------------------
  // 見出し番号付け規則
  //   章 ：１．２．３．…（全角）
  //   節 ：1.1  1.2  1.3 …（半角）
  //   項 ：(1) (2) (3) …
  // -------------------------------------------------------------------
  set heading(numbering: (..nums) => {
    let n = nums.pos()
    if n.len() == 1 {
      _to-fullwidth(n.first()) + "．"
    } else if n.len() == 2 {
      str(n.at(0)) + "." + str(n.at(1))
    } else {
      "(" + str(n.last()) + ")"
    }
  })

  // 見出し
  show heading: it => {
    set par(first-line-indent: 0em)
    set text(font: sans, size: 10pt, weight: "regular")
    if it.numbering != none {
      context counter(heading).display(it.numbering)
    }
    it.body
  }

  // -------------------------------------------------------------------
  // 図表キャプション：サンセリフ体・図は下・表は上
  //   ×図-1  ×写真1  ×図-1：  → ○図1
  // -------------------------------------------------------------------
  show figure.where(kind: image): set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: table): set figure.caption(position: top)
  set figure.caption(separator: box(width: 1em))
  show figure.caption: set text(font: sans)
  // キャプション末尾の par.spacing を除去（figure ブロック外の段落間隔は block.below が担う）
  // show figure.caption: set par(spacing: 0pt)
  // 図表ブロック前後の余白を本文行間と揃える
  // show figure: set block(above: leading, below: leading)

  // -------------------------------------------------------------------
  // 数式：中央揃え・式番号右寄せ
  // -------------------------------------------------------------------
  set math.equation(numbering: "(1)", supplement: "式")

  // 図表参照はサンセリフ体（式参照はセリフ体のまま）
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      text(font: sans)[#it]
    } else {
      it
    }
  }

  // -------------------------------------------------------------------
  // 題目ブロック（1段組み）
  // -------------------------------------------------------------------

  // 論文題目
  align(center)[
    #text(font: sans, size: 12pt)[#title-ja] \
    #text(font: sans, size: 12pt)[#title-en]
  ]

  v(1em)

  // 著者名（和文・英文）
  align(center)[
    #set par(first-line-indent: 0pt)
    #_fmt-authors-ja(authors-ja) \
    #_fmt-authors-en(authors-en)
  ]

  v(1em)

  // 和文概要（左右1cmインデント・両端揃え・段落頭1字下げ）
  {
    // set par(first-line-indent: 1em, justify: true)
    block(width: 100%, inset: (left: 1cm, right: 1cm))[#abstract]
  }

  v(1em)

  // キーワード（左右1cmインデント）
  {
    set par(first-line-indent: 0pt)
    block(width: 100%, inset: (left: 1cm, right: 1cm))[
      #text(style: "italic", weight: "bold")[Keywords: ]
      #h(0.25em)
      #keywords.join("，")
    ]
  }

  v(1em)

  // 著者所属フッター：ページ1底部に float で配置
  // place(bottom, float: true) により本文と重ならず、2ページ目以降は影響なし
  place(bottom, float: true, scope: "parent", clearance: 0.5em, {
    line(length: 100%, stroke: 1pt)
    affil-grid
  })

  // -------------------------------------------------------------------
  // 本文（2段組み）
  // -------------------------------------------------------------------
  columns(2, gutter: 2em)[
    #body
  ]
}
