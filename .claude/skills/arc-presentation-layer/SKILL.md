---
name: arc-presentation-layer
description: |
  Presentation layer patterns with SwiftUI Views, @Observable ViewModels
  (NO business logic, @MainActor per-method only), LoadingState enum, and
  ARCNavigation Router. Use when "creating SwiftUI views", "implementing
  ViewModels", "setting up navigation", "managing UI state", "handling user
  actions", "using @Previewable", or "implementing Liquid Glass effects".
user-invocable: true
metadata:
  author: ARC Labs Studio
  version: "3.0.0"
---

# ARC Labs Studio - Presentation Layer Patterns

## Instructions

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

ViewModels coordinate UI state only. They delegate ALL business logic to Use Cases.
Use `@MainActor` only on specific methods that update UI-bound state, not on the entire class.

```swift
import ARCLogger
import ARCNavigation
import Foundation

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

    init(getUserProfileUseCase: GetUserProfileUseCaseProtocol,
         router: Router<AppRoute>) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.router = router
    }

    // MARK: Lifecycle

    @MainActor
    func onAppear() async {
        await loadProfile()
    }

    // MARK: Public Functions

    func onTappedEditProfile() {
        guard let user = user else { return }
        router.navigate(to: .editProfile(user))
    }

    @MainActor
    func onTappedRetry() async {
        await loadProfile()
    }
}

// MARK: - Private Functions

private extension UserProfileViewModel {
    @MainActor
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
        UserProfileViewModel(getUserProfileUseCase: MockGetUserProfileUseCase(),
                             router: Router())
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
View -> ViewModel -> Use Case -> Repository
  |         |           |          |
  | User    | Calls     | Business | Data
  | Action  | execute() | Logic    | Access
  v         v           v          v
Button  onTapped()  UseCase.execute()  fetch()
```

### View Naming Conventions

- **Views**: `*View.swift` -> `UserProfileView`, `HomeView`
- **ViewModels**: `*ViewModel.swift` -> `UserProfileViewModel`
- **User actions**: `onTapped*`, `onChanged*`, `onAppear`
- **Private methods**: `load*`, `format*`, `validate*`

## View Best Practices

```swift
// Handle all states
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

// Extract subviews
var profileHeader: some View { /* ... */ }

// Use Button for interactions (accessibility)
Button("Add") { viewModel.onTappedAdd() }

// Don't use onTapGesture for buttons
// Image(systemName: "plus").onTapGesture { }  // BAD
```

## ViewModel Best Practices

```swift
// private(set) for mutable state
private(set) var isLoading = false

// Prefix user actions with "on"
func onTappedButton() { }
func onChangedText(_ text: String) { }

// Call Use Cases, not Repositories
let user = try await getUserUseCase.execute()

// Don't reference Views
// var destinationView: ProfileView?  // NEVER

// Don't contain business logic
// if rating > 4.0 && price < 50 { }  // Move to Use Case
```

## iOS 26+ Patterns (Liquid Glass)

### Liquid Glass Materials (iOS 26+)

```swift
import SwiftUI

struct ProfileCardView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            Text("John Doe")
                .font(.headline)
        }
        .padding()
        .glassEffect()  // iOS 26+ Liquid Glass effect
    }
}

// Backward compatible version
struct ProfileCardView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            Text("John Doe")
                .font(.headline)
        }
        .padding()
        .background {
            if #available(iOS 26, *) {
                Color.clear.glassEffect()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            }
        }
    }
}
```

## SwiftUI Previews

### @Previewable Macro (iOS 18+)

```swift
// Modern approach with @Previewable
#Preview {
    @Previewable @State var isEnabled = true
    Toggle("Enable Feature", isOn: $isEnabled)
}

// Preview with ViewModel
#Preview("Profile Loaded") {
    @Previewable @State var viewModel = UserProfileViewModel.mock
    UserProfileView(viewModel: viewModel)
}

// Multiple preview states
#Preview("Dark Mode") {
    UserProfileView(viewModel: .mock)
        .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    UserProfileView(viewModel: .mock)
        .dynamicTypeSize(.xxxLarge)
}
```

## References

For complete patterns:
- **@references/presentation.md** - Complete Presentation layer guide

## Examples

### Creating a new feature screen
User says: "Create a restaurant detail screen"

1. Create `RestaurantDetailView` with proper MARK sections
2. Create `RestaurantDetailViewModel` with `@Observable`, `@MainActor` per-method
3. Define route case in `AppRoute`
4. Extract private subviews into `private extension`
5. Add previews for loaded, loading, and error states
6. Result: Complete feature with View, ViewModel, route, and previews

### Setting up navigation for a tab-based app
User says: "Set up tab navigation with ARCNavigation"

1. Define `AppRoute` enum conforming to `Route`
2. Create `Router<AppRoute>` in app entry point
3. Add `@Environment(Router<AppRoute>.self)` to views needing navigation
4. Implement `onTapped*` methods in ViewModels for navigation actions
5. Result: Type-safe navigation with router pattern

## Related Skills

| If you need...                    | Use                                     |
|-----------------------------------|-----------------------------------------|
| Architecture patterns             | `/arc-swift-architecture`               |
| Testing ViewModels                | `/arc-tdd-patterns`                     |
| UI/Accessibility guidelines       | `/arc-quality-standards`                |
| Data layer implementation         | `/arc-data-layer`                       |
| Advanced iOS 26 Liquid Glass      | `axiom-liquid-glass`, `axiom-swiftui-26-ref` |
| SwiftUI general patterns          | `swiftui-expert-skill`                  |
| Swift Concurrency in ViewModels   | `swift-concurrency`                     |
