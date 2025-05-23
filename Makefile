FLUTTER = fvm flutter
DART = fvm dart

.PHONY: install
install:
	if [ $(GITHUB_ACTIONS) ]; then $(FLUTTER) --version; else fvm install; fi
	$(FLUTTER) config --enable-swift-package-manager
	$(FLUTTER) pub get

.PHONY: build
build:
	$(DART) run build_runner build --delete-conflicting-outputs

.PHONY: build-ios
build-ios:
	$(FLUTTER) build ios

.PHONY: build-android
build-android:
	$(FLUTTER) build appbundle

.PHONY: run
run:
	$(FLUTTER) run

.PHONY: clean
clean:
	$(FLUTTER) clean

.PHONY: test
test:
	$(FLUTTER) test

.PHONY: test-with-coverage
test-with-coverage:
	$(FLUTTER) test --coverage
	lcov --remove coverage/lcov.info 'lib/**.g.dart' -o coverage/new_lcov.info --ignore-errors unused
	genhtml coverage/new_lcov.info -o coverage/html
	open coverage/html/index.html

.PHONY: analyze
analyze:
	$(FLUTTER) analyze ./lib/ ./test/
