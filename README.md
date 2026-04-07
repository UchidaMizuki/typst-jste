# typst-jste

Unofficial [Typst](https://typst.app/) template for the **Japan Society of Traffic Engineers (JSTE) Conference Proceedings** (交通工学研究発表会講演集).

> **Note:** This is an unofficial template. Always check the [official submission guidelines](https://www.jste.or.jp/) before submitting.

---

## Features

- A4, two-column layout (25 chars × 2 cols × 48 lines per page)
- Automatic heading numbering (１．/ 1.1 / (1) style)
- Floating author affiliation footer on page 1
- Figure and table captions in sans-serif (図 below / 表 above)
- Equation numbering with right-aligned labels
- CSL bibliography style (`jste.csl`) supporting Japanese and English references
- Font fallback lists for Windows, macOS, and Linux

## Requirements

- [Typst](https://typst.app/) 0.12 or later
- Japanese fonts (one of the following sets):
  - **Windows:** MS Mincho / MS Gothic
  - **macOS:** Hiragino Mincho ProN / Hiragino Sans
  - **Linux:** IPAMincho + IPAGothic, or Noto Serif/Sans CJK JP

## Usage

Copy `jste.typ`, `jste.csl`, and `refs.bib` into your project, then create your manuscript:

```typst
#import "jste.typ": *

#show: jste.with(
  title-ja: [論文題目（和文）],
  title-en: [Paper Title (English)],

  authors-ja: (
    (name: "交通 太郎", num: 1),
    (name: "工学 花子", num: 2),
  ),
  authors-en: (
    (name: "Taro KOTSU", num: 1),
    (name: "Hanako KOGAKU", num: 2),
  ),

  affiliations: (
    [正会員，工学博士，○○大学工学部],
    [学生会員，修士（工学），○○大学大学院],
  ),

  abstract: [ここに和文概要を300〜350字で記す。],
  keywords: ("交通安全", "交通管理", "道路計画"),
)

= はじめに

本文をここに記述する。

#bibliography("refs.bib", style: "jste.csl", title: "参考文献")
```

Compile with:

```sh
typst compile main.typ
```

## File Structure

| File | Description |
|---|---|
| `jste.typ` | Template (import this in your manuscript) |
| `jste.csl` | CSL bibliography style |
| `refs.bib` | Sample bibliography entries |
| `main.typ` | Sample manuscript |

## Parameters

| Parameter | Type | Description |
|---|---|---|
| `title-ja` | content | Japanese title |
| `title-en` | content | English title |
| `authors-ja` | array | Japanese author list `(name:, num:)` |
| `authors-en` | array | English author list `(name:, num:)` |
| `affiliations` | array | Author affiliations (indexed from 1) |
| `abstract` | content | Japanese abstract (300–350 characters) |
| `keywords` | array | Keywords (up to 5) |
| `font-serif` | auto \| array | Serif font override (default: OS fallback list) |
| `font-sans` | auto \| array | Sans-serif font override (default: OS fallback list) |

## Bibliography

In-text citations use superscript numbers (e.g., `@wardrop1952` → ¹⁾).

Add entries to `refs.bib` following these conventions:

- **Japanese authors:** wrap names in double braces to prevent name parsing: `{{交通 太郎}}`
- **English authors:** use standard BibTeX `Last, First` format: `{Wardrop, John Glen}`
- **English entries:** add `langid = {english}` to switch to English formatting (comma-separated authors with "and")
- **Page ranges:** use `--` (e.g., `pages = {325--362}`)
- **Web entries:** use `@online` type with `publisher` for the site name and `urldate` in ISO 8601 format

See `refs.bib` for examples of all four reference types (book, book chapter, journal article, webpage).

---

## 日本語ガイド

### 概要

交通工学研究発表会講演集の非公式 Typst テンプレートです。

### 動作要件

- Typst 0.12 以降
- 日本語フォント（Windows: MS明朝/MSゴシック、macOS: ヒラギノ、Linux: IPA/Noto CJK）

### 使い方

`jste.typ`、`jste.csl`、`refs.bib` をプロジェクトにコピーし、上記の Usage セクションを参考に原稿ファイルを作成してください。`main.typ` がサンプル原稿です。

### 参考文献

本文中で `@キー名` と記述すると上付き番号が挿入されます。参考文献リストは以下で自動生成されます：

```typst
#bibliography("refs.bib", style: "jste.csl", title: "参考文献")
```

英文文献には `langid = {english}` を付与することで、著者区切りが `・` から `, and` 形式に切り替わります。

### 免責事項

本テンプレートは非公式です。投稿前に[交通工学研究会の公式投稿規程](https://www.jste.or.jp/)を必ずご確認ください。
