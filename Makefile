all: tagnavi_custom.config
tagnavi_custom.config: .built.config
	@cp $< $@
	@echo >> $@
	@echo '%root_menu "my_custom_menu"' >> $@
	@echo "Done! Move tagnavi_custom.config to /.rockbox/ on your player"

clean:
	find -name '.built.config' -delete

subdirs := $(shell find $(CURDIR) -maxdepth 1 -type d -not -wholename $(CURDIR) -wholename .git/)
submenu_builds := $(addsuffix /.built.config,$(subdirs))
build_dir ?= $(CURDIR)
export build_dir

.built.config: submenus formats.config $(submenu_builds) menu.config
	@echo '#! rockbox/tagbrowser/2.0' > $(CURDIR)/$@
	@cat $(realpath $^) | ruby $(build_dir)/add_path_filters.rb | sed '/^#/d' >> $(CURDIR)/$@

submenus:
	@$(foreach dir,$(subdirs),cp Makefile $(dir)/ &&) true
	@$(foreach dir,$(subdirs),touch $(dir)/formats.config &&) true
	@$(foreach dir,$(subdirs),$(MAKE) -C $(dir) .built.config &&) true
