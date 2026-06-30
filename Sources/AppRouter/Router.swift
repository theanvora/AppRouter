import SwiftUI

/// A route is any value you push onto the navigation stack.
public protocol Route: Hashable {}

/// Observable navigation coordinator wrapping a `NavigationPath`, plus sheet and
/// full-screen-cover presentation, generic over your app's `Route` type.
///
/// ```swift
/// enum AppRoute: Route { case detail(id: String), settings }
///
/// @StateObject private var router = Router<AppRoute>()
///
/// NavigationStack(path: $router.path) {
///     HomeView()
///         .navigationDestination(for: AppRoute.self) { route in ... }
/// }
/// .environmentObject(router)
/// ```
@MainActor
public final class Router<R: Route>: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var sheet: R?
    @Published public var cover: R?

    public init() {}

    // MARK: Stack

    public func push(_ route: R) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path = NavigationPath()
    }

    // MARK: Presentation

    public func present(sheet route: R) {
        sheet = route
    }

    public func present(cover route: R) {
        cover = route
    }

    public func dismiss() {
        sheet = nil
        cover = nil
    }
}
