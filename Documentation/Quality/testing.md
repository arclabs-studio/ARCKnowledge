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
