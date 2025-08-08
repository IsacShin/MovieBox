//
//  View+Extension.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import SwiftUI

extension View {
    func skeleton(isActive: Binding<Bool>) -> some View {
        self.modifier(SkeletonModifier(isActive: isActive))
    }
}
