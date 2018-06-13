test:
	ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)" test.byte && ./test.byte

compile:
	ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)" controller.cmo enemy_ai.cmo player.cmo types.cmo controller.cmi enemy_ai.cmi player.cmi types.cmi gui.cmi gui.cmo

clean:
	ocamlbuild -clean
	rm -rf finalproject.zip

gui:
	ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)" main.js && open index.html

play:
	ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)" main.js && open index.html
