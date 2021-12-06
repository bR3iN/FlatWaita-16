flatpak-builder = flatpak run org.flatpak.Builder
# flatpak-builder = flatpak-builder

SASSC_OPT = -M -a -t compact

build:
	sassc $(SASSC_OPT) gtk-3.20/gtk.scss gtk-3.20/gtk.css
	sassc $(SASSC_OPT) gnome-shell/gnome-shell.scss gnome-shell/gnome-shell.css

install: install-theme install-flatpak

install-theme: build
	./reset-theme.sh

install-flatpak: build
	$(flatpak-builder) --user --install --force-clean build org.gtk.Gtk3theme.FlatWaita-16.yaml

system-install:
	if [ "$$UID" -eq 0 ]; then \
		mkdir -p /usr/local/share/themes/FlatWaita-16/gtk-3.0; \
		cp -r assets gtk.css /usr/local/share/themes/FlatWaita-16/gtk-3.0/; \
	else \
		echo; \
		echo "Please run 'make system-install' with 'sudo'."; \
	fi

.PHONY: build install install-theme install-flatpak system-install
