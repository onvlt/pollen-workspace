#lang pollen

◊define-meta[title]{Od *slumů* k neformálnímu prostoru v Praze — esej}

# Markdown heading

◊h1{Pollen heading}

Simple paragraph.

This is paragraph with *markdown emphasis*.

This is paragraph with ◊em{pollen emphasis}.

This is paragraph with **markdown strong emphasis**.

This is paragraph with ◊strong{pollen strong emphasis}.

## Markdown heading with *markdown emphasis*

◊h2{Pollen heading with ◊em{pollen emphasis}}

### Markdown heading with ◊em{pollen emphasis}

◊h3{Pollen heading with *markdown emphasis*}

***

Markdown section separator

◊hr{}

Pollen section separator

Bullet list

◊bullet-list{
  ◊(item) Item 1
  ◊(item) Item 2
  ◊(item) Item 3
}

Number list

◊number-list{
  ◊(item) Item 1
  ◊(item) Item 2
  ◊(item) Item 3
}

◊table{
  Model | Pozitivní | Reflexivní

  Metoda | Šetření | Rozšířený případ

  Techniky empirického zkoumání | Rozhovor | Zúčastněné pozorování

  Vztah vědce k "druhým" | Izolace | Participace

  Limity | Účinky kontextu | Účinky moci

  Objektivita | Procedurální | Embedded
}
