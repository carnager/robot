ifndef PREFIX
  PREFIX=/usr/local
endif

install:
	install -Dm755 robot $(DESTDIR)$(PREFIX)/bin/robot
	install -Dm755 addbmark $(DESTDIR)$(PREFIX)/bin/addbmark
	install -Dm644 config.robot $(DESTDIR)$(PREFIX)/share/doc/robot/config.example
	install -Dm644 config.robot $(DESTDIR)/etc/robot.conf
	install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/robot/README.md
