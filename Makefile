PO := $(wildcard Mesa-dri-nouveau/Mesa-dri-nouveau.*.po)
POT = Mesa-dri-nouveau/Mesa-dri-nouveau.pot
MASTER = Mesa-dri-nouveau/Mesa-dri-nouveau.en
LICENSES := $(PO:.po=.txt)
VERSION=FIXME
dest=/usr/share/doc/packages/eulas

all: $(LICENSES) $(POT)

clean:
	rm -f $(LICENSES)

install: $(LICENSES)
	mkdir -p $(DESTDIR)$(dest)
	for i in $(notdir $(LICENSES:.txt=)); do cp $(dir $(MASTER))$$i.txt $(DESTDIR)$(dest)/$$i; done
	cp $(MASTER) $(DESTDIR)$(dest)

$(POT): $(MASTER)
	txt2po -P $< $@

%.txt: %.po
	po2txt --progress=none --threshold=100 $< $@
	@if [ -e $@ ]; then sed -i -e"s@#VERSION#@$(VERSION)@g" $@; fi

%.po: $(POT)
	test -e $@ || cp $< $@
	msgmerge -U --previous $@ $< && touch $@

.SUFFIXES = .po .txt
.PHONY: clean install all