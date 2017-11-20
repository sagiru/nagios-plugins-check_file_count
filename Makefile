#!/usr/bin/make
PLUGIN_VERSION=$(shell grep -i version= ./VERSION | cut -d'=' -f2)
VERSION=$(PLUGIN_VERSION)$(SNAPSHOT)

RELEASE=$(shell grep release -i ./VERSION | cut -d'=' -f2)

PLUGIN=$(shell pwd | cut -d'-' -f3)
PACKAGE=nagios-plugins-$(PLUGIN)

# To use snapshot versions all the time to differ from upstream, set REL=1
REL=1

ifeq ($(REL),)
  SNAPSHOT=.$(shell date +%Y%m%d%H%M%S)
endif

all: $(RELEASE)

$(RELEASE):
	fpm -f \
		--url "https://github.com/sagiru/nagios-plugins-$(PLUGIN)" \
		--vendor Sysfive \
		--description "Check number of files in a directory."\
		-m sascha.girrulat@sysfive.com \
		-v '$(VERSION)' \
		--iteration '$(RELEASE)' \
		-s dir \
		-t rpm \
		--license GPLv3 \
		-n ${PACKAGE} ./usr/lib/nagios/plugins/

rpm: $(RELEASE)

clean:
	rm ./*.rpm

tag:
	git tag -s "release/${PACKAGE}-${VERSION}-${RELEASE}" -m "tagging release/${PACKAGE}-${VERSION}-${RELEASE}"
