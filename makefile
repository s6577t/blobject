test:
	./spec/exec

docs:
	set -o errexit

	git checkout gh-pages # fail&bail if there are uncommitted changes
	git rm -rf ./*
	git clone git://github.com/sjltaylor/blobject.git
	cd blobject
	yard doc
	cd ..
	mv blobject/doc/* ./
	rm -rf blobject
	git add -A .
	git commit -m 'updated docs with "make docs"'
	git push origin gh-pages:gh-pages
	git checkout master


.PHONY: test docs