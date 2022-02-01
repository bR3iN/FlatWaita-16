flatpak-builder = flatpak run org.flatpak.Builder
# flatpak-builder = flatpak-builder

SASSC_OPT = -M -a -t compact


build: gtk-3.20/gtk.css gnome-shell/gnome-shell.css

gtk-3.20/gtk.css: base16.scss
	sassc $(SASSC_OPT) gtk-3.20/gtk.scss gtk-3.20/gtk.css
	cat gtk-3.20/patches/* >> gtk-3.20/gtk.css

gnome-shell/gnome-shell.css: base16.scss
	sassc $(SASSC_OPT) gnome-shell/gnome-shell.scss gnome-shell/gnome-shell.css

clean:
	rm gtk-3.20/gtk.css
	rm gnome-shell/gnome-shell.css

all: set-theme install-flatpak

set-theme: build
	./set-theme.sh

install-flatpak: build
	$(flatpak-builder) --user --install --force-clean build org.gtk.Gtk3theme.FlatWaita-16.yaml

system-install:
	@if [ "$$UID" -eq 0 ]; then \
		mkdir -p /usr/share/themes/FlatWaita-16/; \
		cp -r gnome-shell gtk-3.20 /usr/share/themes/FlatWaita-16/; \
	else \
		echo "Please run 'make system-install' with 'sudo'."; \
	fi

.PHONY: clean build all set-theme install-flatpak system-install
