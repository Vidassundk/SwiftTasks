//  View+When.swift
//  ToDo
//
//  Tiny helper that lets us attach view modifiers conditionally
//  without cluttering call‑sites with `if` statements.
//
//  Usage:
//      Text("Hello")
//          .when(isEnabled) { $0.bold() }
//
//  Created by ChatGPT on 2025-05-12.
//

import SwiftUI

extension View {

    /// Applies `transform` to `self` **only** when `condition` is `true`.
    ///
    /// SwiftUI’s `ViewBuilder` lets us return *either* the transformed view
    /// or the original view while preserving type‑erasure, so call‑sites
    /// can remain chainable.
    ///
    /// - Parameters:
    ///   - condition:  Boolean that decides whether to apply the transform.
    ///   - transform:  A closure receiving `Self` and returning *any* `View`.
    @ViewBuilder
    func when<T: View>(
        _ condition: Bool,
        transform: (Self) -> T
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
