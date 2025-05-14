FLUTTER = fvm flutter
DART = fvm dart
FASTLANE = bundle exec fastlane

.PHONY: install
install:
	if [ $(GITHUB_ACTIONS) ]; then $(FLUTTER) --version; else fvm install; fi && \
	$(FLUTTER) config --enable-swift-package-manager && \
	$(FLUTTER) pub get && \
	cd ./ios && bundle install && cd .. && \
	cd ./android && bundle install

.PHONY: build
build:
	$(DART) run build_runner build --delete-conflicting-outputs

.PHONY: build-ios
build-ios:
	$(FLUTTER) build ios --release --no-codesign

.PHONY: build-android
build-android:
	$(FLUTTER) build appbundle

.PHONY: deploy-ios-firebase-app-distribution
deploy-ios-firebase-app-distribution:
	$(MAKE) build-ios && \
	cd ./ios && \
	$(FASTLANE) deploy_firebase_app_distribution

.PHONY: deploy-android-firebase-app-distribution
deploy-android-firebase-app-distribution:
	$(MAKE) build-android && \
	cd ./android && \
	$(FASTLANE) deploy_firebase_app_distribution

.PHONY: deploy-ios-testflight
deploy-ios-testflight:
	$(MAKE) build-ios && \
	cd ./ios && \
	$(FASTLANE) deploy_testflight

.PHONY: deploy-android-play-store
deploy-android-play-store:
	$(MAKE) build-android && \
	cd ./android && \
	$(FASTLANE) deploy_play_store

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

.PHONY: match-development
match-development:
	cd ios && $(FASTLANE) match_development_readonly

.PHONY: bump_build
bump_build:
	$(DART) pub global run pub_version_plus:main build

.PHONY: bump_patch
bump_patch:
	$(DART) pub global run pub_version_plus:main patch

.PHONY: bump_minor
bump_minor:
	$(DART) pub global run pub_version_plus:main minor

.PHONY: bump_major
bump_major:
	$(DART) pub global run pub_version_plus:main major
