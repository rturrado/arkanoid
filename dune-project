(lang dune 3.14)
(name arkanoid)
(generate_opam_files true)
(source
    (github rturrado/arkanoid))
(authors "Roberto Turrado Camblor")
(maintainers "Roberto Turrado Camblor")
(license LICENSE)
(documentation https://github.com/rturrado/arkanoid)
(package
    (name arkanoid)
    (synopsis "The Arkanoid game")
    (description "Learning some OCaml by implementing this beautiful arcade game.")
    (depends ocaml dune tsdl)
    (tags ("games")))
; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
