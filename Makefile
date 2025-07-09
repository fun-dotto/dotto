FLUTTER = fvm flutter
DART = fvm dart
FASTLANE = bundle exec fastlane

.PHONY: install
install:
	if [ $(GITHUB_ACTIONS) ]; then $(FLUTTER) --version; else fvm install; fi
	$(FLUTTER) config --enable-swift-package-manager
	$(FLUTTER) pub get

.PHONY: bundle-install
bundle-install:
	cd ./ios && bundle install
	cd ./android && bundle install

.PHONY: build
build:
	$(DART) run build_runner build --delete-conflicting-outputs

.PHONY: run
run:
	$(FLUTTER) run --dart-define-from-file=./.env

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

.PHONY: build-ios
build-ios:
	$(FLUTTER) build ios --release --dart-define-from-file=./.env

.PHONY: build-android
build-android:
	$(FLUTTER) build appbundle --release --dart-define-from-file=./.env

.PHONY: deploy-ios-firebase-app-distribution
deploy-ios-firebase-app-distribution:
	cd ./ios && $(FASTLANE) deploy_firebase_app_distribution

.PHONY: deploy-android-firebase-app-distribution
deploy-android-firebase-app-distribution:
	cd ./android && $(FASTLANE) deploy_firebase_app_distribution

.PHONY: deploy-ios-testflight
deploy-ios-testflight:
	cd ./ios && $(FASTLANE) deploy_testflight

.PHONY: deploy-android-google-play
deploy-android-google-play:
	cd ./android && $(FASTLANE) deploy_google_play

.PHONY: match-development
match-development:
	cd ./ios && $(FASTLANE) match_development_readonly

.PHONY: bump-build
bump-build:
	$(DART) pub global activate pub_version_plus
	$(DART) pub global run pub_version_plus:main build

.PHONY: bump-patch
bump-patch:
	$(DART) pub global activate pub_version_plus
	$(DART) pub global run pub_version_plus:main patch --build reset

.PHONY: bump-minor
bump-minor:
	$(DART) pub global activate pub_version_plus
	$(DART) pub global run pub_version_plus:main minor --build reset

.PHONY: bump-major
bump-major:
	$(DART) pub global activate pub_version_plus
	$(DART) pub global run pub_version_plus:main major --build reset

.PHONY: register-ios-device
register-ios-device:
	cd ./ios && $(FASTLANE) run register_device name:$(name) udid:$(udid)
	cd ./ios && $(FASTLANE) match_development
	cd ./ios && $(FASTLANE) match_adhoc
	cd ./ios && $(FASTLANE) match_appstore
