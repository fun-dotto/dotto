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
