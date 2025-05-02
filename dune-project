(lang dune 3.14)

(name arkanoid)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Roberto Turrado Camblor")

(maintainers "Roberto Turrado Camblor")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name arkanoid)
 (synopsis "The Arkanoid game")
 (description "Learning some OCaml by implementing this beautiful arcade game.")
 (depends ocaml dune)
 (tags
  (topics "games" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
