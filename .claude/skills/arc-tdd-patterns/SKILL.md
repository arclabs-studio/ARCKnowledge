---
name: arc-tdd-patterns
description: |
  Test-Driven Development patterns for ARC Labs Studio using Swift Testing
  framework. Covers TDD methodology (Red-Green-Refactor), test structure with
  Swift Testing macros (@Test, @Suite, #expect), mocking patterns, parameterized
  tests, async testing, test organization, coverage requirements (100% for packages,
  80%+ for apps), and xcodebuild testing for iOS apps.

  **INVOKE THIS SKILL** when:
  - Writing new tests for features or components
  - Setting up test infrastructure for a project
  - Following TDD workflow (Red-Green-Refactor)
  - Creating mocks and test doubles
  - Checking or improving test coverage
  - Configuring CI pipelines for test automation
---

# ARC Labs Studio - TDD Patterns & Swift Testing

## When to Use This Skill

Use this skill when:
- **Writing new tests** for features or components
- **Setting up test infrastructure** for a project or module
- **Following TDD workflow** (Red → Green → Refactor)
- **Creating mocks and test doubles** for dependencies
- **Organizing tests** properly in the test suite
- **Checking test coverage** and meeting requirements
- **Reviewing test quality** and test code
- **Debugging failing tests** and understanding errors
- **Learning Swift Testing** framework syntax and patterns
- **Configuring xcodebuild** for iOS app testing
- **Setting up GitHub Actions** for CI test automation

## Quick Reference

### TDD Cycle

```
1. 🔴 RED: Write a failing test
   └─ Test describes desired behavior

2. 🟢 GREEN: Make test pass with minimal code
   └─ Focus on making it work, not perfect

3. 🔵 REFACTOR: Improve code quality
   └─ Clean up while tests keep passing
```

### Coverage Requirements

| Project Type | Minimum Coverage | Target |
|--------------|-----------------|--------|
| **Swift Packages** | 80% | 100% |
| **iOS Apps** | 60% | 80% |

### Swift Testing Basics

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

### Test Structure - AAA Pattern

```swift
@Test func exampleTest() async throws {
    // ARRANGE - Set up test data and dependencies
    let mockDependency = MockDependency()
    let sut = SystemUnderTest(dependency: mockDependency)

    // ACT - Execute the code being tested
    let result = try await sut.performAction()

    // ASSERT - Verify the results
    #expect(result.isSuccess)
    #expect(mockDependency.methodWasCalled)
}
```

### Mocking Pattern

```swift
// Protocol in Domain layer
protocol UserRepository: Sendable {
    func fetchUsers() async throws -> [User]
}

// Mock implementation for testing
final class MockUserRepository: UserRepository {
    var fetchUsersCalled = false
    var fetchUsersCallCount = 0
    var usersToReturn: [User] = []
    var errorToThrow: Error?

    func fetchUsers() async throws -> [User] {
        fetchUsersCalled = true
        fetchUsersCallCount += 1

        if let error = errorToThrow {
            throw error
        }

        return usersToReturn
    }

    func reset() {
        fetchUsersCalled = false
        fetchUsersCallCount = 0
        usersToReturn = []
        errorToThrow = nil
    }
}
```

### Testing Async Code

```swift
@Test func asyncOperation() async throws {
    let sut = AsyncService()
    let result = try await sut.performAsyncOperation()
    #expect(result.isSuccess)
}
```

### Testing Throws

```swift
@Test func operationThrowsError() async throws {
    let sut = Service()
    await #expect(throws: DomainError.invalidInput) {
        try await sut.failingOperation()
    }
}
```

### Parameterized Tests

```swift
@Test("Valid emails pass validation", arguments: [
    "test@example.com",
    "user.name@example.co.uk",
    "first+last@example.org"
])
func validEmailsPassValidation(email: String) {
    let validator = EmailValidator()
    let result = validator.validate(email)
    #expect(result.isValid == true)
}
```

### Testing ViewModels

ViewModels MUST have unit tests covering state transitions and user action delegation.
Use `@MainActor` on the test suite only if the ViewModel methods under test require it.

```swift
@Suite("User Profile ViewModel Tests")
struct UserProfileViewModelTests {

    @Test("Initial state is correct")
    func initialStateIsCorrect() {
        let mockUseCase = MockGetUserProfileUseCase()
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)

        #expect(viewModel.user == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Load user with success updates user")
    @MainActor
    func loadUser_withSuccessUpdatesUser() async {
        let mockUseCase = MockGetUserProfileUseCase()
        mockUseCase.executeResult = .success(.mock)
        let viewModel = UserProfileViewModel(getUserUseCase: mockUseCase)

        await viewModel.loadUser()

        #expect(viewModel.user != nil)
        #expect(viewModel.isLoading == false)
    }
}
```

### Testing Use Cases (Mandatory)

Every UseCase MUST have unit tests covering business rules, validation, and error paths:

```swift
@Suite("Get Restaurants UseCase Tests")
struct GetRestaurantsUseCaseTests {

    @Test("Returns only valid restaurants sorted by rating")
    func returnsOnlyValidRestaurantsSortedByRating() async throws {
        // Given
        let repository = MockRestaurantRepository()
        repository.restaurantsToReturn = [
            .mock(name: "Low", rating: 2.0),
            .mock(name: "High", rating: 4.5),
            .mock(name: "Invalid", rating: -1.0)  // Invalid
        ]
        let sut = GetRestaurantsUseCase(repository: repository)

        // When
        let result = try await sut.execute()

        // Then
        #expect(result.count == 2)
        #expect(result.first?.name == "High")  // Sorted by rating
    }

    @Test("Throws error when repository fails")
    func throwsErrorWhenRepositoryFails() async {
        let repository = MockRestaurantRepository()
        repository.errorToThrow = RepositoryError.networkError
        let sut = GetRestaurantsUseCase(repository: repository)

        await #expect(throws: RepositoryError.networkError) {
            try await sut.execute()
        }
    }
}
```

### Mock Data Factories

```swift
#if DEBUG
extension User {
    static var mock: User {
        User(
            id: UUID(uuidString: "12345678-1234-1234-1234-123456789012")!,
            email: "test@example.com",
            name: "Test User",
            avatarURL: nil,
            createdAt: Date(timeIntervalSince1970: 1700000000)
        )
    }

    static func mock(
        id: UUID = UUID(),
        email: String = "test@example.com",
        name: String = "Test User"
    ) -> User {
        User(id: id, email: email, name: name, avatarURL: nil, createdAt: Date())
    }
}
#endif
```

## Test Organization

```
Tests/
└── YourModuleTests/
    ├── Domain/
    │   ├── UseCases/
    │   │   └── GetUsersUseCaseTests.swift
    │   └── Entities/
    │       └── UserTests.swift
    ├── Data/
    │   └── Repositories/
    │       └── UserRepositoryTests.swift
    ├── Presentation/
    │   └── ViewModels/
    │       └── UserListViewModelTests.swift
    └── Mocks/
        ├── MockUserRepository.swift
        └── MockRouter.swift
```

## xcodebuild Testing (iOS Apps)

### Running Tests Locally

```bash
# Basic test
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16"

# With coverage
xcodebuild test \
  -scheme "YourApp" \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults.xcresult \
  CODE_SIGNING_ALLOWED=NO

# View coverage
xcrun xccov view --report TestResults.xcresult
```

### GitHub Actions CI

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
            -enableCodeCoverage YES \
            -resultBundlePath TestResults.xcresult \
            CODE_SIGNING_ALLOWED=NO

      - name: Upload Results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: TestResults.xcresult
```

### Swift Package Testing

```bash
# Run tests
swift test

# With coverage
swift test --enable-code-coverage

# View coverage
xcrun llvm-cov report \
  .build/debug/YourPackagePackageTests.xctest/Contents/MacOS/YourPackagePackageTests \
  -instr-profile=.build/debug/codecov/default.profdata
```

## Test Assertions Reference

```swift
// Value equality
#expect(viewModel.user == expectedUser)

// Boolean checks
#expect(viewModel.isLoading == false)
#expect(viewModel.isValid)

// Optional checks
#expect(viewModel.user != nil)
#expect(viewModel.errorMessage == nil)

// Collection checks
#expect(viewModel.users.isEmpty == false)
#expect(viewModel.users.count == 5)
#expect(viewModel.users.contains(expectedUser))

// Error throwing
await #expect(throws: DomainError.invalidInput) {
    try await useCase.execute(invalidId)
}

// Any error
await #expect(throws: (any Error).self) {
    try await repository.getUser(by: invalidId)
}
```

## Detailed Documentation

For complete testing guides and examples:
- **@testing.md** - Complete TDD methodology and Swift Testing guide

## Anti-Patterns to Avoid

- ❌ Testing implementation details instead of behavior
- ❌ Tests depending on execution order
- ❌ Sharing state between tests
- ❌ Testing multiple things in one test
- ❌ Not following AAA pattern
- ❌ Mocking everything (test real objects when possible)
- ❌ Ignoring failing tests
- ❌ Using real network/database in unit tests
- ❌ Skipping `CODE_SIGNING_ALLOWED=NO` in CI

## Common Test Errors & Solutions

### "Scheme not found"
```bash
# List available schemes
xcodebuild -list
# Share scheme: Product → Scheme → Manage Schemes → Check "Shared"
```

### "No matching destination"
```bash
# List available destinations
xcodebuild -scheme "YourApp" -showdestinations
```

### "Code signing error" in CI
```bash
# Add CODE_SIGNING_ALLOWED=NO to xcodebuild command
```

## Related Skills

When working on testing, you may also need:

| If you need...              | Use                       |
|-----------------------------|---------------------------|
| Architecture patterns       | `/arc-swift-architecture` |
| Code quality standards      | `/arc-quality-standards`  |
| Data layer implementation   | `/arc-data-layer`         |
| Git workflow                | `/arc-workflow`           |
