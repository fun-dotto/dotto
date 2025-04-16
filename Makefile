.PHONY: install
install:
	flutter pub get

.PHONY: build
build:
	flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: run
run:
	flutter run

.PHONY: clean
clean:
	flutter clean

.PHONY: test
test:
	flutter test

.PHONY: test-with-coverage
test:
	flutter test --coverage
	lcov --remove coverage/lcov.info 'lib/**.g.dart' -o coverage/new_lcov.info --ignore-errors unused
	genhtml coverage/new_lcov.info -o coverage/html
	open coverage/html/index.html

.PHONY: analyze
analyze:
	flutter analyze
