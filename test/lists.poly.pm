#lang pollen

◊define-meta[title]{Lists}

Simple bullet list

◊bullet-list{
  ◊(item) Item 1
  ◊(item) Item 2
  ◊(item) Item 3
}

Bullet list with multiple paragraphs.

◊bullet-list{
  ◊(item) First paragraph.

  Second paragraph.

  ◊(item) Item 2

  ◊(item) Item 3
}

Bullet list with nested number list.

◊bullet-list{
  ◊(item) Item 1

  ◊number-list{
    ◊(item) Subitem 1
    ◊(item) Subitem 2
    ◊(item) Subitem 3
  }
  ◊(item) Item 2
  ◊(item) Item 3
}

Complex bullet list

◊bullet-list{
  ◊(item) Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi est urna, ultrices sit amet consectetur in, dignissim id nunc. Ut dui mi, facilisis et molestie vel, luctus nec odio.

  Nunc eget ex eget nulla mollis vestibulum vitae in ligula. Nulla tempor enim erat, eget placerat lacus lacinia at. Phasellus bibendum accumsan quam, quis finibus nisi viverra in.

  ◊bullet-list{
    ◊(item) Maecenas sagittis nisl sem, ut lacinia dui semper sollicitudin. Vivamus eget condimentum massa. Nulla facilisi. Aliquam convallis ullamcorper ex nec mollis. Aliquam sit amet egestas elit. Sed iaculis dui at augue scelerisque, et lacinia nulla consequat. Pellentesque a magna sodales, gravida odio nec, rhoncus sem.

    ◊(item) Etiam vitae leo non justo bibendum dapibus. Suspendisse posuere arcu velit, ac malesuada urna iaculis eu. Sed a ultrices erat. Etiam at ex ut erat tristique sodales. Aliquam odio nibh, luctus maximus massa ac, iaculis tincidunt neque. Vivamus vel elementum turpis.
  }

  ◊(item) Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi est urna, ultrices sit amet consectetur in, dignissim id nunc. Ut dui mi, facilisis et molestie vel, luctus nec odio. Nunc eget ex eget nulla mollis vestibulum vitae in ligula. Nulla tempor enim erat, eget placerat lacus lacinia at.

  ◊bullet-list{
    ◊(item) Duis pretium, purus non laoreet tempor
    ◊(item) Quam nulla viverra risus, quis aliquam nulla nunc sed leo
  }

  ◊(item) Ut a condimentum nisi, non ornare magna. Quisque pellentesque interdum arcu, id laoreet elit vulputate ac. Praesent suscipit ut nisi semper lacinia. Donec scelerisque semper varius. Pellentesque non tincidunt erat. Aenean efficitur dapibus diam, ut commodo enim posuere ac.
}
