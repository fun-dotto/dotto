.PHONY: install
install:
	fvm flutter config --enable-swift-package-manager
	fvm flutter pub get

.PHONY: build
build:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: build-ios
build-ios:
	fvm flutter build ios

.PHONY: build-android
build-android:
	fvm flutter build android

.PHONY: run
run:
	fvm flutter run

.PHONY: clean
clean:
	fvm flutter clean

.PHONY: test
test:
	fvm flutter test

.PHONY: test-with-coverage
test-with-coverage:
	fvm flutter test --coverage
	lcov --remove coverage/lcov.info 'lib/**.g.dart' -o coverage/new_lcov.info --ignore-errors unused
	genhtml coverage/new_lcov.info -o coverage/html
	open coverage/html/index.html

.PHONY: analyze
analyze:
	fvm flutter analyze
