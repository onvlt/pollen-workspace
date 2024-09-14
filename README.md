# Pollen workspace

This is my custom setup for [Pollen publishing system](https://docs.racket-lang.org/pollen/index.html). I mainly use Pollen as convenient, extensible markup language and preprocessor for generating nice looking PDF files with [ConTeXt](https://wiki.contextgarden.net/Main_Page), but it can be extended to generate HTML or any other target format.

## Rationale

I have historically used Pandoc to generate PDF files from Markdown. However, [markdown is very limited](https://docs.racket-lang.org/pollen/second-tutorial.html#(part._the-case-against-markdown)) because it's primarily a HTML authoring format and it's hard to extend beyond that. I have later discovered Pollen and thought it's excellent fit, because it can be extended with custom markup. This repository is the setup I have finally settled with.

However, I'm also happy with some aspects of the Markdown notation. This is why implemented a subset of Markdown syntax in Pollen – mostly `# Headings`, `*emphases*` and `**strong emphases**`. I don't aim for complete Markdown compatibility though. My aim is to be able to jot notes in some note-taking app with Markdown support (such as Bear) and then copy-paste that into Pollen.

## Requirements

Racket and ConTeXt have to be installed on the machine.

Template uses [EB Garamond](https://github.com/georgd/EB-Garamond) and [Ysabeau](https://github.com/CatharsisFonts/Ysabeau) fonts. [Adding custom fonts to ConTeXt requires some setup](https://wiki.contextgarden.net/Fonts/Use_the_fonts_you_want).

## Usage

Use `raco pollen render doc.pdf` to render `doc.poly.pm` as PDF. This will generate `doc.ctx` (ConTeXt source file) and then tries to run ConTeXt to compile it to `doc.pdf`. When something goes wrong during ConTeXt compilation phase, we can head to `doc.ctx` to debug potential problems with ConTeXt source file.

Use `raco pollen render doc.ctx` to render ConTeXt source file only.

See `test/test-doc.poly.pm` as reference for custom syntax.

## How it works

Running `pollen render doc.ctx` transforms Pollen markup file to X-expression and parses custom markdown syntax (see `lib/markup.rkt` for reference). Then, in `template.ctx` we run `txexpr->ctx` from `lib/targets/ctx.rkt` to convert this X-expression co TeX markup.

`pollen render doc.pdf` will run `pollen render doc.ctx` on background and then tries to compile ConTeXt source file with ConTeXt executable to PDF.

`template.cxt` is derived from [Pandoc ConTeXt](https://github.com/jgm/pandoc/blob/main/data/templates/default.context) template.
