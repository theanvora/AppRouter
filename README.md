# AppRouter

A lightweight, type-safe navigation coordinator for SwiftUI, built on `NavigationStack` and `NavigationPath`.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-26%2B-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

- **`Router<Route>`** — an `ObservableObject` driving stack, sheet, and full-screen-cover.
- `push` / `pop` / `popToRoot` and `present(sheet:)` / `present(cover:)` / `dismiss`.
- Generic over your own `Route` enum — fully type-checked.

## Installation

```swift
.package(url: "https://github.com/theanvora/AppRouter.git", from: "1.0.0")
```

## Usage

```swift
import AppRouter

enum AppRoute: Route {
    case detail(id: String)
    case settings
}

@State private var router = Router<AppRoute>()

@Bindable var router = router
NavigationStack(path: $router.path) {
    HomeView()
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .detail(let id): DetailView(id: id)
            case .settings:       SettingsView()
            }
        }
}
.environment(router)

// Elsewhere
router.push(.detail(id: "42"))
```

## Requirements

- iOS 26.0+ · Swift 5.9+ (uses the Observation framework)

## License

MIT
