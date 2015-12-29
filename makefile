test:
	./spec/exec

gh-pages:
	set -o errexit

	git checkout gh-pages # fail&bail if there are uncommitted changes
	git ls-files | xargs rm -rf
	git clone git://github.com/sjltaylor/blobject.git
	mv blobject/doc/* ./
	rm -rf blobject
	git add -A .
	git commit -m 'updated docs with "make docs"'
	git push origin gh-pages:gh-pages
	git checkout master


.PHONY: test gh-pages
