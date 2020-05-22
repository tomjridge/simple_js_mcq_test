(lang dune 2.0)
(name test)

;; for opam
(authors              "Tom Ridge <tom.j.ridge@googlemail.com>")
(maintainers          "Tom Ridge <tom.j.ridge@googlemail.com>")
(source               (github tomjridge/test))
(homepage             https://github.com/tomjridge/test)
(documentation        https://tomjridge.github.io/ocamldocs/)
(generate_opam_files  true)


(package 
 (name test)
 (synopsis "test")
 (depends 

  tjr_lib_core
  bos
  js_of_ocaml
  js_of_ocaml-tyxml
  js_of_ocaml-ppx_deriving_json
  js_of_ocaml-ppx
  js_of_ocaml-lwt
  p0_lib
  ppx_blob
]

))

(package 
 (name test_examples)
 (synopsis "test (examples)")
 (depends
test
   ))

