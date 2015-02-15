Q=@

ifneq ($(VERBOSE),)
	Q=
endif

all: tagnavi_custom.config
tagnavi_custom.config: .built.config
	$(Q)cat $< | ruby -e '$$stdin.each {|l| puts l.sub(/(?<!^)\s*#.*$$/,"")}' > $@
	$(Q)echo >> $@
	$(Q)echo '%root_menu "my_custom_menu"' >> $@
	$(Q)echo "Done! Move tagnavi_custom.config to /.rockbox/ on your player"

clean:
	$(Q)find -name '.built.config' -delete

build_dir ?= $(CURDIR)
export build_dir

subdirs := $(shell find $(CURDIR) -maxdepth 1 -type d -not \( -wholename $(CURDIR) -or -wholename $(build_dir)/.git \))
submenu_builds := $(addsuffix /.built.config,$(subdirs))

.built.config: submenus formats.config $(submenu_builds) .pathfilter menu.config
	$(Q)echo '#! rockbox/tagbrowser/2.0' > $(CURDIR)/$@
	$(Q)cat $(realpath $^) | ruby $(build_dir)/add_path_filters.rb | sed '/^#/d' >> $(CURDIR)/$@

.pathfilter:
	$(Q)echo 'Please run `./generate_path_filters.rb`' && false

submenus:
	$(Q)$(foreach dir,$(subdirs),cp Makefile $(dir)/ &&) true
	$(Q)$(foreach dir,$(subdirs),touch $(dir)/formats.config &&) true
	$(Q)$(foreach dir,$(subdirs),$(MAKE) -C $(dir) .built.config &&) true
