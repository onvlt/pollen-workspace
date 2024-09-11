#lang racket

(module+ test
  (require rackunit "test-doc.poly.pm")
  (check-equal?
   doc
   '(root
     (h1 "Markdown heading")
     (h1 "Pollen heading")
     (p "Simple paragraph.")
     (p "This is paragraph with " (em "markdown emphasis") ".")
     (p "This is paragraph with " (em "pollen emphasis") ".")
     (p "This is paragraph with " (strong "markdown strong emphasis") ".")
     (p "This is paragraph with " (strong "pollen strong emphasis") ".")
     (h2 "Markdown heading with " (em "markdown emphasis"))
     (h2 "Pollen heading with " (em "pollen emphasis"))
     (h3 "Markdown heading with " (em "pollen emphasis"))
     (h3 "Pollen heading with " (em "markdown emphasis"))
     (hr)
     (p "Markdown section separator")
     (hr)
     (p "Pollen section separator")
     (ul
      (li "Bullet list item 1")
      (li "Bullet list item 2")
      (li "Bullet list item 3"))
     (ol
      (li "Number list item 1")
      (li "Number list item 2")
      (li "Number list item 3"))
     (table
      (row "Model" (col) "Pozitivní" (col) "Reflexivní")
      (row "Metoda" (col) "Šetření" (col) "Rozšířený případ")
      (row "Techniky empirického zkoumání" (col) "Rozhovor" (col) "Zúčastněné pozorování")
      (row "Vztah vědce k \"druhým\"" (col) "Izolace" (col) "Participace")
      (row "Limity" (col) "Účinky kontextu" (col) "Účinky moci")
      (row "Objektivita" (col) "Procedurální" (col) "Embedded")))))
