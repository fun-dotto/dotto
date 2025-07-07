fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios reset_build_number

```sh
[bundle exec] fastlane ios reset_build_number
```

Reset build number

### ios build_adhoc

```sh
[bundle exec] fastlane ios build_adhoc
```

Build for Ad Hoc

### ios build_appstore

```sh
[bundle exec] fastlane ios build_appstore
```

Build for App Store

### ios deploy_firebase_app_distribution

```sh
[bundle exec] fastlane ios deploy_firebase_app_distribution
```

Deploy to Firebase App Distribution

### ios deploy_testflight

```sh
[bundle exec] fastlane ios deploy_testflight
```

Deploy to TestFlight

### ios match_development

```sh
[bundle exec] fastlane ios match_development
```

Match development

### ios match_adhoc

```sh
[bundle exec] fastlane ios match_adhoc
```

Match adhoc

### ios match_appstore

```sh
[bundle exec] fastlane ios match_appstore
```

Match appstore

### ios match_development_readonly

```sh
[bundle exec] fastlane ios match_development_readonly
```

Match development (readonly)

### ios match_adhoc_readonly

```sh
[bundle exec] fastlane ios match_adhoc_readonly
```

Match adhoc (readonly)

### ios match_appstore_readonly

```sh
[bundle exec] fastlane ios match_appstore_readonly
```

Match appstore (readonly)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
