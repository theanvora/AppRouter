//
//  DeepLink.swift
//  AppRouter
//
//  Created by Anvora on 02/07/2026.
//

import SwiftUI

/// Maps an incoming `URL` to a navigation action. Implement one per app to
/// translate universal links / custom schemes into `Route`s.
public protocol DeepLinkParser: Sendable {
    associatedtype R: Route
    /// Return the resolved navigation, or `nil` if the URL isn't recognized.
    func parse(_ url: URL) -> DeepLinkDestination<R>?
}

/// How a parsed deep link should be presented.
public enum DeepLinkDestination<R: Route> {
    case push(R)
    case sheet(R)
    case cover(R)
    /// Replace the whole stack with this path (e.g. tab + detail).
    case stack([R])
}

public extension Router {
    /// Applies a parsed deep link to this router.
    func handle(_ destination: DeepLinkDestination<R>) {
        switch destination {
        case .push(let route):
            push(route)
        case .sheet(let route):
            present(sheet: route)
        case .cover(let route):
            present(cover: route)
        case .stack(let routes):
            popToRoot()
            routes.forEach { push($0) }
        }
    }

    /// Convenience: parse a URL and navigate in one call. Returns `true` if handled.
    @discardableResult
    func open<P: DeepLinkParser>(_ url: URL, using parser: P) -> Bool where P.R == R {
        guard let destination = parser.parse(url) else { return false }
        handle(destination)
        return true
    }
}
