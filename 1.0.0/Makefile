
#this one must be ahead of EXPAND since FILES will be defined 
DESTROOT = results

define EXPAND

  FILES := $$(filter-out .git,$$(filter-out .svn, $$(filter-out English.lproj, $$(filter-out $(DESTROOT),$$(wildcard $(1)*)))))

  DIRS := 

  $$(foreach e, $$(FILES), $$(if $$(wildcard $$(e)/*), $$(eval DIRS := $$(DIRS) $$(e))))

  FILES := $$(filter-out $$(DIRS),$$(FILES))

  ALLFILES := $$(ALLFILES) $$(FILES)

  $$(foreach e,$$(DIRS),$$(eval $$(call EXPAND,$$(e)/)))

endef

$(eval $(call EXPAND))

XIBS = $(filter %.xib,$(ALLFILES))
STRS = $(filter %.strings,$(ALLFILES))

NIBS = $(subst .xib,.nib,$(XIBS))
LDIRS = $(dir $(XIBS) $(STRS))

DESTDIRS = $(addprefix $(DESTROOT)/, $(LDIRS))


all: $(NIBS) $(STRS)

.PHONY:clean

clean:
	rm -Rf $(DESTROOT) $(NIBS)

%.nib: %.xib $(DESTROOT)
	ibtool --compile "$@" "$<"
	cp $@ $(DESTROOT)/$@

%.strings: $(DESTROOT)
	cp $@ $(DESTROOT)/$@

$(DESTROOT):
	mkdir -p $(DESTDIRS)