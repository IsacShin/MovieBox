//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by shinisac on 8/7/25.
//

import SwiftUI

@main
struct MovieBoxApp: App {
    @StateObject private var navigationManager = NavigationStackManager.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                HomeView()
                    .environment(\.navigationManager, navigationManager)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .movieDetail:
                            EmptyView()
                        }
                    }
            }
        }
    }
}
