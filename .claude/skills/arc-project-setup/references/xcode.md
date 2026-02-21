# 🛠️ Xcode Project Configuration

## Overview

ARC Labs maintains standardized Xcode project configurations across all iOS apps to ensure consistency, optimize build performance, and facilitate team collaboration. This document covers project settings, schemes, build configurations, and best practices.

---

## Project Structure

### Recommended Organization
```
FavRes/
├── FavRes.xcodeproj/
├── FavRes/
│   ├── App/
│   │   ├── FavResApp.swift
│   │   └── Info.plist
│   ├── Presentation/
│   │   ├── Features/
│   │   ├── Coordinators/
│   │   └── ViewModels/
│   ├── Domain/
│   │   ├── Entities/
│   │   └── UseCases/
│   ├── Data/
│   │   └── Repositories/
│   ├── Core/
│   │   ├── Extensions/
│   │   └── Utilities/
│   └── Resources/
│       ├── Assets.xcassets
│       ├── Localizable.xcstrings
│       └── Fonts/
├── FavResTests/
│   ├── Presentation/
│   ├── Domain/
│   └── Data/
├── FavResUITests/
└── Packages/
    └── [Local Swift Packages]
```

### Group vs Folder References

**Use Groups** (📁 yellow) for:
- Code organization
- Logical structure
- Virtual hierarchies

**Use Folder References** (📂 blue) for:
- Assets catalogs
- Resource bundles
- Generated files
- Documentation

---

## Build Settings

### General Settings

#### Deployment Info
```
iOS Deployment Target: 17.0
Supported Destinations: iPhone, iPad
Device Orientation:
  - Portrait
  - Landscape Left
  - Landscape Right
Status Bar Style: Default
Requires Full Screen: No (for iPad multitasking)
```

**Rationale**:
- iOS 17.0+ enables modern frameworks (SwiftData, Observation, etc.)
- iPad support expands market reach
- Flexible orientation improves UX

#### App Icons and Launch Screen
```
App Icons Source: Assets.xcassets/AppIcon
Launch Screen: LaunchScreen.swift (SwiftUI)
Accent Color: Assets.xcassets/AccentColor
```

### Build Locations
```
Build Products Path: $(BUILD_DIR)/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
Intermediate Build Files Path: $(PROJECT_TEMP_DIR)
Per-configuration Build Products Path: $(BUILD_DIR)/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
```

### Swift Compiler

#### Language Version
```
Swift Language Version: Swift 6
```

**Benefits**:
- Strict concurrency checking
- Enhanced type safety
- Modern language features
- Better compiler diagnostics

#### Optimization Levels

**Debug**:
```
Swift Optimization Level: No Optimization [-Onone]
Compilation Mode: Incremental
```

**Release**:
```
Swift Optimization Level: Optimize for Speed [-O]
Compilation Mode: Whole Module
```

#### Code Generation
```
Enable Testability: YES (Debug only)
Generate Debug Symbols: YES
Strip Debug Symbols During Copy: YES (Release only)
Strip Swift Symbols: YES (Release only)
```

### Swift Compiler - Custom Flags

#### Debug Configuration
```
Other Swift Flags:
  -Xfrontend -warn-concurrency
  -Xfrontend -enable-actor-data-race-checks
  -strict-concurrency=complete
```

#### Release Configuration
```
Other Swift Flags:
  -strict-concurrency=complete
  -enable-library-evolution
```

### Code Signing

#### Automatic Signing
```
Automatically manage signing: YES
Team: ARC Labs Studio
Bundle Identifier: com.arclabs.favres
Signing Certificate: Apple Development / Distribution
Provisioning Profile: Automatic
```

#### Manual Signing (Production)
```
Automatically manage signing: NO
Team: ARC Labs Studio
Signing Certificate: Apple Distribution
Provisioning Profile: [Specific Profile]
```

### Build Options
```
Enable Bitcode: NO (deprecated)
Debug Information Format: DWARF with dSYM File
Enable Modules (C and Objective-C): YES
Module Verifier: YES
```

### Linking
```
Other Linker Flags:
  -ObjC (if using Objective-C dependencies)
Dead Code Stripping: YES (Release)
Strip Linked Product: YES (Release)
```

---

## Build Configurations

### Standard Configurations

#### Debug

**Purpose**: Local development and testing
```yaml
Configuration: Debug
Optimization: None [-Onone]
Assertions: Enabled
Debug Information: Full
Code Signing: Development
Preprocessing Macros:
  - DEBUG=1
  - ENABLE_LOGGING=1
```

#### Release

**Purpose**: App Store distribution
```yaml
Configuration: Release
Optimization: Speed [-O]
Assertions: Disabled
Debug Information: DWARF with dSYM
Code Signing: Distribution
Preprocessing Macros:
  - RELEASE=1
Strip Debug Symbols: YES
```

### Custom Configurations (Optional)

#### Staging

**Purpose**: Pre-production testing
```yaml
Configuration: Staging
Based on: Release
API Endpoint: staging.arclabs.com
Analytics: Enabled (test mode)
Crash Reporting: Enabled
Preprocessing Macros:
  - STAGING=1
```

#### Beta

**Purpose**: TestFlight distribution
```yaml
Configuration: Beta
Based on: Release
API Endpoint: api.arclabs.com
Analytics: Enabled
Crash Reporting: Enabled
Debug Menu: Enabled
Preprocessing Macros:
  - BETA=1
```

---

## Schemes

### Main App Scheme

#### Build
```
Targets:
  ✓ FavRes (Run, Test, Profile, Analyze, Archive)
  ✓ FavResTests (Test only)
  ✓ FavResUITests (Test only)

Build Options:
  ✓ Parallelize Build
  ✓ Find Implicit Dependencies
```

#### Run
```
Build Configuration: Debug
Executable: FavRes.app
Launch: Automatically
Debug Options:
  ✓ Debug executable
  ✓ GPU Frame Capture: Metal
  ✓ Memory Management: Enable
Options:
  Language: System Language
  Region: System Region
  Application Language: [Your languages]
  Application Region: [Your regions]
```

#### Test
```
Build Configuration: Debug
Test Targets:
  ✓ FavResTests
  ✓ FavResUITests
Options:
  ✓ Code Coverage
  ✓ Gather Coverage for Targets:
    - FavRes
  ✓ Randomize execution order
  ✓ Parallel testing (if supported)
```

#### Profile
```
Build Configuration: Release
Use the Release build configuration: YES
Options:
  ✓ GPU Frame Capture
  ✓ Gather coverage data
```

#### Analyze
```
Build Configuration: Debug
Run static analyzer during build: YES
```

#### Archive
```
Build Configuration: Release
Reveal Archive in Organizer: YES
Post-actions:
  - Export build artifacts
  - Upload dSYMs to crash reporting
```

### Testing Scheme

Dedicated scheme for comprehensive testing:
```
Name: FavRes-Testing
Build Configuration: Debug
Test Plan: AllTests.xctestplan
Code Coverage: Enabled
Environment Variables:
  - IS_TESTING: 1
  - DISABLE_ANIMATIONS: 1
```

---

## Build Phases

### Standard Build Phases Order

1. **Target Dependencies**
2. **Compile Sources**
3. **Link Binary With Libraries**
4. **Copy Bundle Resources**
5. **Embed Frameworks** (if needed)
6. **Run Script Phases** (see below)

### Custom Run Script Phases

#### SwiftLint

**Phase**: Before Compile Sources
```bash
# SwiftLint
if which swiftlint >/dev/null; then
    swiftlint lint --strict
else
    echo "warning: SwiftLint not installed"
fi
```

**Settings**:
- Based on dependency analysis: ✓
- Show environment variables in build log: ✗
- Input Files: (none)
- Output Files: (none)

#### SwiftFormat Check

**Phase**: Before Compile Sources
```bash
# SwiftFormat Check
if which swiftformat >/dev/null; then
    swiftformat --lint . --quiet
else
    echo "warning: SwiftFormat not installed"
fi
```

#### Version Increment (Archive Only)

**Phase**: After Copy Bundle Resources
```bash
# Auto-increment build number
if [ "$CONFIGURATION" == "Release" ]; then
    buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}")
    buildNumber=$(($buildNumber + 1))
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${INFOPLIST_FILE}"
fi
```

**Settings**:
- Run script: Based on dependency analysis ✗
- Show environment variables: ✗
- Input Files:
  - `$(SRCROOT)/$(INFOPLIST_FILE)`
- Output Files:
  - `$(SRCROOT)/$(INFOPLIST_FILE)`

#### Firebase Crashlytics (if used)

**Phase**: After Embed Frameworks
```bash
# Upload dSYM to Crashlytics
"${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
```

**Settings**:
- Input Files:
  - `$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)/Contents/Resources/DWARF/$(TARGET_NAME)`
  - `$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)`

---

## Info.plist Configuration

### Required Keys
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Bundle Information -->
    <key>CFBundleDisplayName</key>
    <string>FavRes</string>
    
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    
    <!-- Supported Platforms -->
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    
    <!-- Launch Screen -->
    <key>UILaunchScreen</key>
    <dict>
        <key>UIImageName</key>
        <string>LaunchImage</string>
    </dict>
    
    <!-- Supported Interface Orientations -->
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <!-- SwiftUI App -->
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        <key>UISceneConfigurations</key>
        <dict/>
    </dict>
</dict>
</plist>
```

### Privacy Keys (Required for Features)
```xml
<!-- Camera Access -->
<key>NSCameraUsageDescription</key>
<string>FavRes needs camera access to scan QR codes and capture restaurant photos.</string>

<!-- Photo Library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>FavRes needs photo library access to save restaurant photos.</string>

<!-- Location Services -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>FavRes needs your location to find nearby restaurants.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>FavRes uses your location to provide personalized restaurant recommendations.</string>

<!-- Contacts (if needed) -->
<key>NSContactsUsageDescription</key>
<string>FavRes needs contacts access to share restaurant recommendations with friends.</string>
```

### App Transport Security
```xml
<!-- Allow HTTP (only for development) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

---

## Asset Catalogs

### App Icon
```
Assets.xcassets/
└── AppIcon.appiconset/
    ├── Contents.json
    ├── icon-1024.png        (1024x1024, App Store)
    ├── icon-20@2x.png       (40x40, iPhone Notification)
    ├── icon-20@3x.png       (60x60, iPhone Notification)
    ├── icon-29@2x.png       (58x58, iPhone Settings)
    ├── icon-29@3x.png       (87x87, iPhone Settings)
    ├── icon-40@2x.png       (80x80, iPhone Spotlight)
    ├── icon-40@3x.png       (120x120, iPhone Spotlight)
    ├── icon-60@2x.png       (120x120, iPhone App)
    └── icon-60@3x.png       (180x180, iPhone App)
```

**Requirements**:
- PNG format
- No alpha channel
- RGB color space
- Single layer (no transparency)

### Color Assets
```
Assets.xcassets/
├── Colors/
│   ├── AccentColor.colorset/
│   ├── Primary.colorset/
│   ├── Secondary.colorset/
│   ├── Background.colorset/
│   └── Surface.colorset/
```

**Configuration** (Contents.json):
```json
{
  "colors": [
    {
      "idiom": "universal",
      "color": {
        "color-space": "srgb",
        "components": {
          "red": "0.000",
          "green": "0.478",
          "blue": "1.000",
          "alpha": "1.000"
        }
      }
    },
    {
      "idiom": "universal",
      "appearances": [
        {
          "appearance": "luminosity",
          "value": "dark"
        }
      ],
      "color": {
        "color-space": "srgb",
        "components": {
          "red": "0.259",
          "green": "0.635",
          "blue": "1.000",
          "alpha": "1.000"
        }
      }
    }
  ]
}
```

### Image Assets
```
Assets.xcassets/
└── Images/
    ├── logo.imageset/
    │   ├── logo.pdf (vector, preferred)
    │   └── Contents.json
    └── restaurant-placeholder.imageset/
        ├── placeholder@1x.png
        ├── placeholder@2x.png
        ├── placeholder@3x.png
        └── Contents.json
```

**Best Practices**:
- Use PDF vectors when possible (single scale, resolution independent)
- Provide @1x, @2x, @3x for raster images
- Optimize PNG files (ImageOptim, TinyPNG)
- Use compression for large images

---

## Localization

### String Catalogs (.xcstrings)

**Modern Approach** (iOS 15+):
```
Resources/
└── Localizable.xcstrings
```

ARC Labs exclusively uses String Catalogs for all localization. Legacy `.strings` files are not permitted.

### Key Naming Convention

**Format**: `[module].[screen].[element].[type]`

Keys use a hierarchical dot notation that provides context about where and how the string is used.

#### Structure Rules

1. **Module/Section**: Top-level feature or domain (auth, onboarding, home, profile, restaurant, settings, common, error)
2. **Screen/Component**: Specific view or component where the string appears
3. **Element**: The UI element or semantic meaning
4. **Type** (optional): Clarifies the element type (button, title, subtitle, placeholder, error, message, label)

#### Examples

**Authentication Flow**:
```swift
"auth.login.email.placeholder" = "Email address"
"auth.login.password.error.invalid" = "Invalid password"
"auth.login.submit.button" = "Sign In"
"auth.signup.terms.message" = "By continuing, you agree to our Terms"
```

**Onboarding**:
```swift
"onboarding.welcome.title" = "Welcome to FavRes"
"onboarding.welcome.subtitle" = "Discover your favorite restaurants"
"onboarding.step1.title" = "Save Your Favorites"
"onboarding.step1.description" = "Keep track of restaurants you love"
"onboarding.permissions.location.title" = "Enable Location"
```

**Home Screen**:
```swift
"home.welcome.message" = "Good morning!"
"home.nearby.section.title" = "Nearby Restaurants"
"home.favorites.empty.message" = "No favorites yet"
"home.search.placeholder" = "Search restaurants..."
```

**Restaurant Detail**:
```swift
"restaurant.detail.reserve.button" = "Reserve Table"
"restaurant.detail.share.action" = "Share"
"restaurant.detail.hours.label" = "Opening Hours"
"restaurant.detail.rating.accessibility" = "Rating: %@ stars"
```

**Profile & Settings**:
```swift
"profile.settings.title" = "Settings"
"profile.edit.save.button" = "Save Changes"
"profile.logout.confirm.title" = "Sign Out?"
"profile.logout.confirm.message" = "Are you sure you want to sign out?"
"settings.notifications.toggle" = "Push Notifications"
"settings.privacy.section.title" = "Privacy"
```

**Common & Errors**:
```swift
"common.ok.button" = "OK"
"common.cancel.button" = "Cancel"
"common.save.button" = "Save"
"common.delete.button" = "Delete"
"common.loading.message" = "Loading..."

"error.network.title" = "Connection Error"
"error.network.message" = "Please check your internet connection"
"error.generic.title" = "Something went wrong"
```

### String Catalog Structure

**Localizable.xcstrings**:
```json
{
  "sourceLanguage": "en",
  "strings": {
    "onboarding.welcome.title": {
      "extractionState": "manual",
      "comment": "Title shown on the first onboarding screen when user opens the app for the first time",
      "localizations": {
        "en": {
          "stringUnit": {
            "state": "translated",
            "value": "Welcome to FavRes"
          }
        },
        "es": {
          "stringUnit": {
            "state": "translated",
            "value": "Bienvenido a FavRes"
          }
        }
      }
    },
    "restaurant.detail.reserve.button": {
      "extractionState": "manual",
      "comment": "Button text to reserve a table at the restaurant",
      "localizations": {
        "en": {
          "stringUnit": {
            "state": "translated",
            "value": "Reserve Table"
          }
        },
        "es": {
          "stringUnit": {
            "state": "translated",
            "value": "Reservar Mesa"
          }
        }
      }
    }
  },
  "version": "1.0"
}
```

### Usage in Code

**SwiftUI**:
```swift
// Direct usage
Text("onboarding.welcome.title")

// With String interpolation
Text("restaurant.detail.rating.accessibility", arguments: [rating])

// With LocalizedStringKey
let key: LocalizedStringKey = "auth.login.submit.button"
Button(key) { /* action */ }
```

**UIKit**:
```swift
// NSLocalizedString
label.text = NSLocalizedString("home.welcome.message", comment: "")

// With Bundle
let text = Bundle.main.localizedString(
    forKey: "error.network.message",
    value: nil,
    table: nil
)
```

### Type-Safe Localization (Recommended)

Use SwiftGen to generate type-safe accessors:

```swift
// Generated by SwiftGen
Text(L10n.Onboarding.Welcome.title)
Button(L10n.Restaurant.Detail.Reserve.button) { /* action */ }
```

**SwiftGen Configuration** (swiftgen.yml):
```yaml
strings:
  inputs: FavRes/Resources/Localizable.xcstrings
  outputs:
    - templateName: structured-swift5
      output: FavRes/Generated/Strings.swift
```

### Best Practices

#### Do ✅

- Use hierarchical dot notation
- Keep keys consistent across the app
- Add descriptive comments for context
- Use semantic names (describe purpose, not content)
- Group related strings by feature/module
- Include the element type when ambiguous
- Use `common.` prefix for reusable strings
- Leverage SwiftGen for type safety

#### Don't ❌

- Don't use literal content as keys: ~~`"Welcome to FavRes"`~~
- Don't mix context with content: ~~`"welcome_app_favres"`~~
- Don't be too generic: ~~`"message"`~~ or ~~`"title"`~~
- Don't use underscores: ~~`"auth_login_button"`~~ (use dots)
- Don't include the app name in keys
- Don't repeat the same string with different keys (use `common.`)
- Don't skip comments—context helps translators

### Pluralization

String Catalogs support native pluralization:

```json
{
  "restaurant.list.count": {
    "localizations": {
      "en": {
        "variations": {
          "plural": {
            "zero": {
              "stringUnit": {
                "state": "translated",
                "value": "No restaurants"
              }
            },
            "one": {
              "stringUnit": {
                "state": "translated",
                "value": "%lld restaurant"
              }
            },
            "other": {
              "stringUnit": {
                "state": "translated",
                "value": "%lld restaurants"
              }
            }
          }
        }
      }
    }
  }
}
```

**Usage**:
```swift
Text("restaurant.list.count", arguments: [count])
```

### Supported Languages
```
Project Settings → Info → Localizations
  ✓ English (Development Language)
  ✓ Spanish
  ✓ French (optional)
```

### Migration from .strings files

If migrating from legacy `.strings` files:

1. **Xcode → Editor → Export for Localization**
2. **Import to String Catalog**
3. **Refactor keys** to follow new convention
4. **Add comments** for translator context
5. **Delete** old `.strings` files
6. **Update code** to use new keys

---

## Capabilities

### Required Capabilities

Enable in Target → Signing & Capabilities:

#### iCloud
```
Capabilities:
  ✓ iCloud
    ✓ CloudKit
    ✓ Key-value storage

Containers:
  - iCloud.com.arclabs.favres
```

#### Push Notifications
```
Capabilities:
  ✓ Push Notifications
    ✓ Remote notifications background mode
```

#### Background Modes
```
Capabilities:
  ✓ Background Modes
    ✓ Background fetch
    ✓ Remote notifications
```

### Optional Capabilities

#### App Groups (for extensions)
```
Capabilities:
  ✓ App Groups
    ✓ group.com.arclabs.favres
```

#### Sign in with Apple
```
Capabilities:
  ✓ Sign In with Apple
```

---

## Swift Packages

### Package Dependencies
```
Project → Package Dependencies:
  ✓ ARCDesignSystem (1.0.0)
  ✓ ARCLogger (1.2.0)
  ✓ ARCStorage (1.4.0)
  ✓ ARCNetworking (1.1.0)
  ✓ ARCNavigation (1.1.0)
  ✓ ARCUIComponents (1.0.0)
  ✓ ARCIntelligence (1.0.0)
  ✓ ARCMaps (1.0.0)
  ✓ ARCDevTools (1.0.0) [Development only]
```

### Local Packages

For rapid development:
```
FavRes/
└── Packages/
    └── LocalFeature/
        ├── Package.swift
        └── Sources/
```

**Add to Project**:
1. File → Add Package Dependencies
2. Add Local...
3. Select Packages/LocalFeature

---

## Build Performance

### Optimization Tips

#### Reduce Build Times
```yaml
Build Settings:
  # Parallelize builds
  PARALLEL_BUILD: YES
  
  # Disable index-while-building for faster builds
  COMPILER_INDEX_STORE_ENABLE: NO (Debug only)
  
  # Whole module optimization only for Release
  SWIFT_OPTIMIZATION_LEVEL: -Onone (Debug)
  SWIFT_OPTIMIZATION_LEVEL: -O (Release)
  
  # Incremental builds
  SWIFT_COMPILATION_MODE: Incremental (Debug)
  SWIFT_COMPILATION_MODE: wholemodule (Release)
```

#### Clean Build Folder

Regular cleanup:
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Reset package caches
rm -rf ~/Library/Caches/org.swift.swiftpm
```

#### Module Caching
```yaml
Build Settings:
  SWIFT_ENABLE_INCREMENTAL_COMPILATION: YES
  SWIFT_MODULE_CACHING: YES
```

---

## Debugging Configuration

### Environment Variables

Add to Scheme → Run → Arguments → Environment Variables:
```
Name: ENABLE_LOGGING
Value: 1

Name: DEBUG_NETWORK
Value: 1

Name: ANIMATIONS_DISABLED
Value: 1 (for UI testing)
```

### Launch Arguments

Add to Scheme → Run → Arguments → Arguments Passed On Launch:
```
-com.apple.CoreData.SQLDebug 1
-com.apple.CoreData.CloudKitDebug 1
```

### Memory Diagnostics

Enable in Scheme → Run → Diagnostics:
```
Memory Management:
  ✓ Malloc Stack
  ✓ Malloc Guard Edges
  ✓ Guard Malloc
  ✓ Zombie Objects

Logging:
  ✓ API Misuse
  ✓ Main Thread Checker
  ✓ Thread Sanitizer (when needed)
```

---

## Distribution

### Archive for App Store

1. **Product → Archive**
2. **Organizer → Distribute App**
3. **App Store Connect**
4. **Upload** (or Export for manual upload)

### Export Options
```xml
<!-- ExportOptions.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>manageAppVersionAndBuildNumber</key>
    <false/>
</dict>
</plist>
```

### Command Line Archive
```bash
#!/bin/bash
# archive.sh

# Archive
xcodebuild archive \
  -scheme FavRes \
  -configuration Release \
  -archivePath ./build/FavRes.xcarchive

# Export
xcodebuild -exportArchive \
  -archivePath ./build/FavRes.xcarchive \
  -exportPath ./build/FavRes.ipa \
  -exportOptionsPlist ExportOptions.plist
```

---

## Best Practices

### Do ✅

- Use Swift 6 language mode
- Enable strict concurrency checking
- Maintain consistent build settings across targets
- Use build configurations for different environments
- Enable code coverage for tests
- Optimize build performance
- Keep Info.plist organized
- Use asset catalogs for all images
- Localize from day one
- Version control Xcode project files
- Document custom build phases
- Use schemes for different workflows

### Don't ❌

- Hardcode values in build settings
- Commit user-specific schemes
- Disable warnings globally
- Skip code signing setup
- Ignore build warnings
- Use legacy .strings files (use String Catalogs .xcstrings)
- Use underscores in localization keys (use dot notation)
- Commit derived data
- Modify project files manually (use Xcode)
- Skip privacy descriptions
- Forget to update version numbers

---

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean build folder
⌘ + Shift + K

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Reset package caches
File → Packages → Reset Package Caches
```

#### Code Signing Issues
```bash
# List available identities
security find-identity -v -p codesigning

# Verify provisioning profiles
~/Library/MobileDevice/Provisioning\ Profiles/

# Re-download profiles
Xcode → Settings → Accounts → Download Manual Profiles
```

#### Swift Package Issues
```bash
# Update packages
File → Packages → Update to Latest Package Versions

# Resolve package versions
File → Packages → Resolve Package Versions

# Reset package caches
File → Packages → Reset Package Caches
```

---

## Xcode Keyboard Shortcuts

### Essential Shortcuts
```
Build: ⌘ + B
Run: ⌘ + R
Test: ⌘ + U
Clean: ⌘ + Shift + K
Build Folder: ⌘ + Shift + Option + K

Quick Open: ⌘ + Shift + O
Jump to Definition: ⌘ + Click
Find in Workspace: ⌘ + Shift + F
Show/Hide Navigator: ⌘ + 0
Show/Hide Utilities: ⌘ + Option + 0

Comment/Uncomment: ⌘ + /
Re-indent: Ctrl + I
Format Document: ⌘ + A, Ctrl + I
```

---

## Resources

- [Xcode Help](https://developer.apple.com/documentation/xcode)
- [Build Settings Reference](https://xcodebuildsettings.com/)
- [App Distribution Guide](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Swift Package Manager](https://swift.org/package-manager/)

---

## Summary

Proper Xcode project configuration is fundamental to efficient development at ARC Labs. By maintaining standardized settings, utilizing modern features like Swift 6 and string catalogs, and automating quality checks through build phases, we ensure that every project starts on solid ground and scales gracefully. Xcode is our primary development environment—master it, configure it correctly, and it becomes a powerful ally in building exceptional iOS apps.