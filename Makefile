all:
	dune build ./src/index.bc.js
	cp _build/default/src/index.bc.js src-other/index.js

run:
	google-chrome http://localhost:8000 # src-other/index.html
	cd src-other && python3 -m http.server
