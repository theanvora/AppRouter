import Foundation

/// Type-erased `DeepLinkParser`, so parsers of the same `Route` can be stored
/// together.
public struct AnyDeepLinkParser<R: Route>: DeepLinkParser {
    private let _parse: (URL) -> DeepLinkDestination<R>?

    public init<P: DeepLinkParser>(_ parser: P) where P.R == R {
        _parse = parser.parse
    }

    public func parse(_ url: URL) -> DeepLinkDestination<R>? {
        _parse(url)
    }
}

/// Tries a list of parsers in order and returns the first match — a registry for
/// an app that handles several link shapes (universal links, custom schemes…).
public struct DeepLinkResolver<R: Route>: Sendable {
    private let parsers: [AnyDeepLinkParser<R>]

    public init(_ parsers: [AnyDeepLinkParser<R>]) {
        self.parsers = parsers
    }

    public func resolve(_ url: URL) -> DeepLinkDestination<R>? {
        for parser in parsers {
            if let destination = parser.parse(url) { return destination }
        }
        return nil
    }
}

public extension Router {
    /// Resolve a URL through a `DeepLinkResolver` and navigate. Returns `true` if handled.
    @discardableResult
    func open(_ url: URL, with resolver: DeepLinkResolver<R>) -> Bool {
        guard let destination = resolver.resolve(url) else { return false }
        handle(destination)
        return true
    }
}
