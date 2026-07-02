//
//  RoutingExtrasTests.swift
//  AppRouter
//
//  Created by Anvora on 02/07/2026.
//

import XCTest
import Foundation
@testable import AppRouter

private enum Tab: Hashable { case home, search, profile }

private struct PathParser: DeepLinkParser {
    func parse(_ url: URL) -> DeepLinkDestination<TestRoute>? {
        url.path == "/a" ? .push(.a) : nil
    }
}

@MainActor
final class RoutingExtrasTests: XCTestCase {
    func testTabReselectFires() {
        let tabs = TabRouter(initial: Tab.home)
        var reselected: Tab?
        tabs.onReselect = { reselected = $0 }

        tabs.select(.search)
        XCTAssertEqual(tabs.selection, .search)
        XCTAssertNil(reselected)

        tabs.select(.search)
        XCTAssertEqual(reselected, .search)
    }

    func testDeepLinkResolverPicksFirstMatch() {
        let resolver = DeepLinkResolver<TestRoute>([AnyDeepLinkParser(PathParser())])
        let matched = resolver.resolve(URL(string: "myapp://x/a")!)
        let missed = resolver.resolve(URL(string: "myapp://x/b")!)

        if case .push(.a)? = matched {} else { XCTFail("expected push(.a)") }
        XCTAssertNil(missed)
    }
}
