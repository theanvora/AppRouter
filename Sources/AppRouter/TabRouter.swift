//
//  TabRouter.swift
//  AppRouter
//
//  Created by Anvora on 02/07/2026.
//

import SwiftUI
import Observation

/// Coordinates a `TabView`'s selection, exposing the "tap the active tab to pop
/// to root" behaviour apps expect. Generic over your `Tab` enum.
///
/// ```swift
/// @State private var tabs = TabRouter(initial: AppTab.home)
///
/// TabView(selection: tabs.binding) { … }
/// // tabs.onReselect = { tab in routers[tab]?.popToRoot() }
/// ```
@MainActor
@Observable
public final class TabRouter<Tab: Hashable> {
    public private(set) var selection: Tab

    /// Invoked when the already-selected tab is chosen again.
    @ObservationIgnored public var onReselect: ((Tab) -> Void)?

    public init(initial: Tab) {
        self.selection = initial
    }

    public func select(_ tab: Tab) {
        if tab == selection {
            onReselect?(tab)
        } else {
            selection = tab
        }
    }

    /// A `Binding` to drive `TabView(selection:)` while keeping reselect handling.
    public var binding: Binding<Tab> {
        Binding(get: { self.selection }, set: { self.select($0) })
    }
}
