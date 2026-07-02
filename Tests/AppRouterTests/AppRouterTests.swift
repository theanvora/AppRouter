//
//  AppRouterTests.swift
//  AppRouter
//
//  Created by Anvora on 02/07/2026.
//

import XCTest
import SwiftUI
@testable import AppRouter

enum TestRoute: Route { case a, b }

@MainActor
final class AppRouterTests: XCTestCase {
    func testPushPop() {
        let router = Router<TestRoute>()
        XCTAssertTrue(router.path.isEmpty)
        router.push(.a)
        router.push(.b)
        XCTAssertEqual(router.path.count, 2)
        router.pop()
        XCTAssertEqual(router.path.count, 1)
        router.popToRoot()
        XCTAssertTrue(router.path.isEmpty)
    }

    func testPresentation() {
        let router = Router<TestRoute>()
        router.present(sheet: .a)
        XCTAssertEqual(router.sheet, .a)
        router.dismiss()
        XCTAssertNil(router.sheet)
    }
}
