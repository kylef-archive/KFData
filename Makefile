APPLEDOC ?= appledoc
APPLEDOC_OPTS = --output docs \
				--project-company "Kyle Fuller" \
				--company-id "com.kylefuller.KFData" \
			   	--project-name KFData \
				--project-version "$(git describe --tags)" \
				--create-html \
				--no-create-docset \
				--no-install-docset \
				--keep-intermediate-files \
				--docset-platform-family iphoneos \
				--verbose 2

docs: clean
	$(APPLEDOC) $(APPLEDOC_OPTS) Classes Categories

clean:
	rm -fr docs

