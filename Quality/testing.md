# 🧪 Testing with Swift Testing

**Comprehensive testing ensures code quality, prevents regressions, and enables confident refactoring. ARC Labs uses Swift Testing for all test suites.**

---

## 🎯 Testing Philosophy

### Core Principles

1. **Tests are documentation** - They show how code should be used
2. **Tests enable refactoring** - Change implementation with confidence
3. **Tests catch regressions** - Prevent fixed bugs from returning
4. **Tests drive design** - Hard-to-test code is poorly designed code

### Coverage Requirements

| Project Type | Minimum Coverage | Target |
|--------------|-----------------|--------|
| **Swift Packages** | 80% | 100% |
| **iOS Apps** | 60% | 80% |

### What to Test

✅ **ALWAYS Test**:
- ViewModels (state management, business logic coordination)
- Use Cases (business logic, validation, edge cases)
- Repositories (data access, caching, error handling)
- Entities (validation, computed properties)
- Utilities (formatters, validators, extensions)

❌ **DON'T Test** (for now):
- SwiftUI Views (UI testing deferred)
- View-to-ViewModel integration (deferred)
- Navigation flows (deferred)
- Third-party code

---

## 🧪 Swift Testing Framework

### Why Swift Testing?

- **Native Swift** - First-party from Apple
- **Modern syntax** - Uses macros and structured concurrency
- **Descriptive** - Clear test organization and naming
- **Parameterized** - Easy to test multiple scenarios
- **Async-first** - Built for async/await from the ground up

### Basic Structure

```swift
import Testing
@testable import YourModule

@Suite("User Profile Tests")
struct UserProfileTests {
    
    @Test("Loading user updates state")
    func loadingUserUpdatesState() async throws {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeResult = .success(.mock)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        await viewModel.loadUser()
        
        // Assert
        #expect(viewModel.user != nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Loading user with error shows error message")
    func loadingUserWithErrorShowsErrorMessage() async throws {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeResult = .failure(TestError.networkError)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        await viewModel.loadUser()
        
        // Assert
        #expect(viewModel.user == nil)
        #expect(viewModel.errorMessage != nil)
    }
}
```

---

## 🏗️ Testing Layers

### 1. Testing Entities (Domain Layer)

**Purpose**: Verify business rules and validation

```swift
import Testing
@testable import FavRes

@Suite("User Entity Tests")
struct UserTests {
    
    @Test("Valid user passes validation")
    func validUserPassesValidation() {
        // Arrange
        let user = User(
            id: UUID(),
            email: "test@example.com",
            name: "John Doe",
            avatarURL: nil,
            createdAt: Date()
        )
        
        // Assert
        #expect(user.isValid == true)
    }
    
    @Test("User with empty email fails validation")
    func userWithEmptyEmailFailsValidation() {
        // Arrange
        let user = User(
            id: UUID(),
            email: "",
            name: "John Doe",
            avatarURL: nil,
            createdAt: Date()
        )
        
        // Assert
        #expect(user.isValid == false)
    }
    
    @Test("Display name returns formatted name")
    func displayNameReturnsFormattedName() {
        // Arrange
        let user = User(
            id: UUID(),
            email: "test@example.com",
            name: "John Doe",
            avatarURL: nil,
            createdAt: Date()
        )
        
        // Act
        let displayName = user.displayName
        
        // Assert
        #expect(displayName == "John Doe")
    }
}
```

---

### 2. Testing Use Cases (Domain Layer)

**Purpose**: Verify business logic and workflows

```swift
import Testing
@testable import FavRes

@Suite("Get User Profile Use Case Tests")
struct GetUserProfileUseCaseTests {
    
    @Test("Execute with valid user ID returns user")
    func execute_withValidUserIdReturnsUser() async throws {
        // Arrange
        let mockRepository = MockUserRepository()
        let expectedUser = User.mock
        mockRepository.getUserResult = .success(expectedUser)
        
        let useCase = GetUserProfileUseCase(userRepository: mockRepository)
        
        // Act
        let user = try await useCase.execute(userId: expectedUser.id)
        
        // Assert
        #expect(user == expectedUser)
        #expect(mockRepository.getUserCalled == true)
    }
    
    @Test("Execute with invalid user ID throws error")
    func execute_withInvalidUserIdThrowsError() async throws {
        // Arrange
        let mockRepository = MockUserRepository()
        let useCase = GetUserProfileUseCase(userRepository: mockRepository)
        let invalidId = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        
        // Act & Assert
        await #expect(throws: DomainError.invalidUserId) {
            try await useCase.execute(userId: invalidId)
        }
    }
    
    @Test("Execute with inactive user throws error")
    func execute_withInactiveUserThrowsError() async throws {
        // Arrange
        let mockRepository = MockUserRepository()
        var inactiveUser = User.mock
        inactiveUser.isActive = false
        mockRepository.getUserResult = .success(inactiveUser)
        
        let useCase = GetUserProfileUseCase(userRepository: mockRepository)
        
        // Act & Assert
        await #expect(throws: DomainError.userInactive) {
            try await useCase.execute(userId: inactiveUser.id)
        }
    }
    
    @Test("Execute calls repository with correct ID")
    func execute_callsRepositoryWithCorrectId() async throws {
        // Arrange
        let mockRepository = MockUserRepository()
        mockRepository.getUserResult = .success(.mock)
        let useCase = GetUserProfileUseCase(userRepository: mockRepository)
        let userId = UUID()
        
        // Act
        _ = try await useCase.execute(userId: userId)
        
        // Assert
        #expect(mockRepository.lastUserId == userId)
    }
}
```

---

### 3. Testing Repositories (Data Layer)

**Purpose**: Verify data access, caching, and error handling

```swift
import Testing
@testable import FavRes

@Suite("User Repository Tests")
struct UserRepositoryTests {
    
    @Test("Get user with cached data returns cached user without network call")
    func getUser_withCachedDataReturnsCachedUser() async throws {
        // Arrange
        let mockRemote = MockUserRemoteDataSource()
        let mockLocal = MockUserLocalDataSource()
        let cachedUser = UserDTO.mock
        mockLocal.getUserResult = .success(cachedUser)
        
        let repository = UserRepositoryImpl(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        // Act
        let user = try await repository.getUser(by: UUID(uuidString: cachedUser.id)!)
        
        // Assert
        #expect(mockLocal.getUserCalled == true)
        #expect(mockRemote.fetchUserCalled == false)  // Should NOT call remote
        #expect(user.id.uuidString == cachedUser.id)
    }
    
    @Test("Get user without cache fetches from remote and caches")
    func getUser_withoutCacheFetchesFromRemoteAndCaches() async throws {
        // Arrange
        let mockRemote = MockUserRemoteDataSource()
        let mockLocal = MockUserLocalDataSource()
        let remoteUser = UserDTO.mock
        mockRemote.fetchUserResult = .success(remoteUser)
        mockLocal.getUserResult = .failure(CacheError.notFound)
        
        let repository = UserRepositoryImpl(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        
        // Act
        let user = try await repository.getUser(by: UUID(uuidString: remoteUser.id)!)
        
        // Assert
        #expect(mockRemote.fetchUserCalled == true)
        #expect(mockLocal.saveUserCalled == true)
        #expect(user.id.uuidString == remoteUser.id)
    }
    
    @Test("Save user updates both remote and local")
    func saveUser_updatesBothRemoteAndLocal() async throws {
        // Arrange
        let mockRemote = MockUserRemoteDataSource()
        let mockLocal = MockUserLocalDataSource()
        let repository = UserRepositoryImpl(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        let user = User.mock
        
        // Act
        try await repository.saveUser(user)
        
        // Assert
        #expect(mockRemote.updateUserCalled == true)
        #expect(mockLocal.saveUserCalled == true)
    }
    
    @Test("Delete user removes from both remote and local")
    func deleteUser_removesFromBothRemoteAndLocal() async throws {
        // Arrange
        let mockRemote = MockUserRemoteDataSource()
        let mockLocal = MockUserLocalDataSource()
        let repository = UserRepositoryImpl(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )
        let userId = UUID()
        
        // Act
        try await repository.deleteUser(by: userId)
        
        // Assert
        #expect(mockRemote.deleteUserCalled == true)
        #expect(mockLocal.deleteUserCalled == true)
    }
}
```

---

### 4. Testing ViewModels (Presentation Layer)

**Purpose**: Verify UI state management and coordination

```swift
import Testing
@testable import FavRes

@Suite("User Profile ViewModel Tests")
@MainActor
struct UserProfileViewModelTests {
    
    @Test("Initial state is correct")
    func initialStateIsCorrect() {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Assert
        #expect(viewModel.user == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Load user sets loading state")
    func loadUser_setsLoadingState() async {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeDelay = 1.0  // Slow response
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        Task {
            await viewModel.loadUser()
        }
        
        // Wait a bit
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert (while loading)
        #expect(viewModel.isLoading == true)
    }
    
    @Test("Load user with success updates user and clears loading")
    func loadUser_withSuccessUpdatesUserAndClearsLoading() async {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        let expectedUser = User.mock
        mockUseCase.executeResult = .success(expectedUser)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        await viewModel.loadUser()
        
        // Assert
        #expect(viewModel.user == expectedUser)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Load user with error shows error message")
    func loadUser_withErrorShowsErrorMessage() async {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeResult = .failure(TestError.networkError)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        await viewModel.loadUser()
        
        // Assert
        #expect(viewModel.user == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test("Multiple load calls don't cause issues")
    func multipleLoadCallsDontCauseIssues() async {
        // Arrange
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeResult = .success(.mock)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)
        
        // Act
        await viewModel.loadUser()
        await viewModel.loadUser()
        await viewModel.loadUser()
        
        // Assert
        #expect(viewModel.user != nil)
        #expect(viewModel.isLoading == false)
    }
}
```

---

## 🎭 Mock Objects

### Creating Effective Mocks

```swift
// MARK: - Mock Repository

final class MockUserRepository: UserRepositoryProtocol {
    // Track calls
    var getUserCalled = false
    var saveUserCalled = false
    var deleteUserCalled = false
    
    // Track parameters
    var lastUserId: UUID?
    var lastSavedUser: User?
    
    // Configure results
    var getUserResult: Result<User, Error> = .failure(TestError.notConfigured)
    var saveUserResult: Result<Void, Error> = .success(())
    var deleteUserResult: Result<Void, Error> = .success(())
    
    // Add delay for testing loading states
    var getUserDelay: TimeInterval = 0
    
    func getUser(by id: UUID) async throws -> User {
        getUserCalled = true
        lastUserId = id
        
        if getUserDelay > 0 {
            try await Task.sleep(for: .seconds(getUserDelay))
        }
        
        return try getUserResult.get()
    }
    
    func saveUser(_ user: User) async throws {
        saveUserCalled = true
        lastSavedUser = user
        try saveUserResult.get()
    }
    
    func deleteUser(by id: UUID) async throws {
        deleteUserCalled = true
        lastUserId = id
        try deleteUserResult.get()
    }
    
    func reset() {
        getUserCalled = false
        saveUserCalled = false
        deleteUserCalled = false
        lastUserId = nil
        lastSavedUser = nil
    }
}
```

### Mock Best Practices

✅ **DO**:
- Track method calls (`getCalled = true`)
- Store method parameters for verification
- Allow configurable results
- Provide `reset()` method
- Support delay simulation for loading states

❌ **DON'T**:
- Include real logic in mocks
- Make mocks complex
- Reuse mocks across unrelated tests
- Forget to reset state between tests

---

## 📊 Parameterized Tests

Test multiple scenarios efficiently:

```swift
import Testing
@testable import FavRes

@Suite("Email Validation Tests")
struct EmailValidationTests {
    
    @Test("Valid emails pass validation", arguments: [
        "test@example.com",
        "user.name@example.co.uk",
        "first+last@example.org",
        "valid_email@sub.domain.com"
    ])
    func validEmailsPassValidation(email: String) {
        // Arrange
        let validator = EmailValidator()
        
        // Act
        let result = validator.validate(email)
        
        // Assert
        #expect(result.isValid == true)
    }
    
    @Test("Invalid emails fail validation", arguments: [
        "not-an-email",
        "@example.com",
        "user@",
        "user @example.com",
        ""
    ])
    func invalidEmailsFailValidation(email: String) {
        // Arrange
        let validator = EmailValidator()
        
        // Act
        let result = validator.validate(email)
        
        // Assert
        #expect(result.isValid == false)
    }
}
```

---

## 🔧 Test Helpers & Utilities

### Mock Data Factories

```swift
extension User {
    static var mock: User {
        User(
            id: UUID(uuidString: "12345678-1234-1234-1234-123456789012")!,
            email: "test@example.com",
            name: "Test User",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(timeIntervalSince1970: 1700000000)
        )
    }
    
    static func mock(
        id: UUID = UUID(),
        email: String = "test@example.com",
        name: String = "Test User"
    ) -> User {
        User(
            id: id,
            email: email,
            name: name,
            avatarURL: nil,
            createdAt: Date()
        )
    }
}
```

### Test Errors

```swift
enum TestError: Error {
    case notConfigured
    case networkError
    case invalidType
    case notFound
}
```

### Test Assertions

```swift
// Testing async throws
await #expect(throws: DomainError.userInactive) {
    try await useCase.execute(userId: userId)
}

// Testing specific error type
await #expect(throws: (any Error).self) {
    try await repository.getUser(by: invalidId)
}

// Testing value equality
#expect(viewModel.user == expectedUser)

// Testing optional
#expect(viewModel.user != nil)
#expect(viewModel.errorMessage == nil)

// Testing booleans
#expect(viewModel.isLoading == false)

// Testing collections
#expect(viewModel.users.isEmpty == false)
#expect(viewModel.users.count == 5)
```

---

## 📋 Testing Checklist

Before considering a feature complete:

### Coverage
- [ ] All ViewModels tested (state transitions, error handling)
- [ ] All Use Cases tested (business logic, validation, edge cases)
- [ ] All Repositories tested (data access, caching, errors)
- [ ] All Entities tested (validation, computed properties)
- [ ] Coverage meets requirements (80% packages, 60% apps)

### Quality
- [ ] Tests are independent (no shared state)
- [ ] Tests are deterministic (same result every time)
- [ ] Tests are fast (no real network calls, no sleep unless testing delays)
- [ ] Tests have clear names (describe what and why)
- [ ] Tests follow Arrange-Act-Assert pattern

### Mocks
- [ ] Mocks track method calls
- [ ] Mocks store parameters for verification
- [ ] Mocks allow configurable results
- [ ] Mocks are simple and focused

---

## 🎯 Testing Strategies

### Test Pyramid

```
        /\
       /UI\       ← Few (deferred for now)
      /────\
     /Integr\     ← Some (deferred for now)
    /────────\
   /   Unit   \   ← Many (focus here!)
  /────────────\
```

**Current Focus**: Unit tests for maximum coverage

### What to Test First (Priority)

1. **Use Cases** - Core business logic
2. **Repositories** - Data access patterns
3. **ViewModels** - UI state management
4. **Entities** - Business rules and validation
5. **Utilities** - Helpers and extensions

---

## 📱 Testing iOS Apps with xcodebuild

### Overview

iOS apps use `xcodebuild` instead of `swift test` for running tests. This section covers the differences and CI configuration.

### xcodebuild vs swift test

| Aspect | `swift test` (Packages) | `xcodebuild test` (iOS Apps) |
|--------|------------------------|------------------------------|
| Project Type | Swift Package | Xcode Project/Workspace |
| Platform | macOS, Linux | iOS Simulator (macOS host) |
| Configuration | `Package.swift` | `.xcodeproj` + Scheme |
| Parallel Execution | `--parallel` flag | Built-in (per scheme settings) |
| Coverage | `--enable-code-coverage` | `-enableCodeCoverage YES` |
| Output Format | Console | Console + `.xcresult` bundle |

### Running Tests Locally

```bash
# Basic test command
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16"

# With code coverage
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -enableCodeCoverage YES

# Save results to bundle
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -resultBundlePath TestResults.xcresult

# Skip code signing (required for CI)
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  CODE_SIGNING_ALLOWED=NO
```

### Simulator Configuration

#### Finding Available Simulators

```bash
# List all available destinations for a scheme
xcodebuild -scheme "YourApp" -showdestinations

# List all simulators
xcrun simctl list devices

# Boot a specific simulator (optional, xcodebuild does this automatically)
xcrun simctl boot "iPhone 16"
```

#### Common Simulator Destinations

```bash
# iPhone simulators
-destination "platform=iOS Simulator,name=iPhone 16"
-destination "platform=iOS Simulator,name=iPhone 16 Pro"
-destination "platform=iOS Simulator,name=iPhone 16 Pro Max"
-destination "platform=iOS Simulator,name=iPhone SE (3rd generation)"

# iPad simulators
-destination "platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)"
-destination "platform=iOS Simulator,name=iPad Air (5th generation)"

# With specific OS version
-destination "platform=iOS Simulator,name=iPhone 16,OS=18.2"
```

#### CI Simulator Recommendations

For GitHub Actions, use stable simulators that are available on the runner:

```yaml
# Recommended: Use latest iPhone without specifying OS
-destination "platform=iOS Simulator,name=iPhone 16"

# Alternative: Specify OS for reproducibility
-destination "platform=iOS Simulator,name=iPhone 16,OS=18.2"
```

### GitHub Actions CI Configuration

#### Basic Test Workflow

```yaml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: macos-15

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.2.app

      - name: Run Tests
        run: |
          xcodebuild test \
            -scheme "YourApp" \
            -destination "platform=iOS Simulator,name=iPhone 16" \
            -configuration Debug \
            -resultBundlePath TestResults.xcresult \
            CODE_SIGNING_ALLOWED=NO

      - name: Upload Test Results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: TestResults.xcresult
```

#### Test Workflow with Coverage

```yaml
name: Tests with Coverage

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: macos-15

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.2.app

      - name: Run Tests with Coverage
        run: |
          xcodebuild test \
            -scheme "YourApp" \
            -destination "platform=iOS Simulator,name=iPhone 16" \
            -configuration Debug \
            -enableCodeCoverage YES \
            -resultBundlePath TestResults.xcresult \
            CODE_SIGNING_ALLOWED=NO

      - name: Generate Coverage Report
        run: |
          xcrun xccov view --report TestResults.xcresult

      - name: Upload Coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: TestResults.xcresult
```

### Code Coverage for iOS Apps

#### Viewing Coverage Locally

```bash
# Run tests with coverage
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults.xcresult

# View coverage summary
xcrun xccov view --report TestResults.xcresult

# View coverage for specific file
xcrun xccov view --file "YourApp/ViewModels/HomeViewModel.swift" TestResults.xcresult

# Export coverage as JSON
xcrun xccov view --report --json TestResults.xcresult > coverage.json
```

#### Coverage in Xcode

1. Run tests with ⌘U
2. Open Report Navigator (⌘9)
3. Select test run → Coverage tab
4. View per-file and per-function coverage

### Test Scheme Configuration

Ensure your test scheme is properly configured:

1. **Share the Scheme**: Product → Scheme → Manage Schemes → Check "Shared"
2. **Include Test Targets**: Edit Scheme → Test → Add test targets
3. **Enable Coverage**: Edit Scheme → Test → Options → Code Coverage → Gather coverage

### Troubleshooting iOS Tests

#### Tests Don't Run: "Scheme not found"

```bash
# Error: xcodebuild: error: Unable to find a scheme named "YourApp"

# Solution 1: List available schemes
xcodebuild -list

# Solution 2: Share the scheme in Xcode
# Product → Scheme → Manage Schemes → Check "Shared"

# Solution 3: Commit the shared scheme
git add YourApp.xcodeproj/xcshareddata/xcschemes/
git commit -m "chore: share test scheme"
```

#### Tests Fail: "No matching destination"

```bash
# Error: Unable to find a destination matching...

# Solution: List available destinations
xcodebuild -scheme "YourApp" -showdestinations

# Use an available destination from the list
```

#### Tests Hang: "Waiting for simulator"

```bash
# Solution 1: Reset simulators
xcrun simctl shutdown all
xcrun simctl erase all

# Solution 2: Boot simulator manually
xcrun simctl boot "iPhone 16"
```

#### CI Fails: "Code signing error"

```bash
# Error: Signing for "YourApp" requires a development team

# Solution: Add CODE_SIGNING_ALLOWED=NO
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  CODE_SIGNING_ALLOWED=NO  # Required for CI
```

### Best Practices for iOS Testing

✅ **DO**:
- Always use `CODE_SIGNING_ALLOWED=NO` in CI
- Save results to `.xcresult` bundle for debugging
- Upload test artifacts for failed runs
- Use specific Xcode version with `xcode-select`
- Share schemes and commit them to git

❌ **DON'T**:
- Run tests on physical devices in CI (use simulators)
- Specify exact OS versions without checking runner availability
- Skip code coverage in CI pipelines
- Forget to commit shared schemes

---

## ⚡️ Swift 6 Concurrency in Tests

### @MainActor Isolation for Tests

**Problem**: When testing `@MainActor` ViewModels or using mock factory methods that create domain entities with MainActor-isolated properties, you'll encounter concurrency errors.

**Error Example**:
```
Call to main actor-isolated initializer 'mock' in a synchronous nonisolated context
```

**Solution**: Add `@MainActor` to test structs when using mocks that access MainActor-isolated code.

```swift
import Testing
@testable import FavRes_iOS

@Suite("FilterRestaurantsUseCase Tests", .tags(.unit, .domain))
@MainActor  // ✅ Required when Restaurant.mock is @MainActor isolated
struct FilterRestaurantsUseCaseTests {

    @Test("Filters by single cuisine type")
    func filtersBySingleCuisineType() {
        // Given
        let sut = makeSUT()
        let restaurants = [
            Restaurant.mock(name: "Italian 1", cuisineType: .italian),
            Restaurant.mock(name: "Japanese 1", cuisineType: .japanese),
            Restaurant.mock(name: "Italian 2", cuisineType: .italian)
        ]

        // When
        let result = sut.execute(restaurants: restaurants, cuisineTypes: [.italian])

        // Then
        #expect(result.count == 2)
    }

    // MARK: - Helpers

    private func makeSUT() -> FilterRestaurantsUseCase {
        FilterRestaurantsUseCase()
    }
}
```

### Mock Extension Isolation

When mock factory methods use `@Observable` models or other MainActor-isolated types:

```swift
// ✅ Correct: Isolate mock extension to MainActor
@MainActor
extension Restaurant {
    static var mock: Restaurant {
        Restaurant(
            id: UUID(),
            name: "Test Restaurant",
            cuisineType: .italian,
            location: .mock,
            averageRating: 7.5,
            priceRange: .moderate,
            visits: [],
            status: .visited,
            isFavorite: false
        )
    }

    static func mock(
        name: String = "Test Restaurant",
        cuisineType: CuisineType = .italian,
        isFavorite: Bool = false
    ) -> Restaurant {
        // ...
    }
}
```

---

## 🏷️ Test Tag Centralization

### Problem: Ambiguous Tag Definitions

Multiple test files defining the same tags causes compilation errors:

```
Ambiguous use of 'unit'
```

### Solution: Single Tag Definition

Define all tags in **ONE** file (typically the first test file alphabetically or a dedicated file):

```swift
// FavRes-iOSTests/Helpers/TestTags.swift (or first alphabetical test file)
import Testing

extension Tag {
    @Tag static var unit: Self
    @Tag static var domain: Self
    @Tag static var integration: Self
    @Tag static var presentation: Self
}
```

Then **NEVER** define the same tags in other test files:

```swift
// ❌ WRONG - Duplicate tag definition
// SomeOtherTests.swift
extension Tag {
    @Tag static var unit: Self  // ❌ Already defined elsewhere!
}

// ✅ CORRECT - Just use the tags
// SomeOtherTests.swift
@Suite("Some Feature Tests", .tags(.unit, .domain))
struct SomeFeatureTests { }
```

---

## 🎭 Mock Factory Best Practices

### Avoid Default Values That Cause False Matches

**Problem**: Default mock values can cause unintended test matches.

```swift
// ❌ BAD: Default location includes "Madrid" in administrativeArea
extension Location {
    static var mock: Location {
        Location(
            city: "Madrid",
            administrativeArea: "Comunidad de Madrid",  // Contains "Madrid"
            country: "España"
        )
    }
}

@Test("Searches by city")
func searchesByCity() {
    let restaurants = [
        Restaurant.mock(name: "Place 1", location: .mock(city: "Madrid")),
        Restaurant.mock(name: "Place 2", location: .mock(city: "Barcelona")),
        Restaurant.mock(name: "Place 3", location: .mock(city: "Madrid"))
    ]

    // ❌ This might match 3 items because "Barcelona" location
    // still has administrativeArea: "Comunidad de Madrid" by default!
    let result = sut.execute(query: "Madrid", in: restaurants)
    #expect(result.count == 2)  // ❌ May fail
}
```

**Solution**: Use explicit, non-overlapping values in tests:

```swift
// ✅ GOOD: Explicit values that don't overlap
@Test("Searches by city")
func searchesByCity() {
    let restaurants = [
        Restaurant.mock(
            name: "Place 1",
            location: .mock(city: "Valencia", administrativeArea: "Valencia")
        ),
        Restaurant.mock(
            name: "Place 2",
            location: .mock(city: "Barcelona", administrativeArea: "Cataluña")
        ),
        Restaurant.mock(
            name: "Place 3",
            location: .mock(city: "Valencia", administrativeArea: "Valencia")
        )
    ]

    let result = sut.execute(query: "Valencia", in: restaurants)
    #expect(result.count == 2)  // ✅ Deterministic
}
```

### Mock Factory Guidelines

1. **Minimal defaults**: Only set required properties in `.mock`
2. **Explicit test values**: Override all relevant properties in tests
3. **No overlapping strings**: Avoid default values that could match search queries
4. **Unique identifiers**: Each mock should have a unique UUID

---

## 🚫 Common Mistakes

### Mistake 1: Testing Implementation Details

```swift
// ❌ Bad: Testing private implementation
@Test
func viewModelCallsPrivateMethod() {
    // Testing how ViewModel works internally
    #expect(viewModel.privateMethod() == true)
}

// ✅ Good: Testing behavior
@Test
func loadUserUpdatesState() {
    await viewModel.loadUser()
    #expect(viewModel.user != nil)
}
```

### Mistake 2: Shared State Between Tests

```swift
// ❌ Bad: Shared mock
class BadTests {
    let sharedMock = MockRepository()
    
    @Test
    func test1() {
        sharedMock.result = .success(.mock)
        // Test uses shared state
    }
    
    @Test
    func test2() {
        // This test is affected by test1!
    }
}

// ✅ Good: Fresh mock per test
struct GoodTests {
    @Test
    func test1() {
        let mock = MockRepository()
        mock.result = .success(.mock)
        // Test uses isolated state
    }
    
    @Test
    func test2() {
        let mock = MockRepository()
        // Fresh, independent mock
    }
}
```

### Mistake 3: Testing Multiple Things at Once

```swift
// ❌ Bad: Multiple assertions for different scenarios
@Test
func loadUserHandlesAllCases() {
    // Tests success, error, loading all in one test
}

// ✅ Good: One test per scenario
@Test
func loadUserWithSuccessUpdatesUser() { }

@Test
func loadUserWithErrorShowsError() { }

@Test
func loadUserSetsLoadingState() { }
```

---

## 📚 Further Reading

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [Unit Testing Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing)

---

**Remember**: Tests are an **investment**, not a cost. They pay dividends in confidence, speed, and quality. Write tests you can trust. 🧪
