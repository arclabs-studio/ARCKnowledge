---
name: arc-presentation-layer
description: |
  ARC Labs Studio Presentation layer patterns. Covers SwiftUI Views structure,
  @Observable ViewModels with @MainActor, state management with LoadingState enum,
  ARCNavigation Router pattern for navigation, data flow between View-ViewModel-UseCase,
  accessibility, dark mode, SwiftUI previews, and MVVM+C pattern implementation.
  Use when creating Views, implementing ViewModels, setting up navigation with Router,
  managing UI state, handling user actions, or structuring Presentation layer code.
---

# ARC Labs Studio - Presentation Layer Patterns

## When to Use This Skill

Use this skill when:
- **Creating SwiftUI Views** with proper structure
- **Implementing ViewModels** with @Observable
- **Setting up navigation** with ARCNavigation Router
- **Managing UI state** (loading, error, success)
- **Handling user actions** in ViewModels
- **Structuring feature folders** (View, ViewModel, Router)
- **Implementing MVVM+C pattern**
- **Adding SwiftUI previews** for testing

## Quick Reference

### Presentation Layer Structure

```
Presentation/
├── Features/
│   └── UserProfile/
│       ├── View/
│       │   ├── UserProfileView.swift
│       │   └── ProfileHeaderView.swift
│       └── ViewModel/
│           └── UserProfileViewModel.swift
└── Shared/
    └── Components/
        └── LoadingView.swift
```

### View Structure

```swift
import SwiftUI

struct UserProfileView: View {

    // MARK: Private Properties

    @State private var viewModel: UserProfileViewModel

    // MARK: Initialization

    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
    }

    // MARK: View

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                profileDetails
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Profile")
        .task {
            await viewModel.onAppear()
        }
    }
}

// MARK: - Private Views

private extension UserProfileView {
    var profileHeader: some View {
        VStack {
            AsyncImage(url: viewModel.user?.avatarURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())

            Text(viewModel.user?.name ?? "Unknown")
                .font(.title)
        }
    }

    var profileDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            DetailRow(title: "Email", value: viewModel.user?.email ?? "N/A")
        }
    }

    var actionButtons: some View {
        Button("Edit Profile") {
            viewModel.onTappedEditProfile()
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Previews

#Preview("Loaded") {
    let mockViewModel = UserProfileViewModel.mock
    mockViewModel.user = .mock
    return UserProfileView(viewModel: mockViewModel)
}

#Preview("Loading") {
    let mockViewModel = UserProfileViewModel.mock
    mockViewModel.isLoading = true
    return UserProfileView(viewModel: mockViewModel)
}
```

### ViewModel Structure

```swift
import ARCLogger
import ARCNavigation
import Foundation

@MainActor
@Observable
final class UserProfileViewModel {

    // MARK: Private Properties

    private(set) var user: User?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let router: Router<AppRoute>

    // MARK: Public Properties

    var memberSinceText: String {
        guard let user = user else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: user.createdAt)
    }

    // MARK: Initialization

    init(
        getUserProfileUseCase: GetUserProfileUseCaseProtocol,
        router: Router<AppRoute>
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.router = router
    }

    // MARK: Lifecycle

    func onAppear() async {
        await loadProfile()
    }

    // MARK: Public Functions

    func onTappedEditProfile() {
        guard let user = user else { return }
        router.navigate(to: .editProfile(user))
    }

    func onTappedRetry() async {
        await loadProfile()
    }
}

// MARK: - Private Functions

private extension UserProfileViewModel {
    func loadProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            user = try await getUserProfileUseCase.execute()
            ARCLogger.shared.debug("Profile loaded successfully")
        } catch {
            errorMessage = "Failed to load profile"
            ARCLogger.shared.error("Profile load failed", metadata: [
                "error": error.localizedDescription
            ])
        }

        isLoading = false
    }
}

// MARK: - Mock

#if DEBUG
extension UserProfileViewModel {
    static var mock: UserProfileViewModel {
        UserProfileViewModel(
            getUserProfileUseCase: MockGetUserProfileUseCase(),
            router: Router()
        )
    }
}
#endif
```

### Loading State Enum

```swift
enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

@MainActor
@Observable
final class ContentViewModel {
    private(set) var state: LoadingState<[Item]> = .idle

    var items: [Item] {
        if case .loaded(let items) = state { return items }
        return []
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
}
```

### Route Definition (ARCNavigation)

```swift
import ARCNavigation
import SwiftUI

enum AppRoute: Route {
    case home
    case profile(userID: String)
    case settings
    case editProfile(User)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView(viewModel: HomeViewModel.create())
        case .profile(let userID):
            ProfileView(viewModel: ProfileViewModel.create(userID: userID))
        case .settings:
            SettingsView(viewModel: SettingsViewModel.create())
        case .editProfile(let user):
            EditProfileView(viewModel: EditProfileViewModel.create(user: user))
        }
    }
}
```

### Navigation in ViewModel

```swift
@MainActor
@Observable
final class HomeViewModel {
    private let router: Router<AppRoute>

    func onTappedProfile() {
        router.navigate(to: .profile(userID: currentUserId))
    }

    func onTappedSettings() {
        router.navigate(to: .settings)
    }

    func onTappedBack() {
        router.pop()
    }

    func onTappedHome() {
        router.popToRoot()
    }
}
```

### Data Flow

```
View → ViewModel → Use Case → Repository
  │         │           │          │
  │ User    │ Calls     │ Business │ Data
  │ Action  │ execute() │ Logic    │ Access
  ↓         ↓           ↓          ↓
Button  onTapped()  UseCase.execute()  fetch()
```

### View Naming Conventions

- **Views**: `*View.swift` → `UserProfileView`, `HomeView`
- **ViewModels**: `*ViewModel.swift` → `UserProfileViewModel`
- **User actions**: `onTapped*`, `onChanged*`, `onAppear`
- **Private methods**: `load*`, `format*`, `validate*`

## View Best Practices

```swift
// ✅ Handle all states
var body: some View {
    Group {
        switch viewModel.state {
        case .idle: Text("Ready")
        case .loading: ProgressView("Loading...")
        case .loaded(let data): dataView(data)
        case .error(let message): ErrorView(message: message)
        }
    }
}

// ✅ Extract subviews
var profileHeader: some View { /* ... */ }

// ✅ Use Button for interactions (accessibility)
Button("Add") { viewModel.onTappedAdd() }

// ❌ Don't use onTapGesture for buttons
Image(systemName: "plus").onTapGesture { }  // BAD
```

## ViewModel Best Practices

```swift
// ✅ private(set) for mutable state
private(set) var isLoading = false

// ✅ Prefix user actions with "on"
func onTappedButton() { }
func onChangedText(_ text: String) { }

// ✅ Call Use Cases, not Repositories
let user = try await getUserUseCase.execute()

// ❌ Don't reference Views
var destinationView: ProfileView?  // NEVER

// ❌ Don't contain business logic
if rating > 4.0 && price < 50 { }  // Move to Use Case
```

## Detailed Documentation

For complete patterns:
- **@presentation.md** - Complete Presentation layer guide

## Need More Help?

For related topics:
- Architecture patterns → Use `/arc-swift-architecture`
- Testing ViewModels → Use `/arc-tdd-patterns`
- UI guidelines → Use `/arc-quality-standards`
- Navigation → Use `/arc-swift-architecture`
