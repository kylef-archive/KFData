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

PROJECT_NAME=KFData
WORKSPACE=$(PROJECT_NAME).xcworkspace
XCODEBUILD=xcodebuild -workspace $(WORKSPACE)


docs: clean
	$(APPLEDOC) $(APPLEDOC_OPTS) Classes Categories

clean:
	rm -fr docs

test-osx:
	@printf "\e[34m=> Running OS X Tests\033[0m\n"
	@$(XCODEBUILD) -scheme 'OS X Tests' test | xcpretty -c | sed "s/^/ /"

test-ios:
	@printf "\e[34m=> Running iOS Tests\033[0m\n"
	@$(XCODEBUILD) -scheme 'iOS Tests' -sdk iphonesimulator test 2>/dev/null | xcpretty -c | sed "s/^/ /"

test-podspec:
	@printf "\e[34m=> Linting podspec\033[0m\n"
	@pod spec lint KFData.podspec | sed "s/^/ /"

test: test-osx test-ios test-podspec

gh-pages: docs
	cp -r docs/publish/ docs/html
	ghp-import docs/html

