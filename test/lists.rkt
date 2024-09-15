#lang racket
(require rackunit "lists.poly.pm")

(module+ test
  (check-equal?
   doc
   '(root
     (p "Simple bullet list")
     (ul (li "Item 1") (li "Item 2") (li "Item 3"))
     (p "Bullet list with multiple paragraphs.")
     (ul
      (li (p "First paragraph.") (p "Second paragraph."))
      (li "Item 2")
      (li "Item 3"))
     (p "Bullet list with nested list.")
     (ul
      (li (p "Item 1") (ol (li "Subitem 1") (li "Subitem 2") (li "Subitem 3")))
      (li "Item 2")
      (li "Item 3"))
     (p "Complex bullet list")
     (ul
      (li
       (p
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi est urna, ultrices sit amet consectetur in, dignissim id nunc. Ut dui mi, facilisis et molestie vel, luctus nec odio.")
       (p
        "Nunc eget ex eget nulla mollis vestibulum vitae in ligula. Nulla tempor enim erat, eget placerat lacus lacinia at. Phasellus bibendum accumsan quam, quis finibus nisi viverra in.")
       (ul
        (li
         "Maecenas sagittis nisl sem, ut lacinia dui semper sollicitudin. Vivamus eget condimentum massa. Nulla facilisi. Aliquam convallis ullamcorper ex nec mollis. Aliquam sit amet egestas elit. Sed iaculis dui at augue scelerisque, et lacinia nulla consequat. Pellentesque a magna sodales, gravida odio nec, rhoncus sem.")
        (li
         "Etiam vitae leo non justo bibendum dapibus. Suspendisse posuere arcu velit, ac malesuada urna iaculis eu. Sed a ultrices erat. Etiam at ex ut erat tristique sodales. Aliquam odio nibh, luctus maximus massa ac, iaculis tincidunt neque. Vivamus vel elementum turpis.")))
      (li
       (p
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi est urna, ultrices sit amet consectetur in, dignissim id nunc. Ut dui mi, facilisis et molestie vel, luctus nec odio. Nunc eget ex eget nulla mollis vestibulum vitae in ligula. Nulla tempor enim erat, eget placerat lacus lacinia at.")
       (ul
        (li "Duis pretium, purus non laoreet tempor")
        (li "Quam nulla viverra risus, quis aliquam nulla nunc sed leo")))
      (li
       "Ut a condimentum nisi, non ornare magna. Quisque pellentesque interdum arcu, id laoreet elit vulputate ac. Praesent suscipit ut nisi semper lacinia. Donec scelerisque semper varius. Pellentesque non tincidunt erat. Aenean efficitur dapibus diam, ut commodo enim posuere ac.")))))
