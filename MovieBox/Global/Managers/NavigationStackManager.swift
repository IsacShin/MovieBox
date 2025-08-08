//
//  NavigationManager.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import SwiftUI

private struct NavigationManagerKey: EnvironmentKey {
    // 기본값은 옵셔널로 nil
    static let defaultValue: NavigationStackManager? = nil
}

extension EnvironmentValues {
    var navigationManager: NavigationStackManager? {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}

enum Route: Hashable {
    case movieDetail
}

@MainActor
public final class NavigationStackManager: ObservableObject {
    public static let shared = NavigationStackManager() // 싱글톤 인스턴스
    
    @Published var path = NavigationPath()
    
    private init() {}
    
    public func push<T: Hashable>(_ value: T) {
        path.append(value)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
}
