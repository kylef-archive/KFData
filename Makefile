VERSION := $(shell git describe --tags | tr "-" " " | awk '{print $$1}')
APPLEDOC ?= appledoc
APPLEDOC_OPTS = --output docs \
				--project-company "Kyle Fuller" \
				--company-id "com.kylefuller" \
			   	--project-name KFData \
				--project-version "$(VERSION)" \
				--create-html \
				--no-repeat-first-par \
				--keep-intermediate-files \
				--docset-platform-family iphoneos \
				--docset-atom-filename "KFData.atom" \
				--docset-feed-url "http://kylef.github.com/KFData/%DOCSETATOMFILENAME" \
				--docset-package-url "http://kylef.github.com/KFData/%DOCSETPACKAGEFILENAME" \
				--docset-fallback-url "http://kylef.github.com/KFData/" \
				--publish-docset \
				--verbose 2
XCTOOL := $(shell which xctool)


docs: clean
	$(APPLEDOC) $(APPLEDOC_OPTS) Classes Categories

clean:
	rm -fr docs

test-osx:
	xctool -scheme 'OS X Tests' build -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' build-tests -sdk macosx -configuration Release
	xctool -scheme 'OS X Tests' test -test-sdk macosx -sdk macosx -configuration Release

test-ios:
	xctool -scheme 'iOS Tests' build -sdk iphonesimulator -configuration Release
	xctool -scheme 'iOS Tests' build-tests -sdk iphonesimulator -configuration Release
	xctool -scheme 'iOS Tests' test -test-sdk iphonesimulator -sdk iphonesimulator -configuration Release

test-podspec:
	pod spec lint KFData.podspec

test: test-osx test-ios

gh-pages: docs
	cp -r docs/publish/ docs/html
	ghp-import docs/html

